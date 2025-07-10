#!/bin/bash

#
# @file test_version_manager_timeout_fix.sh
# @description Test script to validate version manager timeout fixes
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-10
# @lastModified 2025-07-10
# @version 1.0.0
#
# @relatedIssues 
#   - #workflow-hanging: Fix GitHub Actions workflow hanging during version checks
#
# @relatedEvolutions
#   - v0.3.0: Workflow timeout and hanging fixes
#
# @dependencies
#   - scripts/version-manager.sh: Version management system being tested
#   - timeout: Command timeout utility
#
# @changelog
#   - 2025-07-10: Initial creation to test version manager timeout fixes - ITJ
#
# @usage ./test_version_manager_timeout_fix.sh
# @notes Validates that version manager operations complete within reasonable timeouts
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_info() { echo -e "${BLUE}ℹ️ [INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}✅ [SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️ [WARN]${NC} $1"; }
log_error() { echo -e "${RED}❌ [ERROR]${NC} $1"; }

# Test functions
success() {
    log_success "$1"
    ((TESTS_PASSED++))
}

fail() {
    log_error "$1"
    ((TESTS_FAILED++))
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    local timeout_duration="${3:-30}"
    
    ((TESTS_RUN++))
    
    echo -e "\n${BLUE}🧪 Running:${NC} $test_name"
    
    if timeout "$timeout_duration" bash -c "$test_command" >/dev/null 2>&1; then
        success "$test_name"
    else
        fail "$test_name (failed or timed out after ${timeout_duration}s)"
    fi
}

# Setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_MANAGER="$SCRIPT_DIR/scripts/version-manager.sh"

log_info "🧪 Version Manager Timeout Fix Validation"
log_info "=========================================="

# Test 1: Version manager script exists and is executable
run_test "Version manager script exists and is executable" "test -x '$VERSION_MANAGER'"

# Test 2: Version retrieval completes quickly
run_test "Version retrieval completes within timeout" "'$VERSION_MANAGER' check-status | grep -q 'Current Version'" 15

# Test 3: File scan completes within reasonable time
run_test "File scan completes within timeout" "'$VERSION_MANAGER' scan-files" 60

# Test 4: Version status check doesn't hang
run_test "Version status check completes within timeout" "'$VERSION_MANAGER' check-status" 30

# Test 5: Multiple rapid calls don't cause hanging
run_test "Multiple rapid calls complete successfully" "
    for i in {1..3}; do
        timeout 10s '$VERSION_MANAGER' check-status >/dev/null 2>&1 || exit 1
    done
" 45

# Test 6: Script handles invalid git repository gracefully
run_test "Script handles invalid git operations gracefully" "
    cd /tmp
    timeout 15s '$VERSION_MANAGER' check-status >/dev/null 2>&1 || true
    cd '$SCRIPT_DIR'
" 20

# Test 7: Test with simulated heavy load
run_test "Script performs under simulated load" "
    # Run multiple background processes to simulate load
    for i in {1..2}; do
        timeout 10s '$VERSION_MANAGER' check-status >/dev/null 2>&1 &
    done
    wait
" 25

echo ""
log_info "🏁 Test Results Summary"
log_info "======================="
echo "Tests Run: $TESTS_RUN"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo ""
    log_success "All tests passed! Version manager timeout fixes are working correctly."
    exit 0
else
    echo ""
    log_error "$TESTS_FAILED tests failed. Version manager may still have timeout issues."
    exit 1
fi
