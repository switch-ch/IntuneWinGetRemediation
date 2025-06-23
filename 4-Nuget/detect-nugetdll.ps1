
if (Test-Path "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll") {
    Write-Output "file present"
    Exit 0
}
else {
    Write-Output "file missing"
    Exit 1
}