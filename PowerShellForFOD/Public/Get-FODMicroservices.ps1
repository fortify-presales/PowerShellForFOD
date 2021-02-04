function Get-FODMicroServices {
    <#
    .SYNOPSIS
        Get information about FOD Microservices.
    .DESCRIPTION
        Get information about FOD Microservices.
    .PARAMETER ApplicationId
        The Id of the Application to get Microservices for.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get all of the microservices for Application with id 1234
        Get-FODMicroservices -ApplicationId 1234
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetApplicationMicroservices
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApplicationId,

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
        Write-Verbose "Get-FODMicroservices Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{}
        $RawMicroservices = @()
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/applications/$ApplicationId/microservices'" #$Params
        $Response = Send-FODApi -Method Get -Operation "/api/v3/applications/$ApplicationId/microservices" @Params
        $RawMicroservices = $Response.items
    }
    end {
        if ($Raw) {
            $RawMicroservices
        } else {
            Parse-FODMicroservice -InputObject $RawMicroservices
        }
    }
}
