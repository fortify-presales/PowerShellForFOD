# Parse release
function Parse-FODRelease
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Release in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ReleaseObject'
            releaseId = $Release.releaseId
            releaseName = $Release.releaseName
            releaseDescription = $Release.releaseDescription
            releaseCreatedDate = $Release.releaseCreatedDate
            microserviceName = $Release.microserviceName
            microserviceId = $Release.microserviceId
            applicationName = $Release.applicationName
            applicationId = $Release.applicationId
            currentAnalysisStatusTypeId = $Release.currentAnalysisStatusTypeId
            currentAnalysisStatusType = $Release.currentAnalysisStatusType
            rating = $Release.rating
            critical = $Release.critical
            high = $Release.high
            medium = $Release.medium
            low = $Release.low
            currentStaticScanId = $Release.currentStaticScanId
            currentDynamicScanId = $Release.currentDynamicScanId
            currentMobileScanId = $Release.currentMobileScanId
            staticAnalysisStatusType = $Release.staticAnalysisStatusType
            dynamicAnalysisStatusType = $Release.dynamicAnalysisStatusType
            mobileAnalysisStatusType = $Release.mobileAnalysisStatusType
            staticAnalysisStatusTypeId = $Release.staticAnalysisStatusTypeId
            dynamicAnalysisStatusTypeId = $Release.dynamicAnalysisStatusTypeId
            mobileAnalysisStatusTypeId = $Release.mobileAnalysisStatusTypeId
            staticScanDate = $Release.staticScanDate
            dynamicScanDate = $Release.dynamicScanDate
            mobileScanDate = $Release.mobileScanDate
            issueCount = $Release.issueCount
            isPassed = $Release.isPassed
            passFailReasonTypeId = $Release.passFailReasonTypeId
            passFailReasonType = $Release.passFailReasonType
            sdlcStatusTypeId = $Release.sdlcStatusTypeId
            sdlcStatusType = $Release.sdlcStatusType
            ownerId = $Release.ownerId
            Raw = $Release
        }
    }
}
