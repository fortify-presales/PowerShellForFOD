# Parse BSI token
function Parse-FODBSIToken
{
    [cmdletbinding()]
    param($InputObject)

    $Token = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($InputObject)) | ConvertFrom-Json

    [PSCustomObject]@{
        PSTypeName = 'FOD.BSITokenObject'
        tenantId = $Token.tenantId
        tenantCode = $Token.tenantCode
        releaseId = $Token.releaseId
        payloadType = $Token.payloadType
        assessmentTypeId = $Token.assessmentTypeId
        technologyType = $Token.technologyType
        technologyTypeId = $Token.technologyTypeId
        technologyVersion = $Token.technologyVersion
        technologyVersionId = $Token.technologyVersionId
        auditPreference = $Token.auditPreference
        auditPreferenceId = $Token.auditPreferenceId
        includeThirdParty = $Token.includeThirdParty
        includeOpenSourceAnalysis = $Token.includeOpenSourceAnalysis
        portalUri = $Token.portalUri
        apiUri = $Token.apiUri
        scanPreference = $Token.scanPreference
        scanPreferenceId = $Token.scanPreferenceId
        Raw = $Token
    }

}
