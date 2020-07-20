function Import-FODStaticScan {
    <#
    .SYNOPSIS
        Imports a static scan results file into a FOD Release.
    .DESCRIPTION
        Imports a Fortify SCA on-premise static scan results file into a Fortify on Demand Release.
    .PARAMETER ApplicationName
        The Name of the application to import into.
    .PARAMETER ReleaseName
        The Name of the release to import into.
        Note: Both ApplicationName and ReleaseName are required if not specifying ReleaseId
    .PARAMETER ReleaseId
        The Id of the release to import into.
    .PARAMETER ScanFile
        The absolute path of the scan file to import.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Import an FPR scan file into release with id 1000
        Import-FODStaticScan -ReleaseId 1000 -ScanFile C:\Temp\scans\scanResults.fpr
    .EXAMPLE
        # Import an FPR scan file into release 1.0 of application MyApp
        Import-FODStaticScan -ApplicationName MyApp -Release 1.0 -ScanFile C:\Temp\scans\scanResults.fpr
    .LINK
        https://api.ams.fortify.com/swagger/ui/index#!/StaticScans/StaticScansV3_PutImportScan
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ApplicationName,

        [Parameter()]
        [string]$ReleaseName,

        [Parameter()]
        [int]$ReleaseId,

        [Parameter(Mandatory)]
        [system.io.fileinfo]$ScanFile,

        [switch]$Raw,

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
        # If we don't have a ReleaseId we have to find it using API
        if (-not $ReleaseId) {
            try {
                $ReleaseId = Get-FODReleaseId -ApplicationName $ApplicationName -ReleaseName $ReleaseName
            } catch {
                Write-Error $_
                Break
            }
        }
        if (-not $ScanFile.Exists) {
            throw "Scan file '$ScanFile' does not exist"
        }
        $Params = @{}
        if ($Proxy) {
            $Params['Proxy'] = $Proxy
        }
        if ($ForceVerbose) {
            $Params.Add('ForceVerbose', $True)
            $VerbosePreference = "Continue"
        }
        Write-Verbose "Import-FODStaticScan Bound Parameters: $( $PSBoundParameters | Remove-SensitiveData | Out-String )"

        $ImportSessionId = $null
        $FileLength = $ScanFile.Length
        $Offset = 0
        $FragmentNumber = 0
        $ChunkSize = 1024 * 1024

        # Create temporary file to store payload "chunks" in.
        $TempFile = New-TemporaryFile
        $TempFileName = $TempFile.FullName
        Write-Verbose "Created payload chunk temporary file: $TempFileName"

        $Params.Add('BodyFile', $TempFile.FullName)
        $Params.Add("ContentType", "application/octet-stream")

        $Response = $null
    }
    process
    {
        # Start "Import Scan session"
        Write-Verbose "Send-FODApi -Method Get -Operation '/api/v3/releases/$ReleaseId/import-scan-session-id'" #$Params
        $Response = Send-FODApi -Method Get -Operation "/api/v3/releases/$ReleaseId/import-scan-session-id" @Params
        $ImportSessionId = $Response.importScanSessionId
        Write-Verbose "Import scan session id is: $ImportSessionId"

        # Open scan file for reading
        $stream = [System.IO.File]::OpenRead($ScanFile)
        $readByteArray = New-Object byte[] $ChunkSize

        while ($numBytesRead = $stream.Read($readByteArray, 0, $ChunkSize)){
            if ($numBytesRead -lt $ChunkSize) {
                $FragmentNumber = -1
            }
            if ($FragmentNumber -eq -1) {
                Write-Verbose "Sending last fragment"
            } else {
                Write-Verbose "Sending fragment: $FragmentNumber"
            }
            Set-Content -Path $TempFile.FullName -Value $readByteArray -Encoding Byte
            $ImportUrl = "/api/v3/releases/$ReleaseId/static-scans/import-scan?releaseId=$ReleaseId&fragNo=$FragmentNumber&offset=$Offset&fileLength=$FileLength&importScanSessionId=$ImportSessionId"
            Write-Verbose "Send-FODApi -Method Put -Operation $ImportUrl" #$Params
            $Response = Send-FODApi -Method Put -Operation $ImportUrl @Params
            $FragmentNumber += 1
            $Offset += $numBytesRead
            Write-Verbose "Read bytes: $Offset / $FileLength"
        }
    }
    end {
        # Delete temporary file
        Write-Verbose "Deleting scan data temporary file: $TempFileName"
        $TempFile.Delete()

        if ($Raw) {
            $Response
        } else {
            $ReferenceId = $Response.referenceId
            Write-Host "Imported scan with reference id: $ReferenceId"
        }
    }
}
