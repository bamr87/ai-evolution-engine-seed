# Workflow Branch Updates Summary

> **⚠️ DEPRECATION NOTICE**  
> This document has been consolidated into [README.md](./README.md) as of November 9, 2025.  
> Please refer to the "Branch Strategy Details" section in README.md for the most current information.  
> This file is kept for historical reference only.

## 🎯 What Changed?

All evolution and test workflows have been updated to use dedicated branches for better isolation and review processes.

## 📊 Quick Reference

| Workflow | Checkout Branch | Target Branch | Result Branch Pattern |
|----------|----------------|---------------|----------------------|
| `ai_evolver.yml` | `evolved` | `evolved` | `evolved/evolution-*` |
| `daily_evolution.yml` | `evolved` | `evolved` | via main workflow |
| `periodic_evolution.yml` | `evolved` | `evolved` | via main workflow |
| `testing_automation_evolver.yml` | `evolved` | `evolved` | via main workflow |
| `comprehensive_testing.yml` | `evolved` | `test` | `test/results-*` |

## 🔄 Evolution Workflows

### `ai_evolver.yml` (Manual Evolution)

**Key Changes:**
- Checks out from `evolved` branch by default
- Creates evolution branch: `evolved/evolution-YYYYMMDD-HHMMSS-<id>`
- Commits changes to evolution branch
- Creates PR targeting `evolved` branch
- Includes comprehensive PR description with review checklist

**New Steps:**
1. `🎯 Initialize Evolution` - Sets up branch naming
2. `🌳 Create Evolution Branch & Commit Changes` - Creates and pushes to evolution branch
3. `📋 Create Evolution Pull Request` - Creates PR with detailed metadata

**Usage:**
```bash
# Trigger with default settings (evolved branch)
gh workflow run ai_evolver.yml

# Trigger with specific growth mode
gh workflow run ai_evolver.yml -f growth_mode=experimental -f dry_run=false
```

### `daily_evolution.yml` (Daily Maintenance)

**Key Changes:**
- Checks out from `evolved` branch
- Triggers main evolution workflow with evolved as target
- All automated evolutions go to evolved branch

**Usage:**
```bash
# Manual trigger
gh workflow run daily_evolution.yml -f evolution_type=consistency

# Scheduled: Runs daily at 3 AM UTC automatically
```

### `periodic_evolution.yml` (Scheduled Evolution)

**Key Changes:**
- Checks out from `evolved` branch
- Creates PRs targeting `evolved` branch
- Adds `periodic` and `automated` labels

**Usage:**
```bash
# Manual trigger with specific prompt
gh workflow run periodic_evolution.yml -f prompt_name=doc_harmonization -f dry_run=false

# Scheduled: Multiple scheduled times for different prompts
```

### `testing_automation_evolver.yml` (Testing Improvements)

**Key Changes:**
- Checks out from `evolved` branch
- Creates PRs targeting `evolved` branch
- Adds `testing` and `automation` labels

**Usage:**
```bash
# Trigger testing evolution
gh workflow run testing_automation_evolver.yml -f growth_mode=test-automation -f dry_run=false
```

## 🧪 Test Workflows

### `comprehensive_testing.yml`

**Key Changes:**
- Tests against `evolved` branch by default (configurable)
- Creates test results branch: `test/results-YYYYMMDD-HHMMSS-<run-number>`
- Commits test results and artifacts
- Creates PR targeting `test` branch
- Includes test summary in PR description

**New Steps:**
1. `Checkout repository` - Now checks out from `evolved` or specified branch
2. `🔬 Push Test Results to Test Branch` - Creates branch, commits results, creates PR

**Usage:**
```bash
# Test evolved branch (default)
gh workflow run comprehensive_testing.yml

# Test specific branch
gh workflow run comprehensive_testing.yml -f test_branch=main

# Test with issue creation for failures
gh workflow run comprehensive_testing.yml -f create_issues=true

# Scheduled: Runs daily at 6 AM UTC automatically
```

## 🌿 Branch Structure Flow

```
┌─────────────────────────────────────────────────────────────┐
│                         main branch                          │
│                    (stable production)                       │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           │ merge after review
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                       evolved branch                         │
│              (target for all evolution PRs)                  │
└──┬───────────────────┬──────────────────┬──────────────────┘
   │                   │                  │
   │ PR                │ PR               │ PR
   ↓                   ↓                  ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ evolved/     │  │ evolved/     │  │ evolved/     │
│ evolution-1  │  │ evolution-2  │  │ evolution-3  │
│              │  │              │  │              │
│ (manual)     │  │ (daily)      │  │ (periodic)   │
└──────────────┘  └──────────────┘  └──────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    evolved branch (source)                   │
│                  (tested by test workflows)                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           │ test results
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                       test branch                            │
│               (consolidated test results)                    │
└──┬───────────────────┬──────────────────┬──────────────────┘
   │                   │                  │
   │ PR                │ PR               │ PR
   ↓                   ↓                  ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ test/        │  │ test/        │  │ test/        │
│ results-1    │  │ results-2    │  │ results-3    │
│              │  │              │  │              │
│ (run #123)   │  │ (run #124)   │  │ (run #125)   │
└──────────────┘  └──────────────┘  └──────────────┘
```

## 🚀 Getting Started

### 1. Create Required Branches

```bash
# Create evolved branch
git checkout main
git pull
git checkout -b evolved
git push -u origin evolved

# Create test branch
git checkout main
git checkout -b test  
git push -u origin test
```

### 2. Set Up Branch Protection

**For `main`:**
- Require 2+ pull request reviews
- Require status checks to pass
- Require conversation resolution

**For `evolved`:**
- Require 1+ pull request review
- Require status checks to pass

**For `test`:**
- Optional protection (mainly for records)

### 3. Test the New Workflow

```bash
# Dry run an evolution
gh workflow run ai_evolver.yml -f dry_run=true -f growth_mode=conservative

# Run actual evolution
gh workflow run ai_evolver.yml -f dry_run=false -f growth_mode=conservative

# Run tests
gh workflow run comprehensive_testing.yml
```

## 📝 Best Practices

### For Evolution Reviews

1. **Check the PR** created in the `evolved` branch
2. **Review changes** carefully - these are AI-generated
3. **Run local tests** if needed
4. **Merge to evolved** after approval
5. **Trigger tests** against evolved branch
6. **Merge to main** after successful testing

### For Test Results

1. **Review failures** in the test results branch
2. **Check artifacts** in the workflow run
3. **Create issues** for persistent failures
4. **Merge to test** for historical record
5. **Fix issues** in evolved branch

### For Maintenance

1. **Delete merged branches** regularly
2. **Monitor PR backlog** in evolved branch
3. **Review test trends** in test branch
4. **Update protection rules** as needed

## 🔧 Configuration Options

### Evolution Workflows

```yaml
# In workflow_dispatch inputs
target_branch: 'evolved'      # Base branch (now default to evolved)
dry_run: false               # Simulate without changes
growth_mode: 'adaptive'      # Evolution strategy
auto_merge: false            # Auto-merge if confident
```

### Test Workflows

```yaml
# In workflow_dispatch inputs
test_branch: 'evolved'       # Branch to test
create_issues: false         # Create issues for failures
generate_reports: true       # Generate human-readable reports
```

## 🆘 Troubleshooting

### Issue: Evolution PR not created

**Check:**
- Does `evolved` branch exist?
- Do workflows have `pull-requests: write` permission?
- Are branch protection rules blocking automation?

**Fix:**
```bash
# Create evolved branch if missing
git checkout -b evolved main
git push -u origin evolved

# Check workflow permissions in workflow file
# Ensure: pull-requests: write
```

### Issue: Test results not pushed

**Check:**
- Does `test` branch exist?
- Are there actual test results to commit?
- Do workflows have `contents: write` permission?

**Fix:**
```bash
# Create test branch if missing
git checkout -b test main
git push -u origin test

# Check workflow permissions
```

### Issue: Branch naming conflicts

**Solution:**
- Evolution branches use timestamps + unique IDs
- Test branches use timestamps + run numbers
- Conflicts should be extremely rare
- Delete old branches after merging

## 📚 Additional Documentation

- See `.github/BRANCH_STRATEGY.md` for complete branch strategy details
- See `.github/workflows/README.md` for workflow documentation
- See individual workflow files for specific configuration options

## 🔄 Rollback Procedure

If you need to revert to the old behavior:

1. **Update checkout refs** in workflows to remove `ref: evolved`
2. **Update PR creation** to target `main` instead of `evolved`
3. **Remove test branch push** steps from test workflows
4. **Revert to previous workflow versions** if needed

Note: This is not recommended as the new branch strategy provides better isolation and review processes.
