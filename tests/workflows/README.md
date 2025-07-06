<!--
@file tests/workflows/README.md
@description Documentation for workflow testing directory
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-06
@lastModified 2025-07-06
@version 1.0.0

@relatedIssues 
  - Workflow testing organization and documentation

@relatedEvolutions
  - v1.0.0: Initial creation during test reorganization

@dependencies
  - GitHub Actions workflows in .github/workflows/

@changelog
  - 2025-07-06: Initial creation - ITJ

@usage Reference documentation for workflow testing tools
@notes Centralized location for all workflow-related tests
-->

# Workflow Testing Directory

This directory contains all testing tools and scripts related to GitHub Actions workflows and CI/CD pipeline validation.

## Purpose

The `tests/workflows/` directory provides comprehensive testing capabilities for:

- GitHub Actions workflow validation
- Local workflow simulation
- CI/CD pipeline debugging
- Workflow syntax checking
- Integration testing for automation

## Files Overview

### Core Testing Scripts

| File | Purpose | Usage |
|------|---------|-------|
| `test-all-workflows-local.sh` | Comprehensive workflow testing suite | `./test-all-workflows-local.sh` |
| `test-daily-evolution-local.sh` | Daily evolution workflow testing | `./test-daily-evolution-local.sh` |
| `test-workflow.sh` | Advanced workflow debugging and testing | `./test-workflow.sh [command] [options]` |

### Key Features

#### test-all-workflows-local.sh
- **YAML Syntax Validation**: Checks all workflow files for valid YAML
- **Script Dependency Checking**: Verifies required scripts exist
- **Comprehensive Testing**: Runs all workflows through validation
- **Error Reporting**: Detailed feedback on failures

#### test-daily-evolution-local.sh
- **Environment Simulation**: Tests evolution workflow conditions
- **Health Check Validation**: Verifies repository health analysis
- **Evolution Trigger Testing**: Validates evolution decision logic
- **Output Verification**: Checks expected files are created

#### test-workflow.sh
- **Local Execution**: Run workflows locally with `act`
- **Debug Mode**: Enhanced debugging with detailed output
- **Remote Analysis**: Fetch and analyze GitHub Action logs
- **Syntax Validation**: Check workflow file syntax
- **Custom Testing**: Support for specific scenarios and prompts

## Usage Examples

### Basic Workflow Testing
```bash
# Test all workflows comprehensively
./tests/workflows/test-all-workflows-local.sh

# Test daily evolution specifically  
./tests/workflows/test-daily-evolution-local.sh

# Setup workflow testing environment
./tests/workflows/test-workflow.sh setup
```

### Advanced Testing Scenarios
```bash
# Run workflow locally with custom prompt
./tests/workflows/test-workflow.sh local --prompt "Add authentication system"

# Debug workflow with enhanced output
./tests/workflows/test-workflow.sh debug --prompt "Test feature X"

# Validate workflow syntax only
./tests/workflows/test-workflow.sh validate

# Simulate workflow without changes
./tests/workflows/test-workflow.sh dry-run --prompt "Test simulation"
```

### Log Analysis
```bash
# Fetch recent GitHub Action logs
./tests/workflows/test-workflow.sh logs

# Analyze specific workflow failures
./tests/workflows/test-workflow.sh logs --workflow daily_evolution
```

## Dependencies

### Required Tools
- **bash** >=4.0: Shell execution environment
- **python3**: YAML syntax validation
- **act**: Local GitHub Actions execution (optional)
- **gh**: GitHub CLI for remote operations (optional)
- **docker**: Container runtime for local testing (optional)

### Environment Setup
```bash
# Install act for local testing
# macOS
brew install act

# Ubuntu/Debian
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Install GitHub CLI
# macOS
brew install gh

# Ubuntu/Debian  
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

## Integration with Evolution Engine

### Workflow Testing in Evolution Cycles
- **Pre-Evolution**: Validate workflows before changes
- **Post-Evolution**: Test new workflow configurations
- **Regression Testing**: Ensure changes don't break existing functionality
- **Performance Monitoring**: Track workflow execution times

### Automated Quality Assurance
- **Syntax Validation**: Prevent invalid YAML from being committed
- **Dependency Checking**: Ensure all referenced scripts exist
- **Integration Testing**: Verify workflows work with current repository state
- **Health Monitoring**: Track workflow success rates and failure patterns

## Best Practices

### Local Testing
1. **Always test locally** before pushing workflow changes
2. **Use dry-run mode** for initial testing
3. **Validate syntax first** before functional testing
4. **Test with realistic data** and scenarios

### Debugging Workflows
1. **Enable debug output** for troubleshooting
2. **Test individual jobs** when possible
3. **Use local secrets file** for authentication testing
4. **Analyze logs systematically** when failures occur

### Continuous Improvement
1. **Update tests** when workflows change
2. **Add new test cases** for edge conditions
3. **Monitor test performance** and optimize as needed
4. **Document failures** and their solutions

## Contributing

When adding new workflow tests:
1. Follow the established file header format
2. Include comprehensive error handling
3. Add usage examples and documentation
4. Test thoroughly before committing
5. Update this README with new capabilities

## Related Documentation

- [GitHub Actions Debugging Guide](../../docs/GITHUB_ACTIONS_DEBUGGING.md)
- [Evolution Engine Documentation](../../docs/EVOLUTION_ENGINE.md)
- [Testing Strategy](../README.md)
- [CI/CD Best Practices](../../docs/CI_CD_BEST_PRACTICES.md)
