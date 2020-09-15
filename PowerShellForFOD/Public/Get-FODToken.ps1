function Get-FODToken
{
    <#
    .SYNOPSIS
        Gets a new FOD authentication token.
    .DESCRIPTION
        Connects to FOD using User or Client Credentials and prints the resultant authentication token and/or saves
        it in the PowerShell for FOD module configuration.
    .PARAMETER ApiUri
        FOD API Uri to use, e.g. https://api.ams.fortify.com.
    .PARAMETER GrantType
        The method of authentication: UsernamePassword (Resource Owner Password Credentials) or ClientCredentials.
        Defaults to 'UsernamePassword'.
    .PARAMETER Scope
        The API scope to use, required if UsernamePassword Credentials is used.
        Defaults to 'api-tenant'.
    .PARAMETER Credential
        The Credential object to be used, if empty you will be prompted for User and Password.
        If 'UsernamePassword' credentials are used enter your "tenant\username" details at the User prompt and
        your "password" at the Password prompt.
        If ClientCredentials are used enter your API Key and API Secret.
    .PARAMETER Print
        Prints the value of the authentication token to the output.
    .PARAMETER ForceCredential
        If specified and a Credential object has already been stored, this will ignore it and force the
        prompt for a new Credential object.
    .PARAMETER Proxy
        Proxy server to use.
        Optional.
    .PARAMETER ForceVerbose
        If specified, don't explicitly remove verbose output from Invoke-RestMethod
        *** WARNING ***
        This will expose your data in verbose output
    .EXAMPLE
        # Retrieve an authentication token using Client Credentials from https://api.emea.fortify.com
        Get-FODToken -GrantType ClientCredentials -ApiUrl https://api.emea.fortify.com
    .FUNCTIONALITY
        Fortify on Demand.
    #>
    [OutputType([String])]
    [cmdletbinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (-not$_ -and -not$Script:PS4FOD.ApiUri) {
                throw 'Please supply a FOD Api Uri with Set-FODConfig.'
            } else {
                $true
            }
         })]
        [string]$ApiUri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('UsernamePassword', 'ClientCredentials')]
        [ValidateScript({
            if (-not$_ -and -not$Script:PS4FOD.GrantType) {
                throw 'Please supply a FOD GrantType with Set-FODConfig.'
            } else {
                $true
            }
        })]
        [string]$GrantType = $Script:PS4FOD.GrantType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('api-tenant', 'start-scans', 'manage-apps', 'view-apps', 'manage-issues', 'view-issues',
            'manage-reports', 'view-reports', 'manage-users', 'view-users', 'manage-notifications',
            'view-tenant-data')]
        [ValidateScript({
            if (-not$_ -and -not$Script:PS4FOD.Scope) {
                throw 'Please supply a FOD Scope with Set-FODConfig.'
            } else {
                $true
            }
        })]
        [string]$Scope = $Script:PS4FOD.Scope,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (-not$_ -and -not$Script:PS4FOD.Credential) {
                throw 'Please supply a Credential with Set-FODConfig.'
            } else {
                $true
            }
        })]
        $Credential = $Script:PS4FOD.Credential,

        [switch]$Print = $False,

        [switch]$ForceCredential = $False,

        [string]$Proxy = $Script:PS4FOD.Proxy,
        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose
    )

    # Check parameters have values
    if ([string]::IsNullOrEmpty($ApiUri)) {
        throw 'Please supply a valid FOD API Uri with Set-FODConfig.'
    }
    if ([string]::IsNullOrEmpty($GrantType)) {
        throw 'Please supply a valid FOD GrantType with Set-FODConfig.'
    }
    if ([string]::IsNullOrEmpty($Scope)) {
        throw 'Please supply a valid FOD Scope with Set-FODConfig.'
    }
    if ($ForceCredential -or ($Credential -eq $null)) {
        $Credential = Get-Credential
    }

    $Params = @{
        ErrorAction = 'Stop'
    }
    if ($Proxy) {
        $Params['Proxy'] = $Proxy
    }
    if (-not$ForceVerbose) {
        $Params.Add('Verbose', $False)
    }
    if ($ForceVerbose) {
        $Params.Add('Verbose', $true)
    }
    Write-Verbose "Get-FODToken Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    $Body = @{
        scope = $Scope
    }
    if ($GrantType -eq 'UsernamePassword') {
        $Body.Add('grant_type', 'password')
        #$Body.Add('username', $Credential.UserName)
        #$Body.Add('password',[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)))
        $Body.Add('username', ($Credential.GetNetworkCredential().Domain + "\" + $Credential.GetNetworkCredential().UserName))
        $Body.Add('password', $Credential.GetNetworkCredential().Password)
    } elseif ($GrantType -eq 'ClientCredentials') {
        $Body.Add('grant_type', 'client_credentials')
        #$Body.Add('client_id', $Credential.UserName)
        #$Body.Add('client_secret',[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)))
        $Body.Add('client_id', $Credential.GetNetworkCredential().UserName)
        $Body.Add('client_secret', $Credential.GetNetworkCredential().Password)
    } else {
        # We shouldn't get here...
        throw "Unknown GrantType $GrantType"
    }

    $Uri = "$ApiUri/oauth/token"
    try {
        $Response = $null
        $Response = Invoke-RestMethod -Uri $Uri @Params -Method Post -Body $Body
    } catch {
        if ($_.ErrorDetails.Message -ne $null) {
            Write-Host $_.ErrorDetails
            # Convert the error-message to an object. (Invoke-RestMethod will not return data by-default if a 4xx/5xx status code is generated.)
            $_.ErrorDetails.Message | ConvertFrom-Json | Parse-FODError -Exception $_.Exception -ErrorAction Stop
        } else {
            Write-Error -Exception $_.Exception -Message "FOD API call failed: $_"
        }
    }
    # Check to see if we have confirmation that our API call failed.
    # (Responses with exception-generating status codes are handled in the "catch" block above - this one is for errors that don't generate exceptions)
    if ($Response -ne $null -and $Response.ok -eq $False) {
        $Response | Parse-FODError
    } elseif ($Response) {
        $Token = $Response.access_token
        if ($Print) {
            Write-Host $Token
        }
        Set-FODConfig -ApiUri $ApiUri -GrantType $GrantType -Scope $Scope -Token $Token
    }
    else {
        Write-Verbose "Something went wrong.  `$Response is `$null"
    }
}
