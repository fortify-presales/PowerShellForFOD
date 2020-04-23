function Add-FODUser {
    <#
    .SYNOPSIS
        Adds a new FOD user.
    .DESCRIPTION
        Adds a new FOD user using the FOD REST API and a previously created
        PS4FOD.UserObject.
    .PARAMETER User
        A PS4FOD.UserObject containing the user's values.
    .PARAMETER Raw
        Print Raw output - do not convert into UserObject.
        Default is false.
    .PARAMETER Token
        FOD authentication token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .PARAMETER ForceVerbose
        Force verbose output.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Add a new user
        $userResponse = Add-FODUser -User $userObject
        if ($userResponse) {
            Write-Host "Created user with id:" $userResponse.userId
        }
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [PSTypeName('PS4FOD.UserObject')]
        [parameter(ParameterSetName = 'FODUserObject',
                ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $User,

        [switch]$Raw = $False,

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
        if ($Proxy) {
            $Params.Proxy = $Proxy
        }
        Write-Verbose "Add-FODUser Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawUser = @()
    }
    process
    {
        $Params = @{
            Body = $User
        }
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/users'"
        $RawUser = Send-FODApi -Method Post -Operation "/api/v3/users" @Params
    }
    end {
        if ($Raw) {
            $RawUser
        } else {
            Parse-FODUser -InputObject $RawUser
        }
    }
}
