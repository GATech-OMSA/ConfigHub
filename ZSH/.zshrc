# Performance profiling (uncomment to use)
# zmodload zsh/zprof

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/jimmy/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE" # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Environment Variables
export EDITOR='code'
export VISUAL='code'
export PAGER='less'

# Path Management
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Oh My Zsh Configuration
if [ "$TERM_PROGRAM" != "Apple_Terminal-" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        web-search
        docker
        # npm
        python
    )
    eval "$(oh-my-posh init zsh --config /Users/jimmy/.config/nordic-frost.omp.toml)"
    source $ZSH/oh-my-zsh.sh
fi

alias zshrc="$EDITOR ~/.zshrc"
alias gitconf="$EDITOR ~/.gitconfig"
alias condaconf="$EDITOR ~/.condarc"
alias awsconf="$EDITOR ~/.aws/config"
# alias dockerconf="$EDITOR ~/.docker/config.json"
# alias npmconf="$EDITOR ~/.npmrc"
# alias yarnconf="$EDITOR ~/.yarnrc"
alias jupyterconf="$EDITOR ~/.jupyter/jupyter_notebook_config.py"

# Navigation
alias c="clear"
alias dev="cd ~/Dev"
alias downloads="cd ~/Downloads"
alias apps="cd ~/Applications"
alias docs="cd ~/Documents"
alias algo="cd ~/Dev/algorithms"
alias desktop="cd /Users/jimmy/Desktop"
alias vs="code ."

# Utility
# alias listaliases="alias | sort | bat" # Requires 'bat' to be installed
# alias update_all="update_all"

# Load sensitive information
if [ -f ~/.zsh_secrets ]; then
    source ~/.zsh_secrets
fi

update_all() {
    echo "Starting system update process..."
    # brew upgrade; brew update; brew cu -afy; mas upgrade; brew cleanup --prune=all; brew doctor; 
    # Update Homebrew
    echo "\nUpdating Homebrew..."
    brew update || { echo "Error updating Homebrew" >&2; return 1; }

    # Upgrade Homebrew packages
    echo "\nUpgrading Homebrew packages..."
    brew upgrade || { echo "Error upgrading Homebrew packages" >&2; return 1; }

    # Upgrade Homebrew casks
    echo "\nUpgrading Homebrew casks..."
    brew upgrade --cask || { echo "Error upgrading Homebrew casks" >&2; return 1; }

    # Run Homebrew's diagnostic check
    echo "\nRunning Homebrew diagnostic check..."
    brew doctor || { echo "Error: Homebrew diagnostic check failed" >&2; return 1; }

    # Update Homebrew casks (including auto-update and latest)
    echo "\nUpdating all casks (including auto-update and latest)..."
    brew cu -afy || { echo "Error updating casks with brew-cask-upgrade" >&2; return 1; }

    # Update Mac App Store apps
    if command -v mas &> /dev/null; then
        echo "\nUpdating Mac App Store apps..."
        mas upgrade || { echo "Error updating Mac App Store apps" >&2; return 1; }
    else
        echo "\nmas not found. Skipping Mac App Store updates."
    fi

    # Run Homebrew's diagnostic check
    echo "\nRunning Homebrew diagnostic check..."
    brew doctor || { echo "Error: Homebrew diagnostic check failed" >&2; return 1; }

    # Update Micromamba
    if command -v micromamba &> /dev/null; then
        echo "\nUpdating Micromamba..."
        micromamba update -n dev --all || { echo "Error updating Micromamba" >&2; return 1; }
    else
        echo "\nmicromamba not found. Skipping Micromamba update."
    fi

    # Cleanup Homebrew
    echo "\nCleaning up Homebrew..."
    brew cleanup --prune=all || { echo "Error cleaning up Homebrew" >&2; return 1; }

    # Check for macOS updates
    echo "\nChecking for macOS updates..."
    softwareupdate --list

    echo "\nSystem update process completed!"
}

# ConfigHub Aliases
alias chsync="/Users/jimmy/Documents/ConfigHub/Configs/mac/configHub-sync.sh"
alias chsync-dry="/Users/jimmy/Documents/ConfigHub/Configs/mac/configHub-sync.sh --dry-run --verbose"
alias chbackup="/Users/jimmy/Documents/ConfigHub/Configs/mac/configHub-sync.sh --backup ~/Desktop/ConfigHub-Backup-$(date +%Y%m%d)"

# ConfigHub Navigation
alias chdir="cd ~/Documents/ConfigHub/Configs"
alias chedit="code ~/.config/confighub_sync.conf"

# ConfigHub Git operations
alias chgit="cd ~/Documents/ConfigHub/Configs && git status"
alias chlog="cd ~/Documents/ConfigHub/Configs && git log --oneline -10"
alias chdiff="cd ~/Documents/ConfigHub/Configs && git diff"

# ConfigHub Combined operations
chpush() {
    echo "🔄 Syncing ConfigHub and pushing to git..."
    /Users/jimmy/Documents/ConfigHub/Configs/mac/configHub-sync.sh && \
    cd ~/Documents/ConfigHub/Configs && \
    git add . && \
    git commit -m "Sync: $(date +'%Y-%m-%d %H:%M')" && \
    git push && \
    echo "✅ ConfigHub synced and pushed!"
}

# Status check
chstatus() {
    cd ~/Documents/ConfigHub/Configs
    echo "=== Git Status ==="
    git status -s
    echo -e "\n=== Recent Commits ==="
    git log --oneline -5
    echo -e "\n=== Last Sync ==="
    grep "Last" README.md 2>/dev/null || echo "No sync timestamp found"
}
