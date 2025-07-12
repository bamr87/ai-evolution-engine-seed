<!--
@file tests/README.md
@description Comprehensive testing framework documentation for AI Evolution Engine
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 2.0.0

@relatedIssues 
  - Testing framework reorganization and standardization
  - Implementation of modular test artifact management

@relatedEvolutions
  - v2.0.0: Major restructure with category-specific artifact directories
  - v1.0.0: Initial testing framework implementation

@dependencies
  - bash: >=4.0
  - jq: for JSON processing in tests

@changelog
  - 2025-07-05: Reorganized directory structure with category-specific artifacts - ITJ
  - 2025-07-05: Updated documentation with new standards - ITJ

@usage Reference documentation for test framework organization and usage
@notes Each test category maintains its own logs, results, and reports
-->

# Testing Framework Documentation

This directory contains the comprehensive testing framework for the AI Evolution Engine, featuring organized test artifacts and management tools with category-specific storage.

## Directory Structure

```text
tests/
├── README.md                           # This documentation
├── manage-test-artifacts.sh            # Test artifact management script
├── modular-architecture-test.sh        # Core architecture validation
├── comprehensive-refactoring-test.sh   # Refactoring validation
├── test_runner.sh                      # Legacy test runner
├── workflow_test_runner.sh             # Workflow-specific test runner
├── workflows/                           # Workflow testing directory
│   ├── README.md                      # Workflow testing documentation
│   ├── test-all-workflows-local.sh   # Comprehensive workflow testing
│   ├── test-daily-evolution-local.sh # Daily evolution workflow testing
│   └── test-workflow.sh              # Advanced workflow debugging
├── seed/                              # Seed testing directory
│   ├── README.md                      # Seed testing documentation
│   └── test-evolved-seed.sh          # Evolved seed functionality testing
├── lib/                               # Library testing directory
│   ├── README.md                      # Library testing documentation
│   └── test-modular-library.sh       # Modular library system testing
├── fixtures/                           # Test data and fixtures
├── unit/                               # Unit tests
│   ├── logs/                          # Unit test execution logs
│   ├── results/                       # Unit test results (JSON)
│   ├── reports/                       # Unit test reports (Markdown/HTML)
│   ├── test_project_structure.sh     # Project structure validation
│   └── workflows/                     # Workflow unit tests
│       ├── logs/                      # Workflow test logs
│       ├── results/                   # Workflow test results
│       ├── reports/                   # Workflow test reports
│       ├── test_ai_evolver.sh         # AI evolver workflow tests
│       ├── test_daily_evolution.sh    # Daily evolution tests
│       └── test_daily_evolution_backup.sh
├── integration/                        # Integration tests
│   ├── logs/                          # Integration test logs
│   ├── results/                       # Integration test results
│   ├── reports/                       # Integration test reports
│   ├── test_full_workflow.sh          # Full workflow integration
│   └── test_workflow_integration.sh   # Workflow integration tests
└── archives/                          # Long-term test archives (optional)
```

## Test Artifact Organization

### Category-Specific Artifact Storage

Each test category (`unit/`, `integration/`, `unit/workflows/`) maintains its own artifact directories:

#### `logs/` Directories

- Detailed execution logs for debugging
- Error traces and diagnostic information
- Performance metrics and timing data
- Automatically timestamped and rotated

#### `results/` Directories

- JSON-formatted test results
- Individual test execution outcomes
- Test suite summaries and statistics
- Machine-readable data for automation

#### `reports/` Directories

- Human-readable test reports (Markdown/HTML)
- Summary dashboards and visualizations
- Stakeholder-friendly documentation
- Historical trend analysis

### Artifact Management Principles

#### Design for Failure (DFF)

- All artifacts are retained until explicitly cleaned
- Failed test runs preserve full diagnostic information
- Redundant storage prevents data loss during cleanup

#### Don't Repeat Yourself (DRY)

- Common artifact management functions are centralized
- Template-based report generation eliminates duplication
- Shared utilities handle logging and result formatting

#### Keep It Simple (KIS)

- Clear directory structure with intuitive naming
- Standardized artifact formats across all test categories
- Simple cleanup and archival processes

## Test Artifact Management Commands

### Status and Information

```bash
# Show current test artifacts status across all categories
./manage-test-artifacts.sh status

# Show artifacts for specific test category
./manage-test-artifacts.sh status --category unit
./manage-test-artifacts.sh status --category integration
```

### Cleanup Operations

```bash
# Clean up artifacts but keep reports for reference
./manage-test-artifacts.sh cleanup --keep-reports

# Clean specific category artifacts
./manage-test-artifacts.sh cleanup --category unit
./manage-test-artifacts.sh cleanup --category integration

# Clean all artifacts (destructive)
./manage-test-artifacts.sh cleanup --all

# Auto-cleanup old artifacts (older than 7 days)
./manage-test-artifacts.sh auto-cleanup --days 7
```

### Archiving

```bash
# Archive current artifacts before cleanup
./manage-test-artifacts.sh archive --name "release-v1.0"

# Archive specific test category
./manage-test-artifacts.sh archive --category unit --name "unit-tests-milestone"

# List archived artifacts
./manage-test-artifacts.sh list-archives
```

### Nuclear Options

```bash
# Purge everything including archives (use with extreme caution)
./manage-test-artifacts.sh purge-all --confirm

# Reset test environment completely
./manage-test-artifacts.sh reset --confirm
```

## Test Execution Workflow

### Running Tests

```bash
# Run all tests
./test_runner.sh

# Run specific test category
./test_runner.sh --type unit
./test_runner.sh --type integration

# Run workflow-specific tests
./workflow_test_runner.sh

# Run with verbose output
./test_runner.sh --verbose
```

### Test Results Processing

1. **Execution**: Test runs generate artifacts in category-specific directories
2. **Logging**: Detailed logs are saved to `logs/` subdirectories
3. **Results**: JSON results are saved to `results/` subdirectories
4. **Reports**: Human-readable reports are generated in `reports/` subdirectories

### Artifact Lifecycle

1. **Creation**: During test execution
2. **Retention**: Until manual cleanup or auto-cleanup threshold
3. **Archiving**: Optional long-term storage
4. **Cleanup**: Automated or manual removal

## Integration with CI/CD

### GitHub Actions Integration

Test artifacts are automatically managed in CI/CD pipelines:

- Test execution generates artifacts in appropriate category directories
- Failed tests preserve full diagnostic information
- Artifacts are conditionally uploaded as workflow artifacts
- Historical data is maintained for trend analysis

### Artifact Retention Policies

- **Logs**: Kept for 30 days by default
- **Results**: Kept for 90 days by default
- **Reports**: Kept indefinitely until manual cleanup
- **Archives**: Manually managed, no automatic expiration

## Configuration

### Environment Variables

```bash
# Test artifact retention (days)
TEST_ARTIFACT_RETENTION_DAYS=30

# Enable verbose logging
TEST_VERBOSE_LOGGING=true

# Automatic cleanup threshold
TEST_AUTO_CLEANUP_THRESHOLD=7
```

### Test Categories

- **Unit Tests**: Fast, isolated tests for individual components
- **Integration Tests**: Tests for component interactions
- **Workflow Tests**: Tests for GitHub Actions workflows
- **End-to-End Tests**: Full system validation tests

## Best Practices

### Test Organization

- Use descriptive test names that explain what is being tested
- Group related tests in the same directory
- Follow the DRY principle for test utilities
- Implement proper error handling in all tests

### Artifact Management

- Regularly review and clean up old artifacts
- Archive important test runs before cleanup
- Use descriptive names for archived artifacts
- Monitor disk usage and implement cleanup policies

### Debugging

- Always check the appropriate `logs/` directory for detailed error information
- Use the `results/` directory for programmatic analysis
- Consult the `reports/` directory for human-readable summaries
- Enable verbose logging for troubleshooting

## Troubleshooting

### Common Issues

#### Missing Dependencies

- Install `jq` for JSON processing: `brew install jq` (macOS)
- Ensure `bash` version 4.0 or higher
- Verify script permissions: `chmod +x manage-test-artifacts.sh`

#### Artifact Storage Issues

- Check disk space: `df -h`
- Verify directory permissions
- Ensure `tar` and `gzip` are available for archiving

#### Test Execution Problems

- Review logs in the appropriate `logs/` directory
- Check for missing test dependencies
- Verify test environment setup
- Ensure `init_testing` is called with proper base directory

### Getting Help

1. Check the logs in the appropriate category's `logs/` directory
2. Review the test results in the `results/` directory
3. Consult the generated reports in the `reports/` directory
4. Run tests with verbose output for additional debugging information
5. Use the artifact management script to inspect current state

## Contributing

### Adding New Tests

1. Create test files in the appropriate category directory
2. Follow the standard file header format
3. Use the modular testing framework
4. Implement proper error handling
5. Update documentation as needed

### Modifying Existing Tests

1. Preserve backward compatibility when possible
2. Update version numbers and changelog entries
3. Test changes thoroughly before committing
4. Update related documentation

### Test Framework Development

1. Follow the established patterns and conventions
2. Maintain category-specific artifact storage
3. Implement proper logging and error handling
4. Document all changes and additions
5. Consider impact on CI/CD integration

For detailed contribution guidelines, see the main project CONTRIBUTING.md file.
