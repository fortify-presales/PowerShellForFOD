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
    .PARAMETER CopyState
        Copy the state of an existing release.
        Default is $False.
    .PARAMETER CopyReleaseId
        The Id of the release to copy.
        Optional.
    .PARAMETER SDLCStatus
        The SDLC status of the release.
        Valid values are 'Development', 'QA', 'Production' or 'Retired'.
    .PARAMETER Microservice
        The PS4FOD.MicroserviceObject that the release is related to.
        Optional.
    .EXAMPLE
        # Create the ReleaseObject
        $relObject = New-FODReleaseObject -Name "1.0" -Description "its description" `
            -CopyState $true -CopyReleaseId 100 -SDLCStatus 'Development'
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

        [switch]$CopyState,

        [int]$CopyReleaseId,

        [validateset('Development', 'QA', 'Production', 'Retired')]
        [string]$SDLCStatus,

        [int]$OwnerId,

        [Parameter(Mandatory = $false,
                ValueFromPipeline = $true)]
        [PSTypeName('PS4FOD.MicroServiceObject')]
        $MicroService
    )
    begin
    {
        if ($CopyState -and -not $CopyReleaseId) {
            throw "A value for CopyReleaseId is required id CopyState is selected"
        }
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
            'name'                  { $body.releaseName = $Name }
            'description'           { $body.releaseDescription = $Description }
            'copyState'             {
                if ($CopyState) { $body.copyState = $true }
                else { $body.copyState = $false }
            }
            'copyReleaseId'         { $body.copyStateReleaseId = $CopyReleaseId }
            'sdlcStatus'            { $body.sdlcStatusType = $SDLCStatus }
            'microservice'          { $body.microserviceId = $MicroService.Id }
            'ownerId'                   { $body.ownerId = $OwnerId }
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.ReleaseObject
    }
}
