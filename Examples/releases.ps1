# FOD Releases examples

# Import-Module .\PowerShellForFOD\PowerShellForFOD.psm1 -Force

# Initial setup of API endpoint and Token
#$token = Get-FODToken
#Set-FODConfig -ApiUri https://api.emea.fortify.com -Token $token

#
# Create a new Release for Application Id applicationId
#
$applicationId = 31122

# Create the ReleaseObject
$relObject = New-FODReleaseObject -Name "1.0.zz" -Description "its description" -ApplicationId $applicationId `
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
$relUpdateObject = New-FODReleaseObject -Name "1.0.yy" -Description "updated description" `
    -SDLCStatus 'QA' -OwnerId 9444

# Update the Release
Write-Host "Updating release with id: $releaseId"
Update-FODRelease -Id $releaseId -Release $relUpdateObject

Write-Host -NoNewLine 'Press any key to continue...';
[void][System.Console]::ReadKey($FALSE)

# Delete the Release
Write-Host "Deleting release with id: $releaseId"
Remove-FODRelease -Id $releaseId

