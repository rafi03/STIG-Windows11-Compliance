# Troubleshooting Guide

This guide helps resolve common issues when running Windows 11 STIG compliance scripts.

## 🚨 Common Issues and Solutions

### Permission-Related Issues

#### Issue: "Access Denied" or "UnauthorizedAccessException"
**Symptoms:** 
```
✗ Error configuring registry: Access to the registry key 'HKEY_LOCAL_MACHINE\...' is denied.
```

**Solutions:**
1. **Run PowerShell as Administrator**
   ```powershell
   # Right-click PowerShell → "Run as Administrator"
   ```

2. **Verify Administrator Status**
   ```powershell
   ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
   ```
   Should return `True`

3. **Check User Account Control (UAC)**
   - Ensure UAC is not blocking registry modifications
   - Try running with UAC temporarily disabled (not recommended for production)

### Registry-Related Issues

#### Issue: "Cannot find path" or "Registry key does not exist"
**Symptoms:**
```
✗ Error: Cannot find path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\...'
```

**Solutions:**
1. **Path Creation Verification**
   ```powershell
   # Check if our scripts create paths properly
   $RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
   if (!(Test-Path $RegistryPath)) {
       Write-Host "Path does not exist, creating..." -ForegroundColor Yellow
       New-Item -Path $RegistryPath -Force
   }
   ```

2. **Manual Path Creation**
   ```powershell
   # Create the full path manually
   New-Item -Path "HKLM:\SOFTWARE\Policies" -Force
   New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Force
   New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Force
   New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force
   ```

#### Issue: "Data type mismatch" or "Invalid registry value type"
**Symptoms:**
```
✗ Cannot convert value "1" to type "System.Int32"
```

**Solutions:**
1. **Verify Data Types**
   ```powershell
   # Correct usage
   Set-ItemProperty -Path $Path -Name "Setting" -Value 1 -Type DWord        # For numbers
   Set-ItemProperty -Path $Path -Name "Setting" -Value "Block" -Type String # For text
   ```

2. **Clear Existing Values**
   ```powershell
   # Remove problematic registry value and recreate
   Remove-ItemProperty -Path $Path -Name "Setting" -ErrorAction SilentlyContinue
   Set-ItemProperty -Path $Path -Name "Setting" -Value 1 -Type DWord
   ```

### PowerShell Execution Policy Issues

#### Issue: "Execution of scripts is disabled on this system"
**Symptoms:**
```
.\script.ps1 : File cannot be loaded because running scripts is disabled on this system.
```

**Solutions:**
1. **Check Current Policy**
   ```powershell
   Get-ExecutionPolicy -List
   ```

2. **Set Appropriate Policy**
   ```powershell
   # For current user only (recommended)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   
   # For entire machine (requires admin)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
   ```

3. **Bypass for Single Session**
   ```powershell
   PowerShell.exe -ExecutionPolicy Bypass -File ".\script.ps1"
   ```

### Script-Specific Issues

#### Issue: FIPS Compliance Script Causes System Issues
**Symptoms:** Applications fail to start after enabling FIPS compliance

**Solutions:**
1. **Disable FIPS Mode**
   ```powershell
   # Emergency disable FIPS
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy" -Name "Enabled" -Value 0 -Type DWord
   ```

2. **Application Compatibility Check**
   - Test critical applications before deploying FIPS compliance
   - Some older applications don't support FIPS-compliant algorithms

#### Issue: PowerShell Transcription Fills Disk Space
**Symptoms:** Disk space rapidly consumed by PowerShell transcript logs

**Solutions:**
1. **Configure Log Rotation**
   ```powershell
   # Set up scheduled task to clean old transcripts
   $Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-Command 'Get-ChildItem C:\PowerShellTranscripts -Recurse | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-30)} | Remove-Item -Force'"
   $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2AM
   Register-ScheduledTask -TaskName "CleanPSTranscripts" -Action $Action -Trigger $Trigger -RunLevel Highest
   ```

2. **Monitor Disk Usage**
   ```powershell
   # Check transcript directory size
   $TranscriptPath = "C:\PowerShellTranscripts"
   $Size = (Get-ChildItem $TranscriptPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
   Write-Host "Transcript directory size: $([math]::Round($Size, 2)) MB"
   ```

### Verification Issues

#### Issue: Settings Don't Appear to Take Effect
**Symptoms:** Registry values are set correctly, but Group Policy or system behavior doesn't reflect changes

**Solutions:**
1. **Force Group Policy Update**
   ```powershell
   gpupdate /force
   ```

2. **Check Group Policy Application**
   ```powershell
   # Generate Group Policy report
   gpresult /h GPReport.html
   # Open GPReport.html to verify policy application
   ```

3. **Restart Required Settings**
   Some settings require system restart:
   - FIPS compliance (WN11-SO-000230)
   - Some autoplay settings
   - Certain security policies

4. **Registry Refresh**
   ```powershell
   # Force registry refresh for current session
   $signature = @'
   [DllImport("user32.dll", SetLastError = true)]
   public static extern bool SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
   '@
   $type = Add-Type -MemberDefinition $signature -Name Win32SendMessageTimeout -PassThru
   $HWND_BROADCAST = [IntPtr]0xffff
   $WM_SETTINGCHANGE = 0x1a
   $result = [UIntPtr]::Zero
   $type::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, "Environment", 2, 5000, [ref]$result)
   ```

## 🔍 Diagnostic Commands

### System Information
```powershell
# Check Windows version and edition
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, WindowsBuildLabEx

# Check PowerShell version
$PSVersionTable.PSVersion

# Check if domain-joined
(Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
```

### Registry Verification
```powershell
# Function to check all STIG settings
function Test-STIGCompliance {
    $Settings = @(
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"; Name="MaxSize"; Expected=32768},
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security"; Name="MaxSize"; Expected=1024000},
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\System"; Name="MaxSize"; Expected=32768}
        # Add more settings as needed
    )
    
    foreach ($Setting in $Settings) {
        try {
            $Current = Get-ItemProperty -Path $Setting.Path -Name $Setting.Name -ErrorAction Stop
            $ActualValue = $Current.($Setting.Name)
            
            if ($ActualValue -ge $Setting.Expected) {
                Write-Host "✓ $($Setting.Path)\$($Setting.Name): $ActualValue (Expected: $($Setting.Expected))" -ForegroundColor Green
            } else {
                Write-Host "✗ $($Setting.Path)\$($Setting.Name): $ActualValue (Expected: $($Setting.Expected))" -ForegroundColor Red
            }
        } catch {
            Write-Host "✗ $($Setting.Path)\$($Setting.Name): Not found or inaccessible" -ForegroundColor Red
        }
    }
}

# Run compliance check
Test-STIGCompliance
```

### Event Log Analysis
```powershell
# Check for recent policy application events
Get-WinEvent -FilterHashtable @{LogName='System'; ID=1502} -MaxEvents 10 | Format-Table TimeCreated, Message -Wrap

# Check for security policy changes
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4719} -MaxEvents 10 | Format-Table TimeCreated, Message -Wrap
```

## 📊 Performance Impact

### Expected Performance Changes
- **FIPS Compliance**: May slow cryptographic operations by 10-15%
- **PowerShell Logging**: Minimal CPU impact, moderate disk I/O increase
- **Event Log Sizing**: Increased disk usage for log storage
- **Autoplay Disabling**: No performance impact

### Monitoring Commands
```powershell
# Monitor PowerShell transcript disk usage
Get-ChildItem "C:\PowerShellTranscripts" -Recurse | 
    Measure-Object -Property Length -Sum | 
    ForEach-Object {
        [PSCustomObject]@{
            TotalSizeMB = [math]::Round($_.Sum / 1MB, 2)
            FileCount = $_.Count
        }
    }

# Monitor event log sizes
$Logs = @('Application', 'Security', 'System')
foreach ($Log in $Logs) {
    $LogInfo = Get-WinEvent -ListLog $Log
    Write-Host "$Log Log: $([math]::Round($LogInfo.FileSize / 1MB, 2)) MB" -ForegroundColor Cyan
}
```

## 🆘 Emergency Procedures

### Rollback All Changes
```powershell
# Create rollback script (run this BEFORE applying STIG changes)
$BackupPath = "C:\STIGBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows" $BackupPath
reg export "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" "$BackupPath.eventlogs"

# To restore (if needed)
# reg import $BackupPath
```

### System Recovery
If scripts cause system instability:

1. **Boot to Safe Mode**
2. **Restore Registry from Backup**
   ```cmd
   reg import C:\STIGBackup_[timestamp].reg
   ```
3. **Disable Problematic Policies**
   ```powershell
   # Disable FIPS if causing issues
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy" -Name "Enabled" -Value 0
   ```

## 📞 Getting Additional Help

### Resources
- **Microsoft Documentation**: [PowerShell Documentation](https://docs.microsoft.com/powershell/)
- **DISA STIG Library**: [https://public.cyber.mil/stigs/](https://public.cyber.mil/stigs/)
- **Project Issues**: [GitHub Issues](https://github.com/yourusername/windows11-stig-compliance/issues)

### Reporting Issues
When reporting issues, include:
- Windows 11 version and edition
- PowerShell version
- Complete error message
- Steps to reproduce
- Registry export of affected areas (if applicable)

### Support Matrix
| Issue Type | Response Time | Resolution Method |
|------------|---------------|-------------------|
| Critical Security | 24 hours | GitHub Issue + Priority Tag |
| Script Errors | 48 hours | GitHub Issue |
| Documentation | 1 week | GitHub Issue or PR |
| Enhancement Request | Best Effort | GitHub Discussion |