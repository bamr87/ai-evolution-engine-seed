# Quick Reference: Manual Workflow Execution

## 🚀 Quick Start Commands

### Check if you're ready
```bash
gh auth status
cd /path/to/ai-evolution-engine-seed
```

### Most Common Commands

#### 1. Run AI Evolution (Safe Test)
```bash
gh workflow run ai_evolver.yml \
  -f prompt="Your evolution request here" \
  -f growth_mode="conservative" \
  -f dry_run="true"
```

#### 2. Monitor Recent Workflows
```bash
gh run list --limit=5
```

#### 3. Watch a Running Workflow
```bash
# Get the run ID from the list above, then:
gh run watch <run-id>
```

#### 4. View Logs for Failed Run
```bash
gh run view <run-id> --log
```

## 🛠️ Using the Helper Script

```bash
# Make executable (first time only)
chmod +x scripts/run-workflow.sh

# Show available workflows
./scripts/run-workflow.sh list

# Monitor current runs
./scripts/run-workflow.sh monitor

# Run AI evolution with prompt
./scripts/run-workflow.sh ai "Add better error handling"

# Run daily maintenance
./scripts/run-workflow.sh daily consistency minimal

# Run testing improvements
./scripts/run-workflow.sh testing test-automation
```

## 📋 Workflow Parameters Quick Reference

### AI Evolution (`ai_evolver.yml`)
- **prompt**: Your evolution instructions (required)
- **growth_mode**: conservative | adaptive | experimental
- **dry_run**: true | false (use true for testing)

### Daily Evolution (`daily_evolution.yml`)
- **evolution_type**: consistency | error_fixing | documentation | code_quality | security_updates
- **intensity**: minimal | moderate | comprehensive
- **force_run**: true | false

### Testing Automation (`testing_automation_evolver.yml`)
- **growth_mode**: test-automation | build-optimization | error-resilience | ci-cd-enhancement
- **cycle**: Evolution cycle number
- **generation**: Evolution generation number

## 🔍 Monitoring Commands

```bash
# List all recent runs
gh run list

# List runs for specific workflow
gh run list --workflow="ai_evolver.yml"

# List only failed runs
gh run list --status=failure

# View run details
gh run view <run-id>

# View logs
gh run view <run-id> --log

# Watch live
gh run watch <run-id>

# Download logs
gh run download <run-id>
```

## 🚨 Emergency Commands

```bash
# Check auth status
gh auth status

# Re-authenticate
gh auth login

# List available workflows
gh workflow list

# Cancel running workflow
gh run cancel <run-id>

# Re-run failed workflow
gh run rerun <run-id>
```

## 💡 Pro Tips

1. **Always test with dry_run=true first**
2. **Use conservative growth_mode for important changes**
3. **Monitor logs in real-time with `gh run watch`**
4. **Keep evolution prompts specific and actionable**
5. **Use the helper script for common operations**

## 📞 Getting Help

```bash
# Script help
./scripts/run-workflow.sh help

# GitHub CLI help
gh workflow run --help
gh run --help
```
