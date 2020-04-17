# Import-Module .\PowerShellForFOD\PowerShellForFOD.psm1 -Force

# Some example invocations

# Initial setup of API endpoint and Token
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
    -ReleaseName 1.0 -ReleaseDescription "its description" -SDLCStatus "Development" `
    -HasMicroservices $false -OwnerId 9444 -Attributes $attributes

# Create the new Application
$appResponse = New-FODApplication -Application $appObject # -Verbose
if ($appResponse)
{
    #$appResponse
    Write-Host "Created application with id:" $appResponse.applicationId
}
