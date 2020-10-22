function Update-FODDynamicScanSetup {
    <#
    .SYNOPSIS
        Updates the setup of dynamic scans for a FOD release.
    .DESCRIPTION
        Updates the setup of dynamic scans for a specific Fortify on Demand release.
    .PARAMETER ReleaseId
        The id of the release.
    .PARAMETER InFile
        The JSON file containing the setup to use.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Updated the dynamic scan setup for release with id 100
        Update-FODDynamicScanSetup -Id 100 -InFile setup.json
    .LINK
        https://api.emea.fortify.com/swagger/ui/index#!/DynamicScans/DynamicScansV3_PutDynamicScanSetup
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [int]$ReleaseId,

        [Parameter(Mandatory=$True)]
        [String]$InFile,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Token = $Script:PS4FOD.Token,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Proxy = $Script:PS4FOD.Proxy,

        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose
    )
    begin
    {
        If (-not (Test-Path -Path $InFile)) {
            Throw "Unable to open file $InFile"
        }

        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Update-FODDynamicScanStatus Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $DynamicScanSetup = $null
    }
    process
    {
        Write-Verbose "Send-FODApi -Method Put -Operation 'PUT /api/v3/releases/$ReleaseId/dynamic-scans/scan-setup' -BodyFile $InFile" #$Params
        $DynamicScanSetup = Send-FODApi -Method Put -Operation "/api/v3/releases/$ReleaseId/dynamic-scans/scan-setup -BodyFile $InFile" @Params
    }
    end {
        $DynamicScanSetup
    }
}
