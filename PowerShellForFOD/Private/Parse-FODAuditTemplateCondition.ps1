# Parse application audit template condition
function Parse-FODAuditTemplateCondition
{
    [cmdletbinding()]
    param($InputObject)

    foreach ($AuditTemplateCondition in $InputObject)
    {
        [PSCustomObject]@{
            PSTypeName = 'FOD.AuditTemplateConditionObject'
            field  = $AuditTemplateCondition.field
            conditionType = $AuditTemplateCondition.conditionType
            fieldValue = $AuditTemplateCondition.fieldValue
            operationType  = $AuditTemplateCondition.operationType
        }
    }
}
