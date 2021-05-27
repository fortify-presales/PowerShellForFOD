function Set-FODConfig
{
    <#
    .SYNOPSIS
        Set PowerShell for FOD module configuration.
    .DESCRIPTION
        Set PowerShell for FOD module configuration, and $PS4FOD module variable.
        This data is used as the default Token and ApiUri for most commands.
        If a command takes either a token or a uri, tokens take precedence.
        Credentials can also be stored so that the token can be genereated when needed.
        WARNING: Use this to store the token,uri or crendetials on a filesystem at your own risk
                 Only supported on Windows systems, via the DPAPI
    .PARAMETER Token
        Specify a previously generate authentication Token.
    .PARAMETER ApiUri
        Specify the API Uri to use, e.g. https://api.ams.fortify.com.
    .PARAMETER GrantType
        The method of authentication: UsernamePassword (Resource Owner Password Credentials) or ClientCredentials.
        Default is "UsernamePassword".
    .PARAMETER Scope
        The API scope to use, required if UsernamePassword Credentials is used.
        Default is "api-tenant".
    .PARAMETER Credential
        A previously created Credential object to be used.
    .PARAMETER Proxy
        Proxy to use with Invoke-RESTMethod.
    .PARAMETER ForceToken
        If set to true, an authentication token will be re-generated on every API call.
    .PARAMETER RenewToken
        If set to true, an authentication token will be re-generated if the existing token has expired.
    .PARAMETER ForceVerbose
        If set to true, we allow verbose output that may include sensitive data
        *** WARNING ***
        If you set this to true, your Fortify on Demand token will be visible as plain text in verbose output
    .PARAMETER Path
        If specified, save config file to this file path.
        Defaults to PS4FOD.xml in the user temp folder on Windows, or .ps4fod in the user's home directory on Linux/macOS.
    .EXAMPLE
        # Set the FOD Api Url and Force Verbose mode to $true
        Set-FODConfig -ApiUrl https://api.emea.fortify.com -ForceVerbose
    .FUNCTIONALITY
        Fortify on Demand.
    #>
    [cmdletbinding()]
    param(
        [Parameter()]
        [string]$Token,

        [Parameter()]
        [int]$Expiry,

        [Parameter()]
        [string]$ApiUri,

        [Parameter()]
        [ValidateSet('UsernamePassword', 'ClientCredentials')]
        [string]$GrantType = "UsernamePassword",

        [Parameter()]
        [ValidateSet('api-tenant', 'start-scans', 'manage-apps', 'view-apps', 'manage-issues', 'view-issues',
                'manage-reports', 'view-reports', 'manage-users', 'view-users', 'manage-notifications',
                'view-tenant-data')]
        [string]$Scope = "api-tenant",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [string]$Proxy,

        [Parameter()]
        [bool]$ForceToken,

        [Parameter()]
        [bool]$RenewToken,

        [Parameter()]
        [bool]$ForceVerbose,

        [Parameter()]
        [string]$Path = $script:_PS4FODXmlpath
    )

    switch ($PSBoundParameters.Keys)
    {
        'ApiUri'       { $Script:PS4FOD.ApiUri = $ApiUri }
        'GrantType'    { $Script:PS4FOD.GrantType = $GrantType }
        'Scope'        { $Script:PS4FOD.Scope = $Scope }
        'Credential'   { $Script:PS4FOD.Credential = $Credential }
        'Token'        { $Script:PS4FOD.Token = $Token }
        'Expiry'       { $Script:PS4FOD.Expiry = $Expiry }
        'Proxy'        { $Script:PS4FOD.Proxy = $Proxy }
        'ForceToken'   { $Script:PS4FOD.ForceToken = $ForceToken }
        'RenewToken'   { $Script:PS4FOD.RenewToken = $RenewToken }
        'ForceVerbose' { $Script:PS4FOD.ForceVerbose = $ForceVerbose }
    }

    function encrypt
    {
        param([string]$string)
        if ($String -notlike '' -and (Test-IsWindows)) {
            ConvertTo-SecureString -String $string -AsPlainText -Force
        }
    }

    Write-Verbose "Set-FODConfig Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"

    # Write the global variable and the xml
    $Script:PS4FOD |
        Select-Object -Property Proxy,
        @{l='ApiUri';e={Encrypt $_.ApiUri}},
        @{l='GrantType';e={$_.GrantType}},
        @{l='Scope';e={$_.Scope}},
        @{l='Credential';e={$_.Credential}},
        @{l='Token';e={Encrypt $_.Token}},
        @{l='Expiry';e={$_.Expiry}},
        ForceToken,
        RenewToken,
        ForceVerbose |
        Export-Clixml -Path $Path -force

}
