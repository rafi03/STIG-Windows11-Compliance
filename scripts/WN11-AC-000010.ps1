<#
.SYNOPSIS
    Configures account lockout threshold to meet STIG WN11-AC-000010 requirements.
.DESCRIPTION
    Sets the account lockout threshold to 3 invalid attempts as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000010
#>

try {
    Write-Host "Configuring account lockout threshold..." -ForegroundColor Yellow
    
    # Set lockout threshold to 3 attempts
    $result = & net accounts /lockoutthreshold:3 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout threshold successfully set to 3 attempts" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000010 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Lockout threshold"
    } else {
        Write-Host "✗ Failed to set account lockout threshold" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring account lockout threshold: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Accounts will lock after 3 invalid password attempts." -ForegroundColor Yellow