function Get-FODReleaseId {
    <#
    .SYNOPSIS
        Gets the id for a specific release.
    .DESCRIPTION
        Gets the id for a specific release using the Application name and Release name provided.
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
        # Get the release id for Application name "test", Release name "1.0"
        Get-FODReleaseId -ApplicationName "test" -ReleaseName "1.0"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Releases/ReleasesV3_GetRelease
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
        Write-Verbose "Get-FODReleaseId Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {
        if ($ApplicationName -and $ReleaseName)
        {
            # Find all "matching" releases and filter for exact matches
            Write-Verbose "Retrieving release id for release: $ReleaseName of application: $ApplicationName"
            foreach ($release in Get-FODReleases -Filters "applicationName:$ApplicationName+releaseName:$ReleaseName") {
                if ($release.applicationName -eq $ApplicationName -and $release.releaseName -eq $ReleaseName) {
                    $ReleaseId = $release.releaseId
                    break
                }
            }
            if ($ReleaseId)
            {
                Write-Verbose "Found release id: $ReleaseId"
            }
            else
            {
                throw "Unable to find release: $ReleaseName of application: $ApplicationName"
            }
        } else {
            throw "Both ApplicationName and ReleaseName are required if not specifying ReleaseId"
        }
    }
    end {
        $ReleaseId
    }
}
