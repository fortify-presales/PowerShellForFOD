function Get-FODTenantHeatMaps {
    <#
    .SYNOPSIS
        Get FOD Tenant Heat Maps.
    .DESCRIPTION
        Get the tenant heap maps for releases at a specific SDLC status.
    .PARAMETER SdlcStatus
        SDLC status of releases to include.
        Valid values are: Production, QA, Development, Retired.
    .PARAMETER DaysFrom
        Days back to get data.
    .PARAMETER Filters
        A delimited list of field filters.
    .PARAMETER OrderBy
        The field name to order the results by.
    .PARAMETER OrderByDirection
        The direction to order the results by. ASC and DESC are valid values.
    .PARAMETER Fields
        Comma separated list of fields to return.
    .PARAMETER Paging
        If specified, and more data is available after loading limit of releases,
        continue querying FOD until we have retrieved all the data available.
    .PARAMETER Limit
        Limit the number of releases returned to this number.
        Maximum value is 50.
        Default is 50.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
     .EXAMPLE
        # Get all the tenant heat maps through Paging for releases in Production
        Get-FODTenantHeatMaps -Paging -SdlcStatus Production
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/TenantHeatMaps/TenantHeatMapsV3_GetTenantHeatMap
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Production', 'QA', 'Development', 'Retired')]
        [string]$SdlcStatus,

        [int]$DaysFrom,
        [string]$Filters,
        [string]$OrderBy,
        [string]$OrderByDirection,
        [string]$Fields,
        [switch]$Raw,
        [switch]$Paging,
        [int]$Limit = 50,

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
        Write-Verbose "Get-FODTenantHeatMaps Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{
            sdlcStatus = $SdlcStatus
            offset = 0
            limit = $Limit
        }
        if ($DaysFrom -gt 0) {
            $Body.Add("daysFrom", $DaysFrom)
        }
        if ($Filters) {
            $Body.Add("filters", $Filters)
        }
        if ($OrderBy) {
            $Body.Add("orderBy", $OrderBy)
        }
        if ($OrderByDirection) {
            if ($OrderByDirection -eq "ASC" -or $OrderByDirection -eq "DESC") {
                $Body.Add("orderByDirection", $OrderByDirection)
            } else {
                Write-Error "OrderBy can only be ASC or DESC." -ErrorAction Stop
            }
        }
        if ($Fields) {
            $Body.Add("fields", $Fields)
        }
        if ($Limit -gt 50) {
            Write-Error "Maximum value for Limit is 50." -ErrorAction Stop
        }
        $RawHeatMap = @()
        $HasMore = $false
        $TotalCount = 0
        $LoadedCount = 0
        $LoadLimit = $Limit
    }
    process
    {
        do {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/tenant-heat-maps'" #$Params
            $Response = Send-FODApi -Method Get -Operation "/api/v3/tenant-heat-maps" -Body $Body @Params
            $TotalCount = $Response.totalCount
            if ($LoadedCount -lt ($TotalCount - $LoadLimit)) {
                $HasMore = $true
                $LoadedCount += $LoadLimit
                $Body.Remove("offset")
                $Body.Add("offset", $LoadedCount)
            } else {
                $LoadedCount += $TotalCount
                $HasMore = $false
            }
            $RawHeatMap += $Response.items
        } until (
            -not $Paging -or
                -not $HasMore
        )
        Write-Verbose "Loaded $LoadedCount heat maps"
    }
    end {
        if ($Raw) {
            $RawHeatMap
        } else {
            Parse-FODTenantHeatMap -InputObject $RawHeatMap
        }
    }
}
