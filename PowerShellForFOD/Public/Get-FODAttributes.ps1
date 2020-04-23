function Get-FODAttributes {
    <#
    .SYNOPSIS
        Get information about FOD attributes.
    .DESCRIPTION
        Get information about FOD attributes.
    .PARAMETER Filters
        A delimited list of field filters.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
     .EXAMPLE
        # Get any attributes with "test" or "demo" in their attributename
        Get-FODAttributes -Filters "attributeName:test|demo"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Attributes/AttributesV3_GetAttributes
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [string]$Filters,
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
        Write-Verbose "Get-FODAttributes Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{}
        if ($Filters) {
            $Body.Add("filters", $Filters)
        }

        $RawAttributes = @()
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/attributes'" #$Params
        if ($Body.Count -eq 0) {
            $RawAttributes = Send-FODApi -Method Get -Operation "/api/v3/attributes" @Params
        } else {
            $RawAttributes = Send-FODApi -Method Get -Operation "/api/v3/attributes" -Body $Body @Params
        }
    }
    end {
        if ($Raw) {
            $RawAttributes
        } else {
            Parse-FODAttribute -InputObject $RawAttributes.items
        }
    }
}
