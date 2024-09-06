#!/bin/bash

# ConfigHub Synchronization Script

# Configuration file
CONFIG_FILE="$HOME/.config/confighub_sync.conf"

# Default ConfigHub folder
DEFAULT_CONFIGHUB_FOLDER="$HOME/Documents/ConfigHub/Configs"

# Parse command line arguments
DRY_RUN=false
REMOTE_URL=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true ;;
        --remote) REMOTE_URL="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Function to log messages
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check for required commands
check_commands() {
    for cmd in git cp; do
        if ! command -v $cmd &> /dev/null; then
            log_message "Error: $cmd is not installed or not in PATH"
            exit 1
        fi
    done
}

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        log_message "Warning: Configuration file not found. Using defaults."
        CONFIGHUB_FOLDER="$DEFAULT_CONFIGHUB_FOLDER"
        FILES_TO_SYNC=(
            "$HOME/.gitconfig:Git/.gitconfig"
            "$HOME/.condarc:Micromamba/.condarc"
            "$HOME/.jupyter/jupyter_lab_config.py:Micromamba/jupyter_lab_config.py"
            "$HOME/.jupyter/jupyter_notebook_config.py:Micromamba/jupyter_notebook_config.py"
            "$HOME/Library/Application Support/Code/User/settings.json:VSCode/code-user-settings.json"
            "$HOME/.vscode/spell-dictionary.txt:VSCode/spell-dictionary.txt"
            "$HOME/.zshrc:ZSH/.zshrc"
        )
    fi
}

# Create the ConfigHub folder structure
create_folders() {
    if [[ "$DRY_RUN" = false ]]; then
        mkdir -p "$CONFIGHUB_FOLDER" || {
            log_message "Error: Failed to create ConfigHub folder"
            exit 1
        }
        for dir in git mac micromamba vscode zsh how-to iTerm2; do
            mkdir -p "$CONFIGHUB_FOLDER/$dir" || {
                log_message "Error: Failed to create ConfigHub subfolder: $dir"
                exit 1
            }
        done
    else
        log_message "Dry run: Would create folder $CONFIGHUB_FOLDER and necessary subfolders"
    fi
}

# Sync files
sync_files() {
    local successful_syncs=0
    for file_pair in "${FILES_TO_SYNC[@]}"; do
        IFS=':' read -r source destination <<< "$file_pair"
        full_destination="$CONFIGHUB_FOLDER/$destination"
        if [[ -f "$source" ]]; then
            if [[ "$DRY_RUN" = false ]]; then
                if cp "$source" "$full_destination"; then
                    log_message "Synced: $source to $full_destination"
                    ((successful_syncs++))
                else
                    log_message "Error: Failed to sync $source"
                fi
            else
                log_message "Dry run: Would sync $source to $full_destination"
                ((successful_syncs++))
            fi
        else
            log_message "Warning: $source not found, skipping..."
        fi
    done
    if [[ $successful_syncs -eq 0 ]]; then
        log_message "Error: No files were synced"
        exit 1
    fi
    log_message "Successfully synced $successful_syncs files"
}

# Git operations
git_operations() {
    if [[ "$DRY_RUN" = true ]]; then
        log_message "Dry run: Would perform git operations in $CONFIGHUB_FOLDER"
        return
    fi

    cd "$CONFIGHUB_FOLDER" || {
        log_message "Error: Failed to change to ConfigHub folder"
        exit 1
    }

    if [[ ! -d .git ]]; then
        git init || {
            log_message "Error: Failed to initialize git repository"
            exit 1
        }
        log_message "Initialized new git repository in $CONFIGHUB_FOLDER"
        
        # Add README.md with repository description
        echo "# ConfigHub
Centralized configuration management for development environments
This repository contains my personal configuration files and setup instructions for various development tools and environments. It's designed to be easily synchronized across different machines to maintain a consistent workspace." > README.md
        git add README.md
        git commit -m "Initial commit: Add README with repository description" || {
            log_message "Error: Failed to commit initial README"
            exit 1
        }
    fi

    if [[ -n "$REMOTE_URL" ]]; then
        if ! git remote | grep -q "^origin$"; then
            git remote add origin "$REMOTE_URL" || {
                log_message "Error: Failed to add remote"
                exit 1
            }
            log_message "Added remote: $REMOTE_URL"
        fi
    fi

    # Check if there are any changes to commit
    if git diff-index --quiet HEAD --; then
        log_message "No changes to commit. ConfigHub is up to date."
        return
    fi

    git add . || {
        log_message "Error: Failed to add files to git"
        exit 1
    }

    git commit -m "Sync ConfigHub $(date +'%Y-%m-%d %H:%M:%S')" || {
        log_message "Error: Failed to commit changes"
        exit 1
    }

    if ! git push origin main 2>/dev/null && ! git push origin master 2>/dev/null; then
        log_message "Error: Failed to push changes. Ensure the remote is set up correctly."
        exit 1
    fi

    log_message "Successfully pushed changes to git repository"
}

# Main execution
main() {
    log_message "Starting ConfigHub sync process"
    check_commands
    load_config
    create_folders
    sync_files
    git_operations
    log_message "ConfigHub sync process completed successfully"
}

# Run the main function
main
