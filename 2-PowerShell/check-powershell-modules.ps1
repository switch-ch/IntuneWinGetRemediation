
$logPath = "c:\ProgramData\IntuneRemediation\PowerShell-Modules-Check.txt"
New-item $logPath -ItemType File -Force -ErrorAction SilentlyContinue | Out-null

Start-Transcript -Path $logPath -Force -ErrorAction SilentlyContinue

Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules\" | Select-Object Name, LastWriteTime | Write-Output

if (test-path "C:\Program Files\WindowsPowerShell\Modules\Microsoft.WinGet.Client\*\net48\Microsoft.WinGet.Client.Cmdlets.dll") { 
    Write-Output "module present"
    exit 0
} else {
    Write-Output "module missing"
    exit 1
}