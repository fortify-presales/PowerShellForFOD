# Parse user application access
function Parse-FODUserApplicationAccess
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($UserApplicationAccess in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.UserApplicationAccessObject'
            applicationId = $UserApplicationAccess.applicationId
            applicationName = $UserApplicationAccess.applicationName
            userId = $UserApplicationAccess.userGroupId
            accessMethod = $UserApplicationAccess.accessMethod
            Raw = $UserApplicationAccess
        }
    }
}
