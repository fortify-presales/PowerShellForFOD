function Get-FODUser {
    <#
    .SYNOPSIS
        Get information about a specific FOD user.
    .DESCRIPTION
        Get information about a specific FOD user.
    .PARAMETER Id
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
        # Get the user with id 1000
        Get-FODUser -Id 1000
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Users/UsersV3_GetUser
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$Id,

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
        Write-Verbose "Get-FODUser Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawUser = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/users/$Id'" #$Params
            $RawUser = Send-FODApi -Method Get -Operation "/api/v3/users/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawUser
        } else {
            Parse-FODUser -InputObject $RawUser
        }
    }
}
