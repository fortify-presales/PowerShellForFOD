function Add-FODApplication {
    <#
    .SYNOPSIS
        Adds a new FOD application.
    .DESCRIPTION
        Adds a new FOD application using the FOD REST API and a previously created
        PS4FOD.ApplicationObject.
    .PARAMETER Application
        A PS4FOD.ApplicationObject containing the application's values.
    .PARAMETER Raw
        Print Raw output - do not convert into ApplicationObject.
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
        # Add a new application
        $appResponse = New-FODApplication -Application $appObject
        if ($appResponse) {
            Write-Host "Created application with id:" $appResponse.applicationId
        }
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [PSTypeName('PS4FOD.ApplicationObject')]
        [parameter(ParameterSetName = 'FODApplicationObject',
                ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $Application,

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
        Write-Verbose "Add-FODApplication Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawApplication = @()
    }
    process
    {
        $Params = @{
            Body = $Application
        }
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/applications'"
        $RawApplication = Send-FODApi -Method Post -Operation "/api/v3/applications" @Params
    }
    end {
        if ($Raw) {
            $RawApplication
        } else {
            Parse-FODApplication -InputObject $RawApplication
        }
    }
}
