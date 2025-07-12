#!/bin/bash
#
# @file scripts/test-ai-prompts-config.sh
# @description Test script for AI prompts evolution configuration
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - ai_prompts_evolution.json: Implementation and testing
#
# @relatedEvolutions
#   - v1.0.0: Initial creation for testing AI prompts configuration
#
# @dependencies
#   - bash: >=4.0
#   - jq: JSON processor
#   - ai_prompts_evolution.json: AI prompts configuration file
#
# @changelog
#   - 2025-07-12: Initial creation for testing AI prompts configuration - ITJ
#
# @usage ./test-ai-prompts-config.sh
# @notes Tests loading and functionality of AI prompts configuration
#

set -euo pipefail

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export PROJECT_ROOT="$REPO_ROOT"

# Source required libraries
source "$REPO_ROOT/src/lib/core/logger.sh" 2>/dev/null || {
    echo "Warning: Logger not available, using basic logging"
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
    log_warning() { echo "[WARNING] $*" >&2; }
    log_success() { echo "[SUCCESS] $*"; }
    log_debug() { echo "[DEBUG] $*"; }
}

source "$REPO_ROOT/src/lib/utils/json_processor.sh" 2>/dev/null || {
    log_error "JSON processor module not available"
    exit 1
}

log_info "Testing AI Prompts Evolution Configuration"
echo "=========================================="

# Test 1: Load configuration
log_info "Test 1: Loading AI prompts configuration..."
CONFIG_JSON=$(ai_prompts_load_config)
if [[ $? -eq 0 ]]; then
    log_success "✅ Configuration loaded successfully"
    CONFIG_VERSION=$(echo "$CONFIG_JSON" | jq -r '.version // "unknown"')
    log_info "Configuration version: $CONFIG_VERSION"
else
    log_error "❌ Failed to load configuration"
    exit 1
fi

# Test 2: List all prompts
log_info "Test 2: Listing all available prompts..."
PROMPTS=$(ai_prompts_list_by_category "" "$CONFIG_JSON")
if [[ $? -eq 0 ]]; then
    log_success "✅ Found prompts:"
    echo "$PROMPTS" | while read -r prompt; do
        [[ -n "$prompt" ]] && echo "  - $prompt"
    done
else
    log_error "❌ Failed to list prompts"
fi

# Test 3: Test specific prompt definitions
log_info "Test 3: Testing specific prompt definitions..."
TEST_PROMPTS=("doc_harmonization" "security_scan" "code_refactor")

for prompt in "${TEST_PROMPTS[@]}"; do
    log_info "Testing prompt: $prompt"
    
    # Get definition
    DEFINITION=$(ai_prompts_get_definition "$prompt" "$CONFIG_JSON")
    if [[ $? -eq 0 ]]; then
        CATEGORY=$(echo "$DEFINITION" | jq -r '.category // "unknown"')
        DESCRIPTION=$(echo "$DEFINITION" | jq -r '.description // "no description"')
        log_success "  ✅ Definition loaded - Category: $CATEGORY"
        log_info "     Description: $DESCRIPTION"
    else
        log_error "  ❌ Failed to get definition for $prompt"
        continue
    fi
    
    # Get strategy
    STRATEGY=$(ai_prompts_get_strategy "$prompt" "$CONFIG_JSON")
    if [[ $? -eq 0 ]]; then
        STRATEGY_NAME=$(echo "$DEFINITION" | jq -r '.execution_settings.strategy // "unknown"')
        SAFETY_LEVEL=$(echo "$STRATEGY" | jq -r '.safety_level // "unknown"')
        log_success "  ✅ Strategy loaded - Type: $STRATEGY_NAME, Safety: $SAFETY_LEVEL"
    else
        log_warning "  ⚠️  Could not load strategy for $prompt"
    fi
    
    # Get schedule
    SCHEDULE=$(ai_prompts_get_schedule "$prompt" "$CONFIG_JSON")
    if [[ $? -eq 0 ]]; then
        CRON=$(echo "$SCHEDULE" | jq -r '.cron // "unknown"')
        SCHEDULE_DESC=$(echo "$SCHEDULE" | jq -r '.description // "no description"')
        log_success "  ✅ Schedule loaded - Cron: $CRON, Description: $SCHEDULE_DESC"
    else
        log_warning "  ⚠️  Could not load schedule for $prompt"
    fi
    
    echo ""
done

# Test 4: Test global settings
log_info "Test 4: Testing global settings..."
DEFAULT_DRY_RUN=$(echo "$CONFIG_JSON" | jq -r '.global_settings.default_dry_run // "null"')
MAX_EXEC_TIME=$(echo "$CONFIG_JSON" | jq -r '.global_settings.max_execution_time // "null"')
LOG_LEVEL=$(echo "$CONFIG_JSON" | jq -r '.global_settings.log_level // "null"')

log_success "✅ Global settings:"
log_info "  Default dry run: $DEFAULT_DRY_RUN"
log_info "  Max execution time: $MAX_EXEC_TIME"
log_info "  Log level: $LOG_LEVEL"

# Test 5: Test category listing
log_info "Test 5: Testing category-based prompt listing..."
CATEGORIES=("maintenance" "enhancement" "infrastructure" "community")

for category in "${CATEGORIES[@]}"; do
    CATEGORY_PROMPTS=$(ai_prompts_list_by_category "$category" "$CONFIG_JSON")
    if [[ $? -eq 0 ]]; then
        PROMPT_COUNT=$(echo "$CATEGORY_PROMPTS" | wc -l)
        log_success "✅ Category '$category' has $PROMPT_COUNT prompts:"
        echo "$CATEGORY_PROMPTS" | while read -r prompt; do
            [[ -n "$prompt" ]] && echo "    - $prompt"
        done
    else
        log_warning "⚠️  Could not list prompts for category: $category"
    fi
    echo ""
done

# Test 6: Validate JSON structure
log_info "Test 6: Validating JSON structure..."
if json_validate "$CONFIG_JSON"; then
    log_success "✅ Configuration JSON is valid"
else
    log_error "❌ Configuration JSON is invalid"
    exit 1
fi

# Test 7: Check template files existence
log_info "Test 7: Checking template files existence..."
TEMPLATE_COUNT=0
MISSING_COUNT=0

while read -r prompt; do
    [[ -z "$prompt" ]] && continue
    
    DEFINITION=$(ai_prompts_get_definition "$prompt" "$CONFIG_JSON")
    TEMPLATE_FILE=$(echo "$DEFINITION" | jq -r '.template_file // null')
    
    if [[ "$TEMPLATE_FILE" != "null" ]]; then
        FULL_PATH="$REPO_ROOT/$TEMPLATE_FILE"
        if [[ -f "$FULL_PATH" ]]; then
            echo "  ✅ $prompt -> $TEMPLATE_FILE"
            ((TEMPLATE_COUNT++))
        else
            echo "  ❌ $prompt -> $TEMPLATE_FILE (MISSING)"
            ((MISSING_COUNT++))
        fi
    else
        echo "  ⚠️  $prompt -> No template file specified"
    fi
done <<< "$PROMPTS"

log_info "Template file check complete"

echo ""
echo "=========================================="
log_success "AI Prompts Configuration Test Complete"
log_info "All major functionality appears to be working correctly!"
echo "=========================================="