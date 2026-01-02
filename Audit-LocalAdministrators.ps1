<#
.SYNOPSIS
Audits local Administrators group membership.

.DESCRIPTION
Exports local Administrators group members for security auditing and review.

.AUTHOR
Nduvho Madzivhandila
#>

$OutputFile = ".\LocalAdministrators_Audit.csv"

Get-LocalGroupMember -Group "Administrators" |
Select-Object Name, ObjectClass, PrincipalSource |
Export-Csv $OutputFile -NoTypeInformation

Write-Output "Local Administrators audit exported to $OutputFile"
