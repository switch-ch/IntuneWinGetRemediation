<# Winget updater
    Created by David Sass
    Created: 2024-06-20
#>

<# details
    1. Check if it is installed, if not install it.
    2. If installed check its version and compare it to the latest in Winget, if there is an update install it
    3. When the latest is installed, do nothing.
#>
$logPath = "c:\ProgramData\IntuneRemediation\DesktopAppInstaller-Remedy.txt"
New-Item $logPath -ItemType File -Force | Out-Null

Start-Transcript -Path $logPath -Force

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($ResolveWingetPath) {
    $WingetPath = $ResolveWingetPath[-1].Path
    $Wingetpath = Split-Path -Path $WingetPath -Parent
    Set-Location $wingetpath

    Write-Output "Microsoft.DesktopAppInstaller Installer"

    # get information of latest version
    $available = .\winget.exe search --exact --id Microsoft.AppInstaller --source winget | Select-Object -Last 1 | ConvertFrom-Csv -Delimiter " " -Header "name", "Id", "Version"
    
    # get installed version
    $installed = Get-AppxPackage Microsoft.DesktopAppInstaller -ea SilentlyContinue

    # compare version numbers
    if ( $(try { $installed.Version -eq $available.Version } catch { $false }) ) {
        Write-Output "Mattermost Desktop latest version installed"
    }
    else {
        Write-Output "Installing DesktopAppInstaller to device scope"

        .\winget.exe upgrade --exact --id Microsoft.AppInstaller --silent --accept-package-agreements --accept-source-agreements --scope machine --force
    }

}

Stop-Transcript