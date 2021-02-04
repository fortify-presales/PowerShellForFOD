function New-FODMicroServiceObject
{
    <#
    .SYNOPSIS
        Construct a new FOD Microservice Object.
    .DESCRIPTION
        Construct a new FOD Microservice Object.
        Note that this does not physically add the Microservice in FOD.
        It constructs a microservice object to add with the Add-FODMicroservice function or refers to
        an existing microservice object to passed into the Add-FODApplication function.
    .PARAMETER Id
        The Id of the microservice.
        Note: you do not need to set this parameter to add a new microservice, it is used to store the id
        of a previously created microservice when this is object is used for Get-FODMicroservice/Get-FODMicroservices.
    .PARAMETER Name
        The Name of the microservice.
    .EXAMPLE
        # This is a simple example illustrating how to create a microservice object.
        $myMs1 = New-FODMicroserviceObject -Id 22 -Name "microservice1"
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[String])]
    param
    (
        [int]$Id,
        [string]$Name,
        [int]$ReleaseId
    )
    begin
    {
        Write-Verbose "New-FODMicroserviceObject Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
    }
    process
    {

    }
    end
    {
        $body = @{ }

        switch ($psboundparameters.keys)
        {
            'id'        { $body.id = $Id }
            'name'      { $body.name = $Name }
            'releaseId' { $body.releaseid = $ReleaseId}
        }

        Add-ObjectDetail -InputObject $body -TypeName PS4FOD.MicroserviceObject
    }
}
