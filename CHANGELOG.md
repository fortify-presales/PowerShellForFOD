# Power Shell For Fortify On Demand (FOD) Module

## Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

### Changed

## [1.0.0.9] - 2020-07-21

### Added

- None

### Changed

- Fixed Import-StaticScan, Import-DynamicScan and Start-FODStaticScan to work on PowerShell Core

## [1.0.0.8] - 2020-07-20

### Added

- Static Scans example script (Examples\start-static-scans.ps1)

### Changed

- Changed storage of authentication details to "GetNetworkCredential" to support PowerShell Core.
- Made "throw" logic consistent across functions.

## [1.0.0.7] - 2020-07-15

### Added

- Export and Import of Application Audit Templates
- Get-FODReleaseId - get release id using Application Name and Release Name
- Scans example script (Examples\scans.ps1)

### Changed

- Start-FODStaticScan - added ReleaseId parameter - note: this is the preferred way of initiating the scan as BSI token is being deprecated.
- Added parameters for ApplicationName and ReleaseName so scans can be uploaded without finding ReleaseId
  (Start-FODStaticScan, Import-FODStaticScan, Import-FODDynamicScan, Import-FODDynamicScan, Get-FODVulnerabilities
- Corrected "LoadedCount" calculation in loops (Get-FODApplications, Get-FODApplicationScans, Get-FODReleaseScans, Get-FODUsers,
  Get-FODVulnerabilities)
- Get-FODReleases - corrected documentation

## [1.0.0.6] - 2020-05-06

### Added

- Ability to store Credentials to allow re-generation of token

### Changed

- Get-FODConfig (Added storage of "GrantType", "Scope", "Credential" and "ForceToken" parameters)
- Get-FODToken (Added parameters for "GrantType", "Scope", "Credential" and "ForceToken")
- Get-FODReleaseScan (Added missing "Raw" parameter)
- Send-FODApi (Added "ForceToken" option to allow authentication token to be re-generated on every call)
- Set-FODConfig (Added storage of "GrantType", "Scope", "Credential" and "ForceToken" parameters)
- Update documentation for updated commands

### Removed

- None

## [1.0.0.5] - 2020-05-04

### Added

- Start Static Scans (Advanced by uploading Zip file of source code)
- BSI token parse

### Changed

- Import-FODStaticScan (Added missing "Raw" parameter)
- Import-FODDynamicScan (Added missing "Raw" parameter)
- Get-FODReleaseScan (Added missing "Raw" parameter)
- Get-FODScanSummary (Updated documentation)
- Update documentation for new commands

### Removed

- None

## [1.0.0.4] - 2020-04-29

### Added

- Query Scans and retrieve Scan summary
- Added "Dashboard" examples to README and Examples directory

### Changed

- Get-FODApplicationScans (made "ApplicationId" parameter mandatory)
- Get-FODReleaseScan (made "ReleaseId" parameter mandatory)
- Get-FODReleaseScans (made "ReleaseId" parameter mandatory)
- Update documentation for new commands

### Removed

- None

## [1.0.0.3] - 2020-04-27

### Added

- Query Application, Release and Individual Scans
- Import Static Scans (from [Fortify SCA](https://www.microfocus.com/en-us/products/static-code-analysis-sast))
- Import Dynamic Scans (from [Fortify WebInspect](https://www.microfocus.com/en-us/products/webinspect-dynamic-analysis-dast))
- Query, Add and Remove user access from Applications
- Query, add and Remove user group access from Applications
- Query Vulnerabilities

### Changed

- Send-FODApi (Added parameter to send body from a file and rate limit handling)
- Add-FODApplication (Added correct ForceVerbose operation)
- Add-FODRelease (Added correct ForceVerbose operation)
- Add-FODUser (Added correct ForceVerbose operation)
- Update documentation for new commands

### Removed

- None

## [1.0.0.2] - 2020-04-23

### Added

- Initial version with token generation and basic FOD API call infrastructure
- Query, Add, Update and Delete Releases
- Query, Add, Update and Delete Users
- Query Attributes

### Changed

- Add-FODApplication (updated documentation)
- New-FODApplicationObject (changed HasMicroservices to command line switch)
- Update-FODApplication (updated documentation)
- Added USAGE.md documentation
- Updated README.md

### Removed

- None

## [1.0.0.1] - 2020-04-22

### Added

- Initial version with token generation and basic FOD API call infrastructure
- Query, Add, Update and Delete Applications

### Changed

- None

### Removed

- None
