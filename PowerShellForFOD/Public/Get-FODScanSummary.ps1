function Get-FODScanSummary {
    <#
    .SYNOPSIS
        Gets the scans summary for a specific scan from FOD.
    .DESCRIPTION
        Gets the scans summary for a specific scan from FOD.
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
        # Get the scan summary for scan with id 1000
        Get-ScanSummary -ScanId 1000
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Scans/ScansV3_GetScanSummary
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
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
        Write-Verbose "Get-FODScanSummary Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawScanSummary = $null
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/scans/$ScanId/summary'" #$Params
        $RawScanSummary = Send-FODApi -Method Get -Operation "/api/v3/scans/$ScanId/summary" @Params
}
    end {
        if ($Raw) {
            $RawScanSummary
        } else {
            Parse-FODScanSummary -InputObject $RawScanSummary
        }
    }
}
