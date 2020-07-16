# Parse application audit template
function Parse-FODAuditTemplate
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($AuditTemplate in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.ApplicationAuditTemplateObject'
#            applicationId = $AuditTemplate.applicationId
            scanType = $AuditTemplate.scanType
            scanTypeId = $AuditTemplate.scanTypeId
            conditions = Parse-FODAuditTemplateCondition $AuditTemplate.conditions
            action = Parse-FODAuditTemplateAction $AuditTemplate.action
        }
    }
}
