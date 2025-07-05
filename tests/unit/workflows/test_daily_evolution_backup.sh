#!/bin/bash

# Unit Tests for Daily Evolution & Maintenance Workflow
# Tests all aspects of the daily_evolution.yml workflow
# Version: 0.3.6-seed

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
WORKFLOW_FILE="$PROJECT_ROOT/.github/workflows/daily_evolution.yml"

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
    run_test "Workflow has a descriptive name" "test -n '$workflow_name' && echo '$workflow_name' | grep -q 'Daily Evolution'"
    
    run_test "Workflow has proper trigger (workflow_dispatch)" "yq eval '.on.workflow_dispatch' '$WORKFLOW_FILE' | grep -q 'inputs'"
    run_test "Workflow has required permissions" "yq eval '.permissions.contents' '$WORKFLOW_FILE' | grep -q 'write'"
    run_test "Workflow has PR permissions" "yq eval '.permissions.pull-requests' '$WORKFLOW_FILE' | grep -q 'write'"
}

# Test workflow inputs
test_workflow_inputs() {
    info "Testing workflow inputs..."
    
    run_test "Has required 'evolution_type' input" "grep -q 'evolution_type:' '$WORKFLOW_FILE'"
    run_test "Has 'intensity' input with choices" "grep -q 'intensity:' '$WORKFLOW_FILE'"
    run_test "Has 'force_run' boolean input" "grep -q 'force_run:' '$WORKFLOW_FILE'"
    run_test "Has 'dry_run' boolean input" "grep -q 'dry_run:' '$WORKFLOW_FILE'"
    
    # Test that intensity has expected options
    run_test "Intensity includes 'minimal'" "grep -q 'minimal' '$WORKFLOW_FILE'"
    run_test "Intensity includes 'moderate'" "grep -q 'moderate' '$WORKFLOW_FILE'"
    run_test "Intensity includes 'comprehensive'" "grep -q 'comprehensive' '$WORKFLOW_FILE'"
}

# Test job configuration
test_job_configuration() {
    info "Testing job configuration..."
    
    run_test "Job uses ubuntu-latest runner" "grep -q 'ubuntu-latest' '$WORKFLOW_FILE'"
    run_test "Job has descriptive name" "grep -q 'Daily Growth.*Maintenance' '$WORKFLOW_FILE'"
}

# Test workflow steps
test_workflow_steps() {
    info "Testing workflow steps..."
    
    local step_count
    step_count=$(yq eval '.jobs.daily_evolution.steps | length' "$WORKFLOW_FILE")
    run_test "Workflow has multiple steps" "test '$step_count' -gt 3"
    
    # Test checkout step
    run_test "Has checkout step with full history" "grep -q 'fetch-depth: 0' '$WORKFLOW_FILE'"
    
    # Test context collection step
    run_test "Has repository health analysis step" "grep -q 'analyze-repository-health' '$WORKFLOW_FILE'"
    
    # Test AI simulation step
    run_test "Has evolution prompt generation step" "grep -q 'generate-evolution-prompt' '$WORKFLOW_FILE'"
    
    # Test application step
    run_test "Has evolution trigger step" "grep -q 'trigger-evolution-workflow' '$WORKFLOW_FILE'"
}

# Test script integration
test_script_integration() {
    info "Testing script integration..."
    
    # Check if workflow references expected helper scripts
    run_test "Workflow mentions setup-environment.sh" "grep -q 'setup-environment.sh' '$WORKFLOW_FILE'"
    run_test "Workflow mentions analyze-repository-health.sh" "grep -q 'analyze-repository-health.sh' '$WORKFLOW_FILE'"
    run_test "Workflow mentions generate-evolution-prompt.sh" "grep -q 'generate-evolution-prompt.sh' '$WORKFLOW_FILE'"
    run_test "Workflow mentions trigger-evolution-workflow.sh" "grep -q 'trigger-evolution-workflow.sh' '$WORKFLOW_FILE'"
}

# Test error handling and validation
test_error_handling() {
    info "Testing error handling patterns..."
    
    # Test conditional execution patterns
    run_test "Has conditional step execution" "grep -q 'steps\.health_check\.outputs\.should_evolve' '$WORKFLOW_FILE'"
    run_test "Has dry run handling" "grep -q 'DRY_RUN' '$WORKFLOW_FILE'"
    
    # Test file existence checks
    run_test "Checks for setup script existence" "grep -q 'if \[ ! -f.*setup-environment.sh' '$WORKFLOW_FILE'"
    run_test "Handles script permissions" "grep -q 'chmod +x' '$WORKFLOW_FILE'"
}

# Test environment variable handling
test_environment_variables() {
    info "Testing environment variable usage..."
    
    # Test GitHub context variables
    run_test "Uses github.event.inputs properly" "grep -q '\${{ github\.event\.inputs\.' '$WORKFLOW_FILE'"
    run_test "Uses github.token for authentication" "grep -q 'secrets\.PAT_TOKEN' '$WORKFLOW_FILE'"
    
    # Test custom environment variables
    run_test "Sets EVOLUTION_TYPE variable" "grep -q 'EVOLUTION_TYPE:' '$WORKFLOW_FILE'"
    run_test "Sets INTENSITY variable" "grep -q 'INTENSITY:' '$WORKFLOW_FILE'"
}

# Test version management
test_version_management() {
    info "Testing version management..."
    
    local workflow_version
    workflow_version=$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$WORKFLOW_FILE" | head -1)
    run_test "Workflow has version identifier" "test -n '$workflow_version'"
    
    # Test that version appears in name and environment
    run_test "Version appears in workflow name" "yq eval '.name' '$WORKFLOW_FILE' | grep -q 'v[0-9]'"
    run_test "Version appears in environment variables" "yq eval '.env.EVOLUTION_VERSION' '$WORKFLOW_FILE' | grep -q '[0-9]'"
}

# Test security considerations
test_security() {
    info "Testing security considerations..."
    
    # Test that sensitive operations are properly scoped
    run_test "Has appropriate permissions scope" "yq eval '.permissions | keys | length' '$WORKFLOW_FILE' | grep -q '^3'"
    run_test "No hardcoded secrets" "! grep -E '(password|secret|token): *[\"'\''][a-zA-Z0-9_-]{8,}[\"'\'']' '$WORKFLOW_FILE'"
    run_test "Uses secure checkout" "yq eval '.jobs.daily_evolution.steps[] | select(.uses == \"actions/checkout@v4\")' '$WORKFLOW_FILE' | grep -q 'uses'"
}

# Test dependency requirements
test_dependencies() {
    info "Testing dependency requirements..."
    
    # Test that required tools are available or installed
    run_test "Workflow uses git operations" "grep -q 'fetch-depth: 0' '$WORKFLOW_FILE'"
    run_test "Workflow mentions bash scripts" "grep -q '\.sh' '$WORKFLOW_FILE'"
    run_test "Workflow uses environment variables" "grep -q 'env:' '$WORKFLOW_FILE'"
}

# Main test execution
run_all_tests() {
    info "Starting Daily Evolution Workflow Tests..."
    echo "Testing file: $WORKFLOW_FILE"
    echo ""
    
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
    
    echo ""
    echo "=== Test Results ==="
    echo "Tests Run: $TESTS_RUN"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        return 1
    fi
}

# Install yq if not available
install_dependencies() {
    if ! command -v yq &> /dev/null; then
        info "Installing yq for YAML processing..."
        if command -v wget &> /dev/null; then
            wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
            chmod +x /usr/local/bin/yq
        elif command -v curl &> /dev/null; then
            curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq
            chmod +x /usr/local/bin/yq
        else
            warn "Could not install yq. Some tests may fail."
        fi
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]:-$0}" == "${0}" ]]; then
    install_dependencies
    run_all_tests
fi
