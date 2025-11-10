# 🌱 Daily Evolution & Automated Maintenance Guide

## Overview

The AI Evolution Engine now includes automated daily evolution cycles designed to maintain repository health through consistent, incremental improvements. This system runs automatically every day and can also be triggered on-demand via command line.

## Daily Automation Features

### 🤖 Automated Daily Cycles

- **Schedule**: Runs daily at 3 AM UTC (configurable)
- **Health Check**: Analyzes repository for improvement opportunities
- **Smart Triggering**: Only runs when issues are detected or improvements are needed
- **Conservative Approach**: Focuses on safe, minimal changes by default

### 🔍 Health Check Categories

The daily evolution system automatically detects:

1. **Formatting Inconsistencies**
   - Tab/space mixing in files
   - Inconsistent line endings
   - Irregular markdown formatting

2. **Code Quality Issues**
   - TODO/FIXME comments that can be addressed
   - Unused variables or functions
   - Code style inconsistencies

3. **Documentation Drift**
   - Outdated examples or instructions
   - Missing documentation for recent changes
   - Broken internal links

4. **Security Concerns**
   - Insecure HTTP links
   - Outdated dependencies
   - File permission issues

5. **Evolution Staleness**
   - Repository hasn't evolved in >7 days
   - Metrics indicate improvement opportunities

## Command Line Interface

### Quick Start

```bash
# Run default consistency check
./scripts/evolve.sh

# Documentation improvements with moderate intensity
./scripts/evolve.sh --type documentation --intensity moderate

# Custom evolution with specific prompt
./scripts/evolve.sh --type custom --prompt "Add comprehensive error handling"
```

### Evolution Types

| Type | Description | Focus Areas |
|------|-------------|-------------|
| `consistency` | Fix formatting and structural inconsistencies | Formatting, naming, structure |
| `error_fixing` | Address bugs and robustness issues | Validation, error handling, edge cases |
| `documentation` | Update and improve documentation | Accuracy, completeness, examples |
| `code_quality` | Enhance maintainability and readability | Refactoring, optimization, clarity |
| `security_updates` | Apply security improvements | Dependencies, permissions, validation |
| `custom` | Use a custom prompt | User-defined focus |

### Intensity Levels

| Level | Scope | Risk | Description |
|-------|-------|------|-------------|
| `minimal` | Small changes | Low | Safe improvements preserving functionality |
| `moderate` | Medium changes | Medium | Moderate improvements including minor refactoring |
| `comprehensive` | Large changes | Higher | Significant enhancements and modernization |

### Growth Modes

| Mode | Approach | Use Case |
|------|----------|----------|
| `conservative` | Very safe changes only | Production repositories |
| `adaptive` | Balanced improvements | Most repositories |
| `experimental` | Allow breaking changes | Development/testing |

## Configuration

### Global Settings (.evolution.yml)

```yaml
# Daily automation
daily_evolution:
  enabled: true
  schedule: "0 3 * * *"  # 3 AM UTC
  default_type: "consistency"
  default_intensity: "minimal"
  skip_if_recent_changes: false
  max_issues_threshold: 10

# Evolution type configurations
evolution:
  types:
    consistency:
      safe_mode: true
      focus_areas: ["formatting", "naming", "structure"]
    # ... other types
```

### Customizing Daily Runs

1. **Change Schedule**: Modify the `schedule` field in `.evolution.yml`
2. **Default Behavior**: Adjust `default_type` and `default_intensity`
3. **Threshold Settings**: Configure `max_issues_threshold` for sensitivity

## Usage Examples

### 1. Daily Maintenance

```bash
# Standard daily maintenance (runs automatically)
./scripts/evolve.sh --type consistency --intensity minimal

# Force run even if no issues detected
./scripts/evolve.sh --type consistency --force-run
```

### 2. Documentation Updates

```bash
# Minimal documentation updates
./scripts/evolve.sh --type documentation --intensity minimal

# Comprehensive documentation overhaul
./scripts/evolve.sh --type documentation --intensity comprehensive --mode adaptive
```

### 3. Code Quality Improvements

```bash
# Safe code quality improvements
./scripts/evolve.sh --type code_quality --intensity moderate

# Comprehensive refactoring (use with caution)
./scripts/evolve.sh --type code_quality --intensity comprehensive --mode experimental
```

### 4. Security Updates

```bash
# Apply security fixes
./scripts/evolve.sh --type security_updates --intensity moderate

# Comprehensive security audit and fixes
./scripts/evolve.sh --type security_updates --intensity comprehensive
```

### 5. Custom Evolutions

```bash
# Add specific functionality
./scripts/evolve.sh --type custom --prompt "Add unit tests for all utility functions"

# Performance optimization
./scripts/evolve.sh --type custom --prompt "Optimize shell scripts for better performance" --intensity moderate
```

## Monitoring & Metrics

### Daily Evolution Metrics

The system tracks daily evolution statistics in `.evolution_daily.json`:

```json
{
  "daily_evolution_version": "1.0",
  "total_daily_cycles": 15,
  "last_daily_evolution": "2025-07-04T03:00:00Z",
  "evolution_types": {
    "consistency": 8,
    "error_fixing": 3,
    "documentation": 2,
    "code_quality": 1,
    "security_updates": 1
  },
  "daily_history": [...]
}
```

### Viewing Evolution Status

```bash
# Check if daily evolution is enabled
gh workflow list | grep "Daily Evolution"

# View recent daily evolution runs
gh run list --workflow=daily_evolution.yml --limit=10

# Watch current evolution in progress
gh run watch
```

## Safety & Best Practices

### Built-in Safety Features

1. **Conservative Defaults**: Daily runs use minimal intensity by default
2. **Health Checks**: Only runs when improvements are actually needed
3. **Branch Isolation**: All changes are made in separate branches
4. **Pull Request Review**: Changes require review before merging
5. **Rollback Capability**: Failed evolutions can be easily reverted

### Recommended Workflow

1. **Start Small**: Begin with `consistency` type and `minimal` intensity
2. **Monitor Results**: Review pull requests from daily evolution cycles
3. **Gradual Increase**: Gradually increase intensity as you gain confidence
4. **Custom Needs**: Use on-demand runs for specific improvement areas

### Quality Gates

The system includes built-in quality gates:

- **Test Requirements**: All evolutions must pass existing tests
- **Lint Validation**: Code must pass linting requirements
- **Time Limits**: Evolution cycles have maximum execution time
- **Automatic Rollback**: Failed evolutions are automatically reverted

## Troubleshooting

### Common Issues

1. **Evolution Not Triggering**

   ```bash
   # Check if daily evolution is enabled
   cat .evolution.yml | grep -A5 daily_evolution
   
   # Force run to test
   ./scripts/evolve.sh --force-run
   ```

2. **GitHub CLI Not Authenticated**

   ```bash
   gh auth status
   gh auth login
   ```

3. **Permission Issues**

   ```bash
   # Ensure script is executable
   chmod +x ./scripts/evolve.sh
   
   # Check repository permissions
   gh repo view
   ```

### Debug Mode

```bash
# Run with verbose output
./scripts/evolve.sh --verbose --type consistency

# Dry run to see what would happen
./scripts/evolve.sh --dry-run --type documentation --intensity moderate
```

## Integration with Existing Workflows

### CI/CD Integration

The daily evolution system integrates seamlessly with existing workflows:

- **Respects Branch Protection**: Works within branch protection rules
- **Status Checks**: Honors required status checks before merging
- **Review Requirements**: Follows code review requirements

### Customization for Teams

1. **Review Assignment**: Configure CODEOWNERS for automatic review assignment
2. **Notification Settings**: Set up notifications for evolution PR creation
3. **Branch Naming**: Customize branch naming patterns in workflows
4. **Schedule Adjustment**: Modify timing based on team time zones

## Future Enhancements

The daily evolution system is designed to grow and improve:

- **AI Model Integration**: Future versions will integrate with real AI models
- **Smarter Detection**: Enhanced algorithms for detecting improvement opportunities
- **Team Collaboration**: Features for team-based evolution coordination
- **Performance Metrics**: Detailed analytics on evolution effectiveness
- **Custom Rules**: User-defined rules for evolution triggering

---

*This automated evolution system embodies the core principles of the AI Evolution Engine: sustainable growth, minimal intervention, and continuous improvement. By automating routine maintenance, it frees developers to focus on higher-value creative work while ensuring repositories stay healthy and current.*
