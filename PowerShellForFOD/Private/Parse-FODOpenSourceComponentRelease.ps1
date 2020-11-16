# Parse open source component release
function Parse-FODOpenSourceComponentRelease
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Release in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.OpenSourceComponentReleaseObject'
            applicationId = $Release.applicationId
            applicationName = $Release.applicationName
            releaseId = $Release.releaseId
            releaseName = $Release.releaseName
            Raw = $Release
        }
    }
}
