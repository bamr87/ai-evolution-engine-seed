#!/bin/bash

# 🌱 AI Evolution Engine Core (v3.0.0)
# Simplified core functionality for AI-driven repository evolution

set -euo pipefail

# Configuration
EVOLUTION_VERSION="3.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Utility functions
is_ci() {
    [[ -n "${CI:-}" || -n "${GITHUB_ACTIONS:-}" ]]
}

ensure_executable() {
    local script="$1"
    if [[ ! -x "$script" ]]; then
        chmod +x "$script"
    fi
}

# Environment setup
setup_environment() {
    log_info "Setting up evolution environment..."
    
    # Create necessary directories
    mkdir -p {logs,evolution-output,tests/results}
    
    # Set environment variables
    export EVOLUTION_VERSION="$EVOLUTION_VERSION"
    export PROJECT_ROOT="$PROJECT_ROOT"
    export EVOLUTION_OUTPUT_DIR="$PROJECT_ROOT/evolution-output"
    export LOG_DIR="$PROJECT_ROOT/logs"
    
    # Make scripts executable
    find "$PROJECT_ROOT/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    log_success "Environment setup complete"
}

# Context collection
collect_context() {
    local output_dir="${1:-evolution-output}"
    local context_file="$output_dir/repo-context.json"
    
    log_info "Collecting repository context..."
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Basic repository information
    cat > "$context_file" << EOF
{
  "metadata": {
    "version": "$EVOLUTION_VERSION",
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "repository": "$(basename "$PROJECT_ROOT")",
    "collection_method": "simplified_core"
  },
  "repository": {
    "structure": {},
    "files": {},
    "metrics": {
      "total_files": 0,
      "script_count": 0,
      "workflow_count": 0,
      "documentation_count": 0
    }
  },
  "analysis": {
    "health_score": 85,
    "issues": [],
    "suggestions": []
  }
}
EOF
    
    # Collect basic file structure
    if command -v tree >/dev/null 2>&1; then
        tree -I 'node_modules|.git|*.log' -J "$PROJECT_ROOT" > "$output_dir/structure.json" 2>/dev/null || true
    fi
    
    # Count files by type
    local script_count=$(find "$PROJECT_ROOT" -name "*.sh" | wc -l)
    local workflow_count=$(find "$PROJECT_ROOT/.github/workflows" -name "*.yml" 2>/dev/null | wc -l)
    local doc_count=$(find "$PROJECT_ROOT/docs" -name "*.md" 2>/dev/null | wc -l)
    
    # Update metrics
    jq --arg scripts "$script_count" \
       --arg workflows "$workflow_count" \
       --arg docs "$doc_count" \
       '.repository.metrics.script_count = ($scripts | tonumber) |
        .repository.metrics.workflow_count = ($workflows | tonumber) |
        .repository.metrics.documentation_count = ($docs | tonumber) |
        .repository.metrics.total_files = (.repository.metrics.script_count + .repository.metrics.workflow_count + .repository.metrics.documentation_count)' \
       "$context_file" > "$context_file.tmp" && mv "$context_file.tmp" "$context_file"
    
    log_success "Context collected: $context_file"
    echo "$context_file"
}

# AI simulation
simulate_evolution() {
    local prompt="$1"
    local mode="${2:-conservative}"
    local output_dir="${3:-evolution-output}"
    local response_file="$output_dir/evolution-response.json"
    
    log_info "Simulating AI evolution..."
    log_info "Prompt: $prompt"
    log_info "Mode: $mode"
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Generate mock evolution response
    cat > "$response_file" << EOF
{
  "metadata": {
    "version": "$EVOLUTION_VERSION",
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "prompt": "$prompt",
    "mode": "$mode",
    "simulation": true
  },
  "changes": [
    {
      "action": "improve",
      "file": "README.md",
      "description": "Update documentation with latest changes",
      "priority": "medium"
    },
    {
      "action": "optimize",
      "file": "scripts/evolve.sh",
      "description": "Improve error handling and logging",
      "priority": "high"
    }
  ],
  "metrics": {
    "files_modified": 2,
    "changes_applied": 2,
    "success_rate": 100
  },
  "summary": "Evolution simulation completed successfully with $mode mode improvements"
}
EOF
    
    log_success "Evolution simulated: $response_file"
    echo "$response_file"
}

# Apply changes
apply_changes() {
    local response_file="$1"
    
    if [[ ! -f "$response_file" ]]; then
        log_error "Response file not found: $response_file"
        return 1
    fi
    
    log_info "Applying evolution changes..."
    
    # Parse changes from response file
    local changes=$(jq -r '.changes[] | "\(.action):\(.file):\(.description)"' "$response_file" 2>/dev/null || echo "")
    
    if [[ -z "$changes" ]]; then
        log_warning "No changes to apply"
        return 0
    fi
    
    # Apply each change (mock implementation)
    echo "$changes" | while IFS=':' read -r action file description; do
        if [[ -n "$action" && -n "$file" ]]; then
            log_info "Applying $action to $file: $description"
            
            # Mock file modification
            if [[ -f "$file" ]]; then
                # Add a comment to indicate evolution
                echo "# Evolution: $description - $(date)" >> "$file"
                log_success "Modified $file"
            else
                log_warning "File not found: $file"
            fi
        fi
    done
    
    log_success "Changes applied successfully"
}

# Validate changes
validate_changes() {
    log_info "Validating applied changes..."
    
    # Check if scripts are executable
    local script_errors=0
    while IFS= read -r -d '' script; do
        if [[ ! -x "$script" ]]; then
            log_warning "Script not executable: $script"
            ((script_errors++))
        fi
    done < <(find "$PROJECT_ROOT/scripts" -name "*.sh" -print0 2>/dev/null)
    
    # Check if workflows are valid YAML
    local workflow_errors=0
    while IFS= read -r -d '' workflow; do
        if ! command -v yq >/dev/null 2>&1; then
            if ! python3 -c "import yaml; yaml.safe_load(open('$workflow'))" 2>/dev/null; then
                log_warning "Invalid YAML in workflow: $workflow"
                ((workflow_errors++))
            fi
        fi
    done < <(find "$PROJECT_ROOT/.github/workflows" -name "*.yml" -print0 2>/dev/null)
    
    # Run basic tests
    local test_errors=0
    if [[ -f "$PROJECT_ROOT/scripts/test.sh" ]]; then
        if ! "$PROJECT_ROOT/scripts/test.sh" validation >/dev/null 2>&1; then
            log_warning "Validation tests failed"
            ((test_errors++))
        fi
    fi
    
    # Summary
    local total_errors=$((script_errors + workflow_errors + test_errors))
    if [[ $total_errors -eq 0 ]]; then
        log_success "All validations passed"
        return 0
    else
        log_warning "Found $total_errors validation issues"
        return 1
    fi
}

# Main function
main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        "setup")
            setup_environment
            ;;
        "context")
            collect_context "$@"
            ;;
        "simulate")
            local prompt=""
            local mode="conservative"
            local output_dir="evolution-output"
            
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -p|--prompt)
                        prompt="$2"
                        shift 2
                        ;;
                    -m|--mode)
                        mode="$2"
                        shift 2
                        ;;
                    -o|--output)
                        output_dir="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            
            if [[ -z "$prompt" ]]; then
                log_error "Prompt is required for simulation"
                exit 1
            fi
            
            simulate_evolution "$prompt" "$mode" "$output_dir"
            ;;
        "apply")
            local response_file="$1"
            if [[ -z "$response_file" ]]; then
                log_error "Response file is required"
                exit 1
            fi
            
            apply_changes "$response_file"
            ;;
        "validate")
            validate_changes
            ;;
        "help"|*)
            cat << EOF
🌱 AI Evolution Engine Core (v$EVOLUTION_VERSION)

Usage: $0 <command> [options]

Commands:
  setup                    Setup evolution environment
  context [output_dir]     Collect repository context
  simulate -p <prompt>     Simulate AI evolution
  apply <response_file>    Apply evolution changes
  validate                 Validate applied changes
  help                     Show this help

Options for simulate:
  -p, --prompt <text>     Evolution prompt (required)
  -m, --mode <mode>       Evolution mode (conservative|adaptive|experimental)
  -o, --output <dir>      Output directory

Examples:
  $0 setup
  $0 context evolution-output
  $0 simulate -p "Improve error handling" -m conservative
  $0 apply evolution-output/evolution-response.json
  $0 validate

EOF
            ;;
    esac
}

# Run main function with all arguments
main "$@" 