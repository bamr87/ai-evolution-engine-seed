<!--
@file tests/MIGRATION_NOTICE.md
@description Migration notice for test framework reorganization
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 1.0.0

@relatedIssues 
  - #test-framework-reorganization: Category-specific artifact directories
  - #migration-documentation: Clear migration path for developers

@relatedEvolutions
  - v1.0.0: Initial migration notice for framework restructure

@dependencies
  - None

@changelog
  - 2025-07-05: Initial creation with migration guidelines - ITJ

@usage Reference for developers migrating to new test structure
@notes Temporary file - can be removed after migration is complete
-->

# Test Framework Migration Notice

## Migration Completed: July 5, 2025

The test framework has been reorganized to use category-specific artifact directories instead of global artifact storage.

## Changes Made

### Old Structure (Deprecated)

```text
tests/
├── test-logs/          # ❌ DEPRECATED
├── test-results/       # ❌ DEPRECATED
├── test-reports/       # ❌ DEPRECATED
└── archives/
```

### New Structure (Current)

```text
tests/
├── unit/
│   ├── logs/           # ✅ Unit test logs
│   ├── results/        # ✅ Unit test results
│   └── reports/        # ✅ Unit test reports
├── integration/
│   ├── logs/           # ✅ Integration test logs
│   ├── results/        # ✅ Integration test results
│   └── reports/        # ✅ Integration test reports
├── unit/workflows/
│   ├── logs/           # ✅ Workflow test logs
│   ├── results/        # ✅ Workflow test results
│   └── reports/        # ✅ Workflow test reports
└── archives/           # ✅ Unchanged - long-term storage
```

## Benefits

1. **Organized Artifacts**: Each test category manages its own artifacts
2. **Easier Debugging**: Artifacts are co-located with test files
3. **Better Isolation**: No cross-contamination between test categories
4. **Improved Cleanup**: Category-specific cleanup capabilities

## Action Required

### For Developers

1. **Update Scripts**: Any custom scripts referencing old paths need updating
2. **Clean Old Directories**: Remove deprecated `test-*` directories when ready
3. **Update Documentation**: Reference new artifact locations

### For CI/CD

1. **Update Workflows**: Modify any workflow steps that reference old paths
2. **Update Artifact Collection**: Point to new category-specific directories
3. **Update Retention Policies**: Apply policies per category

## Migration Commands

### Safe Cleanup (After Verification)

```bash
# Verify new structure is working
./test_runner.sh --type unit

# If everything works, clean up old directories
rm -rf test-logs/ test-results/ test-reports/

# Update any custom scripts or workflows
```

### Rollback (If Needed)

```bash
# Temporarily recreate old directories if rollback needed
mkdir -p test-logs test-results test-reports

# Note: This is for emergency rollback only
```

## Updated Commands

### Test Execution

```bash
# Same commands - no change needed
./test_runner.sh
./test_runner.sh --type unit
./test_runner.sh --type integration
```

### Artifact Management

```bash
# Enhanced with category support
./manage-test-artifacts.sh status
./manage-test-artifacts.sh status --category unit
./manage-test-artifacts.sh cleanup --category integration
```

## Verification

To verify the migration is working correctly:

1. **Run Tests**: Execute test suites and verify artifacts appear in correct locations
2. **Check Logs**: Ensure logs are written to category-specific directories
3. **Validate Results**: Confirm JSON results are generated properly
4. **Review Reports**: Check that human-readable reports are created

## Support

If you encounter issues with the migration:

1. Check the `tests/README.md` for updated documentation
2. Review individual README files in artifact directories
3. Run `./manage-test-artifacts.sh status` to see current state
4. Consult test logs in the appropriate category directory

---

**This migration notice can be removed once all teams have successfully migrated to the new structure.**
