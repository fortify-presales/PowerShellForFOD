# Parse dynamic scan setup
function Parse-FODDynamicScanSetup
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($FODDynamicScanSetup in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.DynamicScanSetupObject'
            geoLocationId = $FODDynamicScanSetup.geoLocationId
            dynamicScanEnvironmentFacingType = $FODDynamicScanSetup.dynamicScanEnvironmentFacingType
            exclusions = $FODDynamicScanSetup.exclusions
            exclusionsList = $FODDynamicScanSetup.exclusionsList
            dynamicScanAuthenticationType = $FODDynamicScanSetup.dynamicScanAuthenticationType
            hasFormsAuthentication = $FODDynamicScanSetup.hasFormsAuthentication
            primaryUserName = $FODDynamicScanSetup.primaryUserName
            primaryUserPassword = $FODDynamicScanSetup.primaryUserPassword
            secondaryUserName = $FODDynamicScanSetup.secondaryUserName
            secondaryUserPassword = $FODDynamicScanSetup.secondaryUserPassword
            otherUserName = $FODDynamicScanSetup.otherUserName
            otherUserPassword = $FODDynamicScanSetup.otherUserPassword
            vpnRequired = $FODDynamicScanSetup.vpnRequired
            vpnUserName = $FODDynamicScanSetup.vpnUserName
            vpnPassword = $FODDynamicScanSetup.vpnPassword
            requiresNetworkAuthentication = $FODDynamicScanSetup.requiresNetworkAuthentication
            networkUserName = $FODDynamicScanSetup.networkUserName
            networkPassword = $FODDynamicScanSetup.networkPassword
            multiFactorAuth = $FODDynamicScanSetup.multiFactorAuth
            multiFactorAuthText = $FODDynamicScanSetup.multiFactorAuthText
            notes = $FODDynamicScanSetup.notes
            requestCall = $FODDynamicScanSetup.requestCall
            whitelistRequired = $FODDynamicScanSetup.whitelistRequired
            whitelistText = $FODDynamicScanSetup.whitelistText
            dynamicSiteURL = $FODDynamicScanSetup.dynamicSiteURL
            timeZone = $FODDynamicScanSetup.timeZone
            blockout = $FODDynamicScanSetup.blockout
            repeatScheduleType = $FODDynamicScanSetup.repeatScheduleType
            assessmentTypeId = $FODDynamicScanSetup.assessmentTypeId
            entitlementId = $FODDynamicScanSetup.entitlementId
            allowFormSubmissions = $FODDynamicScanSetup.allowFormSubmissions
            allowSameHostRedirects = $FODDynamicScanSetup.allowSameHostRedirects
            restrictToDirectoryAndSubdirectories = $FODDynamicScanSetup.restrictToDirectoryAndSubdirectories
            generateWAFVirtualPatch = $FODDynamicScanSetup.generateWAFVirtualPatch
            isWebService = $FODDynamicScanSetup.isWebService
            webServiceType = $FODDynamicScanSetup.webServiceType
            webServiceDescriptorURL = $FODDynamicScanSetup.webServiceDescriptorURL
            webServiceUserName = $FODDynamicScanSetup.webServiceUserName
            webServicePassword = $FODDynamicScanSetup.webServicePassword
            webServiceAPIKey = $FODDynamicScanSetup.webServiceAPIKey
            webServiceAPIPassword = $FODDynamicScanSetup.webServiceAPIPassword
            entitlementFrequencyType = $FODDynamicScanSetup.entitlementFrequencyType
            userAgentType = $FODDynamicScanSetup.userAgentType
            concurrentRequestThreadsType = $FODDynamicScanSetup.concurrentRequestThreadsType
            Raw = $FODDynamicScanSetup
        }
    }
}
