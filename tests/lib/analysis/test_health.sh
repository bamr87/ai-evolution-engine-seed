#!/bin/bash

#
# @file tests/lib/analysis/test_health.sh
# @description Unit tests for repository health analysis module
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #modular-refactor: Test health analysis functionality
#
# @relatedEvolutions
#   - v0.4.0: Modular architecture implementation
#
# @dependencies
#   - ../../../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../../../src/lib/analysis/health.sh: Health analysis module
#
# @changelog
#   - 2025-07-05: Initial creation with comprehensive health analysis tests - ITJ
#
# @usage ./tests/lib/analysis/test_health.sh
# @notes Tests repository health checks, metrics analysis, and recommendations
#

set -euo pipefail

# Get test directory and project root
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TEST_DIR}/../../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

# Load required modules
require_module "core/logger"
require_module "analysis/health"

# Test configuration
TEST_RESULTS=()
TESTS_PASSED=0
TESTS_FAILED=0
TEST_TEMP_DIR=""

# Setup test environment
setup_test_environment() {
    TEST_TEMP_DIR=$(mktemp -d)
    cd "$TEST_TEMP_DIR"
    
    # Create a mock repository structure for testing
    mkdir -p .git/refs/heads
    mkdir -p src/{lib,modules}
    mkdir -p tests/{unit,integration}
    mkdir -p docs
    
    # Create test files with various issues
    cat > README.md << 'EOF'
# Test Repository

This is a test	repository with mixed tabs and spaces.
EOF
    
    cat > src/example.js << 'EOF'
// TODO: Fix this function
function example() {
    console.log("Hello, World!");
}
EOF
    
    cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.0.0] - 2023-01-01
- Initial release
EOF
    
    # Create git repository simulation
    echo "ref: refs/heads/main" > .git/HEAD
    date +%s > .git/refs/heads/main
}

# Cleanup test environment
cleanup_test_environment() {
    if [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

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

# Test health module loading
test_health_module_loading() {
    # Test if health analysis functions are available
    if declare -f health_analyze_repository >/dev/null 2>&1 && \
       declare -f health_check_files >/dev/null 2>&1 && \
       declare -f health_generate_recommendations >/dev/null 2>&1; then
        return 0
    else
        log_error "Health analysis module functions not loaded"
        return 1
    fi
}

# Test repository analysis
test_repository_analysis() {
    setup_test_environment
    
    local analysis_result
    analysis_result=$(health_analyze_repository)
    
    cleanup_test_environment
    
    if [[ -n "$analysis_result" ]] && echo "$analysis_result" | grep -q "health_score\|issues\|recommendations"; then
        return 0
    else
        log_error "Repository analysis failed or returned invalid format"
        return 1
    fi
}

# Test file consistency checks
test_file_consistency_checks() {
    setup_test_environment
    
    # Test tab/space detection
    local tab_issues
    tab_issues=$(health_check_whitespace_consistency)
    
    if [[ "$tab_issues" -gt 0 ]]; then
        log_info "Correctly detected whitespace inconsistencies: $tab_issues files"
    else
        log_error "Failed to detect whitespace inconsistencies"
        cleanup_test_environment
        return 1
    fi
    
    cleanup_test_environment
    return 0
}

# Test TODO/FIXME detection
test_todo_detection() {
    setup_test_environment
    
    local todo_count
    todo_count=$(health_count_todos)
    
    if [[ "$todo_count" -gt 0 ]]; then
        log_info "Correctly detected TODO items: $todo_count"
    else
        log_error "Failed to detect TODO items"
        cleanup_test_environment
        return 1
    fi
    
    cleanup_test_environment
    return 0
}

# Test documentation freshness check
test_documentation_freshness() {
    setup_test_environment
    
    # Simulate old documentation
    touch -t 202301010000 README.md
    
    local outdated_docs
    outdated_docs=$(health_check_documentation_freshness)
    
    if [[ "$outdated_docs" -gt 0 ]]; then
        log_info "Correctly detected outdated documentation: $outdated_docs files"
    else
        log_error "Failed to detect outdated documentation"
        cleanup_test_environment
        return 1
    fi
    
    cleanup_test_environment
    return 0
}

# Test health score calculation
test_health_score_calculation() {
    setup_test_environment
    
    local health_score
    health_score=$(health_calculate_score)
    
    if [[ "$health_score" =~ ^[0-9]+(\.[0-9]+)?$ ]] && \
       [[ $(echo "$health_score >= 0" | bc -l) -eq 1 ]] && \
       [[ $(echo "$health_score <= 100" | bc -l) -eq 1 ]]; then
        log_info "Health score calculated: $health_score"
        cleanup_test_environment
        return 0
    else
        log_error "Invalid health score: $health_score"
        cleanup_test_environment
        return 1
    fi
}

# Test recommendation generation
test_recommendation_generation() {
    setup_test_environment
    
    local recommendations
    recommendations=$(health_generate_recommendations)
    
    if [[ -n "$recommendations" ]] && echo "$recommendations" | grep -q "recommendation\|priority\|action"; then
        log_info "Recommendations generated successfully"
        cleanup_test_environment
        return 0
    else
        log_error "Failed to generate recommendations"
        cleanup_test_environment
        return 1
    fi
}

# Test security checks
test_security_checks() {
    setup_test_environment
    
    # Create file with potential security issue
    cat > .env << 'EOF'
API_KEY=secret123
PASSWORD=mypassword
EOF
    
    local security_issues
    security_issues=$(health_check_security_issues)
    
    if [[ "$security_issues" -gt 0 ]]; then
        log_info "Correctly detected security issues: $security_issues"
    else
        log_error "Failed to detect security issues"
        cleanup_test_environment
        return 1
    fi
    
    cleanup_test_environment
    return 0
}

# Test performance metrics
test_performance_metrics() {
    setup_test_environment
    
    # Create large files to test performance metrics
    for i in {1..5}; do
        head -c 1M </dev/urandom > "large_file_$i.txt"
    done
    
    local perf_metrics
    perf_metrics=$(health_analyze_performance)
    
    if [[ -n "$perf_metrics" ]] && echo "$perf_metrics" | grep -q "file_count\|total_size"; then
        log_info "Performance metrics calculated successfully"
        cleanup_test_environment
        return 0
    else
        log_error "Failed to calculate performance metrics"
        cleanup_test_environment
        return 1
    fi
}

# Test error handling
test_error_handling() {
    # Test with non-existent directory
    local original_pwd=$(pwd)
    cd /tmp
    
    if health_analyze_repository 2>/dev/null; then
        log_error "Error handling test failed - should have returned error"
        cd "$original_pwd"
        return 1
    fi
    
    cd "$original_pwd"
    return 0
}

# Main test execution
main() {
    log_info "🏥 Health Analysis Module Tests"
    
    # Ensure bc is available for calculations
    if ! command -v bc >/dev/null 2>&1; then
        log_warn "bc command not available, some tests may be skipped"
    fi
    
    # Run all tests
    run_test "Module Loading" test_health_module_loading
    run_test "Repository Analysis" test_repository_analysis
    run_test "File Consistency Checks" test_file_consistency_checks
    run_test "TODO Detection" test_todo_detection
    run_test "Documentation Freshness" test_documentation_freshness
    
    if command -v bc >/dev/null 2>&1; then
        run_test "Health Score Calculation" test_health_score_calculation
    fi
    
    run_test "Recommendation Generation" test_recommendation_generation
    run_test "Security Checks" test_security_checks
    run_test "Performance Metrics" test_performance_metrics
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
        log_success "All health analysis tests passed!"
        exit 0
    else
        log_error "Some health analysis tests failed!"
        exit 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
