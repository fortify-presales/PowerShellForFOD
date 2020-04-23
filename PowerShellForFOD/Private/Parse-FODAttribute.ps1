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
            attributeTypeId = $Attribute.attributeTypeId
            attributeType = $Attribute.attributeType
            attributeDataTypeId = $Attribute.attributeDataTypeId
            attributeDataType = $Attribute.attributeDataType
            isRequired = $Attribute.isRequired
            isRestricted = $Attribute.isRestricted
            picklistValues = $Attribute.picklistValues
            Raw = $Attribute
        }
    }
}
