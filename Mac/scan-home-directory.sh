#!/bin/bash

# Comprehensive Home Directory Scanner
# Finds potentially important files and folders in your home directory

echo "=== Comprehensive Home Directory Scan ==="
echo "Analyzing $HOME for important files and configurations..."
echo

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Function to format file sizes
format_size() {
    local size=$1
    if [[ $size -gt 1073741824 ]]; then
        echo "$(( size / 1073741824 ))G"
    elif [[ $size -gt 1048576 ]]; then
        echo "$(( size / 1048576 ))M"
    elif [[ $size -gt 1024 ]]; then
        echo "$(( size / 1024 ))K"
    else
        echo "${size}B"
    fi
}

echo -e "${CYAN}=== Top-Level Directories in Home ===${NC}"
echo "Excluding: Library, .Trash, and cache directories"
echo

# Find all directories in home (1 level deep)
find "$HOME" -maxdepth 1 -type d -not -path "$HOME" | sort | while read -r dir; do
    dirname=$(basename "$dir")
    
    # Skip system and cache directories
    if [[ "$dirname" =~ ^(Library|.Trash|.cache|.npm|.cargo|.rustup|.gradle|.m2|.ivy2)$ ]]; then
        continue
    fi
    
    # Get directory size
    size=$(du -sk "$dir" 2>/dev/null | cut -f1)
    formatted_size=$(format_size $((size * 1024)))
    
    # Count files
    file_count=$(find "$dir" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    # Highlight important directories
    if [[ "$dirname" =~ ^(Documents|Dev|Projects|Work|Code|Scripts)$ ]]; then
        echo -e "${GREEN}📁 $dirname${NC} - Size: $formatted_size, Files: $file_count"
    elif [[ "$dirname" =~ ^\..*$ ]]; then
        echo -e "${BLUE}🔧 $dirname${NC} - Size: $formatted_size, Files: $file_count"
    else
        echo -e "📁 $dirname - Size: $formatted_size, Files: $file_count"
    fi
done

echo
echo -e "${CYAN}=== Hidden Files in Home (Potential Configs) ===${NC}"
find "$HOME" -maxdepth 1 -name ".*" -type f -not -name ".DS_Store" -not -name ".*_history" -not -name ".lesshst" | sort | while read -r file; do
    size=$(stat -f%z "$file" 2>/dev/null || echo "0")
    formatted_size=$(format_size $size)
    mod_date=$(stat -f "%Sm" -t "%Y-%m-%d" "$file" 2>/dev/null)
    filename=$(basename "$file")
    echo -e "${YELLOW}$filename${NC} - Size: $formatted_size, Modified: $mod_date"
done

echo
echo -e "${CYAN}=== Script Files Found ===${NC}"
echo "Looking for shell scripts, Python scripts, etc..."

# Find scripts in common locations
for dir in "$HOME" "$HOME/Documents" "$HOME/Desktop" "$HOME/bin" "$HOME/.local/bin" "$HOME/Scripts"; do
    if [[ -d "$dir" ]]; then
        found=$(find "$dir" -maxdepth 2 -type f \( -name "*.sh" -o -name "*.py" -o -name "*.rb" -o -name "*.pl" \) 2>/dev/null | grep -v -E "(node_modules|venv|env|.git)" | head -10)
        if [[ -n "$found" ]]; then
            echo -e "${MAGENTA}In $dir:${NC}"
            echo "$found" | while read -r script; do
                echo "  - $(basename "$script")"
            done
        fi
    fi
done

echo
echo -e "${CYAN}=== Development Projects ===${NC}"
echo "Looking for git repositories..."

# Find git repositories
for base_dir in "$HOME/Documents" "$HOME/Dev" "$HOME/Projects" "$HOME/Work" "$HOME/Code" "$HOME"; do
    if [[ -d "$base_dir" ]]; then
        repos=$(find "$base_dir" -maxdepth 3 -name ".git" -type d 2>/dev/null | head -20)
        if [[ -n "$repos" ]]; then
            echo -e "${MAGENTA}In $base_dir:${NC}"
            echo "$repos" | while read -r git_dir; do
                repo_dir=$(dirname "$git_dir")
                repo_name=$(basename "$repo_dir")
                # Check if it has a remote
                if cd "$repo_dir" 2>/dev/null && git remote -v 2>/dev/null | grep -q origin; then
                    echo -e "  ${GREEN}✓${NC} $repo_name (has remote)"
                else
                    echo -e "  ${YELLOW}⚠${NC}  $repo_name (local only)"
                fi
            done
        fi
    fi
done

echo
echo -e "${CYAN}=== Important Files in Documents ===${NC}"
# Look for potentially important files in Documents
if [[ -d "$HOME/Documents" ]]; then
    echo "Configuration files:"
    find "$HOME/Documents" -maxdepth 3 -type f \( -name "*.conf" -o -name "*.config" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | grep -v -E "(node_modules|.git)" | head -10 | while read -r file; do
        echo "  - ${file#$HOME/Documents/}"
    done
    
    echo
    echo "Documentation files:"
    find "$HOME/Documents" -maxdepth 2 -type f \( -name "*.md" -o -name "*.txt" \) -size +1k 2>/dev/null | grep -E "(README|NOTES|TODO|SETUP|INSTALL)" | head -10 | while read -r file; do
        echo "  - ${file#$HOME/Documents/}"
    done
fi

echo
echo -e "${CYAN}=== Application Support Configurations ===${NC}"
if [[ -d "$HOME/Library/Application Support" ]]; then
    # Look for important app configs
    for app in "Sublime Text" "TextMate" "Atom" "JetBrains" "Postman" "TablePlus" "Sequel Pro" "SourceTree" "Tower" "Fork" "Insomnia" "Paw"; do
        if [[ -d "$HOME/Library/Application Support/$app" ]]; then
            size=$(du -sh "$HOME/Library/Application Support/$app" 2>/dev/null | cut -f1)
            echo -e "${GREEN}✓${NC} $app configuration found (Size: $size)"
        fi
    done
fi

echo
echo -e "${CYAN}=== Analysis Summary ===${NC}"

# Count total config files
config_count=$(find "$HOME" -maxdepth 3 -name ".*rc" -o -name "*.conf" -o -name "*.config" 2>/dev/null | wc -l | tr -d ' ')
echo "Total configuration files found: $config_count"

# Count scripts
script_count=$(find "$HOME" -maxdepth 3 \( -name "*.sh" -o -name "*.py" \) -type f 2>/dev/null | grep -v -E "(node_modules|venv|.git)" | wc -l | tr -d ' ')
echo "Total script files found: $script_count"

# Count git repos
git_count=$(find "$HOME" -maxdepth 4 -name ".git" -type d 2>/dev/null | wc -l | tr -d ' ')
echo "Total git repositories found: $git_count"

echo
echo -e "${YELLOW}=== Recommendations ===${NC}"
echo "1. Consider syncing any custom scripts you use regularly"
echo "2. Document or sync important application configurations"
echo "3. Keep track of project-specific configs that might be useful"
echo "4. Consider creating a 'setup-notes.md' for manual configurations"
echo
echo "To explore a specific directory in detail, run:"
echo "  ls -la <directory_path>"
echo "  tree -L 2 <directory_path>  # if you have tree installed"
