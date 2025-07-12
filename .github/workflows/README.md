# 🌱 AI Evolution Engine - Workflows

This directory contains the GitHub Actions workflows for the AI Evolution Engine.

## 📋 Current Workflows

### 🌱 `evolve.yml` - Main Evolution Workflow
**Purpose**: Primary evolution workflow for AI-driven repository improvements

**Triggers**:
- Manual dispatch with customizable parameters
- Scheduled runs (daily at 3 AM UTC, weekly on Mondays at 2 AM UTC)

**Features**:
- Context collection and analysis
- AI evolution simulation
- Change application and validation
- Pull request creation
- Comprehensive reporting

**Usage**:
```bash
# Manual trigger via GitHub CLI
gh workflow run evolve.yml -f evolution_type=consistency -f intensity=minimal

# Or via GitHub web interface
```

### 🧪 `test.yml` - Testing Workflow
**Purpose**: Comprehensive testing and validation

**Triggers**:
- Manual dispatch
- Push to main branch
- Pull requests

**Features**:
- Multiple test types (all, scripts, workflows, integration, validation)
- Multiple output formats (text, JSON, HTML)
- Automated PR comments with test results
- Artifact upload for test reports

**Usage**:
```bash
# Manual trigger via GitHub CLI
gh workflow run test.yml -f test_type=all -f output_format=json

# Or via GitHub web interface
```

## 🔄 Workflow Simplification

### Before (Complex)
- `ai_evolver.yml` - Manual evolution (478 lines)
- `daily_evolution.yml` - Daily maintenance (166 lines)
- `periodic_evolution.yml` - Periodic prompts (347 lines)
- `testing_automation_evolver.yml` - Testing automation (133 lines)

### After (Simplified)
- `evolve.yml` - Main evolution workflow (consolidated functionality)
- `test.yml` - Testing workflow (comprehensive testing)

**Benefits**:
- **Reduced complexity**: 4 workflows → 2 workflows
- **Clearer purpose**: Each workflow has a single, well-defined purpose
- **Easier maintenance**: Fewer files to maintain and update
- **Better integration**: Uses the new consolidated scripts

## 📊 Workflow Comparison

| Feature | Old Workflows | New Workflows |
|---------|---------------|---------------|
| **Count** | 4 workflows | 2 workflows |
| **Total Lines** | 1,124 lines | ~400 lines |
| **Complexity** | High (multiple overlapping features) | Low (clear separation) |
| **Maintenance** | Difficult (multiple files) | Easy (fewer files) |
| **Integration** | Complex (multiple scripts) | Simple (consolidated scripts) |

## 🎯 Key Improvements

### ✅ Simplified Architecture
- **Single evolution workflow**: Handles all evolution types and modes
- **Unified testing**: Comprehensive test suite with multiple formats
- **Clear separation**: Evolution vs testing responsibilities

### ✅ Enhanced Usability
- **Intuitive parameters**: Clear, descriptive input options
- **Flexible scheduling**: Both manual and automated triggers
- **Comprehensive reporting**: Detailed logs and artifacts

### ✅ Better Integration
- **Uses consolidated scripts**: Leverages the new `evolve.sh`, `setup.sh`, `test.sh`
- **Consistent patterns**: Same setup and validation across workflows
- **Error handling**: Robust fallbacks and validation

## 📁 Archive

Old workflows have been moved to `.github/workflows/archive/`:
- `ai_evolver.yml` - Original manual evolution workflow
- `daily_evolution.yml` - Original daily maintenance workflow
- `periodic_evolution.yml` - Original periodic prompts workflow
- `testing_automation_evolver.yml` - Original testing automation workflow

These are preserved for reference but are no longer active.

## 🚀 Usage Examples

### Manual Evolution
```bash
# Basic consistency evolution
gh workflow run evolve.yml

# Custom evolution with specific prompt
gh workflow run evolve.yml -f evolution_type=custom -f prompt="Add user authentication"

# Conservative evolution with dry run
gh workflow run evolve.yml -f growth_mode=conservative -f dry_run=true
```

### Testing
```bash
# Run all tests
gh workflow run test.yml

# Test specific components
gh workflow run test.yml -f test_type=scripts

# Generate JSON report
gh workflow run test.yml -f output_format=json -f verbose=true
```

### Scheduled Runs
The workflows automatically run on schedule:
- **Daily**: `evolve.yml` runs at 3 AM UTC for maintenance
- **Weekly**: `evolve.yml` runs on Mondays at 2 AM UTC for consistency checks
- **On Push/PR**: `test.yml` runs automatically on code changes

## 🔧 Configuration

### Environment Variables
- `EVOLUTION_VERSION`: Current version (3.0.0)
- `WORKFLOW_TYPE`: Workflow type for logging
- `CI_ENVIRONMENT`: Set to true for CI/CD detection

### Permissions
- `contents: write` - For file modifications
- `pull-requests: write` - For PR creation
- `issues: write` - For issue management

### Secrets
- `GITHUB_TOKEN` - For repository access and PR creation

## 📈 Monitoring

### Workflow Status
Monitor workflow execution in the GitHub Actions tab:
- Green: All steps completed successfully
- Yellow: Some steps completed with warnings
- Red: Steps failed

### Artifacts
Both workflows generate artifacts:
- **Evolution artifacts**: Context files, response files, reports
- **Test artifacts**: Test results, logs, reports

### Logs
Detailed logs are available for each step:
- Setup and environment preparation
- Context collection and analysis
- AI simulation and change application
- Validation and testing results

---

**Note**: These workflows are designed to work with the consolidated scripts (`evolve.sh`, `setup.sh`, `test.sh`) and represent a significant simplification of the previous complex workflow structure.
