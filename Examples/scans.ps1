#
# FOD Scans, Vulnerabilities and Audit Templates examples
#
# - Change "$ownerId" to valid user id (or use 'Get-FODUsers' to find user id values)
# - Change "$attributes" to set any "required" values (use 'Get-FODAttributes Get-FODAttributes -Filters "isRequired:True"' to find any required values)

$ownerId = 9444 # user who will own the application

Import-Module .\PowerShellForFOD\PowerShellForFOD.psm1 -Force

# Initial setup of API endpoint and Token
Set-FODConfig -ApiUri https://api.emea.fortify.com -GrantType UsernamePassword -Scope api-tenant -ForceVerbose $True
$creds = Get-Credential -Message 'Please enter you FOD credentials with username in the format: "tenant\username"'
Get-FODToken -Credential $creds

#
# Create a new Application
#

# Create any AttributeObjects first - some might be mandatory
$attributes = @(
    New-FODAttributeObject -Id 22 -Value "2751" # Regions = EMEA
    New-FODAttributeObject -Id 586 -Value "255" # Project type = Application
)

# Create the ApplicationObject
$appObject = New-FODApplicationObject -Name "apitest1" -Description "its description" `
    -Type "Web_Thick_Client" -BusinessCriticality "Low" `
    -ReleaseName "1.0" -ReleaseDescription "its description" -SDLCStatus "Development" `
    -OwnerId $ownerId -Attributes $attributes

# Add the new Application
Write-Host "Creating new application..."
$appResponse = Add-FODApplication -Application $appObject # -ForceVerbose
if ($appResponse) {
    #$appResponse
    Write-Host "Created application with id:" $appResponse.applicationId
}
$applicationId = $appResponse.applicationId

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Import application audit templates
Write-Host "Importing Application Audit Template"
Import-FODApplicationAuditTemplates -Id $applicationId -FilePath $PSScriptRoot\uploads\sql-injections-aat.json
Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Import static scan
Write-Host "Importing static scan... please wait until complete in FOD portal"
Import-FODStaticScan -ApplicationName "apitest1" -ReleaseName "1.0" -ScanFile $PSScriptRoot\uploads\WebGoat5.0.fpr
Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Import dynamic scan
# TBD

# Get Vulnerabilities again (SQL Injections only) - should be none as suppressed via Audit Template
Write-Host "Retrieving Crtitical SQL Injection Vulnerabilities - there should be none because of filters..."
Get-FODVulnerabilities -ApplicationName "apitest1" -ReleaseName "1.0" -Filters "SeverityString:Critical+category:SQL Injection" -Paging
Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Delete the Application
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId

