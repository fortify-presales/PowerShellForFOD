# Parse user group
function Parse-FODUserGroupApplicationAccess
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($UserGroupApplicationAccess in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.UserGroupApplicationAccessObject'
            applicationId = $UserGroupApplicationAccess.applicationId
            applicationName = $UserGroupApplicationAccess.applicationName
            userGroupId = $UserGroupApplicationAccess.userGroupId
            userGroupName = $UserGroupApplicationAccess.userGroupName
            Raw = $UserGroupApplicationAccess
        }
    }
}
