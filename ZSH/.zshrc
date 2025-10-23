# Performance profiling (uncomment to use)
# zmodload zsh/zprof

# ==============================================================================
# ENVIRONMENT SETUP
# ==============================================================================

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

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================

export EDITOR='code'
export VISUAL='code'
export PAGER='less'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Better history management
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# ==============================================================================
# PATH MANAGEMENT
# ==============================================================================

# Add paths safely (avoid duplicates)
typeset -U PATH path
path=(
    $HOME/bin
    $HOME/.local/bin
    /usr/local/bin
    /opt/homebrew/bin
    /opt/homebrew/sbin
    $path
)
export PATH

# ==============================================================================
# OH MY ZSH CONFIGURATION
# ==============================================================================

if [ "$TERM_PROGRAM" != "Apple_Terminal-" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    
    # Recommended plugins for performance
    plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        web-search
        docker
        python
        # Consider adding:
        # z                    # Quick directory jumping
        # extract             # Extract any archive with 'extract filename'
        # command-not-found   # Suggests packages when command not found
    )
    
    # Oh My Posh theme
    if command -v oh-my-posh &> /dev/null; then
        eval "$(oh-my-posh init zsh --config /Users/jimmy/.config/nordic-frost.omp.toml)"
    fi
    
    source $ZSH/oh-my-zsh.sh
fi

# ==============================================================================
# ALIASES - CONFIGURATION FILES
# ==============================================================================

alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"  # Auto-reload after edit
alias gitconf="$EDITOR ~/.gitconfig"
alias condaconf="$EDITOR ~/.condarc"
alias awsconf="$EDITOR ~/.aws/config"
alias jupyterconf="$EDITOR ~/.jupyter/jupyter_notebook_config.py"
alias reload="source ~/.zshrc && echo '✅ .zshrc reloaded'"

# ==============================================================================
# ALIASES - NAVIGATION
# ==============================================================================

alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"  # Go to previous directory

# Quick navigation
alias dev="cd ~/Dev"
alias downloads="cd ~/Downloads"
alias apps="cd ~/Applications"
alias docs="cd ~/Documents"
alias algo="cd ~/Dev/algorithms"
alias desktop="cd ~/Desktop"
alias vs="code ."

# ==============================================================================
# ALIASES - CONFIGHUB
# ==============================================================================

# ConfigHub sync commands
alias chsync="~/Documents/ConfigHub/Configs/configHub-sync.sh"
alias chsync-dry="~/Documents/ConfigHub/Configs/configHub-sync.sh --dry-run --verbose"
alias chbackup="~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Desktop/ConfigHub-Backup-$(date +%Y%m%d)"

# ConfigHub Navigation
alias chdir="cd ~/Documents/ConfigHub/Configs"
alias chedit="$EDITOR ~/.config/confighub_sync.conf"

# ConfigHub Git operations
alias chgit="cd ~/Documents/ConfigHub/Configs && git status"
alias chlog="cd ~/Documents/ConfigHub/Configs && git log --oneline -10"
alias chdiff="cd ~/Documents/ConfigHub/Configs && git diff"

# ==============================================================================
# ALIASES - DEVELOPMENT
# ==============================================================================

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline -10"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"

# Python/Conda
alias py="python"
alias ipy="ipython"
alias jl="jupyter lab"
alias jn="jupyter notebook"
alias condalist="conda env list"
alias mambalist="mamba env list"

# Docker shortcuts
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias drm="docker rm"
alias drmi="docker rmi"

# ==============================================================================
# ALIASES - UTILITIES
# ==============================================================================

# Better ls
if command -v eza &> /dev/null; then
    alias ls="eza --icons"
    alias ll="eza -la --icons"
    alias lt="eza --tree --level=2 --icons"
else
    alias ll="ls -la"
    alias lt="ls -la"
fi

# Enhanced command replacements
if command -v bat &> /dev/null; then
    alias cat="bat"
    alias catp="bat -p"  # Plain output without line numbers
fi

if command -v rg &> /dev/null; then
    alias grep="rg"
    alias rgi="rg -i"  # Case insensitive
fi

# Directory jumping with zoxide (replaces 'z' plugin)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias zz="z -"  # Go to previous directory
fi

# Safety nets
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Useful shortcuts
alias h="history"
alias j="jobs -l"
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# Network
alias myip="curl -s https://api.ipify.org && echo"
alias localip="ipconfig getifaddr en0"
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P"

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick backup
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file/directory>"
        return 1
    fi
    cp -r "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"
    echo "✅ Backed up $1"
}

# Search history
histgrep() {
    history | grep "$1"
}

# ==============================================================================
# SYSTEM UPDATE FUNCTION
# ==============================================================================

update_all() {
    echo "🚀 Starting system update process..."
    
    local start_time=$(date +%s)
    local errors=0
    
    # Function to run command and check status
    run_update() {
        local cmd="$1"
        local desc="$2"
        echo -e "\n📦 $desc..."
        if eval "$cmd"; then
            echo "✅ $desc completed"
        else
            echo "❌ Error: $desc failed" >&2
            ((errors++))
            return 1
        fi
    }
    
    # Homebrew updates
    if command -v brew &> /dev/null; then
        run_update "brew update" "Updating Homebrew"
        run_update "brew upgrade" "Upgrading Homebrew packages"
        run_update "brew upgrade --cask" "Upgrading Homebrew casks"
        
        # Optional: brew cu for auto-updating casks
        if command -v brew cu &> /dev/null; then
            run_update "brew cu -afy" "Auto-updating casks"
        fi
        
        run_update "brew cleanup --prune=all" "Cleaning up Homebrew"
        run_update "brew doctor" "Running Homebrew diagnostics"
    fi
    
    # Mac App Store updates
    if command -v mas &> /dev/null; then
        run_update "mas upgrade" "Updating Mac App Store apps"
    fi
    
    # Micromamba updates
    if command -v micromamba &> /dev/null; then
        # Update base environment
        run_update "micromamba update -n base --all -y" "Updating Micromamba base"
        
        # Update dev environment if it exists
        if micromamba env list | grep -q "^dev "; then
            run_update "micromamba update -n dev --all -y" "Updating Micromamba dev environment"
        fi
    fi
    
    # VS Code extensions update
    if command -v code &> /dev/null; then
        echo -e "\n📦 Updating VS Code extensions..."
        code --list-extensions | while read extension; do
            code --install-extension "$extension" --force &> /dev/null
        done
        echo "✅ VS Code extensions updated"
    fi
    
    # Update ConfigHub system files
    echo -e "\n🔧 Updating ConfigHub system files..."
    local confighub_dir="$HOME/Documents/ConfigHub/Configs"
    
    if [ -d "$confighub_dir" ]; then
        # Update VS Code extensions list
        if command -v code &> /dev/null; then
            code --list-extensions > "$confighub_dir/vscode/extensions.txt"
            echo "✅ Updated VS Code extensions list"
        fi
        
        # Update Brewfile
        if command -v brew &> /dev/null; then
            brew bundle dump --file="$confighub_dir/mac/Brewfile" --force
            echo "✅ Updated Brewfile"
        fi
        
        # Update conda/mamba environment export
        if command -v mamba &> /dev/null; then
            mamba env export -n base > "$confighub_dir/micromamba/base-environment.yml" 2>/dev/null
            echo "✅ Updated base environment export"
            
            if mamba env list | grep -q "^dev "; then
                mamba env export -n dev > "$confighub_dir/micromamba/dev-environment.yml" 2>/dev/null
                echo "✅ Updated dev environment export"
            fi
        fi
        
        # Sync and push ConfigHub
        echo -e "\n📤 Syncing ConfigHub..."
        if ~/Documents/ConfigHub/Configs/configHub-sync.sh; then
            cd "$confighub_dir"
            git add .
            if ! git diff --staged --quiet; then
                git commit -m "Auto-update: System files updated on $(date +'%Y-%m-%d')"
                git push
                echo "✅ ConfigHub synced and pushed"
            else
                echo "ℹ️  No changes to commit in ConfigHub"
            fi
        else
            echo "❌ ConfigHub sync failed"
            ((errors++))
        fi
    else
        echo "⚠️  ConfigHub directory not found, skipping ConfigHub updates"
    fi
    
    # Check for macOS updates
    echo -e "\n🍎 Checking for macOS updates..."
    softwareupdate --list
    
    # Summary
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "\n📊 Update Summary:"
    echo "⏱️  Duration: $((duration / 60)) minutes and $((duration % 60)) seconds"
    echo "❌ Errors: $errors"
    
    if [ $errors -eq 0 ]; then
        echo -e "\n✅ System update process completed successfully!"
        echo "💡 Restart your terminal to ensure all updates take effect"
    else
        echo -e "\n⚠️  System update completed with $errors error(s)"
        return 1
    fi
}

# ==============================================================================
# CONFIGHUB FUNCTIONS
# ==============================================================================

# ConfigHub Combined operations
chpush() {
    echo "🔄 Syncing ConfigHub and pushing to git..."
    if ~/Documents/ConfigHub/Configs/configHub-sync.sh; then
        cd ~/Documents/ConfigHub/Configs && \
        git add . && \
        git commit -m "Sync: $(date +'%Y-%m-%d %H:%M')" && \
        git push && \
        echo "✅ ConfigHub synced and pushed!"
    else
        echo "❌ ConfigHub sync failed"
        return 1
    fi
}

# ConfigHub Status check
chstatus() {
    cd ~/Documents/ConfigHub/Configs || return 1
    echo "📊 === ConfigHub Status ==="
    echo -e "\n📁cd Git Status:"
    git status -s
    echo -e "\n🕐 Last Sync:"
    grep "Last" README.md 2>/dev/null || echo "No sync timestamp found"
    echo -e "\n💾 Backup Status:"
    ls -lah ../Backups 2>/dev/null | tail -5 || echo "No backups found"
    echo -e "\n📝 Recent Commits:"
    git log --oneline -5
}

# ==============================================================================
# COMPLETION & KEY BINDINGS
# ==============================================================================

# Enable completion
autoload -Uz compinit && compinit

# Better tab completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Key bindings for history search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ==============================================================================
# LOAD ADDITIONAL CONFIGURATIONS
# ==============================================================================

# Load sensitive information
if [ -f ~/.zsh_secrets ]; then
    source ~/.zsh_secrets
fi

# Load local configurations
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# ==============================================================================
# STARTUP
# ==============================================================================

# Show system info on startup (optional)
# neofetch
# Or a simple welcome message
echo "👋 Welcome back, $(whoami)!"
echo "📅 $(date '+%A, %B %d, %Y - %H:%M')"
echo "💻 $(uname -n) | 🖥️  $(sw_vers -productVersion)"

# Performance profiling (uncomment to use)
# zprof
