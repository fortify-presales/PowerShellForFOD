# Power Shell For Fortify On Demand (FOD) Module

#### Table of Contents

*   [Overview](#overview)
*   [Current API Support](#current-api-support)
*   [Installation](#installation)
*   [Configuration](#configuration)
*   [Usage](#usage)
*   [Logging](#logging)
*   [Developing and Contributing](#developing-and-contributing)
*   [Licensing](#licensing)

## Overview

This is a [PowerShell](https://microsoft.com/powershell) [module](https://technet.microsoft.com/en-us/library/dd901839.aspx)
that provides command-line interaction and automation for the [Fortify On Demand API](https://api.ams.fortify.com/swagger/ui/index).

----------

## Current API Support

At present, this module can:
 * Authenticate against the FOD API to retrieve and store authentication token
 * Execute a generic FOD API REST command with authentication and rate limiting support
 * Query, add, update and remove [Applications]

Development is ongoing, with the goal to add broad support for the entire API set.

Review [examples](USAGE.md#examples) to see how the module can be used to accomplish some of these tasks.

----------

## Installation

You can get latest release of the PowerShellForFOD on the [PowerShell Gallery](https://www.powershellgallery.com/packages/PowerShellForFOD)

```PowerShell
Install-Module -Name PowerShellForFOD
```

----------

## Configuration

To access the FOD API you need to provide an "authentication" token. This module allows the creation and 
persistence of this token so that it does not need to be passed with each command. To create the token,
run the following to set your API endpoint and token:

Note: the value for `ApiUrl` will depend on which region you are using Fortify on Demand in.

```PowerShell
Set-FODConfig -ApiUrl https://api.ams.fortify.com
Get-FODToken
```

You will be prompted for a username and password. Both "client credentials" and "username/password" are
supported. For example, to login with your username/password enter your `tenant\username` in the
"username" field and your `password` in the "password" field. For "client credentials" you can enter
an API Key and API Secret that has been setup in Fortify On Demand.

The token is not permanent, Fortify on Demand will "timeout" the token after a period of inactivity,
after which you will need to re-create it with `Get-FODToken`.

The configuration is encrypted and stored on disk for use in subsequent commands.

There are more configuration options available.  Just review the help for that command for the 
most up-to-date list!

## Usage

Example command:

```powershell
$applications = Get-FODApplications -Filters "applicationName:test" -Paging | Out-GridView
```

For more example commands, please refer to [USAGE](USAGE.md#examples).

----------

## Developing and Contributing

Please see the [Contribution Guide](CONTRIBUTING.md) for information on how to develop and
contribute.

If you have any problems, please consult [GitHub Issues](https://github.com/fortify-community-plugins/PowerShellForFOD/issues)
to see if has already been discussed.

If you do not see your problem captured, please file [feedback](CONTRIBUTING.md#feedback).

----------

## Licensing

PowerShellForGitHub is licensed under the [GNU General Public license](LICENSE).


