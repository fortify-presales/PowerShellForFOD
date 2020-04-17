function New-FODUserGroup
{

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    Param
    (
        [int]$Id
    )
    Begin
    {

    }
    Process
    {

    }
    End
    {
        $body = @{}

        switch ($psboundparameters.keys) {
            'id'         { $body.id       = $Id }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.UserGroupObject
    }
}
