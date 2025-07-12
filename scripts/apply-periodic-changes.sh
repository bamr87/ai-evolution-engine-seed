#!/bin/bash
#
# @file apply-periodic-changes.sh
# @description Apply changes from periodic AI evolution prompt responses
# @author AI Evolution Engine <ai-evolution@engine.dev>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - #TBD: Periodic change application automation
#
# @relatedEvolutions
#   - v1.0.0: Initial periodic change application implementation
#
# @dependencies
#   - bash: >=4.0
#   - jq: JSON processing
#   - AI Evolution Engine: >=0.4.3
#
# @changelog
#   - 2025-07-12: Initial creation of periodic change application script - AEE
#
# @usage ./apply-periodic-changes.sh --prompt-name <name> [options]
# @notes Processes AI responses and applies file changes safely
#

set -euo pipefail

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOGS_DIR="$REPO_ROOT/logs"

# Source common utilities
source "$REPO_ROOT/src/lib/core/logger.sh" 2>/dev/null || {
    echo "Warning: Logger not available, using basic logging"
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
    log_warning() { echo "[WARNING] $*" >&2; }
}

# Default values
PROMPT_NAME=""
CREATE_PR="false"
BACKUP_DIR=""
RESPONSE_FILE=""
VALIDATE_ONLY="false"

# Function to display usage
usage() {
    cat << EOF
Usage: $0 --prompt-name <name> [options]

Apply changes from periodic AI evolution prompt responses.

Options:
    --prompt-name <name>     Name of the prompt that generated the changes (required)
    --create-pr <true|false> Create a pull request for changes (default: false)
    --response-file <file>   AI response file (default: auto-detect latest)
    --backup-dir <dir>       Directory for file backups (default: auto-generated)
    --validate-only          Only validate changes without applying them
    --help                   Show this help message

Examples:
    $0 --prompt-name doc_harmonization --create-pr true
    $0 --prompt-name security_scan --validate-only
    $0 --prompt-name code_refactor --backup-dir ./backups

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --prompt-name)
            PROMPT_NAME="$2"
            shift 2
            ;;
        --create-pr)
            CREATE_PR="$2"
            shift 2
            ;;
        --response-file)
            RESPONSE_FILE="$2"
            shift 2
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        --validate-only)
            VALIDATE_ONLY="true"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [[ -z "$PROMPT_NAME" ]]; then
    log_error "Prompt name is required"
    usage
    exit 1
fi

# Auto-detect response file if not specified
if [[ -z "$RESPONSE_FILE" ]]; then
    RESPONSE_FILE=$(find "$LOGS_DIR" -name "periodic_evolution_${PROMPT_NAME}_*.json" -type f | sort -r | head -1)
    if [[ -z "$RESPONSE_FILE" ]]; then
        log_error "No response file found for prompt: $PROMPT_NAME"
        exit 1
    fi
fi

# Validate response file exists
if [[ ! -f "$RESPONSE_FILE" ]]; then
    log_error "Response file not found: $RESPONSE_FILE"
    exit 1
fi

# Setup backup directory if not specified
if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$LOGS_DIR/backups/periodic_${PROMPT_NAME}_$(date +%Y%m%d_%H%M%S)"
fi

log_info "Starting periodic change application"
log_info "Prompt: $PROMPT_NAME"
log_info "Response file: $RESPONSE_FILE"
log_info "Backup directory: $BACKUP_DIR"
log_info "Validate only: $VALIDATE_ONLY"
log_info "Create PR: $CREATE_PR"

# Function to validate JSON response structure
validate_response_structure() {
    local response_file="$1"
    
    log_info "Validating response structure..."
    
    # Check if it's valid JSON
    if ! jq empty "$response_file" 2>/dev/null; then
        log_error "Response file is not valid JSON"
        return 1
    fi
    
    # Check for expected structure
    local has_file_changes=$(jq 'has("file_changes")' "$response_file")
    local has_metrics=$(jq 'has("metrics")' "$response_file")
    
    if [[ "$has_file_changes" != "true" ]]; then
        log_warning "Response does not contain file_changes array"
    fi
    
    if [[ "$has_metrics" != "true" ]]; then
        log_warning "Response does not contain metrics object"
    fi
    
    log_info "Response structure validation completed"
    return 0
}

# Function to validate file changes
validate_file_changes() {
    local response_file="$1"
    
    log_info "Validating file changes..."
    
    local changes_count=$(jq '.file_changes | length' "$response_file" 2>/dev/null || echo "0")
    log_info "Found $changes_count file changes to validate"
    
    if [[ "$changes_count" == "0" ]]; then
        log_info "No file changes to validate"
        return 0
    fi
    
    # Validate each file change
    local i=0
    while [[ $i -lt $changes_count ]]; do
        local path=$(jq -r ".file_changes[$i].path" "$response_file")
        local action=$(jq -r ".file_changes[$i].action" "$response_file")
        local content=$(jq -r ".file_changes[$i].content" "$response_file")
        
        log_info "Validating change $((i+1))/$changes_count: $action $path"
        
        # Validate path
        if [[ "$path" == "null" || -z "$path" ]]; then
            log_error "Invalid file path in change $((i+1))"
            return 1
        fi
        
        # Validate action
        case "$action" in
            "create"|"update"|"delete")
                # Valid actions
                ;;
            *)
                log_error "Invalid action '$action' in change $((i+1))"
                return 1
                ;;
        esac
        
        # Validate content for create/update actions
        if [[ "$action" == "create" || "$action" == "update" ]]; then
            if [[ "$content" == "null" || -z "$content" ]]; then
                log_warning "Empty content for $action action on $path"
            fi
        fi
        
        # Check if file exists for update/delete actions
        if [[ "$action" == "update" || "$action" == "delete" ]]; then
            if [[ ! -f "$REPO_ROOT/$path" ]]; then
                log_warning "File does not exist for $action action: $path"
            fi
        fi
        
        # Check if file already exists for create action
        if [[ "$action" == "create" && -f "$REPO_ROOT/$path" ]]; then
            log_warning "File already exists for create action: $path"
        fi
        
        ((i++))
    done
    
    log_info "File changes validation completed"
    return 0
}

# Function to backup existing files
backup_files() {
    local response_file="$1"
    local backup_dir="$2"
    
    log_info "Creating backups of existing files..."
    
    mkdir -p "$backup_dir"
    
    local changes_count=$(jq '.file_changes | length' "$response_file" 2>/dev/null || echo "0")
    
    if [[ "$changes_count" == "0" ]]; then
        log_info "No files to backup"
        return 0
    fi
    
    local i=0
    while [[ $i -lt $changes_count ]]; do
        local path=$(jq -r ".file_changes[$i].path" "$response_file")
        local action=$(jq -r ".file_changes[$i].action" "$response_file")
        
        # Only backup for update/delete actions on existing files
        if [[ ("$action" == "update" || "$action" == "delete") && -f "$REPO_ROOT/$path" ]]; then
            local backup_path="$backup_dir/$path"
            local backup_parent=$(dirname "$backup_path")
            
            mkdir -p "$backup_parent"
            cp "$REPO_ROOT/$path" "$backup_path"
            log_info "Backed up: $path -> $backup_path"
        fi
        
        ((i++))
    done
    
    log_info "File backup completed"
    return 0
}

# Function to apply file changes
apply_file_changes() {
    local response_file="$1"
    
    log_info "Applying file changes..."
    
    local changes_count=$(jq '.file_changes | length' "$response_file" 2>/dev/null || echo "0")
    log_info "Applying $changes_count file changes"
    
    if [[ "$changes_count" == "0" ]]; then
        log_info "No file changes to apply"
        return 0
    fi
    
    local applied_count=0
    local failed_count=0
    
    local i=0
    while [[ $i -lt $changes_count ]]; do
        local path=$(jq -r ".file_changes[$i].path" "$response_file")
        local action=$(jq -r ".file_changes[$i].action" "$response_file")
        local content=$(jq -r ".file_changes[$i].content" "$response_file")
        
        log_info "Applying change $((i+1))/$changes_count: $action $path"
        
        case "$action" in
            "create")
                local file_dir=$(dirname "$REPO_ROOT/$path")
                mkdir -p "$file_dir"
                echo "$content" > "$REPO_ROOT/$path"
                log_info "Created file: $path"
                ((applied_count++))
                ;;
            "update")
                if [[ -f "$REPO_ROOT/$path" ]]; then
                    echo "$content" > "$REPO_ROOT/$path"
                    log_info "Updated file: $path"
                    ((applied_count++))
                else
                    log_error "Cannot update non-existent file: $path"
                    ((failed_count++))
                fi
                ;;
            "delete")
                if [[ -f "$REPO_ROOT/$path" ]]; then
                    rm "$REPO_ROOT/$path"
                    log_info "Deleted file: $path"
                    ((applied_count++))
                else
                    log_warning "File already deleted or does not exist: $path"
                    ((applied_count++))
                fi
                ;;
            *)
                log_error "Unknown action: $action"
                ((failed_count++))
                ;;
        esac
        
        ((i++))
    done
    
    log_info "File changes applied: $applied_count successful, $failed_count failed"
    
    if [[ $failed_count -gt 0 ]]; then
        return 1
    fi
    
    return 0
}

# Function to validate applied changes
validate_applied_changes() {
    log_info "Validating applied changes..."
    
    # Check git status
    local modified_files=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    log_info "Git reports $modified_files modified files"
    
    # Run basic syntax checks on common file types
    local syntax_errors=0
    
    # Check JSON files
    for json_file in $(git diff --name-only --diff-filter=AM 2>/dev/null | grep '\.json$' || true); do
        if [[ -f "$json_file" ]]; then
            if ! jq empty "$json_file" 2>/dev/null; then
                log_error "JSON syntax error in: $json_file"
                ((syntax_errors++))
            fi
        fi
    done
    
    # Check YAML files
    for yaml_file in $(git diff --name-only --diff-filter=AM 2>/dev/null | grep -E '\.(yml|yaml)$' || true); do
        if [[ -f "$yaml_file" ]]; then
            if command -v yamllint >/dev/null 2>&1; then
                if ! yamllint "$yaml_file" >/dev/null 2>&1; then
                    log_warning "YAML syntax issues in: $yaml_file"
                fi
            fi
        fi
    done
    
    if [[ $syntax_errors -gt 0 ]]; then
        log_error "Syntax errors detected in applied changes"
        return 1
    fi
    
    log_info "Applied changes validation completed"
    return 0
}

# Function to create summary report
create_summary_report() {
    local response_file="$1"
    local backup_dir="$2"
    
    local summary_file="$LOGS_DIR/periodic_changes_summary_${PROMPT_NAME}_$(date +%Y%m%d_%H%M%S).md"
    
    log_info "Creating summary report: $summary_file"
    
    cat > "$summary_file" << EOF
# Periodic Evolution Changes Summary

## Execution Details
- **Prompt**: $PROMPT_NAME
- **Timestamp**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
- **Response File**: $RESPONSE_FILE
- **Backup Directory**: $backup_dir
- **Validation Only**: $VALIDATE_ONLY

## Changes Applied
$(jq -r '.file_changes[]? | "- \(.action | ascii_upcase): \(.path)"' "$response_file" 2>/dev/null || echo "No file changes found")

## Metrics
$(jq -r '.metrics // {} | to_entries[]? | "- **\(.key)**: \(.value)"' "$response_file" 2>/dev/null || echo "No metrics available")

## Impact Assessment
$(jq -r '.impact_assessment // {} | to_entries[]? | "- **\(.key)**: \(.value)"' "$response_file" 2>/dev/null || echo "No impact assessment available")

## Git Status
\`\`\`
$(git status --porcelain 2>/dev/null || echo "Git status unavailable")
\`\`\`

## Next Steps
- Review applied changes
- Run tests to validate functionality
- Create pull request if changes are satisfactory
- Monitor for any issues or regressions

EOF

    log_info "Summary report created: $summary_file"
    
    # Set output for GitHub Actions
    if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
        echo "summary_file=$summary_file" >> "$GITHUB_OUTPUT"
    fi
}

# Main execution
main() {
    log_info "=== Periodic Change Application Started ==="
    
    # Validate response structure
    if ! validate_response_structure "$RESPONSE_FILE"; then
        log_error "Response structure validation failed"
        exit 1
    fi
    
    # Validate file changes
    if ! validate_file_changes "$RESPONSE_FILE"; then
        log_error "File changes validation failed"
        exit 1
    fi
    
    if [[ "$VALIDATE_ONLY" == "true" ]]; then
        log_info "Validation only mode - changes not applied"
        log_info "=== Validation Completed Successfully ==="
        return 0
    fi
    
    # Create backups
    if ! backup_files "$RESPONSE_FILE" "$BACKUP_DIR"; then
        log_error "File backup failed"
        exit 1
    fi
    
    # Apply file changes
    if ! apply_file_changes "$RESPONSE_FILE"; then
        log_error "File changes application failed"
        log_error "Backups available at: $BACKUP_DIR"
        exit 1
    fi
    
    # Validate applied changes
    if ! validate_applied_changes; then
        log_error "Applied changes validation failed"
        log_error "Consider reverting from backups at: $BACKUP_DIR"
        exit 1
    fi
    
    # Create summary report
    create_summary_report "$RESPONSE_FILE" "$BACKUP_DIR"
    
    log_info "=== Periodic Change Application Completed Successfully ==="
    log_info "Backups available at: $BACKUP_DIR"
    
    if [[ "$CREATE_PR" == "true" ]]; then
        log_info "Creating pull request for applied changes..."
        # This would be handled by the workflow calling create_pr.sh
    fi
}

# Execute main function
main "$@"
