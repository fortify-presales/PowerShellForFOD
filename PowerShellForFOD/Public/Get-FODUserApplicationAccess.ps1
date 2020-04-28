function Get-FODUserApplicationAccess {
    <#
    .SYNOPSIS
        Get information about the application access of an FOD user.
    .DESCRIPTION
        Get information about the application access of an FOD user.
    .PARAMETER UserId
        The id of the user.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE

    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/UserApplicationAccesss/UserApplicationAccesssV3_GetUserApplicationAccess
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$UserId,

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
        $RawUserApplicationAccess = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/user-application-access/$UserId'" #$Params
            $RawUserApplicationAccess = Send-FODApi -Method Get -Operation "/api/v3/user-application-access/$UserId" @Params
    }
    end {
        if ($Raw) {
            $RawUserApplicationAccess
        } else {
            Parse-FODUserApplicationAccess -InputObject $RawUserApplicationAccess.items
        }
    }
}
