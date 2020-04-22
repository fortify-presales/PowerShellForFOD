function New-FODApplicationObject
{
    <#
    .SYNOPSIS
        Construct a new FOD Application Object.
    .DESCRIPTION
        Construct a new FOD Application Object.
        Note that this does not physically add the application in FOD.
        It constructs an application object to add with the Add-FODApplication function.
    .PARAMETER Id
        The Id of the application.
        Note: you do not need to set this parameter to add a new application, it is used to store the id
        of a previously created application when this is object is used for Get-FODApplication/Get-FODApplications.
    .PARAMETER Name
        The Name of the application.
    .PARAMETER Description
        The Description of the application.
        Optional.
    .PARAMETER Type
        The Type of the application.
        Allowed values are 'Web_Thick_Client' or 'Mobile'.
    .PARAMETER BusinessCriticality
        The Business Criticality of the application.
        Valid values are 'High', 'Medium' or 'Low'.
    .PARAMETER ReleaseName
        The name of the initial Release to create for the application.
    .PARAMETER ReleaseDescription
        The Description of the release.
        Optional.
    .PARAMETER SDLCStatus
        The SDLC status of the release.
        Valid values are 'Development', 'QA', 'Production' or 'Retired'.
    .PARAMETER EmailList
        Comma separated list of email addresses to send notifications to.
        Optional.
    .PARAMETER HasMicroservices
        Whether the application contains Microservices.
        Default is false.
    .PARAMETER MicroServices
        Collection of PS4FOD.MicroserviceObject's containing the release names of all
        Microservices associated to the application.
        Optional.
    .PARAMETER ReleaseMicroserviceName
        The name of the Microservice to be associated with the release.
        Optional.
    .PARAMETER OwnerId
        The id of the owner of the application. The "Owner" receives all email notifications
        related to this application.
    .PARAMETER Attributes
        Collection of PS4FOD.AttributeObject's containing key/value pairs.
        Optional but some attributes may have been made mandatory for your tenant.
    .PARAMETER UserGroups
        Collection of PS4FOD.UserGroupObject's containing user id's that should have access
        to this application.
        Optional.
    .EXAMPLE
        New-FODApplicationObject -Name "apitest1" -Description "its description"
            -Type "Web_Thick_Client" -BusinessCriticality "Low"
            -ReleaseName 1.0 -ReleaseDescription "its description" -SDLCStatus "Development"
            -HasMicroservices $false -OwnerId 9444 -Attributes $attributes
    .FUNCTIONALITY
        Fortify on Demand
    #>
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
        [bool]$HasMicroservices = $False,

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
        $Attributes,

        [Parameter(Mandatory=$false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.UserGroupObject')]
        [System.Collections.Hashtable[]]
        $UserGroups

    )
    begin
    {
        $AllMicroservices = @()
        $AllUserGroups = @()
        $AllAttributes = @()
        Write-Verbose "New-FODApplicationObject Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {
        foreach ($MicroService in $Microservices) {
            $AllMicroservices += $MicroService
        }
        foreach ($UserGroup in $UserGroups) {
            $AllUserGroups += $UserGroup
        }
        foreach ($Attribute in $Attributes) {
            $AllAttributes += $Attribute
        }
    }
    end
    {
        $body = @{ }

        switch ($psboundparameters.keys) {
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

            'userGroupIds'              { $body.userGroupIds = @($AllUserGroups)}

            'attributes'                { $body.attributes = @($AllAttributes) }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.ApplicationObject
    }
}
