#!/usr/bin/env bash
#
# @file scripts/validate-evolution.sh
# @description Validates evolution results and changes before applying
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - Missing validation script for evolution workflow
#
# @relatedEvolutions
#   - v1.0.0: Initial creation for evolution validation
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#   - src/lib/core/validation.sh: Validation functions
#
# @changelog
#   - 2025-07-12: Initial creation for evolution validation - ITJ
#
# @usage ./validate-evolution.sh [--response-file FILE] [--growth-mode MODE]
# @notes Validates evolution responses and code changes
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/validation"
require_module "utils/json_processor"

# Initialize logging
init_logger "logs" "validate-evolution"

# Parse command line arguments
RESPONSE_FILE=""
GROWTH_MODE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --response-file)
            RESPONSE_FILE="$2"
            shift 2
            ;;
        --growth-mode)
            GROWTH_MODE="$2"
            shift 2
            ;;
        *)
            if [[ -z "$RESPONSE_FILE" ]]; then
                RESPONSE_FILE="$1"
            fi
            shift
            ;;
    esac
done

# Set defaults
RESPONSE_FILE="${RESPONSE_FILE:-/tmp/evolution_response.json}"
GROWTH_MODE="${GROWTH_MODE:-adaptive}"

log_info "Validating evolution results..."
log_info "Response file: $RESPONSE_FILE"
log_info "Growth mode: $GROWTH_MODE"

# Validate response file exists and is readable
if ! validate_file_readable "$RESPONSE_FILE"; then
    log_error "Evolution response file is not readable: $RESPONSE_FILE"
    exit 1
fi

# Validate JSON structure
if ! is_valid_json "$(cat "$RESPONSE_FILE")"; then
    log_error "Evolution response file contains invalid JSON"
    exit 1
fi

# Check for required fields in response
REQUIRED_FIELDS=("status" "changes")
for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$RESPONSE_FILE" >/dev/null 2>&1; then
        log_warn "Missing field in evolution response: $field"
    fi
done

# Validate changes array if present
if jq -e ".changes" "$RESPONSE_FILE" >/dev/null 2>&1; then
    CHANGES_COUNT=$(jq '.changes | length' "$RESPONSE_FILE")
    log_info "Found $CHANGES_COUNT change(s) to validate"
    
    # Validate each change entry
    local validation_errors=0
    for ((i=0; i<CHANGES_COUNT; i++)); do
        CHANGE=$(jq ".changes[$i]" "$RESPONSE_FILE")
        
        # Check for required change fields
        if ! echo "$CHANGE" | jq -e ".path" >/dev/null 2>&1; then
            log_error "Change $((i+1)) missing 'path' field"
            ((validation_errors++))
        fi
        
        if ! echo "$CHANGE" | jq -e ".action" >/dev/null 2>&1; then
            log_error "Change $((i+1)) missing 'action' field"
            ((validation_errors++))
        fi
    done
    
    if [[ $validation_errors -gt 0 ]]; then
        log_error "Found $validation_errors validation error(s) in evolution response"
        exit 1
    fi
fi

# Run syntax validation on any shell scripts in changes
if jq -e '.changes[] | select(.path | endswith(".sh"))' "$RESPONSE_FILE" >/dev/null 2>&1; then
    log_info "Validating shell script syntax in changes..."
    
    jq -r '.changes[] | select(.path | endswith(".sh")) | .content' "$RESPONSE_FILE" | while read -r script_content; do
        if [[ -n "$script_content" ]]; then
            if ! echo "$script_content" | bash -n; then
                log_error "Shell script syntax validation failed"
                exit 1
            fi
        fi
    done
fi

log_success "Evolution validation completed successfully"
exit 0
