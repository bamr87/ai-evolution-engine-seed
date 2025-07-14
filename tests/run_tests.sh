#!/bin/bash
#
# @file tests/run_tests.sh
# @description Unified test management system for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 3.0.0
#
# @relatedIssues 
#   - #test-framework-consolidation: Unified test management system
#   - #test-framework-reorganization: Category-specific artifact management
#
# @relatedEvolutions
#   - v3.0.0: Complete consolidation of test runners into unified system
#   - v2.0.0: Category-specific artifact management
#   - v1.0.0: Initial testing framework
#
# @dependencies
#   - bash: >=4.0
#   - find: for test discovery
#   - jq: for JSON processing
#   - yq: for YAML processing
#
# @changelog
#   - 2025-07-05: Created unified test management system - ITJ
#
# @usage ./run_tests.sh [COMMAND] [OPTIONS]
# @notes Consolidates all test runners into a single comprehensive system
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
VERSION="3.0.0"
VERBOSE=false
FAIL_FAST=false
COVERAGE=false
PARALLEL=false
TEST_CATEGORY="all"
OUTPUT_FORMAT="text"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Test categories - using regular arrays for bash 3.2 compatibility
TEST_CATEGORIES=(
    "unit:Unit tests for individual components"
    "integration:Integration tests for system components"
    "workflow:GitHub Actions workflow tests"
    "modular:Modular library architecture tests"
    "performance:Performance and benchmarking tests"
    "security:Security and vulnerability tests"
    "all:All available tests"
)

# Available commands - using regular arrays for bash 3.2 compatibility
COMMANDS=(
    "run:Run tests"
    "list:List available tests"
    "clean:Clean test artifacts"
    "archive:Archive test results"
    "status:Show test status"
    "help:Show help information"
)

# Logging functions
header() { echo -e "${CYAN}$1${NC}"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Show banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                AI Evolution Engine Test Suite                ║
║                   Unified Test Management                     ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${BLUE}Version: $VERSION${NC}"
    echo ""
}

# Show usage information
show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
$(for cmd in "${COMMANDS[@]}"; do echo "  ${cmd%:*}         ${cmd#*:}"; done)

Test Categories:
$(for cat in "${TEST_CATEGORIES[@]}"; do echo "  ${cat%:*}         ${cat#*:}"; done)

Options:
  -v, --verbose       Enable verbose output
  -f, --fail-fast     Stop on first failure
  -c, --coverage      Generate coverage report
  -p, --parallel      Run tests in parallel
  -o, --output FORMAT Output format (text, json, html)
  -h, --help          Show this help

Examples:
  $0 run                      # Run all tests
  $0 run unit                 # Run unit tests only
  $0 run --verbose --coverage # Run with verbose output and coverage
  $0 list                     # List available tests
  $0 clean                    # Clean test artifacts
  $0 status                   # Show test status
EOF
}

# Parse command line arguments
parse_args() {
    local command=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            run|list|clean|archive|status|help)
                command="$1"
                shift
                ;;
            unit|integration|workflow|modular|performance|security|all)
                TEST_CATEGORY="$1"
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -f|--fail-fast)
                FAIL_FAST=true
                shift
                ;;
            -c|--coverage)
                COVERAGE=true
                shift
                ;;
            -p|--parallel)
                PARALLEL=true
                shift
                ;;
            -o|--output)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Default command is run
    if [[ -z "$command" ]]; then
        command="run"
    fi
    
    echo "$command"
}

# Run unit tests
run_unit_tests() {
    header "Running Unit Tests"
    
    local test_files=()
    local test_dirs=("$SCRIPT_DIR/unit")
    
    for test_dir in "${test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -executable -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No unit tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        run_test_file "$test_file" "unit"
    done
}

# Run integration tests
run_integration_tests() {
    header "Running Integration Tests"
    
    local test_files=()
    local test_dirs=("$SCRIPT_DIR/integration")
    
    for test_dir in "${test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -executable -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No integration tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        run_test_file "$test_file" "integration"
    done
}

# Run workflow tests
run_workflow_tests() {
    header "Running Workflow Tests"
    
    # Use the existing workflow test runner
    local workflow_runner="$SCRIPT_DIR/workflow_test_runner.sh"
    if [[ -f "$workflow_runner" ]]; then
        run_test_file "$workflow_runner" "workflow"
    else
        warn "Workflow test runner not found"
    fi
}

# Run modular architecture tests
run_modular_tests() {
    header "Running Modular Architecture Tests"
    
    local modular_tests=(
        "$SCRIPT_DIR/comprehensive-modular-test.sh"
        "$SCRIPT_DIR/modular-architecture-test.sh"
        "$SCRIPT_DIR/lib/test-modular-library.sh"
    )
    
    for test_file in "${modular_tests[@]}"; do
        if [[ -f "$test_file" ]]; then
            run_test_file "$test_file" "modular"
        fi
    done
}

# Run performance tests
run_performance_tests() {
    header "Running Performance Tests"
    
    info "Performance testing functionality"
    
    # Test bootstrap performance
    local start_time=$(date +%s%N)
    for i in {1..5}; do
        (
            source "$PROJECT_ROOT/src/lib/core/bootstrap.sh" 2>/dev/null || true
        ) >/dev/null 2>&1
    done
    local end_time=$(date +%s%N)
    local duration=$(((end_time - start_time) / 1000000))
    
    if [[ $duration -lt 1000 ]]; then
        success "Bootstrap performance: ${duration}ms (good)"
        ((TESTS_PASSED++))
    else
        fail "Bootstrap performance: ${duration}ms (slow)"
        ((TESTS_FAILED++))
    fi
    
    ((TESTS_RUN++))
}

# Run security tests
run_security_tests() {
    header "Running Security Tests"
    
    info "Security testing functionality"
    
    local security_issues=0
    
    # Check for hardcoded secrets
    if grep -r -l "password\|secret\|key" "$PROJECT_ROOT/src" --include="*.sh" 2>/dev/null | head -1 >/dev/null; then
        warn "Potential hardcoded secrets found"
        ((security_issues++))
    fi
    
    # Check for unsafe operations
    if grep -r -l "rm -rf \$\|eval \$" "$PROJECT_ROOT/src" --include="*.sh" 2>/dev/null | head -1 >/dev/null; then
        warn "Potentially unsafe operations found"
        ((security_issues++))
    fi
    
    if [[ $security_issues -eq 0 ]]; then
        success "No obvious security issues detected"
        ((TESTS_PASSED++))
    else
        fail "Found $security_issues potential security issues"
        ((TESTS_FAILED++))
    fi
    
    ((TESTS_RUN++))
}

# Run a single test file
run_test_file() {
    local test_file="$1"
    local test_type="${2:-unknown}"
    local test_name="$(basename "$test_file")"
    
    ((TESTS_RUN++))
    
    info "Running $test_type test: $test_name"
    
    local start_time=$(date +%s)
    local temp_log=$(mktemp)
    
    if [[ "$VERBOSE" == "true" ]]; then
        if bash "$test_file" 2>&1 | tee "$temp_log"; then
            success "$test_name completed"
            ((TESTS_PASSED++))
        else
            fail "$test_name failed"
            ((TESTS_FAILED++))
            if [[ "$FAIL_FAST" == "true" ]]; then
                error "Stopping due to --fail-fast option"
                rm -f "$temp_log"
                exit 1
            fi
        fi
    else
        if bash "$test_file" >"$temp_log" 2>&1; then
            success "$test_name completed"
            ((TESTS_PASSED++))
        else
            fail "$test_name failed"
            ((TESTS_FAILED++))
            if [[ "$VERBOSE" == "true" ]]; then
                error "Error output:"
                cat "$temp_log" | head -10
            fi
            if [[ "$FAIL_FAST" == "true" ]]; then
                rm -f "$temp_log"
                exit 1
            fi
        fi
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [[ "$VERBOSE" == "true" ]]; then
        info "  Duration: ${duration}s"
    fi
    
    rm -f "$temp_log"
}

# List available tests
list_tests() {
    header "Available Tests"
    
    echo "Unit Tests:"
    if [[ -d "$SCRIPT_DIR/unit" ]]; then
        find "$SCRIPT_DIR/unit" -name "*.sh" -executable | sort | while read -r test; do
            echo "  - $(basename "$test")"
        done
    fi
    
    echo -e "\nIntegration Tests:"
    if [[ -d "$SCRIPT_DIR/integration" ]]; then
        find "$SCRIPT_DIR/integration" -name "*.sh" -executable | sort | while read -r test; do
            echo "  - $(basename "$test")"
        done
    fi
    
    echo -e "\nWorkflow Tests:"
    if [[ -f "$SCRIPT_DIR/workflow_test_runner.sh" ]]; then
        echo "  - workflow_test_runner.sh"
    fi
    
    echo -e "\nModular Tests:"
    local modular_tests=(
        "comprehensive-modular-test.sh"
        "modular-architecture-test.sh"
        "lib/test-modular-library.sh"
    )
    for test in "${modular_tests[@]}"; do
        if [[ -f "$SCRIPT_DIR/$test" ]]; then
            echo "  - $test"
        fi
    done
}

# Clean test artifacts
clean_artifacts() {
    header "Cleaning Test Artifacts"
    
    if [[ -f "$SCRIPT_DIR/manage-test-artifacts.sh" ]]; then
        info "Using artifact management script"
        "$SCRIPT_DIR/manage-test-artifacts.sh" cleanup
    else
        info "Manual cleanup"
        find "$SCRIPT_DIR" -name "*.log" -o -name "*.tmp" -o -name "*.json" -type f -mtime +7 -delete 2>/dev/null || true
        success "Cleaned old artifacts"
    fi
}

# Archive test results
archive_results() {
    header "Archiving Test Results"
    
    if [[ -f "$SCRIPT_DIR/manage-test-artifacts.sh" ]]; then
        info "Using artifact management script"
        "$SCRIPT_DIR/manage-test-artifacts.sh" archive "test-run-$(date +%Y%m%d-%H%M%S)"
    else
        warn "Archive functionality requires manage-test-artifacts.sh"
    fi
}

# Show test status
show_status() {
    header "Test Framework Status"
    
    if [[ -f "$SCRIPT_DIR/manage-test-artifacts.sh" ]]; then
        "$SCRIPT_DIR/manage-test-artifacts.sh" status
    else
        info "Basic status information"
        echo "Test directories:"
        for dir in unit integration workflows lib; do
            if [[ -d "$SCRIPT_DIR/$dir" ]]; then
                local count=$(find "$SCRIPT_DIR/$dir" -name "*.sh" -perm +111 | wc -l)
                echo "  $dir: $count tests"
            fi
        done
    fi
}

# Generate test report
generate_report() {
    local success_rate=0
    if [[ $TESTS_RUN -gt 0 ]]; then
        success_rate=$(( (TESTS_PASSED * 100) / TESTS_RUN ))
    fi
    
    echo ""
    header "Test Results Summary"
    echo "Total Tests: $TESTS_RUN"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    echo "Skipped: $TESTS_SKIPPED"
    echo "Success Rate: $success_rate%"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo ""
        success "All tests passed! 🎉"
        return 0
    else
        echo ""
        fail "$TESTS_FAILED test(s) failed"
        return 1
    fi
}

# Main execution
main() {
    local command=$(parse_args "$@")
    
    case "$command" in
        run)
            show_banner
            info "Running tests - Category: $TEST_CATEGORY"
            echo ""
            
            case "$TEST_CATEGORY" in
                unit)
                    run_unit_tests
                    ;;
                integration)
                    run_integration_tests
                    ;;
                workflow)
                    run_workflow_tests
                    ;;
                modular)
                    run_modular_tests
                    ;;
                performance)
                    run_performance_tests
                    ;;
                security)
                    run_security_tests
                    ;;
                all)
                    run_unit_tests
                    run_integration_tests
                    run_workflow_tests
                    run_modular_tests
                    if [[ "$COVERAGE" == "true" ]]; then
                        run_performance_tests
                        run_security_tests
                    fi
                    ;;
                *)
                    error "Unknown test category: $TEST_CATEGORY"
                    exit 1
                    ;;
            esac
            
            generate_report
            ;;
        list)
            show_banner
            list_tests
            ;;
        clean)
            clean_artifacts
            ;;
        archive)
            archive_results
            ;;
        status)
            show_status
            ;;
        help)
            show_usage
            ;;
        *)
            error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Execute main function
main "$@" 