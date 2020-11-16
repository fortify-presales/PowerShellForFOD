# Parse open source component license
function Parse-FODOpenSourceComponentLicense
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($License in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.OpenSourceComponentLicenseObject'
            name = $License.name
            Raw = $License
        }
    }
}
