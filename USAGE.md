# Power Shell For Fortify On Demand (FOD) Module

## Usage

#### Table of Contents
*   [Configuration](#configuration)
*   [Applications](#applications)
    * [Adding Applications](#adding-applications)
    * [Retrieving Applications](#retrieving-applications)
    * [Updating Applications](#updating-applications)
    * [Deleting Application](#deleting-applications)
    * [Adding User Application Access](#adding-user-application-access)
    * [Retrieving User Application Access](#retrieving-user-application-access)
    * [Removing User Application Access](#removing-user-application-access)
    * [Adding User Group Application Access](#adding-user-group-application-access)
    * [Retrieving User Group Application Access](#retrieving-user-group-application-access)
    * [Removing User Group Application Access](#removing-user-group-application-access)    
*   [Releases](#releases)
    * [Adding Releases](#adding-releases)
    * [Retrieving Releases](#retrieving-releases)
    * [Updating Releases](#updating-releases)
    * [Deleting Releases](#deleting-releases)
*   [Scans](#scans)
    * [Retrieving Scans](#retrieving-scans)
    * [Retrieving Scan Summary](#retrieving-scan-summary)
    * [Importing Static Scans](#importing-static-scans)
    * [Importing Dynamic Scans](#importing-dynamic-scans)    
    * [Starting a Static Scan](#starting-a-static-scan)
*   [Vulnerabilities](#vulnerabilities)
    * [Retrieving Vulnerabilities](#retrieving-vulnerabilities)    
*   [Users](#users)
    * [Adding Users](#adding-users)
    * [Retrieving Users](#retrieving-users)
    * [Updating Users](#updating-users)
    * [Deleting Users](#deleting-users)
*   [Attributes](#attributes)
    * [Retrieving Attributes](#retrieving-attributes)    
*   [Troubleshooting](#troubleshooting)    

----------

## Configuration

To access the [Fortify On Demand](https://www.microfocus.com/en-us/products/application-security-testing) API you need 
to create an **authentication token**. This module allows the creation and persistence of this token so that it does
not need to be passed with each command. To create the token, set your **API Uri** endpoint and the **GrantType** and **Scope**
you will be using to access Fortify on Demand as in the following: 

```PowerShell
Set-FODConfig -ApiUri https://api.ams.fortify.com -GrantType UsernamePassword -Scope api-tenant
```

The value for `ApiUri` will depend on which region you are using Fortify on Demand in. The current values are:

|Data Center|API Root Uri|
|-----------|------------|
|US|https://api.ams.fortify.com|
|EMEA|https://api.emea.fortify.com|
|APAC|https://api.apac.fortify.com|
|FedRAMP|https://api.fed.fortify.com|

Fortify on Demand supports two authentication types or `GrantType`: **username/password** authentication (`GrantType UsernamePassword`) 
and **client credentials** (`GrantType ClientCredentials`). 

You can then retrieve an **authentication token** using the following: 

```PowerShell
Get-FODToken
```
After which you will be prompted to login with your Fortify On Demand credentials. The values you enter depend on which
`GrantType` you are using. For **username/password** authentication enter your `tenantId\username` values in the 
*"username"* field and your `password` value in the **password** field. For **client credentials** authentication you 
should enter an **API Key** and **API Secret** that has been created in the Fortify On Demand portal at `Administration -> Settings -> API`.

Please note, the token is not permanent - Fortify on Demand will "timeout" the token after a period of inactivity,
after which you will need to re-create it with `Get-FODToken`. However, you can also store a PowerShell [Credential](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential?view=powershellsdk-1.1.0)
object which can be automatically used to generate the token. To do this you can carry out the following:

```Powershell
$Credential = Get-Credential
Set-FODConfig -Credential $Credential
``` 

The configuration is encrypted and stored on disk for use in subsequent commands.

To retrieve the current configuration execute the following:

```PowerShell
Get-FODConfig
```

There following configuration settings are available/visible:

- `Proxy` - A proxy server configuration to use
- `ApiUri` - The API endpoint of the Fortify On Demand server you are using
- `GrantType` - The type of authentication being used
- `Scope` - The API scope of access
- `Credential` - A PowerShell Credential object
- `Token` - An authentication token retrieved using `Get-FODToken`
- `ForceToken` - Force the authentication token to be re-generated on every API call
- `ForceVerbose` - Force Verbose output for all commands and subcommands 

Each of these options can be set via `Set-FODConfig`, for example `Set-FODConfig -ForceVerbose` to force
verbose output in commands and sub-commands.

----------

## Applications

### Adding applications

To create a new application, you need to create a `FODApplicationObject` and `FODAttributeObjects` for any 
attributes you want to set for the application. Note: some attributes are mandatory and values will need to be provided - 
you can check which attributes are mandatory using `Get-FODAttributes -Filter 'isRequired:True'`. 

An example of creating attributes and an application is shown in the following: 

```Powershell
# Create any AttributeObjects first - some might be mandatory
$attributes = @(
    New-FODAttributeObject -Id 22 -Value "2751"
    New-FODAttributeObject -Id 1388 -Value "some value"
)

# Create the ApplicationObject
$appObject = New-FODApplicationObject -Name "apitest1" -Description "its description" `
    -Type "Web_Thick_Client" -BusinessCriticality "Low" `
    -ReleaseName 1.0 -ReleaseDescription "its description" -SDLCStatus "Development" `
    -OwnerId 9444 -Attributes $attributes

# Add the new Application
$appResponse = Add-FODApplication -Application $appObject
if ($appResponse) {
    Write-Host "Created application with id:" $appResponse.applicationId
}
$applicationId = $appResponse.applicationId
```

In the above, you will need to know the *id* of the user who is the owner of the application. You can find out a user's
*id* by running `Get-FODUsers -Filter 'userName:xxx'` where *xxx* is the username of the user to find the *id* for.

### Retrieving applications

To get (retrieve) an individual application, use the following:

```Powershell
# Get the new Application created above
Get-FODApplication -Id $applicationId
```

To get (retrieve) one or more applications, use the following:

```Powershell
# Get any applications with "test" or "demo" in their name
Get-FODApplications -Paging -Filters "applicationName:test|demo"
```

### Updating applications

To update an existing application, you will first need to create an `FODApplicationObject` with any updated values,
you will also need to supply any `AttributeObjects` (if they are mandatory). An example is shown in the following:

```Powershell 
# Create update AttributeObjects first - mandatory attributes will still need to be sent
$updateAttributes = @(
    New-FODAttributeObject -Id 22 -Value "2751"
    New-FODAttributeObject -Id 1388 -Value "some other value"
)

# Create the update ApplicationObject
$appUpdateObject = New-FODApplicationObject -Name "apitest1-new" -Description "its updated description" `
    -BusinessCriticality "Medium" -EmailList "testuser@mydomain.com" -Attributes $updateAttributes

# Update the Application
Update-FODApplication -Id $applicationId -Application $appUpdateObject
```

### Deleting applications

To delete (remove) an application, use the following:

```Powershell
Write-Host "Deleting application with id: $applicationId"
Remove-FODApplication -Id $applicationId
```

### Adding User Application Access

To give a user access to an application, use the following:

```Powershell
# Give the user with id 1000 access to application with id 100
Add-FODUserApplicationAccess -UserId 1000 -ApplicationId 100
```

### Retrieving User Application Access

To retrieve what users have access to an application, use the following:

```Powershell
# Get the application access details of user group id 1000
Get-FODUserGroupApplicationAccess -Id 1000
```
    
### Removing User Application Access

To remove a user's access to an application, use the following:

```Powershell
# Remove the user group with id 1000 from application 100
Remove-FODUserGroupApplicationAccess -UserGroupId 1000 -ApplicationId 100
```

### Adding User Group Application Access

To give a user group access to an application, use the following:

```Powershell
# Give the user group with id 1000 access to application with id 100
Add-FODUserGroupApplicationAccess -UserGroupId 1000 -ApplicationId 100
```

### Retrieving User Group Application Access

To retrieve what user groups have access to an application, use the following:

```Powershell
# Get the application access details of user group id 1000
Get-FODUserGroupApplicationAccess -Id 1000
```

### Removing User Group Application Access

To remove a user's access to an application, use the following:

```Powershell
# Remove the user with id 1000 from application 100
Remove-FODUserApplicationAccess -UserId 1000 -ApplicationId 100
```
  
----------

## Releases

### Adding releases

To create a release, you need to create an `FODReleaseObject` and then call `Add-FODRelease` as shown in the following:

```Powershell
# Create the ReleaseObject
$relObject = New-FODReleaseObject -Name "1.0" -Description "its description" -ApplicationId $applicationId `
    -SDLCStatus 'Development'

# Add the new release
$relResponse = Add-FODRelease -Release $relObject
if ($relResponse) {
    Write-Host "Created release with id:" $relResponse.releaseId
}
$releaseId = $relResponse.releaseId
```

### Retrieving releases

To get (retrieve) an individual release, use the following:

```Powershell
# Get the new Release created above
Get-FODRelease -Id $releaseId
```

To get (retrieve) one or more releases, use the following:

```Powershell
# Get any releases that are in 'Production' and have not 'Passed'
Get-FODReleases -Paging -Filters 'sdlcStatusType:Production+isPassed:False'
```

### Updating releases

To update an existing release, you will first need to create an `FODReleaseObject` with any updated values. An example
is shown in the following:

```Powershell
# Create the update ReleaseObject
$relUpdateObject = New-FODReleaseObject -Name "1.0.1" -Description "updated description" `
    -SDLCStatus 'QA' -OwnerId 9444

# Update the release
Update-FODRelease -Id $releaseId -Release $relUpdateObject
```

Note: the API requires that the *OwnerId* is specified on an update operation.

### Deleting releases

To delete (remove) a release, use the following:

```Powershell
Remove-FODRelease -Id $releaseId
```

----------

## Scans

### Retrieving Scans

To retrieve scans you can use:

```Powershell
# Get all of the scans for application id 1000 through Paging, latest completed first
Get-FODScans -Filters "applicationId:1000" -Paging -OrderBy 'startedDateTime' -OrderByDirection 'DESC'
```

To retrieve scans for an application you can use:

```Powershell
# Get all of the scans for application id 1000 through Paging
Get-FODApplicationScans -ApplicationId 1000 -Paging
```

To retrieve scans for a release you can use:

```Powershell
# Get all of the scans for release id 1000 through Paging
Get-FODReleaseScans -ReleaseId 1000 -Paging
```

To retrieve a specific scan for a release you can use:

```Powershell
# Get the scans with id 1234 for release id 1000 through Paging
Get-FODReleaseScan -ReleaseId 1000 -ScanId 1234
```

### Retrieving Scan Summary

To retrieve the summary for a scan you can use:

```Powershell
# Get the scan summary for scan with id 1000
Get-ScanSummary -ScanId 1000
```

### Importing Static Scans

You can import on-premise static scans (from [Fortify SCA](https://www.microfocus.com/en-us/products/static-code-analysis-sast))
using the `Import-FODStaticScan` as in the following:

```Powershell
# Import an FPR scan file into release with id 1000
Import-FODStaticScan -Release 1000 -ScanFile C:\Temp\scans\scanResults.fpr
```

### Importing Dynamic Scans

You can import on-premise dynamic scans (from [Fortify WebInspect](https://www.microfocus.com/en-us/products/webinspect-dynamic-analysis-dast))
using the `Import-FODDynamicScan` as in the following:

```Powershell
# Import an FPR scan file into release with id 1000
Import-FODDynamicScan -Release 1000 -ScanFile C:\Temp\scans\scanResults.fpr
```

### Starting a Static Scan

To start a Fortify on Demand static scan, a *Zip* file with the source and dependencies (as described in the [documentation](https://ams.fortify.com/Docs/en/index.htm) 
needs to be uploaded and a Build Server Integration (BSI) token needs to be specified. This token is available in the
 `Static Scan Setup` when you select `Start Scan -> Static` from the Fortify on Demand portal and enter 
the basic details of the scan. When you have both of these you can start a static scan using the following:

```Powershell 
# Copy the BSI Token from the portal between the quotes
$BsiToken = "..."
# Starts a static scan using the BSI Token $BsiToken and the Zip file "C:\Temp\upload\fod.zip"
$response = Start-FODStaticScan -BSIToken $BsiToken -ZipFile C:\Temp\upload\fod.zip `
    -RemediationScanPreference NonRemediationScanOnly -EntitlementPreference SubscriptionOnly `
    -InProgressScanPreference DoNotStartScan -Notes "some notes" -Raw
Write-Host "Started static scan id: $response.scanId"
```

After the zip file has been uploaded the scan will be queued and executed in Fortify on Demand. To find the status of
the scan you can use the `Get-FODScanSummary` function as in the following:

```Powershell
# Get the summary of the scan from the $response object created in the previous step
Get-FODScanSummary -ScanId $response.scanId | Select-Object -Property analysisStatusType
```

The `analysisStatusType` will be the current status visibile in the Fortify on Demand portal, e.g. Queued, In_Progress, 
Completed and so on.

----------

## Vulnerabilities

### Retrieving Vulnerabilities

You can retrieve vulnerabilities for a specific release using the following:

```Powershell
# Get all of the vulnerabilities for release id 1000 through Paging
Get-FODVulnerabilities -Release Id 1000 -Paging
```

You can also use "filters" to retrieve different severities, categories and types of vulnerabilities, for example:

```Powershell
# Get all vulnerabilities with "critical" or "high" severity for release id 1000
Get-FODVulnerabilities -Release Id 1000 -Paging -Filters "severityString:Critical|High"
```

----------

## Users

### Adding users

To create a user, you need to create an `FODUserObject` and then call `Add-FODUser` as shown in the following:

```Powershell
# Create the ReleaseObject
$userObject = New-FODUserObject -Username "user1" -FirstName "Test" -LastName "User" `
    -Email "user1@mydomain.com" -PhoneNumber "0123456789" -RoleId 0

# Add the new user
$usrResponse = Add-FODUser -User $usrObject
if ($usrResponse) {
    Write-Host "Created user with id:" $usrResponse.userId
}
$userId = $usrResponse.userId
```

Note: there is no function to retrieve the *RoleId* - to find the *RoleId* for a specific role, e.g. "Security Lead"
execute `Get-FODUser` on a user who you know has the role and examine the `roleId` field in the response.

### Retrieving users

To get (retrieve) an individual user, use the following:

```Powershell
# Get the new user created above
Get-FODUser -Id $userId
```

To get (retrieve) one or more users, use the following:

```Powershell
# Get any users that have the role 'Security Lead'
Get-FODUsers -Paging -Filters 'roleName:Security Lead'
```

### Updating users

To update an existing user, you will first need to create an `FODUserObject` with any updated values. An example
is shown in the following:

```Powershell
# Create the update UserObject
$usrUpdateObject = New-FODUserObject -Email "updated@mydomain.com" -PhoneNumber "01234777666" `
    -Password 'password' -MustChange

# Update the user
Update-FODUser -Id $userId -User $usrUpdateObject
```

### Deleting users

To delete (remove) a user, use the following:

```Powershell
Remove-FODRelease -Id $userId
```

----------

## Attributes

### Retrieving attributes

To get (retrieve) one or more attributes, use the following:

```Powershell
# Get all atributes
Get-FODAttributes

# Get a specific attribute called 'Regions'
Get-FODAttributes -Filter 'name:Regions'
```

----------

## Troubleshooting

### Untrusted Repository

If this is the first time you have installed a module from [PSGallery](https://www.powershellgallery.com/), you might receive a message similar to the
following:

```
Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its
InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from
'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): Y
```

Select `Y` to install the module this time or you can use `Set-PSRepository` cmdlet.

### Creating/Storing a Powershell Credential object

The `Get-FODToken` function requires a PowerShell `Credential` object which will normally be created by prompting
the user for Fortify on Demand login details. However, if you are creating a script you might want to create
this `Credential` object programmatically. This can be achieved by the following:

```Powershell
$Credential = Get-Credential
Set-FODConfig -ApiUri $FODPortalUri ... -Credential $Credential
Get-FODToken
```

`Get-Credential` will request a username and password which will be either your `tenantId\username` and `password`
values or an **API Key** and **API Secret** that has been created in the Fortify On Demand portal at 
`Administration -> Settings -> API`.

### Removing/creating the configuration file

The configuration file is stored in `%HOME_DRIVE%%HOME_PATH%\AppData\Local\Temp`, e.g. `C:\Users\demo\AppData\Local\Temp`
as `%USERNAME%-hostname-PS4FOD.xml`. You can delete this file and re-create it using `Set-FODConfig` if necessary.

### Debugging responses

If you are not receiving the output you expect you can turn on **verbose** output using the `ForceVerbose` option
as in the following:

```Powershell
Set-FODConfig -ForceVerbose $true
```

Then when you execute a command you should see details of all the API calls that are being made.
