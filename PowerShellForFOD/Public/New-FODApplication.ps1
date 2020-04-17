function New-FODApplication {
    <#
    .SYNOPSIS
        Creates a new FOD application.

    .DESCRIPTION
        Creates a new FOD application.

    .PARAMETER Name
        Application Name.

    .PARAMETER Description
        Application Description.

    .PARAMETER Type
        Application Type.

    .PARAMETER ReleaseName
        Release Name.

    .PARAMETER ReleaseDescription
        Release Description.

    .PARAMETER EmailList
        Email List

    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.

    .PARAMETER Token
        FOD token to use.

        If empty, the value from PS4FOD will be used.

    .PARAMETER Proxy
        Proxy server to use.

        Default value is the value set by Set-FODConfig

    .EXAMPLE

        Get-FODApplications -Paging

        # Get all of the applications in the system through Paging

     .EXAMPLE

        Get-FODApplications -Filters "applicationName:myApp1|myApp2"

        # Get the applications "myapp1" or "myApp2"

    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetApplications

    .FUNCTIONALITY
        Fortify on Demand
    #>
    [cmdletbinding()]
    param (
        [PSTypeName('PS4FOD.ApplicationObject')]
        [parameter(ParameterSetName = 'FODApplicationObject',
                ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $Application,

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
        if ($Proxy)
        {
            $Params.Proxy = $Proxy
        }
        Write-Verbose "Send-FODApplication Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawApplication = @()
    }
    process
    {
        $params = @{
            Body = $Application
        }
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/applications'"
        $RawApplication = Send-FODApi -Method Post -Operation "/api/v3/applications" @params
    }
    end {
        if ($Raw) {
            $RawApplication
        } else {
            Parse-FODApplication -InputObject $RawApplication
        }
    }
}
