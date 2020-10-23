# Parse release assessment type
function Parse-FODReleaseAssessment
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($FODReleaseAssessment in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.FODReleaseAssessmentObject'
            assessmentTypeId = $FODReleaseAssessment.assessmentTypeId
            name = $FODReleaseAssessment.name
            scanType = $FODReleaseAssessment.scanType
            scanTypeId = $FODReleaseAssessment.scanTypeId
            entitlementId = $FODReleaseAssessment.entitlementId
            frequencyType = $FODReleaseAssessment.frequencyType
            frequencyTypeId = $FODReleaseAssessment.frequencyTypeId
            units = $FODReleaseAssessment.units
            unitsAvailable = $FODReleaseAssessment.unitsAvailable
            subscriptionEndDate = $FODReleaseAssessment.subscriptionEndDate
            isRemediation = $FODReleaseAssessment.isRemediation
            remediationScansAvailable = $FODReleaseAssessment.remediationScansAvailable
            isBundledAssessment = $FODReleaseAssessment.isBundledAssessment
            parentAssessmentTypeId = $FODReleaseAssessment.parentAssessmentTypeId
            parentAssessmentTypeName = $FODReleaseAssessment.parentAssessmentTypeName
            parentAssessmentTypeScanType = $FODReleaseAssessment.parentAssessmentTypeScanType
            parentAssessmentTypeScanTypeId = $FODReleaseAssessment.parentAssessmentTypeScanTypeId
            entitlementDescription = $FODReleaseAssessment.entitlementDescription
            Raw = $FODReleaseAssessment
        }
    }
}
