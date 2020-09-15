#
# FOD Release examples
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

#
# Create a new Release for Application Id $applicationId
#

# Create the ReleaseObject
$relObject = New-FODReleaseObject -Name "1.0.1" -Description "its description" -ApplicationId $applicationId `
    -SDLCStatus 'Development'

# Add the new Release
Write-Host "Creating new release..."
$relResponse = Add-FODRelease -Release $relObject
if ($relResponse) {
    Write-Host "Created release with id:" $relResponse.releaseId
}
$releaseId = $relResponse.releaseId

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Get the new Release
Write-Host "Getting release with id: $releaseId"
Get-FODRelease -Id $releaseId

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Create the update ReleaseObject
$relUpdateObject = New-FODReleaseObject -Name "1.0.2" -Description "updated description" `
    -SDLCStatus 'QA' -OwnerId $ownerId

# Update the Release
Write-Host "Updating release with id: $releaseId"
Update-FODRelease -Id $releaseId -Release $relUpdateObject

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Delete the Release
Write-Host "Deleting release with id: $releaseId"
Remove-FODRelease -Id $releaseId

# Delete the Application
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId
