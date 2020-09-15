function Get-FODVulnerabilities {
    <#
    .SYNOPSIS
        Get information about FOD vulnerabilities.
    .DESCRIPTION
        Get information about FOD vulnerabilities.
    .PARAMETER ReleaseId
        The Id of the Release to get vulnerabilities for.
    .PARAMETER ApplicationName
        The Name of the application to import into.
    .PARAMETER ReleaseName
        The Name of the release to import into.
        Note: Both ApplicationName and ReleaseName are required if not specifying ReleaseId
    .PARAMETER Filters
        A delimited list of field filters.
    .PARAMETER OrderBy
        The field name to order the results by.
    .PARAMETER OrderByDirection
        The direction to order the results by. ASC and DESC are valid values.
    .PARAMETER Fields
        Comma separated list of fields to return.
    .PARAMETER ExcludeFilters
        Filter data should be excluded in the return value.
    .PARAMETER IncludeFixed
        Items that have been fixed should be included in the return value.
    .PARAMETER IncludeSuppressed
        items that have been suppressed should be included in the return value.
    .PARAMETER KeywordSearch
        Used for keyword searches.
    .PARAMETER Paging
        If specified, and more data is available after loading limit of vulnerabilities,
        continue querying FOD until we have retrieved all the data available.
    .PARAMETER Limit
        Limit the number of vulnerabilities returned to this number.
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
        # Get all of the vulnerabilities for release id 1000 through Paging
        Get-FODVulnerabilities -Release Id 1000 -Paging
    .EXAMPLE
        # Get all of the vulnerabilities for release "1.0" of application "FOD-Test"
        Get-FODVulnerabilities -ApplicationName "FOD-Test" -ReleaseName "1.0" -Paging
    .EXAMPLE
        # Get all vulnerabilities with "critical" or "high" severity for release id 1000
        Get-FODVulnerabilities -Release Id 1000 -Paging -Filters "severityString:Critical|High"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Vulnerabilities/VulnerabilitiesV3_GetVulnerabilities
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [int]$ReleaseId,

        [Parameter(Mandatory=$False)]
        [string]$ApplicationName,

        [Parameter(Mandatory=$False)]
        [string]$ReleaseName,

        [string]$Filters,
        [string]$OrderBy,
        [string]$OrderByDirection,
        [string]$Fields,
        [switch]$ExcludeFilters,
        [switch]$IncludeFixed,
        [switch]$IncludeSuppressed,
        [string]$KeywordSearch,
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
        # If we don't have a ReleaseId parameter we have to find it using API
        if (-not $PSBoundParameters.ContainsKey('ReleaseId'))
        {
            if ($PSBoundParameters.ContainsKey('ApplicationName') -and $PSBoundParameters.ContainsKey('ReleaseName')) {
                try {
                    $ReleaseId = Get-FODReleaseId -ApplicationName $ApplicationName -ReleaseName $ReleaseName
                    Write-Verbose "Found Release Id: $ReleaseId"
                } catch {
                    Write-Error $_
                    Break
                }
            } else {
                throw "Please supply a parameter for `"ReleaseId`" or both `"ApplicationName`" and `"ReleaseName`""
            }
        }
        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Get-FODVulnerabilities Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{
            offset = 0
            limit = $Limit
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
                Write-Error "OrderBy can only be ASC or DESC."
                Break
            }
        }
        if ($Fields) {
            $Body.Add("fields", $Fields)
        }
        if ($ExcludeFilters) {
            $Body.Add("excludeFilters", "true")
        } else {
            #$Body.Add("excludeFilters", "false")
        }
        if ($IncludeFixed) {
            $Body.Add("includeFixed", "true")
        } else {
            #$Body.Add("includeFixed", "false")
        }
        if ($IncludeSuppressed) {
            $Body.Add("includeSuppressed", "true")
        } else {
            #$Body.Add("includeSuppressed", "false")
        }
        if ($KeywordSearch) {
            $Body.Add("keywordSearch", $KeywordSearch)
        }
        if ($Limit -gt 50) {
            Write-Error "Maximum value for Limit is 50."
            Break
        }
        $RawVulnerabilities = @()
        $HasMore = $false
        $TotalCount = 0
        $LoadedCount = 0
        $LoadLimit = $Limit
    }
    process
    {
        do {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/releases/$ReleaseId/vulnerabilities'" #$Params
            $Response = Send-FODApi -Method Get -Operation "/api/v3/releases/$ReleaseId/vulnerabilities" -Body $Body @Params
            $TotalCount = $Response.totalCount
            if ($TotalCount -lt $LoadLimit) {
                $LoadedCount += $TotalCount
                $HasMore = $false
            } elseif ($LoadedCount -lt ($TotalCount - $LoadLimit)) {
                $HasMore = $true
                $LoadedCount += $LoadLimit
                $Body.Remove("offset")
                $Body.Add("offset", $LoadedCount)
            } else {
                $LoadedCount += $TotalCount
                $HasMore = $false
            }
            $RawVulnerabilities += $Response.items
        } until (
            -not $Paging -or
                -not $HasMore
        )
        Write-Verbose "Loaded $TotalCount vulnerabilities"
    }
    end {
        if ($Raw) {
            $RawVulnerabilities
        } else {
            Parse-FODVulnerability -InputObject $RawVulnerabilities
        }
    }
}
