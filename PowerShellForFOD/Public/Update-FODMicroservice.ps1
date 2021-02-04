function Update-FODMicroservice {
    <#
    .SYNOPSIS
        Updates a specific FOD microservice.
    .DESCRIPTION
        Updates a specific FOD microservice.
    .PARAMETER ApplicationId
        The id of the application the microservice exists in.
    .PARAMETER Id
        The id of the microservice to update
    .PARAMETER Name
        The updated name of the microservice
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Update the microservice with id 100 in application id 1234
        Update-FODMicroservice -ApplicationId 1234 -Id 100 -Name "Updated Micoservice"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_PutApplicationMicroservice
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [int]$ApplicationId,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [int]$Id,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

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
        Write-Verbose "Update-FODMicroservice Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
        $Params = @{}
        $Body = @{
            microservicename = $Name
        }
        Write-Verbose "Send-FODApi: -Method Put -Operation '/api/v3/applications/$ApplicationId/microservices/$Id'"
        $RawResponse = Send-FODApi -Method Put -Operation "/api/v3/applications/$ApplicationId/microservices/$Id" -Body $Body @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
