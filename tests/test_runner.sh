#!/bin/bash
#
# @file tests/test_runner.sh
# @description Comprehensive testing framework for AI Evolution Engine with category-specific artifacts
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - #test-framework-reorganization: Category-specific artifact management
#   - #comprehensive-testing: Multi-category test execution
#
# @relatedEvolutions
#   - v2.0.0: Major restructure for category-specific artifact storage
#   - v1.0.0: Initial implementation with basic test runner
#
# @dependencies
#   - bash: >=4.0
#   - find: for test discovery
#   - jq: for JSON processing (optional)
#
# @changelog
#   - 2025-07-05: Restructured for category-specific artifacts - ITJ
#   - 2025-07-05: Enhanced with proper DFF error handling - ITJ
#
# @usage ./test_runner.sh [OPTIONS]
# @notes Comprehensive testing framework following DFF principles
#

# AI Evolution Engine - Test Runner
# Comprehensive testing framework following DFF principles
# Version: 2.0.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VERBOSE=false
TEST_TYPE="all"
FAIL_FAST=false

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

fail() {
    echo -e "${RED}✗${NC} $1"
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -t|--type)
                TEST_TYPE="$2"
                shift 2
                ;;
            --fail-fast)
                FAIL_FAST=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help message
show_help() {
    cat << EOF
AI Evolution Engine Test Runner

Usage: $0 [OPTIONS]

Options:
    -v, --verbose       Enable verbose output
    -t, --type TYPE     Run specific test type (unit|integration|workflow|all)
    --fail-fast         Stop on first failure
    -h, --help          Show this help message

Test Types:
    unit                Run unit tests only
    integration         Run integration tests only
    workflow            Run GitHub Actions workflow tests only
    all                 Run all tests (default)

Examples:
    $0                          # Run all tests
    $0 --verbose               # Run all tests with verbose output
    $0 -t unit                 # Run only unit tests
    $0 -t workflow             # Run only workflow tests
    $0 --fail-fast             # Stop on first failure
EOF
}

# Run a single test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local test_type="${3:-unit}"
    
    ((TESTS_RUN++))
    
    if [[ "$VERBOSE" == true ]]; then
        info "Running test: $test_name"
    fi
    
    if eval "$test_command" &>/dev/null; then
        ((TESTS_PASSED++))
        success "$test_name"
        return 0
    else
        ((TESTS_FAILED++))
        fail "$test_name"
        
        if [[ "$VERBOSE" == true ]]; then
            error "Command failed: $test_command"
            # Show actual error output in verbose mode
            eval "$test_command" || true
        fi
        
        if [[ "$FAIL_FAST" == true ]]; then
            error "Failing fast due to --fail-fast option"
            exit 1
        fi
        
        return 1
    fi
}

# Test project structure
test_project_structure() {
    log "Testing project structure..."
    
    run_test "README.md exists" "test -f '$PROJECT_ROOT/README.md'"
    run_test "LICENSE exists" "test -f '$PROJECT_ROOT/LICENSE' || test -f '$PROJECT_ROOT/LICENSE.md'"
    run_test "scripts directory exists" "test -d '$PROJECT_ROOT/scripts'"
    run_test "tests directory exists" "test -d '$PROJECT_ROOT/tests'"
    run_test "src directory exists" "test -d '$PROJECT_ROOT/src'"
    run_test "docs directory exists" "test -d '$PROJECT_ROOT/docs'"
    run_test ".gitignore exists" "test -f '$PROJECT_ROOT/.gitignore'"
    run_test ".gptignore exists" "test -f '$PROJECT_ROOT/.gptignore'"
}

# Test scripts are executable
test_script_permissions() {
    log "Testing script permissions..."
    
    while IFS= read -r -d '' script; do
        script_name=$(basename "$script")
        run_test "Script $script_name is executable" "test -x '$script'"
    done < <(find "$PROJECT_ROOT/scripts" -name "*.sh" -print0 2>/dev/null || true)
}

# Test JSON files are valid
test_json_validity() {
    log "Testing JSON file validity..."
    
    while IFS= read -r -d '' json_file; do
        json_name=$(basename "$json_file")
        run_test "JSON file $json_name is valid" "jq empty '$json_file'"
    done < <(find "$PROJECT_ROOT" -name "*.json" -not -path "*/node_modules/*" -print0 2>/dev/null || true)
}

# Test YAML files are valid
test_yaml_validity() {
    log "Testing YAML file validity..."
    
    while IFS= read -r -d '' yaml_file; do
        yaml_name=$(basename "$yaml_file")
        run_test "YAML file $yaml_name is valid" "python3 -c 'import yaml, sys; yaml.safe_load(open(sys.argv[1]))' '$yaml_file'"
    done < <(find "$PROJECT_ROOT" -name "*.yml" -o -name "*.yaml" -not -path "*/node_modules/*" -print0 2>/dev/null || true)
}

# Test shell scripts syntax
test_shell_syntax() {
    log "Testing shell script syntax..."
    
    while IFS= read -r -d '' script; do
        script_name=$(basename "$script")
        run_test "Shell script $script_name has valid syntax" "bash -n '$script'"
    done < <(find "$PROJECT_ROOT" -name "*.sh" -not -path "*/node_modules/*" -print0 2>/dev/null || true)
}

# Run unit tests
run_unit_tests() {
    log "Running unit tests..."
    
    test_project_structure
    test_script_permissions
    test_json_validity
    test_yaml_validity
    test_shell_syntax
    
    # Check if there are custom unit test files
    if [[ -d "$PROJECT_ROOT/tests/unit" ]]; then
        while IFS= read -r -d '' test_file; do
            test_name=$(basename "$test_file" .sh)
            run_test "Unit test: $test_name" "bash '$test_file'"
        done < <(find "$PROJECT_ROOT/tests/unit" -name "*.sh" -print0 2>/dev/null || true)
    fi
}

# Run integration tests
run_integration_tests() {
    log "Running integration tests..."
    
    # Check if there are custom integration test files
    if [[ -d "$PROJECT_ROOT/tests/integration" ]]; then
        while IFS= read -r -d '' test_file; do
            test_name=$(basename "$test_file" .sh)
            run_test "Integration test: $test_name" "bash '$test_file'"
        done < <(find "$PROJECT_ROOT/tests/integration" -name "*.sh" -print0 2>/dev/null || true)
    else
        info "No integration tests found in tests/integration/"
    fi
}

# Run workflow tests
run_workflow_tests() {
    log "Running GitHub Actions workflow tests..."
    
    # Check if workflow test runner exists
    local workflow_test_runner="$PROJECT_ROOT/tests/workflow_test_runner.sh"
    if [[ -f "$workflow_test_runner" ]]; then
        run_test "GitHub Actions workflows" "bash '$workflow_test_runner'"
    else
        warn "Workflow test runner not found: $workflow_test_runner"
        # Fallback to basic workflow validation
        test_yaml_validity
    fi
}

# Show test results
show_results() {
    echo
    log "Test Results Summary:"
    echo "  Tests run: $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo "  Success rate: $(( TESTS_PASSED * 100 / TESTS_RUN ))%"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        success "All tests passed! 🎉"
        return 0
    else
        error "$TESTS_FAILED test(s) failed"
        return 1
    fi
}

# Main execution
main() {
    parse_args "$@"
    
    info "AI Evolution Engine Test Runner v1.0.0"
    info "Project root: $PROJECT_ROOT"
    info "Test type: $TEST_TYPE"
    info "Verbose: $VERBOSE"
    echo
    
    case "$TEST_TYPE" in
        unit)
            run_unit_tests
            ;;
        integration)
            run_integration_tests
            ;;
        workflow)
            run_workflow_tests
            ;;
        all)
            run_unit_tests
            run_integration_tests
            run_workflow_tests
            ;;
        *)
            error "Invalid test type: $TEST_TYPE"
            show_help
            exit 1
            ;;
    esac
    
    show_results
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
