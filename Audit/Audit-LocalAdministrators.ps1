<#
.SYNOPSIS
Audits local Administrators group membership.

.DESCRIPTION
Retrieves all members of the local Administrators group and exports
the results for security auditing and compliance review.
This script is read-only and does not modify system configuration.

CIS Benchmark Guidance (High Level):
- Membership of local Administrators should be limited
- Privileged access should be reviewed regularly

.AUTHOR
Nduvho Madzivhandila
#>

$ComputerName = $env:COMPUTERNAME
$OutputFile  = ".\LocalAdministrators_Audit_$ComputerName.csv"

Write-Output "[$ComputerName] Collecting local Administrators group members..."

try {
    Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop |
        Select-Object Name, ObjectClass, PrincipalSource |
        Export-Csv $OutputFile -NoTypeInformation -Force

    Write-Output "Local Administrators audit exported successfully."
    Write-Output "Audit file: $OutputFile"
}
catch {
    Write-Error "Failed to retrieve local Administrators group members. Error details: $_"
}
