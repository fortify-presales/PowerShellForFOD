# This assumes you are running PowerShell 5

Write-Host "Running in: $PSScriptRoot"

# Parameters for publishing the module
$PublishParams = @{
    Path = "C:\Source\fortify-community-plugins\PowerShellForFOD\PowerShellForFOD"
    ErrorAction  = 'Stop'
    NuGetApiKey = $Env:NUGET_API_KEY
    Force = $true
    Verbose = $true
}

# We install and run PSScriptAnalyzer against the module to make sure it's not failing any tests
Install-Module -Name PSScriptAnalyzer -force
Invoke-ScriptAnalyzer -Path .\PowerShellForFOD

# ScriptAnalyzer passed! Let's publish
Publish-Module @PublishParams

# The module is now listed on the PowerShell Gallery
#Find-Module PowerShellForFOD
