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
    .PARAMETER Name
        The Name of the user.
    .EXAMPLE
        # This is a simple example illustrating how to create a microservice object.
        $myUser1 = New-FODUserObject -Id 22 -Name "user1"
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    param
    (
        [int]$Id
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
            'id'         { $body.id       = $Id }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.UserObject
    }
}
