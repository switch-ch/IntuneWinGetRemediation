$scriptRoot = (split-path -parent $MyInvocation.MyCommand.Definition)

Write-Warning "$scriptRoot\detect.ps1"

if ("pwsh" -eq (Get-Process -Id $pid).Name) { "pwsh" } else {"powershell"}
if ($IsWindows) { "Windows" }

$logPath = "c:\ProgramData\IntuneRemediation\Nuget-Check.txt"
new-item $logPath -ItemType File -Force -ErrorAction SilentlyContinue | Out-null

Start-Transcript -Path $logPath -Force -ErrorAction SilentlyContinue

Write-Host "Detect Nuget"

Get-PackageProvider | Select-Object Name, Version | Write-host
Get-PackageProvider | Select-Object Name, Version | Write-Output

$nuget = Get-PackageProvider -Name nuget -ErrorAction SilentlyContinue
Write-Output $nuget

if ($nuget) {
    if ($nuget.Version.Major -gt 1) { 
        Write-Host "nuget present"
        Write-Output "nuget present"
        exit 0
    } else {
        Write-Host "nuget needs update"
        Write-Output "nuget needs update"
        exit 1
    }
} else {
    Write-Host "nuget missing"
    Write-Output "nuget missing"
    exit 1
}

