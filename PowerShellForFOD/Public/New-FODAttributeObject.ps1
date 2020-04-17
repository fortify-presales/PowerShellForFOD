function New-FODAttributeObject
{

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
