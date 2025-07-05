#!/bin/bash
# scripts/ai-debug-helper.sh
# Prepares comprehensive debugging information for AI analysis
# Collects logs, context, and environment details for AI troubleshooting

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"

# Configuration
OUTPUT_DIR="./debug-output"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEBUG_FILE="$OUTPUT_DIR/ai-debug-report-$TIMESTAMP.md"

# Create debug output directory
mkdir -p "$OUTPUT_DIR"

# Function to collect system information
collect_system_info() {
    cat << EOF
## System Information

- **Operating System**: $(uname -s) $(uname -r)
- **Architecture**: $(uname -m)
- **Shell**: $SHELL
- **Current User**: $(whoami)
- **Working Directory**: $(pwd)
- **Date/Time**: $(date)

### Tool Versions
- **Git**: $(git --version 2>/dev/null || echo "Not installed")
- **Docker**: $(docker --version 2>/dev/null || echo "Not installed")
- **Act**: $(act --version 2>/dev/null || echo "Not installed")
- **GitHub CLI**: $(gh --version 2>/dev/null | head -1 || echo "Not installed")
- **jq**: $(jq --version 2>/dev/null || echo "Not installed")
- **curl**: $(curl --version 2>/dev/null | head -1 || echo "Not installed")

### Environment Variables (Relevant)
\`\`\`
CI_ENVIRONMENT=${CI_ENVIRONMENT:-not set}
USE_CONTAINER=${USE_CONTAINER:-not set}
GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-not set}
GITHUB_TOKEN=${GITHUB_TOKEN:+***set***}
PAT_TOKEN=${PAT_TOKEN:+***set***}
GH_TOKEN=${GH_TOKEN:+***set***}
\`\`\`

EOF
}

# Function to collect repository information
collect_repo_info() {
    cat << EOF
## Repository Information

### Git Status
\`\`\`
$(git status --porcelain 2>/dev/null || echo "Not a git repository")
\`\`\`

### Current Branch
\`\`\`
$(git branch --show-current 2>/dev/null || echo "Unknown")
\`\`\`

### Recent Commits
\`\`\`
$(git log --oneline -10 2>/dev/null || echo "No commits found")
\`\`\`

### Remote URLs
\`\`\`
$(git remote -v 2>/dev/null || echo "No remotes configured")
\`\`\`

### Repository Structure
\`\`\`
$(tree -L 3 -I '.git|_site|node_modules|logs|debug-output' . 2>/dev/null || find . -maxdepth 3 -type d -name .git -prune -o -type d -print | head -20)
\`\`\`

EOF
}

# Function to collect workflow information
collect_workflow_info() {
    local workflow_file=".github/workflows/ai_evolver.yml"
    
    cat << EOF
## GitHub Actions Workflow Information

### Workflow Files
\`\`\`
$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null || echo "No workflow files found")
\`\`\`

### Main Workflow Content
EOF

    if [ -f "$workflow_file" ]; then
        echo "\`\`\`yaml"
        cat "$workflow_file"
        echo "\`\`\`"
    else
        echo "Main workflow file not found: $workflow_file"
    fi

    cat << EOF

### Workflow Validation
\`\`\`
$(act --list 2>&1 || echo "Act validation failed or not available")
\`\`\`

EOF
}

# Function to collect recent logs
collect_logs() {
    cat << EOF
## Recent Logs and Output

EOF

    # Local logs
    if [ -d "./logs" ]; then
        echo "### Local Log Files"
        echo "\`\`\`"
        ls -la logs/ 2>/dev/null || echo "No local logs directory"
        echo "\`\`\`"
        
        # Get most recent local log
        local recent_log=$(ls -t logs/*.log 2>/dev/null | head -1 || echo "")
        if [ -n "$recent_log" ]; then
            echo "### Most Recent Local Log: $recent_log"
            echo "\`\`\`"
            tail -100 "$recent_log"
            echo "\`\`\`"
        fi
    fi

    # GitHub Actions logs (if available)
    if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
        echo "### Recent GitHub Actions Runs"
        echo "\`\`\`"
        gh run list --limit 5 2>/dev/null || echo "Failed to fetch GitHub Actions runs"
        echo "\`\`\`"
        
        # Try to get the latest run logs
        local latest_run_id=$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || echo "")
        if [ -n "$latest_run_id" ] && [ "$latest_run_id" != "null" ]; then
            echo "### Latest GitHub Actions Run Log (ID: $latest_run_id)"
            echo "\`\`\`"
            timeout 30 gh run view "$latest_run_id" --log 2>/dev/null | tail -200 || echo "Could not fetch run logs"
            echo "\`\`\`"
        fi
    else
        echo "### GitHub Actions Logs"
        echo "GitHub CLI not available or not authenticated"
    fi
}

# Function to collect script information
collect_script_info() {
    cat << EOF
## Scripts and Configuration

### Script Files
\`\`\`
$(find scripts -name "*.sh" -type f 2>/dev/null | sort || echo "No scripts directory found")
\`\`\`

### Script Permissions
\`\`\`
$(find scripts -name "*.sh" -type f -exec ls -la {} \; 2>/dev/null || echo "Cannot check script permissions")
\`\`\`

### Evolution Metrics (if available)
\`\`\`json
$(cat evolution-metrics.json 2>/dev/null | jq . || echo "Evolution metrics file not found or invalid JSON")
\`\`\`

### Package/Dependency Files
EOF

    for file in package.json Gemfile requirements.txt Dockerfile docker-compose.yml; do
        if [ -f "$file" ]; then
            echo "#### $file"
            echo "\`\`\`"
            cat "$file"
            echo "\`\`\`"
        fi
    done
}

# Function to collect error patterns
collect_error_analysis() {
    cat << EOF
## Error Analysis

### Common Error Patterns in Logs
EOF

    # Search for common error patterns in logs
    if [ -d "./logs" ]; then
        echo "#### Error Keywords Found:"
        echo "\`\`\`"
        grep -i "error\|failed\|fatal\|exception\|denied\|unauthorized\|timeout" logs/*.log 2>/dev/null | tail -20 || echo "No error patterns found in logs"
        echo "\`\`\`"
        
        echo "#### Warning Keywords Found:"
        echo "\`\`\`"
        grep -i "warn\|warning\|deprecated\|skip" logs/*.log 2>/dev/null | tail -10 || echo "No warning patterns found in logs"
        echo "\`\`\`"
    fi

    # Check for common GitHub Actions issues
    echo "### Common GitHub Actions Issues Check"
    echo "\`\`\`"
    
    # Check if secrets are properly configured
    if [ -f ".secrets" ]; then
        echo "✓ Local secrets file exists"
    else
        echo "⚠ Local secrets file (.secrets) not found"
    fi
    
    # Check Docker status
    if docker info >/dev/null 2>&1; then
        echo "✓ Docker is running"
    else
        echo "⚠ Docker is not running or not available"
    fi
    
    # Check GitHub authentication
    if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
        echo "✓ GitHub CLI is authenticated"
    else
        echo "⚠ GitHub CLI not authenticated"
    fi
    
    echo "\`\`\`"
}

# Function to create troubleshooting suggestions
create_troubleshooting_guide() {
    cat << EOF
## Troubleshooting Guide

### For AI Analysis
When sharing this debug report with an AI assistant, ask them to:

1. **Analyze Error Patterns**: Look for recurring errors or failure points
2. **Check Dependencies**: Verify all required tools and permissions are available
3. **Validate Configuration**: Review workflow syntax and environment setup
4. **Suggest Fixes**: Provide specific commands or code changes to resolve issues
5. **Test Plan**: Recommend a testing strategy to verify fixes

### Quick Fixes to Try

#### Local Testing Issues
\`\`\`bash
# Ensure scripts are executable
find ./scripts -name "*.sh" -exec chmod +x {} \\;

# Validate workflow syntax
act --list

# Test with dry run
./scripts/test-workflow.sh dry-run --prompt "Test run"
\`\`\`

#### GitHub Actions Issues
\`\`\`bash
# Check authentication
gh auth status

# View recent runs
gh run list --limit 5

# Re-run failed workflow
gh run rerun <run-id>
\`\`\`

#### Docker Issues
\`\`\`bash
# Check Docker status
docker info

# Pull required images
docker pull catthehacker/ubuntu:act-latest
\`\`\`

### Next Steps
1. Share this debug report with your AI assistant
2. Follow their specific recommendations
3. Test fixes locally before pushing to GitHub
4. Update this report after implementing fixes

EOF
}

# Main function to generate debug report
generate_debug_report() {
    log_info "Generating comprehensive debug report..."
    log_info "Output file: $DEBUG_FILE"
    
    cat > "$DEBUG_FILE" << EOF
# GitHub Actions Debug Report
*Generated on $(date)*

This report contains comprehensive debugging information for AI analysis.

EOF

    # Collect all information
    collect_system_info >> "$DEBUG_FILE"
    collect_repo_info >> "$DEBUG_FILE"
    collect_workflow_info >> "$DEBUG_FILE"
    collect_logs >> "$DEBUG_FILE"
    collect_script_info >> "$DEBUG_FILE"
    collect_error_analysis >> "$DEBUG_FILE"
    create_troubleshooting_guide >> "$DEBUG_FILE"
    
    log_success "Debug report generated: $DEBUG_FILE"
    
    # Create a summary for quick reference
    local summary_file="$OUTPUT_DIR/debug-summary-$TIMESTAMP.txt"
    cat > "$summary_file" << EOF
Debug Report Summary - $(date)
===============================

Main Report: $DEBUG_FILE
Repository: $(pwd)
Git Branch: $(git branch --show-current 2>/dev/null || echo "Unknown")

Quick Status:
- Docker Running: $(docker info >/dev/null 2>&1 && echo "Yes" || echo "No")
- GitHub Auth: $(gh auth status >/dev/null 2>&1 && echo "Yes" || echo "No")
- Act Available: $(command -v act >/dev/null 2>&1 && echo "Yes" || echo "No")
- Local Logs: $([ -d logs ] && ls logs/*.log 2>/dev/null | wc -l || echo "0") files

To share with AI:
1. Upload or paste the content of: $DEBUG_FILE
2. Ask for specific troubleshooting help
3. Request step-by-step solutions

EOF

    log_info "Summary created: $summary_file"
    
    # Display key information
    echo ""
    echo "=== KEY INFORMATION FOR AI DEBUGGING ==="
    cat "$summary_file"
    echo "========================================"
    echo ""
    
    log_info "You can now share $DEBUG_FILE with an AI assistant for debugging help"
}

# Script options
case "${1:-generate}" in
    "generate"|"")
        generate_debug_report
        ;;
    "help"|"--help")
        cat << EOF
Usage: $0 [COMMAND]

Commands:
  generate    Generate comprehensive debug report (default)
  help        Show this help message

The debug report will be created in: $OUTPUT_DIR/
EOF
        ;;
    *)
        log_error "Unknown command: $1"
        exit 1
        ;;
esac
