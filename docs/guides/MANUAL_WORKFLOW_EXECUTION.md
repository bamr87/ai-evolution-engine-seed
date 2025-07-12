# Manual Workflow Execution Guide

This guide explains how to manually invoke GitHub Actions workflows from the terminal and monitor their execution.

## Prerequisites

1. **GitHub CLI Installation**

   ```bash
   # macOS
   brew install gh
   
   # Or download from: https://cli.github.com/
   ```

2. **Authentication**

   ```bash
   gh auth login
   ```

3. **Repository Access**
   Ensure you have write access to the repository and appropriate permissions.

## Quick Start

### 🚀 Using the Helper Script

We've provided a convenient script to manage all workflow operations:

```bash
# Make the script executable
chmod +x scripts/run-workflow.sh

# Show available workflows
./scripts/run-workflow.sh list

# Monitor recent runs
./scripts/run-workflow.sh monitor
```

### 📋 Direct GitHub CLI Commands

## Available Workflows

### 1. 🌱 AI Evolution Engine (`ai_evolver.yml`)

**Purpose**: Manual AI-driven evolution with custom prompts

**Parameters**:

- `prompt` (required): Growth instructions for the AI
- `growth_mode`: conservative | adaptive | experimental (default: adaptive)
- `auto_plant_seeds`: true | false (default: true)
- `dry_run`: true | false (default: false)
- `use_container`: true | false (default: true)

**Examples**:

```bash
# Using helper script
./scripts/run-workflow.sh ai "Implement user authentication system" experimental false

# Direct GitHub CLI
gh workflow run ai_evolver.yml \
  -f prompt="Add logging and monitoring" \
  -f growth_mode="adaptive" \
  -f dry_run="true"

# Simple evolution with defaults
gh workflow run ai_evolver.yml -f prompt="Fix code formatting issues"
```

### 2. 🌿 Daily Evolution (`daily_evolution.yml`)

**Purpose**: Automated maintenance and repository health checks

**Parameters**:

- `evolution_type`: consistency | error_fixing | documentation | code_quality | security_updates
- `intensity`: minimal | moderate | comprehensive (default: minimal)
- `force_run`: true | false (default: false)
- `dry_run`: true | false (default: false)

**Examples**:

```bash
# Using helper script
./scripts/run-workflow.sh daily error_fixing moderate true false

# Direct GitHub CLI
gh workflow run daily_evolution.yml \
  -f evolution_type="consistency" \
  -f intensity="moderate" \
  -f force_run="true"

# Quick consistency check
gh workflow run daily_evolution.yml -f evolution_type="consistency"
```

### 3. 🧪 Testing Automation (`testing_automation_evolver.yml`)

**Purpose**: Testing and CI/CD improvements

**Parameters**:

- `growth_mode`: test-automation | build-optimization | error-resilience | ci-cd-enhancement
- `cycle`: Evolution cycle number (default: 3)
- `generation`: Evolution generation number (default: 1)
- `dry_run`: true | false (default: false)

**Examples**:

```bash
# Using helper script
./scripts/run-workflow.sh testing test-automation 4 2 true

# Direct GitHub CLI
gh workflow run testing_automation_evolver.yml \
  -f growth_mode="build-optimization" \
  -f cycle="5" \
  -f generation="3"

# Focus on error resilience
gh workflow run testing_automation_evolver.yml -f growth_mode="error-resilience"
```

## Monitoring Workflow Execution

### 📊 List Recent Runs

```bash
# Show recent workflow runs
gh run list

# Show runs for specific workflow
gh run list --workflow="ai_evolver.yml"

# Show only failed runs
gh run list --status=failure

# Limit results
gh run list --limit=5
```

### 🔍 View Workflow Details

```bash
# Get run ID from list, then view details
gh run view <run-id>

# View with web browser
gh run view <run-id> --web
```

### 📋 View Logs

```bash
# View logs for a specific run
gh run view <run-id> --log

# View logs for specific job
gh run view <run-id> --job="evolve"

# Download logs
gh run download <run-id>
```

### ⏱️ Watch Running Workflows

```bash
# Watch a running workflow (real-time updates)
gh run watch <run-id>

# Watch latest run of specific workflow
gh run watch --workflow="ai_evolver.yml"
```

## Practical Examples

### 🔧 Development Workflow

```bash
# 1. Start with a safe test run
gh workflow run ai_evolver.yml \
  -f prompt="Improve error handling in main functions" \
  -f growth_mode="conservative" \
  -f dry_run="true"

# 2. Monitor the test run
gh run list --limit=1
export RUN_ID=$(gh run list --limit=1 --json databaseId --jq '.[0].databaseId')
gh run watch $RUN_ID

# 3. If test looks good, run for real
gh workflow run ai_evolver.yml \
  -f prompt="Improve error handling in main functions" \
  -f growth_mode="conservative" \
  -f dry_run="false"
```

### 🚨 Debugging Failed Workflows

```bash
# 1. Find failed runs
gh run list --status=failure --limit=5

# 2. View failure details
gh run view <failed-run-id>

# 3. Download logs for analysis
gh run download <failed-run-id>

# 4. Re-run with dry mode to test fix
gh run rerun <failed-run-id>
```

### 🔄 Continuous Monitoring

```bash
# Monitor all workflows continuously
watch -n 30 'gh run list --limit=5'

# Monitor specific workflow
watch -n 15 'gh run list --workflow="daily_evolution.yml" --limit=3'
```

## Advanced Techniques

### 🎯 Targeted Evolution

```bash
# Focus on specific areas
gh workflow run ai_evolver.yml \
  -f prompt="Optimize database queries and add caching" \
  -f growth_mode="experimental"

# Documentation improvements
gh workflow run daily_evolution.yml \
  -f evolution_type="documentation" \
  -f intensity="comprehensive"

# Security hardening
gh workflow run daily_evolution.yml \
  -f evolution_type="security_updates" \
  -f intensity="moderate"
```

### 🔬 Testing New Features

```bash
# Test automation improvements
gh workflow run testing_automation_evolver.yml \
  -f growth_mode="test-automation" \
  -f dry_run="true"

# Build process optimization
gh workflow run testing_automation_evolver.yml \
  -f growth_mode="build-optimization" \
  -f cycle="6"
```

## Troubleshooting

### Common Issues

1. **Authentication Problems**

   ```bash
   gh auth refresh
   gh auth status
   ```

2. **Permission Errors**
   - Ensure you have write access to the repository
   - Check if branch protection rules allow workflow runs

3. **Workflow Not Found**

   ```bash
   # List available workflows
   gh workflow list
   ```

4. **Parameters Not Accepted**
   - Check workflow file for exact parameter names
   - Ensure parameter types match (string, boolean, choice)

### Debug Commands

```bash
# Verbose output
gh run view <run-id> --log --verbose

# Check workflow syntax
gh workflow view ai_evolver.yml

# List all runs with status
gh run list --json status,conclusion,name,createdAt --jq '.[] | {status, conclusion, name, createdAt}'
```

## Best Practices

### 🛡️ Safety First

1. **Always test with dry_run=true first**
2. **Use conservative growth_mode for critical changes**
3. **Monitor logs during execution**
4. **Keep evolution prompts specific and clear**

### 📈 Optimization

1. **Use appropriate intensity levels**
2. **Track cycle and generation numbers for testing workflows**
3. **Force runs only when necessary (daily evolution)**
4. **Use containerized execution for consistent results**

### 📊 Monitoring

1. **Set up notifications for workflow failures**
2. **Regularly review evolution metrics**
3. **Download logs for important runs**
4. **Use watch mode for critical workflows**

## Integration with Development Workflow

### 🔄 Daily Development Routine

```bash
# Morning: Check repository health
./scripts/run-workflow.sh daily consistency minimal false true

# Development: Implement features with AI assistance
./scripts/run-workflow.sh ai "Add user profile management" adaptive true

# Afternoon: Optimize tests and builds
./scripts/run-workflow.sh testing test-automation

# Evening: Review and apply changes
./scripts/run-workflow.sh monitor
```

This guide ensures you can effectively manage and monitor the AI Evolution Engine workflows from the terminal, following the IT-Journey principles of simplicity, reliability, and continuous improvement.
