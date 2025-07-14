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
./tests/run_tests.sh

# Run only workflow tests
./tests/run_tests.sh run workflow
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
