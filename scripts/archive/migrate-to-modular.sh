#!/bin/bash
#
# @file scripts/migrate-to-modular.sh
# @description Migration helper script to convert existing scripts to use modular library
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Migration helper for modular library adoption
#
# @dependencies
#   - bash: >=4.0
#   - sed: For text processing
#
# @changelog
#   - 2025-07-05: Initial creation of migration script - ITJ
#
# @usage ./migrate-to-modular.sh <script_file> [--dry-run]
# @notes Helps migrate existing scripts to use the new modular library system
#

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Migration patterns
declare -A OLD_PATTERNS
declare -A NEW_PATTERNS

# Initialize migration patterns
init_migration_patterns() {
    # Direct source patterns to modular bootstrap
    OLD_PATTERNS[source_logger]='source.*src/lib/core/logger\.sh'
    NEW_PATTERNS[source_logger]='# Bootstrap the modular library system\nsource "$PROJECT_ROOT/src/lib/core/bootstrap.sh"\nbootstrap_library\n\n# Load required modules\nrequire_module "core/logger"'
    
    OLD_PATTERNS[source_environment]='source.*src/lib/core/environment\.sh'
    NEW_PATTERNS[source_environment]='require_module "core/environment"'
    
    OLD_PATTERNS[source_git]='source.*src/lib/evolution/git\.sh'
    NEW_PATTERNS[source_git]='require_module "evolution/git"'
    
    OLD_PATTERNS[source_metrics]='source.*src/lib/evolution/metrics\.sh'
    NEW_PATTERNS[source_metrics]='require_module "evolution/metrics"'
    
    # Function call patterns
    OLD_PATTERNS[command_check]='command -v [a-zA-Z_]+ >/dev/null 2>&1'
    NEW_PATTERNS[command_check]='check_command "COMMAND_NAME"'
    
    OLD_PATTERNS[git_check]='git rev-parse --git-dir >/dev/null 2>&1'
    NEW_PATTERNS[git_check]='check_git_repository'
    
    # Error handling patterns
    OLD_PATTERNS[simple_exit]='echo.*error.*exit 1'
    NEW_PATTERNS[simple_exit]='log_error "ERROR_MESSAGE"\nexit 1'
}

# Show help message
show_help() {
    cat << EOF
🔄 AI Evolution Engine - Modular Library Migration Tool

USAGE:
    $0 <script_file> [OPTIONS]

OPTIONS:
    --dry-run, -d    Show what would be changed without making changes
    --backup, -b     Create a backup of the original file
    --force, -f      Force migration even if file appears already migrated
    --help, -h       Show this help message

DESCRIPTION:
    This tool helps migrate existing scripts to use the new modular library system.
    It automatically updates import patterns, function calls, and error handling
    to use the new modular approach.

EXAMPLES:
    $0 scripts/my-script.sh                    # Migrate script in-place
    $0 scripts/my-script.sh --dry-run          # Preview changes only
    $0 scripts/my-script.sh --backup           # Create backup before migration
    $0 scripts/my-script.sh --dry-run --backup # Preview and backup

MIGRATION CHANGES:
    - Replaces direct source statements with bootstrap + require_module calls
    - Updates function calls to use modular equivalents
    - Improves error handling with modular logger
    - Adds proper module dependencies
    - Updates file headers with modular standards
EOF
}

# Check if file appears to be already migrated
is_already_migrated() {
    local file="$1"
    
    if grep -q "bootstrap_library" "$file" 2>/dev/null; then
        return 0  # Already migrated
    fi
    
    if grep -q "require_module" "$file" 2>/dev/null; then
        return 0  # Already migrated
    fi
    
    return 1  # Not migrated
}

# Create backup of file
create_backup() {
    local file="$1"
    local backup_file="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    cp "$file" "$backup_file"
    echo -e "${GREEN}✅ Backup created: $backup_file${NC}"
}

# Add or update file header
update_file_header() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Check if file already has a modular header
    if grep -q "@file.*$file" "$file" 2>/dev/null; then
        echo -e "${BLUE}ℹ️  File header already exists, skipping header update${NC}"
        return 0
    fi
    
    # Extract shebang if it exists
    local shebang=""
    if head -n1 "$file" | grep -q "^#!"; then
        shebang=$(head -n1 "$file")
    fi
    
    # Generate new header
    local filename
    filename=$(basename "$file")
    
    cat > "$temp_file" << EOF
$shebang
#
# @file scripts/$filename
# @description DESCRIPTION_TO_BE_UPDATED
# @author IT-Journey Team <team@it-journey.org>
# @created $(date +%Y-%m-%d)
# @lastModified $(date +%Y-%m-%d)
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Migrated to use modular library system
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#
# @changelog
#   - $(date +%Y-%m-%d): Migrated to modular library system - ITJ
#
# @usage ./$filename [arguments]
# @notes USAGE_NOTES_TO_BE_UPDATED
#

EOF
    
    # Append rest of file (skip shebang if it exists)
    if [[ -n "$shebang" ]]; then
        tail -n +2 "$file" >> "$temp_file"
    else
        cat "$file" >> "$temp_file"
    fi
    
    mv "$temp_file" "$file"
    echo -e "${GREEN}✅ File header updated${NC}"
}

# Update imports to use modular system
update_imports() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    echo -e "${BLUE}🔄 Updating import statements...${NC}"
    
    # First, add bootstrap if not present
    if ! grep -q "bootstrap_library" "$file"; then
        # Find location to insert bootstrap (after shebang and before first source)
        local insert_line
        insert_line=$(grep -n "^source\|^[[:space:]]*source" "$file" | head -n1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            # Insert bootstrap before first source
            sed "${insert_line}i\\
\\
# Get script directory for relative imports\\
SCRIPT_DIR=\"\$(cd \"\$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"\\
PROJECT_ROOT=\"\$(cd \"\${SCRIPT_DIR}/..\" && pwd)\"\\
\\
# Bootstrap the modular library system\\
source \"\$PROJECT_ROOT/src/lib/core/bootstrap.sh\"\\
bootstrap_library\\
\\
# Load required modules" "$file" > "$temp_file"
            mv "$temp_file" "$file"
        fi
    fi
    
    # Replace old source patterns
    sed -i.bak \
        -e 's|source.*src/lib/core/logger\.sh|require_module "core/logger"|g' \
        -e 's|source.*src/lib/core/environment\.sh|require_module "core/environment"|g' \
        -e 's|source.*src/lib/evolution/git\.sh|require_module "evolution/git"|g' \
        -e 's|source.*src/lib/evolution/metrics\.sh|require_module "evolution/metrics"|g' \
        -e 's|source.*src/lib/core/config\.sh|require_module "core/config"|g' \
        -e 's|source.*src/lib/core/utils\.sh|require_module "core/utils"|g' \
        -e 's|source.*src/lib/core/validation\.sh|require_module "core/validation"|g' \
        "$file"
    
    rm -f "${file}.bak"
    echo -e "${GREEN}✅ Import statements updated${NC}"
}

# Update function calls to use modular equivalents
update_function_calls() {
    local file="$1"
    
    echo -e "${BLUE}🔄 Updating function calls...${NC}"
    
    # Update command checks
    sed -i.bak \
        -e 's|command -v \([a-zA-Z_][a-zA-Z0-9_]*\) >/dev/null 2>&1|check_command "\1"|g' \
        "$file"
    
    # Update git repository checks
    sed -i.bak2 \
        -e 's|git rev-parse --git-dir >/dev/null 2>&1|check_git_repository|g' \
        "$file"
    
    # Update error handling
    sed -i.bak3 \
        -e 's|echo "Error:|log_error "|g' \
        -e 's|echo "WARNING:|log_warn "|g' \
        -e 's|echo "INFO:|log_info "|g' \
        "$file"
    
    rm -f "${file}.bak" "${file}.bak2" "${file}.bak3"
    echo -e "${GREEN}✅ Function calls updated${NC}"
}

# Add module initialization if needed
add_module_initialization() {
    local file="$1"
    
    echo -e "${BLUE}🔄 Adding module initialization...${NC}"
    
    # Check if logger initialization exists
    if ! grep -q "init_logger" "$file"; then
        # Find a good place to add logger init (after require_module calls)
        local insert_line
        insert_line=$(grep -n "require_module" "$file" | tail -n1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            # Insert after last require_module call
            local next_line=$((insert_line + 1))
            sed "${next_line}i\\
\\
# Initialize logging\\
init_logger \"logs\" \"$(basename "$file" .sh)\"" "$file" > "${file}.tmp"
            mv "${file}.tmp" "$file"
        fi
    fi
    
    echo -e "${GREEN}✅ Module initialization added${NC}"
}

# Validate migrated script
validate_migration() {
    local file="$1"
    
    echo -e "${BLUE}🔍 Validating migration...${NC}"
    
    local issues=0
    
    # Check for bootstrap
    if ! grep -q "bootstrap_library" "$file"; then
        echo -e "${RED}❌ Missing bootstrap_library call${NC}"
        ((issues++))
    fi
    
    # Check for old source patterns
    if grep -q "source.*src/lib" "$file"; then
        echo -e "${YELLOW}⚠️  Old source patterns still present${NC}"
        ((issues++))
    fi
    
    # Check syntax
    if ! bash -n "$file" 2>/dev/null; then
        echo -e "${RED}❌ Syntax errors detected${NC}"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        echo -e "${GREEN}✅ Migration validation passed${NC}"
        return 0
    else
        echo -e "${RED}❌ Migration validation failed with $issues issues${NC}"
        return 1
    fi
}

# Show migration preview
show_preview() {
    local file="$1"
    
    echo -e "${BLUE}🔍 Migration Preview for: $file${NC}"
    echo "=================================="
    
    # Show old source patterns that would be changed
    echo -e "${YELLOW}Old source patterns to be updated:${NC}"
    grep -n "source.*src/lib" "$file" 2>/dev/null || echo "  None found"
    
    echo ""
    echo -e "${YELLOW}Command checks to be updated:${NC}"
    grep -n "command -v.*>/dev/null" "$file" 2>/dev/null || echo "  None found"
    
    echo ""
    echo -e "${YELLOW}Git checks to be updated:${NC}"
    grep -n "git rev-parse --git-dir" "$file" 2>/dev/null || echo "  None found"
    
    echo ""
    echo -e "${YELLOW}Error handling to be updated:${NC}"
    grep -n 'echo.*"Error:\|echo.*"WARNING:\|echo.*"INFO:' "$file" 2>/dev/null || echo "  None found"
    
    echo "=================================="
}

# Main migration function
migrate_script() {
    local file="$1"
    local dry_run="${2:-false}"
    local create_backup_flag="${3:-false}"
    local force="${4:-false}"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}❌ File not found: $file${NC}"
        return 1
    fi
    
    echo -e "${GREEN}🚀 Starting migration for: $file${NC}"
    
    # Check if already migrated
    if is_already_migrated "$file" && [[ "$force" != "true" ]]; then
        echo -e "${YELLOW}⚠️  File appears to already be migrated${NC}"
        echo -e "${BLUE}ℹ️  Use --force to migrate anyway${NC}"
        return 0
    fi
    
    # Show preview if dry run
    if [[ "$dry_run" == "true" ]]; then
        show_preview "$file"
        return 0
    fi
    
    # Create backup if requested
    if [[ "$create_backup_flag" == "true" ]]; then
        create_backup "$file"
    fi
    
    # Perform migration steps
    update_file_header "$file"
    update_imports "$file"
    update_function_calls "$file"
    add_module_initialization "$file"
    
    # Validate migration
    if validate_migration "$file"; then
        echo -e "${GREEN}✅ Migration completed successfully${NC}"
    else
        echo -e "${RED}❌ Migration completed with issues${NC}"
        return 1
    fi
}

# Main execution
main() {
    local script_file=""
    local dry_run="false"
    local create_backup_flag="false"
    local force="false"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-d)
                dry_run="true"
                shift
                ;;
            --backup|-b)
                create_backup_flag="true"
                shift
                ;;
            --force|-f)
                force="true"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            -*)
                echo -e "${RED}❌ Unknown option: $1${NC}"
                echo "Use --help for usage information"
                exit 1
                ;;
            *)
                if [[ -z "$script_file" ]]; then
                    script_file="$1"
                else
                    echo -e "${RED}❌ Multiple script files not supported${NC}"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate arguments
    if [[ -z "$script_file" ]]; then
        echo -e "${RED}❌ Script file argument required${NC}"
        echo "Use --help for usage information"
        exit 1
    fi
    
    # Initialize migration patterns
    init_migration_patterns
    
    # Perform migration
    migrate_script "$script_file" "$dry_run" "$create_backup_flag" "$force"
}

# Execute main function
main "$@"
