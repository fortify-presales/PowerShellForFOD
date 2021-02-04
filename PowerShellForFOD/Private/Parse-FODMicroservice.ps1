# Parse Microservice
function Parse-FODMicroservice
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($Microservice in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.MicroserviceObject'
            id = $Microservice.microserviceId
            name = $Microservice.microserviceName
            releaseId = $Microservice.releaseId
            Raw = $Microservice
        }
    }
}
