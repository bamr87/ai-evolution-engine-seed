# GitHub Actions Testing & Debugging Guide for AI-Assisted Development

## Overview

This guide provides the best practices for testing and debugging GitHub Actions workflows with AI assistance, specifically designed for the AI Evolution Engine.

## Quick Start

### 1. Setup Testing Environment

```bash
# One-time setup
./tests/workflows/test-workflow.sh setup

# Edit your secrets file (required for local testing)
nano .secrets
```

### 2. Local Testing Workflow

```bash
# Test locally before pushing
./tests/workflows/test-workflow.sh local --prompt "Your test prompt"

# Debug mode with verbose output
./tests/workflows/test-workflow.sh debug --prompt "Your test prompt"

# Dry run simulation
./tests/workflows/test-workflow.sh dry-run --prompt "Your test prompt"
```

### 3. Generate Debug Report for AI
```bash
# Generate comprehensive debug info
./scripts/ai-debug-helper.sh generate

# The report will be in: ./debug-output/ai-debug-report-[timestamp].md
```

### 4. Monitor Logs in Real-Time
```bash
# Monitor local logs
./scripts/monitor-logs.sh local

# Monitor GitHub Actions
./scripts/monitor-logs.sh github

# Monitor both simultaneously
./scripts/monitor-logs.sh both

# Filter for specific issues
./scripts/monitor-logs.sh both --filter "error"
```

## Best Practices for AI-Assisted Debugging

### 1. **Systematic Approach**
- Always start with local testing using `act`
- Generate debug reports before asking for AI help
- Provide complete context (logs, environment, code)
- Test fixes locally before deploying

### 2. **Effective AI Interaction**
When working with AI assistants:

```bash
# Generate a comprehensive debug report
./scripts/ai-debug-helper.sh generate

# Share the generated report with AI and ask:
```

**Example AI Prompt:**
> "I'm having issues with my GitHub Actions workflow. Here's my debug report:
> 
> [Paste content of debug report]
> 
> Please:
> 1. Analyze the error patterns
> 2. Identify the root cause
> 3. Provide specific fixes
> 4. Suggest a testing plan
> 5. Help me understand what went wrong"

### 3. **Common Testing Scenarios**

#### Test New Features
```bash
# Test a new feature locally
./tests/workflows/test-workflow.sh local --prompt "Add user authentication system"

# Monitor the output
./scripts/monitor-logs.sh local --filter "auth"
```

#### Debug Failed Runs
```bash
# Fetch recent GitHub logs
./tests/workflows/test-workflow.sh logs

# Generate debug report
./scripts/ai-debug-helper.sh generate

# Share with AI for analysis
```

#### Validate Workflow Changes
```bash
# Validate syntax
./tests/workflows/test-workflow.sh validate

# Test with different modes
./tests/workflows/test-workflow.sh local --mode conservative
./tests/workflows/test-workflow.sh local --mode experimental
```

## Tools and Scripts Reference

### Main Testing Script: `test-workflow.sh`
```bash
# Commands
./tests/workflows/test-workflow.sh setup      # Initial setup
./tests/workflows/test-workflow.sh local      # Run locally
./tests/workflows/test-workflow.sh debug      # Debug mode
./tests/workflows/test-workflow.sh validate   # Check syntax
./tests/workflows/test-workflow.sh logs       # Fetch GitHub logs
./tests/workflows/test-workflow.sh dry-run    # Simulate only

# Options
--prompt "Your prompt"                # Test prompt
--mode conservative|adaptive|experimental
--job specific-job-name              # Run specific job
--secrets /path/to/secrets           # Custom secrets file
```

### Debug Helper: `ai-debug-helper.sh`
```bash
# Generate comprehensive debug report
./scripts/ai-debug-helper.sh generate

# Output location
./debug-output/ai-debug-report-[timestamp].md
```

### Log Monitor: `monitor-logs.sh`
```bash
# Monitor types
./scripts/monitor-logs.sh local       # Local logs only
./scripts/monitor-logs.sh github      # GitHub Actions only
./scripts/monitor-logs.sh both        # Both sources

# Options
--filter "error"                     # Filter content
--interval 10                        # Refresh interval
--lines 100                          # Lines to show
--file path/to/log                   # Specific file
```

## Troubleshooting Common Issues

### 1. **Local Testing Issues**

**Problem**: `act` command fails
```bash
# Check Docker is running
docker info

# Check workflow syntax
act --list

# Use debug mode
./tests/workflows/test-workflow.sh debug
```

**Problem**: Permission denied
```bash
# Fix script permissions
find ./scripts -name "*.sh" -exec chmod +x {} \;

# Check Docker permissions
docker run hello-world
```

### 2. **GitHub Actions Issues**

**Problem**: Authentication failures
```bash
# Check GitHub CLI auth
gh auth status

# Re-authenticate if needed
gh auth login
```

**Problem**: Workflow not triggering
```bash
# Check workflow file location
ls -la .github/workflows/

# Validate workflow syntax
act --list
```

### 3. **AI Debugging Workflow**

**Step 1**: Reproduce the issue locally
```bash
./tests/workflows/test-workflow.sh local --prompt "Reproduce issue"
```

**Step 2**: Generate debug report
```bash
./scripts/ai-debug-helper.sh generate
```

**Step 3**: Share with AI
- Upload the debug report to your AI assistant
- Ask for specific analysis and solutions
- Request step-by-step fixes

**Step 4**: Test fixes
```bash
# Test AI-suggested fixes locally
./tests/workflows/test-workflow.sh local --prompt "Test fix"

# Monitor results
./scripts/monitor-logs.sh local
```

**Step 5**: Deploy and verify
```bash
# Push changes and monitor
git push origin main

# Monitor GitHub Actions
./scripts/monitor-logs.sh github
```

## Advanced Usage

### Custom Testing Scenarios
```bash
# Test specific job only
./tests/workflows/test-workflow.sh local --job evolve --prompt "Test specific job"

# Test with custom secrets
./tests/workflows/test-workflow.sh local --secrets ./custom-secrets --prompt "Test with custom auth"

# Long-running test monitoring
./scripts/monitor-logs.sh both --interval 30 --filter "evolution"
```

### Integration with CI/CD
```bash
# Add to your development workflow
alias test-action='./tests/workflows/test-workflow.sh local'
alias debug-action='./scripts/ai-debug-helper.sh generate'
alias monitor-action='./scripts/monitor-logs.sh both'
```

## Security Considerations

1. **Never commit secrets**: The `.secrets` file is gitignored
2. **Use environment variables**: For sensitive data in workflows
3. **Test permissions**: Ensure minimal required permissions
4. **Review AI suggestions**: Always review AI-generated code before applying

## Files Created by This Setup

```
scripts/
├── test-workflow.sh      # Main testing script
├── ai-debug-helper.sh    # Debug report generator  
├── monitor-logs.sh       # Real-time log monitoring
└── setup-environment.sh  # Environment setup

debug-output/             # Generated debug reports
├── ai-debug-report-*.md  # Comprehensive debug info
└── debug-summary-*.txt   # Quick status summary

logs/                     # Local test logs
├── local-run-*.log       # Local execution logs
└── github-logs-*.log     # Downloaded GitHub logs

.secrets                  # Local secrets (gitignored)
```

## Tips for Effective AI Collaboration

1. **Be Specific**: Include exact error messages and context
2. **Provide Context**: Share the debug report, not just error snippets
3. **Ask for Examples**: Request specific code changes or commands
4. **Iterate**: Test AI suggestions locally before implementing
5. **Document**: Keep track of successful solutions for future reference

## Example AI Interaction Flow

```bash
# 1. Issue occurs
./tests/workflows/test-workflow.sh local --prompt "Feature X"
# -> Error occurs

# 2. Generate debug report
./scripts/ai-debug-helper.sh generate
# -> Creates comprehensive report

# 3. Share with AI
# "Here's my debug report: [paste content]
#  The workflow fails at step Y with error Z.
#  Please help me fix this."

# 4. AI provides solution
# -> Follow AI's step-by-step instructions

# 5. Test fix
./tests/workflows/test-workflow.sh local --prompt "Test fix"
# -> Verify solution works

# 6. Deploy
git commit -m "Fix: Apply AI-suggested solution for issue X"
git push origin main
```

This approach ensures you have comprehensive debugging information and can effectively collaborate with AI assistants to resolve GitHub Actions issues quickly and systematically.
