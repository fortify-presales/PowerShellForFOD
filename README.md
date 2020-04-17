# PowerShellForFOD

[![Build status](https://ci.appveyor.com/api/projects/status/7yb9er834qod0xvw?svg=true)](https://ci.appveyor.com/project/Name/templatepowershellmodule)

## PowerShell for Fortify on Demand (FOD)

Automate Fortify on Demand task through the PowerShell command line.

## Synopsis

A PowerShell Module to integrate with Fortify on Demand using its REST API.

## Description

A PowerShell Module to

## Using TemplatePowerShellModule

To use this module, you will first need to download/clone the repository and import the module:

```powershell
Import-Module .\PowerShellForFOD\PowerShellForFOD.psm1
```

### How to use

You will first need to connect to FOD:

```powershell
New-FODToken ...
```

### Using Send-FODApi in PowerShellForFOD

To create a generic FOD API request

```powershell
Send-FODApi ...
```

## Notes

```yaml
   Name: PowerShellForFOD
   Created by: Kevin A. Lee
   Created Date: 15/04/2020
```
