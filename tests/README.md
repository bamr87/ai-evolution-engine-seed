# Testing Framework Documentation

This directory contains the comprehensive testing framework for the AI Evolution Engine, featuring organized test artifacts and management tools.

## Directory Structure

```
tests/
├── README.md                           # This documentation
├── manage-test-artifacts.sh            # Test artifact management script
├── modular-architecture-test.sh        # Core architecture validation
├── comprehensive-refactoring-test.sh   # Refactoring validation
├── test_runner.sh                      # Legacy test runner
├── test-results/                       # JSON test results (temporary)
├── test-reports/                       # Markdown/HTML reports (temporary)
├── test-logs/                          # Execution logs (temporary)
└── archives/                           # Long-term test archives (optional)
```

## Test Artifact Organization

### Temporary Directories (Git Ignored)

**`test-results/`** - JSON test result files
- Individual test execution results
- Test suite summaries
- Performance metrics
- Created during test runs, cleaned up automatically

**`test-reports/`** - Human-readable test reports
- Markdown formatted reports
- HTML dashboards (if generated)
- Summary reports for stakeholders
- Can be preserved during cleanup for reference

**`test-logs/`** - Detailed execution logs
- Debug information
- Error traces
- Performance data
- Automatically rotated and cleaned

### Permanent Storage

**`archives/`** - Long-term test artifact storage
- Compressed archives of important test runs
- Historical data for trend analysis
- Manually created via management script

## Test Management Commands

### Status and Information
```bash
# Show current test artifacts status
./manage-test-artifacts.sh status

# Show help and available commands
./manage-test-artifacts.sh --help
```

### Cleanup Operations
```bash
# Clean up all temporary test artifacts
./manage-test-artifacts.sh cleanup

# Clean up but preserve test reports
./manage-test-artifacts.sh cleanup keep-reports

# Auto-cleanup artifacts older than 7 days
./manage-test-artifacts.sh auto-cleanup

# Auto-cleanup artifacts older than 3 days
./manage-test-artifacts.sh auto-cleanup 3
```

### Archiving
```bash
# Archive current test artifacts with auto-generated name
./manage-test-artifacts.sh archive

# Archive with custom name
./manage-test-artifacts.sh archive "release-v1.0-tests"

# Archive and cleanup original files
./manage-test-artifacts.sh archive "milestone-tests"
./manage-test-artifacts.sh cleanup
```

### Nuclear Options
```bash
# Remove ALL test artifacts including archives (requires confirmation)
PURGE_CONFIRM=true ./manage-test-artifacts.sh purge
```

## Test Framework Integration

### For Test Scripts

When creating new test scripts, use the organized structure:

```bash
#!/bin/bash
set -euo pipefail

# Source the testing framework
source "../src/lib/core/testing.sh"

# Initialize with proper directory structure
init_testing "my-test-session" "tests"

# Your tests here...
start_test_suite "example_tests"
run_test "Example test" "echo 'Hello, World!'"
end_test_suite

# Generate reports and finalize
generate_test_report
finalize_testing
```

### For CI/CD Integration

The testing framework supports automated cleanup and archiving:

```yaml
# Example GitHub Actions integration
- name: Run Tests
  run: ./tests/comprehensive-refactoring-test.sh

- name: Archive Test Results
  if: always()
  run: ./tests/manage-test-artifacts.sh archive "ci-build-${{ github.run_number }}"

- name: Cleanup Temporary Artifacts
  if: always()
  run: ./tests/manage-test-artifacts.sh cleanup keep-reports
```

## Best Practices

### Development Workflow

1. **During Development**: Let temporary artifacts accumulate for debugging
2. **After Debugging**: Use `cleanup keep-reports` to preserve summaries
3. **Before Releases**: Archive important test runs for historical reference
4. **Regular Maintenance**: Use `auto-cleanup` to prevent disk bloat

### Debugging Failed Tests

1. Check `test-logs/` for detailed execution logs
2. Review `test-results/` for specific failure data
3. Examine `test-reports/` for high-level summaries
4. Archive the session before cleanup for future reference

### Performance Considerations

- Test artifacts are automatically cleaned to prevent disk usage issues
- Archives are compressed to minimize storage requirements
- Old artifacts are auto-cleaned based on age policies
- Large test outputs are truncated in reports

## Integration with Modular Architecture

The testing framework leverages the modular architecture:

- **`src/lib/core/testing.sh`**: Core testing functionality
- **`src/lib/core/logger.sh`**: Unified logging across tests
- **`src/lib/core/environment.sh`**: Environment detection and validation

This ensures consistent behavior across all test scenarios and easy maintenance of the testing infrastructure.

## Troubleshooting

### Common Issues

**Test artifacts not being created:**
- Ensure `init_testing` is called with proper base directory
- Check permissions on the tests directory

**Cleanup not working:**
- Verify script permissions: `chmod +x manage-test-artifacts.sh`
- Check for running test processes that may lock files

**Archives not being created:**
- Ensure `tar` and `gzip` are available
- Check disk space availability
- Verify test artifacts exist before archiving

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
export LOG_LEVEL=DEBUG
./tests/comprehensive-refactoring-test.sh
```

This will provide detailed information about test execution and artifact management operations.
