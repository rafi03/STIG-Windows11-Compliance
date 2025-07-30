<#
.SYNOPSIS
    Configures minimum password length to meet STIG WN11-AC-000035 requirements.
.DESCRIPTION
    Sets minimum password length to 14 characters as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000035
#>

try {
    Write-Host "Configuring minimum password length..." -ForegroundColor Yellow
    
    # Set minimum password length to 14 characters
    $result = & net accounts /minpwlen:14 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Minimum password length successfully set to 14 characters" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000035 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Minimum password length"
    } else {
        Write-Host "✗ Failed to set minimum password length" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring minimum password length: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: All passwords must be at least 14 characters long." -ForegroundColor Yellow