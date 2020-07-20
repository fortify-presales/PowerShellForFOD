function Get-FODApplications {
    <#
    .SYNOPSIS
        Get information about FOD applications.
    .DESCRIPTION
        Get information about FOD applications.
    .PARAMETER Filters
        A delimited list of field filters.
    .PARAMETER OrderBy
        The field name to order the results by.
    .PARAMETER OrderByDirection
        The direction to order the results by. ASC and DESC are valid values.
    .PARAMETER Fields
        Comma separated list of fields to return.
    .PARAMETER Paging
        If specified, and more data is available after loading limit of applications,
        continue querying FOD until we have retrieved all the data available.
    .PARAMETER Limit
        Limit the number of applications returned to this number.
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
        # Get all of the applications in the system through Paging
        Get-FODApplications -Paging
     .EXAMPLE
        # Get any applications with "test" or "demo" in their name
        Get-FODApplications -Paging -Filters "applicationName:test|demo"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetApplications
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
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
        Write-Verbose "Get-FODApplications Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
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
                Write-Error "OrderBy can only be ASC or DESC." -ErrorAction Stop
            }
        }
        if ($Fields) {
            $Body.Add("fields", $Fields)
        }
        if ($Limit -gt 50) {
            Write-Error "Maximum value for Limit is 50." -ErrorAction Stop
        }
        $RawApplications = @()
        $HasMore = $false
        $TotalCount = 0
        $LoadedCount = 0
        $LoadLimit = $Limit
    }
    process
    {
        do {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/applications'" #$Params
            $Response = Send-FODApi -Method Get -Operation "/api/v3/applications" -Body $Body @Params
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
                $HasMore = $false
            }
            $RawApplications += $Response.items
        } until (
            -not $Paging -or
                -not $HasMore
        )
        Write-Verbose "Loaded $LoadedCount applications"
    }
    end {
        if ($Raw) {
            $RawApplications
        } else {
            Parse-FODApplication -InputObject $RawApplications
        }
    }
}
