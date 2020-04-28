# Parse scan
function Parse-FODScan
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Scan in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ScanObject'
            applicationId = $Scan.applicationId
            applicationName = $Scan.applicationName
            releaseId = $Scan.releaseId
            releaseName = $Scan.releaseName
            scanId = $Scan.scanId
            scanTypeId = $Scan.scanTypeId
            scanType = $Scan.scanType
            assessmentTypeId = $Scan.assessmentTypeId
            assessmentTypeName = $Scan.assessmentTypeName
            analysisStatusTypeId = $Scan.analysisStatusTypeId
            analysisStatusType = $Scan.analysisStatusType
            startedDateTime = $Scan.startedDateTime
            completedDateTime = $Scan.completedDateTime
            totalIssues = $Scan.totalIssues
            issueCountCritical = $Scan.issueCountCritical
            issueCountHigh = $Scan.issueCountHigh
            issueCountMedium = $Scan.issueCountMedium
            issueCountLow = $Scan.issueCountLow
            starRating = $Scan.starRating
            notes = $Scan.notes
            isFalsePositiveChallenge = $Scan.isFalsePositiveChallenge
            isRemediationScan = $Scan.isRemediationScan
            entitlementId = $Scan.entitlementId
            entitlementUnitsConsumed = $Scan.entitlementUnitsConsumed
            isSubscriptionEntitlement = $Scan.isSubscriptionEntitlement
            pauseDetails = Parse-FODScanPauseDetail $Scan.pauseDetails
            cancelReason = $Scan.cancelReason
            analysisStatusReasonNotes = $Scan.analysisStatusReasonNotes
            scanMethodTypeId = $Scan.scanMethodTypeId
            scanMethodTypeName = $Scan.scanMethodTypeName
            scanTool = $Scan.scanTool
            scanToolVersion = $Scan.scanToolVersion
            Raw = $Scan
        }
    }
}
