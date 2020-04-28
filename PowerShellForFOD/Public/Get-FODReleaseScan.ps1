function Get-FODReleaseScan {
    <#
    .SYNOPSIS
        Gets the individual scan for a FOD releases.
    .DESCRIPTION
        Get the individual scan that has been carried out for a specific FOD release.
    .PARAMETER ReleaseId
        The release id.
    .PARAMETER ScanId
        The scan id.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get the scans with id 1234 for release id 100 through Paging
        Get-FODReleaseScan -ReleaseId 100 -ScanId 1234
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Releases/ReleasesV3_GetScansByReleaseId
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [int]$ReleaseId,
        [int]$ScanId,
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
        Write-Verbose "Get-FODReleaseScan Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = $null
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/releases/$ReleaseId/scans/$ScanId'" #$Params
        $Response = Send-FODApi -Method Get -Operation "/api/v3/releases/$ReleaseId/scans/$ScanId" @Params
    }
    end {
        if ($Raw) {
            $Response
        } else {
            Parse-FODScan -InputObject $Response
        }
    }
}
