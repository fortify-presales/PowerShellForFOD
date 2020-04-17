function New-FODApplicationObject
{

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    Param
    (
        [int]$Id,

        [string]$Name,

        [string]$Description,

        [validateset('Web_Thick_Client', 'Mobile')]
        [string]$Type,

        [validateset('High', 'Medium', 'Low')]
        [string]$BusinessCriticality,

        [string]$ReleaseName,

        [string]$ReleaseDescription,

        [validateset('Development', 'QA', 'Production', 'Retired')]
        [string]$SDLCStatus,

        [string]$EmailList,

        [validateset($True, $False)]
        [bool]$HasMicroservices,

        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.MicroserviceObject')]
        [System.Collections.Hashtable[]]
        $MicroServices,

        [string]$ReleaseMicroserviceName,

        [int]$OwnerId,

        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.AttributeObject')]
        [System.Collections.Hashtable[]]
        $Attributes

    #        [Parameter(Mandatory=$false,
    #            ValueFromPipeline = $true)]
    #        [PSTypeName('PS4FOD.UserGroup')]
    #        [System.Collections.Hashtable[]]
    #        $UserGroups

    )
    Begin
    {
        $AllMicroservices = @()
        #        $AllUserGroups = @()
        $AllAttributes = @()

    }
    Process
    {
        foreach ($MicroService in $Microservices)
        {
            $AllMicroservices += $MicroService
        }
        #        foreach ($UserGroup in $UserGroups)
        #        {
        #            $AllUserGroups += $UserGroup
        #        }
        foreach ($Attribute in $Attributes)
        {
            $AllAttributes += $Attribute
        }
    }
    End
    {
        $body = @{ }

        switch ($psboundparameters.keys)
        {
            'id'                        { $body.applicationId = $Id }
            'name'                      { $body.applicationName = $Name }
            'description'               { $body.applicationDescription = $Description }
            'type'                      { $body.applicationType = $Type }
            'businessCriticality'       { $body.businessCriticalityType = $BusinessCriticality }
            'user'                      { $body.ownerId = $User.Id }
            'emailList'                 { $body.emailList = $EmailList }

            'hasMicroservices'          { $body.hasMicroservices = $HasMicroservices }
            'microservices'             { $body.microservices = @($AllMicroServices) }
            'releaseMicroserviceName'   { $body.releaseMicroserviceName = $releaseMicroserviceName }

            'releaseName'               { $body.releaseName = $ReleaseName }
            'releaseDescription'        { $body.releaseDescription = $ReleaseDescription }
            'sdlcStatus'                { $body.sdlcStatusType = $SDLCStatus }

            'ownerId'                   { $body.ownerId = $OwnerId }

            #            'userGroupIds'              { $body.userGroupIds            = @($AllUserGroups)}

            'attributes'                { $body.attributes = @($AllAttributes) }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.ApplicationObject
    }
}
