function New-FODAttributeObject
{
    <#
    .SYNOPSIS
        Construct a new FOD Attribute Object.
    .DESCRIPTION
        Construct a new FOD Attribute Object.
        Note that this does not physically add the attribute in FOD.
        It constructs an application object to add with the Add-FODAttribute function or refers to
        an existing attribute object to passed into the Add-FODApplication function.
    .PARAMETER Id
        The Id of the attribute.
        Note: you do not need to set this parameter to add a new attribute, it is used to store the id
        of a previously created attribute when this is object is used for Get-FODAttribute/Get-FODAttributes.
    .PARAMETER Name
        The Name of the attribute.
    .PARAMETER Value
        The value of the attribute.
    .EXAMPLE
        # This is a simple example illustrating how to create an attribute object.
        $myAttr1 = New-FODAttributeObject -Id 22 -Value "2751"  # Region attribute id
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    Param
    (
        [int]$Id,
        [string]$Name,
        [string]$Value
    )
    Begin
    {

    }
    Process
    {

    }
    End
    {
        $body = @{ }

        switch ($psboundparameters.keys)
        {
            'id'        { $body.id = $Id }
            'name'      { $body.name = $Name }
            'value'     { $body.value = $Value }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.AttributeObject
    }
}
