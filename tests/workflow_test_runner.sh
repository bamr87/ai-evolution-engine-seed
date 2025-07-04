#!/bin/bash

# GitHub Actions Workflow Test Runner
# Comprehensive testing framework for all workflow files
# Version: 1.0.0

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKFLOW_DIR="$PROJECT_ROOT/.github/workflows"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Test counters
TOTAL_WORKFLOWS=0
WORKFLOWS_PASSED=0
WORKFLOWS_FAILED=0

# Logging functions
log() { echo -e "${GREEN}[WORKFLOW-TEST]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }

# Show banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                  GitHub Actions Workflow Tests               ║
║           Comprehensive Workflow Validation Suite            ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Install dependencies
install_dependencies() {
    info "Checking dependencies..."
    
    # Install yq if not available
    if ! command -v yq &> /dev/null; then
        info "Installing yq for YAML processing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install yq
            else
                curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_darwin_amd64 -o /usr/local/bin/yq
                chmod +x /usr/local/bin/yq
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v wget &> /dev/null; then
                sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
                sudo chmod +x /usr/local/bin/yq
            elif command -v curl &> /dev/null; then
                sudo curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq
                sudo chmod +x /usr/local/bin/yq
            fi
        fi
    fi
    
    # Check for Python (for YAML validation)
    if ! command -v python3 &> /dev/null; then
        error "Python 3 is required for YAML validation"
        exit 1
    fi
    
    # Install Python YAML library if needed
    if ! python3 -c "import yaml" &> /dev/null; then
        info "Installing PyYAML..."
        pip3 install PyYAML || pip install PyYAML
    fi
}

# Discover workflow files
discover_workflows() {
    if [[ ! -d "$WORKFLOW_DIR" ]]; then
        error "Workflow directory not found: $WORKFLOW_DIR"
        exit 1
    fi
    
    local workflow_files
    workflow_files=$(find "$WORKFLOW_DIR" -name "*.yml" -o -name "*.yaml" | sort)
    
    if [[ -z "$workflow_files" ]]; then
        warn "No workflow files found"
        return 1
    fi
    
    TOTAL_WORKFLOWS=$(echo "$workflow_files" | wc -l | tr -d ' ')
    echo "$workflow_files"
}

# Run tests for a specific workflow
test_workflow() {
    local workflow_file="$1"
    local workflow_name
    workflow_name=$(basename "$workflow_file" .yml)
    
    info "Testing workflow: $workflow_name"
    
    # Check if specific test file exists
    local test_file="$SCRIPT_DIR/unit/workflows/test_${workflow_name}.sh"
    
    if [[ -f "$test_file" ]]; then
        info "Running specific tests for $workflow_name..."
        if bash "$test_file"; then
            success "Workflow $workflow_name passed all tests"
            ((WORKFLOWS_PASSED++))
            return 0
        else
            fail "Workflow $workflow_name failed tests"
            ((WORKFLOWS_FAILED++))
            return 1
        fi
    else
        info "Running generic tests for $workflow_name..."
        if test_workflow_generic "$workflow_file"; then
            success "Workflow $workflow_name passed generic tests"
            ((WORKFLOWS_PASSED++))
            return 0
        else
            fail "Workflow $workflow_name failed generic tests"
            ((WORKFLOWS_FAILED++))
            return 1
        fi
    fi
}

# Generic workflow tests
test_workflow_generic() {
    local workflow_file="$1"
    local workflow_name
    workflow_name=$(basename "$workflow_file")
    
    local tests_passed=0
    local tests_failed=0
    
    # Test 1: Valid YAML
    if python3 -c "import yaml; yaml.safe_load(open('$workflow_file'))" &>/dev/null; then
        success "  ✓ Valid YAML syntax"
        ((tests_passed++))
    else
        fail "  ✗ Invalid YAML syntax"
        ((tests_failed++))
    fi
    
    # Test 2: Has name
    if yq eval '.name' "$workflow_file" | grep -q .; then
        success "  ✓ Has workflow name"
        ((tests_passed++))
    else
        fail "  ✗ Missing workflow name"
        ((tests_failed++))
    fi
    
    # Test 3: Has trigger
    if yq eval '.on' "$workflow_file" | grep -q .; then
        success "  ✓ Has trigger configuration"
        ((tests_passed++))
    else
        fail "  ✗ Missing trigger configuration"
        ((tests_failed++))
    fi
    
    # Test 4: Has jobs
    if yq eval '.jobs' "$workflow_file" | grep -q .; then
        success "  ✓ Has job definitions"
        ((tests_passed++))
    else
        fail "  ✗ Missing job definitions"
        ((tests_failed++))
    fi
    
    # Test 5: Jobs have runners
    local jobs_without_runners
    jobs_without_runners=$(yq eval '.jobs | to_entries[] | select(.value.runs-on == null) | .key' "$workflow_file")
    if [[ -z "$jobs_without_runners" ]]; then
        success "  ✓ All jobs have runners specified"
        ((tests_passed++))
    else
        fail "  ✗ Jobs missing runners: $jobs_without_runners"
        ((tests_failed++))
    fi
    
    # Test 6: Uses modern action versions
    if grep -q "actions/checkout@v[4-9]" "$workflow_file"; then
        success "  ✓ Uses modern action versions"
        ((tests_passed++))
    elif grep -q "actions/checkout" "$workflow_file"; then
        fail "  ✗ Uses outdated action versions"
        ((tests_failed++))
    else
        success "  ✓ No checkout action found (acceptable)"
        ((tests_passed++))
    fi
    
    # Test 7: Has appropriate permissions if using tokens
    if grep -q "GITHUB_TOKEN\|github.token" "$workflow_file"; then
        if yq eval '.permissions' "$workflow_file" | grep -q .; then
            success "  ✓ Has permissions defined for token usage"
            ((tests_passed++))
        else
            fail "  ✗ Uses tokens but missing permissions"
            ((tests_failed++))
        fi
    else
        success "  ✓ No token usage detected"
        ((tests_passed++))
    fi
    
    info "  Generic tests: $tests_passed passed, $tests_failed failed"
    
    if [[ $tests_failed -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# Generate workflow test documentation
generate_test_docs() {
    local docs_file="$PROJECT_ROOT/docs/workflow-testing.md"
    
    info "Generating workflow test documentation..."
    
    cat > "$docs_file" << 'EOF'
# GitHub Actions Workflow Testing Guide

This document describes the comprehensive testing framework for GitHub Actions workflows in the AI Evolution Engine.

## Overview

All GitHub Actions workflows must be thoroughly tested to ensure:
- **Reliability**: Workflows execute successfully under expected conditions
- **Security**: Proper permissions and secure handling of secrets
- **Maintainability**: Clear structure and documentation
- **Functionality**: All features work as intended

## Testing Framework Structure

```
tests/
├── unit/
│   └── workflows/
│       ├── test_ai_evolver.sh      # Tests for ai_evolver.yml
│       ├── test_daily_evolution.sh # Tests for daily_evolution.yml
│       └── ...                     # Additional workflow tests
└── workflow_test_runner.sh         # Main test runner
```

## Running Workflow Tests

### Run All Workflow Tests
```bash
./tests/workflow_test_runner.sh
```

### Run Specific Workflow Tests
```bash
./tests/unit/workflows/test_ai_evolver.sh
./tests/unit/workflows/test_daily_evolution.sh
```

### Integration with Main Test Suite
```bash
# Run all tests including workflows
./tests/test_runner.sh

# Run only workflow tests
./tests/test_runner.sh --type workflow
```

## Test Categories

### 1. Structural Tests
- **YAML Validity**: Ensures workflows are valid YAML
- **Required Fields**: Validates presence of name, triggers, jobs
- **Job Configuration**: Checks runner specifications and job structure

### 2. Security Tests
- **Permission Scoping**: Validates appropriate permission levels
- **Secret Handling**: Ensures secure token usage
- **Action Versions**: Checks for secure, up-to-date action versions

### 3. Functional Tests
- **Input Validation**: Tests workflow inputs and parameters
- **Trigger Configuration**: Validates schedule and manual triggers
- **Step Logic**: Tests individual workflow steps and their logic

### 4. Integration Tests
- **Script Integration**: Validates calls to helper scripts
- **Environment Variables**: Tests proper variable handling
- **Error Handling**: Ensures graceful error handling

## Writing Workflow Tests

### Test File Structure
Each workflow should have a corresponding test file:
```bash
#!/bin/bash
# Unit Tests for [Workflow Name]
# Tests all aspects of the [workflow_file.yml] workflow

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
WORKFLOW_FILE="$PROJECT_ROOT/.github/workflows/workflow_name.yml"

# Test functions...
```

### Test Function Example
```bash
test_workflow_inputs() {
    info "Testing workflow inputs..."
    
    run_test "Has required input" "yq eval '.on.workflow_dispatch.inputs.required_param.required' '$WORKFLOW_FILE' | grep -q 'true'"
    run_test "Input has correct type" "yq eval '.on.workflow_dispatch.inputs.param.type' '$WORKFLOW_FILE' | grep -q 'string'"
}
```

## Test Standards

### 1. Mandatory Tests
Every workflow must test:
- ✅ YAML syntax validity
- ✅ Required workflow structure
- ✅ Job runner specifications
- ✅ Permission configurations
- ✅ Action version currency

### 2. Conditional Tests
Based on workflow features:
- 🔍 Input validation (if has inputs)
- 🔍 Schedule validation (if scheduled)
- 🔍 Environment variable handling (if uses env vars)
- 🔍 Script integration (if calls scripts)

### 3. Security Tests
All workflows must verify:
- 🔒 Proper permission scoping
- 🔒 Secure secret handling
- 🔒 No hardcoded credentials
- 🔒 Updated action versions

## Continuous Integration

Workflow tests are automatically run:
- ✨ On every pull request
- ✨ Before workflow deployment
- ✨ As part of daily evolution checks

## Best Practices

### 1. Test-Driven Workflow Development
```bash
# 1. Write tests first
echo "test_new_feature() { ... }" >> test_workflow.sh

# 2. Implement workflow feature
# 3. Run tests to verify
./tests/unit/workflows/test_workflow.sh

# 4. Refine until tests pass
```

### 2. Comprehensive Coverage
- Test all inputs and outputs
- Validate all conditional logic
- Check error handling paths
- Verify environment variable usage

### 3. Documentation Integration
- Document test purpose and scope
- Include usage examples
- Maintain test documentation
- Link to workflow documentation

## Troubleshooting

### Common Issues
1. **yq not found**: Install yq dependency
2. **Python import error**: Install PyYAML
3. **Permission denied**: Make test scripts executable
4. **YAML parsing errors**: Check workflow syntax

### Debug Mode
```bash
# Run with verbose output
VERBOSE=true ./tests/workflow_test_runner.sh

# Run specific test with debugging
bash -x ./tests/unit/workflows/test_workflow.sh
```

## Contributing

When adding new workflows:
1. ✍️ Create corresponding test file
2. ✍️ Implement comprehensive tests
3. ✍️ Update this documentation
4. ✍️ Run full test suite
5. ✍️ Include tests in PR

For more information, see [CONTRIBUTING.md](../CONTRIBUTING.md).
EOF

    success "Generated workflow test documentation: $docs_file"
}

# Main execution
main() {
    show_banner
    install_dependencies
    
    info "Starting comprehensive workflow testing..."
    info "Discovering workflow files..."
    
    local workflows
    if ! workflows=$(discover_workflows); then
        warn "No workflow files found to test"
        return 0
    fi
    
    info "Found $TOTAL_WORKFLOWS workflow files"
    
    # Test each workflow
    while IFS= read -r workflow; do
        [[ -n "$workflow" ]] && test_workflow "$workflow"
    done <<< "$workflows"
    
    # Generate documentation
    generate_test_docs
    
    # Show results
    echo ""
    echo "=== Final Results ==="
    echo "Total Workflows: $TOTAL_WORKFLOWS"
    echo "Workflows Passed: $WORKFLOWS_PASSED"
    echo "Workflows Failed: $WORKFLOWS_FAILED"
    
    if [[ $WORKFLOWS_FAILED -eq 0 ]]; then
        success "All workflows passed testing!"
        return 0
    else
        error "Some workflows failed testing!"
        return 1
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# Show help
show_help() {
    cat << EOF
GitHub Actions Workflow Test Runner

Usage: $0 [OPTIONS]

Options:
    -v, --verbose       Enable verbose output
    -h, --help          Show this help message

Examples:
    $0                  # Run all workflow tests
    $0 --verbose        # Run with detailed output
EOF
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    parse_args "$@"
    main
fi
