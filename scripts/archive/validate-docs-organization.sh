#!/bin/bash
#
# @file validate-docs-organization.sh
# @description Validates that all non-README markdown files are in docs/ directory and every directory has a README.md
# @author AI Evolution Engine <ai@evolution-engine.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - Documentation organization enforcement
#   - Mandatory README.md validation
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation of docs organization validation
#
# @dependencies
#   - bash: >=4.0
#   - find: standard UNIX utility
#
# @changelog
#   - 2025-07-12: Initial creation with comprehensive validation logic - AEE
#
# @usage ./scripts/validate-docs-organization.sh
# @notes Run after every AI prompt cycle to enforce organization rules
#

set -euo pipefail

# Override to allow script to continue on errors in this validation context
set +e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}🔍 Validating Documentation Organization${NC}"
echo "Repository: $REPO_ROOT"
echo "=========================================="

# Track validation results
VALIDATION_ERRORS=0
WARNINGS=0

# Function to log errors
log_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ((VALIDATION_ERRORS++))
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    ((WARNINGS++))
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to log info
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo -e "\n${BLUE}1. Checking for misplaced markdown files...${NC}"

# Find all markdown files that are NOT README.md or CHANGELOG.md
MISPLACED_FILES=()

# Find all .md files in the repository
while IFS= read -r -d '' file; do
    # Convert to relative path
    rel_path="${file#$REPO_ROOT/}"
    
    # Skip files in docs/ directory
    if [[ "$rel_path" == docs/* ]]; then
        continue
    fi
    
    # Skip README.md files (allowed in any directory)
    if [[ "$(basename "$file")" == "README.md" ]]; then
        continue
    fi
    
    # Skip CHANGELOG.md in repository root only
    if [[ "$rel_path" == "CHANGELOG.md" ]]; then
        continue
    fi
    
    # Skip hidden directories and files
    if [[ "$rel_path" == .* ]] || [[ "$rel_path" == */.* ]]; then
        continue
    fi
    
    # Skip _site directory (Jekyll build output)
    if [[ "$rel_path" == _site/* ]]; then
        continue
    fi
    
    # Skip node_modules and other build directories
    if [[ "$rel_path" == node_modules/* ]] || [[ "$rel_path" == build/* ]] || [[ "$rel_path" == dist/* ]]; then
        continue
    fi
    
    # This is a misplaced markdown file
    MISPLACED_FILES+=("$rel_path")
    log_error "Markdown file found outside docs/: $rel_path"
    
done < <(find "$REPO_ROOT" -name "*.md" -type f -print0)

if [[ ${#MISPLACED_FILES[@]} -eq 0 ]]; then
    log_success "All markdown files are properly organized"
else
    echo -e "\n${RED}📁 Files that should be moved to docs/:${NC}"
    for file in "${MISPLACED_FILES[@]}"; do
        echo "  - $file"
    done
fi

echo -e "\n${BLUE}2. Checking for missing README.md files...${NC}"

# Find all directories and check for README.md
MISSING_README_DIRS=()

while IFS= read -r -d '' dir; do
    # Convert to relative path
    rel_dir="${dir#$REPO_ROOT/}"
    
    # Skip hidden directories
    if [[ "$rel_dir" == .* ]] || [[ "$rel_dir" == */.* ]]; then
        continue
    fi
    
    # Skip build/output directories
    if [[ "$rel_dir" == _site* ]] || [[ "$rel_dir" == node_modules* ]] || [[ "$rel_dir" == build* ]] || [[ "$rel_dir" == dist* ]]; then
        continue
    fi
    
    # Skip empty directories or directories with only hidden files
    if [[ ! "$(ls -A "$dir" 2>/dev/null | grep -v '^\.')" ]]; then
        continue
    fi
    
    # Check if README.md exists in this directory
    if [[ ! -f "$dir/README.md" ]]; then
        MISSING_README_DIRS+=("$rel_dir")
        log_error "Missing README.md in directory: $rel_dir"
    fi
    
done < <(find "$REPO_ROOT" -type d -print0)

if [[ ${#MISSING_README_DIRS[@]} -eq 0 ]]; then
    log_success "All directories have README.md files"
else
    echo -e "\n${RED}📂 Directories missing README.md:${NC}"
    for dir in "${MISSING_README_DIRS[@]}"; do
        echo "  - $dir/"
    done
fi

echo -e "\n${BLUE}3. Checking docs/ directory structure...${NC}"

# Check if docs directory exists
if [[ ! -d "$REPO_ROOT/docs" ]]; then
    log_warning "docs/ directory does not exist"
else
    log_success "docs/ directory exists"
    
    # Count markdown files in docs
    DOCS_MD_COUNT=$(find "$REPO_ROOT/docs" -name "*.md" -type f | wc -l)
    log_info "Found $DOCS_MD_COUNT markdown files in docs/ directory"
    
    # Check for common subdirectories
    EXPECTED_SUBDIRS=("guides" "api" "architecture" "evolution" "reports")
    for subdir in "${EXPECTED_SUBDIRS[@]}"; do
        if [[ -d "$REPO_ROOT/docs/$subdir" ]]; then
            log_info "Found recommended subdirectory: docs/$subdir/"
        fi
    done
fi

echo -e "\n${BLUE}4. Validation Summary${NC}"
echo "===================="

if [[ $VALIDATION_ERRORS -eq 0 ]]; then
    log_success "All documentation organization rules are satisfied!"
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}Note: $WARNINGS warning(s) found${NC}"
    fi
    exit 0
else
    echo -e "${RED}Found $VALIDATION_ERRORS error(s) that must be fixed:${NC}"
    echo ""
    echo "Required actions:"
    
    if [[ ${#MISPLACED_FILES[@]} -gt 0 ]]; then
        echo "1. Move the following files to docs/ subdirectories:"
        for file in "${MISPLACED_FILES[@]}"; do
            # Suggest appropriate docs subdirectory based on filename
            suggested_dir="docs/"
            case "$file" in
                *guide*|*tutorial*|*howto*) suggested_dir="docs/guides/" ;;
                *api*|*reference*) suggested_dir="docs/api/" ;;
                *architecture*|*design*) suggested_dir="docs/architecture/" ;;
                *evolution*|*changelog*|*history*) suggested_dir="docs/evolution/" ;;
                *report*|*analysis*) suggested_dir="docs/reports/" ;;
                *) suggested_dir="docs/misc/" ;;
            esac
            echo "   mv $file $suggested_dir$(basename "$file")"
        done
        echo ""
    fi
    
    if [[ ${#MISSING_README_DIRS[@]} -gt 0 ]]; then
        echo "2. Create README.md files in the following directories:"
        for dir in "${MISSING_README_DIRS[@]}"; do
            echo "   touch $dir/README.md"
        done
        echo ""
    fi
    
    echo "After making these changes, run this script again to verify compliance."
    exit 1
fi
