#!/bin/bash

#############################################################################
# 🧪 Simple Test Script for AI Evolution Engine - init_setup.sh
# Version: 1.0.0
# Purpose: Basic testing of the seed initialization script
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
EXPECTED_VERSION="0.4.1"

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
test_script_execution() {
    log_test "Testing script execution"
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Run the init script
    if bash "$INIT_SCRIPT" > init_output.log 2>&1; then
        log_pass "Script executed successfully"
        return 0
    else
        log_fail "Script execution failed"
        cat init_output.log
        return 1
    fi
}

test_essential_files() {
    log_test "Verifying essential files"
    
    local essential_files=(
        "README.md"
        ".seed.md"
        "evolution-metrics.json"
        ".github/workflows/ai_evolver.yml"
    )
    
    local all_exist=true
    for file in "${essential_files[@]}"; do
        if [ -f "$TEST_DIR/$file" ]; then
            log_pass "Essential file exists: $file"
        else
            log_fail "Missing essential file: $file"
            all_exist=false
        fi
    done
    
    return $([ "$all_exist" = true ] && echo 0 || echo 1)
}

test_version_presence() {
    log_test "Checking version $EXPECTED_VERSION presence"
    
    local files_with_version=0
    local files_to_check=(
        "README.md"
        ".seed.md"
        "evolution-metrics.json"
        ".github/workflows/ai_evolver.yml"
    )
    
    for file in "${files_to_check[@]}"; do
        if [ -f "$TEST_DIR/$file" ] && grep -q "$EXPECTED_VERSION" "$TEST_DIR/$file"; then
            log_info "✓ Version $EXPECTED_VERSION found in $file"
            files_with_version=$((files_with_version + 1))
        fi
    done
    
    if [ "$files_with_version" -ge 3 ]; then
        log_pass "Version $EXPECTED_VERSION found in multiple files"
        return 0
    else
        log_fail "Version $EXPECTED_VERSION not found in enough files"
        return 1
    fi
}

test_no_old_versions() {
    log_test "Checking for old version references"
    
    cd "$TEST_DIR"
    
    if find . -type f -name "*.md" -o -name "*.yml" -o -name "*.json" | xargs grep -l "0\.3\.6\|0\.2\.0" > /dev/null 2>&1; then
        log_fail "Found old version references:"
        find . -type f -name "*.md" -o -name "*.yml" -o -name "*.json" | xargs grep -n "0\.3\.6\|0\.2\.0" || true
        return 1
    else
        log_pass "No old version references found"
        return 0
    fi
}

test_git_repo() {
    log_test "Checking Git repository"
    
    cd "$TEST_DIR"
    
    if [ -d ".git" ] && git log --oneline -1 > /dev/null 2>&1; then
        log_pass "Git repository initialized with commit"
        return 0
    else
        log_fail "Git repository not properly initialized"
        return 1
    fi
}

test_workflow_structure() {
    log_test "Checking workflow basic structure"
    
    local workflow_file="$TEST_DIR/.github/workflows/ai_evolver.yml"
    
    if [ -f "$workflow_file" ]; then
        # Check for basic workflow elements
        local has_name=$(grep -c "^name:" "$workflow_file" || true)
        local has_on=$(grep -c "^on:" "$workflow_file" || true)
        local has_jobs=$(grep -c "^jobs:" "$workflow_file" || true)
        
        if [ "$has_name" -gt 0 ] && [ "$has_on" -gt 0 ] && [ "$has_jobs" -gt 0 ]; then
            log_pass "Workflow has basic required structure"
            return 0
        else
            log_fail "Workflow missing basic structure elements"
            return 1
        fi
    else
        log_fail "Workflow file not found"
        return 1
    fi
}

# Main test execution
main() {
    printf "${GREEN}🧪 Simple AI Evolution Engine Init Script Test${NC}\n"
    echo "================================================"
    echo "Testing: $INIT_SCRIPT"
    echo "Test directory: $TEST_DIR"
    echo "Expected version: $EXPECTED_VERSION"
    echo "================================================"
    echo
    
    # Run tests
    if test_script_execution; then
        test_essential_files
        test_version_presence
        test_no_old_versions
        test_git_repo
        test_workflow_structure
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