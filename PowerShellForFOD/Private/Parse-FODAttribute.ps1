# Parse application
function Parse-FODAttribute
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Attribute in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.AttributeObject'
            id = $Attribute.id
            name = $Attribute.name
            value = $Attribute.value
            Raw = $Attribute
        }
    }
}
