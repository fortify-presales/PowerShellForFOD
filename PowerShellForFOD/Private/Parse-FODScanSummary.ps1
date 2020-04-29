# Parse scan summary
function Parse-FODScanSummary
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($ScanSummary in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ScanSummaryObject'
            startedByUserId = $ScanSummary.startedByUserId
            startedByUserName = $ScanSummary.startedByUserName
            dynamicScanSummaryDetails = Parse-FODDynamicScanSummaryDetail $ScanSummary.dynamicScanSummaryDetails
            mobileScanSummaryDetails = Parse-FODMobileScanSummaryDetail $ScanSummary.mobileScanSummaryDetails
            staticScanSummaryDetails = Parse-FODStaticScanSummaryDetail $ScanSummary.staticScanSummaryDetails
            applicationId = $ScanSummary.applicationId
            applicationName = $ScanSummary.applicationName
            releaseId = $ScanSummary.releaseId
            releaseName = $ScanSummary.releaseName
            scanId = $ScanSummary.scanId
            scanTypeId = $ScanSummary.scanTypeId
            scanType = $ScanSummary.scanType
            assessmentTypeId = $ScanSummary.assessmentTypeId
            assessmentTypeName = $ScanSummary.assessmentTypeName
            analysisStatusTypeId = $ScanSummary.analysisStatusTypeId
            analysisStatusType = $ScanSummary.analysisStatusType
            startedDateTime = $ScanSummary.startedDateTime
            completedDateTime = $ScanSummary.completedDateTime
            totalIssues = $ScanSummary.totalIssues
            issueCountCritical = $ScanSummary.issueCountCritical
            issueCountHigh = $ScanSummary.issueCountHigh
            issueCountMedium = $ScanSummary.issueCountMedium
            issueCountLow = $ScanSummary.issueCountLow
            starRating = $ScanSummary.starRating
            notes = $ScanSummary.notes
            isFalsePositiveChallenge = $ScanSummary.isFalsePositiveChallenge
            isRemediationScanSummary = $ScanSummary.isRemediationScanSummary
            entitlementId = $ScanSummary.entitlementId
            entitlementUnitsConsumed = $ScanSummary.entitlementUnitsConsumed
            isSubscriptionEntitlement = $ScanSummary.isSubscriptionEntitlement
            pauseDetails = Parse-FODScanPauseDetail $ScanSummary.pauseDetails
            cancelReason = $ScanSummary.cancelReason
            analysisStatusReasonNotes = $ScanSummary.analysisStatusReasonNotes
            scanMethodTypeId = $ScanSummary.scanMethodTypeId
            scanMethodTypeName = $ScanSummary.scanMethodTypeName
            scanTool = $ScanSummary.scanTool
            scanToolVersion = $ScanSummary.scanToolVersion
            Raw = $ScanSummary
        }
    }
}
