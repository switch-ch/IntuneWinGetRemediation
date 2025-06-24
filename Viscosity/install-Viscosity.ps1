<# SparkLabs.Viscosity installer
    Created by David Sass
    Created: 2024-11-18
#>
$packageId = 'SparkLabs.Viscosity'

$command = {
    $packageId = 'SparkLabs.Viscosity'

    $logPath = "c:\ProgramData\IntuneRemediation\$packageId-Remedy.txt"
    new-item $logPath -ItemType File -Force | Out-null

    Start-Transcript -Path $logPath -Force

    $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($ResolveWingetPath) {
        $WingetPath = $ResolveWingetPath[-1].Path
        $Wingetpath = Split-Path -Path $WingetPath -Parent
        Set-Location $wingetpath

        if ( $null -eq ( Get-WinGetPackage $packageId -ErrorAction SilentlyContinue ) ) {
    
            Write-Output "$packageId is not installed, installing it"
            Write-Host "$packageId is not installed, installing it"

            #.\winget.exe install --exact --id Microsoft.PowerShell --silent --accept-package-agreements --accept-source-agreements --scope machine --force
            Install-WinGetPackage -Id $packageId -Source 'Winget' -Force -Mode Silent -Scope System -ErrorAction SilentlyContinue 

        }
        else {
            Write-Output "$packageId is installed, making sure it is the latest"

            # get installed version
            $installed =  Get-WinGetPackage $packageId -ErrorAction SilentlyContinue
            
            if ( $false -eq $installed.IsUpdateAvailable ) {
                Write-Host  "$packageId latest version installed"
                Write-Output "$packageId latest version installed"
            }
            else {
                Write-Host "Installing $packageId to device scope"
                Write-Output "Installing $packageId to device scope"

                Install-WinGetPackage -Id $packageId -Source 'Winget' -Force -Mode Silent -Scope System -ErrorAction SilentlyContinue 
            }
        }
    }

    Stop-Transcript
    exit 0
}

import-module PSAppInsights
$Client = New-AIClient -key $env:InstrumentationKey -AllowPII
Send-AIEvent "Remedy $packageId - $(HOSTNAME.EXE)" -Flush

$o = pwsh.exe -c $command

$oo = $o | Out-String
Send-AITrace -Message $oo -Flush

Exit $LASTEXITCODE
