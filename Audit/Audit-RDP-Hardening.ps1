<#
.SYNOPSIS
Audits Remote Desktop (RDP) security configuration.

.DESCRIPTION
Checks RDP enablement, Network Level Authentication (NLA),
listening port, security layer, and encryption level.
This script is read-only and intended for security auditing.

CIS Benchmark Guidance (High Level):
- RDP should only be enabled when required
- NLA must be enabled
- Security layer should be SSL (TLS)
- Encryption level should be High or FIPS compliant

.AUTHOR
Nduvho Madzivhandila
#>

$ComputerName = $env:COMPUTERNAME
$RDPBasePath  = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
$RDPTcpPath   = "$RDPBasePath\WinStations\RDP-Tcp"

# Initialise variables
$RDPEnabled      = "Unknown"
$NLAEnabled      = "Unknown"
$RDPPort         = "Unknown"
$SecurityLayer   = "Unknown"
$EncryptionLevel = "Unknown"

try {
    $RDPEnabled = (Get-ItemProperty $RDPBasePath -ErrorAction Stop).fDenyTSConnections -eq 0
    $NLAEnabled = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).UserAuthentication -eq 1
    $RDPPort    = (Get-ItemProperty $RDPTcpPath -ErrorAction Stop).PortNumber

    $SecurityLayer = switch ((Get-ItemProperty $RDPTcpPath).SecurityLayer) {
        0 { "RDP Security Layer" }
        1 { "Negotiate" }
        2 { "SSL (TLS)" }
        Default { "Unknown" }
    }

    $EncryptionLevel = switch ((Get-ItemProperty $RDPTcpPath).MinEncryptionLevel) {
        1 { "Low" }
        2 { "Client Compatible" }
        3 { "High" }
        4 { "FIPS Compliant" }
        Default { "Unknown" }
    }
}
catch {
    Write-Warning "Unable to retrieve one or more RDP configuration values."
}

$Report = [PSCustomObject]@{
    ComputerName      = $ComputerName
    RDPEnabled        = $RDPEnabled
    NetworkLevelAuth  = $NLAEnabled
    RDPPort           = $RDPPort
    SecurityLayer     = $SecurityLayer
    EncryptionLevel   = $EncryptionLevel
}

$Report | Format-List
$Report | Export-Csv ".\RDP_Hardening_Audit_$ComputerName.csv" -NoTypeInformation

Write-Output "RDP hardening audit completed successfully."
