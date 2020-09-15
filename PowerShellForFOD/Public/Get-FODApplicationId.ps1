function Get-FODApplicationId {
    <#
    .SYNOPSIS
        Gets the id for a FOD applications.
    .DESCRIPTION
        Get the internal id for a specific FOD application.
    .PARAMETER ApplicationName
        The application name.
    .PARAMETER Raw
        If specified, provide raw output and do not parse any responses.
    .PARAMETER Token
        FOD token to use.
        If empty, the value from PS4FOD will be used.
    .PARAMETER Proxy
        Proxy server to use.
        Default value is the value set by Set-FODConfig
    .EXAMPLE
        # Get the id for the Application called "FOD-Test"
        Get-FODApplicationId -ApplicationName "FOD-Test"
    .FUNCTIONALITY
        Fortify on Demand
    #>
    param (
        [Parameter(Mandatory=$True)]
        [string]$ApplicationName,

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
        $Application = @()
    }
    process
    {
        try {
            $Application = Get-FODApplications -Filters "applicationName:$ApplicationName" | Where-Object { $_.applicationName -eq $ApplicationName }
        } catch {
            Write-Error $_
            Break
        }
    }
    end {
        if ($Raw) {
            $Application
        } else {
            $Application | Select-Object -ExpandProperty applicationId
        }
    }
}
