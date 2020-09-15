function Get-FODUserId {
    <#
    .SYNOPSIS
        Gets the id for a specific user.
    .DESCRIPTION
        Gets the internal id for a specific user using the user name provided.
    .PARAMETER UserName
        The user name of the user.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get the user id for user name "testuser1"
        Get-FODUserId -UserName "testuser1"
     .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$UserName,

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
        Write-Verbose "Get-FODUserId Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $User = @{}
    }
    process
    {
        # Find all "matching" users and filter for exact matches
        Write-Verbose "Retrieving all users with username:$UserName"
        foreach ($u in Get-FODUsers -Filters "username:$UserName") {
            if ($u.username -eq $UserName) {
                $User = $u
                break
            }
        }
        if ($User.Count -ne 0)
        {
            Write-Verbose "Found user: $UserName"
        }
        else
        {
            throw "Unable to find user: $UserName"
        }
    }
    end {
        if ($Raw) {
            $User
        } else {
            $User.userId
        }
    }
}
