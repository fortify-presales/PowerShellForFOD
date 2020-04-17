function New-FODReleaseObject
{

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    Param
    (
        [int]$Id,
        [int]$ApplicationId,
        [string]$Name,
        [string]$Description,
        [validateset('Development', 'QA', 'Production', 'Retired')]
        [string]$SDLCStatus,
        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.MicroServiceObject')]
        $MicroService,
        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.UserObject')]
        $Owner

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
            'id'                    { $body.id = $Id }
            'applicationId'         { $body.applicationId = $ApplicationId }
            'releaseName'           { $body.releaseName = $Name }
            'releaseDescription'    { $body.releaseDescription = $Description }
            'sdlcStatusType'        { $body.sdlcStatusType = $SDLCStatus }
            'microserviceId'        { $body.microserviceId = $MicroService.Id }
            'ownerId'               { $body.ownerId = $User.Id }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.ReleaseObject
    }
}
