function Send-FODApi {
    <#
    .SYNOPSIS
        Send a request to the FOD REST API.
    .DESCRIPTION
        Send a request to the FOD REST API.
        This function is used by other PS4FOD functions.
        It's a simple wrapper you could use for calls to the FOD API.
    .PARAMETER Method
        REST API Method (Get, Post, Put, Delete ...).
        Defaults to Get.
    .PARAMETER Operation
        FOD API Operation to call, e.g. /api/v3/applications, this will be appended to $ApiUri
        Reference: https://api.ams.fortify.com/
    .PARAMETER Body
        Hash table of arguments to send to the FOD API.
    .PARAMETER BodyFile
        A File containing the Body to be sent to the FOD API.
    .PARAMETER ContentType
        Content Type to send, if not specified defaults to "application/json"
    .PARAMETER Token
        FOD authentication token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETR ApiUri
        FOD API Uri to use, e.g. https://api.ams.fortify.com.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER NewToken
        Create a new token using stored credentials.
    .PARAMETER ForceVerbose
        If specified, don't explicitly remove verbose output from Invoke-RestMethod
        *** WARNING ***
        This will expose your data in verbose output.
    .EXAMPLE
        # Get a list of (the first 5) FOD applications
        $Body = @{
            limit = 5
        }
        Send-FODApi -Operation "/api/v3/applications" -Body $Body -ForceVerbose
    .FUNCTIONALITY
        Fortify on Demand.
    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Get', 'Post', 'Put', 'Delete', 'Patch')]
        [string]$Method,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Operation,

        [ValidateNotNullOrEmpty()]
        [hashtable]$Body,

        [Parameter(Mandatory=$false)]
        [string]$BodyFile,

        [Parameter(Mandatory=$false)]
        [string]$ContentType = 'application/json',

        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (-not $_ -and -not $Script:PS4FOD.Token){
                throw 'Please specify an authentication token or create a new FOD Api Token with Get-FODToken.'
            } else {
                $true
            }
        })]
        [string]$Token = $Script:PS4FOD.Token,

        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (-not $_ -and -not $Script:PS4FOD.ApiUri) {
                throw 'Please supply a FOD Api Uri with Set-FODConfig.'
            } else {
                $true
            }
        })]
        [string]$ApiUri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Proxy = $Script:PS4FOD.Proxy,

        [switch]$ForceToken = $Script:PS4FOD.ForceToken,

        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose

    )
    begin
    {
        $Params = @{
            Uri = "$ApiUri$Operation"
            ErrorAction = 'Stop'
        }
        if (-not $Method) {
            $Method = 'Get'
        }
        if ($Method -eq 'Get') {
            $Params.Add('Method', 'Get')
            $Params.Add('Body', $Body)
        } elseif ($BodyFile) {
            Write-Verbose "BodyFile is $BodyFile"
            $Params.Add('Method', $Method)
            $Params.Add('InFile', $BodyFile)
            $Params.Add('ContentType', $ContentType)
        } else {
            $Params.Add('Method', $Method)
            $Params.Add('ContentType', $ContentType)
            $Params.add('Body', (ConvertTo-Json $Body))
        }
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('Verbose', $True)
            $VerbosePreference = "Continue"
        }
        if ($ForceToken) {
            Write-Verbose "Re-creating authentication token"
            Get-FODToken
            $Token = $Script:PS4FOD.Token
        }
        $Headers = @{
            'Authorization' = "Bearer " + $Token
            'Accept' = "application/json"
        }
        Write-Verbose "Send-FODApi Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {
        $Response = $null
        try
        {
            if ($Body) {
                Write-Verbose "JSON Payload:"
                Write-Verbose (ConvertTo-Json $Body)
            }
            $Response = Invoke-RestMethod -Headers $Headers @Params
            Write-Verbose $Response
        } catch {
            Write-Verbose "Caught Exception:"
            # (HTTP 429 is "Too Many Requests")
            if ($_.Exception.Response.StatusCode -eq 429) {
                $RetryPeriod = 30
                if ($_.Exception.Response.Headers -and $_.Exception.Response.Headers.Contains('X-Rate-Limit-Reset'))
                {
                    $RetryPeriod = $_.Exception.Response.Headers.GetValues('X-Rate-Limit-Reset')
                    if ($RetryPeriod -is [string[]])
                    {
                        $RetryPeriod = [int]$RetryPeriod[0]
                    }
                }
                # Write Response error
                Write-Verbose "Sleeping [$RetryPeriod] seconds due to FOD 429 response"
                Start-Sleep -Seconds $RetryPeriod
                Send-FODApi @PSBoundParameters
            } elseif ($_.ErrorDetails.Message -ne $null) {
                $StatusCode = $_.Exception.Response.StatusCode
                $ErrorObj = $_.ErrorDetails.Message | ConvertFrom-Json
                # if multitple errors, i.e. from input validation
                if ($ErrorObj.errors) {
                    #$ErrorObj.errors
                    foreach ($error in $ErrorObj.errors) {
                        # Do not parse for now, just write directly
                        Write-Host "Error: $StatusCode"
                        Write-Host $error
                    }
                } else {
                    # Convert the error-message to an object. (Invoke-RestMethod will not return data by-default if a 4xx/5xx status code is generated.)
                    $_.ErrorDetails | ConvertFrom-Json | Parse-FODError -Exception $_.Exception -ErrorAction Stop
                }
            } else {
                Write-Error -Exception $_.Exception -Message "FOD API call failed: $_"
            }
        }
    }
    end
    {
        # Check to see if we have confirmation that our API call failed.
        # (Responses with exception-generating status codes are handled in the "catch" block above - this one is for errors that don't generate exceptions)
        if ($Response -ne $null -and $Response.ok -eq $False) {
            $Response | Parse-FODError
        } elseif ($Response) {
            Write-Output $Response
        } else {
            Write-Verbose "Response is empty."
        }
    }
}
