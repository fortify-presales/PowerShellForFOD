#
# Example script to extract filtered list of open source components from Fortify on Demand
#

    [CmdletBinding()]
param (
    [Parameter()]
    [string]$ApplicationFilter = '*',

    [Parameter()]
    [string]$LicenseFilter = '*',

    [Parameter()]
    [string]$ComponentFilter = '*',

    [Parameter()]
    [string]$FODApiUri,

    [Parameter()]
    [string]$FODApiUsername,

    [Parameter()]
    [string]$FODApiPassword,

    [Parameter()]
    [string]$FODApiGrantType = 'ClientCredentials',

    [Parameter()]
    [string]$FODApiScope = 'api-tenant',

    [Parameter()]
    [switch]$Raw
)
begin {
    # Make sure PowerShellForFOD Module is installed
    #Write-Host "Installing PowerShellForFOD module ..."
    #Install-Module PowerShellForFOD -Scope CurrentUser -Force -Repository PSGallery
}
process {

    # Configure API
    if ($FODApiUri) {
        Write-Host "Configuring FOD API ..."
        $PWord = ConvertTo-SecureString -String $FODApiPassword -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $FODApiUsername, $PWord
        Set-FODConfig -ApiUri $FODApiUri -GrantType $FODApiGrantType -Scope $FODApiScope
        Get-FODToken -Credential $Credential
    }

    try
    {
        # Get All Open Source Components
        Write-Host "Retrieving Open Source Components"
        $OpenSourceComponents = Get-FODOpenSourceComponents -OpenSourceScanType Sonatype -Paging | Where-Object {
            $_.releases.applicationName -like $applicationFilter -and $_.licenses.name -like $licenseFilter -and $_.componentName -like $componentFilter
        } |
                ForEach-Object -Process {
                    [PSCustomObject]@{
                        Component = $_.componentName;
                        Version = $_.componentVersionName;
                        Licenses = Out-String -InputObject $_.licenses.name -Width 100;
                        Critical = (Select-Object -InputObject $_.vulnerabilityCounts | Where-Object -Property severity -In "Critical").count
                        High = (Select-Object -InputObject $_.vulnerabilityCounts | Where-Object -Property severity -In "High").count
                        Medium = (Select-Object -InputObject $_.vulnerabilityCounts | Where-Object -Property severity -In "Medium").count
                        Low = (Select-Object -InputObject $_.vulnerabilityCounts | Where-Object -Property severity -In "Low").count
                    }
                }
    } catch {
        Write-Error "Error retrieving open source components" -ErrorAction Stop
    }
}
end {
    if ($Raw)
    {
        $OpenSourceComponents
    } else {
        $OpenSourceComponents | Format-Table -GroupBy $_.license.name -Wrap -Autosize
    }
}
