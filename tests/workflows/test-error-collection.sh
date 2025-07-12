#!/bin/bash
#
# @file tests/workflows/test-error-collection.sh
# @description Test script for validating workflow error collection functionality
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-01-27
# @lastModified 2025-01-27
# @version 1.0.0
#
# @relatedIssues 
#   - #workflow-error-logging: Test error collection capabilities
#
# @relatedEvolutions
#   - v1.0.0: Initial test implementation for error collection validation
#
# @dependencies
#   - ../scripts/collect-workflow-errors.sh: Error collection script
#   - jq: JSON processing for validation
#
# @changelog
#   - 2025-01-27: Initial creation with comprehensive error collection tests - ITJ
#
# @usage ./tests/workflows/test-error-collection.sh
# @notes Tests both successful and error scenarios
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Test configuration
TEST_LOG_DIR="/tmp/test-logs"
TEST_OUTPUT_DIR="/tmp/test-outputs"
COLLECT_SCRIPT="$PROJECT_ROOT/scripts/collect-workflow-errors.sh"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to log test results
log_test() {
    local status="$1"
    local message="$2"
    ((TESTS_RUN++))
    
    if [[ "$status" == "PASS" ]]; then
        echo -e "${GREEN}✓ PASS${NC}: $message"
        ((TESTS_PASSED++))
    elif [[ "$status" == "FAIL" ]]; then
        echo -e "${RED}✗ FAIL${NC}: $message"
        ((TESTS_FAILED++))
    else
        echo -e "${BLUE}ℹ INFO${NC}: $message"
    fi
}

# Setup test environment
setup_test_env() {
    echo -e "${BLUE}🔧 Setting up test environment...${NC}"
    
    # Create test directories
    mkdir -p "$TEST_LOG_DIR"
    mkdir -p "$TEST_OUTPUT_DIR"
    
    # Create sample log files with errors and warnings
    cat > "$TEST_LOG_DIR/sample-error.log" << EOF
[INFO] Starting process...
[ERROR] Database connection failed: timeout after 30s
[WARNING] Retrying connection attempt 1/3
[ERROR] Authentication failed for user 'testuser'
[INFO] Process completed with errors
EOF
    
    cat > "$TEST_LOG_DIR/sample-warning.log" << EOF
[INFO] Initialization complete
[WARNING] Configuration file missing, using defaults
[WARNING] Deprecated API endpoint used
[INFO] All tasks completed successfully
EOF
    
    cat > "$TEST_LOG_DIR/sample-clean.log" << EOF
[INFO] Starting application
[INFO] All systems operational
[INFO] Application ready
[INFO] Process completed successfully
EOF
    
    # Create a test JSON log
    cat > "$TEST_LOG_DIR/sample-metrics.json" << EOF
{
  "status": "error",
  "message": "Failed to process request",
  "errors": ["validation failed", "timeout occurred"],
  "warnings": ["deprecated method used"]
}
EOF
    
    echo -e "${GREEN}✅ Test environment ready${NC}"
}

# Test basic script functionality
test_basic_functionality() {
    echo -e "${BLUE}🧪 Testing basic functionality...${NC}"
    
    # Test help option
    if "$COLLECT_SCRIPT" --help >/dev/null 2>&1; then
        log_test "PASS" "Help option works"
    else
        log_test "FAIL" "Help option failed"
    fi
    
    # Test script execution without errors
    local output_file="$TEST_OUTPUT_DIR/basic-test.json"
    if "$COLLECT_SCRIPT" --workflow-type "test" --job-status "success" --output-file "$output_file" 2>/dev/null; then
        log_test "PASS" "Basic script execution works"
        
        # Validate output file was created
        if [[ -f "$output_file" ]]; then
            log_test "PASS" "Output file was created"
            
            # Validate JSON format
            if jq empty "$output_file" >/dev/null 2>&1; then
                log_test "PASS" "Output file is valid JSON"
            else
                log_test "FAIL" "Output file is not valid JSON"
            fi
        else
            log_test "FAIL" "Output file was not created"
        fi
    else
        log_test "FAIL" "Basic script execution failed"
    fi
}

# Test error detection from log files
test_error_detection() {
    echo -e "${BLUE}🔍 Testing error detection...${NC}"
    
    # Temporarily create logs in project directory for testing
    local temp_logs="$PROJECT_ROOT/logs/temp-test"
    mkdir -p "$temp_logs"
    
    # Copy test logs
    cp "$TEST_LOG_DIR"/*.log "$temp_logs/"
    cp "$TEST_LOG_DIR"/*.json "$temp_logs/"
    
    local output_file="$TEST_OUTPUT_DIR/error-detection.json"
    
    # Run error collection
    if "$COLLECT_SCRIPT" --workflow-type "test" --job-status "failure" --output-file "$output_file" --collect-from-logs 2>/dev/null; then
        log_test "PASS" "Error detection script completed"
        
        # Check if errors were detected
        if [[ -f "$output_file" ]]; then
            local error_count=$(jq -r '.workflow_error_summary.summary.total_errors' "$output_file" 2>/dev/null || echo "0")
            local warning_count=$(jq -r '.workflow_error_summary.summary.total_warnings' "$output_file" 2>/dev/null || echo "0")
            
            if [[ "$error_count" -gt 0 ]]; then
                log_test "PASS" "Errors were detected ($error_count errors found)"
            else
                log_test "FAIL" "No errors were detected when they should have been"
            fi
            
            if [[ "$warning_count" -gt 0 ]]; then
                log_test "PASS" "Warnings were detected ($warning_count warnings found)"
            else
                log_test "FAIL" "No warnings were detected when they should have been"
            fi
        else
            log_test "FAIL" "Output file was not created during error detection"
        fi
    else
        log_test "FAIL" "Error detection script failed"
    fi
    
    # Clean up temp logs
    rm -rf "$temp_logs"
}

# Test GitHub Actions environment simulation
test_github_actions_env() {
    echo -e "${BLUE}🏗️ Testing GitHub Actions environment simulation...${NC}"
    
    # Set up mock GitHub Actions environment
    export GITHUB_RUN_ID="12345"
    export GITHUB_RUN_ATTEMPT="1"
    export GITHUB_JOB="test-job"
    export GITHUB_REPOSITORY="test/repo"
    export GITHUB_REF="refs/heads/main"
    export GITHUB_ACTOR="test-user"
    export GITHUB_OUTPUT="$TEST_OUTPUT_DIR/github-output.txt"
    export GITHUB_STEP_SUMMARY="$TEST_OUTPUT_DIR/step-summary.md"
    
    # Create mock step summary with errors
    cat > "$GITHUB_STEP_SUMMARY" << EOF
## Previous Steps

- ✅ Setup completed
- ❌ ERROR: Build failed
- ⚠️ WARNING: Tests had warnings
- ✅ Cleanup completed
EOF
    
    local output_file="$TEST_OUTPUT_DIR/github-env-test.json"
    
    if "$COLLECT_SCRIPT" --workflow-type "github_test" --job-status "failure" --output-file "$output_file" 2>/dev/null; then
        log_test "PASS" "GitHub Actions environment simulation completed"
        
        # Check if GitHub-specific data was captured
        if [[ -f "$output_file" ]]; then
            local workflow_id=$(jq -r '.workflow_error_summary.metadata.workflow_id' "$output_file" 2>/dev/null || echo "")
            if [[ "$workflow_id" == "12345" ]]; then
                log_test "PASS" "GitHub workflow ID was captured correctly"
            else
                log_test "FAIL" "GitHub workflow ID was not captured correctly"
            fi
            
            local repository=$(jq -r '.workflow_error_summary.metadata.repository' "$output_file" 2>/dev/null || echo "")
            if [[ "$repository" == "test/repo" ]]; then
                log_test "PASS" "GitHub repository was captured correctly"
            else
                log_test "FAIL" "GitHub repository was not captured correctly"
            fi
        fi
        
        # Check GitHub outputs were set
        if [[ -f "$GITHUB_OUTPUT" ]]; then
            if grep -q "errors_found=" "$GITHUB_OUTPUT"; then
                log_test "PASS" "GitHub output variables were set"
            else
                log_test "FAIL" "GitHub output variables were not set"
            fi
        fi
        
        # Check step summary was updated
        if [[ -f "$GITHUB_STEP_SUMMARY" ]] && grep -q "Workflow Error & Warning Summary" "$GITHUB_STEP_SUMMARY"; then
            log_test "PASS" "GitHub step summary was updated"
        else
            log_test "FAIL" "GitHub step summary was not updated"
        fi
    else
        log_test "FAIL" "GitHub Actions environment simulation failed"
    fi
    
    # Clean up environment variables
    unset GITHUB_RUN_ID GITHUB_RUN_ATTEMPT GITHUB_JOB GITHUB_REPOSITORY GITHUB_REF GITHUB_ACTOR GITHUB_OUTPUT GITHUB_STEP_SUMMARY
}

# Test different workflow types
test_workflow_types() {
    echo -e "${BLUE}📋 Testing different workflow types...${NC}"
    
    local workflow_types=("ai_evolver" "testing_automation" "daily_evolution" "periodic_evolution")
    
    for workflow_type in "${workflow_types[@]}"; do
        local output_file="$TEST_OUTPUT_DIR/workflow-${workflow_type}.json"
        
        if "$COLLECT_SCRIPT" --workflow-type "$workflow_type" --job-status "success" --output-file "$output_file" 2>/dev/null; then
            log_test "PASS" "Workflow type '$workflow_type' processed successfully"
            
            # Validate workflow type was saved correctly
            if [[ -f "$output_file" ]]; then
                local saved_type=$(jq -r '.workflow_error_summary.metadata.workflow_type' "$output_file" 2>/dev/null || echo "")
                if [[ "$saved_type" == "$workflow_type" ]]; then
                    log_test "PASS" "Workflow type '$workflow_type' saved correctly in output"
                else
                    log_test "FAIL" "Workflow type '$workflow_type' not saved correctly in output"
                fi
            fi
        else
            log_test "FAIL" "Workflow type '$workflow_type' processing failed"
        fi
    done
}

# Test clean workflow (no errors/warnings)
test_clean_workflow() {
    echo -e "${BLUE}✨ Testing clean workflow (no issues)...${NC}"
    
    local output_file="$TEST_OUTPUT_DIR/clean-workflow.json"
    
    # Run on a clean environment (no error logs)
    if "$COLLECT_SCRIPT" --workflow-type "clean_test" --job-status "success" --output-file "$output_file" 2>/dev/null; then
        log_test "PASS" "Clean workflow test completed"
        
        if [[ -f "$output_file" ]]; then
            local error_count=$(jq -r '.workflow_error_summary.summary.total_errors' "$output_file" 2>/dev/null || echo "-1")
            local warning_count=$(jq -r '.workflow_error_summary.summary.total_warnings' "$output_file" 2>/dev/null || echo "-1")
            local overall_status=$(jq -r '.workflow_error_summary.summary.overall_status' "$output_file" 2>/dev/null || echo "")
            
            if [[ "$error_count" == "0" && "$warning_count" == "0" ]]; then
                log_test "PASS" "Clean workflow reported zero errors and warnings"
            else
                log_test "FAIL" "Clean workflow should have zero errors and warnings (found $error_count errors, $warning_count warnings)"
            fi
            
            if [[ "$overall_status" == "clean" ]]; then
                log_test "PASS" "Clean workflow status reported correctly"
            else
                log_test "FAIL" "Clean workflow status should be 'clean' but was '$overall_status'"
            fi
        fi
    else
        log_test "FAIL" "Clean workflow test failed"
    fi
}

# Cleanup test environment
cleanup_test_env() {
    echo -e "${BLUE}🧹 Cleaning up test environment...${NC}"
    rm -rf "$TEST_LOG_DIR"
    rm -rf "$TEST_OUTPUT_DIR"
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

# Run all tests
run_all_tests() {
    echo -e "${GREEN}🚀 Starting workflow error collection tests...${NC}"
    echo "=============================================="
    
    setup_test_env
    
    test_basic_functionality
    test_error_detection
    test_github_actions_env
    test_workflow_types
    test_clean_workflow
    
    cleanup_test_env
    
    echo "=============================================="
    echo -e "${BLUE}📊 Test Results Summary:${NC}"
    echo "   Tests Run: $TESTS_RUN"
    echo -e "   ${GREEN}Tests Passed: $TESTS_PASSED${NC}"
    echo -e "   ${RED}Tests Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Some tests failed.${NC}"
        exit 1
    fi
}

# Main execution
main() {
    if [[ $# -gt 0 ]] && [[ "$1" == "--help" ]]; then
        echo "Usage: $0"
        echo "Runs comprehensive tests for workflow error collection functionality."
        exit 0
    fi
    
    # Check if collect script exists
    if [[ ! -f "$COLLECT_SCRIPT" ]]; then
        echo -e "${RED}❌ Error collection script not found: $COLLECT_SCRIPT${NC}"
        exit 1
    fi
    
    # Check dependencies
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${RED}❌ jq is required but not installed${NC}"
        exit 1
    fi
    
    run_all_tests
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n${YELLOW}⚠️ Tests interrupted by user${NC}"; cleanup_test_env; exit 1' INT

# Run main function
main "$@"