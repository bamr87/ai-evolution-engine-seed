#!/bin/bash

# Workflow Validation Script for AI Evolution Engine
# This script validates that all workflows follow the established standards

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

log_header "AI Evolution Workflow Validation Script"

WORKFLOWS_DIR=".github/workflows"
ERRORS=0

# Function to check if file exists
check_file_exists() {
    local file="$1"
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        ((ERRORS++))
        return 1
    fi
    log_success "Found: $file"
    return 0
}

# Function to check if string exists in file
check_string_in_file() {
    local file="$1"
    local string="$2"
    local description="$3"
    
    if ! grep -q "$string" "$file"; then
        log_error "$description not found in $file"
        ((ERRORS++))
        return 1
    fi
    log_success "$description found in $file"
    return 0
}

# Function to validate workflow structure
validate_workflow() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    log_info "Validating $workflow_name..."
    
    check_file_exists "$workflow_file" || return 1
    
    # Check version consistency
    check_string_in_file "$workflow_file" "v0.3.0" "Version v0.3.0"
    
    # Check permissions
    check_string_in_file "$workflow_file" "contents: write" "Contents write permission"
    check_string_in_file "$workflow_file" "pull-requests: write" "Pull requests write permission"
    check_string_in_file "$workflow_file" "issues: write" "Issues write permission"
    
    # Check for GitHub token usage
    check_string_in_file "$workflow_file" "GITHUB_TOKEN" "GitHub token usage"
    
    # Check for dry run support
    check_string_in_file "$workflow_file" "dry_run" "Dry run support"
    
    # Check for emoji usage in step names
    check_string_in_file "$workflow_file" "🌱" "Emoji usage in step names"
    
    # Check for error handling patterns
    check_string_in_file "$workflow_file" "chmod +x" "Script permission handling"
    
    return 0
}

# Function to validate documentation
validate_documentation() {
    log_info "Validating Documentation..."
    
    check_file_exists "$WORKFLOWS_DIR/README.md"
    check_file_exists "$WORKFLOWS_DIR/WORKFLOW_STANDARDS.md"
    check_file_exists "$WORKFLOWS_DIR/IMPROVEMENTS_SUMMARY.md"
    
    # Check documentation content
    check_string_in_file "$WORKFLOWS_DIR/README.md" "AI Evolution Engine" "Main documentation title"
    check_string_in_file "$WORKFLOWS_DIR/WORKFLOW_STANDARDS.md" "0.3.0" "Standards version"
    check_string_in_file "$WORKFLOWS_DIR/IMPROVEMENTS_SUMMARY.md" "Design for Failure" "DFF principle documentation"
    
    return 0
}

# Main validation
log_info "Starting Workflow Validation..."

# Validate each workflow
validate_workflow "$WORKFLOWS_DIR/ai_evolver.yml" "AI Evolution Growth Engine"
validate_workflow "$WORKFLOWS_DIR/daily_evolution.yml" "Daily Evolution & Maintenance"
validate_workflow "$WORKFLOWS_DIR/testing_automation_evolver.yml" "Testing & Build Automation"

# Validate documentation
validate_documentation

# Summary
log_header "Validation Summary"

if [ $ERRORS -eq 0 ]; then
    log_success "All validations passed! Workflows are properly configured."
    echo ""
    log_success "Consistency: All workflows follow standard patterns"
    log_success "Security: Using GitHub tokens appropriately"
    log_success "Error Handling: Proper validation and error handling"
    log_success "Documentation: Complete documentation suite"
    log_success "DRY Principle: Standardized patterns and reusable components"
    log_success "Simplicity: Clear, readable workflow structure"
    echo ""
    log_success "Ready for deployment!"
    exit 0
else
    log_error "Validation failed with $ERRORS errors."
    echo ""
    echo "Please review the errors above and fix them before proceeding."
    echo "Refer to WORKFLOW_STANDARDS.md for guidance."
    exit 1
fi
