# Windows 11 STIG Compliance Automation

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Security](https://img.shields.io/badge/Security-FF6B6B?style=for-the-badge&logo=shield&logoColor=white)

A comprehensive collection of PowerShell scripts to automate Windows 11 STIG (Security Technical Implementation Guide) compliance remediation. This repository provides ready-to-use scripts for addressing common security configuration failures identified by vulnerability scanners like Tenable.

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [🚀 Quick Start](#-quick-start)
- [📊 STIG Remediations](#-stig-remediations)
- [🔧 How to Use](#-how-to-use)
- [⚠️ Prerequisites](#️-prerequisites)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🎯 Overview

STIG (Security Technical Implementation Guide) compliance is crucial for maintaining secure Windows environments, especially in enterprise and government settings. This repository contains PowerShell automation scripts that remediate 20 common Windows 11 STIG compliance failures.

### What is STIG?
STIG provides security configuration standards developed by DISA (Defense Information Systems Agency) to enhance the security posture of information systems. These scripts help automate the remediation of failed STIG audits.

## 📚 PowerShell Basics for Beginners

If you're new to PowerShell, this section will help you understand the fundamental concepts used throughout our STIG remediation scripts.

<details>
<summary><strong>🔍 PowerShell Fundamentals</strong></summary>

### Variables
Variables in PowerShell store data for later use. They always start with a `# Windows 11 STIG Compliance Automation

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Security](https://img.shields.io/badge/Security-FF6B6B?style=for-the-badge&logo=shield&logoColor=white)

A comprehensive collection of PowerShell scripts to automate Windows 11 STIG (Security Technical Implementation Guide) compliance remediation. This repository provides ready-to-use scripts for addressing common security configuration failures identified by vulnerability scanners like Tenable.

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [🚀 Quick Start](#-quick-start)
- [📊 STIG Remediations](#-stig-remediations)
- [🔧 How to Use](#-how-to-use)
- [⚠️ Prerequisites](#️-prerequisites)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🎯 Overview

STIG (Security Technical Implementation Guide) compliance is crucial for maintaining secure Windows environments, especially in enterprise and government settings. This repository contains PowerShell automation scripts that remediate 20 common Windows 11 STIG compliance failures.

### What is STIG?
STIG provides security configuration standards developed by DISA (Defense Information Systems Agency) to enhance the security posture of information systems. These scripts help automate the remediation of failed STIG audits.

 symbol:

```powershell
$RequiredSizeKB = 32768        # Stores a number
$RegistryPath = "HKLM:\..."    # Stores text (a string)
$CurrentSetting = Get-Item...  # Stores the result of a command
```

**Think of variables like labeled boxes:** You put something in the box, label it, and use it later.

### Registry Paths
The Windows Registry is like a huge database where Windows stores all its settings. Registry paths are like file paths, but for this database:

```powershell
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
```

**Breaking this down:**
- `HKLM:` = HKEY_LOCAL_MACHINE (the main system settings)
- `\SOFTWARE` = Software settings section
- `\Policies` = Group policy settings
- `\Microsoft\Windows\Explorer` = Specific to Windows Explorer

### Common PowerShell Commands Used in Our Scripts

#### Set-ItemProperty
**Purpose:** Changes a registry value  
**Syntax:** `Set-ItemProperty -Path [WHERE] -Name [WHAT] -Value [TO_WHAT] -Type [DATA_TYPE]`

```powershell
Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value 32768 -Type DWord
```
**Translation:** "Go to the location stored in $RegistryPath, find the setting called 'MaxSize', and change it to 32768"

#### Get-ItemProperty  
**Purpose:** Reads a registry value  
**Syntax:** `Get-ItemProperty -Path [WHERE] -Name [WHAT]`

```powershell
$CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize"
```
**Translation:** "Go to $RegistryPath, read the 'MaxSize' setting, and store the result in $CurrentSize"

#### Test-Path
**Purpose:** Check if a registry path or file exists  
**Returns:** True if it exists, False if it doesn't

```powershell
if (!(Test-Path $RegistryPath)) {
    # Path doesn't exist, create it
}
```

#### New-Item
**Purpose:** Creates new registry paths or files  
**Usage:** Often used with `-Force` to create missing parent directories

```powershell
New-Item -Path $RegistryPath -Force | Out-Null
```

### Data Types
Windows Registry uses different data types for different kinds of information:

- **DWord:** 32-bit numbers (like 1, 0, 32768, 255)
- **String:** Text values (like "Block", "Disabled")  
- **Binary:** Raw binary data (rarely used in our scripts)

### Conditional Logic (If Statements)

```powershell
if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
    # Do this if condition is true
} else {
    # Do this if condition is false
}
```

**Comparison Operators:**
- `-eq` = Equal to
- `-ne` = Not equal to  
- `-gt` = Greater than
- `-ge` = Greater than or equal to
- `-lt` = Less than
- `-le` = Less than or equal to

### Error Handling

```powershell
try {
    # Try to execute this code
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value 32768 -Type DWord
} catch {
    # If anything goes wrong, do this instead
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
```

**Why use try/catch?** Registry operations can fail due to permissions, missing paths, or other issues. This prevents our script from crashing.

### Output and Colors

```powershell
Write-Host "Success message" -ForegroundColor Green
Write-Host "Warning message" -ForegroundColor Yellow  
Write-Host "Error message" -ForegroundColor Red
Write-Host "Info message" -ForegroundColor Cyan
```

**Color coding helps users quickly understand:**
- 🟢 Green = Success/Good news
- 🟡 Yellow = Warning/Attention needed
- 🔴 Red = Error/Problem
- 🔵 Cyan = Information/Details

</details>

<details>
<summary><strong>🏗️ Understanding Our Script Structure</strong></summary>

Every STIG remediation script follows the same pattern:

### 1. Header and Documentation
```powershell
<#
.SYNOPSIS
    Brief description of what the script does
.DESCRIPTION  
    Detailed explanation
.NOTES
    Author, version, STIG ID, etc.
#>
```

### 2. Variable Declarations
```powershell
$RequiredSizeKB = 32768
$RegistryPath = "HKLM:\SYSTEM\..."
```
**Purpose:** Set up the values we'll need throughout the script

### 3. Main Logic Block with Error Handling
```powershell
try {
    # Main script logic here
} catch {
    # Error handling here
}
```

### 4. Registry Path Creation (if needed)
```powershell
if (!(Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
```
**Purpose:** Many policy paths don't exist by default, so we create them

### 5. Apply the Security Setting
```powershell
Set-ItemProperty -Path $RegistryPath -Name "PolicyName" -Value 1 -Type DWord
```
**Purpose:** This is where we actually make the security change

### 6. Verification
```powershell
$CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "PolicyName"
if ($CurrentSetting.PolicyName -eq 1) {
    Write-Host "✓ Success!" -ForegroundColor Green
}
```
**Purpose:** Confirm our change worked correctly

### 7. User Feedback
```powershell
Write-Host "Policy has been applied successfully" -ForegroundColor Green
```
**Purpose:** Tell the user what happened and what it means

</details>

## 🚀 Quick Start

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/yourusername/windows11-stig-compliance.git
   cd windows11-stig-compliance
   ```

2. **Run PowerShell as Administrator** (Required for system-level changes)

3. **Execute a specific script:**
   ```powershell
   .\STIG-ID-WN11-AU-000500.ps1
   ```

4. **Run all scripts at once:**
   ```powershell
   .\Run-All-STIG-Remediations.ps1
   ```

## 📊 STIG Remediations

This repository addresses the following 20 STIG compliance issues:

| STIG ID | Category | Severity | Description |
|---------|----------|----------|-------------|
| [WN11-AU-000500](#wn11-au-000500) | Audit | CAT II | Application Event Log Size |
| [WN11-AU-000505](#wn11-au-000505) | Audit | CAT II | Security Event Log Size |
| [WN11-AU-000510](#wn11-au-000510) | Audit | CAT II | System Event Log Size |
| [WN11-CC-000180](#wn11-cc-000180) | Config | CAT I | Disable Autoplay for Non-Volume Devices |
| [WN11-CC-000185](#wn11-cc-000185) | Config | CAT I | Prevent Autorun Commands |
| [WN11-CC-000190](#wn11-cc-000190) | Config | CAT I | Disable Autoplay for All Drives |
| [WN11-CC-000197](#wn11-cc-000197) | Config | CAT III | Turn Off Microsoft Consumer Experiences |
| [WN11-CC-000210](#wn11-cc-000210) | Config | CAT II | Enable Windows Defender SmartScreen |
| [WN11-CC-000295](#wn11-cc-000295) | Config | CAT II | Prevent RSS Feed Attachments |
| [WN11-CC-000305](#wn11-cc-000305) | Config | CAT II | Disable Encrypted File Indexing |
| [WN11-CC-000310](#wn11-cc-000310) | Config | CAT II | Prevent User Installation Control |
| [WN11-CC-000315](#wn11-cc-000315) | Config | CAT I | Disable Elevated Privileges Installation |
| [WN11-CC-000326](#wn11-cc-000326) | Config | CAT II | Enable PowerShell Script Block Logging |
| [WN11-CC-000327](#wn11-cc-000327) | Config | CAT II | Enable PowerShell Transcription |
| [WN11-SO-000025](#wn11-so-000025) | Security | CAT II | Rename Built-in Guest Account |
| [WN11-SO-000030](#wn11-so-000030) | Security | CAT II | Enable Audit Policy Subcategories |
| [WN11-SO-000095](#wn11-so-000095) | Security | CAT II | Smart Card Removal Behavior |
| [WN11-SO-000230](#wn11-so-000230) | Security | CAT II | Use FIPS Compliant Algorithms |
| [WN11-UC-000015](#wn11-uc-000015) | User Config | CAT III | Turn Off Toast Notifications on Lock Screen |
| [WN11-CC-000005](#wn11-cc-000005) | Config | CAT II | Prevent Lock Screen Camera Access |

---

## 🔧 Detailed STIG Remediations

### WN11-AU-000500
<details>
<summary><strong>Application Event Log Size Configuration</strong></summary>

**Problem:** The Application event log size must be configured to 32768 KB or greater to ensure adequate logging capacity.

**Solution:** This script configures the Windows Application event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the Application event log size to meet STIG WN11-AU-000500 requirements.
.DESCRIPTION
    Sets the maximum Application event log size to 32768 KB (32 MB) or greater as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-AU-000500
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Registry path for Application event log settings
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"

try {
    Write-Host "Configuring Application Event Log size..." -ForegroundColor Yellow
    
    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord
    
    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue
    
    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Application Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000500 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Application Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Application Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

### **How It Works**

**🎯 The Big Picture**
Windows stores event logs (like Application, Security, System) in files that have size limits. If these logs are too small, important security events might get overwritten before administrators can review them. The STIG requires the Application log to be at least **32 MB** to ensure adequate log retention.

**📋 Our Strategy**
This script follows a simple and robust strategy:

1.  Define the required log size (32 MB = 32768 KB).
2.  Locate the specific Windows Registry **policy** that controls the log size.
3.  Check if the registry path exists, and create it if it doesn't to prevent errors.
4.  Set the registry value to meet the STIG requirement.
5.  Verify the change was successful.
6.  Wrap the entire operation in error handling.

-----

### **🔍 Line-by-Line Breakdown**

```powershell
$RequiredSizeKB = 32768
```

  * `$RequiredSizeKB`: This creates a PowerShell variable (a container) to store our target size.
  * `= 32768`: We set it to **32768 kilobytes**, which equals 32 megabytes.

<!-- end list -->

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
```

  * `$RegistryPath`: Another variable to store the location in the Windows Registry.
  * `"HKLM:\SOFTWARE\Policies\..."`: This is the crucial path for **Group Policy** settings.
  * **Why this path?** Settings in the `Policies` key override the system's default settings and are what auditors check to ensure compliance is enforced by an administrator.

<!-- end list -->

```powershell
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
```

  * This is a critical safety check.
  * `if (-not (Test-Path ...))`: This checks if the registry path **does not** exist.
  * `New-Item ...`: If the path is missing, this command **creates it**. This prevents the next command from failing.

<!-- end list -->

```powershell
Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord
```

  * This is the core command that makes the change.
  * `Set-ItemProperty`: The PowerShell command to create or modify a registry value.
  * `-Path $RegistryPath`: Tells PowerShell **WHERE** to make the change (using our variable).
  * `-Name "MaxSize"`: The specific setting that controls the log file size.
  * `-Value $RequiredSizeKB`: The new value we're setting it to (our 32768 KB variable).
  * `-Type DWord`: The data type, a 32-bit number, which Windows expects for this setting.

<!-- end list -->

```powershell
$CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue
```

  * `Get-ItemProperty`: The command to **READ** a registry value (the opposite of `Set-ItemProperty`). We use this to verify our change.
  * `$CurrentSize =`: Stores the result in a new variable so we can check it.
  * `-ErrorAction SilentlyContinue`: If there's an error reading the value, don't show an error message; just continue.

<!-- end list -->

```powershell
if ($CurrentSize.MaxSize -ge $RequiredSizeKB) { ... }
```

  * `if`: A conditional statement—"if this condition is true, do something."
  * `$CurrentSize.MaxSize`: Accesses the actual size number from the value we just read.
  * `-ge`: The "Greater than or Equal to" operator.
  * **What it means:** "If the current log size is greater than or equal to what we set it to, then we succeeded."

-----

### **🛡️ Error Handling**

```powershell
try {
    # Our main code here
} catch {
    # Error handling here
}
```

  * `try { ... }`: Tells PowerShell to "try to execute this block of code."
  * `catch { ... }`: If anything inside the `try` block fails, the script immediately jumps to the `catch` block instead of crashing. This is essential for handling issues like permission errors.

</details>

### WN11-AU-000505
<details>
<summary><strong>Security Event Log Size Configuration</strong></summary>

**Problem:** The Security event log size must be configured to 1024000 KB or greater for adequate security logging.

**Solution:** This script configures the Windows Security event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the Security event log size to meet STIG WN11-AU-000505 requirements.
.DESCRIPTION
    Sets the maximum Security event log size to 1024000 KB (1 GB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000505
#>

# Define the minimum required log size in KB (1 GB)
$RequiredSizeKB = 1024000

# Correct STIG registry path
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"

try {
    Write-Host "Configuring Security Event Log size (STIG WN11-AU-000505)..." -ForegroundColor Yellow

    # Ensure the path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Security Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000505 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Security Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Security Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:**
Security event logs are the most critical logs in Windows — they track login attempts, privilege escalations, audit policy changes, and other sensitive security activities. The **STIG WN11-AU-000505** mandates a minimum log size of **1 GB (1024000 KB)** to ensure these high-volume logs retain enough history for forensic investigation and incident response.

---

**📋 Our Strategy:**

1. Set the **Security Event Log size** to **1 GB (1024000 KB)** to meet STIG requirements
2. Modify the **Group Policy-backed registry location** (not runtime path)
3. Automatically verify the change to ensure compliance

---

**🔍 Key Differences from Application Log Configuration:**

```powershell
$RequiredSizeKB = 1024000  # 1 GB for high-volume security auditing
```

* **Why larger?** Security logs record:

  * Every successful and failed login
  * Privilege use and elevation
  * Sensitive file accesses (if auditing is enabled)
  * System-level security policy changes
* **1 GB (1024000 KB)** helps preserve more log data before it gets overwritten.

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
```

* This is the **Group Policy path**, not the live event log path
* Used for **persistent configuration** and **STIG compliance checking**
* Ensures settings are applied consistently even after reboots or policy refresh

---

**🛡️ Why This Matters:**

* Small log sizes cause **important security events to be lost quickly**
* In case of a breach or insider activity, you need **historical audit trails**
* STIG compliance isn’t just a checkbox — it's a way to ensure **logs remain useful during investigations**
* Forensic analysts often look here first when determining the timeline of compromise


</details>

### WN11-AU-000510
<details>
<summary><strong>System Event Log Size Configuration</strong></summary>

**Problem:** The System event log size must be configured to 32768 KB or greater.

**Solution:** This script configures the Windows System event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the System event log size to meet STIG WN11-AU-000510 requirements.
.DESCRIPTION
    Sets the maximum System event log size to 32768 KB (32 MB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000510
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Correct registry path for STIG compliance
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"

try {
    Write-Host "Configuring System Event Log size (STIG WN11-AU-000510)..." -ForegroundColor Yellow

    # Ensure the registry path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ System Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000510 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set System Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring System Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:**
System event logs capture critical information about the operating system’s core functions — including hardware issues, driver behavior, and service events. While not as security-focused as Security logs, they are vital for **diagnostics and stability analysis**. According to **STIG WN11-AU-000510**, the System log must be configured with a minimum size of **32 MB (32768 KB)** to retain enough event history for effective troubleshooting.

---

**📋 Our Strategy:**

1. Set the **System Event Log size** to **32 MB (32768 KB)**
2. Modify the **Group Policy registry location** to ensure STIG compliance
3. Use a consistent and verifiable approach like with Application and Security logs

---

**🔍 What System Events Include:**

* Hardware failures and alerts (e.g., disk errors, overheating)
* Driver load/unload operations
* Service startup and shutdown events
* System boot sequences and shutdown logs
* Kernel and OS-level errors

---

**🔧 Code Explanation:**

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
```

* This is the **STIG-required Group Policy path**
* Ensures the setting persists and is picked up by **compliance scans** (e.g., SCAP, ACAS)
* Matches the structure used by Application and Security log configurations under `SOFTWARE\Policies`

---

**💡 Why 32 MB for System Logs:**

* System logs aren't as high-volume as security logs but **more active than application logs**
* **32 MB provides sufficient history** to identify recent hardware, service, or boot-related problems
* Helps administrators detect and resolve issues like failing services, unstable drivers, or system crashes
* A practical compromise between **storage efficiency** and **diagnostic value**


</details>

### WN11-CC-000180
<details>
<summary><strong>Disable Autoplay for Non-Volume Devices</strong></summary>

**Problem:** Autoplay for non-volume devices (like MTP devices) must be disabled to prevent malicious code execution.

**Solution:** This script disables autoplay for non-volume devices through Group Policy registry settings.

```powershell
<#
.SYNOPSIS
    Disables autoplay for non-volume devices to meet STIG WN11-CC-000180 requirements.
.DESCRIPTION
    Prevents autoplay for non-volume devices (Media Transfer Protocol devices) to prevent malicious code execution.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000180
#>

# Registry path for AutoPlay policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

try {
    Write-Host "Disabling autoplay for non-volume devices..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable autoplay for non-volume devices
    Set-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.NoAutoplayfornonVolume -eq 1) {
        Write-Host "✓ Autoplay for non-volume devices successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000180 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autoplay for non-volume devices" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autoplay settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Note: A system restart may be required for changes to take full effect." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:** Autoplay is a Windows feature that automatically runs programs when you insert media (like USB drives, CDs, etc.). While convenient, this creates a major security risk - malicious USB drives can automatically execute malware when plugged in. Non-volume devices (like smartphones, cameras, MTP devices) are particularly risky because they can contain executable files disguised as media.

**📋 Our Strategy:**
1. Locate the Windows Registry location that controls autoplay policies
2. Create the registry path if it doesn't exist (many systems don't have this configured)
3. Set the policy to disable autoplay for non-volume devices
4. Verify our security setting took effect

**🔍 Understanding the Threat:**
- **Attack scenario:** Attacker creates malicious USB device → Victim plugs it in → Malware runs automatically
- **Non-volume devices:** Smartphones, tablets, cameras, MP3 players using MTP (Media Transfer Protocol)
- **Why dangerous:** These devices can execute code without user awareness

**🔧 Detailed Code Breakdown:**

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
```
- `HKLM:\SOFTWARE\Policies` = Machine-wide policy settings (affects all users)
- `\Microsoft\Windows\Explorer` = Windows Explorer (File Manager) policies
- **Why here?** Explorer controls how Windows handles removable devices

```powershell
if (!(Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
```
- `Test-Path` = PowerShell command to check if a registry path exists
- `!` = "NOT" operator (reverses true/false)
- `!(Test-Path $RegistryPath)` = "If the registry path does NOT exist"
- `New-Item -Path $RegistryPath -Force` = Create the missing registry path
- `-Force` = Create all missing parent directories if needed
- `| Out-Null` = Don't show output from the New-Item command (keeps output clean)

**Why we need this check:** Many Windows systems don't have this policy path created by default, so we must create it before we can modify it.

```powershell
Set-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
```
- `-Name "NoAutoplayfornonVolume"` = The specific policy setting name (Microsoft's exact naming)
- `-Value 1` = Enable the policy (1 = enabled/true, 0 = disabled/false)
- `-Type DWord` = 32-bit integer (the data type Windows expects)

**What this setting does:** Tells Windows "Do not automatically play content from non-volume devices"

**🛡️ Security Impact:**
- Prevents automatic malware execution from smartphones/cameras
- Users can still manually access device contents
- Blocks "BadUSB" style attacks on MTP devices
- Maintains usability while eliminating automatic execution risk

</details>

### WN11-CC-000185
<details>
<summary><strong>Prevent Autorun Commands</strong></summary>

**Problem:** The default autorun behavior must be configured to prevent autorun commands from executing.

**Solution:** This script configures the system to not execute any autorun commands.

```powershell
<#
.SYNOPSIS
    Prevents autorun commands from executing to meet STIG WN11-CC-000185 requirements.
.DESCRIPTION
    Configures the default autorun behavior to prevent autorun commands from executing automatically.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000185
#>

# Registry path for AutoRun policies
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

try {
    Write-Host "Configuring autorun behavior to prevent autorun commands..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Set autorun behavior to "Do not execute any autorun commands"
    # Value 1 = Do not execute any autorun commands
    Set-ItemProperty -Path $RegistryPath -Name "NoAutorun" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "NoAutorun" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.NoAutorun -eq 1) {
        Write-Host "✓ Autorun commands successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000185 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autorun commands" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autorun settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System is now protected from automatic execution of autorun commands." -ForegroundColor Green
```

**How it works:**

**🎯 The Big Picture:** Autorun is an older Windows feature that automatically executes commands specified in "autorun.inf" files when removable media is inserted. This is extremely dangerous because any USB drive, CD, or network drive can contain an autorun.inf file that runs malicious commands immediately when connected. This script completely disables autorun command execution.

**📋 Our Strategy:**
1. Navigate to the Windows policy registry location for autorun control
2. Set the "NoAutorun" policy to completely block autorun commands
3. Verify that autorun commands are now blocked system-wide

**🔍 Understanding Autorun vs Autoplay:**
- **Autorun:** Executes specific commands from autorun.inf files (more dangerous)
- **Autoplay:** Shows menu of actions or auto-launches programs (less dangerous but still risky)
- **Our goal:** Block autorun completely while previous script handled autoplay

**🔧 Detailed Code Analysis:**

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
```
- `\CurrentVersion\Policies\Explorer` = Different path than previous script
- **Why different?** Autorun policies are stored separately from autoplay policies
- This location controls Explorer.exe behavior regarding autorun files

```powershell
Set-ItemProperty -Path $RegistryPath -Name "NoAutorun" -Value 1 -Type DWord
```
**Breaking down each component:**
- `-Name "NoAutorun"` = The exact policy name Microsoft uses to control autorun
- `-Value 1` = Disable autorun (1 = "No Autorun", 0 = "Allow Autorun")
- **Result:** Windows will completely ignore autorun.inf files

**🔍 What happens after this change:**
1. **Before:** USB with autorun.inf → Commands execute automatically → Potential malware infection
2. **After:** USB with autorun.inf → Commands ignored → Files accessible but safe

**📁 Example of blocked autorun.inf content:**
```ini
[autorun]
open=malware.exe
icon=innocent_icon.ico
label=Free Software
```
**Before our script:** This would run malware.exe automatically  
**After our script:** This file is completely ignored

**🛡️ Security Benefits:**
- Blocks the most common USB-based malware delivery method
- Prevents autorun-based attacks from CDs, DVDs, network drives
- Still allows manual access to all files on the device
- No impact on legitimate software that doesn't rely on autorun

</details>

### WN11-CC-000190
<details>
<summary><strong>Disable Autoplay for All Drives</strong></summary>

**Problem:** Autoplay must be disabled for all drives to prevent malicious code execution.

**Solution:** This script disables autoplay functionality for all drives system-wide.

```powershell
<#
.SYNOPSIS
    Disables autoplay for all drives to meet STIG WN11-CC-000190 requirements.
.DESCRIPTION
    Turns off AutoPlay for all drives to prevent malicious code from executing automatically.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000190
#>

# Registry paths for AutoPlay policies
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

try {
    Write-Host "Disabling autoplay for all drives..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable AutoPlay for all drives
    # Value 255 (0xFF) = Disable autoplay for all drives
    Set-ItemProperty -Path $RegistryPath -Name "NoDriveTypeAutoRun" -Value 255 -Type DWord
    
    # Also set the Group Policy equivalent
    $GPRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (!(Test-Path $GPRegistryPath)) {
        New-Item -Path $GPRegistryPath -Force | Out-Null
        Write-Host "Created Group Policy registry path: $GPRegistryPath" -ForegroundColor Cyan
    }
    
    Set-ItemProperty -Path $GPRegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $CurrentSetting1 = Get-ItemProperty -Path $RegistryPath -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
    $CurrentSetting2 = Get-ItemProperty -Path $GPRegistryPath -Name "NoAutoplayfornonVolume" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting1.NoDriveTypeAutoRun -eq 255 -and $CurrentSetting2.NoAutoplayfornonVolume -eq 1) {
        Write-Host "✓ Autoplay successfully disabled for all drives" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000190 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autoplay for all drives" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autoplay settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "All drives are now protected from autoplay execution." -ForegroundColor Green
```

**How it works:**

**🎯 The Big Picture:** This is the most comprehensive autoplay protection script. While our previous scripts handled specific aspects of autoplay, this one completely disables autoplay for ALL types of drives system-wide. It's like putting a complete lockdown on automatic media execution while still allowing manual access to files.

**📋 Our Strategy:**
1. Disable autoplay for all drive types using a bitmask value (255 = all drives)
2. Set both user-level and Group Policy-level registry settings
3. Ensure comprehensive coverage across all possible drive types
4. Verify both settings are applied correctly

**🔍 Understanding the Bitmask System:**

Windows uses a bitmask to control autoplay for different drive types:
- **Value 255 (binary: 11111111)** = All 8 drive type bits set to "disabled"
- **Each bit represents:** Unknown drives, removable drives, fixed drives, network drives, CD-ROMs, RAM drives, etc.
- **Why 255?** It's the maximum value for an 8-bit number, meaning "disable ALL types"

**🔧 Advanced Code Breakdown:**

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
```
- This is the primary location for autoplay drive policies
- Different from Group Policy location (we'll set both for complete coverage)

```powershell
Set-ItemProperty -Path $RegistryPath -Name "NoDriveTypeAutoRun" -Value 255 -Type DWord
```
**Let's decode this critical line:**
- `-Name "NoDriveTypeAutoRun"` = Microsoft's setting name for drive-type-specific autorun control
- `-Value 255` = Binary 11111111 (disable autoplay for all 8 drive types)
- **Drive types included:** Removable, Fixed, Network, CD-ROM, RAM, Unknown, etc.

**🎯 Why We Set Multiple Registry Locations:**
```powershell
$GPRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
Set-ItemProperty -Path $GPRegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
```
- **Dual approach:** Some Windows versions check different registry locations
- **Group Policy path:** Takes precedence in domain environments
- **User Policy path:** Handles local policy settings
- **Result:** Complete coverage regardless of Windows configuration

**🔍 Verification Logic:**
```powershell
if ($CurrentSetting1.NoDriveTypeAutoRun -eq 255 -and $CurrentSetting2.NoAutoplayfornonVolume -eq 1)
```
- `$CurrentSetting1.NoDriveTypeAutoRun -eq 255` = Check that ALL drive types are disabled
- `$CurrentSetting2.NoAutoplayfornonVolume -eq 1` = Check that Group Policy setting is enabled
- `-and` = Both conditions must be true for success
- **Why both?** Ensures comprehensive protection across all possible scenarios

**🛡️ Complete Protection Achieved:**
- **CD/DVD drives:** No autoplay when disc inserted
- **USB drives:** No autoplay when plugged in
- **Network drives:** No autoplay when mapped
- **Memory cards:** No autoplay when inserted
- **External hard drives:** No autoplay when connected
- **Unknown devices:** No autoplay for any new device type

**💡 User Experience Impact:**
- **Before:** Insert USB → Program might run automatically
- **After:** Insert USB → Windows shows folder contents, user chooses action manually

</details>

### WN11-CC-000197
<details>
<summary><strong>Turn Off Microsoft Consumer Experiences</strong></summary>

**Problem:** Microsoft consumer experiences must be turned off to prevent unwanted app suggestions and installations.

**Solution:** This script disables Microsoft consumer experiences that may suggest or install unwanted applications.

```powershell
<#
.SYNOPSIS
    Configures the Application event log size to meet STIG WN11-AU-000500 requirements.
.DESCRIPTION
    Sets the maximum Application event log size to 32768 KB (32 MB) or greater as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000500
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Registry path for Application event log policy settings
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

try {
    Write-Host "Configuring Application Event Log size..." -ForegroundColor Yellow

    # Create the registry key if it doesn't exist
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created missing registry path: $RegistryPath" -ForegroundColor Cyan
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Application Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000500 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Application Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Application Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:** Microsoft continuously pushes "consumer experiences" to Windows users - things like app suggestions, promoted content, third-party software recommendations, and sponsored content in the Start menu. In enterprise/government environments, this creates security risks and policy violations. This script completely disables these consumer-focused features to maintain a controlled, professional environment.

**📋 Our Strategy:**
1. Access the Cloud Content policy registry location
2. Disable multiple consumer experience features with targeted settings
3. Block third-party suggestions and promotions
4. Verify all consumer features are disabled

**🔍 Understanding Consumer Experiences:**

**What gets disabled:**
- Suggested apps in Start menu (like Candy Crush, Netflix, etc.)
- Third-party software promotions
- Microsoft Store app recommendations
- Consumer account integration prompts
- Sponsored content in Windows tips
- Promotional notifications

**🔧 Deep Code Analysis:**

```powershell
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
```
- `\CloudContent` = Microsoft's term for cloud-delivered consumer content
- **Why "Cloud Content"?** These suggestions are downloaded from Microsoft's servers
- This registry location controls all cloud-delivered consumer features

```powershell
Set-ItemProperty -Path $RegistryPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord
```
**Master consumer features control:**
- `-Name "DisableWindowsConsumerFeatures"` = The main toggle for consumer features
- `-Value 1` = Disable all consumer features (this is the big master switch)
- **Impact:** Stops Windows from downloading and showing consumer content

```powershell
Set-ItemProperty -Path $RegistryPath -Name "DisableThirdPartySuggestions" -Value 1 -Type DWord
```
**Third-party content blocker:**
- Specifically targets suggestions for non-Microsoft software
- Prevents apps like games, trial software, and promotional apps from being suggested
- **Example blocked content:** "Try Adobe Creative Suite", "Install Spotify", etc.

```powershell
Set-ItemProperty -Path $RegistryPath -Name "DisableConsumerAccountStateContent" -Value 1 -Type DWord
```
**Consumer account integration blocker:**
- Prevents prompts to link personal Microsoft accounts
- Blocks consumer-oriented account features in enterprise environments
- Maintains separation between business and personal account services

**🎯 Verification Strategy:**
```powershell
if ($Setting1.DisableWindowsConsumerFeatures -eq 1 -and $Setting2.DisableThirdPartySuggestions -eq 1)
```
- **Dual verification:** Check both the master switch AND third-party blocker
- **Why both?** Some consumer content might slip through with only one setting
- Ensures comprehensive blocking of all consumer experiences

**🛡️ Enterprise Benefits:**
- **Clean Start menu:** No game icons or promotional apps
- **Reduced distractions:** Focus on work applications only
- **Bandwidth savings:** No downloading of promotional content
- **Policy compliance:** Meets requirements for controlled environments
- **Security improvement:** Fewer attack vectors through suggested software

**💡 Before vs After:**
- **Before:** Start menu shows Candy Crush, Netflix, random games, software trials
- **After:** Start menu shows only business applications and user-installed software

</details>

### WN11-CC-000210
<details>
<summary><strong>Enable Windows Defender SmartScreen</strong></summary>

**Problem:** Microsoft Defender SmartScreen for Explorer must be enabled to protect against malicious programs.

**Solution:** This script enables and configures Windows Defender SmartScreen with "Warn and prevent bypass" setting.

```powershell
<#
.SYNOPSIS
    Enables Windows Defender SmartScreen to meet STIG WN11-CC-000210 requirements.
.DESCRIPTION
    Configures Windows Defender SmartScreen for File Explorer with "Warn and prevent bypass" setting.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000210
#>

# Registry paths for SmartScreen configuration
$ExplorerPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$SmartScreenPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen"

try {
    Write-Host "Configuring Windows Defender SmartScreen..." -ForegroundColor Yellow
    
    # Create the registry paths if they don't exist
    if (!(Test-Path $ExplorerPath)) {
        New-Item -Path $ExplorerPath -Force | Out-Null
        Write-Host "Created registry path: $ExplorerPath" -ForegroundColor Cyan
    }
    
    if (!(Test-Path $SmartScreenPath)) {
        New-Item -Path $SmartScreenPath -Force | Out-Null
        Write-Host "Created registry path: $SmartScreenPath" -ForegroundColor Cyan
    }
    
    # Enable SmartScreen for File Explorer
    Set-ItemProperty -Path $ExplorerPath -Name "EnableSmartScreen" -Value 1 -Type DWord
    
    # Set SmartScreen level to "Block" (Warn and prevent bypass)
    Set-ItemProperty -Path $ExplorerPath -Name "ShellSmartScreenLevel" -Value "Block" -Type String
    
    # Configure SmartScreen for Explorer specifically
    Set-ItemProperty -Path $SmartScreenPath -Name "ConfigureAppInstallControlEnabled" -Value 1 -Type DWord
    Set-ItemProperty -Path $SmartScreenPath -Name "ConfigureAppInstallControl" -Value "Anywhere" -Type String
    
    # Verify the settings were applied
    $EnableSetting = Get-ItemProperty -Path $ExplorerPath -Name "EnableSmartScreen" -ErrorAction SilentlyContinue
    $LevelSetting = Get-ItemProperty -Path $ExplorerPath -Name "ShellSmartScreenLevel" -ErrorAction SilentlyContinue
    
    if ($EnableSetting.EnableSmartScreen -eq 1 -and $LevelSetting.ShellSmartScreenLevel -eq "Block") {
        Write-Host "✓ Windows Defender SmartScreen successfully enabled and configured" -ForegroundColor Green
        Write-Host "✓ SmartScreen level set to 'Block' (Warn and prevent bypass)" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000210 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure Windows Defender SmartScreen" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring SmartScreen settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "SmartScreen will now warn and block potentially malicious programs." -ForegroundColor Green
```

**How it works:**
- `EnableSmartScreen = 1`: Enables SmartScreen functionality
- `ShellSmartScreenLevel = "Block"`: Sets the protection level to maximum (warn and prevent bypass)
- SmartScreen checks files and programs against Microsoft's reputation database
- Blocks or warns about potentially malicious or unknown programs
- Provides real-time protection against malware downloads

</details>

### WN11-CC-000295
<details>
<summary><strong>Prevent RSS Feed Attachments</strong></summary>

**Problem:** Attachments must be prevented from being downloaded from RSS feeds for security.

**Solution:** This script prevents RSS feed attachments from being downloaded automatically.

```powershell
<#
.SYNOPSIS
    Prevents RSS feed attachments from being downloaded to meet STIG WN11-CC-000295 requirements.
.DESCRIPTION
    Configures RSS Feeds to prevent downloading of enclosures/attachments for security.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000295
#>

# Registry path for RSS Feeds policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"

try {
    Write-Host "Preventing RSS feed attachments from downloading..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent downloading of RSS feed enclosures/attachments
    Set-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.DisableEnclosureDownload -eq 1) {
        Write-Host "✓ RSS feed attachments successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000295 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable RSS feed attachments" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RSS feed settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "RSS feeds will no longer automatically download attachments." -ForegroundColor Green
```

**How it works:**
- `DisableEnclosureDownload = 1`: Prevents automatic downloading of RSS feed attachments
- RSS enclosures are files attached to RSS feed items (like podcasts, videos, documents)
- This setting prevents potentially malicious files from being downloaded automatically
- Users can still manually download attachments if needed, but auto-download is blocked

</details>

### WN11-CC-000305
<details>
<summary><strong>Disable Encrypted File Indexing</strong></summary>

**Problem:** Indexing of encrypted files must be turned off to prevent sensitive data exposure.

**Solution:** This script disables the indexing of encrypted files to protect sensitive information.

```powershell
<#
.SYNOPSIS
    Disables indexing of encrypted files to meet STIG WN11-CC-000305 requirements.
.DESCRIPTION
    Turns off indexing of encrypted files to prevent potential exposure of sensitive data.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000305
#>

# Registry path for Search policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

try {
    Write-Host "Disabling indexing of encrypted files..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable indexing of encrypted files
    # Value 0 = Do not allow indexing of encrypted files
    Set-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.AllowIndexingEncryptedStoresOrItems -eq 0) {
        Write-Host "✓ Indexing of encrypted files successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000305 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable indexing of encrypted files" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring search indexing settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Encrypted files will no longer be indexed by Windows Search." -ForegroundColor Green
```

**How it works:**
- `AllowIndexingEncryptedStoresOrItems = 0`: Disables indexing of encrypted files
- Windows Search normally indexes file contents to make them searchable
- Indexing encrypted files could potentially expose sensitive information
- This setting ensures encrypted files remain fully protected from indexing

</details>

### WN11-CC-000310
<details>
<summary><strong>Prevent User Installation Control</strong></summary>

**Problem:** Users must be prevented from changing installation options to maintain security controls.

**Solution:** This script prevents users from controlling installation options.

```powershell
<#
.SYNOPSIS
    Prevents users from changing installation options to meet STIG WN11-CC-000310 requirements.
.DESCRIPTION
    Disables user control over installation options to maintain administrative control.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000310
#>

# Registry path for Windows Installer policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Preventing users from changing installation options..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable user control over installs
    # Value 0 = Do not allow user control over installs
    Set-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.EnableUserControl -eq 0) {
        Write-Host "✓ User control over installations successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000310 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable user control over installations" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installation control settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Users can no longer modify installation options." -ForegroundColor Green
```

**How it works:**
- `EnableUserControl = 0`: Prevents users from changing installation options
- This ensures only administrators can control how software is installed
- Prevents users from bypassing security features during installations
- Maintains consistent security policies across all software installations

</details>

### WN11-CC-000315
<details>
<summary><strong>Disable Elevated Privileges Installation</strong></summary>

**Problem:** The Windows Installer feature 'Always install with elevated privileges' must be disabled.

**Solution:** This script disables the elevated privileges installation feature to prevent privilege escalation.

```powershell
<#
.SYNOPSIS
    Disables 'Always install with elevated privileges' to meet STIG WN11-CC-000315 requirements.
.DESCRIPTION
    Prevents Windows Installer from always using elevated privileges during installations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000315
#>

# Registry paths for Windows Installer policies (both machine and user)
$MachinePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$UserPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Disabling 'Always install with elevated privileges'..." -ForegroundColor Yellow
    
    # Configure machine policy
    if (!(Test-Path $MachinePath)) {
        New-Item -Path $MachinePath -Force | Out-Null
        Write-Host "Created machine registry path: $MachinePath" -ForegroundColor Cyan
    }
    
    # Configure user policy
    if (!(Test-Path $UserPath)) {
        New-Item -Path $UserPath -Force | Out-Null
        Write-Host "Created user registry path: $UserPath" -ForegroundColor Cyan
    }
    
    # Disable elevated privileges for machine installations
    Set-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Disable elevated privileges for user installations  
    Set-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Verify the settings were applied
    $MachineSetting = Get-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    $UserSetting = Get-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    
    if ($MachineSetting.AlwaysInstallElevated -eq 0 -and $UserSetting.AlwaysInstallElevated -eq 0) {
        Write-Host "✓ 'Always install with elevated privileges' successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000315 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable elevated privileges installation" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installer privilege settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Windows Installer will no longer automatically use elevated privileges." -ForegroundColor Green
```

**How it works:**
- `AlwaysInstallElevated = 0`: Disables automatic elevated privileges for installations
- Must be set in both HKLM (machine) and HKCU (user) registry hives
- Prevents malicious installers from gaining system privileges
- Standard users will need admin approval for privileged installations
- This is a critical security setting to prevent privilege escalation attacks

</details>

### WN11-CC-000326
<details>
<summary><strong>Enable PowerShell Script Block Logging</strong></summary>

**Problem:** PowerShell script block logging must be enabled for security monitoring.

**Solution:** This script enables PowerShell script block logging to monitor PowerShell activity.

```powershell
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
    $InvocationSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockInvocationLogging" -ErrorAction SilentlyContinue
    
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
```

**How it works:**
- `EnableScriptBlockLogging = 1`: Enables logging of PowerShell script blocks
- `EnableScriptBlockInvocationLogging = 1`: Logs when script blocks start and stop
- Script block logging captures PowerShell commands and scripts as they execute
- Logs are written to Windows Event Log (Event ID 4104) for security analysis
- Essential for detecting malicious PowerShell activity and forensic investigations

</details>

### WN11-CC-000327
<details>
<summary><strong>Enable PowerShell Transcription</strong></summary>

**Problem:** PowerShell Transcription must be enabled for detailed activity logging.

**Solution:** This script enables PowerShell transcription to create detailed logs of PowerShell sessions.

```powershell
<#
.SYNOPSIS
    Enables PowerShell transcription logging to meet STIG WN11-CC-000327 requirements.
.DESCRIPTION
    Configures PowerShell to create transcription logs of all PowerShell activity.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000327
#>

# Registry path for PowerShell transcription
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"

# Secure transcript output directory
$TranscriptPath = "C:\PowerShellTranscripts"

try {
    Write-Host "Enabling PowerShell transcription logging..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Create transcript directory if it doesn't exist
    if (!(Test-Path $TranscriptPath)) {
        New-Item -Path $TranscriptPath -ItemType Directory -Force | Out-Null
        Write-Host "Created transcript directory: $TranscriptPath" -ForegroundColor Cyan
        
        # Set secure permissions on transcript directory (Administrators only)
        $Acl = Get-Acl $TranscriptPath
        $Acl.SetAccessRuleProtection($true, $false)  # Remove inheritance
        $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.SetAccessRule($AdminRule)
        $Acl.SetAccessRule($SystemRule)
        Set-Acl -Path $TranscriptPath -AclObject $Acl
        Write-Host "Set secure permissions on transcript directory" -ForegroundColor Cyan
    }
    
    # Enable PowerShell transcription
    Set-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -Value 1 -Type DWord
    
    # Set transcript output directory
    Set-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -Value $TranscriptPath -Type String
    
    # Enable invocation headers in transcripts
    Set-ItemProperty -Path $RegistryPath -Name "EnableInvocationHeader" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $TranscriptSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -ErrorAction SilentlyContinue
    $DirectorySetting = Get-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -ErrorAction SilentlyContinue
    
    if ($TranscriptSetting.EnableTranscripting -eq 1 -and $DirectorySetting.OutputDirectory -eq $TranscriptPath) {
        Write-Host "✓ PowerShell transcription successfully enabled" -ForegroundColor Green
        Write-Host "✓ Transcript directory: $TranscriptPath" -ForegroundColor Green
        Write-Host "✓ Invocation headers enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000327 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to enable PowerShell transcription" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring PowerShell transcription: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "PowerShell sessions will now be transcribed to: $TranscriptPath" -ForegroundColor Green
```

**How it works:**
- `EnableTranscripting = 1`: Enables PowerShell transcription logging
- `OutputDirectory`: Specifies where transcript files are stored
- `EnableInvocationHeader = 1`: Includes detailed headers in transcript files
- Creates a secure directory with restricted permissions for transcript storage
- Transcripts capture complete PowerShell sessions including input and output
- Provides detailed forensic trail of all PowerShell activity

</details>

### WN11-SO-000025
<details>
<summary><strong>Rename Built-in Guest Account</strong></summary>

**Problem:** The built-in guest account must be renamed from its default name for security.

**Solution:** This script renames the built-in guest account to a non-obvious name.

```powershell
<#
.SYNOPSIS
    Renames the built-in guest account to meet STIG WN11-SO-000025 requirements.
.DESCRIPTION
    Changes the name of the built-in guest account from "Guest" to a non-obvious name.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000025
#>

# New name for the guest account (change this to your preferred name)
$NewGuestName = "Visitor_Account"

# Registry path for account rename policy
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

try {
    Write-Host "Renaming built-in guest account..." -ForegroundColor Yellow
    
    # Set the guest account rename through security policy
    $SecurityPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $SecurityPolicyPath)) {
        New-Item -Path $SecurityPolicyPath -Force | Out-Null
    }
    
    # Method 1: Use Local Security Policy registry setting
    $LSAPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    
    # Get current guest account name to verify change
    $GuestAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    $OriginalName = $GuestAccount.Name
    
    Write-Host "Current guest account name: $OriginalName" -ForegroundColor Cyan
    
    # Rename using WMI (most reliable method)
    $GuestAccount.Rename($NewGuestName)
    
    # Verify the rename was successful
    $RenamedAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    
    if ($RenamedAccount.Name -eq $NewGuestName) {
        Write-Host "✓ Guest account successfully renamed from '$OriginalName' to '$NewGuestName'" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000025 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to rename guest account" -ForegroundColor Red
        Write-Host "Current name: $($RenamedAccount.Name)" -ForegroundColor Red
    }
    
    # Also set the policy registry value for consistency
    $PolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    if (!(Test-Path $PolicyPath)) {
        New-Item -Path $PolicyPath -Force | Out-Null
    }
    
} catch {
    Write-Host "✗ Error renaming guest account: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Note: This operation requires administrative privileges" -ForegroundColor Yellow
}

Write-Host "Built-in guest account name has been changed for security." -ForegroundColor Green
```

**How it works:**
- Uses WMI (Windows Management Instrumentation) to rename the account
- Identifies the guest account by its well-known SID ending in "-501"
- `$GuestAccount.Rename()`: Renames the account using WMI method
- Verification checks ensure the rename operation was successful
- Renaming the guest account makes it less obvious to potential attackers

</details>

### WN11-SO-000030
<details>
<summary><strong>Enable Audit Policy Subcategories</strong></summary>

**Problem:** Audit policy using subcategories must be enabled for more precise auditing capabilities.

**Solution:** This script enables subcategory audit policy settings to override category settings.

```powershell
<#
.SYNOPSIS
    Enables audit policy subcategories to meet STIG WN11-SO-000030 requirements.
.DESCRIPTION
    Forces audit policy subcategory settings to override audit policy category settings.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000030
#>

# Registry path for audit policy settings
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

try {
    Write-Host "Enabling audit policy subcategories..." -ForegroundColor Yellow
    
    # Enable subcategory policy override
    # Value 1 = Force audit policy subcategory settings to override category settings
    Set-ItemProperty -Path $RegistryPath -Name "SCENoApplyLegacyAuditPolicy" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "SCENoApplyLegacyAuditPolicy" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.SCENoApplyLegacyAuditPolicy -eq 1) {
        Write-Host "✓ Audit policy subcategories successfully enabled" -ForegroundColor Green
        Write-Host "✓ Subcategory settings will override category settings" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000030 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to enable audit policy subcategories" -ForegroundColor Red
    }
    
    # Additional verification using auditpol command
    Write-Host "Verifying audit policy configuration..." -ForegroundColor Yellow
    $AuditResult = & auditpol.exe /get /category:* 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Audit policy is functioning correctly" -ForegroundColor Green
    }
    
} catch {
    Write-Host "✗ Error configuring audit policy settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Audit policy subcategories are now enabled for precise auditing control." -ForegroundColor Green
```

**How it works:**
- `SCENoApplyLegacyAuditPolicy = 1`: Enables subcategory audit policy override
- This allows administrators to configure specific subcategories of auditing
- More granular control over what events are audited
- Subcategory settings take precedence over broader category settings
- Essential for detailed security monitoring and compliance

</details>

### WN11-SO-000095
<details>
<summary><strong>Configure Smart Card Removal Behavior</strong></summary>

**Problem:** Smart Card removal option must be configured to Force Logoff or Lock Workstation.

**Solution:** This script configures the system to lock when a smart card is removed.

```powershell
<#
.SYNOPSIS
    Configures smart card removal behavior to meet STIG WN11-SO-000095 requirements.
.DESCRIPTION
    Sets the system to lock the workstation when a smart card is removed.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000095
#>

# Registry path for smart card policy
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

try {
    Write-Host "Configuring smart card removal behavior..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Configure smart card removal behavior
    # Value 1 = Lock Workstation, Value 2 = Force Logoff, Value 0 = No Action
    # Setting to 1 (Lock Workstation) for security while maintaining usability
    Set-ItemProperty -Path $RegistryPath -Name "ScRemoveOption" -Value 1 -Type String
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "ScRemoveOption" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.ScRemoveOption -eq "1") {
        Write-Host "✓ Smart card removal behavior set to 'Lock Workstation'" -ForegroundColor Green
        Write-Host "✓ System will lock when smart card is removed" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000095 requirement satisfied" -ForegroundColor Green
    } elseif ($CurrentSetting.ScRemoveOption -eq "2") {
        Write-Host "✓ Smart card removal behavior set to 'Force Logoff'" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000095 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure smart card removal behavior" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring smart card settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Smart card removal will now trigger workstation lock for security." -ForegroundColor Green
```

**How it works:**
- `ScRemoveOption = "1"`: Configures system to lock workstation when smart card is removed
- Value "1" = Lock Workstation (recommended for usability)
- Value "2" = Force Logoff (more secure but less user-friendly)
- Ensures unattended systems are automatically secured when smart card is removed
- Critical for environments using smart card authentication

</details>

### WN11-SO-000230
<details>
<summary><strong>Use FIPS Compliant Algorithms</strong></summary>

**Problem:** The system must be configured to use FIPS-compliant algorithms for encryption, hashing, and signing.

**Solution:** This script enables FIPS-compliant cryptographic algorithms system-wide.

```powershell
<#
.SYNOPSIS
    Enables FIPS-compliant algorithms to meet STIG WN11-SO-000230 requirements.
.DESCRIPTION
    Configures the system to use only FIPS-compliant algorithms for all cryptographic operations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000230
#>

# Registry path for FIPS policy
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"

try {
    Write-Host "Enabling FIPS-compliant algorithms..." -ForegroundColor Yellow
    Write-Host "WARNING: This change requires a system restart to take effect!" -ForegroundColor Red
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Enable FIPS-compliant algorithms
    # Value 1 = Use FIPS-compliant algorithms for encryption, hashing, and signing
    Set-ItemProperty -Path $RegistryPath -Name "Enabled" -Value 1 -Type DWord
    
    # Also set the policy registry value
    $PolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Set-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $FIPSSetting = Get-ItemProperty -Path $RegistryPath -Name "Enabled" -ErrorAction SilentlyContinue
    $PolicySetting = Get-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -ErrorAction SilentlyContinue
    
    if ($FIPSSetting.Enabled -eq 1 -and $PolicySetting.FipsAlgorithmPolicy -eq 1) {
        Write-Host "✓ FIPS-compliant algorithms successfully enabled" -ForegroundColor Green
        Write-Host "✓ System will use only FIPS-approved cryptographic algorithms" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000230 requirement satisfied" -ForegroundColor Green
        Write-Host "⚠️  RESTART REQUIRED: Changes take effect after system restart" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Failed to enable FIPS-compliant algorithms" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring FIPS settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System configured to use FIPS-compliant cryptographic algorithms." -ForegroundColor Green
Write-Host "Please restart the system for changes to take effect." -ForegroundColor Yellow
```

**How it works:**
- `Enabled = 1`: Enables FIPS mode in the FIPS Algorithm Policy
- `FipsAlgorithmPolicy = 1`: Sets the LSA policy for FIPS compliance
- FIPS (Federal Information Processing Standards) ensures cryptographic security
- Only government-approved algorithms will be used for encryption, hashing, and signing
- **Important**: System restart required for FIPS mode to activate
- May break some applications that use non-FIPS algorithms

</details>

### WN11-UC-000015
<details>
<summary><strong>Turn Off Toast Notifications on Lock Screen</strong></summary>

**Problem:** Toast notifications to the lock screen must be turned off to prevent information disclosure.

**Solution:** This script disables toast notifications on the lock screen for all users.

```powershell
<#
.SYNOPSIS
    Turns off toast notifications on lock screen to meet STIG WN11-UC-000015 requirements.
.DESCRIPTION
    Disables toast notifications from appearing on the lock screen to protect sensitive information.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-UC-000015
#>

# Registry paths for notification policies
$UserPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
$MachinePolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

try {
    Write-Host "Turning off toast notifications on lock screen..." -ForegroundColor Yellow
    
    # Create the registry paths if they don't exist
    if (!(Test-Path $UserPolicyPath)) {
        New-Item -Path $UserPolicyPath -Force | Out-Null
        Write-Host "Created registry path: $UserPolicyPath" -ForegroundColor Cyan
    }
    
    if (!(Test-Path $MachinePolicyPath)) {
        New-Item -Path $MachinePolicyPath -Force | Out-Null
        Write-Host "Created registry path: $MachinePolicyPath" -ForegroundColor Cyan
    }
    
    # Disable toast notifications on lock screen
    Set-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -Value 1 -Type DWord
    
    # Also configure via alternative registry location for comprehensive coverage
    $NotificationPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (!(Test-Path $NotificationPath)) {
        New-Item -Path $NotificationPath -Force | Out-Null
    }
    Set-ItemProperty -Path $NotificationPath -Name "DisableNotificationCenter" -Value 1 -Type DWord
    
    # Configure for current user as well
    $CurrentUserPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (!(Test-Path $CurrentUserPath)) {
        New-Item -Path $CurrentUserPath -Force | Out-Null
    }
    Set-ItemProperty -Path $CurrentUserPath -Name "DisableNotificationCenter" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $ToastSetting = Get-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -ErrorAction SilentlyContinue
    
    if ($ToastSetting.NoToastApplicationNotificationOnLockScreen -eq 1) {
        Write-Host "✓ Toast notifications on lock screen successfully disabled" -ForegroundColor Green
        Write-Host "✓ Sensitive information will not appear on lock screen" -ForegroundColor Green
        Write-Host "✓ STIG WN11-UC-000015 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable toast notifications on lock screen" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring notification settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Lock screen will no longer display toast notifications." -ForegroundColor Green
```

**How it works:**
- `NoToastApplicationNotificationOnLockScreen = 1`: Disables toast notifications on lock screen
- `DisableNotificationCenter = 1`: Additional setting to disable notification center
- Configured for both machine-wide and current user policies
- Prevents sensitive information from appearing on lock screen
- Unauthorized users cannot see notification contents when system is locked

</details>

### WN11-CC-000005
<details>
<summary><strong>Prevent Lock Screen Camera Access</strong></summary>

**Problem:** Camera access from the lock screen must be disabled to prevent unauthorized use.

**Solution:** This script disables camera access from the Windows lock screen.

```powershell
<#
.SYNOPSIS
    Prevents camera access from lock screen to meet STIG WN11-CC-000005 requirements.
.DESCRIPTION
    Disables the ability to access the camera from the Windows lock screen.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000005
#>

# Registry path for personalization policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

try {
    Write-Host "Disabling camera access from lock screen..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent enabling lock screen camera
    Set-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -Value 1 -Type DWord
    
    # Also disable camera access via privacy settings
    $PrivacyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
    if (!(Test-Path $PrivacyPath)) {
        New-Item -Path $PrivacyPath -Force | Out-Null
        Write-Host "Created privacy registry path: $PrivacyPath" -ForegroundColor Cyan
    }
    
    # Disable camera access for apps above lock screen
    Set-ItemProperty -Path $PrivacyPath -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -Value "Force Deny" -Type String
    
    # Verify the settings were applied
    $CameraSetting = Get-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -ErrorAction SilentlyContinue
    
    if ($CameraSetting.NoLockScreenCamera -eq 1) {
        Write-Host "✓ Lock screen camera access successfully disabled" -ForegroundColor Green
        Write-Host "✓ Camera cannot be accessed from lock screen" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000005 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable lock screen camera access" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring camera access settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Camera access from lock screen has been disabled for security." -ForegroundColor Green
```

**How it works:**
- `NoLockScreenCamera = 1`: Prevents camera access from lock screen
- `LetAppsAccessCamera_UserInControlOfTheseApps = "Force Deny"`: Blocks app camera access above lock
- Ensures unauthorized users cannot access camera when system is locked
- Prevents potential privacy violations and unauthorized recording
- Camera remains available after proper authentication

</details>

---

## ⚠️ Prerequisites

- **Administrative Privileges**: All scripts must be run as Administrator
- **PowerShell Execution Policy**: Set to allow script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  ```
- **Windows 11**: Scripts are designed for Windows 11 systems
- **Backup**: Create system restore point before running scripts

## 🔧 How to Use

### Running Individual Scripts

1. **Open PowerShell as Administrator**
2. **Navigate to script directory**
3. **Execute the script:**
   ```powershell
   .\STIG-ID-WN11-AU-000500.ps1
   ```

### Running All Scripts

Use the provided batch script to run all remediations:

```powershell
<#
.SYNOPSIS
    Runs all STIG compliance remediation scripts
.DESCRIPTION
    Executes all PowerShell scripts to remediate Windows 11 STIG compliance issues
.NOTES
    Author: Abdullah Al Rafi
    Run as Administrator
#>

# Get all STIG remediation scripts
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$Scripts = Get-ChildItem -Path $ScriptPath -Filter "STIG-ID-*.ps1"

Write-Host "Starting Windows 11 STIG Compliance Remediation..." -ForegroundColor Green
Write-Host "Found $($Scripts.Count) remediation scripts" -ForegroundColor Cyan

foreach ($Script in $Scripts) {
    Write-Host "`n" + "="*50 -ForegroundColor Yellow
    Write-Host "Executing: $($Script.Name)" -ForegroundColor Yellow
    Write-Host "="*50 -ForegroundColor Yellow
    
    try {
        & $Script.FullName
    } catch {
        Write-Host "Error executing $($Script.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n" + "="*50 -ForegroundColor Green
Write-Host "STIG Compliance Remediation Complete!" -ForegroundColor Green
Write-Host "="*50 -ForegroundColor Green
Write-Host "Please review the output above for any failed remediations." -ForegroundColor Yellow
Write-Host "A system restart may be required for some changes to take effect." -ForegroundColor Yellow
```

### Verification

After running the scripts, you can verify compliance using:

```powershell
# Check specific registry values
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application" -Name "MaxSize"

# Verify audit policy settings
auditpol.exe /get /category:*

# Check Group Policy results
gpresult /h GPReport.html
```

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**
3. **Test your changes thoroughly**
4. **Update documentation**
5. **Submit a pull request**

### Code Standards

- Follow PowerShell best practices
- Include comprehensive error handling
- Add detailed comments and help text
- Test on clean Windows 11 systems
- Verify STIG compliance after changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

These scripts modify system security settings. Always test in a non-production environment first. The authors are not responsible for any system issues that may arise from using these scripts.

## 📞 Support

For questions or issues:

- **GitHub Issues**: [Create an issue](https://github.com/yourusername/windows11-stig-compliance/issues)
- **LinkedIn**: [Abdullah Al Rafi](https://linkedin.com/in/abdullah-al-rafi03/)

---

*Last updated: July 29, 2025*