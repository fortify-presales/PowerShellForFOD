# Parse user
function Parse-FODUser
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($User in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.UserObject'
            userId = $User.userId
            userName = $User.userName
            firstName = $User.firstName
            lastName = $User.lastName
            email = $User.email
            phoneNumber = $User.phoneNumber
            isVerified = $User.isVerified
            roleId = $User.roleId
            roleName = $User.roleName
            isSuspended = $User.isSuspended
            mustChange = $User.mustChange
            passwordNeverExpires = $User.passwordNeverExpires
            Raw = $User
        }
    }
}
