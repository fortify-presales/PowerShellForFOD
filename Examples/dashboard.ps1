# An example dashboard using PowerShellForFOD and Universal Dashboard (https://universaldashboard.io/)

# Install-Module Universal -Scope CurrentUser -AllowClobber
# Install-PSUServer -LatestVersion
# Install-PSUServer -Path (Join-Path $Env:AppData "PSU") -AddToPath
# (C:\Users\YOUR_USERNAME\AppData\Roaming\PSU)
# Start-PSUServer -Port 8080
#
# To start dashboard run this script from PowerShell console:
#       ./dashboard.ps1
#
# Browse to http://localhost:10001
#
# To stop dashboard:
#       Get-UDDashboard | Stop-UDDashboard
#

# Change to your regional portal, e.g. "https://ams.fortify.com" etc.
$FODPortalUri = "https://emea.fortify.com"

# An example of creating a $Credential object and generating FOD authentication token
#$User = "tenant\username"
#$Password = ConvertTo-SecureString -String "password" -AsPlainText -Force
#$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password
#Set-FODConfig -ApiUri $FODPortalUri
#Get-FODToken -GrantType UsernamePassword -Credential $Credential

# A bar chart showing vulnerabilities by SDLC status and severity - in use "Retired" status should be filtered
$VulnerabilityChart = New-UDChart -Type Bar -Title "Vulnerabilities by SDLC Status and Severity" -Endpoint  {
    Get-FODReleases | Group-Object -Property sdlcStatusType |
            ForEach-Object -Process { [PSCustomObject]@{
                Id = $_.Name;
                critical = ($_.Group.critical | Measure-Object -sum).Sum;
                high = ($_.Group.high | Measure-Object -sum).Sum;
                medium = ($_.Group.medium | Measure-Object -sum).Sum;
                low = ($_.Group.low | Measure-Object -sum).Sum;
            }
            } | Out-UDChartData -LabelProperty "Id" -Dataset @(
    New-UdChartDataset -DataProperty critical -Label Critical -BackgroundColor "#FF0000" -HoverBackgroundColor "#FF6666"
    New-UdChartDataset -DataProperty high -Label High -BackgroundColor "#FF8000" -HoverBackgroundColor "#FFB266"
    New-UdChartDataset -DataProperty medium -Label Medium -BackgroundColor "#FFFF00" -HoverBackgroundColor "#FFFF66"
    New-UdChartDataset -DataProperty low -Label Low -BackgroundColor "#80FF00" -HoverBackgroundColor "#B2FF66"
    )
}

# A bar chart showing recent scans by type
$ScanChart = New-UDChart -Title "Recent Scans by Type" -Type Doughnut -RefreshInterval 5 -Endpoint {
    Get-FODScans -OrderBy completedDateTime -OrderByDirection "DESC" -Limit 50 | Group-Object -Property scanType |
        ForEach-Object -Process { [PSCustomObject]@{
            Type = $_.Name;
            Count = ($_.Group.scanType).Count;
        }
    } | Out-UDChartData -LabelProperty "Type" -Dataset @(
        New-UDChartDataset -DataProperty "Count" -BackgroundColor @("#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600") -HoverBackgroundColor @("#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600")
    )
} -Options @{
    legend = @{
        position = "left"
    }
}

# An example page containing some counters and charts
$HomePage = New-UDPage -Name "Home" -Content {
    New-UDRow -Columns {
        New-UDColumn -Size 4 {
            New-UDCounter -Title "Applications" -AutoRefresh -RefreshInterval 30 -Endpoint {
                (Get-FODApplications -Paging | Measure-Object).Count
            } -TextSize Large -TextAlignment center
        }
        New-UDColumn -Size 4 {
            New-UDCounter -Title "Releases" -AutoRefresh -RefreshInterval 30 -Endpoint {
                (Get-FODReleases -Paging | Measure-Object).Count
            } -TextSize Large -TextAlignment center
        }
        New-UDColumn -Size 4 {
            New-UDCounter -Title "Users" -AutoRefresh -RefreshInterval 30 -Endpoint {
                (Get-FODUsers -Paging | Measure-Object).Count
            } -TextSize Large -TextAlignment center
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 6 {
            $VulnerabilityChart
        }
        New-UDColumn -Size 6 {
            $ScanChart
        }
    }
}

# An example page containing more details of Applications
$AppPage = New-UDPage -Name "Applications" -Content {
    New-UdGrid -Title "Applications" -Headers @("Id", "Name", "Date Created", "Type", "Business Criticality") `
        -Properties @("applicationId", "applicationName", "applicationCreatedDate", "applicationType", "businessCriticalityType") `
        -AutoRefresh -RefreshInterval 60 -Endpoint {
            Get-FODApplications -Paging |
                    Select-Object @{Name='applicationId';Expression={New-UDLink -Text ($_.applicationId) -Url ($FODPortalUri+"/Applications/"+$_.applicationId)}},applicationName,applicationCreatedDate,applicationType,businessCriticalityType |
                        Out-UDGridData
        }
}

# Some empty pages
$ScanPage = New-UDPage -Name "Scans" -Content {
    New-UDCard -Title "Scans could go here..."
}

# The navigation sidebar
$Navigation = New-UDSideNav -Content {
    New-UDSideNavItem -Text "Home" -PageName "Home" -Icon Home
    New-UDSideNavItem -Text "Applications" -PageName "Applications" -Icon Cube
    New-UDSideNavItem -Text "Scans" -PageName "Scans" -Icon Bullseye
    New-UDSideNavItem -Text "Fortify on Demand" -Url ($FODPortalUri) -Icon Shield
}

# The footer
$Footer = New-UDFooter -Links @(
    New-UDLink -Text " | "
    New-UDLink -Text "Micro Focus" -Url "https://www.microfocus.com" -Icon Link
    New-UDLink -Text " | "
    New-UDLink -Text "Fortify" -Url "https://www.microfocus.com/en-us/solutions/application-security" -Icon Link
)

# The definition of the overall dashboard
$DevSecOpsDashboard = New-UDDashboard -Title "DevSecOps Dashboard" `
    -Pages @($HomePage, $AppPage, $ScanPage) -Navigation $Navigation -Footer $Footer

# Start the dashboard on port 1000 and auto reload if changes are made to this file (for development only)
Start-UDDashboard -Port 10001 -Dashboard $DevSecOpsDashboard -AutoReload
