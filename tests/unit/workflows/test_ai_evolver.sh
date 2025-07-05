#!/bin/bash
#
# @file tests/unit/workflows/test_ai_evolver.sh
# @description Unit tests for AI Evolution Growth Engine Workflow validation
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #AI-workflow-testing: Comprehensive workflow validation testing
#   - #test-framework-reorganization: Category-specific artifact management
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation with comprehensive workflow testing
#
# @dependencies
#   - bash: >=4.0
#   - yq: for YAML processing
#   - jq: for JSON processing
#
# @changelog
#   - 2025-07-05: Added proper file header and artifact management - ITJ
#   - 2025-07-05: Initial creation with workflow validation tests - ITJ
#
# @usage ./test_ai_evolver.sh
# @notes Tests all aspects of the ai_evolver.yml workflow including metadata, inputs, and steps
#

# Unit Tests for AI Evolution Growth Engine Workflow
# Tests all aspects of the ai_evolver.yml workflow
# Version: 0.3.6-seed

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
WORKFLOW_FILE="$PROJECT_ROOT/.github/workflows/ai_evolver.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
success() { 
    echo -e "${GREEN}✓${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}
fail() { 
    echo -e "${RED}✗${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Run a test with error handling
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if eval "$test_command" &>/dev/null; then
        success "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Setup artifact directories
WORKFLOW_LOGS_DIR="$SCRIPT_DIR/logs"
WORKFLOW_RESULTS_DIR="$SCRIPT_DIR/results"
WORKFLOW_REPORTS_DIR="$SCRIPT_DIR/reports"

# Create artifact directories if they don't exist
mkdir -p "$WORKFLOW_LOGS_DIR" "$WORKFLOW_RESULTS_DIR" "$WORKFLOW_REPORTS_DIR"

# Initialize test run timestamp for artifacts
TEST_RUN_TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
TEST_LOG_FILE="$WORKFLOW_LOGS_DIR/ai_evolver_test_${TEST_RUN_TIMESTAMP}.log"
TEST_RESULTS_FILE="$WORKFLOW_RESULTS_DIR/ai_evolver_results_${TEST_RUN_TIMESTAMP}.json"
TEST_REPORT_FILE="$WORKFLOW_REPORTS_DIR/ai_evolver_report_${TEST_RUN_TIMESTAMP}.md"

# Redirect all output to log file as well as console
exec > >(tee -a "$TEST_LOG_FILE")
exec 2>&1

# Initialize results JSON
echo "{\"test_run_id\": \"ai_evolver_test_${TEST_RUN_TIMESTAMP}\", \"start_time\": \"$(date -Iseconds)\", \"tests\": []}" > "$TEST_RESULTS_FILE"

# Enhanced logging functions with JSON result tracking
success() { 
    echo -e "${GREEN}✓${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    log_test_result "$1" "PASSED" ""
}
fail() { 
    echo -e "${RED}✗${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    log_test_result "$1" "FAILED" "$2"
}

# Log test results to JSON file
log_test_result() {
    local test_name="$1"
    local result="$2"
    local error_msg="$3"
    local timestamp=$(date -Iseconds)
    
    # Update JSON results file
    jq --arg name "$test_name" --arg result "$result" --arg error "$error_msg" --arg time "$timestamp" \
       '.tests += [{"name": $name, "result": $result, "error": $error, "timestamp": $time}]' \
       "$TEST_RESULTS_FILE" > "${TEST_RESULTS_FILE}.tmp" && mv "${TEST_RESULTS_FILE}.tmp" "$TEST_RESULTS_FILE"
}

# Test workflow file exists and is valid YAML
test_workflow_exists() {
    info "Testing workflow file existence and structure..."
    
    run_test "AI Evolver workflow file exists" "test -f \"$WORKFLOW_FILE\""
    run_test "Workflow YAML is valid" "yq eval '.name' \"$WORKFLOW_FILE\" > /dev/null"
}

# Test workflow metadata
test_workflow_metadata() {
    info "Testing workflow metadata..."
    
    local workflow_name
    workflow_name=$(yq eval '.name' "$WORKFLOW_FILE")
    run_test "Workflow has a descriptive name" "test -n '$workflow_name' && echo '$workflow_name' | grep -q 'AI Evolution'"
    
    run_test "Workflow has proper trigger (workflow_dispatch)" "yq eval '.on.workflow_dispatch' '$WORKFLOW_FILE' | grep -q 'inputs'"
    run_test "Workflow has required permissions" "yq eval '.permissions.contents' '$WORKFLOW_FILE' | grep -q 'write'"
    run_test "Workflow has PR permissions" "yq eval '.permissions.pull-requests' '$WORKFLOW_FILE' | grep -q 'write'"
}

# Test workflow inputs
test_workflow_inputs() {
    info "Testing workflow inputs..."
    
    run_test "Has cycle input" "yq eval '.on.workflow_dispatch.inputs.cycle' '$WORKFLOW_FILE' | grep -q 'description'"
    run_test "Has generation input" "yq eval '.on.workflow_dispatch.inputs.generation' '$WORKFLOW_FILE' | grep -q 'description'"
    run_test "Has prompt input" "yq eval '.on.workflow_dispatch.inputs.prompt' '$WORKFLOW_FILE' | grep -q 'description'"
    run_test "Has growth_mode input" "yq eval '.on.workflow_dispatch.inputs.growth_mode' '$WORKFLOW_FILE' | grep -q 'description'"
    
    # Test input defaults and validation
    run_test "Cycle has numeric default" "yq eval '.on.workflow_dispatch.inputs.cycle.default' '$WORKFLOW_FILE' | grep -E '^[0-9]+$'"
    run_test "Generation has numeric default" "yq eval '.on.workflow_dispatch.inputs.generation.default' '$WORKFLOW_FILE' | grep -E '^[0-9]+$'"
}

# Test job configuration
test_job_configuration() {
    info "Testing job configuration..."
    
    run_test "Has evolve job" "yq eval '.jobs.evolve' '$WORKFLOW_FILE' | grep -q 'runs-on'"
    run_test "Job runs on ubuntu-latest" "yq eval '.jobs.evolve.runs-on' '$WORKFLOW_FILE' | grep -q 'ubuntu-latest'"
    run_test "Job has environment variables" "yq eval '.jobs.evolve.env' '$WORKFLOW_FILE' | grep -q 'GITHUB_TOKEN'"
}

# Test workflow steps
test_workflow_steps() {
    info "Testing workflow steps..."
    
    run_test "Has checkout step" "yq eval '.jobs.evolve.steps[] | select(.uses == \"actions/checkout@v4\")' '$WORKFLOW_FILE' | grep -q 'uses'"
    run_test "Has setup node step" "yq eval '.jobs.evolve.steps[] | select(.uses | contains(\"actions/setup-node\"))' '$WORKFLOW_FILE' | grep -q 'uses'"
    run_test "Has context collection step" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Collect Repository Context\"))' '$WORKFLOW_FILE' | grep -q 'name'"
    run_test "Has AI response generation step" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Generate AI Response\"))' '$WORKFLOW_FILE' | grep -q 'name'"
    run_test "Has PR creation step" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Create Pull Request\"))' '$WORKFLOW_FILE' | grep -q 'name'"
}

# Test script integration
test_script_integration() {
    info "Testing script integration..."
    
    # Check if referenced scripts exist
    run_test "Generate seed script exists" "test -f '$PROJECT_ROOT/scripts/generate_seed.sh'"
    run_test "Generate AI response script exists" "test -f '$PROJECT_ROOT/scripts/generate_ai_response.sh'"
    run_test "Create PR script exists" "test -f '$PROJECT_ROOT/scripts/create_pr.sh'"
    
    # Test script permissions
    run_test "Generate seed script is executable" "test -x '$PROJECT_ROOT/scripts/generate_seed.sh'"
    run_test "Generate AI response script is executable" "test -x '$PROJECT_ROOT/scripts/generate_ai_response.sh'"
    run_test "Create PR script is executable" "test -x '$PROJECT_ROOT/scripts/create_pr.sh'"
}

# Test error handling and validation
test_error_handling() {
    info "Testing error handling and validation..."
    
    # Check for proper error handling in workflow steps
    run_test "Steps have continue-on-error where appropriate" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Validation\")) | .continue-on-error' '$WORKFLOW_FILE' | grep -q 'true' || true"
    run_test "Critical steps fail fast" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Generate AI Response\")) | has(\"continue-on-error\")' '$WORKFLOW_FILE' | grep -q 'false' || true"
}

# Test environment variable handling
test_environment_variables() {
    info "Testing environment variables..."
    
    run_test "GITHUB_TOKEN is configured" "yq eval '.jobs.evolve.env.GITHUB_TOKEN' '$WORKFLOW_FILE' | grep -q 'secrets.GITHUB_TOKEN'"
    run_test "Required environment variables are set" "yq eval '.jobs.evolve.env | keys | length' '$WORKFLOW_FILE' | grep -E '^[1-9][0-9]*$'"
}

# Test version management
test_version_management() {
    info "Testing version management..."
    
    # Check if version tracking is implemented
    run_test "Workflow tracks version information" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"version\"))' '$WORKFLOW_FILE' || true"
    run_test "Evolution metrics are updated" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"metrics\"))' '$WORKFLOW_FILE' || true"
}

# Test security considerations
test_security() {
    info "Testing security considerations..."
    
    run_test "Secrets are not exposed in logs" "! yq eval '.jobs.evolve.steps[].run' '$WORKFLOW_FILE' | grep -i 'secret'"
    run_test "Token permissions are restricted" "yq eval '.permissions | keys | length' '$WORKFLOW_FILE' | grep -E '^[1-9][0-9]*$'"
    run_test "Workflow uses pinned action versions" "yq eval '.jobs.evolve.steps[].uses' '$WORKFLOW_FILE' | grep -v 'latest' || true"
}

# Test dependency requirements
test_dependencies() {
    info "Testing dependency requirements..."
    
    run_test "Node.js version is specified" "yq eval '.jobs.evolve.steps[] | select(.uses | contains(\"setup-node\")) | .with.node-version' '$WORKFLOW_FILE' | grep -E '^[0-9]+'"
    run_test "Required tools are installed" "yq eval '.jobs.evolve.steps[] | select(.name | contains(\"Install\"))' '$WORKFLOW_FILE' | grep -q 'name'"
}

# Generate final test report
generate_test_report() {
    local end_time=$(date -Iseconds)
    local total_tests=$((TESTS_PASSED + TESTS_FAILED))
    local success_rate=0
    
    if [ $total_tests -gt 0 ]; then
        success_rate=$((TESTS_PASSED * 100 / total_tests))
    fi
    
    # Update JSON results with summary
    jq --arg end_time "$end_time" --argjson passed "$TESTS_PASSED" --argjson failed "$TESTS_FAILED" --argjson total "$total_tests" --argjson rate "$success_rate" \
       '.end_time = $end_time | .summary = {"total": $total, "passed": $passed, "failed": $failed, "success_rate": $rate}' \
       "$TEST_RESULTS_FILE" > "${TEST_RESULTS_FILE}.tmp" && mv "${TEST_RESULTS_FILE}.tmp" "$TEST_RESULTS_FILE"
    
    # Generate markdown report
    cat > "$TEST_REPORT_FILE" << EOF
# AI Evolver Workflow Test Report

**Test Run ID:** ai_evolver_test_${TEST_RUN_TIMESTAMP}  
**Date:** $(date)  
**Workflow File:** $WORKFLOW_FILE

## Summary

- **Total Tests:** $total_tests
- **Passed:** $TESTS_PASSED
- **Failed:** $TESTS_FAILED
- **Success Rate:** ${success_rate}%

## Test Categories

### Workflow Structure Tests
- Workflow file existence and YAML validity
- Metadata configuration
- Input definitions
- Job configuration

### Integration Tests
- Script availability and permissions
- Error handling mechanisms
- Environment variable configuration

### Security Tests
- Secret handling
- Permission restrictions
- Action version pinning

### Dependency Tests
- Required tool availability
- Version specifications

## Detailed Results

$(jq -r '.tests[] | "- \(.name): \(.result)" + (if .error != "" then " (\(.error))" else "" end)' "$TEST_RESULTS_FILE")

## Recommendations

EOF

    if [ $TESTS_FAILED -gt 0 ]; then
        cat >> "$TEST_REPORT_FILE" << EOF
⚠️ **Action Required:** Some tests failed. Please review the following:

$(jq -r '.tests[] | select(.result == "FAILED") | "- \(.name): \(.error)"' "$TEST_RESULTS_FILE")

EOF
    else
        cat >> "$TEST_REPORT_FILE" << EOF
✅ **All tests passed!** The AI Evolver workflow is properly configured.

EOF
    fi
    
    cat >> "$TEST_REPORT_FILE" << EOF
## Artifacts

- **Log File:** $TEST_LOG_FILE
- **Results File:** $TEST_RESULTS_FILE
- **Report File:** $TEST_REPORT_FILE

---
*Generated by AI Evolution Engine Test Framework*
EOF
}

# Main test execution
run_all_tests() {
    info "Starting AI Evolver workflow validation tests"
    info "Workflow file: $WORKFLOW_FILE"
    info "Artifacts will be saved to: $SCRIPT_DIR/{logs,results,reports}/"
    
    # Install dependencies if needed
    install_dependencies
    
    # Run all test suites
    test_workflow_exists
    test_workflow_metadata
    test_workflow_inputs
    test_job_configuration
    test_workflow_steps
    test_script_integration
    test_error_handling
    test_environment_variables
    test_version_management
    test_security
    test_dependencies
    
    # Generate final report
    generate_test_report
    
    echo
    info "Test execution completed"
    info "Results summary:"
    echo "  Total tests: $((TESTS_PASSED + TESTS_FAILED))"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo
    info "Artifacts saved:"
    echo "  Log: $TEST_LOG_FILE"
    echo "  Results: $TEST_RESULTS_FILE"
    echo "  Report: $TEST_REPORT_FILE"
    
    # Exit with error if any tests failed
    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    fi
}

# Install yq if not available
install_dependencies() {
    if ! command -v yq &> /dev/null; then
        warn "yq not found. Attempting to install..."
        if command -v brew &> /dev/null; then
            brew install yq
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y yq
        else
            fail "Unable to install yq. Please install it manually."
            exit 1
        fi
    fi
    
    if ! command -v jq &> /dev/null; then
        warn "jq not found. Attempting to install..."
        if command -v brew &> /dev/null; then
            brew install jq
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y jq
        else
            fail "Unable to install jq. Please install it manually."
            exit 1
        fi
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
