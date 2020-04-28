# Parse user group
function Parse-FODUserGroup
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($UserGroup in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.UserGroupObject'
            id = $UserGroup.id
            name = $UserGroup.name
            assignedUsersCount = $UserGroup.assignedUsersCount
            assignedApplicationsCount = $UserGroup.assignedApplicationsCount
            Raw = $UserGroup
        }
    }
}
