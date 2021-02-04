function Remove-FODMicroservice {
    <#
    .SYNOPSIS
        Deletes a specific FOD microservice from an application.
    .DESCRIPTION
        Deletes a a specific FOD microservice from an application.
    .PARAMETER ApplicationId
        The id of the application to delete the microservice from.
    .PARAMETER Id
        The id of the microservice.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Remove the microservice with id 100 from application with id 1234
        Remove-FODMicroservice -ApplicationId 1234 -Id 100
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_DeleteApplicationMicroservice
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
        Write-Verbose "Remove-FODApplication Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Delete -Operation '/api/v3/applications/$ApplicationId/microservices/$Id'" #$Params
            $RawResponse = Send-FODApi -Method Delete -Operation "/api/v3/applications/$ApplicationId/microservices/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
