#
# FOD Application examples
#
# - Change "$ownerId" to valid user id (user'Get-FODUsers' to find user id values)
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

# Get the new Application
Write-Host "Getting application with id: $applicationId"
Get-FODApplication -Id $applicationId

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Create update AttributeObjects first - mandatory attributes will still need to be sent
$updateAttributes = @(
    New-FODAttributeObject -Id 22 -Value "2749" # Regions = AMS
    New-FODAttributeObject -Id 586 -Value "257" # Project type = Other
)

# Create the update ApplicationObject
$appUpdateObject = New-FODApplicationObject -Name "apitest1-updated" -Description "its updated description" `
    -BusinessCriticality "Medium" -EmailList "testuser@mydomain.com" -Attributes $updateAttributes

# Update the Application
Write-Host "Updating application with id: $applicationId"
Update-FODApplication -Id $applicationId -Application $appUpdateObject

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Delete the Application
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId

