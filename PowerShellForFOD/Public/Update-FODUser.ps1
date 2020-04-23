function Update-FODUser {
    <#
    .SYNOPSIS
        Updates a specific FOD user.
    .DESCRIPTION
        Updates a specific FOD user.
    .PARAMETER Id
        The id of the user.
    .PARAMETER User
        A PS4FOD.UserObject containing the user's values.
        Note: only the following fields can/will be updated:
            - Email
            - FirstName
            - LastName
            - PhoneNumber
            - RoleId
            - PasswordNeverExpires
            - IsSuspended
            - MustChange
            - Password
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Update the user with id 1000
        Update-FODUser -Id 1000 -User $userObj
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Users/UsersV3_PutUser
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$Id,

        [PSTypeName('PS4FOD.UserObject')]
        [parameter(ParameterSetName = 'FODUserObject',
            ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $User,

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
        Write-Verbose "Update-FODUser Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
        $Params = @{
            Body = $User
        }
        Write-Verbose "Send-FODApi: -Method Put -Operation '/api/v3/users/$Id'"
        $RawResponse = Send-FODApi -Method Put -Operation "/api/v3/users/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
