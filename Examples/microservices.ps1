#
# FOD Micro Service examples
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

$microservices = @(
    New-FODMicroserviceObject -Name "Microservice 1"
    New-FODMicroserviceObject -Name "Microservice 2"
)

# Create the ApplicationObject
$appObject = New-FODApplicationObject -Name "apimstest1" -Description "its description" `
    -Type "Web_Thick_Client" -BusinessCriticality "Low" -HasMicroservices $True `
    -ReleaseName "1.0" -ReleaseDescription "its description" -SDLCStatus "Development" `
    -MicroServices $microservices -ReleaseMicroserviceName "Microservice 1" `
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

# Get Microservice 2
$msObject = Get-FODMicroservices -ApplicationId $applicationId | Where-Object {$_.name -eq 'Microservice 2'}

# Create the ReleaseObject for the release to add to microservice
$relObject = New-FODReleaseObject -Name "1.0" -Description "its description" -ApplicationId $applicationId `
    -SDLCStatus 'Development' -Microservice $msObject

# Add the new Release
Write-Host "Creating new microservice release..."
$relResponse = Add-FODRelease -Release $relObject
if ($relResponse) {
    Write-Host "Created microservice release with id:" $relResponse.releaseId
}

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Add a new microservice to the application
$msResponse = Add-FODMicroservice -ApplicationId $applicationId -Name "Microservice 3"
if ($msResponse) {
    Write-Host "Created microservice with id:" $msResponse.id
}
# Update the microservice
Write-Host "Updating microservice"
Update-FODMicroservice -ApplicationId $applicationId -Id $msResponse.id -Name "Microservice 3 Updated"

# Delete the microservice
Write-Host "Removing microservice"
Remove-FODMicroservice -ApplicationId $applicationId -Id $msResponse.id

# Delete the Application
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId

