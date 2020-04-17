function Get-FODConfigPath
{
    [CmdletBinding()]
    param()

    end
    {
        if (Test-IsWindows)
        {
            Join-Path -Path $env:TEMP -ChildPath "$env:USERNAME-$env:COMPUTERNAME-PS4FOD.xml"
        }
        else
        {
            Join-Path -Path $env:HOME -ChildPath '.ps4fod' # Leading . and no file extension to be Unixy.
        }
    }
}
