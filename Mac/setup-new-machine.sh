#!/bin/bash
# Setup script for new machines from ConfigHub
# Place this in ~/Documents/ConfigHub/Configs/setup-new-machine.sh

echo "=== Setting up development environment from ConfigHub ==="

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install from Brewfile
if [[ -f "mac/brew-bundle" ]]; then
    echo -e "${BLUE}Installing Homebrew packages from brew-bundle...${NC}"
    brew bundle --file="mac/brew-bundle"
elif [[ -f "mac/Brewfile" ]]; then
    echo -e "${BLUE}Installing Homebrew packages from Brewfile...${NC}"
    brew bundle --file="mac/Brewfile"
else
    echo -e "${YELLOW}No Brewfile found, skipping Homebrew packages${NC}"
fi

# Install VS Code extensions
if [[ -f "vscode/extensions.txt" ]] && command -v code &> /dev/null; then
    echo -e "${BLUE}Installing VS Code extensions...${NC}"
    while IFS= read -r extension; do
        echo "Installing: $extension"
        code --install-extension "$extension"
    done < "vscode/extensions.txt"
fi

# Setup Python environment
if command -v conda &> /dev/null || command -v mamba &> /dev/null; then
    if [[ -f "micromamba/base-environment.yml" ]]; then
        echo -e "${BLUE}Setting up Python environment...${NC}"
        mamba env update -f micromamba/base-environment.yml || conda env update -f micromamba/base-environment.yml
    fi
fi

# Create directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p ~/.config
mkdir -p ~/.aws
mkdir -p ~/.docker

# Function to safely link files
safe_link() {
    local source="$1"
    local target="$2"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file if it exists and isn't a symlink
    if [[ -f "$target" ]] && [[ ! -L "$target" ]]; then
        mv "$target" "${target}.backup-$(date +%Y%m%d)"
        echo -e "${YELLOW}Backed up existing file: ${target}${NC}"
    fi
    
    # Remove existing symlink
    rm -f "$target"
    
    # Create new symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓ Linked: $(basename "$source")${NC}"
}

# Function to safely copy files
safe_copy() {
    local source="$1"
    local target="$2"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file if different
    if [[ -f "$target" ]]; then
        if ! diff -q "$source" "$target" > /dev/null 2>&1; then
            mv "$target" "${target}.backup-$(date +%Y%m%d)"
            echo -e "${YELLOW}Backed up existing file: ${target}${NC}"
        fi
    fi
    
    # Copy file
    cp "$source" "$target"
    echo -e "${GREEN}✓ Copied: $(basename "$source")${NC}"
}

# Link or copy configuration files
echo -e "${BLUE}Setting up configuration files...${NC}"

CONFIGHUB_DIR="$(pwd)"

# Git (link)
[[ -f "$CONFIGHUB_DIR/git/.gitconfig" ]] && safe_link "$CONFIGHUB_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Shell (link)
[[ -f "$CONFIGHUB_DIR/zsh/.zshrc" ]] && safe_link "$CONFIGHUB_DIR/zsh/.zshrc" "$HOME/.zshrc"
[[ -f "$CONFIGHUB_DIR/zsh/.zprofile" ]] && safe_link "$CONFIGHUB_DIR/zsh/.zprofile" "$HOME/.zprofile"

# Conda (link)
[[ -f "$CONFIGHUB_DIR/micromamba/.condarc" ]] && safe_link "$CONFIGHUB_DIR/micromamba/.condarc" "$HOME/.condarc"

# Jupyter (copy)
if [[ -f "$CONFIGHUB_DIR/micromamba/jupyter_lab_config.py" ]]; then
    safe_copy "$CONFIGHUB_DIR/micromamba/jupyter_lab_config.py" "$HOME/.jupyter/jupyter_lab_config.py"
fi
if [[ -f "$CONFIGHUB_DIR/micromamba/jupyter_notebook_config.py" ]]; then
    safe_copy "$CONFIGHUB_DIR/micromamba/jupyter_notebook_config.py" "$HOME/.jupyter/jupyter_notebook_config.py"
fi

# VS Code (copy - VS Code doesn't like symlinks)
if [[ -f "$CONFIGHUB_DIR/vscode/code-user-settings.json" ]]; then
    safe_copy "$CONFIGHUB_DIR/vscode/code-user-settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi
if [[ -f "$CONFIGHUB_DIR/vscode/spell-dictionary.txt" ]]; then
    safe_copy "$CONFIGHUB_DIR/vscode/spell-dictionary.txt" "$HOME/.vscode/spell-dictionary.txt"
fi

# AWS config (copy, NOT credentials)
if [[ -f "$CONFIGHUB_DIR/AWS/config" ]]; then
    safe_copy "$CONFIGHUB_DIR/AWS/config" "$HOME/.aws/config"
fi

# Docker config
if [[ -f "$CONFIGHUB_DIR/Docker/config.json" ]]; then
    safe_copy "$CONFIGHUB_DIR/Docker/config.json" "$HOME/.docker/config.json"
fi

echo -e "\n${GREEN}=== Setup Complete! ===${NC}"
echo -e "\n${YELLOW}Manual steps required:${NC}"
echo "1. Install Xcode command line tools: xcode-select --install"
echo "2. Sign into App Store for Mac App Store apps"
echo "3. Configure application licenses (Alfred, etc.)"
echo "4. Set up SSH keys"
echo "5. Configure AWS credentials (never store in ConfigHub!)"
echo "6. Restart your terminal to apply shell configurations"

echo -e "\n${BLUE}To keep configs in sync, run: ~/configHub-sync.sh${NC}"