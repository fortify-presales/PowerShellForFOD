# Parse mobile scan summary detail
function Parse-FODMobileScanSummaryDetail
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($MobileScanSummaryDetail in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.MobileScanSummaryDetailObject'
            frameworkType = $MobileScanSummaryDetail.frameworkType
            auditPreferenceType = $MobileScanSummaryDetail.auditPreferenceType
            platformType = $MobileScanSummaryDetail.platformType
            identifier = $MobileScanSummaryDetail.identifier
            version = $MobileScanSummaryDetail.version
            userAccountsRequried = $MobileScanSummaryDetail.userAccountsRequried
            accessToWebServices = $MobileScanSummaryDetail.accessToWebServices
            hasExclusions = $MobileScanSummaryDetail.hasExclusions
            hasAvailabilityRestrictions = $MobileScanSummaryDetail.hasAvailabilityRestrictions
            Raw = $MobileScanSummaryDetail
        }
    }
}
