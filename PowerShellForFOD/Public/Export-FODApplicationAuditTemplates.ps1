function Export-FODApplicationAuditTemplates {
    <#
    .SYNOPSIS
        Exports the audit templates for a given application.
    .DESCRIPTION
        Exports the audit templates for a given application to a file in JSON format.
        The file can subsequently be imported with Import-FODApplicationAuditTemplates.
    .PARAMETER Id
        The id of the Application to retrieve the audit templatea for.
    .PARAMETER ScanType
        The audit templates will be filtered by this type.
        Valid values are: Static, Dynamic, Mobile, OpenSource, All.
    .PARAMETER FilePath
        The path of the file to save the audit templates to.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Export all the audit templates for application with id 1000
        Export-FODApplicationAuditTemplates -Id 1000 -ScanType All -FilePath aat-10000.json
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/Applications/ApplicationsV3_GetAuditTemplates
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$Id,

        [Parameter(Mandatory)]
        [ValidateSet('Static', 'Dynamic', 'Mobile', 'OpenSource', 'All', IgnoreCase = $false)]
        $ScanType,

        [Parameter()]
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
        Write-Verbose "Export-FODApplicationAuditTemplates Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Body = @{ }
        if ($ScanType -and $ScanType -ne 'All') {
            $Body.Add("scanType", $ScanType)
            $Params.Add("Body", $Body)
        }
        $AuditTemplates = New-Object System.Collections.Generic.List[System.Object]
        $AuditTemplateSummary = $null
    }
    process
    {
        if ($ScanType -ne 'All') {
            Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/applications/$Id/audittemplates'" #$Params
            $AuditTemplateSummary = Send-FODApi -Method Get -Operation "/api/v3/applications/$Id/audittemplates" @Params
            $AuditTemplates.Add($AuditTemplateSummary.items)
        } else {
            foreach ($sType in @('Static', 'Dynamic', 'Mobile', 'OpenSource')) {
                $Body = @{
                    "scanType" = $sType
                }
                $Params["Body"] = $Body
                Write-Verbose "Retrieving audit template for scan type: $st"
                Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/applications/$Id/audittemplates'" #$Params
                $AuditTemplateSummary = Send-FODApi -Method Get -Operation "/api/v3/applications/$Id/audittemplates" @Params
                if ($AuditTemplateSummary.items) {
                    $AuditTemplates.Add($AuditTemplateSummary.items)
                }
            }
        }
    }
    end {
        $AuditTemplatesArray = Parse-FODAuditTemplate -InputObject $AuditTemplates.ToArray()
        if ($FilePath) {
            ConvertTo-Json @($AuditTemplatesArray) -Depth 5 | Out-File -FilePath $FilePath
        } else {
            $AuditTemplatesArray
        }
    }
}
