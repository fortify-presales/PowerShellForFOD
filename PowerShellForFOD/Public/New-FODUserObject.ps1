function New-FODUserObject
{
    <#
    .SYNOPSIS
        Construct a new FOD User Object.
    .DESCRIPTION
        Construct a new FOD User Object.
        Note that this does not physically add the user in FOD.
        It constructs a user object to add with the Add-FODUser function or refers to
        an existing user object to passed into the Add-FODUser function.
    .PARAMETER Id
        The Id of the user.
        Note: you do not need to set this parameter to add a new user, it is used to store the id
        of a previously created user when this is object is used for Get-FODUser/Get-FODUsers.
    .PARAMETER Username
        The username of the user.
    .PARAMTER Password
        The default password for the user.
    .PARAMETER Firstname
        The first name of the user.
    .PARAMETER Lastname
        The last name of the user.
    .PARMETER Email
        The email address of the user.
    .PARMETER PhoneNumber
        The phone number of the user.
    .PARAMETER RoleId
        The role id of the user.
    .PARMETER PasswordNeverExpires
        Select to enable a non-expiring password for the user.
    .PARAMETER MustChange
        Select to force the user to change their password on login.
    .PARAMETER IsVerified
        Whether the user has been verified or not.
    .PARAMETER IsSuspended
        Whether the user has been suspended or not.
    .EXAMPLE
        # This is a simple example illustrating how to create a user object.
        $myUser1 = New-FODUserObject -Username "user1" -FirstName "Test" -LastName "User" `
            -Email "user1@mydomain.com" -PhoneNumber "0123456789" -RoleId 0
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    param
    (
        [int]$Id,
        [string]$Username,
        [string]$Password,
        [string]$FirstName,
        [string]$LastName,
        [string]$Email,
        [string]$PhoneNumber,
        [int]$RoleId,
        [switch]$PasswordNeverExpires,
        [switch]$MustChange,
        [validateset($True, $False)]
        [switch]$IsVerified,
        [validateset($True, $False)]
        [switch]$IsSuspended
    )
    begin
    {
        Write-Verbose "New-FODUserObject Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {

    }
    end
    {
        $body = @{}

        switch ($psboundparameters.keys) {
            'userId'                { $body.userId                  = $userId }
            'userName'              { $body.userName                = $userName }
            'password'              { $body.password                = $password }
            'firstName'             { $body.firstName               = $firstName }
            'lastName'              { $body.lastName                = $lastName }
            'email'                 { $body.email                   = $email }
            'phoneNumber'           { $body.phoneNumber             = $phoneNumber }
            'roleId'                { $body.roleId                  = $roleId }
            'roleName'              { $body.roleName                = $roleName }
            'passwordNeverExpires'  {
                if ($PasswordNeverExpires) {
                    $body.passwordNeverExpires = $true
                } else {
                    $body.passwordNeverExpires = $false
                }
            }
            'mustChange'            {
                if ($MustChange) {
                    $body.mustChange = $true
                } else {
                    $body.mustChange = $false
                }
            }
            'isVerified'            { $body.isVerified              = $isSuspended }
            'isSuspended'           { $body.isSuspended             = $isSuspended }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.UserObject
    }
}
