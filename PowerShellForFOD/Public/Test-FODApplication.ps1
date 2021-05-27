function Test-FODApplication {
    <#
    .SYNOPSIS
        Checks if an FOD application exists.
    .DESCRIPTION
        Checks if the specified FOD application name already exists in FOD.
        Returns $True if the application exists else $False.
    .PARAMETER ApplicationName
        The name of the application.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Test if the Application with name "test" exists
        Test-FODApplication -ApplicationName test
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [string]$ApplicationName,

        [switch]$Raw,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Token = $Script:PS4FOD.Token,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Proxy = $Script:PS4FOD.Proxy,

        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose
    )
    begin
    {
        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Test-FODApplication Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Exists = $False
    }
    process
    {
        try {
            $Response = Get-FODApplicationId -ApplicationName $ApplicationName @Params
            if ($Response -gt 0) {
                $Exists = $True
            }
        } catch {
            $Exists = $False
        }
    }
    end {
        return $Exists
    }
}
