# Parse static scan summary detail
function Parse-FODStaticScanSummaryDetail
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($StaticScanSummaryDetail in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.StaticScanSummaryDetailObject'
            technologyStack = $StaticScanSummaryDetail.technologyStack
            languageLevel = $StaticScanSummaryDetail.languageLevel
            doSonatypeScan = $StaticScanSummaryDetail.doSonatypeScan
            auditPreferenceType = $StaticScanSummaryDetail.auditPreferenceType
            excludeThirdPartyLibs = $StaticScanSummaryDetail.excludeThirdPartyLibs
            buildDate = $StaticScanSummaryDetail.buildDate
            rulePackVersion = $StaticScanSummaryDetail.rulePackVersion
            fileCount = $StaticScanSummaryDetail.fileCount
            totalLinesOfCode = $StaticScanSummaryDetail.totalLinesOfCode
            payLoadSize = $StaticScanSummaryDetail.payLoadSize
            staticVulnerabilityFilter = $StaticScanSummaryDetail.staticVulnerabilityFilter
            Raw = $StaticScanSummaryDetail
        }
    }
}
