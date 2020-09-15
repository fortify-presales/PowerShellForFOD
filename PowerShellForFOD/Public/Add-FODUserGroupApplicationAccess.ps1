function Add-FODUserGroupApplicationAccess {
    <#
    .SYNOPSIS
        Adds/Grants user group access for a given application.
    .DESCRIPTION
        Adds/Grants user group access for one or more applications.
    .PARAMETER UserGroupId
        The id of the user group to give access to.
    .PARAMETER ApplicationId
        The id of the application to give the user access to.
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
        # Give the user group with id 1000 access to application with id 100
        Add-FODUserGroupApplicationAccess -UserGroupId 1000 -ApplicationId 100
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $UserGroupId,

        [Parameter(Mandatory)]
        $ApplicationId,

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
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Add-FODUserGroupApplicationAccess Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = $null
    }
    process
    {
        $Body = @{
            applicationId = $ApplicationId
        }
        $Params.Body = $Body
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/user-group-application-access/$UserGroupId'"
        $Response = Send-FODApi -Method Post -Operation "/api/v3/user-group-application-access/$UserGroupId" @Params
    }
    end {
        $Response
    }
}
