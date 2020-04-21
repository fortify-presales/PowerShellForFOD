# Parse application
function Parse-FODApplication
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Application in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ApplicationObject'
            applicationId = $Application.applicationId
            applicationName = $Application.applicationName
            applicationDescription = $Application.applicationDescription
            applicationCreatedDate = $Application.applicationCreatedDate
            applicationTypeId = $Application.applicationTypeId
            applicationType = $Application.applicationType
            businessCriticalityTypeId = $Application.businessCriticalityTypeId
            businessCriticalityType = $Application.businessCriticalityType
            emailList = $Application.emailList
            hasMicroservices = $Application.hasMicroservices
            attributes = Parse-FODAttribute $Application.attributes
            Raw = $Application
        }
    }
}
