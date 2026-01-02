# Windows Server Hardening

This repository contains PowerShell scripts focused on **auditing** and **baselining**
Windows Server security configurations.  
The primary goal is to improve **visibility, governance, and compliance**
by identifying security risks and capturing configuration baselines
before any hardening changes are applied.

The approach aligns with **enterprise best practices**, where security
controls are typically reviewed, approved, and enforced through
change-managed processes such as Group Policy or security baselines.

---

## Repository Structure

Windows-Server-Hardening/
├── Audit/
│ ├── Audit-LocalAdministrators.ps1
│ └── Audit-RDP-Hardening.ps1
│
├── Baselines/
│ ├── Export-FirewallRules.ps1
│ └── Get-PasswordPolicy.ps1
│
└── README.md


---

## Audit Scripts

Audit scripts are **read-only** and designed to identify security risks
without modifying system configuration.

### Included Audit Scripts
- **Audit-LocalAdministrators.ps1**  
  Audits membership of the local Administrators group to support
  privileged access reviews and least-privilege enforcement.

- **Audit-RDP-Hardening.ps1**  
  Audits Remote Desktop (RDP) security settings including:
  - RDP enablement
  - Network Level Authentication (NLA)
  - Listening port
  - Security layer (TLS)
  - Encryption level

---

## Baseline Scripts

Baseline scripts capture the **current security configuration**
to support compliance reviews, audits, and change comparison over time.

### Included Baseline Scripts
- **Get-PasswordPolicy.ps1**  
  Exports effective password and account lockout policies for audit
  and compliance validation.

- **Export-FirewallRules.ps1**  
  Exports Windows Defender Firewall rules to establish a security baseline
  and support least-privilege traffic reviews.

---

## Security & Compliance Approach

This repository follows a **security-first and audit-driven methodology**:

1. **Audit** – Identify insecure or high-risk configurations  
2. **Baseline** – Capture current state for governance and compliance  
3. **Harden** – Enforce changes through approved mechanisms
   (e.g. Group Policy, security baselines, or change management)

Legacy protocol hardening (such as SMBv1 or TLS 1.0/1.1) is intentionally
treated as a **policy and change-managed activity** rather than enforced
directly by scripts in this repository.

---

## Alignment & Best Practices

- CIS Benchmarks (high-level alignment)
- Least privilege principles
- Change management awareness
- Read-only auditing for production safety
- Enterprise Windows Server environments

---

## Disclaimer

All scripts are provided for **learning, auditing, and demonstration purposes**.
They should be tested in **non-production environments** and reviewed
according to organizational security and change management policies
before use in live systems.

---

## Author

**Nduvho Madzivhandila**  
Server Engineer | Windows Server | Security Auditing | PowerShell Automation
