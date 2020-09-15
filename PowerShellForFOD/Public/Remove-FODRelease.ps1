function Remove-FODRelease {
    <#
    .SYNOPSIS
        Deletes a specific FOD release.
    .DESCRIPTION
        Deletes a specific FOD release.
    .PARAMETER Id
        The id of the release.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Remove the release with id 100
        Remove-FODRelease -Id 100
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Releases/ReleasesV3_Delete
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$Id,

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
        Write-Verbose "Remove-FODRelease Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Delete -Operation '/api/v3/releases/$Id'" #$Params
            $RawResponse = Send-FODApi -Method Delete -Operation "/api/v3/releases/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
