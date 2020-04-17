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

        Maximum value is 50. Default is 50.

    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.

    .PARAMETER Token
        FOD token to use.

        If empty, the value from PS4FOD will be used.

    .PARAMETER Proxy
        Proxy server to use.

        Default value is the value set by Set-FODConfig

    .EXAMPLE

        Get-FODApplications -Paging

        # Get all of the applications in the system through Paging

     .EXAMPLE

        Get-FODApplications -Filters "applicationName:myApp1|myApp2"

        # Get the applications "myapp1" or "myApp2"

    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetApplications

    .FUNCTIONALITY
        Fortify on Demand
    #>
    [cmdletbinding()]
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
        [string]$Uri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Proxy = $Script:PS4FOD.Proxy,

        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose
    )
    begin
    {
        $Params = @{}
        if ($Proxy)
        {
            $Params.Proxy = $Proxy
        }
        Write-Verbose "Get-FODApplications Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $body = @{
            offset = 0
            limit = $Limit
        }
        if ($Filters)
        {
            $body.Add("filters", $Filters)
        }
        if ($OrderBy)
        {
            $body.Add("orderBy", $OrderBy)
        }
        if ($OrderByDirection)
        {
            if ($OrderByDirection -eq "ASC" -or $OrderByDirection -eq "DESC") {
                $body.Add("orderByDirection", $OrderByDirection)
            } else {
                Write-Error "OrderBy can only be ASC or DESC."
                Exit
            }
        }
        if ($Fields)
        {
            $body.Add("fields", $Fields)
        }
        if ($Limit -gt 50)
        {
            Write-Error "Maximum value for Limit is 50."
            Exit
        }
        $RawApplications = @()
        $has_more = $false
        $totalCount = 0
        $loadedCount = 0
        $loadLimit = $Limit
    }
    process
    {
        do
        {
            $params = @{
                Body = $body
            }
            Write-Verbose "Send-FODApi"
            $response = Send-FODApi -Operation "/api/v3/applications" @params
            $totalCount = $response.totalCount
            if ($loadedCount -lt ($totalCount - $loadLimit))
            {
                $has_more = $true
                $loadedCount += $loadLimit
                $Body.Remove("offset")
                $Body.Add("offset", $loadedCount)
            }
            else
            {
                $has_more = $false
            }
            $RawApplications += $response.items
        } until (
            -not$Paging -or
                -not$has_more
        )
    }

    end {
        if ($Raw) {
            $RawApplications
        } else {
            Parse-FODApplication -InputObject $RawApplications
        }
    }
}
