# easy-windows-setup
Setup Windows in a whiff (maybe)

## WSL Installation

Install Windows Subsystem for Linux (WSL) with Ubuntu 24.04 as the default distribution.

### Requirements
- Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11
- Administrator privileges
- Internet connection for downloading Ubuntu 24.04

### Usage

1. Open PowerShell as Administrator
2. Navigate to the repository directory
3. Run the WSL installation script:

```powershell
.\scripts\wsl-install.ps1
```

#### Options

```powershell
# Show help
.\scripts\wsl-install.ps1 -Help

# Skip confirmation prompts
.\scripts\wsl-install.ps1 -Force
```

### What the script does

- Checks Windows version compatibility
- Verifies administrator privileges
- Installs WSL with Ubuntu 24.04 distribution
- Sets Ubuntu 24.04 as the default WSL distribution
- Provides guidance for post-installation setup

After installation, you may need to restart your computer and complete the Ubuntu setup by creating a user account.
