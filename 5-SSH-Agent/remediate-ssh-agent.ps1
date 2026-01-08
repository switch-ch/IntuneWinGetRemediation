# Intune Remediation Detection script to enable the ssh-agent service if it is disabled
$service = Get-Service ssh-agent
try { 
    if ($service.StartType -eq 'Disabled') {
        Set-Service -Name ssh-agent -StartupType Automatic -ErrorAction Stop
        Start-Service -Name ssh-agent -ErrorAction Stop
        write-Output "ssh-agent service has been enabled and started."
        exit 0
    }
    else {
        write-Output "ssh-agent service is already enabled."
        exit 0
    }
}
catch {
    write-Output "An error occurred while trying to enable or start the ssh-agent service: $_"
    exit 1
}