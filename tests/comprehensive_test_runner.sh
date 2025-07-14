#!/bin/bash
#
# @file tests/comprehensive_test_runner.sh
# @description Enhanced comprehensive test automation framework with AI integration
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-14
# @lastModified 2025-07-14
# @version 1.0.0
#
# @relatedIssues 
#   - Comprehensive test automation framework implementation
#   - Integration with AI analysis and GitHub issue creation
#
# @relatedEvolutions
#   - v1.0.0: Initial comprehensive test framework with AI integration
#
# @dependencies
#   - bash: >=4.0
#   - jq: for JSON processing
#   - find: for test discovery
#
# @changelog
#   - 2025-07-14: Initial creation with comprehensive test execution and reporting - ITJ
#
# @usage ./comprehensive_test_runner.sh [options]
# @notes Runs all tests and generates comprehensive reports for AI analysis
#

set -euo pipefail

# Script configuration
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
VERSION="1.0.0"
VERBOSE=false
CREATE_ISSUES=false
HUMAN_REPORTS=false
OUTPUT_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="$OUTPUT_DIR/comprehensive_results_${TIMESTAMP}.json"

# Test tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0
START_TIME=""
END_TIME=""

# Test results array
TEST_RESULTS=()

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
║           Comprehensive Test Automation Framework            ║
║              AI-Powered Test Analysis & Reporting            ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${BLUE}Version: $VERSION${NC}"
    echo ""
}

# Initialize output directory
init_output() {
    mkdir -p "$OUTPUT_DIR"
    START_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
}

# Add test result to tracking
add_test_result() {
    local test_name="$1"
    local test_category="$2"
    local test_status="$3"
    local test_duration="$4"
    local test_output="$5"
    local test_error="${6:-}"
    
    local test_result=$(cat << EOF
{
  "test_name": "$test_name",
  "category": "$test_category", 
  "status": "$test_status",
  "duration": $test_duration,
  "output": $(echo "$test_output" | jq -Rs .),
  "error": $(echo "$test_error" | jq -Rs .),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
    
    TEST_RESULTS+=("$test_result")
    
    case "$test_status" in
        "passed")
            ((PASSED_TESTS++))
            ;;
        "failed")
            ((FAILED_TESTS++))
            ;;
        "skipped")
            ((SKIPPED_TESTS++))
            ;;
    esac
    
    ((TOTAL_TESTS++))
}

# Execute a single test with comprehensive tracking
execute_test() {
    local test_file="$1"
    local test_category="$2"
    local test_name="$(basename "$test_file")"
    
    info "Executing $test_category test: $test_name"
    
    local start_time=$(date +%s)
    local temp_output=$(mktemp)
    local temp_error=$(mktemp)
    local exit_code=0
    
    # Make test executable if it isn't
    chmod +x "$test_file" 2>/dev/null || true
    
    # Run test with timeout and capture output
    if timeout 300 bash "$test_file" >"$temp_output" 2>"$temp_error"; then
        local test_status="passed"
        success "$test_name completed successfully"
    else
        exit_code=$?
        if [[ $exit_code -eq 124 ]]; then
            local test_status="failed"
            echo "Test timed out after 300 seconds" >> "$temp_error"
            fail "$test_name timed out"
        else
            local test_status="failed"
            fail "$test_name failed with exit code $exit_code"
        fi
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    local test_output=$(cat "$temp_output")
    local test_error=$(cat "$temp_error")
    
    # Add to results
    add_test_result "$test_name" "$test_category" "$test_status" "$duration" "$test_output" "$test_error"
    
    # Show output if verbose or if failed
    if [[ "$VERBOSE" == "true" ]] || [[ "$test_status" == "failed" ]]; then
        if [[ -n "$test_output" ]]; then
            echo "Output:"
            echo "$test_output" | head -20
        fi
        if [[ -n "$test_error" ]]; then
            echo "Errors:"
            echo "$test_error" | head -10
        fi
    fi
    
    # Cleanup
    rm -f "$temp_output" "$temp_error"
    
    return 0
}

# Discover and run unit tests
run_unit_tests() {
    header "Running Unit Tests"
    
    local test_files=()
    local test_dirs=("$SCRIPT_DIR/unit")
    
    for test_dir in "${test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -type f -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No unit tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        execute_test "$test_file" "unit"
    done
}

# Discover and run integration tests
run_integration_tests() {
    header "Running Integration Tests"
    
    local test_files=()
    local test_dirs=("$SCRIPT_DIR/integration")
    
    for test_dir in "${test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -type f -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No integration tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        execute_test "$test_file" "integration"
    done
}

# Run workflow tests
run_workflow_tests() {
    header "Running Workflow Tests"
    
    local workflow_tests=(
        "$SCRIPT_DIR/workflows/test-all-workflows-local.sh"
        "$SCRIPT_DIR/workflows/test-daily-evolution-local.sh"
        "$SCRIPT_DIR/workflows/test-workflow.sh"
        "$SCRIPT_DIR/workflow_test_runner.sh"
    )
    
    local found_tests=false
    for test_file in "${workflow_tests[@]}"; do
        if [[ -f "$test_file" ]]; then
            found_tests=true
            execute_test "$test_file" "workflow"
        fi
    done
    
    if [[ "$found_tests" == "false" ]]; then
        warn "No workflow tests found"
    fi
}

# Run modular architecture tests
run_modular_tests() {
    header "Running Modular Architecture Tests"
    
    local modular_tests=(
        "$SCRIPT_DIR/comprehensive-modular-test.sh"
        "$SCRIPT_DIR/modular-architecture-test.sh"
        "$SCRIPT_DIR/lib/test-modular-library.sh"
        "$SCRIPT_DIR/comprehensive-refactoring-test.sh"
    )
    
    local found_tests=false
    for test_file in "${modular_tests[@]}"; do
        if [[ -f "$test_file" ]]; then
            found_tests=true
            execute_test "$test_file" "modular"
        fi
    done
    
    if [[ "$found_tests" == "false" ]]; then
        warn "No modular tests found"
    fi
}

# Run library tests
run_library_tests() {
    header "Running Library Tests"
    
    local lib_test_dirs=("$SCRIPT_DIR/lib")
    local test_files=()
    
    for test_dir in "${lib_test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -type f -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No library tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        execute_test "$test_file" "library"
    done
}

# Run seed tests  
run_seed_tests() {
    header "Running Seed Tests"
    
    local seed_test_dirs=("$SCRIPT_DIR/seed")
    local test_files=()
    
    for test_dir in "${seed_test_dirs[@]}"; do
        if [[ -d "$test_dir" ]]; then
            while IFS= read -r -d '' test_file; do
                test_files+=("$test_file")
            done < <(find "$test_dir" -name "*.sh" -type f -print0)
        fi
    done
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        warn "No seed tests found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        execute_test "$test_file" "seed"
    done
}

# Generate comprehensive test results
generate_results() {
    END_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    local success_rate=0
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        success_rate=$(echo "scale=2; ($PASSED_TESTS * 100) / $TOTAL_TESTS" | bc -l)
    fi
    
    info "Generating comprehensive test results"
    
    # Build JSON test results array
    local test_results_json="["
    local first=true
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            test_results_json+=","
        fi
        test_results_json+="$result"
    done
    test_results_json+="]"
    
    # Generate complete results file
    cat > "$RESULTS_FILE" << EOF
{
  "metadata": {
    "framework_version": "$VERSION",
    "execution_id": "test_run_${TIMESTAMP}",
    "start_time": "$START_TIME",
    "end_time": "$END_TIME",
    "duration_seconds": $(( $(date -d "$END_TIME" +%s) - $(date -d "$START_TIME" +%s) )),
    "hostname": "$(hostname)",
    "working_directory": "$PROJECT_ROOT"
  },
  "summary": {
    "total_tests": $TOTAL_TESTS,
    "passed_tests": $PASSED_TESTS,
    "failed_tests": $FAILED_TESTS,
    "skipped_tests": $SKIPPED_TESTS,
    "success_rate": $success_rate
  },
  "test_results": $test_results_json,
  "categories": {
    "unit": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "unit")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "unit" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "unit" and .status == "failed")] | length')
    },
    "integration": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "integration")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "integration" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "integration" and .status == "failed")] | length')
    },
    "workflow": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "workflow")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "workflow" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "workflow" and .status == "failed")] | length')
    },
    "modular": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "modular")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "modular" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "modular" and .status == "failed")] | length')
    },
    "library": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "library")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "library" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "library" and .status == "failed")] | length')
    },
    "seed": {
      "total": $(echo "$test_results_json" | jq '[.[] | select(.category == "seed")] | length'),
      "passed": $(echo "$test_results_json" | jq '[.[] | select(.category == "seed" and .status == "passed")] | length'),
      "failed": $(echo "$test_results_json" | jq '[.[] | select(.category == "seed" and .status == "failed")] | length')
    }
  },
  "environment": {
    "shell": "$SHELL",
    "bash_version": "$BASH_VERSION",
    "path": "$PATH",
    "test_framework": "comprehensive_test_runner.sh v$VERSION"
  }
}
EOF
    
    success "Test results saved to: $RESULTS_FILE"
}

# Run AI analysis
run_ai_analysis() {
    if [[ -f "$SCRIPT_DIR/ai_test_analyzer.sh" ]]; then
        header "Running AI Analysis"
        
        local ai_options=""
        if [[ "$CREATE_ISSUES" == "true" ]]; then
            ai_options+=" --create-issue"
        fi
        if [[ "$HUMAN_REPORTS" == "true" ]]; then
            ai_options+=" --human-report"
        fi
        
        chmod +x "$SCRIPT_DIR/ai_test_analyzer.sh"
        "$SCRIPT_DIR/ai_test_analyzer.sh" "$RESULTS_FILE" $ai_options
    else
        warn "AI analyzer not found - skipping AI analysis"
    fi
}

# Show test summary
show_summary() {
    local success_rate=0
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        success_rate=$(echo "scale=1; ($PASSED_TESTS * 100) / $TOTAL_TESTS" | bc -l)
    fi
    
    echo ""
    header "Comprehensive Test Results Summary"
    echo "======================================"
    echo "Total Tests Executed: $TOTAL_TESTS"
    echo "Passed: $PASSED_TESTS"
    echo "Failed: $FAILED_TESTS"
    echo "Skipped: $SKIPPED_TESTS"
    echo "Success Rate: ${success_rate}%"
    echo ""
    echo "Results File: $RESULTS_FILE"
    echo "Execution Time: $(( $(date -d "$END_TIME" +%s) - $(date -d "$START_TIME" +%s) )) seconds"
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo ""
        success "All tests passed! 🎉"
        return 0
    else
        echo ""
        fail "$FAILED_TESTS test(s) failed"
        return 1
    fi
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [options]

Options:
  -v, --verbose         Enable verbose output
  -i, --create-issues   Create GitHub issues for failures
  -r, --human-reports   Generate human-readable reports
  -h, --help           Show this help

Examples:
  $0                               # Run all tests
  $0 --verbose --create-issues     # Run with verbose output and issue creation
  $0 --human-reports              # Run with human-readable report generation
EOF
}

# Main execution
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -i|--create-issues)
                CREATE_ISSUES=true
                shift
                ;;
            -r|--human-reports)
                HUMAN_REPORTS=true
                shift
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
    
    show_banner
    init_output
    
    info "Starting comprehensive test execution"
    info "Results will be saved to: $RESULTS_FILE"
    echo ""
    
    # Run all test categories
    run_unit_tests
    run_integration_tests  
    run_workflow_tests
    run_modular_tests
    run_library_tests
    run_seed_tests
    
    # Generate results and run analysis
    generate_results
    run_ai_analysis
    
    # Show summary and exit with appropriate code
    show_summary
}

# Execute main function
main "$@"