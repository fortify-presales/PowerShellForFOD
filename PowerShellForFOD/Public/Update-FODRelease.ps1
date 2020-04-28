function Update-FODRelease {
    <#
    .SYNOPSIS
        Updates a specific FOD release.
    .DESCRIPTION
        Updates a specific FOD release.
    .PARAMETER Id
        The id of the release.
    .PARAMETER Release
        A PS4FOD.ReleaseObject containing the release's values.
        Note: only the following fields can/will be updated:
            - Name
            - Description
            - SdlcStatusType
            - Owner
            - Microservice
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Update the release with id 100
        Update-FODRelease -Id 100 -Release $releaseObj
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Releases/ReleasesV3_PutRelease
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$Id,

        [PSTypeName('PS4FOD.ReleaseObject')]
        [parameter(ParameterSetName = 'FODReleaseObject',
            ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $Release,

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
        Write-Verbose "Update-FODRelease Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
        $Params = @{
            Body = $Release
        }
        Write-Verbose "Send-FODApi: -Method Put -Operation '/api/v3/releases/$Id'"
        $RawResponse = Send-FODApi -Method Put -Operation "/api/v3/releases/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
