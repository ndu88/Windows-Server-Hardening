<#
.SYNOPSIS
Exports Windows password and account lockout policy settings.

.DESCRIPTION
Retrieves the effective password and account lockout policies
configured on the system and exports them for baseline comparison,
audit, and compliance review.

# Note: net accounts reflects the effective local password and lockout policy
# applied to this system (local or via GPO)

This script is read-only and does not modify any system settings.

CIS Benchmark Guidance (High Level):
- Enforce minimum password length
- Enforce password complexity
- Configure account lockout threshold and duration
- Avoid unlimited password age

.AUTHOR
Nduvho Madzivhandila
#>

$ComputerName = $env:COMPUTERNAME
$OutputFile  = ".\PasswordPolicy_Baseline_$ComputerName.txt"

Write-Output "[$ComputerName] Collecting password and lockout policy baseline..."

try {
    $PolicyOutput = net accounts
    $PolicyOutput | Out-File $OutputFile -Force

    Write-Output "Password and account lockout policy exported successfully."
    Write-Output "Baseline file: $OutputFile"
}
catch {
    Write-Error "Failed to retrieve password policy. Error details: $_"
}

# Display output for quick review
$PolicyOutput

