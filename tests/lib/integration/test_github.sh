#!/bin/bash

#
# @file tests/lib/integration/test_github.sh
# @description Unit tests for GitHub integration module
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #modular-refactor: Test GitHub integration functionality
#
# @relatedEvolutions
#   - v0.4.0: Modular architecture implementation
#
# @dependencies
#   - ../../../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../../../src/lib/integration/github.sh: GitHub integration module
#
# @changelog
#   - 2025-07-05: Initial creation with comprehensive GitHub tests - ITJ
#
# @usage ./tests/lib/integration/test_github.sh
# @notes Tests GitHub API interactions, PR creation, and authentication
#

set -euo pipefail

# Get test directory and project root
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TEST_DIR}/../../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

# Load required modules
require_module "core/logger"
require_module "integration/github"

# Test configuration
TEST_RESULTS=()
TESTS_PASSED=0
TESTS_FAILED=0

# Test utilities
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    log_info "Running test: $test_name"
    
    if $test_function; then
        log_success "✓ $test_name"
        TEST_RESULTS+=("PASS: $test_name")
        ((TESTS_PASSED++))
    else
        log_error "✗ $test_name"
        TEST_RESULTS+=("FAIL: $test_name")
        ((TESTS_FAILED++))
    fi
}

# Test GitHub module loading
test_github_module_loading() {
    # Test if GitHub functions are available
    if declare -f github_check_auth >/dev/null 2>&1 && \
       declare -f github_create_pr >/dev/null 2>&1 && \
       declare -f github_get_repo_info >/dev/null 2>&1; then
        return 0
    else
        log_error "GitHub module functions not loaded"
        return 1
    fi
}

# Test GitHub authentication check (mock mode)
test_github_auth_check() {
    # Mock the gh command for testing
    export GITHUB_TEST_MODE="true"
    
    # Test authentication check
    if github_check_auth >/dev/null 2>&1; then
        return 0
    else
        log_error "GitHub auth check failed"
        return 1
    fi
}

# Test PR body generation
test_pr_body_generation() {
    local test_title="Test PR Title"
    local test_description="Test PR Description"
    local test_changes="Added new feature"
    
    local pr_body
    pr_body=$(github_generate_pr_body "$test_title" "$test_description" "$test_changes")
    
    if [[ "$pr_body" == *"$test_title"* ]] && \
       [[ "$pr_body" == *"$test_description"* ]] && \
       [[ "$pr_body" == *"$test_changes"* ]]; then
        return 0
    else
        log_error "PR body generation failed"
        return 1
    fi
}

# Test repository info extraction
test_repo_info_extraction() {
    # Mock git commands for testing
    export GIT_TEST_MODE="true"
    
    local repo_info
    repo_info=$(github_get_repo_info)
    
    if [[ -n "$repo_info" ]] && echo "$repo_info" | grep -q "owner\|repo"; then
        return 0
    else
        log_error "Repository info extraction failed"
        return 1
    fi
}

# Test GitHub URL validation
test_github_url_validation() {
    local valid_urls=(
        "https://github.com/owner/repo"
        "git@github.com:owner/repo.git"
        "https://github.com/owner/repo.git"
    )
    
    local invalid_urls=(
        "https://gitlab.com/owner/repo"
        "not-a-url"
        ""
    )
    
    # Test valid URLs
    for url in "${valid_urls[@]}"; do
        if ! github_is_valid_url "$url"; then
            log_error "Valid URL rejected: $url"
            return 1
        fi
    done
    
    # Test invalid URLs
    for url in "${invalid_urls[@]}"; do
        if github_is_valid_url "$url"; then
            log_error "Invalid URL accepted: $url"
            return 1
        fi
    done
    
    return 0
}

# Test branch operations
test_branch_operations() {
    export GIT_TEST_MODE="true"
    
    local test_branch="test-feature-branch"
    
    # Test branch creation
    if github_create_branch "$test_branch"; then
        log_info "Branch creation test passed"
    else
        log_error "Branch creation test failed"
        return 1
    fi
    
    # Test branch existence check
    if github_branch_exists "$test_branch"; then
        log_info "Branch existence check passed"
    else
        log_error "Branch existence check failed"
        return 1
    fi
    
    return 0
}

# Test error handling
test_error_handling() {
    export GITHUB_TEST_MODE="true"
    export GITHUB_FORCE_ERROR="true"
    
    # Test that functions handle errors gracefully
    if github_check_auth 2>/dev/null; then
        log_error "Error handling test failed - should have returned error"
        return 1
    fi
    
    unset GITHUB_FORCE_ERROR
    return 0
}

# Main test execution
main() {
    log_info "🔗 GitHub Integration Module Tests"
    
    # Run all tests
    run_test "Module Loading" test_github_module_loading
    run_test "Authentication Check" test_github_auth_check
    run_test "PR Body Generation" test_pr_body_generation
    run_test "Repository Info Extraction" test_repo_info_extraction
    run_test "GitHub URL Validation" test_github_url_validation
    run_test "Branch Operations" test_branch_operations
    run_test "Error Handling" test_error_handling
    
    # Display results
    log_info "📊 Test Results Summary"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == PASS:* ]]; then
            log_success "$result"
        else
            log_error "$result"
        fi
    done
    
    log_info "Tests passed: $TESTS_PASSED"
    log_info "Tests failed: $TESTS_FAILED"
    
    # Exit with appropriate code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All GitHub integration tests passed!"
        exit 0
    else
        log_error "Some GitHub integration tests failed!"
        exit 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
