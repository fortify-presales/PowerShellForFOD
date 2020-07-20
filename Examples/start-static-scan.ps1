#
# Example script to perform Fortify On Demand static analysis
#

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$ZipFile = ".\fod.zip",

    [Parameter(Mandatory)]
    [int]$FODReleaseId,

    [Parameter(Mandatory)]
    [string]$FODApiUri = "https://api.ams.fortify.com",

    [Parameter(Mandatory)]
    [string]$FODUser,

    [Parameter(Mandatory)]
    [string]$FODPassword,

    [Parameter()]
    [string]$FODGrantType = "UsernamePassword",

    [Parameter()]
    [string]$FODApiScope = "api-tenant",

    [switch]$Raw

)
begin {
    if (-not (Test-Path -Path $ZipFile)) {
        Write-Error "File $ZipFile does not exist!"
        Break
    }

    # Make sure PowerShellForFOD Module is installed
    Write-Host "Installing PowerShellForFOD module ..."
    Install-Module PowerShellForFOD -Scope CurrentUser -Force -Repository PSGallery
}
process {

    # Configure API
    Write-Verbose "Configuring FOD API ..."
    $PWord = ConvertTo-SecureString -String $FODPassword -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $FODUser, $PWord
    Set-FODConfig -ApiUri $FODApiUri -GrantType $FODGrantType -Scope $FODApiScope
    Get-FODToken -Credential $Credential

    try
    {
        $release = Get-FODRelease -Id $FODReleaseId
        if ($release.releaseName)
        {
            Write-Host "Found release:" $release.releaseName "of application: " $release.applicationName
        }
        else
        {
            Write-Error "Could not find release with id: " $FODReleaseId
        }
    } catch {
        Write-Error "Error finding release: $_"
    }

    # Start Scan
    $fodZipFile = Resolve-Path -Path $ZipFile
    Write-Host "Uploading" $ZipFile "for scanning ..."
    $fodStaticScan = Start-FODStaticScan -ReleaseId $FODReleaseId -ZipFile $fodZipFile.Path -EntitlementPreference SubscriptionOnly `
        -RemediationScanPreference NonRemediationScanOnly -InProgressScanPreference DoNotStartScan `
        -Notes "Created from PowerShellForFOD" -Raw
    $ScanId = $fodStaticScan.scanId

    Write-Host "Polling status of scan id: $ScanId"
    do {
        Start-Sleep -s 30 # sleep for 30 seconds
        $fodScan = Get-FODScanSummary -ScanId $ScanId
        $ScanStatus = $fodScan.analysisStatusType
        Write-Host "Scan $ScanId status: $ScanStatus"
    } until (
        -not ($ScanStatus -eq "Queued" -or
            $ScanStatus -eq "In_Progress" -or
            $ScanStatus -eq "Cancelled")
    )

}
end {
    if ($Raw) {
        $fodScan
    } else {
        Write-Host "Finished scan with scan id: $ScanId"
    }
}
