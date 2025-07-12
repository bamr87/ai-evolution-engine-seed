#!/bin/bash
#
# @file tests/workflows/test-workflow.sh
# @description Comprehensive GitHub Actions testing and debugging script
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-06
# @version 0.3.6-seed
#
# @relatedIssues 
#   - GitHub Actions workflow testing and debugging
#
# @relatedEvolutions
#   - v0.3.6: Migrated from scripts/ to tests/workflows/
#   - v0.3.6-seed: Modular Architecture
#
# @dependencies
#   - bash: >=4.0
#   - act: For local workflow testing
#   - gh: GitHub CLI for remote operations
#
# @changelog
#   - 2025-07-06: Migrated to tests/workflows/ directory - ITJ
#   - 2025-07-05: Initial creation with modular architecture - ITJ
#
# @usage ./tests/workflows/test-workflow.sh [COMMAND] [OPTIONS]
# @notes Supports both local testing with 'act' and remote workflow analysis
#

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Import modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/core/testing.sh"

# Initialize environment and logging
init_environment_config
init_logger "logs" "test-workflow"

# Configuration
WORKFLOW_FILE=".github/workflows/ai_evolver.yml"
LOG_DIR="./logs"
SECRETS_FILE=".secrets" # For local testing only - never commit this file

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
  local           Run workflow locally with 'act'
  debug           Run workflow locally with debug output
  validate        Validate workflow syntax
  logs            Fetch and analyze recent GitHub Action logs
  setup           Setup local testing environment
  dry-run         Simulate workflow without making changes

Options:
  --prompt TEXT   Specify the prompt for testing (default: "Test run")
  --mode MODE     Growth mode: conservative|adaptive|experimental (default: adaptive)
  --secrets FILE  Path to secrets file for local testing
  --job JOB       Specific job to run (default: all jobs)
  --help          Show this help message

Examples:
  $0 setup                                    # Setup testing environment
  $0 local --prompt "Add authentication"     # Test locally
  $0 debug --mode experimental               # Debug mode
  $0 logs                                     # Fetch recent logs
  $0 validate                                 # Check workflow syntax
EOF
}

# Function to setup local testing environment
setup_testing() {
    log_info "Setting up local testing environment..."
    
    # Create logs directory
    mkdir -p "$LOG_DIR"
    
    # Check if act is installed
    if ! command -v act >/dev/null 2>&1; then
        log_error "act is not installed. Install with: brew install act"
        exit 1
    fi
    
    # Check if Docker is running (required for act)
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    
    # Create sample secrets file if it doesn't exist
    if [ ! -f "$SECRETS_FILE" ]; then
        log_info "Creating sample secrets file: $SECRETS_FILE"
        cat > "$SECRETS_FILE" << 'EOF'
# Local testing secrets - NEVER commit this file
# Add your GitHub token for testing
GITHUB_TOKEN=your_github_token_here
PAT_TOKEN=your_pat_token_here
EOF
        log_warn "Please edit $SECRETS_FILE and add your GitHub tokens"
    fi
    
    # Add to .gitignore if not already there
    if [ -f ".gitignore" ] && ! grep -q "^\.secrets$" .gitignore; then
        echo ".secrets" >> .gitignore
        log_info "Added .secrets to .gitignore"
    fi
    
    log_success "Testing environment setup complete"
}

# Function to validate workflow syntax
validate_workflow() {
    log_info "Validating workflow syntax..."
    
    if [ ! -f "$WORKFLOW_FILE" ]; then
        log_error "Workflow file not found: $WORKFLOW_FILE"
        exit 1
    fi
    
    # Use act to validate workflow
    if act --list >/dev/null 2>&1; then
        log_success "Workflow syntax is valid"
        
        # Show available jobs
        log_info "Available jobs:"
        act --list
    else
        log_error "Workflow syntax validation failed"
        exit 1
    fi
}

# Function to run workflow locally
run_local() {
    local prompt="${1:-Test run}"
    local mode="${2:-adaptive}"
    local job="${3:-}"
    local debug_mode="${4:-false}"
    
    log_info "Running workflow locally..."
    log_info "Prompt: $prompt"
    log_info "Mode: $mode"
    
    # Prepare act command
    local act_cmd="act workflow_dispatch"
    
    # Add secrets if available
    if [ -f "$SECRETS_FILE" ]; then
        act_cmd="$act_cmd --secret-file $SECRETS_FILE"
    fi
    
    # Add input variables
    act_cmd="$act_cmd --input prompt='$prompt' --input growth_mode='$mode' --input dry_run=true"
    
    # Add job filter if specified
    if [ -n "$job" ]; then
        act_cmd="$act_cmd --job $job"
    fi
    
    # Add debug flags if needed
    if [ "$debug_mode" = "true" ]; then
        act_cmd="$act_cmd --verbose --env ACT=true"
    fi
    
    # Create log file
    local log_file="$LOG_DIR/local-run-$(date +%Y%m%d-%H%M%S).log"
    
    log_info "Running: $act_cmd"
    log_info "Log file: $log_file"
    
    # Run act and capture output
    if eval "$act_cmd" 2>&1 | tee "$log_file"; then
        log_success "Local workflow run completed"
        log_info "Check log file for details: $log_file"
    else
        log_error "Local workflow run failed"
        log_info "Check log file for errors: $log_file"
        exit 1
    fi
}

# Function to fetch and analyze GitHub Action logs
fetch_github_logs() {
    log_info "Fetching recent GitHub Action logs..."
    
    # Check if gh CLI is installed and authenticated
    if ! command -v gh >/dev/null 2>&1; then
        log_error "GitHub CLI (gh) is not installed. Install with: brew install gh"
        exit 1
    fi
    
    if ! gh auth status >/dev/null 2>&1; then
        log_error "GitHub CLI not authenticated. Run: gh auth login"
        exit 1
    fi
    
    # Fetch recent workflow runs
    local runs_file="$LOG_DIR/recent-runs-$(date +%Y%m%d-%H%M%S).json"
    
    log_info "Fetching workflow runs..."
    gh run list --workflow="$WORKFLOW_FILE" --limit=10 --json=status,conclusion,createdAt,headBranch,databaseId > "$runs_file"
    
    # Display recent runs
    log_info "Recent workflow runs:"
    gh run list --workflow="$WORKFLOW_FILE" --limit=5
    
    # Get the most recent run ID
    local latest_run_id
    latest_run_id=$(jq -r '.[0].databaseId' "$runs_file" 2>/dev/null || echo "")
    
    if [ -n "$latest_run_id" ] && [ "$latest_run_id" != "null" ]; then
        log_info "Fetching logs for latest run: $latest_run_id"
        
        local log_file="$LOG_DIR/github-logs-$latest_run_id-$(date +%Y%m%d-%H%M%S).log"
        
        # Download logs
        if gh run download "$latest_run_id" --dir "$LOG_DIR/run-$latest_run_id" 2>/dev/null; then
            log_success "Logs downloaded to: $LOG_DIR/run-$latest_run_id"
        else
            # If download fails, try to view logs directly
            log_info "Attempting to view logs directly..."
            gh run view "$latest_run_id" --log > "$log_file" || true
        fi
        
        # Display log summary
        if [ -f "$log_file" ]; then
            log_info "Log summary:"
            echo "=========================================="
            tail -50 "$log_file"
            echo "=========================================="
        fi
    else
        log_warn "No recent workflow runs found"
    fi
}

# Function to create debug script for AI analysis
create_debug_output() {
    local log_file="$1"
    local debug_file="$LOG_DIR/debug-analysis-$(date +%Y%m%d-%H%M%S).md"
    
    log_info "Creating debug analysis file: $debug_file"
    
    cat > "$debug_file" << EOF
# GitHub Actions Debug Analysis

## Environment Info
- Date: $(date)
- Repository: $(git remote get-url origin 2>/dev/null || echo "Unknown")
- Branch: $(git branch --show-current 2>/dev/null || echo "Unknown")
- Commit: $(git rev-parse HEAD 2>/dev/null || echo "Unknown")

## Workflow Information
- Workflow File: $WORKFLOW_FILE
- Log File: $log_file

## Recent Git Activity
\`\`\`
$(git log --oneline -5 2>/dev/null || echo "No git history available")
\`\`\`

## Repository Structure
\`\`\`
$(tree -L 3 -I '.git|_site|node_modules' . 2>/dev/null || find . -type d -name .git -prune -o -type f -print | head -20)
\`\`\`

## Log Content
\`\`\`
$(cat "$log_file" 2>/dev/null || echo "Log file not available")
\`\`\`

## System Information
- OS: $(uname -s)
- Architecture: $(uname -m)
- Docker: $(docker --version 2>/dev/null || echo "Not available")
- Act: $(act --version 2>/dev/null || echo "Not available")
- GitHub CLI: $(gh --version 2>/dev/null || echo "Not available")

## Troubleshooting Checklist
- [ ] Workflow syntax is valid
- [ ] All required secrets are configured
- [ ] Dependencies are installed
- [ ] Docker is running (for local testing)
- [ ] GitHub CLI is authenticated
- [ ] Repository permissions are correct
EOF

    log_success "Debug analysis created: $debug_file"
    log_info "You can share this file with AI assistants for debugging help"
}

# Main script logic
main() {
    local command="${1:-help}"
    local prompt="Test run"
    local mode="adaptive"
    local job=""
    local secrets_file="$SECRETS_FILE"
    
    # Parse arguments
    shift || true
    while [[ $# -gt 0 ]]; do
        case $1 in
            --prompt)
                prompt="$2"
                shift 2
                ;;
            --mode)
                mode="$2"
                shift 2
                ;;
            --job)
                job="$2"
                shift 2
                ;;
            --secrets)
                secrets_file="$2"
                shift 2
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Execute command
    case $command in
        "setup")
            setup_testing
            ;;
        "local")
            validate_workflow
            run_local "$prompt" "$mode" "$job" "false"
            ;;
        "debug")
            validate_workflow
            run_local "$prompt" "$mode" "$job" "true"
            ;;
        "validate")
            validate_workflow
            ;;
        "logs")
            fetch_github_logs
            ;;
        "dry-run")
            log_info "Running dry-run simulation..."
            validate_workflow
            run_local "$prompt" "$mode" "$job" "false"
            ;;
        "help"|*)
            show_usage
            ;;
    esac
}

# Run main function with all arguments
main "$@"
