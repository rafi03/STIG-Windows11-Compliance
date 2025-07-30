<#
.SYNOPSIS
    Configures account lockout counter reset time to meet STIG WN11-AC-000015 requirements.
.DESCRIPTION
    Sets the reset counter time to 15 minutes as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000015
#>

try {
    Write-Host "Configuring account lockout counter reset time..." -ForegroundColor Yellow
    
    # Set lockout observation window to 15 minutes
    $result = & net accounts /lockoutwindow:15 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout counter reset time successfully set to 15 minutes" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000015 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "observation window"
    } else {
        Write-Host "✗ Failed to set lockout counter reset time" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring lockout counter: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Failed login attempts reset after 15 minutes of no activity." -ForegroundColor Yellow