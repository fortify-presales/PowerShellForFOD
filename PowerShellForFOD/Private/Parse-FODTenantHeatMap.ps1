# Parse tenant heat map
function Parse-FODTenantHeatMap
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($TenantHeatMap in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.TenantHeatMapObject'
            starRating = $TenantHeatMap.starRating
            businessCriticalityId = $TenantHeatMap.businessCriticalityId
            businessCriticality = $TenantHeatMap.businessCriticality
            projectCountText = $TenantHeatMap.projectCountText
            url = $TenantHeatMap.url
            Raw = $TenantHeatMap
        }
    }
}
