<#
.SYNOPSIS
Exports Windows Defender Firewall rules for baseline and audit purposes.

.DESCRIPTION
Retrieves all Windows Defender Firewall rules and exports key properties
to a CSV file. This script is read-only and intended for baseline
comparison, audit evidence, and compliance review.

CIS Benchmark Guidance (High Level):
- Firewall should be enabled for all profiles (Domain, Private, Public)
- Only required inbound rules should be allowed
- Firewall rules should be reviewed regularly for least privilege

.AUTHOR
Nduvho Madzivhandila
#>

$ComputerName = $env:COMPUTERNAME
$OutputFile  = ".\FirewallRules_Baseline_$ComputerName.csv"

Write-Output "[$ComputerName] Collecting Windows Firewall rules baseline..."

try {
    $FirewallRules = Get-NetFirewallRule -ErrorAction Stop |
        Select-Object `
            Name,
            DisplayName,
            Enabled,
            Direction,
            Action,
            Profile,
            Program,
            Service,
            Description

    $FirewallRules | Export-Csv $OutputFile -NoTypeInformation -Force

    Write-Output "Firewall rules baseline exported successfully."
    Write-Output "Baseline file: $OutputFile"
}
catch {
    Write-Error "Failed to export firewall rules. Error details: $_"
}

# Optional on-screen summary
$FirewallRules |
    Group-Object Direction, Action |
    Select-Object Name, Count |
    Format-Table -AutoSize
