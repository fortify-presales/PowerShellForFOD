# Parse open source component
function Parse-FODOpenSourceComponent
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Component in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.OpenSourceComponentObject'
            componentHash = $Component.componentHash
            componentName = $Component.componentName
            componentVersionName = $Component.componentVersionName
            licenses = Parse-FODOpenSourceComponentLicense $Component.licenses
            vulnerabilityCounts = Parse-FODVulnerabilityCount $Component.vulnerabilityCounts
            releases = Parse-FODOpenSourceComponentRelease $Component.releases
            Raw = $Component
        }
    }
}
