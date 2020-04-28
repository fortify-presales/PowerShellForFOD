function Add-FODUserApplicationAccess {
    <#
    .SYNOPSIS
        Adds/Grants user access for a given application.
    .DESCRIPTION
        Adds/Grants user access for one or more applications.
    .PARAMETER UserId
        The id of the user to give access to.
    .PARAMTER ApplicationId
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
        # Give the user with id 1000 access to application with id 100
        Add-FODUserApplicationAccess -UserId 1000 -ApplicationId 100
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $UserId,

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
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Add-FODUserApplicationAccess Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = @()
    }
    process
    {
        $Body = @{
            applicationId = $ApplicationId
        }
        $Params.Body = $Body
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/user-application-access/$UserId'"
        $Response = Send-FODApi -Method Post -Operation "/api/v3/user-application-access/$UserId" @Params
    }
    end {
        $Response
    }
}
