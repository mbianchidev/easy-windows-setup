# easy-windows-setup
Setup Windows in a whiff (maybe)

## Available Scripts

### 1. WSL Installation
### 2. CLI Tools Installation  
### 3. WSL Development Environment Setup

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

## CLI Tools Installation

Install fundamental CLI tools for major software languages and development on Windows.

### Requirements
- Windows 10 version 1903 or higher (Build 18362 and higher) or Windows 11
- Administrator privileges
- Internet connection

### Usage

1. Open PowerShell as Administrator
2. Navigate to the repository directory
3. Run the CLI tools installation script:

```powershell
.\scripts\install-cli-tools.ps1
```

#### Options

```powershell
# Show help
.\scripts\install-cli-tools.ps1 -Help

# Skip confirmation prompts
.\scripts\install-cli-tools.ps1 -Force
```

### What the script installs

- Git for Windows
- Node.js and npm
- Python 3.12 and pip
- Go programming language
- Rust and Cargo
- Java (Eclipse Temurin JDK 17)
- .NET 8 SDK

The script uses Windows Package Manager (winget) when available, or provides manual download instructions.

## WSL Development Environment Setup

Set up a complete development environment with Homebrew and essential tools inside WSL.

### Requirements
- WSL with Ubuntu or Debian-based distribution
- Internet connection
- sudo privileges

### Usage

1. Open your WSL terminal
2. Navigate to the repository directory
3. Run the setup script:

```bash
./scripts/wsl-setup-brew.sh
```

#### Options

```bash
# Show help
./scripts/wsl-setup-brew.sh --help

# Skip confirmation prompts
./scripts/wsl-setup-brew.sh --force
```

### What the script installs

- Homebrew package manager
- Essential build tools (build-essential, curl, git)
- Development tools (vim, htop, tree, jq, wget)
- Programming languages (Node.js, Python 3.12, Go, Rust)
- GitHub CLI (gh)
- Modern shell tools (zsh, tmux, neovim)
- Modern CLI utilities (ripgrep, fd, bat, exa, fzf)
- Python tools (pipenv, poetry, virtualenv)
- Node.js tools (yarn, pnpm, Vue CLI, Create React App)
- Rust tools (cargo-edit, cargo-watch)
