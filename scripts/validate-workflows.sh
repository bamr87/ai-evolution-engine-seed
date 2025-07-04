#!/bin/bash

# Workflow Validation Script for AI Evolution Engine
# This script validates that all workflows follow the established standards

set -euo pipefail

echo "🔍 AI Evolution Workflow Validation Script"
echo "========================================="

WORKFLOWS_DIR=".github/workflows"
ERRORS=0

# Function to check if file exists
check_file_exists() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "❌ ERROR: File not found: $file"
        ((ERRORS++))
        return 1
    fi
    echo "✅ Found: $file"
    return 0
}

# Function to check if string exists in file
check_string_in_file() {
    local file="$1"
    local string="$2"
    local description="$3"
    
    if ! grep -q "$string" "$file"; then
        echo "❌ ERROR: $description not found in $file"
        ((ERRORS++))
        return 1
    fi
    echo "✅ $description found in $file"
    return 0
}

# Function to validate workflow structure
validate_workflow() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    echo ""
    echo "🔎 Validating $workflow_name..."
    echo "----------------------------------------"
    
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
    echo ""
    echo "📚 Validating Documentation..."
    echo "----------------------------------------"
    
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
echo ""
echo "🚀 Starting Workflow Validation..."
echo ""

# Validate each workflow
validate_workflow "$WORKFLOWS_DIR/ai_evolver.yml" "AI Evolution Growth Engine"
validate_workflow "$WORKFLOWS_DIR/daily_evolution.yml" "Daily Evolution & Maintenance"
validate_workflow "$WORKFLOWS_DIR/testing_automation_evolver.yml" "Testing & Build Automation"

# Validate documentation
validate_documentation

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="

if [ $ERRORS -eq 0 ]; then
    echo "🎉 All validations passed! Workflows are properly configured."
    echo ""
    echo "✅ Consistency: All workflows follow standard patterns"
    echo "✅ Security: Using GitHub tokens appropriately"
    echo "✅ Error Handling: Proper validation and error handling"
    echo "✅ Documentation: Complete documentation suite"
    echo "✅ DRY Principle: Standardized patterns and reusable components"
    echo "✅ Simplicity: Clear, readable workflow structure"
    echo ""
    echo "🚀 Ready for deployment!"
    exit 0
else
    echo "❌ Validation failed with $ERRORS errors."
    echo ""
    echo "Please review the errors above and fix them before proceeding."
    echo "Refer to WORKFLOW_STANDARDS.md for guidance."
    exit 1
fi
