# CLI Tools Installation Script
# Installs fundamental CLI tools for major software languages plus git
# Requires Administrator privileges

param(
    [switch]$Force,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
CLI Tools Installation Script

This script installs fundamental CLI tools for major software languages and development.

Usage:
    .\install-cli-tools.ps1 [-Force] [-Help]

Parameters:
    -Force    : Skip confirmation prompts
    -Help     : Show this help message

Tools installed:
    - Git for Windows
    - Node.js and npm
    - Python and pip
    - Go
    - Rust and Cargo
    - Java (OpenJDK)
    - .NET SDK

Requirements:
    - Windows 10 version 1903 or higher
    - Administrator privileges
    - Internet connection

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

if ($buildNumber -lt 18362) {
    Write-Error "This script requires Windows 10 version 1903 (Build 18362) or higher. Your current build is $buildNumber."
    exit 1
}

Write-Host "Windows version is compatible." -ForegroundColor Green

# Function to check if a command exists
function Test-CommandExists {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction SilentlyContinue) {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to install using winget if available, otherwise provide download instructions
function Install-WithWinget {
    param(
        [string]$PackageId,
        [string]$DisplayName,
        [string]$FallbackUrl = ""
    )
    
    Write-Host "`nInstalling $DisplayName..." -ForegroundColor Yellow
    
    if (Test-CommandExists "winget") {
        try {
            winget install --id $PackageId --silent --accept-package-agreements --accept-source-agreements
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$DisplayName installed successfully via winget." -ForegroundColor Green
                return $true
            }
        }
        catch {
            Write-Warning "Failed to install $DisplayName via winget."
        }
    }
    
    if ($FallbackUrl -ne "") {
        Write-Host "Please download and install $DisplayName manually from: $FallbackUrl" -ForegroundColor Cyan
    }
    return $false
}

Write-Host "`nStarting CLI tools installation...`n" -ForegroundColor Yellow

if (-not $Force) {
    $choice = Read-Host "This will install fundamental CLI tools for development. Continue? (Y/n)"
    if ($choice -eq 'n' -or $choice -eq 'N') {
        Write-Host "Installation cancelled by user." -ForegroundColor Yellow
        exit 0
    }
}

try {
    # Check if winget is available
    if (-not (Test-CommandExists "winget")) {
        Write-Warning "Windows Package Manager (winget) is not available. Please install it from the Microsoft Store or download from GitHub."
        Write-Host "Continuing with manual installation instructions..." -ForegroundColor Cyan
    }

    # Install Git
    if (-not (Test-CommandExists "git")) {
        Install-WithWinget -PackageId "Git.Git" -DisplayName "Git for Windows" -FallbackUrl "https://git-scm.com/download/win"
    } else {
        Write-Host "Git is already installed." -ForegroundColor Green
    }

    # Install Node.js
    if (-not (Test-CommandExists "node")) {
        Install-WithWinget -PackageId "OpenJS.NodeJS" -DisplayName "Node.js" -FallbackUrl "https://nodejs.org/en/download/"
    } else {
        Write-Host "Node.js is already installed." -ForegroundColor Green
    }

    # Install Python
    if (-not (Test-CommandExists "python")) {
        Install-WithWinget -PackageId "Python.Python.3.12" -DisplayName "Python 3.12" -FallbackUrl "https://www.python.org/downloads/"
    } else {
        Write-Host "Python is already installed." -ForegroundColor Green
    }

    # Install Go
    if (-not (Test-CommandExists "go")) {
        Install-WithWinget -PackageId "GoLang.Go" -DisplayName "Go Programming Language" -FallbackUrl "https://golang.org/dl/"
    } else {
        Write-Host "Go is already installed." -ForegroundColor Green
    }

    # Install Rust
    if (-not (Test-CommandExists "rustc")) {
        Install-WithWinget -PackageId "Rustlang.Rustup" -DisplayName "Rust (rustup)" -FallbackUrl "https://rustup.rs/"
    } else {
        Write-Host "Rust is already installed." -ForegroundColor Green
    }

    # Install Java
    if (-not (Test-CommandExists "java")) {
        Install-WithWinget -PackageId "Eclipse.Temurin.17.JDK" -DisplayName "Eclipse Temurin JDK 17" -FallbackUrl "https://adoptium.net/"
    } else {
        Write-Host "Java is already installed." -ForegroundColor Green
    }

    # Install .NET SDK
    if (-not (Test-CommandExists "dotnet")) {
        Install-WithWinget -PackageId "Microsoft.DotNet.SDK.8" -DisplayName ".NET 8 SDK" -FallbackUrl "https://dotnet.microsoft.com/download"
    } else {
        Write-Host ".NET SDK is already installed." -ForegroundColor Green
    }

    Write-Host "`nCLI tools installation completed!`n" -ForegroundColor Green
    
    Write-Host "Installed tools:" -ForegroundColor Yellow
    $tools = @(
        @{Name="Git"; Command="git --version"},
        @{Name="Node.js"; Command="node --version"},
        @{Name="npm"; Command="npm --version"},
        @{Name="Python"; Command="python --version"},
        @{Name="pip"; Command="pip --version"},
        @{Name="Go"; Command="go version"},
        @{Name="Rust"; Command="rustc --version"},
        @{Name="Cargo"; Command="cargo --version"},
        @{Name="Java"; Command="java --version"},
        @{Name=".NET"; Command="dotnet --version"}
    )
    
    foreach ($tool in $tools) {
        try {
            $version = Invoke-Expression $tool.Command 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ $($tool.Name): Available" -ForegroundColor Green
            } else {
                Write-Host "✗ $($tool.Name): Not available" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "✗ $($tool.Name): Not available" -ForegroundColor Red
        }
    }
    
    Write-Host "`nNote: You may need to restart your terminal or add tools to your PATH manually." -ForegroundColor Cyan
    Write-Host "Some installations may require a system restart to take full effect." -ForegroundColor Cyan

} catch {
    Write-Error "Failed to install CLI tools: $($_.Exception.Message)"
    Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
    Write-Host "1. Ensure you're running PowerShell as Administrator" -ForegroundColor Cyan
    Write-Host "2. Check your internet connection" -ForegroundColor Cyan
    Write-Host "3. Install Windows Package Manager (winget) from Microsoft Store" -ForegroundColor Cyan
    Write-Host "4. Manually download and install tools from their official websites" -ForegroundColor Cyan
    exit 1
}