# ConfigHub Backup & Recovery Guide

## Overview

The ConfigHub sync script includes comprehensive backup functionality to protect your configuration files. This guide covers:
- How backups work
- Setting up automatic backups
- Creating manual backups
- Recovering from backups
- Best practices

## Table of Contents
- [Backup Features](#backup-features)
- [Backup Configuration](#backup-configuration)
- [Creating Backups](#creating-backups)
- [Recovery Procedures](#recovery-procedures)
- [Backup Strategies](#backup-strategies)
- [Troubleshooting](#troubleshooting)

## Backup Features

### Automatic Backups
- **Before Each Sync**: By default, a backup is created before every sync operation
- **Rotation**: Automatically keeps only the last 5 backups (configurable)
- **Location**: Stored in `~/Documents/ConfigHub/Backups/`
- **Naming**: `configHub-backup-YYYYMMDD-HHMMSS` format

### Manual Backups
- Create on-demand backups to any location
- Useful before major changes or system updates
- Can be automated via cron/launchd

## Backup Configuration

### Configuration Options

Edit `~/.config/confighub_sync.conf`:

```bash
# Enable/disable automatic backups
ENABLE_BACKUP=true

# Create backup before each sync
BACKUP_BEFORE_SYNC=true

# Number of backups to keep (0 = unlimited)
MAX_BACKUPS=5

# Default backup location (can be overridden)
# Backups go to: $CONFIGHUB_FOLDER/../Backups
```

### Backup Storage Locations

Default backup locations:
- **Automatic backups**: `~/Documents/ConfigHub/Backups/`
- **Manual backups**: Anywhere you specify
- **Safety backups**: Created during restore operations

## Creating Backups

### Method 1: Automatic Backup (During Sync)

```bash
# Regular sync (includes automatic backup)
~/Documents/ConfigHub/Configs/configHub-sync.sh

# Or using alias
chsync
```

### Method 2: Manual Backup Command

```bash
# Backup to specific location
~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Desktop/my-backup

# Using alias with timestamp
chbackup  # Creates backup on Desktop with timestamp
```

### Method 3: Backup-Only Operation

```bash
# Create backup without syncing
~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Backups/manual-backup --dry-run
```

### Method 4: Scheduled Backups

Add to crontab for regular backups:

```bash
# Daily backup at 2 AM
0 2 * * * ~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Backups/daily-$(date +\%Y\%m\%d) --dry-run

# Weekly backup on Sundays
0 3 * * 0 ~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Backups/weekly-$(date +\%Y\%m\%d) --dry-run
```

## Recovery Procedures

### Quick Recovery

Restore from a specific backup:

```bash
# Restore from backup
~/Documents/ConfigHub/Configs/configHub-sync.sh --restore ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000

# A safety backup is automatically created before restore
```

### Manual Recovery

If the script fails, manually restore:

```bash
# 1. Create safety backup of current state
cp -R ~/Documents/ConfigHub/Configs ~/Documents/ConfigHub/Configs-safety-$(date +%Y%m%d)

# 2. Copy backup over current ConfigHub
cp -R ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000/* ~/Documents/ConfigHub/Configs/

# 3. Verify files
ls -la ~/Documents/ConfigHub/Configs/
```

### Selective Recovery

Restore specific files only:

```bash
# Restore just VS Code settings
cp ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000/vscode/* \
   ~/Documents/ConfigHub/Configs/vscode/

# Restore shell configurations
cp ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000/zsh/.zshrc \
   ~/Documents/ConfigHub/Configs/zsh/
```

### Recovery from Git

If local backups are lost:

```bash
# Clone from remote
git clone git@github.com:yourusername/confighub.git ~/Documents/ConfigHub/Configs-recovery

# Or reset to specific commit
cd ~/Documents/ConfigHub/Configs
git log --oneline  # Find the commit you want
git reset --hard <commit-hash>
```

## Backup Strategies

### 3-2-1 Backup Rule

1. **3 copies** of important data:
   - Working copy (your system files)
   - ConfigHub synchronized copy
   - Backup copy

2. **2 different media**:
   - Local disk (automatic backups)
   - Git remote repository

3. **1 offsite backup**:
   - GitHub/GitLab (private repository)

### Recommended Setup

```bash
# 1. Enable automatic backups (default)
ENABLE_BACKUP=true
BACKUP_BEFORE_SYNC=true
MAX_BACKUPS=5

# 2. Set up git remote
GIT_REMOTE_URL="git@github.com:yourusername/confighub.git"

# 3. Schedule regular syncs
# This ensures both local backups and remote pushes
```

### Before Major Changes

Always create a manual backup before:
- macOS updates
- Major application updates
- System migrations
- Experimenting with configurations

```bash
# Create timestamped backup
~/Documents/ConfigHub/Configs/configHub-sync.sh --backup ~/Desktop/before-update-$(date +%Y%m%d-%H%M%S)
```

## Backup Management

### List Available Backups

```bash
# List all backups with sizes and dates
ls -lah ~/Documents/ConfigHub/Backups/

# Find backups older than 30 days
find ~/Documents/ConfigHub/Backups -name "configHub-backup-*" -mtime +30

# Check backup sizes
du -sh ~/Documents/ConfigHub/Backups/*
```

### Clean Up Old Backups

```bash
# Remove backups older than 60 days
find ~/Documents/ConfigHub/Backups -name "configHub-backup-*" -mtime +60 -delete

# Keep only last 10 backups manually
cd ~/Documents/ConfigHub/Backups
ls -t | grep "configHub-backup-" | tail -n +11 | xargs rm -rf
```

### Verify Backup Integrity

```bash
# Compare backup with current ConfigHub
diff -r ~/Documents/ConfigHub/Configs ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000

# Check specific file in backup
cat ~/Documents/ConfigHub/Backups/configHub-backup-20250712-143000/zsh/.zshrc
```

## Troubleshooting

### Common Issues

#### Backup Failed
```bash
# Check disk space
df -h ~/Documents/ConfigHub/

# Check permissions
ls -la ~/Documents/ConfigHub/

# Run with verbose mode
~/configHub-sync.sh --backup ~/Desktop/test-backup --verbose
```

#### Restore Failed
```bash
# Check if backup exists and is readable
ls -la ~/Documents/ConfigHub/Backups/configHub-backup-XXXXX

# Try manual restore (see Manual Recovery section)
```

#### Backups Not Rotating
```bash
# Check configuration
grep MAX_BACKUPS ~/.config/confighub_sync.conf

# List current backups
ls -la ~/Documents/ConfigHub/Backups/ | wc -l

# Manually clean if needed
```

### Backup Best Practices

1. **Test Your Backups**
   - Periodically test restore procedures
   - Verify backup contents
   - Document any issues

2. **Monitor Backup Size**
   ```bash
   # Check total backup size
   du -sh ~/Documents/ConfigHub/Backups
   
   # Set up alert if too large
   # Add to crontab
   0 9 * * * [ $(du -s ~/Documents/ConfigHub/Backups | cut -f1) -gt 1048576 ] && echo "ConfigHub backups exceed 1GB"
   ```

3. **Secure Sensitive Data**
   - Never backup credentials or private keys
   - Use `.gitignore` to exclude sensitive files
   - Encrypt backups if needed:
   ```bash
   # Create encrypted backup
   tar -czf - ~/Documents/ConfigHub/Configs | openssl enc -aes-256-cbc -out backup.tar.gz.enc
   ```

## Emergency Recovery Plan

If everything goes wrong:

1. **Check Local Backups**
   ```bash
   ls -la ~/Documents/ConfigHub/Backups/
   ```

2. **Check Git History**
   ```bash
   cd ~/Documents/ConfigHub/Configs
   git log --oneline
   git reflog  # Shows all actions, even "lost" commits
   ```

3. **Check System Backups**
   - Time Machine (macOS)
   - Other system backup solutions

4. **Reconstruct from System**
   - Your actual config files still exist in their original locations
   - Run sync to recreate ConfigHub:
   ```bash
   ~/configHub-sync.sh
   ```

## Quick Reference

### Essential Commands

```bash
# Create backup
chbackup                    # Alias for quick backup to Desktop
~/Documents/ConfigHub/Configs/configHub-sync.sh --backup /path/to/backup

# List backups
ls -lah ~/Documents/ConfigHub/Backups/

# Restore from backup
~/Documents/ConfigHub/Configs/configHub-sync.sh --restore /path/to/backup

# Check backup size
du -sh ~/Documents/ConfigHub/Backups/

# Clean old backups (keep last 10)
cd ~/Documents/ConfigHub/Backups && ls -t | tail -n +11 | xargs rm -rf
```

### Configuration Quick Reference

```bash
ENABLE_BACKUP=true          # Enable backup feature
BACKUP_BEFORE_SYNC=true     # Auto-backup before sync
MAX_BACKUPS=5              # Keep last 5 backups (0=unlimited)
```

---

**Remember**: The best backup is the one you never need to use, but when you need it, you'll be glad it's there!
