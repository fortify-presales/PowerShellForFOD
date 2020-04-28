# Parse scan pause detail
function Parse-FODScanPauseDetail
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($ScanPauseDetail in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ScanPauseDetailObject'
            pausedOn  = $ScanPauseDetail.pausedOn
            reason  = $ScanPauseDetail.reason
            notes  = $ScanPauseDetail.notes
            Raw = $ScanPauseDetail
        }
    }
}
