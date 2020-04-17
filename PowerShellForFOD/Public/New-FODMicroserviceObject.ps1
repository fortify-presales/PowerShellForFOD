function New-FODMicroServiceObject
{

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    Param
    (
        [int]$Id,
        [string]$Name
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
            'id'     { $body.id = $Id }
            'name'   { $body.name = $name }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.MicroserviceObject
    }
}
