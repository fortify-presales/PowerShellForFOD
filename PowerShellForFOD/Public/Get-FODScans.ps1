function Get-FODScans {
    <#
    .SYNOPSIS
        Gets scans from FOD.
    .DESCRIPTION
        Get scans from FOD.
    .PARAMETER StartedOnStartDate
        The started on state date.
    .PARAMETER StartedOnEndDate
        The started on end date.
    .PARAMETER CompletedOnStartDate
        The completed on state date.
    .PARAMETER CompletedOnEndDate
        The completed on end date.
    .PARAMETER OrderBy
        The field name to order the results by.
    .PARAMETER OrderByDirection
        The direction to order the results by. ASC and DESC are valid values.
    .PARAMETER Fields
        Comma separated list of fields to return.
    .PARAMETER Paging
        If specified, and more data is available after loading limit of scans,
        continue querying FOD until we have retrieved all the data available.
    .PARAMETER Limit
        Limit the number of scans returned to this number.
        Maximum value is 50.
        Default is 50.
    .PARAMETER Since
        Limit the results to the specified modified on or after date.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get all of the scans for application id 100 through Paging, latest completed first
        Get-FODScans -Filters "applicationId:100" -Paging -OrderBy 'startedDateTime' -OrderByDirection 'DESC'
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Scans/ScansV3_GetScans
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [string]$StartedOnStartDate,
        [string]$StartedOnEndDate,
        [string]$CompletedOnStartDate,
        [string]$CompletedOnEndDate,
        [string]$OrderBy,
        [string]$OrderByDirection,
        [string]$Fields,
        [switch]$Raw,
        [switch]$Paging,
        [int]$Limit = 50,
        [DateTime]$Since,

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
        Write-Verbose "Get-FODScans Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{
            offset = 0
            limit = $Limit
        }
        if ($StartedOnStartDate) {
            $Body.Add("startedOnStartDate", $StartedOnStartDate)
        }
        if ($StartedOnEndDate) {
            $Body.Add("startedOnEndDate", $StartedOnEndDate)
        }
        if ($CompletedOnStartDate) {
            $Body.Add("completedOnStartDate", $CompletedOnStartDate)
        }
        if ($CompletedOnEndDate) {
            $Body.Add("completedOnEndDate", $CompletedOnEndDate)
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
        if ($Since) {
            $DateTimeString = Get-Date -Date $Since -Format "o"
            $Body.Add("modifiedStartDate", $DateTimeString)
        }
        $RawScans = @()
        $HasMore = $false
        $TotalCount = 0
        $LoadedCount = 0
        $LoadLimit = $Limit
    }
    process
    {
        do {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/scans'" #$Params
            $Response = Send-FODApi -Method Get -Operation "/api/v3/scans" -Body $Body @Params
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
            $RawScans += $Response.items
        } until (
            -not $Paging -or
                -not $HasMore
        )
        Write-Verbose "Loaded $LoadedCount scans"
    }
    end {
        if ($Raw) {
            $RawScans
        } else {
            Parse-FODScan -InputObject $RawScans
        }
    }
}
