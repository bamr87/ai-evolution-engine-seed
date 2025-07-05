#!/bin/bash
# Testing framework for AI Evolution Engine
# Provides comprehensive testing utilities with AI-powered insights
# Version: 1.0.0

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/logger.sh"

# Test configuration
readonly TEST_FRAMEWORKS=("unit" "integration" "workflow" "e2e")

# Test directories (relative to project root or tests directory)
TEST_BASE_DIR=""
TEST_RESULTS_DIR=""
TEST_REPORTS_DIR=""
TEST_LOGS_DIR=""

# Test state tracking
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0
TEST_START_TIME=""
TEST_SESSION_ID=""
CURRENT_TEST_SUITE=""
FAIL_FAST=false

# Initialize testing framework
init_testing() {
    local session_name="${1:-evolution-test}"
    local base_dir="${2:-tests}"  # Default to tests directory
    
    TEST_SESSION_ID="${session_name}-$(date +%Y%m%d-%H%M%S)"
    TEST_START_TIME=$(date +%s)
    
    # Set up test directories structure
    TEST_BASE_DIR="$base_dir"
    TEST_RESULTS_DIR="$TEST_BASE_DIR/test-results"
    TEST_REPORTS_DIR="$TEST_BASE_DIR/test-reports" 
    TEST_LOGS_DIR="$TEST_BASE_DIR/test-logs"
    
    # Create test directories
    mkdir -p "$TEST_RESULTS_DIR" "$TEST_REPORTS_DIR" "$TEST_LOGS_DIR"
    
    # Initialize logger with test-specific log directory
    init_logger "$TEST_LOGS_DIR" "$TEST_SESSION_ID"
    
    log_info "Initialized testing session: $TEST_SESSION_ID"
    log_info "Test directories:"
    log_info "  Results: $TEST_RESULTS_DIR"
    log_info "  Reports: $TEST_REPORTS_DIR"
    log_info "  Logs: $TEST_LOGS_DIR"
    
    # Create session metadata
    cat > "$TEST_RESULTS_DIR/$TEST_SESSION_ID.json" << EOF
{
  "session_id": "$TEST_SESSION_ID",
  "start_time": "$(date -Iseconds)",
  "framework_version": "1.0.0",
  "environment": {
    "os": "$(uname -s)",
    "shell": "$SHELL",
    "ci": "${CI_ENVIRONMENT:-false}"
  },
  "suites": [],
  "summary": {
    "total": 0,
    "passed": 0,
    "failed": 0,
    "skipped": 0
  }
}
EOF
}

# Test runner functions
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-0}"
    local test_id="test-$(date +%s)-$RANDOM"
    
    ((TESTS_RUN++))
    
    log_debug "Running test: $test_name"
    log_debug "Command: $test_command"
    
    local start_time=$(date +%s)
    local result=0
    local output=""
    
    # Execute test with timeout and capture output
    if timeout 60s bash -c "$test_command" >/tmp/test-output-$test_id 2>&1; then
        result=0
        output=$(cat /tmp/test-output-$test_id)
    else
        result=$?
        output=$(cat /tmp/test-output-$test_id)
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Determine test result
    local status="unknown"
    if [[ $result -eq $expected_result ]]; then
        ((TESTS_PASSED++))
        status="passed"
        log_success "$test_name"
    else
        ((TESTS_FAILED++))
        status="failed"
        log_error "$test_name (exit code: $result, expected: $expected_result)"
        
        # Show output for failed tests
        if [[ -n "$output" ]]; then
            log_debug "Test output: $output"
        fi
        
        # Fail fast if enabled
        if [[ "$FAIL_FAST" == "true" ]]; then
            log_error "Failing fast due to test failure"
            finalize_testing
            exit 1
        fi
    fi
    
    # Record test result
    record_test_result "$test_id" "$test_name" "$test_command" "$status" "$result" "$duration" "$output"
    
    # Cleanup
    rm -f /tmp/test-output-$test_id
    
    return $result
}

# Record test results in JSON format
record_test_result() {
    local test_id="$1"
    local test_name="$2"
    local test_command="$3"
    local status="$4"
    local exit_code="$5"
    local duration="$6"
    local output="$7"
    
    local result_file="$TEST_RESULTS_DIR/test-$test_id.json"
    
    cat > "$result_file" << EOF
{
  "id": "$test_id",
  "name": "$test_name",
  "command": "$test_command",
  "status": "$status",
  "exit_code": $exit_code,
  "duration": $duration,
  "timestamp": "$(date -Iseconds)",
  "suite": "$CURRENT_TEST_SUITE",
  "session": "$TEST_SESSION_ID",
  "output": $(echo "$output" | jq -R -s .)
}
EOF
}

# Test suite management
start_test_suite() {
    local suite_name="$1"
    local description="${2:-$suite_name}"
    
    CURRENT_TEST_SUITE="$suite_name"
    log_info "Starting test suite: $suite_name"
    log_debug "Description: $description"
    
    # Reset suite counters
    SUITE_TESTS_RUN=0
    SUITE_TESTS_PASSED=0
    SUITE_TESTS_FAILED=0
    SUITE_START_TIME=$(date +%s)
}

end_test_suite() {
    local suite_end_time=$(date +%s)
    local suite_duration=$((suite_end_time - SUITE_START_TIME))
    
    log_info "Completed test suite: $CURRENT_TEST_SUITE"
    log_info "Suite results: $SUITE_TESTS_PASSED passed, $SUITE_TESTS_FAILED failed in ${suite_duration}s"
    
    CURRENT_TEST_SUITE=""
}

# Test assertions
assert_equal() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Values should be equal}"
    
    if [[ "$expected" == "$actual" ]]; then
        return 0
    else
        log_error "$message: expected '$expected', got '$actual'"
        return 1
    fi
}

assert_not_equal() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Values should not be equal}"
    
    if [[ "$expected" != "$actual" ]]; then
        return 0
    else
        log_error "$message: both values are '$actual'"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String should contain substring}"
    
    if [[ "$haystack" == *"$needle"* ]]; then
        return 0
    else
        log_error "$message: '$haystack' does not contain '$needle'"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist}"
    
    if [[ -f "$file" ]]; then
        return 0
    else
        log_error "$message: '$file' does not exist"
        return 1
    fi
}

assert_command_succeeds() {
    local command="$1"
    local message="${2:-Command should succeed}"
    
    if eval "$command" >/dev/null 2>&1; then
        return 0
    else
        log_error "$message: '$command' failed"
        return 1
    fi
}

# Test discovery and execution
discover_tests() {
    local test_dir="$1"
    local test_pattern="${2:-test_*.sh}"
    
    find "$test_dir" -name "$test_pattern" -type f -executable 2>/dev/null | sort
}

run_test_file() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .sh)
    
    start_test_suite "$test_name" "Test file: $test_file"
    
    log_info "Executing test file: $test_file"
    
    # Source and run the test file
    if [[ -x "$test_file" ]]; then
        if bash "$test_file"; then
            log_success "Test file completed: $test_file"
        else
            log_error "Test file failed: $test_file"
        fi
    else
        log_error "Test file is not executable: $test_file"
        ((TESTS_FAILED++))
    fi
    
    end_test_suite
}

# Test reporting
generate_test_report() {
    local report_format="${1:-json}"
    local output_file="${2:-$TEST_REPORTS_DIR/report-$TEST_SESSION_ID.$report_format}"
    
    case "$report_format" in
        "json")
            generate_json_report "$output_file"
            ;;
        "html")
            generate_html_report "$output_file"
            ;;
        "markdown")
            generate_markdown_report "$output_file"
            ;;
        *)
            log_error "Unknown report format: $report_format"
            return 1
            ;;
    esac
    
    log_success "Generated test report: $output_file"
}

generate_json_report() {
    local output_file="$1"
    local end_time=$(date +%s)
    local total_duration=$((end_time - TEST_START_TIME))
    
    # Collect all test results
    local test_results="[]"
    for result_file in "$TEST_RESULTS_DIR"/test-*.json; do
        if [[ -f "$result_file" ]]; then
            test_results=$(echo "$test_results" | jq ". + [$(cat "$result_file")]")
        fi
    done
    
    cat > "$output_file" << EOF
{
  "session_id": "$TEST_SESSION_ID",
  "start_time": "$(date -d @$TEST_START_TIME -Iseconds)",
  "end_time": "$(date -Iseconds)",
  "duration": $total_duration,
  "summary": {
    "total": $TESTS_RUN,
    "passed": $TESTS_PASSED,
    "failed": $TESTS_FAILED,
    "skipped": $TESTS_SKIPPED,
    "success_rate": $(echo "scale=2; $TESTS_PASSED * 100 / $TESTS_RUN" | bc -l)
  },
  "tests": $test_results,
  "environment": {
    "os": "$(uname -s)",
    "shell": "$SHELL",
    "user": "$(whoami)",
    "pwd": "$(pwd)"
  }
}
EOF
}

generate_markdown_report() {
    local output_file="$1"
    local end_time=$(date +%s)
    local total_duration=$((end_time - TEST_START_TIME))
    
    cat > "$output_file" << EOF
# Test Report: $TEST_SESSION_ID

**Generated:** $(date)  
**Duration:** ${total_duration}s  
**Environment:** $(uname -s)

## Summary

| Metric | Value |
|--------|-------|
| Total Tests | $TESTS_RUN |
| Passed | $TESTS_PASSED |
| Failed | $TESTS_FAILED |
| Skipped | $TESTS_SKIPPED |
| Success Rate | $(echo "scale=1; $TESTS_PASSED * 100 / $TESTS_RUN" | bc -l)% |

## Test Results

EOF

    # Add individual test results
    for result_file in "$TEST_RESULTS_DIR"/test-*.json; do
        if [[ -f "$result_file" ]]; then
            local test_data=$(cat "$result_file")
            local name=$(echo "$test_data" | jq -r .name)
            local status=$(echo "$test_data" | jq -r .status)
            local duration=$(echo "$test_data" | jq -r .duration)
            
            local status_icon="❓"
            case "$status" in
                "passed") status_icon="✅" ;;
                "failed") status_icon="❌" ;;
                "skipped") status_icon="⏭️" ;;
            esac
            
            echo "- $status_icon **$name** (${duration}s)" >> "$output_file"
        fi
    done
}

# Archive test results for long-term storage
archive_test_results() {
    local archive_name="${1:-test-archive-$(date +%Y%m%d-%H%M%S)}"
    local archive_dir="archives"
    
    if [[ ! -d "$TEST_BASE_DIR" ]]; then
        log_error "No test base directory found to archive"
        return 1
    fi
    
    # Create archives directory
    mkdir -p "$archive_dir"
    
    # Create archive with test results, reports, and logs
    local archive_file="$archive_dir/${archive_name}.tar.gz"
    
    log_info "Creating test archive: $archive_file"
    
    if tar -czf "$archive_file" \
        -C "$TEST_BASE_DIR" \
        test-results test-reports test-logs 2>/dev/null; then
        log_success "Test results archived to: $archive_file"
        
        # Optional: Clean up original files after archiving
        if [[ "${2:-false}" == "cleanup" ]]; then
            cleanup_test_artifacts
        fi
        
        return 0
    else
        log_error "Failed to create test archive"
        return 1
    fi
}

# Clean up temporary test artifacts
cleanup_test_artifacts() {
    local keep_reports="${1:-false}"
    
    log_info "Cleaning up test artifacts..."
    
    # Always clean up temporary files
    rm -rf /tmp/test-output-* 2>/dev/null || true
    
    # Clean up test directories
    if [[ -d "$TEST_RESULTS_DIR" ]]; then
        log_info "Removing test results: $TEST_RESULTS_DIR"
        rm -rf "$TEST_RESULTS_DIR"
    fi
    
    if [[ -d "$TEST_LOGS_DIR" ]]; then
        log_info "Removing test logs: $TEST_LOGS_DIR"
        rm -rf "$TEST_LOGS_DIR"
    fi
    
    # Optionally keep reports for reference
    if [[ "$keep_reports" != "true" && -d "$TEST_REPORTS_DIR" ]]; then
        log_info "Removing test reports: $TEST_REPORTS_DIR"
        rm -rf "$TEST_REPORTS_DIR"
    elif [[ "$keep_reports" == "true" ]]; then
        log_info "Keeping test reports: $TEST_REPORTS_DIR"
    fi
    
    log_success "Test artifact cleanup completed"
}

# Auto-cleanup old test artifacts (older than specified days)
cleanup_old_test_artifacts() {
    local max_age_days="${1:-7}"  # Default to 7 days
    local base_search_dir="${2:-tests}"
    
    log_info "Cleaning up test artifacts older than $max_age_days days..."
    
    # Find and remove old test directories
    find "$base_search_dir" -type d \( -name "test-results" -o -name "test-logs" \) \
        -mtime +$max_age_days -exec rm -rf {} + 2>/dev/null || true
    
    # Find and remove old individual result files
    find "$base_search_dir" -name "*.json" -path "*/test-results/*" \
        -mtime +$max_age_days -delete 2>/dev/null || true
    
    # Find and remove old log files
    find "$base_search_dir" -name "*.log" -path "*/test-logs/*" \
        -mtime +$max_age_days -delete 2>/dev/null || true
    
    log_success "Old test artifacts cleanup completed"
}

# Test artifacts management helper
manage_test_artifacts() {
    local action="$1"
    shift
    
    case "$action" in
        "archive")
            archive_test_results "$@"
            ;;
        "cleanup")
            cleanup_test_artifacts "$@"
            ;;
        "auto-cleanup")
            cleanup_old_test_artifacts "$@"
            ;;
        "status")
            show_test_artifacts_status
            ;;
        *)
            log_error "Unknown action: $action"
            log_info "Available actions: archive, cleanup, auto-cleanup, status"
            return 1
            ;;
    esac
}

# Show current test artifacts status
show_test_artifacts_status() {
    log_info "Test Artifacts Status:"
    
    for dir in test-results test-reports test-logs; do
        local full_path="${TEST_BASE_DIR:-tests}/$dir"
        if [[ -d "$full_path" ]]; then
            local file_count=$(find "$full_path" -type f | wc -l)
            local dir_size=$(du -sh "$full_path" 2>/dev/null | cut -f1 || echo "unknown")
            log_info "  $dir: $file_count files, $dir_size"
        else
            log_info "  $dir: not found"
        fi
    done
    
    # Show archives if they exist
    if [[ -d "archives" ]]; then
        local archive_count=$(find archives -name "*.tar.gz" | wc -l)
        local archive_size=$(du -sh archives 2>/dev/null | cut -f1 || echo "unknown")
        log_info "  archives: $archive_count files, $archive_size"
    fi
}

# Test session finalization
finalize_testing() {
    local end_time=$(date +%s)
    local total_duration=$((end_time - TEST_START_TIME))
    
    log_info "Test session completed: $TEST_SESSION_ID"
    log_info "Total duration: ${total_duration}s"
    log_info "Results: $TESTS_PASSED passed, $TESTS_FAILED failed, $TESTS_SKIPPED skipped"
    
    # Generate reports
    generate_test_report "json"
    generate_test_report "markdown"
    
    # Determine exit code
    if [[ $TESTS_FAILED -gt 0 ]]; then
        log_error "Some tests failed"
        return 1
    else
        log_success "All tests passed"
        return 0
    fi
}

# Configuration setters
set_fail_fast() { FAIL_FAST=true; }
unset_fail_fast() { FAIL_FAST=false; }
