#!/bin/bash

#############################################################################
# 🧪 Test Script for AI Evolution Engine - init_setup.sh
# Version: 1.0.0
# Purpose: Comprehensive testing of the seed initialization script
#############################################################################

set -euo pipefail

# Colors for test output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT_SCRIPT="$PROJECT_ROOT/init_setup.sh"
TEST_DIR="/tmp/ai-evolution-test-$$"
EXPECTED_VERSION="0.4.1-seed"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test utilities
log_test() {
    printf "${BLUE}[TEST]${NC} %s\n" "$1"
    TESTS_RUN=$((TESTS_RUN + 1))
}

log_pass() {
    printf "${GREEN}[PASS]${NC} %s\n" "$1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    printf "${RED}[FAIL]${NC} %s\n" "$1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

log_info() {
    printf "${CYAN}[INFO]${NC} %s\n" "$1"
}

# Cleanup function
cleanup() {
    if [ -d "$TEST_DIR" ]; then
        log_info "Cleaning up test directory: $TEST_DIR"
        rm -rf "$TEST_DIR"
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# Test functions
test_script_exists() {
    log_test "Checking if init_setup.sh exists"
    if [ -f "$INIT_SCRIPT" ]; then
        log_pass "init_setup.sh exists at $INIT_SCRIPT"
    else
        log_fail "init_setup.sh not found at $INIT_SCRIPT"
        exit 1
    fi
}

test_script_executable() {
    log_test "Checking if init_setup.sh is executable"
    if [ -x "$INIT_SCRIPT" ]; then
        log_pass "init_setup.sh is executable"
    else
        log_fail "init_setup.sh is not executable"
        log_info "Making script executable..."
        chmod +x "$INIT_SCRIPT"
    fi
}

test_script_syntax() {
    log_test "Checking script syntax"
    if bash -n "$INIT_SCRIPT" 2>/dev/null; then
        log_pass "Script syntax is valid"
    else
        log_fail "Script has syntax errors"
        bash -n "$INIT_SCRIPT"
        exit 1
    fi
}

test_script_execution() {
    log_test "Testing script execution in isolated directory"
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Run the init script
    if bash "$INIT_SCRIPT" > init_output.log 2>&1; then
        log_pass "Script executed successfully"
    else
        log_fail "Script execution failed"
        cat init_output.log
        return 1
    fi
}

test_directory_structure() {
    log_test "Verifying directory structure"
    
    local expected_dirs=(
        ".github/workflows"
        "prompts"
        "src/lib/core"
        "src/lib/evolution"
        "src/lib/integration"
        "src/lib/workflow"
        "src/lib/analysis"
        "src/lib/utils"
        "src/lib/template"
        "tests/unit"
        "tests/integration"
        "tests/fixtures"
        "tests/results"
        "tests/workflows"
        "tests/seed"
        "tests/lib"
        "docs/guides"
        "docs/architecture"
        "docs/evolution"
        "docs/workflows"
        "docs/seeds"
        "logs/evolution"
    )
    
    local all_exist=true
    for dir in "${expected_dirs[@]}"; do
        if [ -d "$TEST_DIR/$dir" ]; then
            log_info "✓ Directory exists: $dir"
        else
            log_fail "Missing directory: $dir"
            all_exist=false
        fi
    done
    
    if [ "$all_exist" = true ]; then
        log_pass "All expected directories created"
    else
        log_fail "Some directories are missing"
        return 1
    fi
}

test_file_creation() {
    log_test "Verifying file creation"
    
    local expected_files=(
        ".gitignore"
        ".gptignore"
        "README.md"
        ".evolution.yml"
        "evolution-metrics.json"
        ".seed.md"
        ".github/workflows/ai_evolver.yml"
        "prompts/first_growth.md"
    )
    
    local all_exist=true
    for file in "${expected_files[@]}"; do
        if [ -f "$TEST_DIR/$file" ]; then
            log_info "✓ File exists: $file"
        else
            log_fail "Missing file: $file"
            all_exist=false
        fi
    done
    
    if [ "$all_exist" = true ]; then
        log_pass "All expected files created"
    else
        log_fail "Some files are missing"
        return 1
    fi
}

test_version_consistency() {
    log_test "Checking version consistency across files"
    
    cd "$TEST_DIR"
    
    # Check version in key files
    local version_files=(
        "README.md"
        ".seed.md"
        "evolution-metrics.json"
        ".github/workflows/ai_evolver.yml"
    )
    
    local all_consistent=true
    for file in "${version_files[@]}"; do
        if [ -f "$file" ]; then
            # Check for version with or without -seed suffix
            local base_version="0.4.1"
            local has_version=false
            
            # Check for exact version match
            if grep -q "$EXPECTED_VERSION" "$file"; then
                local count=$(grep -c "$EXPECTED_VERSION" "$file" || true)
                log_info "✓ Found $count occurrences of $EXPECTED_VERSION in $file"
                has_version=true
            # Check for version without -seed suffix
            elif grep -q "$base_version" "$file"; then
                local count=$(grep -c "$base_version" "$file" || true)
                log_info "✓ Found $count occurrences of $base_version in $file"
                has_version=true
            fi
            
            if ! $has_version; then
                log_fail "No version $base_version found in $file"
                all_consistent=false
            fi
            
            # Special check for evolution-metrics.json
            if [[ "$file" == "evolution-metrics.json" ]]; then
                if grep -q '"seed_version": "0.4.1-seed"' "$file"; then
                    log_info "✓ Correct seed_version field in evolution-metrics.json"
                else
                    log_fail "Incorrect seed_version in evolution-metrics.json"
                    all_consistent=false
                fi
            fi
            
            # Check for old versions
            if grep -E "0\.3\.6|0\.2\.0" "$file" > /dev/null 2>&1; then
                log_fail "Found old version references in $file"
                grep -n -E "0\.3\.6|0\.2\.0" "$file" || true
                all_consistent=false
            fi
        fi
    done
    
    if [ "$all_consistent" = true ]; then
        log_pass "Version consistency maintained across all files"
    else
        log_fail "Version inconsistencies found"
        return 1
    fi
}

test_git_initialization() {
    log_test "Checking Git repository initialization"
    
    cd "$TEST_DIR"
    
    if [ -d ".git" ]; then
        log_pass "Git repository initialized"
        
        # Check for initial commit
        if git log --oneline -1 > /dev/null 2>&1; then
            local commit_msg=$(git log --oneline -1)
            log_info "Initial commit: $commit_msg"
            
            if [[ "$commit_msg" == *"Planted AI Evolution Engine Seed"* ]]; then
                log_pass "Initial commit message is correct"
            else
                log_fail "Initial commit message is incorrect"
            fi
        else
            log_fail "No initial commit found"
        fi
    else
        log_fail "Git repository not initialized"
        return 1
    fi
}

test_workflow_validity() {
    log_test "Checking GitHub workflow validity"
    
    cd "$TEST_DIR"
    
    if [ -f ".github/workflows/ai_evolver.yml" ]; then
        # Basic YAML syntax check (if yq is available)
        if command -v yq > /dev/null 2>&1; then
            if yq eval '.' ".github/workflows/ai_evolver.yml" > /dev/null 2>&1; then
                log_pass "Workflow YAML is valid"
            else
                log_fail "Workflow YAML has syntax errors"
                return 1
            fi
        else
            log_info "yq not available, skipping YAML validation"
        fi
        
        # Check for required workflow elements
        if grep -q "name: 🌱 AI Evolution Growth Engine" ".github/workflows/ai_evolver.yml" && \
           grep -q "workflow_dispatch:" ".github/workflows/ai_evolver.yml" && \
           grep -q "jobs:" ".github/workflows/ai_evolver.yml"; then
            log_pass "Workflow contains required elements"
        else
            log_fail "Workflow missing required elements"
            return 1
        fi
    else
        log_fail "Workflow file not found"
        return 1
    fi
}

test_no_uuidgen_usage() {
    log_test "Checking for uuidgen usage (should be replaced)"
    
    cd "$TEST_DIR"
    
    if grep -r "uuidgen" . --exclude-dir=.git > /dev/null 2>&1; then
        log_fail "Found uuidgen usage in generated files"
        grep -r "uuidgen" . --exclude-dir=.git || true
        return 1
    else
        log_pass "No uuidgen usage found (good for compatibility)"
    fi
}

test_evolution_metrics() {
    log_test "Checking evolution-metrics.json structure"
    
    cd "$TEST_DIR"
    
    if [ -f "evolution-metrics.json" ]; then
        # Check if it's valid JSON
        if jq '.' evolution-metrics.json > /dev/null 2>&1; then
            log_pass "evolution-metrics.json is valid JSON"
            
            # Check required fields
            local required_fields=("seed_version" "planted_at" "growth_cycles" "current_generation")
            local all_fields=true
            
            for field in "${required_fields[@]}"; do
                if jq -e ".$field" evolution-metrics.json > /dev/null 2>&1; then
                    local value=$(jq -r ".$field" evolution-metrics.json)
                    log_info "✓ Field '$field': $value"
                else
                    log_fail "Missing required field: $field"
                    all_fields=false
                fi
            done
            
            if [ "$all_fields" = true ]; then
                log_pass "All required fields present in evolution-metrics.json"
            fi
        else
            log_fail "evolution-metrics.json is not valid JSON"
            return 1
        fi
    else
        log_fail "evolution-metrics.json not found"
        return 1
    fi
}

# Main test execution
main() {
    printf "${GREEN}🧪 AI Evolution Engine Init Script Test Suite${NC}\n"
    echo "================================================"
    echo "Testing: $INIT_SCRIPT"
    echo "Test directory: $TEST_DIR"
    echo "Expected version: $EXPECTED_VERSION"
    echo "================================================"
    echo
    
    # Run tests
    test_script_exists
    test_script_executable
    test_script_syntax
    test_script_execution
    
    # Only run these tests if execution succeeded
    if [ -d "$TEST_DIR/.git" ]; then
        test_directory_structure
        test_file_creation
        test_version_consistency
        test_git_initialization
        test_workflow_validity
        test_no_uuidgen_usage
        test_evolution_metrics
    fi
    
    # Summary
    echo
    echo "================================================"
    printf "${CYAN}Test Summary:${NC}\n"
    echo "Tests run: $TESTS_RUN"
    printf "Tests passed: ${GREEN}%d${NC}\n" "$TESTS_PASSED"
    printf "Tests failed: ${RED}%d${NC}\n" "$TESTS_FAILED"
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        printf "${GREEN}✅ All tests passed!${NC}\n"
        exit 0
    else
        printf "${RED}❌ Some tests failed!${NC}\n"
        exit 1
    fi
}

# Run main function
main "$@" 