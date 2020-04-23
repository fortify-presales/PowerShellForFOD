function Add-FODRelease {
    <#
    .SYNOPSIS
        Adds a new FOD release.
    .DESCRIPTION
        Adds a new FOD release using the FOD REST API and a previously created
        PS4FOD.ReleaseObject.
    .PARAMETER Release
        A PS4FOD.ReleaseObject containing the release's values.
    .PARAMETER Raw
        Print Raw output - do not convert into ReleaseObject.
        Default is false.
    .PARAMETER Token
        FOD authentication token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .PARAMETER ForceVerbose
        Force verbose output.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Add a new release
        $relResponse = Add-FODRelease -Release $relObject
        if ($relResponse) {
            Write-Host "Created release with id:" $relResponse.releaseId
        }
    .FUNCTIONALITY
        Fortify on Demand
    #>
    [CmdletBinding()]
    param (
        [PSTypeName('PS4FOD.ReleaseObject')]
        [parameter(ParameterSetName = 'FODReleaseObject',
                ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        $Release,

        [switch]$Raw = $False,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Token = $Script:PS4FOD.Token,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Uri = $Script:PS4FOD.ApiUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Proxy = $Script:PS4FOD.Proxy,

        [switch]$ForceVerbose = $Script:PS4FOD.ForceVerbose
    )
    begin
    {
        $Params = @{}
        if ($Proxy) {
            $Params.Proxy = $Proxy
        }
        Write-Verbose "Add-FODRelease Bound Parameters:  $( $PSBoundParameters | Remove-SensitiveData | Out-String )"
        $RawRelease = @()
    }
    process
    {
        $Params = @{
            Body = $Release
        }
        Write-Verbose "Send-FODApi: -Method Post -Operation '/api/v3/releases'"
        $RawRelease = Send-FODApi -Method Post -Operation "/api/v3/releases" @Params
    }
    end {
        if ($Raw) {
            $RawRelease
        } else {
            Parse-FODRelease -InputObject $RawRelease
        }
    }
}
