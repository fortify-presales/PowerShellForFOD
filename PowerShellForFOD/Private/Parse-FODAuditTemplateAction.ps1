# Parse application audit template action
function Parse-FODAuditTemplateAction
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($AuditTemplateAction in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.AuditTemplateActionObject'
            actionType = $AuditTemplateAction.actionType
            severity = $AuditTemplateAction.severity
            severityId = $AuditTemplateAction.severityId
        }
    }
}
