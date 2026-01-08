# Intune Remediation Detection script to check whether the ssh-agent service is disabled or not
$service = Get-Service ssh-agent

# if the service is disabled we return an error message and exit with code 1
if ($service.StartType -eq 'Disabled') {
    Write-Output "ssh-agent service is disabled."
    exit 1
} else {
    Write-Output "ssh-agent service is enabled."
    exit 0
}