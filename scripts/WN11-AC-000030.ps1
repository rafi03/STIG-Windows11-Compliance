<#
.SYNOPSIS
    Configures minimum password age to meet STIG WN11-AC-000030 requirements.
.DESCRIPTION
    Sets minimum password age to 1 day as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000030
#>

try {
    Write-Host "Configuring minimum password age..." -ForegroundColor Yellow
    
    # Set minimum password age to 1 day
    $result = & net accounts /minpwage:1 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Minimum password age successfully set to 1 day" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000030 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Minimum password age"
    } else {
        Write-Host "✗ Failed to set minimum password age" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring minimum password age: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users must wait 1 day between password changes." -ForegroundColor Yellow