# quick script to install the NuGet DLL if it is not present
# this is needed for the NuGet provider to work in PowerShell 5.1
# this should be a one-time remediation script that runs on devices that fails to install the NuGet provider

if (Test-Path "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll") {
    Write-Output "file present"
    Exit 0
}
else {
    New-Item "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll" -ItemType File -Force | Out-Null
    Invoke-WebRequest -Uri 'https://eastus8646.blob.core.windows.net/vscode-e/Microsoft.PackageManagement.NuGetProvider.dll' -OutFile "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll"
    Unblock-File "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll"
    Exit 0
}