
$logPath = "c:\ProgramData\IntuneRemediation\PowerShell-Modules-v2-Remedy.txt"
New-item $logPath -ItemType File -Force -ErrorAction SilentlyContinue | Out-null

Start-Transcript -Path $logPath -Force -ErrorAction SilentlyContinue

# PS Modules to install/update - List your modules here:
$modules = @(
    'PowershellGet' 
    'PackageManagement'
    'PSReadLine'
    'Pester'
    'PSAppInsights'
    'Microsoft.WinGet.Client'
)

Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules\" | Select-Object Name, LastWriteTime | Write-Output

function Update-Modules([string[]]$modules) {
    #Loop through each module in the list
    foreach ($module in $modules) {
        # Check if the module exists
        if (Get-Module -Name $module -ListAvailable) {
            # Get the version of the currently installed module
            $installedVersionV = (Get-Module -ListAvailable $module) | Sort-Object Version -Descending  | Select-Object Version -First 1 

            # Convert version to string
            $stringver = $installedVersionV | Select-Object @{n = 'Version'; e = { $_.Version -as [string] } }
            $installedVersionS = $stringver | Select-Object Version -ExpandProperty Version
            Write-Host "Current version $module[$installedVersionS]"
            $installedVersionString = $installedVersionS.ToString()

            # Get the version of the latest available module from gallery
            $latestVersion = (Find-Module -Name $module).Version

            # Compare the version numbers
            if ($installedVersionString -lt $latestVersion) {
                # Update the module
                Write-Host "Found latest version $module [$latestVersion], updating.."
                # Attempt to update module via Update-Module
                try {
                    Update-Module -Name $module -Force -ErrorAction Stop
                    Write-Host "Updated $module to [$latestVersion]"
                }
                # Catch error and force install newer module
                catch {
                    Write-Host $_
                    Write-Host "Force installing newer module"
                    Install-Module -Name $module -Force -Scope AllUsers -Confirm:$false -SkipPublisherCheck
                    Write-Host "Updated $module to [$latestVersion]"
                }
                
            }
            else {
                # Already latest installed
                Write-Host "Latest version already installed"
            
            }
        }
        else {
            # Install the module if it doesn't exist
            Write-Host "Module not found, installing $module[$latestVersion].."
            Install-Module -Name $module -Repository PSGallery -Force -AllowClobber -Scope AllUsers -Confirm:$false
        }
    }
}

"$((Get-Date).ToFileTimeUtc())`tUpdate-Modules" | Out-File "C:\ProgramData\IntuneRemediation\Global-Script-History.txt" -Append -Force -ErrorAction SilentlyContinue

Update-Modules($modules)

Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules\" | Select-Object Name, LastWriteTime | Write-Output


Stop-Transcript
Exit 0