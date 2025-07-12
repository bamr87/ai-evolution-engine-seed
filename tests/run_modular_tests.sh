#!/bin/bash

#
# @file tests/run_modular_tests.sh
# @description Comprehensive test runner for the modular library system
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #modular-refactor: Comprehensive testing for modular architecture
#
# @relatedEvolutions
#   - v1.0.0: Initial creation with comprehensive test coverage
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - Various test files in tests/lib/
#
# @changelog
#   - 2025-07-05: Initial creation with comprehensive test suite - ITJ
#
# @usage ./tests/run_modular_tests.sh [test_category] [--verbose] [--coverage]
# @notes Runs all modular library tests with detailed reporting and coverage analysis
#

set -euo pipefail

# Get test directory and project root
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TEST_DIR}/.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

# Load required modules
require_module "core/logger"

# Test configuration
TEST_CATEGORY="${1:-all}"
VERBOSE_MODE="false"
COVERAGE_MODE="false"
PARALLEL_MODE="false"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE_MODE="true"
            shift
            ;;
        --coverage|-c)
            COVERAGE_MODE="true"
            shift
            ;;
        --parallel|-p)
            PARALLEL_MODE="true"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            if [[ -z "$TEST_CATEGORY" ]]; then
                TEST_CATEGORY="$1"
            fi
            shift
            ;;
    esac
done

# Test results tracking
declare -A TEST_RESULTS
declare -A TEST_DURATIONS
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Available test categories
AVAILABLE_CATEGORIES=(
    "core"
    "evolution"
    "integration"
    "analysis"
    "template"
    "scripts"
    "performance"
    "security"
    "all"
)

# Test definitions
declare -A TEST_SUITES
TEST_SUITES[core]="lib/core/test_bootstrap.sh lib/core/test_logger.sh lib/core/test_config.sh lib/core/test_validation.sh lib/core/test_utils.sh"
TEST_SUITES[evolution]="lib/evolution/test_engine.sh lib/evolution/test_seeds.sh lib/evolution/test_metrics.sh lib/evolution/test_git.sh"
TEST_SUITES[integration]="lib/integration/test_github.sh lib/integration/test_ci.sh"
TEST_SUITES[analysis]="lib/analysis/test_health.sh"
TEST_SUITES[template]="lib/template/test_engine.sh"
TEST_SUITES[scripts]="scripts/test_evolve.sh scripts/test_generate_seed.sh scripts/test_create_pr.sh"

# Helper functions
show_help() {
    cat << EOF
Usage: $0 [test_category] [options]

Test Categories:
  core          Test core modules (bootstrap, logger, config, validation, utils)
  evolution     Test evolution modules (engine, seeds, metrics, git)
  integration   Test integration modules (github, ci)
  analysis      Test analysis modules (health)
  template      Test template modules (engine)
  scripts       Test refactored scripts
  performance   Run performance tests
  security      Run security tests
  all           Run all tests (default)

Options:
  --verbose, -v     Enable verbose output
  --coverage, -c    Generate test coverage report
  --parallel, -p    Run tests in parallel (experimental)
  --help, -h        Show this help message

Examples:
  $0                    # Run all tests
  $0 core               # Run only core module tests
  $0 integration -v     # Run integration tests with verbose output
  $0 all --coverage     # Run all tests with coverage report
EOF
}

# Test execution functions
run_test_file() {
    local test_file="$1"
    local test_name="$(basename "$test_file" .sh)"
    local test_path="$TEST_DIR/$test_file"
    
    if [[ ! -f "$test_path" ]]; then
        log_warn "Test file not found: $test_path"
        TEST_RESULTS["$test_name"]="SKIPPED"
        ((SKIPPED_TESTS++))
        return 0
    fi
    
    log_info "Running test: $test_name"
    
    local start_time=$(date +%s)
    local temp_log=$(mktemp)
    
    if [[ "$VERBOSE_MODE" == "true" ]]; then
        if bash "$test_path" 2>&1 | tee "$temp_log"; then
            TEST_RESULTS["$test_name"]="PASSED"
            ((PASSED_TESTS++))
        else
            TEST_RESULTS["$test_name"]="FAILED"
            ((FAILED_TESTS++))
        fi
    else
        if bash "$test_path" >"$temp_log" 2>&1; then
            TEST_RESULTS["$test_name"]="PASSED"
            ((PASSED_TESTS++))
        else
            TEST_RESULTS["$test_name"]="FAILED"
            ((FAILED_TESTS++))
            log_error "Test failed: $test_name"
            if [[ -s "$temp_log" ]]; then
                log_error "Error output:"
                cat "$temp_log" | head -20
            fi
        fi
    fi
    
    local end_time=$(date +%s)
    TEST_DURATIONS["$test_name"]=$((end_time - start_time))
    ((TOTAL_TESTS++))
    
    rm -f "$temp_log"
}

run_test_category() {
    local category="$1"
    
    if [[ ! "${TEST_SUITES[$category]+exists}" ]]; then
        log_error "Unknown test category: $category"
        log_info "Available categories: ${AVAILABLE_CATEGORIES[*]}"
        return 1
    fi
    
    log_info "🧪 Running $category tests"
    
    local test_files="${TEST_SUITES[$category]}"
    for test_file in $test_files; do
        run_test_file "$test_file"
    done
}

run_all_tests() {
    log_info "🔬 Running All Modular Library Tests"
    
    for category in core evolution integration analysis template; do
        if [[ "${TEST_SUITES[$category]+exists}" ]]; then
            run_test_category "$category"
        fi
    done
}

run_performance_tests() {
    log_info "⚡ Running Performance Tests"
    
    # Test bootstrap performance
    log_info "Testing bootstrap performance..."
    local start_time=$(date +%s%N)
    for i in {1..10}; do
        (
            source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
            require_module "core/logger"
        ) >/dev/null 2>&1
    done
    local end_time=$(date +%s%N)
    local duration=$(((end_time - start_time) / 1000000))
    log_info "Bootstrap performance: ${duration}ms for 10 iterations"
    
    # Test large file processing
    log_info "Testing large file processing..."
    local temp_file=$(mktemp)
    head -c 1M </dev/urandom > "$temp_file"
    
    start_time=$(date +%s)
    source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
    require_module "core/utils"
    utils_process_file "$temp_file" >/dev/null 2>&1 || true
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    log_info "Large file processing: ${duration}s for 1MB file"
    
    rm -f "$temp_file"
}

run_security_tests() {
    log_info "🔒 Running Security Tests"
    
    # Test for potential security issues in modules
    log_info "Scanning for potential security issues..."
    
    local security_issues=0
    
    # Check for hardcoded secrets
    if grep -r "password\|secret\|key" "$PROJECT_ROOT/src/lib" --include="*.sh" | grep -v "# @" >/dev/null; then
        log_warn "Potential hardcoded secrets found in library files"
        ((security_issues++))
    fi
    
    # Check for unsafe eval usage
    if grep -r "eval\|exec" "$PROJECT_ROOT/src/lib" --include="*.sh" >/dev/null; then
        log_warn "Potentially unsafe eval/exec usage found"
        ((security_issues++))
    fi
    
    # Check for unsafe file operations
    if grep -r "rm -rf \$" "$PROJECT_ROOT/src/lib" --include="*.sh" >/dev/null; then
        log_warn "Potentially unsafe rm -rf usage found"
        ((security_issues++))
    fi
    
    if [[ $security_issues -eq 0 ]]; then
        log_success "No obvious security issues detected"
    else
        log_warn "Found $security_issues potential security issues"
    fi
}

generate_coverage_report() {
    log_header "Generating Test Coverage Report"
    
    local coverage_dir="$TEST_DIR/coverage"
    mkdir -p "$coverage_dir"
    
    # Analyze which modules were tested
    local modules_dir="$PROJECT_ROOT/src/lib"
    local total_modules=0
    local tested_modules=0
    
    while IFS= read -r module_file; do
        ((total_modules++))
        local module_name=$(basename "$module_file" .sh)
        local module_path=$(echo "$module_file" | sed "s|$modules_dir/||")
        
        # Check if there's a test for this module
        local test_pattern="test_${module_name}.sh"
        if find "$TEST_DIR" -name "$test_pattern" | grep -q .; then
            ((tested_modules++))
            echo "✓ $module_path" >> "$coverage_dir/tested_modules.txt"
        else
            echo "✗ $module_path" >> "$coverage_dir/untested_modules.txt"
        fi
    done < <(find "$modules_dir" -name "*.sh" -type f)
    
    local coverage_percentage=$(( (tested_modules * 100) / total_modules ))
    
    # Generate coverage report
    cat > "$coverage_dir/coverage_report.md" << EOF
# Test Coverage Report

Generated: $(date)

## Summary
- Total modules: $total_modules
- Tested modules: $tested_modules
- Coverage: $coverage_percentage%

## Test Results
- Total tests run: $TOTAL_TESTS
- Passed: $PASSED_TESTS
- Failed: $FAILED_TESTS
- Skipped: $SKIPPED_TESTS

## Module Coverage
### Tested Modules
$(cat "$coverage_dir/tested_modules.txt" 2>/dev/null || echo "None")

### Untested Modules
$(cat "$coverage_dir/untested_modules.txt" 2>/dev/null || echo "None")

## Recommendations
EOF
    
    if [[ $coverage_percentage -lt 80 ]]; then
        echo "- Increase test coverage to at least 80%" >> "$coverage_dir/coverage_report.md"
    fi
    
    if [[ $FAILED_TESTS -gt 0 ]]; then
        echo "- Fix failing tests before production deployment" >> "$coverage_dir/coverage_report.md"
    fi
    
    log_info "Coverage report generated: $coverage_dir/coverage_report.md"
    log_info "Module coverage: $coverage_percentage% ($tested_modules/$total_modules)"
}

display_results() {
    log_header "Test Results Summary"
    
    # Display overall results
    log_info "Total tests: $TOTAL_TESTS"
    log_success "Passed: $PASSED_TESTS"
    if [[ $FAILED_TESTS -gt 0 ]]; then
        log_error "Failed: $FAILED_TESTS"
    else
        log_info "Failed: $FAILED_TESTS"
    fi
    if [[ $SKIPPED_TESTS -gt 0 ]]; then
        log_warn "Skipped: $SKIPPED_TESTS"
    else
        log_info "Skipped: $SKIPPED_TESTS"
    fi
    
    # Display individual test results
    log_info "Individual Test Results:"
    for test_name in "${!TEST_RESULTS[@]}"; do
        local result="${TEST_RESULTS[$test_name]}"
        local duration="${TEST_DURATIONS[$test_name]:-0}"
        
        case "$result" in
            "PASSED")
                log_success "  ✓ $test_name (${duration}s)"
                ;;
            "FAILED")
                log_error "  ✗ $test_name (${duration}s)"
                ;;
            "SKIPPED")
                log_warn "  - $test_name (skipped)"
                ;;
        esac
    done
    
    # Calculate success rate
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        local success_rate=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
        log_info "Success rate: $success_rate%"
        
        if [[ $success_rate -eq 100 ]]; then
            log_success "🎉 All tests passed!"
        elif [[ $success_rate -ge 90 ]]; then
            log_success "✅ Excellent test results!"
        elif [[ $success_rate -ge 80 ]]; then
            log_warn "⚠️  Good test results, but some improvements needed"
        else
            log_error "❌ Poor test results, significant improvements needed"
        fi
    fi
}

# Main execution
main() {
    log_header "Modular Library Test Runner"
    log_info "Test category: $TEST_CATEGORY"
    log_info "Verbose mode: $VERBOSE_MODE"
    log_info "Coverage mode: $COVERAGE_MODE"
    log_info "Parallel mode: $PARALLEL_MODE"
    
    # Validate test category
    if [[ ! " ${AVAILABLE_CATEGORIES[*]} " =~ " ${TEST_CATEGORY} " ]]; then
        log_error "Invalid test category: $TEST_CATEGORY"
        log_info "Available categories: ${AVAILABLE_CATEGORIES[*]}"
        exit 1
    fi
    
    # Create test logs directory
    mkdir -p "$TEST_DIR/logs"
    
    # Run tests based on category
    case "$TEST_CATEGORY" in
        "all")
            run_all_tests
            if [[ "$COVERAGE_MODE" == "true" ]]; then
                run_performance_tests
                run_security_tests
            fi
            ;;
        "performance")
            run_performance_tests
            ;;
        "security")
            run_security_tests
            ;;
        *)
            run_test_category "$TEST_CATEGORY"
            ;;
    esac
    
    # Generate coverage report if requested
    if [[ "$COVERAGE_MODE" == "true" ]]; then
        generate_coverage_report
    fi
    
    # Display results
    display_results
    
    # Exit with appropriate code
    if [[ $FAILED_TESTS -eq 0 ]]; then
        log_success "All tests completed successfully!"
        exit 0
    else
        log_error "Some tests failed!"
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
