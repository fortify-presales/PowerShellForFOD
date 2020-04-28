function Remove-FODUserGroupApplicationAccess {
    <#
    .SYNOPSIS
        Removes access from an application for a specific user group.
    .DESCRIPTION
        Removes access from an application for a specific user group.
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
        # Remove the user group with id 1000 from application 100
        Remove-FODUserGroupApplicationAccess -UserGroupId 1000 -ApplicationId 100
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/UserGroupApplicationAccess/UserGroupApplicationAccessV3_DeleteUserGroupApplicationAccess
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$UserGroupId,

        [Parameter(Mandatory)]
        [int]$ApplicationId,

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
        Write-Verbose "Remove-FODUserGroupApplicationAccess Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = $null
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Delete -Operation '/api/v3/user-group-application-access/$UserGroupId/$ApplicationId'" #$Params
        $Response = Send-FODApi -Method Delete -Operation "/api/v3/user-group-application-access/$UserGroupId/$ApplicationId" @Params
    }
    end {
        $Response
    }
}
