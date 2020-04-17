# Parse application
Function Parse-FODAttribute
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Attribute in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.Attribute'
            id = $Attribute.id
            name = $Attribute.name
            value = $Attribute.value
            Raw = $Attribute
        }
    }
}
