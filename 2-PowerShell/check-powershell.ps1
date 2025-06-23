<# Microsoft.PowerShell checker
    Created by David Sass
    Created: 2024-10-04
#>

<# details
    1. Check if it is installed, if not install it.
    2. If installed check its version and compare it to the latest in Winget, if there is an update install it
    3. When the latest is installed, do nothing.
#>
$logPath = "c:\ProgramData\IntuneRemediation\PowerShell-Check.txt"
new-item $logPath -ItemType File -Force | Out-null

Start-Transcript -Path $logPath -Force

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($ResolveWingetPath) {
    $WingetPath = $ResolveWingetPath[-1].Path
    $Wingetpath = Split-Path -Path $WingetPath -Parent
    Set-Location $wingetpath

    if ( $null -eq (Get-Package "powershell*" -ErrorAction SilentlyContinue) ) {
        Write-Output "Microsoft.PowerShell not installed"

        Stop-Transcript
        exit 1
    }
    else {
        Write-Output "Microsoft.PowerShell is installed, making sure it is the latest"

        # get information of latest version
        $available = .\winget.exe search --exact --id Microsoft.PowerShell --source winget | Select-Object -Last 1 | ConvertFrom-Csv -Delimiter " " -Header "name", "Id", "Version"
        
        # get installed version
        $installed = Get-Package "powershell*"  -ErrorAction SilentlyContinue
    
        # compare version numbers
        if ( $installed.Version -eq $available.Version ) {
            Write-Output "Microsoft.PowerShell latest version installed"
        }
        else {
            Write-Output "Installing Microsoft.PowerShell to device scope needed"
            
            Stop-Transcript
            exit 1
        }
        
    }
}

Stop-Transcript