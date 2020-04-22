function New-FODUserGroup
{
    <#
    .SYNOPSIS
        Construct a new FOD UserGroup Object.
    .DESCRIPTION
        Construct a new FOD UserGroup Object.
        Note that this does not physically add the User Group in FOD.
        It constructs a usergroup object to add with the Add-FODUserGroup function or refers to
        an existing usergroup object to passed into the Add-FODApplication function.
    .PARAMETER Id
        The Id of the group.
        Note: you do not need to set this parameter to add a new usergroup, it is used to store the id
        of a previously created usergroup when this is object is used for Get-FODUserGroup/Get-FODUserGroups.
    .PARAMETER Name
        The Name of the usergroup.
    .EXAMPLE
        # This is a simple example illustrating how to create a usergroup object.
        $myUg1 = New-FODUserGroupObject -Id 22 -Name "group1"
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
        Write-Verbose "New-FODUserGroupObject Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
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

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.UserGroupObject
    }
}
