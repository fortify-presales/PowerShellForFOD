# using module .\PowerShellForFOD\Class\PowerShellForFOD.Class1.psm1
# Above needs to remain the first line to import Classes
# remove the comment when using classes

# requires -Version 2
# Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Create / Read config
$script:_PS4FODXmlpath = Get-FODConfigPath
if(-not (Test-Path -Path $script:_PS4FODXmlpath -ErrorAction SilentlyContinue))
{
    Try
    {
        Write-Warning "Did not find config file $($script:_PS4FODXmlpath), attempting to create"
        [PSCustomObject]@{
            ApiUri = $null
            GrantType = $null
            Scope = $null
            Credential = $null
            Token = $null
            Expiry = $null
            Proxy = $null
            ForceToken = $False
            RenewToken = $False
            ForceVerbose = $False
        } | Export-Clixml -Path $($script:_PS4FODXmlpath) -Force -ErrorAction Stop
    }
    Catch
    {
        Write-Warning "Failed to create config file $($script:_PS4FODXmlpath): $_"
    }
}

# Initialize the config variable.
Try
{
    # Import the config
    $PS4FOD = $null
    $PS4FOD = Get-FODConfig -Source PS4FOD.xml -ErrorAction Stop
}
Catch
{
    Write-Warning "Error importing PS4FOD config: $_"
}

# Create a hashtable for use with the "leaky bucket" rate-limiting algorithm. (Some of FOD's API calls will fail if you request them too quickly.)
# https://en.wikipedia.org/wiki/Leaky_bucket
$Script:APIRateBuckets = @{}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Export-ModuleMember -Function $Public.Basename
