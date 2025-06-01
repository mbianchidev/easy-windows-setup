# WSL Installation Script
# Installs Windows Subsystem for Linux with Ubuntu 24.04 as default distribution
# Requires Administrator privileges

param(
    [switch]$Force,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
WSL Installation Script

This script installs Windows Subsystem for Linux (WSL) with Ubuntu 24.04 as the default distribution.

Usage:
    .\wsl-install.ps1 [-Force] [-Help]

Parameters:
    -Force    : Skip confirmation prompts
    -Help     : Show this help message

Requirements:
    - Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11
    - Administrator privileges
    - Internet connection for downloading Ubuntu 24.04

"@
    exit 0
}

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges. Please run PowerShell as Administrator."
    exit 1
}

# Check Windows version
$osVersion = [System.Environment]::OSVersion.Version
$buildNumber = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild

Write-Host "Checking Windows version..." -ForegroundColor Yellow
Write-Host "OS Version: $($osVersion.Major).$($osVersion.Minor), Build: $buildNumber" -ForegroundColor Cyan

if ($buildNumber -lt 19041) {
    Write-Error "WSL 2 requires Windows 10 version 2004 (Build 19041) or higher. Your current build is $buildNumber."
    exit 1
}

Write-Host "Windows version is compatible with WSL 2." -ForegroundColor Green

# Function to check if WSL is already installed
function Test-WSLInstalled {
    try {
        $wslInfo = wsl --status 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

# Function to check if a WSL distribution is installed
function Test-WSLDistributionInstalled {
    param([string]$DistributionName)
    
    try {
        $distributions = wsl --list --quiet 2>$null
        return $distributions -contains $DistributionName
    }
    catch {
        return $false
    }
}

Write-Host "`nStarting WSL installation process..." -ForegroundColor Yellow

# Check if WSL is already installed
if (Test-WSLInstalled) {
    Write-Host "WSL is already installed." -ForegroundColor Green
    
    # Check if Ubuntu 24.04 is already installed
    if (Test-WSLDistributionInstalled "Ubuntu-24.04") {
        Write-Host "Ubuntu 24.04 is already installed." -ForegroundColor Green
        
        if (-not $Force) {
            $choice = Read-Host "Do you want to set Ubuntu 24.04 as the default distribution? (y/N)"
            if ($choice -ne 'y' -and $choice -ne 'Y') {
                Write-Host "Installation cancelled by user." -ForegroundColor Yellow
                exit 0
            }
        }
        
        Write-Host "Setting Ubuntu 24.04 as default distribution..." -ForegroundColor Yellow
        wsl --set-default Ubuntu-24.04
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Ubuntu 24.04 is now the default WSL distribution." -ForegroundColor Green
        } else {
            Write-Error "Failed to set Ubuntu 24.04 as default distribution."
            exit 1
        }
        
        Write-Host "`nWSL setup completed successfully!" -ForegroundColor Green
        exit 0
    }
} else {
    if (-not $Force) {
        $choice = Read-Host "This will install WSL and Ubuntu 24.04. Continue? (Y/n)"
        if ($choice -eq 'n' -or $choice -eq 'N') {
            Write-Host "Installation cancelled by user." -ForegroundColor Yellow
            exit 0
        }
    }
}

Write-Host "`nInstalling WSL..." -ForegroundColor Yellow

# Install WSL with Ubuntu 24.04
try {
    # Use the modern wsl --install command which handles everything
    wsl --install --distribution Ubuntu-24.04
    
    if ($LASTEXITCODE -ne 0) {
        throw "WSL installation failed with exit code $LASTEXITCODE"
    }
    
    Write-Host "`nWSL and Ubuntu 24.04 installation completed successfully!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Restart your computer to complete the installation" -ForegroundColor Cyan
    Write-Host "2. After restart, Ubuntu 24.04 will launch automatically to complete setup" -ForegroundColor Cyan
    Write-Host "3. Create a user account when prompted" -ForegroundColor Cyan
    Write-Host "`nTo manually launch Ubuntu 24.04 later, run: wsl" -ForegroundColor Cyan
    
    $restartChoice = Read-Host "`nWould you like to restart now? (y/N)"
    if ($restartChoice -eq 'y' -or $restartChoice -eq 'Y') {
        Write-Host "Restarting computer in 5 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        Restart-Computer -Force
    }
    
} catch {
    Write-Error "Failed to install WSL: $($_.Exception.Message)"
    Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
    Write-Host "1. Ensure you're running PowerShell as Administrator" -ForegroundColor Cyan
    Write-Host "2. Check your internet connection" -ForegroundColor Cyan
    Write-Host "3. Verify Windows version compatibility" -ForegroundColor Cyan
    Write-Host "4. Try running: Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux" -ForegroundColor Cyan
    exit 1
}