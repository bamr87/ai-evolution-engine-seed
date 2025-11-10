# Branch Strategy for AI Evolution Engine

## Overview

The AI Evolution Engine now uses a dedicated branch structure to isolate evolution and testing workflows from the main codebase. This strategy provides better control, review processes, and isolation of automated changes.

## Branch Structure

```
main (stable production code)
  ↓
evolved (evolution target and test source)
  ↓
evolved/evolution-* (individual evolution PRs)
  ↓
test (consolidated test results)
  ↓
test/results-* (individual test run PRs)
```

## Branch Purposes

### `main` Branch
- **Purpose**: Stable, production-ready code
- **Updates**: Manual merges from `evolved` after review
- **Protection**: Should have branch protection rules enabled
- **CI/CD**: Production deployments

### `evolved` Branch
- **Purpose**: Target for all evolution workflows
- **Updates**: Receives PRs from evolution workflow branches
- **Role**: Source branch for testing workflows
- **Review**: All evolution PRs must be reviewed before merging

### `evolved/evolution-*` Branches
- **Purpose**: Individual evolution cycle results
- **Naming**: `evolved/evolution-YYYYMMDD-HHMMSS-<id>`
- **Lifecycle**: Created by evolution workflows, deleted after PR merge
- **PRs**: Target `evolved` branch

### `test` Branch
- **Purpose**: Consolidated test results
- **Updates**: Receives PRs from test result branches
- **Role**: Historical record of test executions
- **Review**: Optional - mainly for record keeping

### `test/results-*` Branches
- **Purpose**: Individual test run results
- **Naming**: `test/results-YYYYMMDD-HHMMSS-<run-number>`
- **Lifecycle**: Created by test workflows, can be deleted after merge
- **PRs**: Target `test` branch

## Workflow Behavior

### Evolution Workflows

All evolution workflows now:

1. **Checkout from**: `evolved` branch
2. **Create branch**: `evolved/evolution-*` with timestamp and ID
3. **Apply changes**: In the new evolution branch
4. **Create PR**: Targeting `evolved` branch
5. **Labels**: `evolution`, `automated`

#### Modified Workflows:
- `ai_evolver.yml` - Manual evolution engine
- `daily_evolution.yml` - Daily maintenance
- `periodic_evolution.yml` - Scheduled evolutions
- `testing_automation_evolver.yml` - Testing improvements

### Testing Workflows

The test workflow now:

1. **Checkout from**: `evolved` branch (or configurable via `test_branch` input)
2. **Run tests**: On the checked-out code
3. **Create branch**: `test/results-*` with timestamp and run number
4. **Commit results**: Test results and artifacts
5. **Create PR**: Targeting `test` branch
6. **Labels**: `testing`, `automated`, `results`

#### Modified Workflows:
- `comprehensive_testing.yml` - Comprehensive test automation

## Workflow Triggers

### Evolution Workflows

```yaml
# Manual trigger
workflow_dispatch:
  inputs:
    target_branch:
      default: 'evolved'

# Scheduled trigger (uses evolved)
schedule:
  - cron: '0 2 * * 1'
```

### Test Workflows

```yaml
# Push to evolved branch
push:
  branches: [ evolved, main, develop ]

# PR to evolved branch  
pull_request:
  branches: [ evolved, main, develop ]

# Manual trigger with branch selection
workflow_dispatch:
  inputs:
    test_branch:
      default: 'evolved'

# Scheduled (uses evolved)
schedule:
  - cron: '0 6 * * *'
```

## Review Process

### Evolution Review Process

1. **Automated Evolution**: Workflow runs and creates branch
2. **PR Creation**: Automatically creates PR to `evolved`
3. **Review Required**: Team reviews the evolution changes
4. **Merge**: Approved changes merge to `evolved`
5. **Testing**: Automatic or manual test runs against `evolved`
6. **Promotion**: After successful testing, merge to `main`

### Test Results Review Process

1. **Test Execution**: Workflow runs tests on `evolved` branch
2. **Results Branch**: Creates `test/results-*` branch
3. **PR Creation**: Automatically creates PR to `test`
4. **Optional Review**: Results can be reviewed if needed
5. **Merge**: Merge to `test` branch for historical record

## Migration Guide

### For New Repositories

1. Create the `evolved` branch from `main`:
   ```bash
   git checkout main
   git pull
   git checkout -b evolved
   git push -u origin evolved
   ```

2. Create the `test` branch from `main`:
   ```bash
   git checkout main
   git checkout -b test
   git push -u origin test
   ```

3. Configure branch protection rules:
   - Protect `main` - require reviews
   - Protect `evolved` - require reviews for evolution PRs
   - Optional: Protect `test` if desired

### For Existing Workflows

If you have existing evolution workflows:

1. **Update checkout refs**: Add `ref: evolved` to checkout actions
2. **Update PR creation**: Set `--base evolved` for PR targets
3. **Update scripts**: Pass branch parameters to scripts if needed

## Environment Variables

Workflows now use these environment variables:

```yaml
env:
  EVOLUTION_VERSION: "0.4.9"
  WORKFLOW_TYPE: "manual_evolution|scheduled_evolution|testing_automation"
  TARGET_BRANCH: "evolved"  # For evolution workflows
  TEST_BRANCH: "evolved"     # For test workflows
```

## Branch Protection Recommendations

### `main` Branch
- ✅ Require pull request reviews (2+ reviewers)
- ✅ Require status checks to pass
- ✅ Require conversation resolution
- ✅ Do not allow bypassing the above settings

### `evolved` Branch
- ✅ Require pull request reviews (1+ reviewer)
- ✅ Require status checks to pass
- ⚠️ Allow evolution workflows to create PRs
- ⚠️ Consider allowing force push for evolution fixes

### `test` Branch
- ⚠️ Optional protection (mainly for record keeping)
- ✅ Allow test workflows to create PRs
- ✅ Allow force push if needed for cleanup

## Troubleshooting

### Evolution PR Creation Fails

Check:
1. `evolved` branch exists
2. Workflow has `contents: write` and `pull-requests: write` permissions
3. Branch protection rules don't block the workflow
4. `GITHUB_TOKEN` has sufficient permissions

### Test Results Not Pushed

Check:
1. `test` branch exists
2. Workflow has `contents: write` permission
3. Test results directory has content
4. Git configuration is correct

### Branch Naming Conflicts

If branches with the same name exist:
1. Evolution branches use timestamps to avoid conflicts
2. Test branches use timestamps + run numbers
3. Old branches should be deleted after PR merge

## Benefits

1. **Isolation**: Evolution changes isolated from main codebase
2. **Review**: All automated changes require review before reaching main
3. **Testing**: Clear separation of test results from code
4. **History**: Test branch maintains execution history
5. **Safety**: Main branch remains stable and protected
6. **Rollback**: Easy to revert or discard evolution attempts

## Future Enhancements

Potential improvements:
- Automatic cleanup of merged evolution branches
- Enhanced metrics tracking per branch
- Integration with GitHub Projects for evolution tracking
- Automated promotion of tested changes from evolved to main
- Dashboard for branch health and evolution status
