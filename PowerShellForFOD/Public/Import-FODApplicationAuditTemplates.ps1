function Import-FODApplicationAuditTemplates {
    <#
    .SYNOPSIS
        Import the audit templates for a given application.
    .DESCRIPTION
        Import the audit templates for a given application from a file in JSON format.
        The input file can be exported previously with Export-FODApplicationAuditTemplates.
    .PARAMETER Id
        The id of the Application to import the audit template to.
    .PARAMETER FilePath
        The path of the file containing the audit templates.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Import the audit templates for application with id 1000
        Import-FODApplicationAuditTemplates -Id 10000 -FilePath aat-10000.json
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_PutApplicationAuditTemplates
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$Id,

        [Parameter(Mandatory)]
        [ValidateScript( {Test-Path -Path $PSItem -IsValid})]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

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
        if (Test-Path -Path $FilePath -IsValid) {
            $Params.Add('BodyFile', $FilePath)
            $Params.Add("ContentType", "application/json")
        } else {
            throw "Cannot read input file: $FilePath"
        }
        Write-Verbose "Import-FODApplicationAuditTemplates Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {
        Write-Verbose "Send-FODApi: -Method Put -Operation '/api/v3/applications/$Id/audittemplates'" #$Params
        $RawResponse = Send-FODApi -Method Put -Operation "/api/v3/applications/$Id/audittemplates" @Params
    }
    end {
        if ($Raw) {
            $RawResponse
        } else {
            Parse-FODResponse -InputObject $RawResponse
        }
    }
}
