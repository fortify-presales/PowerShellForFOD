# Enums
Enum RemediationScanPreferenceType {
    RemediationScanIfAvailable = 0
    RemediationScanOnly = 1
    NonRemediationScanOnly = 2
}
Enum EntitlementPreferenceType {
    SingleScanOnly = 1
    SubscriptionOnly = 2
    SingleScanFirstThenSubscription = 3
    SubscriptionFirstThenSingleScan = 4
}
Enum EntitlementFrequencyType {
    SingleScan = 1
    Subscription = 2
}
Enum InProgressScanActionType {
    DoNotStartScan = 0
    CancelScanInProgress = 1
    Queue = 2
}
Enum DynamicScanAssessmentType {
    DynamicWebsite = 119
    DynamicPlusWebsite = 120
    DynamicWebServices = 125
    DynamicPlusWebServices = 126
}
