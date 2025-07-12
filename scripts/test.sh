#!/bin/bash
#
# @file scripts/test.sh
# @description Consolidated test script for AI Evolution Engine
# @author AI Evolution Engine Team
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 3.0.0
#
# @relatedIssues 
#   - Repository cleanup and refactoring
#
# @relatedEvolutions
#   - v3.0.0: Consolidated test script combining multiple test scripts
#
# @dependencies
#   - bash: >=4.0
#   - jq: JSON processing
#
# @changelog
#   - 2025-07-12: Initial creation of consolidated test script - AEE
#
# @usage ./scripts/test.sh [options]
# @notes Runs comprehensive tests for AI Evolution Engine
#

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEST_DIR="$PROJECT_ROOT/tests"
RESULTS_DIR="$TEST_DIR/results"
LOGS_DIR="$TEST_DIR/logs"

# Default values
TEST_TYPE="all"
VERBOSE="false"
DRY_RUN="false"
OUTPUT_FORMAT="text"
SAVE_RESULTS="true"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Test results tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Show help message
show_help() {
    cat << EOF
🧪 AI Evolution Engine - Test Script

DESCRIPTION:
    Runs comprehensive tests for the AI Evolution Engine.
    Tests scripts, workflows, and functionality.

USAGE:
    $0 [OPTIONS] [TEST_TYPE]

TEST TYPES:
    all              Run all tests (default)
    scripts          Test script functionality
    workflows        Test workflow execution
    integration      Test integration scenarios
    unit             Run unit tests
    validation       Test validation functions
    help             Show this help message

OPTIONS:
    -v, --verbose          Enable verbose output
    -d, --dry-run          Show what would be tested without executing
    -f, --format FORMAT    Output format (text, json, html) [default: text]
    --no-save             Don't save test results
    -h, --help            Show this help message

EXAMPLES:
    # Run all tests
    $0

    # Test only scripts
    $0 scripts

    # Run with verbose output
    $0 -v all

    # Generate JSON report
    $0 -f json all

TEST FEATURES:
    ✅ Script functionality testing
    ✅ Workflow execution testing
    ✅ Integration scenario testing
    ✅ Unit test execution
    ✅ Validation function testing
    ✅ Multiple output formats
    ✅ Comprehensive reporting

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE="true"
                shift
                ;;
            -d|--dry-run)
                DRY_RUN="true"
                shift
                ;;
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            --no-save)
                SAVE_RESULTS="false"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            all|scripts|workflows|integration|unit|validation|help)
                TEST_TYPE="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Initialize test environment
init_test_env() {
    log_info "Initializing test environment..."
    
    # Create test directories
    mkdir -p "$RESULTS_DIR" "$LOGS_DIR"
    
    # Reset test counters
    TOTAL_TESTS=0
    PASSED_TESTS=0
    FAILED_TESTS=0
    SKIPPED_TESTS=0
    
    log_success "Test environment initialized"
}

# Test result tracking
record_test_result() {
    local test_name="$1"
    local result="$2"
    local message="${3:-}"
    
    ((TOTAL_TESTS++))
    
    case "$result" in
        "pass")
            ((PASSED_TESTS++))
            log_success "✅ $test_name: $message"
            ;;
        "fail")
            ((FAILED_TESTS++))
            log_error "❌ $test_name: $message"
            ;;
        "skip")
            ((SKIPPED_TESTS++))
            log_warning "⏭️  $test_name: $message"
            ;;
    esac
}

# Test script functionality
test_scripts() {
    log_info "Testing script functionality..."
    
    local scripts_to_test=(
        "evolve.sh:Main evolution script"
        "setup.sh:Setup script"
        "test.sh:Test script"
    )
    
    for script_info in "${scripts_to_test[@]}"; do
        IFS=':' read -r script_name description <<< "$script_info"
        local script_path="$PROJECT_ROOT/scripts/$script_name"
        
        if [[ -f "$script_path" ]]; then
            if [[ -x "$script_path" ]]; then
                # Test script syntax
                if bash -n "$script_path" 2>/dev/null; then
                    record_test_result "$script_name" "pass" "Syntax valid"
                else
                    record_test_result "$script_name" "fail" "Syntax error"
                fi
                
                # Test help functionality
                if timeout 10s bash "$script_path" --help >/dev/null 2>&1; then
                    record_test_result "$script_name help" "pass" "Help works"
                else
                    record_test_result "$script_name help" "fail" "Help failed"
                fi
            else
                record_test_result "$script_name" "fail" "Not executable"
            fi
        else
            record_test_result "$script_name" "skip" "File not found"
        fi
    done
}

# Test workflow execution
test_workflows() {
    log_info "Testing workflow execution..."
    
    local workflows_to_test=(
        "ai_evolver.yml:Main evolution workflow"
        "daily_evolution.yml:Daily maintenance workflow"
    )
    
    for workflow_info in "${workflows_to_test[@]}"; do
        IFS=':' read -r workflow_name description <<< "$workflow_info"
        local workflow_path="$PROJECT_ROOT/.github/workflows/$workflow_name"
        
        if [[ -f "$workflow_path" ]]; then
            # Test YAML syntax
            if command -v yamllint >/dev/null 2>&1; then
                if yamllint "$workflow_path" >/dev/null 2>&1; then
                    record_test_result "$workflow_name" "pass" "YAML syntax valid"
                else
                    record_test_result "$workflow_name" "fail" "YAML syntax error"
                fi
            else
                # Basic YAML check
                if grep -q "name:" "$workflow_path" && grep -q "on:" "$workflow_path"; then
                    record_test_result "$workflow_name" "pass" "Basic structure valid"
                else
                    record_test_result "$workflow_name" "fail" "Invalid workflow structure"
                fi
            fi
        else
            record_test_result "$workflow_name" "skip" "File not found"
        fi
    done
}

# Test integration scenarios
test_integration() {
    log_info "Testing integration scenarios..."
    
    # Test evolution cycle
    if [[ "$DRY_RUN" == "true" ]]; then
        record_test_result "evolution-cycle" "skip" "Dry run mode"
    else
        if timeout 30s bash "$PROJECT_ROOT/scripts/evolve.sh" context >/dev/null 2>&1; then
            record_test_result "evolution-cycle" "pass" "Context collection works"
        else
            record_test_result "evolution-cycle" "fail" "Context collection failed"
        fi
    fi
    
    # Test setup script
    if [[ "$DRY_RUN" == "true" ]]; then
        record_test_result "setup-script" "skip" "Dry run mode"
    else
        if timeout 30s bash "$PROJECT_ROOT/scripts/setup.sh" --no-deps --no-prereqs >/dev/null 2>&1; then
            record_test_result "setup-script" "pass" "Setup script works"
        else
            record_test_result "setup-script" "fail" "Setup script failed"
        fi
    fi
}

# Test unit functionality
test_unit() {
    log_info "Testing unit functionality..."
    
    # Test JSON processing
    if command -v jq >/dev/null 2>&1; then
        if echo '{"test": "value"}' | jq -r '.test' 2>/dev/null | grep -q "value"; then
            record_test_result "json-processing" "pass" "JSON processing works"
        else
            record_test_result "json-processing" "fail" "JSON processing failed"
        fi
    else
        record_test_result "json-processing" "skip" "jq not available"
    fi
    
    # Test git functionality
    if git rev-parse --git-dir >/dev/null 2>&1; then
        record_test_result "git-repository" "pass" "Git repository detected"
    else
        record_test_result "git-repository" "skip" "Not in git repository"
    fi
    
    # Test file operations
    local test_file="$TEST_DIR/test-temp.txt"
    if echo "test" > "$test_file" 2>/dev/null; then
        if [[ -f "$test_file" ]]; then
            record_test_result "file-operations" "pass" "File operations work"
            rm -f "$test_file"
        else
            record_test_result "file-operations" "fail" "File creation failed"
        fi
    else
        record_test_result "file-operations" "fail" "File operations failed"
    fi
}

# Test validation functions
test_validation() {
    log_info "Testing validation functions..."
    
    # Test essential files exist
    local essential_files=("README.md" "scripts/evolve.sh" ".gitignore")
    for file in "${essential_files[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            record_test_result "file-exists-$file" "pass" "File exists"
        else
            record_test_result "file-exists-$file" "fail" "File missing"
        fi
    done
    
    # Test directory structure
    local required_dirs=("scripts" "src" "tests")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PROJECT_ROOT/$dir" ]]; then
            record_test_result "dir-exists-$dir" "pass" "Directory exists"
        else
            record_test_result "dir-exists-$dir" "fail" "Directory missing"
        fi
    done
    
    # Test script permissions
    if [[ -x "$PROJECT_ROOT/scripts/evolve.sh" ]]; then
        record_test_result "script-permissions" "pass" "Scripts are executable"
    else
        record_test_result "script-permissions" "fail" "Scripts not executable"
    fi
}

# Generate test report
generate_report() {
    local report_file="$RESULTS_DIR/test-report-$(date +%Y%m%d-%H%M%S)"
    
    case "$OUTPUT_FORMAT" in
        "json")
            cat > "${report_file}.json" << EOF
{
  "test_summary": {
    "total_tests": $TOTAL_TESTS,
    "passed": $PASSED_TESTS,
    "failed": $FAILED_TESTS,
    "skipped": $SKIPPED_TESTS,
    "success_rate": $((PASSED_TESTS * 100 / TOTAL_TESTS))
  },
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "test_type": "$TEST_TYPE"
}
EOF
            log_info "JSON report saved: ${report_file}.json"
            ;;
        "html")
            cat > "${report_file}.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>AI Evolution Engine Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .summary { background: #f5f5f5; padding: 15px; border-radius: 5px; }
        .pass { color: green; }
        .fail { color: red; }
        .skip { color: orange; }
    </style>
</head>
<body>
    <h1>AI Evolution Engine Test Report</h1>
    <div class="summary">
        <h2>Summary</h2>
        <p>Total Tests: $TOTAL_TESTS</p>
        <p class="pass">Passed: $PASSED_TESTS</p>
        <p class="fail">Failed: $FAILED_TESTS</p>
        <p class="skip">Skipped: $SKIPPED_TESTS</p>
        <p>Success Rate: $((PASSED_TESTS * 100 / TOTAL_TESTS))%</p>
    </div>
    <p>Generated: $(date)</p>
</body>
</html>
EOF
            log_info "HTML report saved: ${report_file}.html"
            ;;
        *)
            # Text format (default)
            cat > "${report_file}.txt" << EOF
AI Evolution Engine Test Report
================================

Test Type: $TEST_TYPE
Generated: $(date)

Summary:
- Total Tests: $TOTAL_TESTS
- Passed: $PASSED_TESTS
- Failed: $FAILED_TESTS
- Skipped: $SKIPPED_TESTS
- Success Rate: $((PASSED_TESTS * 100 / TOTAL_TESTS))%

EOF
            log_info "Text report saved: ${report_file}.txt"
            ;;
    esac
}

# Print test summary
print_summary() {
    echo
    echo "🧪 Test Summary"
    echo "==============="
    echo "Total Tests: $TOTAL_TESTS"
    echo "Passed: $PASSED_TESTS"
    echo "Failed: $FAILED_TESTS"
    echo "Skipped: $SKIPPED_TESTS"
    
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        echo "Success Rate: ${success_rate}%"
        
        if [[ $success_rate -eq 100 ]]; then
            log_success "🎉 All tests passed!"
        elif [[ $success_rate -ge 80 ]]; then
            log_success "✅ Most tests passed"
        else
            log_error "❌ Many tests failed"
        fi
    fi
}

# Main test execution
main() {
    log_info "🧪 AI Evolution Engine Test Suite v3.0.0"
    log_info "Test Type: $TEST_TYPE"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No tests will be executed"
    fi
    
    init_test_env
    
    case "$TEST_TYPE" in
        "all")
            test_scripts
            test_workflows
            test_integration
            test_unit
            test_validation
            ;;
        "scripts")
            test_scripts
            ;;
        "workflows")
            test_workflows
            ;;
        "integration")
            test_integration
            ;;
        "unit")
            test_unit
            ;;
        "validation")
            test_validation
            ;;
        "help")
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown test type: $TEST_TYPE"
            show_help
            exit 1
            ;;
    esac
    
    print_summary
    
    if [[ "$SAVE_RESULTS" == "true" ]]; then
        generate_report
    fi
    
    # Exit with appropriate code
    if [[ $FAILED_TESTS -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Parse arguments and execute
parse_arguments "$@"
main "$@" 