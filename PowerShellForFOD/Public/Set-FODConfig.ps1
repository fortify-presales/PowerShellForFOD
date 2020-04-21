function Set-FODConfig
{
    <#
    .SYNOPSIS
        Set PowerShell for FOD module configuration.
    .DESCRIPTION
        Set PowerShell for FOD module configuration, and $PS4FOD module variable.
        This data is used as the default Token and ApiUri for most commands.
        If a command takes either a token or a uri, tokens take precedence.
        WARNING: Use this to store the token or uri on a filesystem at your own risk
                 Only supported on Windows systems, via the DPAPI
    .PARAMETER Token
        Specify a Token to use.
        Only serialized to disk on Windows, via DPAPI.
    .PARAMETER ApiUri
        Specify the API Uri to use, e.g. https://api.ams.fortify.com.
        Only serialized to disk on Windows, via DPAPI.
    .PARAMETER Proxy
        Proxy to use with Invoke-RESTMethod.
    .PARAMETER ForceVerbose
        If set to true, we allow verbose output that may include sensitive data
        *** WARNING ***
        If you set this to true, your Slack token will be visible as plain text in verbose output
    .PARAMETER Path
        If specified, save config file to this file path.
        Defaults to PS4FOD.xml in the user temp folder on Windows, or .ps4fod in the user's home directory on Linux/macOS.
    .FUNCTIONALITY
        Fortify on Demand.
    #>
    [cmdletbinding()]
    param(
        [string]$ApiUri,
        [string]$Token,
        [string]$Proxy,
        [bool]$ForceVerbose,
        [string]$Path = $script:_PS4FODXmlpath
    )

    Switch ($PSBoundParameters.Keys)
    {
        'ApiUri'       { $Script:PS4FOD.ApiUri = $ApiUri }
        'Token'        { $Script:PS4FOD.Token = $Token }
        'Proxy'        { $Script:PS4FOD.Proxy = $Proxy }
        'ForceVerbose' { $Script:PS4FOD.ForceVerbose = $ForceVerbose }
    }

    Function Encrypt
    {
        param([string]$string)
        if ($String -notlike '' -and (Test-IsWindows)) {
            ConvertTo-SecureString -String $string -AsPlainText -Force
        }
    }

    # Write the global variable and the xml
    $Script:PS4FOD |
        Select-Object -Property Proxy,
        @{ l = 'ApiUri'; e = { Encrypt $_.ApiUri } },
        @{ l = 'Token'; e = { Encrypt $_.Token } },
        ForceVerbose |
        Export-Clixml -Path $Path -force

}
