# Workflow Error Collection System

## Overview

The AI Evolution Engine now includes a comprehensive error and warning collection system that captures, analyzes, and reports issues from GitHub Actions workflow runs. This system provides detailed summaries to help with troubleshooting and workflow optimization.

## Features

### 🔍 **Comprehensive Error Detection**
- Scans workflow step outputs for errors and warnings
- Analyzes log files for error patterns
- Checks environment variables for failure indicators
- Processes GitHub Actions step summaries

### 📊 **Detailed Reporting**
- Generates structured JSON summaries with metadata
- Creates visual reports in GitHub Actions step summaries
- Provides actionable recommendations for issue resolution
- Tracks error severity levels (low, medium, high)

### 🔧 **Multi-Source Collection**
- **Step Outputs**: Captures errors from individual workflow steps
- **Log Files**: Scans recent log files for error patterns
- **Environment**: Checks environment variables for error states
- **GitHub Actions**: Integrates with GitHub Actions reporting

## Implementation

### Enhanced Workflow Files

All four main workflow files have been enhanced with error collection:

1. **`ai_evolver.yml`** - Manual AI evolution workflow
2. **`testing_automation_evolver.yml`** - Testing and build automation
3. **`daily_evolution.yml`** - Scheduled daily evolution
4. **`periodic_evolution.yml`** - Scheduled periodic evolution

### Error Collection Script

The core functionality is provided by `scripts/collect-workflow-errors.sh`:

```bash
# Basic usage
./scripts/collect-workflow-errors.sh \
  --workflow-type "ai_evolver" \
  --job-status "failure" \
  --collect-from-logs \
  --include-context
```

#### Script Options

| Option | Description | Example |
|--------|-------------|---------|
| `--workflow-type` | Type of workflow being monitored | `ai_evolver`, `daily_evolution` |
| `--job-status` | Current job status | `success`, `failure`, `cancelled` |
| `--output-file` | Path to save error summary | `/tmp/errors.json` |
| `--collect-from-logs` | Scan log files for additional errors | (flag) |
| `--include-context` | Include additional context information | (flag) |

## Usage Examples

### In GitHub Actions Workflows

Each enhanced workflow includes an error collection step:

```yaml
- name: 📋 Collect Workflow Errors & Warnings
  if: always()
  id: error_collection
  run: |
    chmod +x ./scripts/collect-workflow-errors.sh
    ./scripts/collect-workflow-errors.sh \
      --workflow-type "ai_evolver" \
      --job-status "${{ job.status }}" \
      --collect-from-logs \
      --include-context
```

### Local Testing

Test the error collection system locally:

```bash
# Test all workflow types
./scripts/test-enhanced-workflows.sh

# Simple functionality test
./test-simple-error-collection.sh

# Comprehensive test suite
./tests/workflows/test-error-collection.sh
```

## Output Format

### JSON Summary Structure

```json
{
  "workflow_error_summary": {
    "metadata": {
      "generated_at": "2025-01-27T12:00:00Z",
      "workflow_type": "ai_evolver",
      "workflow_id": "12345",
      "workflow_attempt": "1",
      "job_status": "failure",
      "job_name": "evolve",
      "repository": "user/repo",
      "ref": "refs/heads/main",
      "actor": "username"
    },
    "summary": {
      "total_errors": 2,
      "total_warnings": 1,
      "overall_status": "has_issues",
      "severity": "high"
    },
    "errors": [
      "Step Summary: ❌ Build failed with exit code 1",
      "build.log: ERROR: Package not found"
    ],
    "warnings": [
      "test.log: WARNING: Deprecated API used"
    ],
    "recommendations": [
      "Review and fix 2 error(s) before next workflow run",
      "Address 1 warning(s) to improve workflow reliability"
    ]
  }
}
```

### GitHub Actions Integration

The system automatically:
- Sets output variables for subsequent steps
- Updates the GitHub Actions step summary with visual reports
- Creates structured error summaries for workflow analysis

#### Output Variables

```bash
echo "errors_found=2" >> $GITHUB_OUTPUT
echo "warnings_found=1" >> $GITHUB_OUTPUT
echo "summary_file=/path/to/summary.json" >> $GITHUB_OUTPUT
echo "overall_status=has_issues" >> $GITHUB_OUTPUT
```

## Error Detection Patterns

### Error Patterns
- `[ERROR]`, `ERROR:`, `Fatal:`, `Exception:`
- Failed commands with exit codes
- Authentication failures
- Timeout errors
- Permission denied errors

### Warning Patterns
- `[WARNING]`, `WARNING:`, `WARN:`
- Deprecated API usage
- Configuration issues
- Fallback behaviors
- Retry attempts

### False Positive Prevention
- Excludes metric reporting lines (e.g., "Total Errors: 0")
- Ignores summary headers and counts
- Focuses on actual error messages rather than statistics

## Configuration

### Environment Variables

The script automatically uses GitHub Actions environment variables when available:

- `GITHUB_RUN_ID` - Workflow run identifier
- `GITHUB_RUN_ATTEMPT` - Attempt number
- `GITHUB_JOB` - Current job name
- `GITHUB_STEP_SUMMARY` - Path to step summary file
- `GITHUB_OUTPUT` - Path to output variables file

### Customization

You can customize error detection by modifying the patterns in the script:

```bash
# Add custom error patterns
if echo "$line" | grep -qi "CUSTOM_ERROR\|SPECIFIC_FAILURE"; then
    ERRORS+=("Custom: $line")
    ((ERRORS_COLLECTED++))
fi
```

## Troubleshooting

### Common Issues

1. **No errors detected when expected**
   - Check if log files are in the expected location (`logs/` directory)
   - Verify error patterns match your log format
   - Ensure the script has proper permissions

2. **Too many false positives**
   - Review the error patterns in the script
   - Add exclusion patterns for your specific use case
   - Check if metrics files are being scanned incorrectly

3. **JSON output format errors**
   - Ensure error messages don't contain unescaped quotes
   - Check for control characters in log files
   - Validate JSON output with `jq empty file.json`

### Testing and Validation

Run the test suite to validate functionality:

```bash
# Quick validation
./test-simple-error-collection.sh

# Comprehensive testing
./tests/workflows/test-error-collection.sh

# Test all workflow types
./scripts/test-enhanced-workflows.sh
```

## Benefits

### 🎯 **Improved Debugging**
- Centralized error collection from all workflow steps
- Structured error summaries for easier analysis
- Historical error tracking through saved summaries

### 📈 **Better Monitoring**
- Automatic error detection and reporting
- Integration with GitHub Actions for visual feedback
- Severity assessment for prioritizing fixes

### 🔄 **Workflow Optimization**
- Identify recurring issues across runs
- Track error patterns and improvements
- Provide actionable recommendations for fixes

## Future Enhancements

- Integration with external monitoring systems
- Email/Slack notifications for critical errors
- Trend analysis across multiple workflow runs
- Custom error pattern configuration files
- Integration with issue tracking systems

## Related Files

- `scripts/collect-workflow-errors.sh` - Main error collection script
- `scripts/test-enhanced-workflows.sh` - Testing script for all workflow types
- `tests/workflows/test-error-collection.sh` - Comprehensive test suite
- `.github/workflows/*.yml` - Enhanced workflow files with error collection
- `logs/` - Directory for error summary output files