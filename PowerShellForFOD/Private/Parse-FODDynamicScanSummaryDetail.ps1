# Parse dynamic scan summary detail
function Parse-FODDynamicScanSummaryDetail
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($DynamicScanSummaryDetail in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.DynamicScanSummaryDetailObject'
            dynamicSiteURL = $DynamicScanSummaryDetail.dynamicSiteURL
            restrictToDirectoryAndSubdirectories = $DynamicScanSummaryDetail.restrictToDirectoryAndSubdirectories
            allowSameHostRedirects = $DynamicScanSummaryDetail.allowSameHostRedirects
            allowFormSubmissions = $DynamicScanSummaryDetail.allowFormSubmissions
            timeZone = $DynamicScanSummaryDetail.timeZone
            dynamicScanEnvironmentFacingType = $DynamicScanSummaryDetail.dynamicScanEnvironmentFacingType
            hasAvailabilityRestrictions = $DynamicScanSummaryDetail.hasAvailabilityRestrictions
            requestCall = $DynamicScanSummaryDetail.requestCall
            hasFormsAuthentication = $DynamicScanSummaryDetail.hasFormsAuthentication
            isWebService = $DynamicScanSummaryDetail.isWebService
            webServiceType = $DynamicScanSummaryDetail.webServiceType
            userAgentType = $DynamicScanSummaryDetail.userAgentType
            notes = $DynamicScanSummaryDetail.notes
            concurrentRequestThreadsType = $DynamicScanSummaryDetail.concurrentRequestThreadsType
            Raw = $DynamicScanSummaryDetail
        }
    }
}
