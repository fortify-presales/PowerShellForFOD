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
    .PARAMETER EntitlementPreference
        Select the entitlement preference. If multiple entitlements are available, the scan will use the oldest entitlement.
        If the release has an active subscription, the scan will use the active subscription.
        Valid values are: SingleScan, Subscription.
    .PARAMETER PurchaseEntitlements
         Select to purchase an entitlement if none is available for the specified entitlement preference.
         If the purchase entitlements feature is not enabled for the tenant, the logs will display an error message.
         Optional.
    .PARAMETER PreferRemediation
         Select to run a remediation scan if one is available.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Starts a single dynamic scan for release id 1000
        Start-FODDynamicScan -ReleaseId 1000 -AssessmentType -EntitlementPreference SingleScan
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

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('SingleScan', 'Subscription', IgnoreCase = $false)]
        $EntitlementPreference,

        [Parameter()]
        [switch]$PurchaseEntitlements,

        [Parameter()]
        [switch]$PreferRemediation,

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
        $EntitlementId = -1
        $EntitlementFrequencyTypeId = 1
        $EntitlementPreferenceId = 0
        $AssessmentTypeId = 0

        if ($EntitlementPreference -eq 'SingleScan') {
            $EntitlementPreferenceId = 1
        } elseif ($EntitlementPreference -eq 'Subscription') {
            $EntitlementPreferenceId = 2
        } else {
            throw "Invalid Scan Preference!"
        }

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
                throw "Please supply a parameter for `"ReleaseId`" or both `"ApplicationName`" and `"ReleaseName`""
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
        $ScanDetails.Add("scanMethodType", "CICD")
        $ScanDetails.Add("scanTool", $myModuleName)
        $ScanDetails.Add("scanToolVersion", $myModuleVer)

        Write-Verbose "Start-FODDynamicScan Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $Response = $null
    }
    process
    {
        $RelAssTypes = @()      # all of the possible assessment types for the release
        $SelectedRat = $null    # the assessment type selected from the logic below

        # get the scan setup so we can get assessment type id
        $ScanSetup = Get-FODDynamicScanSetup -ReleaseId $ReleaseId
        $AssessmentTypeId = $ScanSetup.assessmentTypeId

        # get all of the possible release assessment types
        $RelAssTypes = Get-FODReleaseAssessmentTypes -ReleaseId $ReleaseId -ScanType "Dynamic"
        if ($RelAssTypes) {
            Write-Host "Validating entitlements..."
            # check if a remediation scan entitlement is available
            if ($PreferRemediation) {
                $SelectedRat = ($RelAssTypes | Where-Object { $_.entitlementId -gt 0 -and $_.isRemediation -eq $True -and $_.remediationScansAvailable -gt 0 }) | Select-Object -First 1
                if ($SelectedRat) {
                    Write-Host "Running remediation scan using entitlement: '$($SelectedRat.entitlementDescription)'"
                    $ScanDetails.Add("isRemediationScan", $True)
                    $EntitlementId = $SelectedRat.entitlementId
                    $EntitlementFrequencyTypeId = $SelectedRat.frequencyTypeId
                } else  {
                    Write-Host "No remediation scan entitlement found, checking for other entitlements..."
                }
            } else {
                # check for in use subscription even if the user selected SingleScan
                $SelectedRat = ($RelAssTypes | Where-Object { $_.entitlementId -gt 0 -and $_.frequencyTypeId -eq 2 -and $_.subscriptionEndDate -ne $null }) | Select-Object -First 1
                if ($SelectedRat) {
                    Write-Host "Running subscription scan using entitlement: '$($SelectedRat.entitlementDescription)'"
                    $EntitlementId = $SelectedRat.entitlementId
                    $EntitlementFrequencyTypeId = $SelectedRat.frequencyTypeId
                } else {
                    # check for an entitlement with units available
                    $SelectedRat = ($RelAssTypes | Where-Object { $_.entitlementId -gt 0 -and $_.frequencyTypeId -eq $EntitlementPreferenceId -and $_.unitsAvailable -ge $_.units }) | Select-Object -First 1
                    if ($SelectedRat) {
                        Write-Host "Running scan using entitlement: '$($SelectedRat.entitlementDescription)'"
                        $EntitlementId = $SelectedRat.entitlementId
                        $EntitlementFrequencyTypeId = $SelectedRat.frequencyTypeId
                    }
                }
            }
        }

        # have we got an entitlement to use?
        if ($EntitlementId -le 0 -and -not $PurchaseEntitlements) {
            # no entitlement is available and the user did not select the PurchaseEntitlements option
            throw "Error validating entitlements - no entitlement available!"
        }

        $ScanDetails.Add("assessmentTypeId", $AssessmentTypeId)
        $ScanDetails.Add("isRemediationScan", $PreferRemediation.IsPresent)
        $ScanDetails.Add("entitlementId", $EntitlementId)
        $ScanDetails.Add("entitlementFrequencyType", $EntitlementFrequencyTypeId)

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
                Write-Error "Error starting scan, could not extract scan id!"
            }
        }
    }
}
