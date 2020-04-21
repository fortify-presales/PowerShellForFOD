Function Get-FODConfig {
    <#
    .SYNOPSIS
        Get PowerShell For FOD module configuration.
    .DESCRIPTION
        Retrieves the PowerShell for FOD module configuration from the serialized XML file.
    .PARAMETER Source
        Get the config data from either:
            PS4FOD:     the live module variable used for command defaults
            PS4FOD.xml: the serialized PS4FOD.xml that loads when importing the module
        Defaults to PS4FOD.
    .PARAMETER Path
        If specified, read config from this XML file.
        Defaults to PS4FOD.xml in the user temp folder on Windows, or .ps4fod in the user's home directory on Linux/macOS.
    .FUNCTIONALITY
        Fortify on Demand.
    #>
    [cmdletbinding(DefaultParameterSetName = 'source')]
    param(
        [parameter(ParameterSetName='source')]
        [ValidateSet("PS4FOD","PS4FOD.xml")]
        $Source = "PS4FOD",

        [parameter(ParameterSetName='path')]
        [parameter(ParameterSetName='source')]
        $Path = $script:_PS4FODXmlpath
    )

    if($PSCmdlet.ParameterSetName -eq 'source' -and $Source -eq "PS4FOD" -and -not $PSBoundParameters.ContainsKey('Path')) {
        $Script:PS4FOD
    } else {
        function Decrypt {
            param($String)
            if($String -is [System.Security.SecureString]) {
                [System.Runtime.InteropServices.marshal]::PtrToStringAuto(
                        [System.Runtime.InteropServices.marshal]::SecureStringToBSTR(
                                $string))
            }
        }
        Import-Clixml -Path $Path |
                Select-Object -Property Proxy,
                @{l='ApiUri';e={Decrypt $_.ApiUri}},
                @{l='Token';e={Decrypt $_.Token}},
                ForceVerbose
    }

}
