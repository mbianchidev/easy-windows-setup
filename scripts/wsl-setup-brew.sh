#!/bin/bash

# WSL Homebrew Setup Script
# Installs Homebrew and fundamental development tools on WSL
# Should be run inside WSL environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
WSL Homebrew Setup Script

This script installs Homebrew and fundamental development tools on WSL.

Usage:
    ./wsl-setup-brew.sh [OPTIONS]

Options:
    -f, --force     Skip confirmation prompts
    -h, --help      Show this help message

Tools installed:
    - Homebrew package manager
    - Essential build tools (build-essential, curl, git)
    - Development tools (vim, htop, tree, jq, wget)
    - Programming language tools via Homebrew
    - Common libraries and dependencies

Requirements:
    - WSL environment (Ubuntu/Debian based)
    - Internet connection
    - sudo privileges

EOF
}

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if running in WSL
check_wsl() {
    if [[ ! -f /proc/version ]]; then
        print_error "This script should be run in a WSL environment."
        exit 1
    fi
    
    if ! grep -qi "microsoft\|wsl" /proc/version; then
        print_error "This script should be run in a WSL environment."
        exit 1
    fi
    
    print_status "Running in WSL environment."
}

# Check if user has sudo privileges
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        print_error "This script requires sudo privileges. Please ensure you can run sudo commands."
        exit 1
    fi
    print_status "Sudo privileges confirmed."
}

# Update system packages
update_system() {
    print_step "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    print_status "System packages updated."
}

# Install essential build tools
install_essentials() {
    print_step "Installing essential build tools..."
    sudo apt install -y \
        build-essential \
        curl \
        file \
        git \
        procps \
        wget \
        vim \
        htop \
        tree \
        jq \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release
    print_status "Essential tools installed."
}

# Install Homebrew
install_homebrew() {
    print_step "Installing Homebrew..."
    
    if command -v brew &> /dev/null; then
        print_status "Homebrew is already installed."
        return 0
    fi
    
    # Download and install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Verify installation
    if command -v brew &> /dev/null; then
        print_status "Homebrew installed successfully."
    else
        print_error "Failed to install Homebrew."
        exit 1
    fi
}

# Install development tools via Homebrew
install_brew_tools() {
    print_step "Installing development tools via Homebrew..."
    
    # Essential development tools
    local tools=(
        "gcc"
        "make"
        "cmake"
        "pkg-config"
        "node"
        "python@3.12"
        "go"
        "rust"
        "gh"
        "zsh"
        "tmux"
        "neovim"
        "ripgrep"
        "fd"
        "bat"
        "exa"
        "fzf"
    )
    
    for tool in "${tools[@]}"; do
        print_step "Installing $tool..."
        if brew install "$tool"; then
            print_status "$tool installed successfully."
        else
            print_warning "Failed to install $tool, continuing..."
        fi
    done
}

# Configure Git (basic setup)
configure_git() {
    print_step "Configuring Git..."
    
    if ! git config --global user.name &> /dev/null; then
        print_warning "Git user.name not configured. You can set it later with: git config --global user.name 'Your Name'"
    fi
    
    if ! git config --global user.email &> /dev/null; then
        print_warning "Git user.email not configured. You can set it later with: git config --global user.email 'your.email@example.com'"
    fi
    
    # Set some useful Git defaults
    git config --global init.defaultBranch main
    git config --global core.autocrlf input
    git config --global pull.rebase false
    
    print_status "Git configured with sensible defaults."
}

# Install additional useful packages
install_additional_tools() {
    print_step "Installing additional useful tools..."
    
    # Install Python tools
    if command -v pip3 &> /dev/null; then
        pip3 install --user pipenv poetry virtualenv
        print_status "Python tools installed."
    fi
    
    # Install Node.js tools (if Node.js is available)
    if command -v npm &> /dev/null; then
        npm install -g yarn pnpm @vue/cli create-react-app
        print_status "Node.js tools installed."
    fi
    
    # Install Rust tools (if Rust is available)
    if command -v cargo &> /dev/null; then
        cargo install cargo-edit cargo-watch
        print_status "Rust tools installed."
    fi
}

# Main installation function
main() {
    echo -e "${GREEN}WSL Homebrew Setup Script${NC}"
    echo "================================"
    
    # Pre-flight checks
    check_wsl
    check_sudo
    
    if [[ "$FORCE" != "true" ]]; then
        echo
        read -p "This will install Homebrew and development tools on WSL. Continue? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_warning "Installation cancelled by user."
            exit 0
        fi
    fi
    
    echo
    print_status "Starting WSL development environment setup..."
    
    # Run installation steps
    update_system
    install_essentials
    install_homebrew
    install_brew_tools
    configure_git
    install_additional_tools
    
    echo
    print_status "WSL development environment setup completed!"
    
    echo
    print_step "Installed tools summary:"
    echo "✓ Homebrew package manager"
    echo "✓ Essential build tools"
    echo "✓ Git version control"
    echo "✓ Node.js and npm"
    echo "✓ Python 3.12"
    echo "✓ Go programming language"
    echo "✓ Rust programming language"
    echo "✓ GitHub CLI (gh)"
    echo "✓ Modern shell tools (zsh, tmux, neovim)"
    echo "✓ Modern CLI utilities (ripgrep, fd, bat, exa, fzf)"
    
    echo
    print_warning "Important notes:"
    echo "1. Restart your terminal or run 'source ~/.bashrc' to use Homebrew"
    echo "2. Configure Git with your name and email:"
    echo "   git config --global user.name 'Your Name'"
    echo "   git config --global user.email 'your.email@example.com'"
    echo "3. Consider switching to zsh for better shell experience: chsh -s \$(which zsh)"
    
    echo
    print_status "Setup complete! Happy coding! 🚀"
}

# Run main function
main "$@"