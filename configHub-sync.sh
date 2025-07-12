#!/bin/bash

# ConfigHub Synchronization Script
# Enhanced version with better error handling, backup functionality, and reporting

# Script version
VERSION="2.0.0"

# Configuration file
CONFIG_FILE="$HOME/.config/confighub_sync.conf"

# Default ConfigHub folder
DEFAULT_CONFIGHUB_FOLDER="$HOME/Documents/ConfigHub/Configs"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
DRY_RUN=false
REMOTE_URL=""
VERBOSE=false
FORCE=false
RESTORE=false
BACKUP_DIR=""

show_help() {
    cat << EOF
ConfigHub Sync Script v$VERSION

Usage: $(basename "$0") [OPTIONS]

OPTIONS:
    --dry-run           Show what would be done without making changes
    --remote URL        Set git remote URL
    --verbose, -v       Enable verbose output
    --force             Force sync even if files have conflicts
    --backup DIR        Create backup in specified directory
    --restore DIR       Restore from backup directory
    --version           Show version information
    --help, -h          Show this help message

EXAMPLES:
    # Perform a dry run to see what would be synced
    $(basename "$0") --dry-run

    # Sync with a remote git repository
    $(basename "$0") --remote git@github.com:username/confighub.git

    # Create a backup before syncing
    $(basename "$0") --backup ~/Desktop/config-backup

EOF
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true ;;
        --remote) REMOTE_URL="$2"; shift ;;
        --verbose|-v) VERBOSE=true ;;
        --force) FORCE=true ;;
        --backup) BACKUP_DIR="$2"; shift ;;
        --restore) RESTORE=true; BACKUP_DIR="$2"; shift ;;
        --version) echo "ConfigHub Sync Script v$VERSION"; exit 0 ;;
        --help|-h) show_help; exit 0 ;;
        *) echo "Unknown parameter: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Function to log messages with colors
log_message() {
    local level=$1
    shift
    local message="$@"
    local timestamp="[$(date +'%Y-%m-%d %H:%M:%S')]"
    
    case $level in
        ERROR)
            echo -e "${RED}${timestamp} ERROR: ${message}${NC}" >&2
            ;;
        WARNING)
            echo -e "${YELLOW}${timestamp} WARNING: ${message}${NC}"
            ;;
        SUCCESS)
            echo -e "${GREEN}${timestamp} SUCCESS: ${message}${NC}"
            ;;
        INFO)
            echo -e "${BLUE}${timestamp} INFO: ${message}${NC}"
            ;;
        DEBUG)
            if [[ "$VERBOSE" = true ]]; then
                echo -e "${timestamp} DEBUG: ${message}"
            fi
            ;;
        *)
            echo "${timestamp} $level: $message"
            ;;
    esac
}

# Check for required commands
check_commands() {
    local missing_commands=()
    for cmd in git cp rsync; do
        if ! command -v $cmd &> /dev/null; then
            missing_commands+=($cmd)
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_message ERROR "Missing required commands: ${missing_commands[*]}"
        log_message INFO "Please install the missing commands and try again"
        exit 1
    fi
}

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        log_message DEBUG "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        log_message ERROR "Configuration file not found at $CONFIG_FILE"
        log_message INFO "Please create the configuration file first"
        exit 1
    fi
    
    # Set defaults if not defined
    CONFIGHUB_FOLDER="${CONFIGHUB_FOLDER:-$DEFAULT_CONFIGHUB_FOLDER}"
    ENABLE_GIT_SYNC="${ENABLE_GIT_SYNC:-true}"
    ENABLE_BACKUP="${ENABLE_BACKUP:-true}"
    BACKUP_BEFORE_SYNC="${BACKUP_BEFORE_SYNC:-true}"
    MAX_BACKUPS="${MAX_BACKUPS:-5}"
    
    # Override with command line remote if provided
    if [[ -n "$REMOTE_URL" ]]; then
        GIT_REMOTE_URL="$REMOTE_URL"
    fi
}

# Create the ConfigHub folder structure
create_folders() {
    if [[ "$DRY_RUN" = false ]]; then
        mkdir -p "$CONFIGHUB_FOLDER" || {
            log_message ERROR "Failed to create ConfigHub folder"
            exit 1
        }
        
        # Create subdirectories based on the files to sync
        local dirs=()
        for file_pair in "${FILES_TO_SYNC[@]}"; do
            IFS=':' read -r source destination <<< "$file_pair"
            local dir=$(dirname "$destination")
            if [[ "$dir" != "." ]]; then
                dirs+=("$dir")
            fi
        done
        
        # Create unique directories
        local unique_dirs=($(printf "%s\n" "${dirs[@]}" | sort -u))
        for dir in "${unique_dirs[@]}"; do
            mkdir -p "$CONFIGHUB_FOLDER/$dir" || {
                log_message ERROR "Failed to create subfolder: $dir"
                exit 1
            }
            log_message DEBUG "Created directory: $CONFIGHUB_FOLDER/$dir"
        done
    else
        log_message INFO "Dry run: Would create folder $CONFIGHUB_FOLDER and necessary subfolders"
    fi
}

# Create backup
create_backup() {
    if [[ "$ENABLE_BACKUP" != true || "$DRY_RUN" = true ]]; then
        return
    fi
    
    local backup_name="configHub-backup-$(date +'%Y%m%d-%H%M%S')"
    local backup_path="${BACKUP_DIR:-$CONFIGHUB_FOLDER/../Backups}/$backup_name"
    
    log_message INFO "Creating backup at $backup_path"
    
    mkdir -p "$(dirname "$backup_path")"
    if cp -R "$CONFIGHUB_FOLDER" "$backup_path"; then
        log_message SUCCESS "Backup created successfully"
        
        # Clean up old backups
        if [[ -n "$MAX_BACKUPS" ]] && [[ "$MAX_BACKUPS" -gt 0 ]]; then
            local backup_dir="$(dirname "$backup_path")"
            local backup_count=$(ls -1 "$backup_dir" | grep -c "configHub-backup-")
            if [[ "$backup_count" -gt "$MAX_BACKUPS" ]]; then
                local to_delete=$((backup_count - MAX_BACKUPS))
                log_message DEBUG "Removing $to_delete old backups"
                ls -1t "$backup_dir" | grep "configHub-backup-" | tail -n "$to_delete" | while read old_backup; do
                    rm -rf "$backup_dir/$old_backup"
                    log_message DEBUG "Removed old backup: $old_backup"
                done
            fi
        fi
    else
        log_message ERROR "Failed to create backup"
        exit 1
    fi
}

# Restore from backup
restore_from_backup() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_message ERROR "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi
    
    log_message INFO "Restoring from backup: $BACKUP_DIR"
    
    if [[ "$DRY_RUN" = false ]]; then
        # Create a safety backup first
        local safety_backup="$CONFIGHUB_FOLDER/../Safety-Backup-$(date +'%Y%m%d-%H%M%S')"
        cp -R "$CONFIGHUB_FOLDER" "$safety_backup" 2>/dev/null
        
        # Restore from backup
        if rsync -av --delete "$BACKUP_DIR/" "$CONFIGHUB_FOLDER/"; then
            log_message SUCCESS "Restored from backup successfully"
            log_message INFO "Safety backup created at: $safety_backup"
        else
            log_message ERROR "Failed to restore from backup"
            exit 1
        fi
    else
        log_message INFO "Dry run: Would restore from $BACKUP_DIR to $CONFIGHUB_FOLDER"
    fi
}

# Sync files
sync_files() {
    local successful_syncs=0
    local failed_syncs=0
    local skipped_files=0
    
    # Sync individual files
    for file_pair in "${FILES_TO_SYNC[@]}"; do
        IFS=':' read -r source destination <<< "$file_pair"
        
        # Expand tilde and variables in source path
        source=$(eval echo "$source")
        
        if [[ -z "$destination" ]]; then
            log_message WARNING "No destination specified for $source, skipping..."
            ((skipped_files++))
            continue
        fi
        
        local full_destination="$CONFIGHUB_FOLDER/$destination"
        
        if [[ -e "$source" ]]; then
            if [[ "$DRY_RUN" = false ]]; then
                # Create destination directory if needed
                mkdir -p "$(dirname "$full_destination")"
                
                # Check if source is a directory
                if [[ -d "$source" ]]; then
                    if rsync -av "$source/" "$full_destination/"; then
                        log_message SUCCESS "Synced directory: $source to $full_destination"
                        ((successful_syncs++))
                    else
                        log_message ERROR "Failed to sync directory: $source"
                        ((failed_syncs++))
                    fi
                else
                    if cp "$source" "$full_destination"; then
                        log_message SUCCESS "Synced: $source to $full_destination"
                        ((successful_syncs++))
                    else
                        log_message ERROR "Failed to sync: $source"
                        ((failed_syncs++))
                    fi
                fi
            else
                log_message INFO "Dry run: Would sync $source to $full_destination"
                ((successful_syncs++))
            fi
        else
            log_message WARNING "$source not found, skipping..."
            ((skipped_files++))
        fi
    done
    
    # Sync directories
    for dir_pair in "${DIRS_TO_SYNC[@]}"; do
        IFS=':' read -r source destination <<< "$dir_pair"
        source=$(eval echo "$source")
        
        if [[ -z "$destination" ]]; then
            log_message WARNING "No destination specified for directory $source, skipping..."
            ((skipped_files++))
            continue
        fi
        
        local full_destination="$CONFIGHUB_FOLDER/$destination"
        
        if [[ -d "$source" ]]; then
            if [[ "$DRY_RUN" = false ]]; then
                mkdir -p "$full_destination"
                if rsync -av "$source/" "$full_destination/"; then
                    log_message SUCCESS "Synced directory: $source to $full_destination"
                    ((successful_syncs++))
                else
                    log_message ERROR "Failed to sync directory: $source"
                    ((failed_syncs++))
                fi
            else
                log_message INFO "Dry run: Would sync directory $source to $full_destination"
                ((successful_syncs++))
            fi
        else
            log_message WARNING "Directory $source not found, skipping..."
            ((skipped_files++))
        fi
    done
    
    # Summary
    log_message INFO "Sync summary: $successful_syncs successful, $failed_syncs failed, $skipped_files skipped"
    
    if [[ $successful_syncs -eq 0 ]] && [[ $failed_syncs -eq 0 ]]; then
        log_message WARNING "No files were synced"
        exit 1
    fi
}

# Git operations
git_operations() {
    if [[ "$ENABLE_GIT_SYNC" != true ]]; then
        log_message DEBUG "Git sync is disabled"
        return
    fi
    
    if [[ "$DRY_RUN" = true ]]; then
        log_message INFO "Dry run: Would perform git operations in $CONFIGHUB_FOLDER"
        return
    fi

    cd "$CONFIGHUB_FOLDER" || {
        log_message ERROR "Failed to change to ConfigHub folder"
        exit 1
    }

    # Initialize git repo if needed
    if [[ ! -d .git ]]; then
        git init || {
            log_message ERROR "Failed to initialize git repository"
            exit 1
        }
        log_message SUCCESS "Initialized new git repository"
        
        # Create .gitignore
        if [[ ${#GIT_EXCLUDE_PATTERNS[@]} -gt 0 ]]; then
            printf "%s\n" "${GIT_EXCLUDE_PATTERNS[@]}" > .gitignore
            log_message DEBUG "Created .gitignore file"
        fi
        
        git add .
        git commit -m "Initial commit: ConfigHub setup" || {
            log_message ERROR "Failed to commit initial setup"
            exit 1
        }
    fi

    # Set up remote if provided
    if [[ -n "${GIT_REMOTE_URL:-}" ]]; then
        if ! git remote | grep -q "^origin$"; then
            git remote add origin "$GIT_REMOTE_URL" || {
                log_message ERROR "Failed to add remote"
                exit 1
            }
            log_message SUCCESS "Added git remote: $GIT_REMOTE_URL"
        else
            # Update remote URL if it changed
            local current_url=$(git remote get-url origin)
            if [[ "$current_url" != "$GIT_REMOTE_URL" ]]; then
                git remote set-url origin "$GIT_REMOTE_URL"
                log_message INFO "Updated git remote URL"
            fi
        fi
    fi

    # Fetch if remote exists
    if git remote | grep -q "^origin$"; then
        log_message DEBUG "Fetching from remote..."
        git fetch origin 2>/dev/null || log_message WARNING "Could not fetch from remote"
    fi

    # Check for changes
    git add . || {
        log_message ERROR "Failed to add files to git"
        exit 1
    }
    
    if git diff --staged --quiet; then
        log_message INFO "No changes to commit"
    else
        git commit -m "Sync ConfigHub - $(date +'%Y-%m-%d %H:%M:%S')" || {
            log_message ERROR "Failed to commit changes"
            exit 1
        }
        log_message SUCCESS "Changes committed"
    fi

    # Push if remote exists
    if git remote | grep -q "^origin$"; then
        # Check if we need to set upstream
        local current_branch=$(git branch --show-current)
        if ! git rev-parse --abbrev-ref "$current_branch@{upstream}" &>/dev/null; then
            log_message DEBUG "Setting upstream branch"
            git push -u origin "$current_branch" || {
                log_message WARNING "Failed to push. You may need to set up the remote repository"
            }
        else
            git push || {
                log_message WARNING "Failed to push changes"
            }
        fi
    fi
}

# Generate report
generate_report() {
    if [[ "$VERBOSE" != true ]]; then
        return
    fi
    
    echo
    log_message INFO "=== ConfigHub Sync Report ==="
    log_message INFO "ConfigHub location: $CONFIGHUB_FOLDER"
    log_message INFO "Configuration file: $CONFIG_FILE"
    
    if [[ -d "$CONFIGHUB_FOLDER/.git" ]]; then
        cd "$CONFIGHUB_FOLDER"
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        local last_commit=$(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")
        log_message INFO "Git commits: $commit_count"
        log_message INFO "Last commit: $last_commit"
        
        if git remote | grep -q "^origin$"; then
            local remote_url=$(git remote get-url origin)
            log_message INFO "Git remote: $remote_url"
        fi
    fi
    
    local total_size=$(du -sh "$CONFIGHUB_FOLDER" 2>/dev/null | cut -f1)
    log_message INFO "Total size: $total_size"
}

# Main execution
main() {
    log_message INFO "Starting ConfigHub sync process (v$VERSION)"
    
    check_commands
    load_config
    
    if [[ "$RESTORE" = true ]]; then
        restore_from_backup
        exit 0
    fi
    
    if [[ "$BACKUP_BEFORE_SYNC" = true ]] && [[ "$DRY_RUN" = false ]]; then
        create_backup
    fi
    
    create_folders
    sync_files
    git_operations
    generate_report
    
    log_message SUCCESS "ConfigHub sync completed successfully"
}

# Trap errors
trap 'log_message ERROR "Script failed at line $LINENO"' ERR

# Run the main function
main
