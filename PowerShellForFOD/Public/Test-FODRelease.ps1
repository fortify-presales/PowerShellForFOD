function Test-FODRelease {
    <#
    .SYNOPSIS
        Checks if an FOD application release exists.
    .DESCRIPTION
        Checks if the specified FOD release name already exists in an FOD Applicaiton.
        Returns $True if the release exists else $False.
    .PARAMETER ApplicationName
        The name of the application.
    .PARAMETER ReleaseName
        The name of the release.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Test if the Application name "test" has a Release named "1.0"
        Test-FODRelease -ApplicationName "test" -ReleaseName "1.0"
     .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApplicationName,

        [Parameter(Mandatory)]
        [string]$ReleaseName,

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
        Write-Verbose "Test-FODRelease Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Exists = $False
    }
    process
    {
        try {
            $Response = Get-FODReleaseId -ApplicationName $ApplicationName -ReleaseName $ReleaseName @Params
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
