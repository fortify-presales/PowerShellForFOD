function Get-FODUserGroups {
    <#
    .SYNOPSIS
        Get information about FOD user groups.
    .DESCRIPTION
        Get information about FOD user groups.
    .PARAMETER Filters
        A delimited list of field filters.
    .PARAMETER OrderBy
        The field name to order the results by.
    .PARAMETER OrderByDirection
        The direction to order the results by. ASC and DESC are valid values.
    .PARAMETER Fields
        Comma separated list of fields to return.
    .PARAMETER Paging
        If specified, and more data is available after loading limit of user groups,
        continue querying FOD until we have retrieved all the data available.
    .PARAMETER Limit
        Limit the number of user groups returned to this number.
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
        # Get all of the user groups in the system through Paging
        Get-FODUserGroups -Paging
     .EXAMPLE
        # Get any user groups with "test" or "demo" in their username
        Get-FODUserGroups -Paging -Filters "userName:test|demo"
     .EXAMPLE
        # Get the userId of a specific user (for use in other operations)
        $user = Get-FODUserGroups -Filter "userName:testuser" -Fields "userId"
        Write-Host $user.userId
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/UserGroups/UserGroupsV3_GetUserGroups
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
        Write-Verbose "Get-FODUserGroups Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
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
        $RawUserGroups = @()
        $HasMore = $false
        $TotalCount = 0
        $LoadedCount = 0
        $LoadLimit = $Limit
    }
    process
    {
        do {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/user-management/user-groups'" #$Params
            $Response = Send-FODApi -Method Get -Operation "/api/v3/user-management/user-groups" -Body $Body @Params
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
            $RawUserGroups += $Response.items
        } until (
            -not $Paging -or
                -not $HasMore
        )
        Write-Verbose "Loaded $LoadedCount user groups"
    }
    end {
        if ($Raw) {
            $RawUserGroups
        } else {
            Parse-FODUserGroup -InputObject $RawUserGroups
        }
    }
}
