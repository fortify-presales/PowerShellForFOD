# FOD Application examples

# Import-Module .\PowerShellForFOD\PowerShellForFOD.psm1 -Force

# Initial setup of API endpoint and Token
#$token = Get-FODToken
#Set-FODConfig -ApiUri https://api.emea.fortify.com -Token $token

#
# Create a new Application
#

# Create any AttributeObjects first - some might be mandatory
$attributes = @(
    New-FODAttributeObject -Id 22 -Value "2751"
    New-FODAttributeObject -Id 1388 -Value "some value"
)

# Create the ApplicationObject
$appObject = New-FODApplicationObject -Name "apitest1" -Description "its description" `
    -Type "Web_Thick_Client" -BusinessCriticality "Low" `
    -ReleaseName "1.0" -ReleaseDescription "its description" -SDLCStatus "Development" `
    -OwnerId 9444 -Attributes $attributes

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
    New-FODAttributeObject -Id 22 -Value "2751"
    New-FODAttributeObject -Id 1388 -Value "some other value"
)

# Create the update ApplicationObject
$appUpdateObject = New-FODApplicationObject -Name "apitest1-new" -Description "its updated description" `
    -BusinessCriticality "Medium" -EmailList "testuser@mydomain.com" -Attributes $updateAttributes

# Update the Application
Write-Host "Updating application with id: $applicationId"
Update-FODApplication -Id $applicationId -Application $appUpdateObject

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Delete the Application
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId

