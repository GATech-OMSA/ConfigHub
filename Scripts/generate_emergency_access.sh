#!/bin/bash

# Emergency Access Symlinks Generator
# Creates organized symlinks to critical documents for easy emergency access
# Compatible with macOS default bash (3.2)

set -euo pipefail

# Configuration
SOURCE_DIR="/Users/jimmy/Documents/Database Alpha"
TARGET_DIR="/Users/jimmy/Documents/00 Emergency Access"

# Additional directories to exclude (user can modify this)
ADDITIONAL_EXCLUDE_DIRS=(
    "Drafts"
    "Archive"
    "Backup"
    "Old"
    "Templates"
    "Private **Do Not Delete**"
    "10 Resources & Planning"
    "09 Digital Security"
    "Official Fillings"  # Attorney filings, not the actual docs
)

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Emergency Access Symlinks Generator ===${NC}"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo

# Verify source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory not found: $SOURCE_DIR${NC}"
    exit 1
fi

# Remove and recreate target directory
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Removing existing emergency access directory...${NC}"
    rm -rf "$TARGET_DIR"
fi

echo -e "${GREEN}Creating emergency access directory structure...${NC}"
mkdir -p "$TARGET_DIR"

# Create directory structure
declare -a DIRS=(
    "Immigration Status/Work Authorization"
    "Immigration Status/Permanent Residence"
    "Immigration Status/Entry Records"
    "Immigration Status/Visas"
    "Identity & Travel"
    "Medical Emergency"
    "Insurance"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$TARGET_DIR/$dir"
done

# Exclusion patterns for filenames
EXCLUDE_FILE_PATTERNS="template|sample|example|draft|test|backup|old|archive|tbd|consolidated|readme"

# Function to check if file should be excluded
should_exclude() {
    local file="$1"
    local basename=$(basename "$file")
    
    # Check if in excluded directories
    for exclude_dir in "${ADDITIONAL_EXCLUDE_DIRS[@]}"; do
        if [[ "$file" == *"/$exclude_dir/"* ]]; then
            return 0
        fi
    done
    
    # Check if filename matches exclusion patterns
    if echo "$basename" | grep -qiE "$EXCLUDE_FILE_PATTERNS"; then
        return 0
    fi
    
    # Exclude .DS_Store, .zip, .msg, .txt, .xlsx files
    if [[ "$basename" == ".DS_Store" ]] || [[ "$basename" == *.zip ]] || [[ "$basename" == *.msg ]] || [[ "$basename" == *.txt ]] || [[ "$basename" == *.xlsx ]]; then
        return 0
    fi
    
    return 1
}

# Function to extract year from filename
extract_year() {
    local filename="$1"
    if [[ "$filename" =~ (19|20)[0-9]{2} ]]; then
        echo "${BASH_REMATCH[0]}"
    else
        echo ""
    fi
}

# Function to calculate score for file selection
calculate_score() {
    local filename="$1"
    local basename=$(basename "$filename")
    
    # Check for "Latest" keyword
    if [[ "$basename" =~ [Ll]atest ]]; then
        echo 999999
        return
    fi
    
    # Check for I-94 YYMM format
    if [[ "$basename" =~ I-94.*-[[:space:]]*([0-9]{4})[[:space:]]*- ]]; then
        local yymm="${BASH_REMATCH[1]}"
        local year="20${yymm:0:2}"
        local month="${yymm:2:2}"
        echo "${year}${month}"
        return
    fi
    
    # Check for year in path (for Work Authorization folders)
    if [[ "$filename" =~ /(20[0-9]{2})([[:space:]]|_) ]]; then
        echo "${BASH_REMATCH[1]}"
        return
    fi
    
    # Check for regular year in filename
    local year=$(extract_year "$basename")
    if [ -n "$year" ]; then
        echo "$year"
        return
    fi
    
    # Default score for files without year or latest
    echo 1
}

# Function to create symlink with proper naming
create_symlink() {
    local source="$1"
    local target_dir="$2"
    local link_name="$3"
    
    local target="$target_dir/$link_name"
    
    if ln -s "$source" "$target" 2>/dev/null; then
        echo -e "${GREEN}  ✓ Created: $link_name${NC}"
        return 0
    else
        echo -e "${RED}  ✗ Failed: $link_name${NC}"
        return 1
    fi
}

# Function to find latest file from a list
find_latest_file() {
    local pattern="$1"
    local search_path="${2:-$SOURCE_DIR}"
    local temp_file="/tmp/emergency_files_temp.txt"
    local temp_scores="/tmp/emergency_scores_temp.txt"
    
    # Clean up temp files
    rm -f "$temp_file" "$temp_scores"
    
    # Find all matching files and calculate scores
    find "$search_path" -type f -iname "*${pattern}*" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if ! should_exclude "$file"; then
            local score=$(calculate_score "$file")
            echo "$score|$file" >> "$temp_scores"
        fi
    done
    
    # Find highest scoring file
    if [ -f "$temp_scores" ]; then
        sort -t'|' -k1 -nr "$temp_scores" | head -1 | cut -d'|' -f2-
    fi
    
    # Clean up
    rm -f "$temp_file" "$temp_scores"
}

# Function to process H1B files with special logic
process_h1b_files() {
    local target_subdir="$1"
    local temp_file="/tmp/emergency_h1b_temp.txt"
    
    # Find all I-797 files in Work Authorization folders
    rm -f "$temp_file"
    find "$SOURCE_DIR/02 US Immigration/Work Authorization" -type f -name "*I-797*" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if ! should_exclude "$file"; then
            local score=$(calculate_score "$file")
            local basename=$(basename "$file")
            # Check if it's an approval (I-797A) or receipt (I-797C)
            local doc_type="other"
            if [[ "$basename" =~ I-797A ]]; then
                doc_type="approval"
            elif [[ "$basename" =~ I-797C ]]; then
                doc_type="receipt"
            fi
            echo "$score|$file|$basename|$doc_type" >> "$temp_file"
        fi
    done
    
    if [ ! -f "$temp_file" ] || [ ! -s "$temp_file" ]; then
        echo -e "${YELLOW}  No H1B files found${NC}"
        return
    fi
    
    # Find latest approval and current year files
    local latest_approval=""
    local latest_approval_score=0
    local file_current_year=""
    local score_current_year=0
    local current_year=$(date +%Y)
    
    while IFS='|' read -r score file basename doc_type; do
        # Track highest scoring approval (I-797A only)
        if [[ "$doc_type" == "approval" ]] && [[ $score -gt $latest_approval_score ]]; then
            latest_approval_score=$score
            latest_approval="$file"
        fi
        
        # Track current year file (can be approval or receipt)
        if [[ "$file" =~ $current_year ]] && [[ $score -gt $score_current_year ]]; then
            score_current_year=$score
            file_current_year="$file"
        fi
    done < "$temp_file"
    
    # If no approval found, use any highest scoring I-797
    if [[ -z "$latest_approval" ]]; then
        latest_approval=$(sort -t'|' -k1 -nr "$temp_file" | head -1 | cut -d'|' -f2)
    fi
    
    # Create symlinks based on findings with clear A/C designation
    if [[ -n "$latest_approval" ]]; then
        # Always create the latest approval with I-797A designation
        create_symlink "$latest_approval" "$TARGET_DIR/$target_subdir" "H1B I-797A (Latest Approval).pdf"
    fi
    
    if [[ -n "$file_current_year" ]] && [[ "$file_current_year" != "$latest_approval" ]]; then
        # Current year file exists and is different from latest approval
        # Check if it's receipt or approval
        local current_basename=$(basename "$file_current_year")
        if [[ "$current_basename" =~ I-797C ]]; then
            create_symlink "$file_current_year" "$TARGET_DIR/$target_subdir" "H1B I-797C ($current_year Receipt).pdf"
        else
            create_symlink "$file_current_year" "$TARGET_DIR/$target_subdir" "H1B I-797A ($current_year Approval).pdf"
        fi
    fi
    
    rm -f "$temp_file"
}

# Function to process visa files
process_visa_files() {
    local visa_dir="$SOURCE_DIR/03 International Visas"
    local target_subdir="Immigration Status/Visas"
    
    echo -e "\n${BLUE}Processing: Visa files → $target_subdir${NC}"
    
    # US H-1B Visa
    local h1b_visa=$(find "$visa_dir/US" -type f -name "US Work Visa*" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if ! should_exclude "$file"; then
            echo "$(calculate_score "$file")|$file"
        fi
    done | sort -t'|' -k1 -nr | head -1 | cut -d'|' -f2-)
    
    if [[ -n "$h1b_visa" ]]; then
        create_symlink "$h1b_visa" "$TARGET_DIR/$target_subdir" "US H-1B.pdf"
    fi
    
    # US Tourist Visa
    local us_tourist=$(find "$visa_dir/US" -type f -name "US Visitor Visa*" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if ! should_exclude "$file"; then
            echo "$(calculate_score "$file")|$file"
        fi
    done | sort -t'|' -k1 -nr | head -1 | cut -d'|' -f2-)
    
    if [[ -n "$us_tourist" ]]; then
        create_symlink "$us_tourist" "$TARGET_DIR/$target_subdir" "US Tourist.pdf"
    fi
    
    # Canada Tourist Visa
    local canada_tourist=$(find "$visa_dir/Canada" -type f -name "*Visitor Visa*" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if ! should_exclude "$file"; then
            echo "$(calculate_score "$file")|$file"
        fi
    done | sort -t'|' -k1 -nr | head -1 | cut -d'|' -f2-)
    
    if [[ -n "$canada_tourist" ]]; then
        create_symlink "$canada_tourist" "$TARGET_DIR/$target_subdir" "Canada Tourist.pdf"
    fi
}

# Function to process standard files
process_standard_files() {
    local pattern="$1"
    local target_subdir="$2"
    local naming_function="$3"
    local search_path="${4:-$SOURCE_DIR}"
    
    echo -e "\n${BLUE}Processing: $pattern files → $target_subdir${NC}"
    
    local latest_file=$(find_latest_file "$pattern" "$search_path")
    
    if [[ -n "$latest_file" ]]; then
        local link_name=$($naming_function "$latest_file")
        create_symlink "$latest_file" "$TARGET_DIR/$target_subdir" "$link_name"
    else
        echo -e "${YELLOW}  No files found${NC}"
    fi
}

# Naming functions
name_latest() {
    local file="$1"
    local basename=$(basename "$file")
    local extension="${basename##*.}"
    local name="${basename%.*}"
    
    # Remove year from name if present
    name=$(echo "$name" | sed -E 's/ - (19|20)[0-9]{2}//g')
    
    echo "${name} Latest.${extension}"
}

name_as_is() {
    basename "$1"
}

name_simplified() {
    local file="$1"
    local basename=$(basename "$file")
    local extension="${basename##*.}"
    local name="${basename%.*}"
    
    # Simplify common patterns
    name=$(echo "$name" | sed -E 's/ - (Latest|LATEST)//gi')
    name=$(echo "$name" | sed -E 's/ - (19|20)[0-9]{2}//g')
    
    echo "${name}.${extension}"
}

# Process Immigration Documents
echo -e "\n${YELLOW}=== Processing Immigration Documents ===${NC}"

# Work Authorization - H1B with special handling
echo -e "\n${BLUE}Processing: H1B files → Immigration Status/Work Authorization${NC}"
process_h1b_files "Immigration Status/Work Authorization"

# Other Work Authorization docs - Skip EAD since it doesn't exist
process_standard_files "I-129 Petition" "Immigration Status/Work Authorization" "name_latest" "$SOURCE_DIR/02 US Immigration/Work Authorization"

# Permanent Residence
process_standard_files "I-140" "Immigration Status/Permanent Residence" "name_latest" "$SOURCE_DIR/02 US Immigration/Permanent Residence"
process_standard_files "PERM" "Immigration Status/Permanent Residence" "name_latest" "$SOURCE_DIR/02 US Immigration/Permanent Residence"

# Entry Records
process_standard_files "I-94" "Immigration Status/Entry Records" "name_as_is" "$SOURCE_DIR/02 US Immigration/Status Documents"
process_standard_files "I-20" "Immigration Status/Entry Records" "name_latest" "$SOURCE_DIR/02 US Immigration"
process_standard_files "DS-160" "Immigration Status/Entry Records" "name_latest" "$SOURCE_DIR/02 US Immigration"

# Visas from International Visas folder
process_visa_files

# Process Identity Documents
echo -e "\n${YELLOW}=== Processing Identity Documents ===${NC}"

# Birth Certificate
process_standard_files "Birth Certificate" "Identity & Travel" "name_simplified" "$SOURCE_DIR/01 Core Identity"

# Passports - look in Travel Docs for the specific files
echo -e "\n${BLUE}Processing: Passport files → Identity & Travel${NC}"
passport_latest=$(find "$SOURCE_DIR/01 Core Identity/Personal Documents/Travel Docs" -name "Passport - Latest.pdf" -type f 2>/dev/null | head -1)
if [[ -n "$passport_latest" ]]; then
    create_symlink "$passport_latest" "$TARGET_DIR/Identity & Travel" "Passport Latest.pdf"
else
    echo -e "${YELLOW}  Passport not found${NC}"
fi

# National IDs - Look in the correct location
echo -e "\n${BLUE}Processing: National ID files → Identity & Travel${NC}"

# Aadhaar Card
aadhaar=$(find "$SOURCE_DIR/01 Core Identity/Personal Documents/National ID Cards" -name "*Aadhaar Current.pdf" -type f 2>/dev/null | head -1)
if [[ -n "$aadhaar" ]]; then
    create_symlink "$aadhaar" "$TARGET_DIR/Identity & Travel" "Aadhaar Card.pdf"
else
    echo -e "${YELLOW}  Aadhaar not found${NC}"
fi

# PAN Card
pan=$(find "$SOURCE_DIR/01 Core Identity/Personal Documents/National ID Cards" -name "PAN Card*" -type f 2>/dev/null | head -1)
if [[ -n "$pan" ]]; then
    create_symlink "$pan" "$TARGET_DIR/Identity & Travel" "PAN Card.pdf"
else
    echo -e "${YELLOW}  PAN not found${NC}"
fi

# Driving Licenses - Look in the correct locations
echo -e "\n${BLUE}Processing: Driving License files → Identity & Travel${NC}"

# India Driving License
india_dl=$(find "$SOURCE_DIR/01 Core Identity/Personal Documents/National ID Cards" -name "India Driving License*" -type f 2>/dev/null | head -1)
if [[ -n "$india_dl" ]]; then
    create_symlink "$india_dl" "$TARGET_DIR/Identity & Travel" "India Driving License.pdf"
else
    echo -e "${YELLOW}  India Driving License not found${NC}"
fi

# US Driving License
us_dl=$(find "$SOURCE_DIR/01 Core Identity/Personal Documents" -name "US Driving License.pdf" -type f 2>/dev/null | head -1)
if [[ -n "$us_dl" ]]; then
    create_symlink "$us_dl" "$TARGET_DIR/Identity & Travel" "US Driving License.pdf"
else
    echo -e "${YELLOW}  US Driving License not found${NC}"
fi

# Process Medical Documents
echo -e "\n${YELLOW}=== Processing Medical Documents ===${NC}"

process_standard_files "Covid Vaccine" "Medical Emergency" "name_simplified" "$SOURCE_DIR/06 US Documents/Medical Records"
process_standard_files "Insurance Card" "Medical Emergency" "name_simplified" "$SOURCE_DIR/06 US Documents"
process_standard_files "Blood Group" "Medical Emergency" "name_simplified" "$SOURCE_DIR"

# Process Insurance Documents
echo -e "\n${YELLOW}=== Processing Insurance Documents ===${NC}"

process_standard_files "Health Insurance" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"
process_standard_files "Aetna PPO" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"
process_standard_files "Auto Insurance Progressive" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"
process_standard_files "Renters Insurance" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"
process_standard_files "Life Insurance" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"
process_standard_files "Disability Insurance" "Insurance" "name_latest" "$SOURCE_DIR/06 US Documents/Insurance"

# Generate README
echo -e "\n${YELLOW}=== Generating README ===${NC}"

cat > "$TARGET_DIR/README.md" << EOF
# Emergency Access Directory

This directory contains symlinks to critical documents for emergency access.
Generated on: $(date)

## Directory Structure

### Immigration Status
- **Work Authorization**: H1B approvals (I-797), I-129, EAD
- **Permanent Residence**: I-140, PERM documents
- **Entry Records**: I-94 travel records, I-20, DS-160
- **Visas**: Passport visa stamps (US H-1B, US Tourist, Canada Tourist)

### Identity & Travel
- Birth certificate
- Passports (India, US)
- National ID cards (Aadhaar, PAN)
- Driving licenses (India, Georgia)

### Medical Emergency
- COVID vaccination records
- Insurance cards
- Blood group information

### Insurance
- Health insurance policies
- Auto insurance
- Home/renters insurance
- Life insurance
- Disability insurance

## Important Notes

1. These are symbolic links to original documents
2. Directory is regenerated each time script runs
3. Always verify document validity before use
4. Keep original documents secure

## Emergency Contacts

Add your emergency contacts here:
- Primary Contact: [Name] [Phone]
- Secondary Contact: [Name] [Phone]
- Insurance Agent: [Name] [Phone]
- Immigration Attorney: [Name] [Phone]

---
*This directory is automatically maintained. Do not edit manually.*
EOF

# Summary
echo -e "\n${GREEN}=== Summary ===${NC}"
echo "Emergency access directory created at: $TARGET_DIR"
echo "Total symlinks created: $(find "$TARGET_DIR" -type l | wc -l | tr -d ' ')"
echo
echo -e "${BLUE}Directory structure:${NC}"
tree -L 3 "$TARGET_DIR" 2>/dev/null || find "$TARGET_DIR" -type d | sort

echo -e "\n${GREEN}✓ Emergency access setup complete!${NC}"

# Clean up any temp files
rm -f /tmp/emergency_*_temp.txt
