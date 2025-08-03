<# SparkLabs.Viscosity checker
    Created by David Sass
    Created: 2024-11-18
#>
$packageId = 'SparkLabs.Viscosity'

$command = {

    $packageId = 'SparkLabs.Viscosity'

    $logPath = "c:\ProgramData\IntuneRemediation\$packageId-Check.txt"
    new-item $logPath -ItemType File -Force | Out-null

    Start-Transcript -Path $logPath -Force

    $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($ResolveWingetPath) {
        $WingetPath = $ResolveWingetPath[-1].Path
        $Wingetpath = Split-Path -Path $WingetPath -Parent
        Set-Location $wingetpath

        if ( $null -eq ( Get-WinGetPackage $packageId -ErrorAction SilentlyContinue ) ) {
            Write-Output "$packageId not installed"
            Write-Host "$packageId not installed"
            Stop-Transcript
            exit 1
        
        }
        else {
            Write-Output "$packageId is installed, making sure it is the latest"
            Write-Host  "$packageId is installed, making sure it is the latest"
            # get installed version
            $installed =  Get-WinGetPackage $packageId -ErrorAction SilentlyContinue
            
            if ( $false -eq $installed.IsUpdateAvailable ) {
                Write-Host  "$packageId latest version installed"
                Write-Output "$packageId latest version installed"
            }
            else {
                Write-Host "Installing $packageId to device scope needed"
                Write-Output "Installing $packageId to device scope needed"
                
                Stop-Transcript
                exit 1
            }
            
        }
    }

    Stop-Transcript
    exit 0
}

import-module PSAppInsights
$Client = New-AIClient -Key $env:InstrumentationKey -AllowPII 
Send-AIEvent "Check $packageId - $(HOSTNAME.EXE)" -Flush

$o = pwsh.exe -c $command

$oo = $o | Out-String
Send-AITrace -Message $oo -Flush

Exit $LASTEXITCODE
