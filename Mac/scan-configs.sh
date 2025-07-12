#!/bin/bash

# Configuration Scanner Script
# Finds potential configuration files and folders to sync

echo "=== Configuration Scanner ==="
echo "Scanning for configuration files in your home directory..."
echo "This will help identify what you might want to add to ConfigHub"
echo

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Function to check if file/directory exists and show its info
check_config() {
    local path="$1"
    local description="$2"
    local category="$3"
    
    if [[ -e "$path" ]]; then
        local size=$(du -sh "$path" 2>/dev/null | cut -f1)
        local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d" "$path" 2>/dev/null)
        echo -e "${GREEN}✓${NC} ${category} | ${BLUE}${path}${NC}"
        echo -e "  ${description}"
        echo -e "  Size: ${size}, Last modified: ${mod_time}"
        echo
    fi
}

# Function to find files by pattern
find_by_pattern() {
    local pattern="$1"
    local description="$2"
    local max_depth="${3:-3}"
    
    local found=$(find "$HOME" -maxdepth $max_depth -name "$pattern" -type f 2>/dev/null | grep -v -E "(Library/Caches|Library/Logs|.Trash|node_modules|.git/|env/|venv/|.cache/)" | head -5)
    
    if [[ -n "$found" ]]; then
        echo -e "${YELLOW}Pattern: ${pattern}${NC} - ${description}"
        echo "$found" | while read -r file; do
            echo -e "  ${BLUE}${file}${NC}"
        done
        echo
    fi
}

echo -e "${CYAN}=== Shell Configurations ===${NC}"
check_config "$HOME/.zshrc" "Zsh configuration" "Shell"
check_config "$HOME/.zprofile" "Zsh profile" "Shell"
check_config "$HOME/.bashrc" "Bash configuration" "Shell"
check_config "$HOME/.bash_profile" "Bash profile" "Shell"
check_config "$HOME/.profile" "Shell profile" "Shell"
check_config "$HOME/.aliases" "Shell aliases" "Shell"
check_config "$HOME/.functions" "Shell functions" "Shell"
check_config "$HOME/.oh-my-zsh/custom" "Oh My Zsh customizations" "Shell"
check_config "$HOME/.config/fish" "Fish shell configuration" "Shell"

echo -e "${CYAN}=== Development Tools ===${NC}"
check_config "$HOME/.gitconfig" "Git global configuration" "Git"
check_config "$HOME/.gitignore_global" "Global git ignores" "Git"
check_config "$HOME/.gitmessage" "Git commit template" "Git"
check_config "$HOME/.vimrc" "Vim configuration" "Editor"
check_config "$HOME/.vim" "Vim directory" "Editor"
check_config "$HOME/.config/nvim" "Neovim configuration" "Editor"
check_config "$HOME/.emacs.d" "Emacs configuration" "Editor"
check_config "$HOME/.spacemacs" "Spacemacs configuration" "Editor"
check_config "$HOME/.nanorc" "Nano configuration" "Editor"

echo -e "${CYAN}=== Programming Languages ===${NC}"
check_config "$HOME/.npmrc" "NPM configuration" "Node.js"
check_config "$HOME/.yarnrc" "Yarn configuration" "Node.js"
check_config "$HOME/.node-version" "Node version file" "Node.js"
check_config "$HOME/.nvmrc" "NVM configuration" "Node.js"
check_config "$HOME/.cargo/config" "Rust Cargo configuration" "Rust"
check_config "$HOME/.rustup" "Rust toolchain settings" "Rust"
check_config "$HOME/.pypirc" "PyPI configuration" "Python"
check_config "$HOME/.pylintrc" "Pylint configuration" "Python"
check_config "$HOME/.config/pip" "Pip configuration" "Python"
check_config "$HOME/.ipython/profile_default" "IPython configuration" "Python"
check_config "$HOME/.rvm" "Ruby Version Manager" "Ruby"
check_config "$HOME/.rbenv" "rbenv configuration" "Ruby"
check_config "$HOME/.gemrc" "RubyGems configuration" "Ruby"
check_config "$HOME/.bundle/config" "Bundler configuration" "Ruby"

echo -e "${CYAN}=== Database & Data Tools ===${NC}"
check_config "$HOME/.psqlrc" "PostgreSQL client config" "Database"
check_config "$HOME/.my.cnf" "MySQL client config" "Database"
check_config "$HOME/.mongorc.js" "MongoDB shell config" "Database"
check_config "$HOME/.redis-cli_history" "Redis CLI history" "Database"

echo -e "${CYAN}=== Terminal & Multiplexers ===${NC}"
check_config "$HOME/.tmux.conf" "Tmux configuration" "Terminal"
check_config "$HOME/.tmux" "Tmux plugins/themes" "Terminal"
check_config "$HOME/.screenrc" "GNU Screen config" "Terminal"
check_config "$HOME/.config/alacritty" "Alacritty terminal config" "Terminal"
check_config "$HOME/.config/kitty" "Kitty terminal config" "Terminal"
check_config "$HOME/.hyper.js" "Hyper terminal config" "Terminal"
check_config "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "iTerm2 preferences" "Terminal"

echo -e "${CYAN}=== macOS Specific ===${NC}"
check_config "$HOME/.config/karabiner" "Karabiner keyboard customization" "macOS"
check_config "$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences" "Alfred preferences" "macOS"
check_config "$HOME/Library/Preferences/com.apple.Terminal.plist" "Terminal.app preferences" "macOS"
check_config "$HOME/.config/homebrew" "Homebrew configuration" "macOS"
check_config "$HOME/.Brewfile" "Homebrew bundle file" "macOS"

echo -e "${CYAN}=== Security & SSH ===${NC}"
check_config "$HOME/.ssh/config" "SSH client configuration" "Security"
check_config "$HOME/.gnupg/gpg.conf" "GPG configuration" "Security"
check_config "$HOME/.aws/config" "AWS CLI configuration" "Cloud"
check_config "$HOME/.aws/credentials" "AWS credentials (BE CAREFUL!)" "Cloud"
check_config "$HOME/.config/gcloud" "Google Cloud configuration" "Cloud"
check_config "$HOME/.azure" "Azure CLI configuration" "Cloud"

echo -e "${CYAN}=== Other Development Tools ===${NC}"
check_config "$HOME/.docker/config.json" "Docker configuration" "Container"
check_config "$HOME/.kube/config" "Kubernetes configuration" "Container"
check_config "$HOME/.vagrant.d" "Vagrant configuration" "VM"
check_config "$HOME/.ansible.cfg" "Ansible configuration" "DevOps"
check_config "$HOME/.terraformrc" "Terraform configuration" "DevOps"

echo -e "${CYAN}=== Text Processing & Utilities ===${NC}"
check_config "$HOME/.ackrc" "Ack search tool config" "Utils"
check_config "$HOME/.agignore" "The Silver Searcher ignore" "Utils"
check_config "$HOME/.ripgreprc" "Ripgrep configuration" "Utils"
check_config "$HOME/.wgetrc" "Wget configuration" "Utils"
check_config "$HOME/.curlrc" "Curl configuration" "Utils"

echo -e "${CYAN}=== Custom Scripts & Binaries ===${NC}"
if [[ -d "$HOME/bin" ]] && [[ -n "$(ls -A "$HOME/bin" 2>/dev/null)" ]]; then
    echo -e "${GREEN}✓${NC} Found ~/bin directory with custom scripts:"
    ls -la "$HOME/bin" | grep -E "^-rwx" | awk '{print "  " $NF}'
    echo
fi

if [[ -d "$HOME/.local/bin" ]] && [[ -n "$(ls -A "$HOME/.local/bin" 2>/dev/null)" ]]; then
    echo -e "${GREEN}✓${NC} Found ~/.local/bin directory with custom scripts:"
    ls -la "$HOME/.local/bin" | grep -E "^-rwx" | awk '{print "  " $NF}'
    echo
fi

echo -e "${CYAN}=== Looking for other config patterns ===${NC}"
find_by_pattern "*.conf" "Configuration files"
find_by_pattern ".*rc" "RC files"
find_by_pattern "config.json" "JSON config files"
find_by_pattern "config.yaml" "YAML config files"
find_by_pattern "config.yml" "YAML config files"
find_by_pattern "settings.json" "Settings files"

echo -e "${CYAN}=== Summary ===${NC}"
echo "Consider adding the configurations you use regularly to your ConfigHub."
echo
echo -e "${YELLOW}⚠️  Important Security Notes:${NC}"
echo "- Never sync private keys, passwords, or sensitive credentials"
echo "- Be careful with .aws/credentials, .ssh/id_*, API tokens"
echo "- Consider using .gitignore for sensitive files"
echo "- Some files (like .zsh_history) contain sensitive commands"
echo
echo "To check a specific directory in more detail, you can run:"
echo "  ls -la ~/path/to/directory"
