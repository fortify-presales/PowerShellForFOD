# Power Shell For Fortify On Demand (FOD) Module

## Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

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

- Initial version with token generation and basic FOS API call infrastructure
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

- Initial version with token generation and basic FOS API call infrastructure
- Query, Add, Update and Delete Applications

### Changed

- None

### Removed

- None
