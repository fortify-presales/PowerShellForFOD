function Get-FODUserGroupApplicationAccess {
    <#
    .SYNOPSIS
        Get information about the application access of an FOD user group.
    .DESCRIPTION
        Get information about the application access of an FOD user group.
    .PARAMETER UserGroupId
        The id of the user group.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get the application access details of user group id 1000
        Get-FODUserGroupApplicationAccess -Id 1000
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/UserGroupApplicationAccesss/UserGroupApplicationAccesssV3_GetUserGroupApplicationAccess
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$UserGroupId,

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
        Write-Verbose "Get-FODUserGroupApplicationAccess Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawUserGroupApplicationAccess = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/user-group-application-access/$UserGroupId'" #$Params
            $RawUserGroupApplicationAccess = Send-FODApi -Method Get -Operation "/api/v3/user-group-application-access/$UserGroupId" @Params
    }
    end {
        if ($Raw) {
            $RawUserGroupApplicationAccess
        } else {
            Parse-FODUserGroupApplicationAccess -InputObject $RawUserGroupApplicationAccess.items
        }
    }
}
