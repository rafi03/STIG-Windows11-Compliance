<#
.SYNOPSIS
    Enables group membership auditing to meet STIG WN11-AU-000060 requirements.
.DESCRIPTION
    Configures system to include group membership information in logon events.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000060
#>

try {
    Write-Host "Enabling group membership auditing..." -ForegroundColor Yellow
    
    # Enable success auditing for group membership
    $result = & auditpol /set /subcategory:"Group Membership" /success:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Group membership auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000060 requirement satisfied" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Group Membership:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Group Membership"
        
        Write-Host "`nGroup membership info will be included in Event ID 4624 (Logon)" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Failed to enable group membership auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: User group memberships will be logged during authentication." -ForegroundColor Yellow