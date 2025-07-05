<!--
@file tests/unit/logs/README.md
@description Documentation for unit test execution logs directory
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 1.0.0

@relatedIssues 
  - #test-artifact-management: Category-specific artifact storage
  - #test-framework-reorganization: Structured logging implementation

@relatedEvolutions
  - v1.0.0: Initial implementation with organized log storage

@dependencies
  - Parent test execution scripts for log generation

@changelog
  - 2025-07-05: Initial creation with artifact organization - ITJ

@usage Automatic log storage during unit test execution
@notes Logs are automatically timestamped and organized by test run
-->

# Unit Test Logs Directory

This directory contains execution logs for unit tests, providing detailed debugging information and test execution traces.

## Log Organization

### File Naming Convention

```text
{test_name}_test_{YYYYMMDD-HHMMSS}.log
```

**Examples:**
- `project_structure_test_20250705-143022.log`
- `ai_evolver_test_20250705-143125.log`

### Log Content Structure

Each log file contains:

1. **Test Execution Header**
   - Test run ID and timestamp
   - Test file and version information
   - Environment and dependency information

2. **Test Progress Output**
   - Real-time test execution progress
   - Success/failure indicators for each test
   - Detailed error messages and stack traces

3. **Artifact Location Information**
   - Paths to related results and reports
   - Cross-references to other test artifacts

## Log Retention

- **Default Retention**: 30 days
- **Cleanup Policy**: Managed by `../manage-test-artifacts.sh`
- **Manual Cleanup**: Can be cleaned selectively by test category

## Log Analysis

### Common Log Patterns

**Successful Test:**
```
[INFO] Starting test: Project structure validation
✓ README.md exists and is not empty
✓ LICENSE file exists
```

**Failed Test:**
```
[INFO] Starting test: Script permissions
✗ Generate seed script is executable
[ERROR] Script not found: /path/to/script.sh
```

### Debugging Tips

1. **Search for Error Patterns:**
   ```bash
   grep -n "ERROR\|FAIL\|✗" *.log
   ```

2. **Find Specific Test Results:**
   ```bash
   grep -A 5 -B 5 "test_name" *.log
   ```

3. **Check Test Execution Time:**
   ```bash
   grep "start_time\|end_time" *.log
   ```

## Integration with Test Framework

These logs are automatically generated when:
- Unit tests are executed via `test_runner.sh`
- Individual test files are run directly
- CI/CD workflows execute test suites

## Best Practices

1. **Log Review**: Always check logs after test failures
2. **Pattern Analysis**: Look for recurring error patterns
3. **Performance Monitoring**: Monitor test execution times
4. **Environment Issues**: Check for dependency-related errors

## Related Artifacts

- **Results**: `../results/` - Machine-readable test outcomes
- **Reports**: `../reports/` - Human-readable summaries
- **Archives**: `../../archives/` - Long-term storage for important test runs
