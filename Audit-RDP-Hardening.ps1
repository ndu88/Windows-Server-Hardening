<#
.SYNOPSIS
Audits Remote Desktop (RDP) security configuration.

.DESCRIPTION
Checks key RDP hardening settings including:
- RDP enablement
- Network Level Authentication (NLA)
- Listening port
- Security layer
- Encryption level

This script is read-only and intended for security auditing and compliance review.

CIS Benchmark Guidance (High Level):
- RDP should only be enabled when required
- Network Level Authentication (NLA) must be enabled
- Security Layer should be set to SSL (TLS)
- Encryption Level should be set to High or FIPS compliant

.AUTHOR
Nduvho Madzivhandila
#>

$ComputerName = $env:COMPUTERNAME
$RDPBasePath  = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
$RDPTcpPath   = "$RDPBasePath\WinStations\RDP-Tcp"

# Initialise variables
$RDPEnabled       = "Unknown"
$NLAEnabled       = "Unknown"
$RDPPort          = "Unknown"
$SecurityLayer    = "Unknown"
$EncryptionLevel  = "Unknown"

# RDP Enabled / Disabled
try {
    $RDPEnabled = (Get-ItemProperty $RDPBasePath -ErrorAction Stop).fDenyTSConnections -eq 0
}
catch {
    Write-Warning "Unable to read RDP enablement setting"
}

# Network Level Authentication (NLA)
try {
    $NLAEnabled = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).UserAuthentication -eq 1
}
catch {
    Write-Warning "Unable to read NLA configuration"
}

# RDP Port
try {
    $RDPPort = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).PortNumber
}
catch {
    Write-Warning "Unable to read RDP port configuration"
}

# Security Layer
try {
    $SecurityLayerValue = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).SecurityLayer
    $SecurityLayer = switch ($SecurityLayerValue) {
        0 { "RDP Security Layer" }
        1 { "Negotiate" }
        2 { "SSL (TLS)" }
        Default { "Unknown" }
    }
}
catch {
    Write-Warning "Unable to read RDP security layer"
}

# Encryption Level
try {
    $EncryptionValue = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).MinEncryptionLevel
    $EncryptionLevel = switch ($EncryptionValue) {
        1 { "Low" }
        2 { "Client Compatible" }
        3 { "High" }
        4 { "FIPS Compliant" }
        Default { "Unknown" }
    }
}
catch {
    Write-Warning "Unable to read RDP encryption level"
}

# Build audit report
$Report = [PSCustomObject]@{
    ComputerName      = $ComputerName
    RDPEnabled        = $RDPEnabled
    NetworkLevelAuth  = $NLAEnabled
    RDPPort           = $RDPPort
    SecurityLayer     = $SecurityLayer
    EncryptionLevel   = $EncryptionLevel
}

# Output results
$Report | Format-List

# Export for audit evidence
$OutputFile = ".\RDP_Hardening_Audit_$ComputerName.csv"
$Report | Export-Csv $OutputFile -NoTypeInformation

Write-Output "RDP hardening audit completed. Results exported to $OutputFile"
