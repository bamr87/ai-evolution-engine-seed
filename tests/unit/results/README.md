<!--
@file tests/unit/results/README.md
@description Documentation for unit test results directory
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 1.0.0

@relatedIssues 
  - #test-artifact-management: Category-specific artifact storage
  - #test-framework-reorganization: Structured results storage

@relatedEvolutions
  - v1.0.0: Initial implementation with JSON-based result storage

@dependencies
  - jq: for JSON processing and validation

@changelog
  - 2025-07-05: Initial creation with artifact organization - ITJ

@usage Automatic result storage during unit test execution
@notes Results are machine-readable JSON files for automation and analysis
-->

# Unit Test Results Directory

This directory contains machine-readable test results in JSON format for programmatic analysis and automation integration.

## Result File Structure

### File Naming Convention

```text
{test_name}_results_{YYYYMMDD-HHMMSS}.json
```

### JSON Schema

Each result file follows this structure:

```json
{
  "test_run_id": "test_name_YYYYMMDD-HHMMSS",
  "start_time": "2025-07-05T14:30:22.000Z",
  "end_time": "2025-07-05T14:30:45.000Z",
  "summary": {
    "total": 15,
    "passed": 14,
    "failed": 1,
    "success_rate": 93
  },
  "tests": [
    {
      "name": "Test description",
      "result": "PASSED|FAILED",
      "error": "Error message if failed",
      "timestamp": "2025-07-05T14:30:25.000Z"
    }
  ]
}
```

## Data Analysis

### Query Examples

**Count total tests:**

```bash
jq '.summary.total' results/*.json
```

**Find failed tests:**

```bash
jq -r '.tests[] | select(.result == "FAILED") | .name' results/*.json
```

**Calculate success rate:**

```bash
jq '.summary.success_rate' results/*.json | awk '{sum+=$1; count++} END {print sum/count}'
```

## Integration Points

- **CI/CD Systems**: Parse results for build status decisions
- **Reporting Tools**: Generate trends and analytics
- **Quality Gates**: Automated quality threshold validation
- **Monitoring**: Test suite health tracking

## Retention Policy

- **Default Retention**: 90 days
- **Cleanup**: Managed automatically via artifact management
- **Archiving**: Important results archived before cleanup
