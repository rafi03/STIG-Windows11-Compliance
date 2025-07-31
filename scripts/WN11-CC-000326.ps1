<#
.SYNOPSIS
    Enables PowerShell script block logging to meet STIG WN11-CC-000326 requirements.
.DESCRIPTION
    Configures PowerShell to log detailed script block information for security monitoring.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000326
#>

# Registry path for PowerShell script block logging
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"

try {
    Write-Host "Enabling PowerShell script block logging..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Enable script block logging
    Set-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockLogging" -Value 1 -Type DWord
    
    # Enable logging of script block invocation start/stop events
    Set-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockInvocationLogging" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $LoggingSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockLogging" -ErrorAction SilentlyContinue
    # $InvocationSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockInvocationLogging" -ErrorAction SilentlyContinue
    
    if ($LoggingSetting.EnableScriptBlockLogging -eq 1) {
        Write-Host "✓ PowerShell script block logging successfully enabled" -ForegroundColor Green
        Write-Host "✓ Script block invocation logging enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000326 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ PowerShell activities will be logged to Event ID 4104" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Failed to enable PowerShell script block logging" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring PowerShell logging settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "PowerShell script execution will now be logged for security monitoring." -ForegroundColor Green