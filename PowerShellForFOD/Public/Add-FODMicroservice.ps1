function Add-FODMicroservice {
    <#
    .SYNOPSIS
        Adds a new microservice to an FOD application.
    .DESCRIPTION
        Adds a new microservice using the FOD REST API to a previously created application.
    .PARAMETER ApplicationId
        The id of the application to add the microservice to.
    .PARAMETER Name
        The name of the microservice to add.
    .PARAMETER Raw
        Print Raw output - do not convert into ReleaseObject.
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
        # Add a new microservice named "Microservice 1" to application with id 1234
        Add-FODMicroservice -ApplicationId 1234 -Name "Microservice 1"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_PostApplicationMicroservice
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [int]$ApplicationId,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

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
        $Body = @{
            microservicename = $Name
        }
        Write-Verbose "Add-FODMicroservice Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawMicroservice = @()
    }
    process
    {
        Write-Verbose "Send-FODApi: -Method Post -Operation 'POST /api/v3/applications/$ApplicationId/microservices'"
        $RawMicroservice = Send-FODApi -Method Post -Operation "/api/v3/applications/$ApplicationId/microservices" -Body $Body @Params
    }
    end {
        if ($Raw) {
            $RawMicroservice
        } else {
            Parse-FODMicroservice -InputObject $RawMicroservice
        }
    }
}
