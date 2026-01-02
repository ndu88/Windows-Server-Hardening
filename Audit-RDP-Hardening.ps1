<#
.SYNOPSIS
Audits Remote Desktop (RDP) security configuration.

.DESCRIPTION
Checks key RDP hardening settings including RDP enablement,
Network Level Authentication (NLA), listening port,
security layer, and encryption level.
This script is read-only and intended for security auditing.

.AUTHOR
Nduvho Madzivhandila
#>

$RDPBasePath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
$RDPTcpPath  = "$RDPBasePath\WinStations\RDP-Tcp"

# RDP Enabled / Disabled
$RDPEnabled = (Get-ItemProperty $RDPBasePath).fDenyTSConnections -eq 0

# NLA Status
$NLAEnabled = (Get-ItemProperty $RDPTcpPath).UserAuthentication -eq 1

# RDP Port
$RDPPort = (Get-ItemProperty $RDPTcpPath).PortNumber

# Security Layer
$SecurityLayerValue = (Get-ItemProperty $RDPTcpPath).SecurityLayer
$SecurityLayer = switch ($SecurityLayerValue) {
    0 { "RDP Security Layer" }
    1 { "Negotiate" }
    2 { "SSL (TLS)" }
    Default { "Unknown" }
}

# Encryption Level
$EncryptionValue = (Get-ItemProperty $RDPTcpPath).MinEncryptionLevel
$EncryptionLevel = switch ($EncryptionValue) {
    1 { "Low" }
    2 { "Client Compatible" }
    3 { "High" }
    4 { "FIPS Compliant" }
    Default { "Unknown" }
}

# Output Object
$Report = [PSCustomObject]@{
    RDPEnabled        = $RDPEnabled
    NetworkLevelAuth = $NLAEnabled
    RDPPort          = $RDPPort
    SecurityLayer    = $SecurityLayer
    EncryptionLevel  = $EncryptionLevel
}

$Report | Format-List

# Optional export for audit evidence
$Report | Export-Csv ".\RDP_Hardening_Audit.csv" -NoTypeInformation

Write-Output "RDP hardening audit completed. Results exported to RDP_Hardening_Audit.csv"
