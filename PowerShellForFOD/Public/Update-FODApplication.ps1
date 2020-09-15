function Update-FODApplication {
    <#
    .SYNOPSIS
        Updates a specific FOD application.
    .DESCRIPTION
        Updates a specific FOD application.
    .PARAMETER Id
        The id of the application.
    .PARAMETER Application
        A PS4FOD.ApplicationObject containing the application's values.
        Note: only the following fields can/will be updated:
            - applicationName
            - applicationDescription
            - emailList
            - attributes
            - businessCriticalityType
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Update the application with id 100
        Update-FODApplication -Id 100 -Application $applicationObj
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_PutApplication
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$Id,

        [PSTypeName('PS4FOD.ApplicationObject')]
        [parameter(ParameterSetName = 'FODApplicationObject',
            ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $Application,

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
        Write-Verbose "Update-FODApplication Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawResponse = $null
    }
    process
    {
        $Params = @{
            Body = $Application
        }
        Write-Verbose "Send-FODApi: -Method Put -Operation '/api/v3/applications/$Id'"
        $RawResponse = Send-FODApi -Method Put -Operation "/api/v3/applications/$Id" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
