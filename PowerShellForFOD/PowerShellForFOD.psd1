#
# Module manifest for module 'PowerShellForFOD'
#
# Generated by: Kevin A. Lee
#
# Generated on: 4/23/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PowerShellForFOD.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '705f11bd-f9ea-428e-bf33-39c6b4b0605d'

# Author of this module
Author = 'Kevin A. Lee'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2020 Kevin Lee. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell Module for Fortify on Demand'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Add-FODApplication', 'Add-FODRelease', 'Add-FODUser', 
                'Get-FODApplication', 'Get-FODApplications', 'Get-FODAttributes',
                'Get-FODConfig', 'Get-FODRelease', 'Get-FODReleases', 'Get-FODToken',
                'Get-FODUser', 'Get-FODUsers', 'Get-FODUserGroups',
                'Get-FODUserGroupApplicationAccess', 'Add-FODUserGroupApplicationAccess', 'Remove-FODUserGroupApplicationAccess',
                'Get-FODUserApplicationAccess', 'Add-FODUserApplicationAccess', 'Remove-FODUserApplicationAccess',
                'New-FODApplicationObject',
                'New-FODAttributeObject', 'New-FODMicroserviceObject',
                'New-FODReleaseObject', 'New-FODUserGroupObject', 'New-FODUserObject',
                'Remove-FODApplication', 'Remove-FODRelease', 'Remove-FODUser',
                'Send-FODApi', 'Set-FODConfig', 'Update-FODApplication',
                'Update-FODRelease', 'Update-FODUser',
                'Get-FODVulnerabilities',
                'Get-FODApplicationScans', 'Get-FODReleaseScans', 'Get-FODReleaseScan',
                'Import-FODStaticScan', 'Import-FODDynamicScan')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'MicroFocus','Fortify','FOD','FortifyOnDemand','Security','DevOps','DevSecOps'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/fortify-community-plugins/PowerShellForFOD/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/fortify-community-plugins/PowerShellForFOD'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'Added Release,User and Attribute operations.'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

