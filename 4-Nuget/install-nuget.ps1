
$logPath = "c:\ProgramData\IntuneRemediation\Nuget-Remedy.txt"
new-item $logPath -ItemType File -Force -ErrorAction SilentlyContinue | Out-null

Start-Transcript -Path $logPath -Force -ErrorAction SilentlyContinue

Get-PackageProvider | Select-Object Name, Version | Write-host
Get-PackageProvider | Select-Object Name, Version | Write-Output


Write-host "installing"
Write-Output "installing"

Install-PackageProvider -Name NuGet -MinimumVersion 2.8 -Force -ErrorAction SilentlyContinue -Confirm:$false -Scope AllUsers -ErrorVariable SilentlyContinue

Write-host "done?"
Write-Output "done?"

Get-PackageProvider | Select-Object Name, Version | Write-host
Get-PackageProvider | Select-Object Name, Version | Write-Output

Write-Output 'hopefully installed'

exit 0
