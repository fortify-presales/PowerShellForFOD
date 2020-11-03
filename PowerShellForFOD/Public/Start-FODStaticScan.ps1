function Start-FODStaticScan {
    <#
    .SYNOPSIS
        Starts a static scan in FOD.
    .DESCRIPTION
        Starts a Fortify On Demand static scan by uploading a Zip file with the source code to analyse.
        The scan options (such as lanaguage/technology etc) should have been set and saved in FOD prior
        to executing this function.
    .PARAMETER BSIToken
        The Build Server Integration (BSI) token found in Fortify on Demand Portal.
        Note: The BSI token is being deprecated, please use ReleaseId or ApplicationName and ReleaseName.
    .PARAMETER ReleaseId
        The Id of the release to import into.
    .PARAMETER ApplicationName
        The Name of the application to import into.
    .PARAMETER ReleaseName
        The Name of the release to import into.
        Note: Both ApplicationName and ReleaseName are required if not specifying ReleaseId
    .PARAMETER ZipFile
        The absolute path of the Zip file to upload.
    .PARAMETER IsRemediationScan
        Select to force a remediation scan.
    .PARAMETER EntitlementPreference
        The entitlement preference type.
        Valid values are: SingleScanOnly, SubscriptionOnly, SingleScanFirstThenSubscription, SubscriptionFirstThenSingleScan
    .PARAMETER PurchaseEntitlement
        Select if an entitlement should be purchased if one is not available.
    .PARAMETER RemediationScanPreference
        The remdiation scan preference type.
        Valid values are: RemediationScanIfAvailable, RemediationScanOnly, NonRemediationScanOnly
    .PARAMER InProgressScanPreference
        The action to perform if a scan is already running.
        Valid values are: DoNotStartScan, CancelInProgressScan
    .PARAMETER Notes
        Any notes to be included with the scan.
        Optional.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Starts a static scan using the BSI Token $BsiToken and the Zip file "C:\Temp\upload\fod.zip"
        Start-FODStaticScan -BSIToken $BsiToken -ZipFile C:\Temp\upload\fod.zip `
            -RemediationScanPreference NonRemediationScanOnly -EntitlementPreference SubscriptionOnly `
            -InProgressScanPreference DoNotStartScan -Notes "some notes"
    .EXAMPLE
        # Starts a static scan using the release id 1000 and the Zip file "C:\Temp\upload\fod.zip"
        Start-FODStaticScan -ReleaseId 1000 -ZipFile C:\Temp\upload\fod.zip `
            -RemediationScanPreference NonRemediationScanOnly -EntitlementPreference SubscriptionOnly `
            -InProgressScanPreference DoNotStartScan -Notes "some notes"
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/StaticScans/StaticScansV3_StartScanAdvanced
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [string]$BSIToken,

        [Parameter(Mandatory=$False)]
        [int]$ReleaseId,

        [Parameter(Mandatory=$False)]
        [string]$ApplicationName,

        [Parameter(Mandatory=$False)]
        [string]$ReleaseName,

        [Parameter(Mandatory)]
        [system.io.fileinfo]$ZipFile,

        [Parameter()]
        [switch]$IsRemediationScan,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('SingleScanOnly', 'SubscriptionOnly', 'SingleScanFirstThenSubscription', 'SubscriptionFirstThenSingleScan', IgnoreCase = $false)]
        $EntitlementPreference,

        [Parameter()]
        [switch]$PurchaseEntitlement,

        [Parameter(Mandatory)]
        [ValidateSet('RemediationScanIfAvailable', 'RemediationScanOnly', 'NonRemediationScanOnly', IgnoreCase = $false)]
        $RemediationScanPreference,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('DoNotStartScan', 'CancelInProgressScan', 'Queue', IgnoreCase = $false)]
        $InProgressScanPreference,

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

        if (-not $ZipFile.Exists) {
            throw "Zip file '$ZipFile' does not exist"
        }
        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }

        $BSITokenObj = $null
        if ($BSIToken) {
            $BSITokenObj = Parse-FODBSIToken $BSIToken
            if ($BSITokenObj -eq $null) {
                throw "Unable to parse BSI token"
            }
            $ReleaseId = $BSITokenObj.releaseId
        }
        Write-Verbose "Start-FODStaticScan Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"

        $FileLength = $ZipFile.Length
        $Offset = 0
        $FragmentNumber = 0
        $ChunkSize = 1024 * 1024

        # Create temporary file to store payload "chunks" in.
        $TempFile = New-TemporaryFile
        $TempFileName = $TempFile.FullName
        Write-Verbose "Created payload chunk temporary file: $TempFileName"

        $Params.Add('BodyFile', $TempFile.FullName)
        $Params.Add("ContentType", "application/octet-stream")

        $Response = $null
    }
    process
    {
        if ($IsRemediationScan.IsPresent) {
            $RemScanPrefVal = [RemediationScanPreferenceType]::RemediationScanOnly.value__
        }  elseif ($RemediationScanPreference -eq $null) {
            $RemScanPrefVal = [RemediationScanPreferenceType]::NonRemediationScanOnly.value__
        } else {
            $RemScanPrefVal = [RemediationScanPreferenceType]::$RemediationScanPreference.value__
        }
        $ScanPrefix = [string]::Format("/api/v3/releases/{0}/static-scans/start-scan-advanced?" +
            "releaseId={1}&entitlementPreferenceType={2}" +
            "&purchaseEntitlement={3}&remdiationScanPreferenceType={4}" +
            "&inProgressScanActionType={5}&scanTool={6}&scanToolVersion={7}&scanMethodType=CICD",
            $ReleaseId, $ReleaseId,
            [EntitlementPreferenceType]::$EntitlementPreference.value__, $PurchaseEntitlement.IsPresent,
            $RemScanPrefVal, [InProgressScanActionType]::$InProgressScanPreference.value__,
            $myModuleName, $myModuleVer)
        if (-not [string]::IsNullOrEmpty($BSIToken)) {
            $ScanPrefix = [string]::Format("{0}&bsiToken={1}", $ScanPrefix, $BSIToken)
        }
        if (-not [string]::IsNullOrEmpty($Notes)) {
            $ScanPrefix = [string]::Format("{0}&notes={1}", $ScanPrefix, $Notes)
        }

        # Open zip file for reading
        $stream = [System.IO.File]::OpenRead($ZipFile)
        $readByteArray = New-Object byte[] $ChunkSize

        while ($numBytesRead = $stream.Read($readByteArray, 0, $ChunkSize)){
            if ($numBytesRead -lt $ChunkSize) {
                $FragmentNumber = -1
            }
            if ($FragmentNumber -eq -1) {
                Write-Verbose "Sending last fragment"
            } else {
                Write-Verbose "Sending fragment: $FragmentNumber"
            }
            if ($PSVersionTable.PSVersion.Major -lt 6) {
                Set-Content -Path $TempFile.FullName -Value $readByteArray -Encoding Byte
            } else
            {
                Set-Content -Path $TempFile.FullName -Value $readByteArray -AsByteStream
            }
            $ScanUrl = "$ScanPrefix&fragNo=$FragmentNumber&offset=$Offset"
            Write-Verbose "Send-FODApi -Method Post -Operation $ScanUrl" #$Params
            $Response = Send-FODApi -Method Post -Operation $ScanUrl @Params
            $FragmentNumber++
            $Offset += $numBytesRead
            Write-Verbose "Read bytes: $Offset / $FileLength"

            if ($FragmentNumber % 5 -eq 0) {
                Write-Host "Upload Status - Bytes sent: $Offset / $FileLength"
            }

        }
    }
    end {
        # Delete temporary file
        Write-Verbose "Deleting payload data temporary file: $TempFileName"
        $TempFile.Delete()

        if ($Raw) {
            $Response
        } else {
            $ScanId = $Response.scanId
            If ($ScanId) {
                Write-Host "Started static scan with scan id: $ScanId"
            } else {
                Write-Error "Error starting scan, could not extract scan id!"
            }
        }
    }
}
