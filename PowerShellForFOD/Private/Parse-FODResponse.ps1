# Parse application
function Parse-FODResponse
{
    [cmdletbinding()]
    param($InputObject)

    [PSCustomObject]@{
        PSTypeName = 'FOD.ResponseObject'
        success = $InputObject.success
        errors = $InputObject.errors
        Raw = $InputObject
    }
}
