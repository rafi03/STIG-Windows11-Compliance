<#
.SYNOPSIS
    Disables WinRM Basic authentication to meet STIG WN11-CC-000330 requirements.
.DESCRIPTION
    Prevents WinRM from using Basic authentication which transmits credentials insecurely.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000330
#>

# Registry path for WinRM client policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"

try {
    Write-Host "Disabling WinRM Basic authentication..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable Basic authentication
    Set-ItemProperty -Path $RegistryPath -Name "AllowBasic" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "AllowBasic" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.AllowBasic -eq 0) {
        Write-Host "✓ WinRM Basic authentication successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000330 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ WinRM will use secure authentication methods only" -ForegroundColor Green
        
        # Check WinRM configuration
        Write-Host "`nVerifying WinRM client configuration..." -ForegroundColor Cyan
        try {
            $winrmConfig = winrm get winrm/config/client
            Write-Host $winrmConfig | Select-String "Basic"
        } catch {
            Write-Host "Note: WinRM service may not be running" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Failed to disable WinRM Basic authentication" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring WinRM settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: WinRM will only use Kerberos or NTLM authentication." -ForegroundColor Yellow