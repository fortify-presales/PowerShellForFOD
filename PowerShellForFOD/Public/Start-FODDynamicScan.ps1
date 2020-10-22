function Start-FODDynamicScan {
    <#
    .SYNOPSIS
        Starts a dynamic scan in FOD.
    .DESCRIPTION
        Starts a previously configured Fortify On Demand dynamic scan.
    .PARAMETER ReleaseId
        The Id of the release to start the scan for.
    .PARAMETER ApplicationName
        The Name of the application to start the scan for.
    .PARAMETER ReleaseName
        The Name of the release to start the scan for.
        Note: Both ApplicationName and ReleaseName are required if not specifying ReleaseId
    .PARAMETER EntitlementId
        The Fortify on Demand Entitlement Id, found in "Administration, Entitlements"
    .PARAMETER AssessmentType
        The type of assessment to be carried out.
        Valid Values are: DynamicWebsite, DynamicPlusWebsite, DynamicWebServices, DynamicPlusWebServices
    .PARAMETER IsRemediationScan
        Select to force a remediation scan.
    .PARAMETER EntitlementFrequency
        The entitlement frequency type.
        Valid values are: SingleScan, Subscription
    .PARAMETER Notes
        Any notes to be included with the scan.
        Optional. Not currently used.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Starts a dynamic scan for release id 1000
        Start-FODDynamicScan -ReleaseId 1000 -AssessmentType DynamicWebsite -EntitlementId 1000 `
            -EntitlementFrequency SingleScan -Notes "some notes"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/DynamicScans/DynamicScansV3_StartDynamicScan
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [int]$ReleaseId,

        [Parameter(Mandatory=$False)]
        [string]$ApplicationName,

        [Parameter(Mandatory=$False)]
        [string]$ReleaseName,

        [Parameter()]
        [int]$EntitlementId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('DynamicWebsite', 'DynamicPlusWebsite', 'DynamicWebServices', 'DynamicPlusWebServices', IgnoreCase = $false)]
        $AssessmentType,

        [Parameter()]
        [switch]$IsRemediationScan,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('SingleScan', 'Subscription', IgnoreCase = $false)]
        $EntitlementFrequency,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Notes,

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
        # If we don't have a ReleaseId we have to find it using API
        if (-not ($PSBoundParameters.ContainsKey('ReleaseId') -or $PSBoundParameters.ContainsKey('BSIToken'))) {
            if ($PSBoundParameters.ContainsKey('ApplicationName') -and $PSBoundParameters.ContainsKey('ReleaseName')) {
                try {
                    $ReleaseId = Get-FODReleaseId -ApplicationName $ApplicationName -ReleaseName $ReleaseName
                    Write-Verbose "Found Release Id: $ReleaseId"
                } catch {
                    Write-Error $_
                    Break
                }
            } else {
                throw "Please supply a parameter for `"BSIToken`", `"ReleaseId`" or both `"ApplicationName`" and `"ReleaseName`""
            }
        }

        # Get current module version
        $myModuleName = "PowerShellForFOD"
        $module = Get-Module -ListAvailable -Name $myModuleName
        $myModuleVer = $module.Version
        if ([string]::IsNullOrEmpty($myModuleVer)) { $myModuleVer = "1.0.0.0" }

        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }

        $ScanDetails = @{}
        $ScanDetails.Add("startDate", (Get-Date -Format s))
        $ScanDetails.Add("assessmentTypeId", [DynamicScanAssessmentType]::$AssessmentType.value__)
        $ScanDetails.Add("entitlementId", $EntitlementId)
        $ScanDetails.Add("entitlementFrequencyType", $EntitlementFrequency)
        $ScanDetails.Add("isRemediationScan", $IsRemediationScan.IsPresent)
        $ScanDetails.Add("isBundledAssessment", $True)
        $ScanDetails.Add("parentAssessmentTypeId", 0)
        $ScanDetails.Add("applyPreviousScanSettings", $True)
        $ScanDetails.Add("scanMethodType", "CICD")
        $ScanDetails.Add("scanTool", $myModuleName)
        $ScanDetails.Add("scanToolVersion", $myModuleVer)

        Write-Verbose "Start-FODDynamicScan Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = $null
    }
    process
    {
        $Params.Body = $ScanDetails
        Write-Verbose "Send-FODApi: -Method Post -Operation 'POST /api/v3/releases/$ReleaseId/dynamic-scans/start-scan'"
        $Response = Send-FODApi -Method Post -Operation "/api/v3/releases/$ReleaseId/dynamic-scans/start-scan" @Params
    }
    end {
        if ($Raw) {
            $Response
        } else {
            $ScanId = $Response.scanId
            If ($ScanId) {
                Write-Host "Started dynamic scan with scan id: $ScanId"
            } else {
                Write-Error "Could not extract scan id!"
            }
        }
    }
}
