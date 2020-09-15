function Get-FODApplication {
    <#
    .SYNOPSIS
        Get information about a specific FOD application.
    .DESCRIPTION
        Get information about a specific FOD application.
    .PARAMETER Id
        The id of the application.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get the application with id 100
        Get-FODApplication -Id 100
    .EXAMPLE
        # Get the application with name "FOD-TEST" using "Get-FODApplicationId" in pipeline
        Get-FODApplicationId -ApplicationName FOD-TEST | Get-FODApplication
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetApplication
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
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
        Write-Verbose "Get-FODApplication Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawApplication = $null
    }
    process
    {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/applications/$Id'" #$Params
            $RawApplication = Send-FODApi -Method Get -Operation "/api/v3/applications/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawApplication
        } else {
            Parse-FODApplication -InputObject $RawApplication
        }
    }
}
