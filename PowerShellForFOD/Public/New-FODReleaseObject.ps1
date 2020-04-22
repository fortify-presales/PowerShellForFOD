function New-FODReleaseObject
{
    <#
    .SYNOPSIS
        Construct a new FOD Release Object.
    .DESCRIPTION
        Construct a new FOD Release Object.
        Note that this does not physically add the release in FOD.
        It constructs an release object to add with the Add-FODApplication function.
    .PARAMETER Id
        The Id of the release.
        Note: you do not need to set this parameter to add a new release, it is used to store the id
        of a previously created release when this is object is used for Get-FODRelease/Get-FODReleases
    .PARAMETER ApplicationId
        The Id of the application the release is included in.
    .PARAMETER Name
        The Name of the release.
    .PARAMETER Description
        The Description of the release.
        Optional.
    .PARAMETER Type
        The Type of the release.
        Allowed values are 'Web_Thick_Client' or 'Mobile'.
    .PARAMETER BusinessCriticality
        The Business Criticality of the release.
        Valid values are 'High', 'Medium' or 'Low'.
    .PARAMETER ReleaseName
        The name of the initial Release to create for the release.
    .PARAMETER ReleaseDescription
        The Description of the release.
        Optional.
    .PARAMETER SDLCStatus
        The SDLC status of the release.
        Valid values are 'Development', 'QA', 'Production' or 'Retired'.
    .PARAMETER Microservice
        The PS4FOD.MicroserviceObject that the release is related to.
        Optional.
    .PARAMETER OwnerId
        The id of the owner of the release.
    .EXAMPLE
        # Create the ReleaseObject
        $relObject = New-FODReleaseObject -Name "1.0" -Description "its description" `
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    param
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
    begin
    {
        Write-Verbose "New-FODReleaseObject Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {

    }
    end
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
