#!/bin/bash

# AI Evolution Engine - Manual Workflow Runner
# This script helps you manually invoke GitHub Actions workflows and monitor their execution
# Version: 0.3.6-seed

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

# Check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed."
        echo "Install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated."
        echo "Run: gh auth login"
        exit 1
    fi
    
    log_success "GitHub CLI is installed and authenticated"
}

# Show available workflows
show_workflows() {
    log_info "📋 Available AI Evolution Workflows"
    echo
    echo "1. ai_evolver.yml - Manual AI Evolution Engine"
    echo "   Purpose: Custom AI-driven evolution with human prompts"
    echo "   Use cases: Feature development, custom improvements"
    echo
    echo "2. daily_evolution.yml - Automated Maintenance"
    echo "   Purpose: Repository health checks and maintenance"
    echo "   Use cases: Consistency fixes, error resolution, documentation"
    echo
    echo "3. testing_automation_evolver.yml - Testing & Build Optimization"
    echo "   Purpose: Testing and CI/CD improvements"
    echo "   Use cases: Test automation, build optimization, error resilience"
    echo
}

# Function to run AI Evolution workflow
run_ai_evolver() {
    local prompt="$1"
    local growth_mode="${2:-adaptive}"
    local dry_run="${3:-false}"
    local auto_plant_seeds="${4:-true}"
    local use_container="${5:-true}"
    
    log_info "🚀 Running AI Evolution Workflow"
    log_info "Prompt: $prompt"
    log_info "Growth Mode: $growth_mode"
    log_info "Dry Run: $dry_run"
    
    gh workflow run ai_evolver.yml \
        -f prompt="$prompt" \
        -f growth_mode="$growth_mode" \
        -f dry_run="$dry_run" \
        -f auto_plant_seeds="$auto_plant_seeds" \
        -f use_container="$use_container"
    
    log_success "Workflow triggered successfully!"
}

# Function to run Daily Evolution workflow
run_daily_evolution() {
    local evolution_type="${1:-consistency}"
    local intensity="${2:-minimal}"
    local force_run="${3:-false}"
    local dry_run="${4:-false}"
    
    log_info "📅 Running Daily Evolution Workflow"
    log_info "Evolution Type: $evolution_type"
    log_info "Intensity: $intensity"
    log_info "Force Run: $force_run"
    log_info "Dry Run: $dry_run"
    
    gh workflow run daily_evolution.yml \
        -f evolution_type="$evolution_type" \
        -f intensity="$intensity" \
        -f force_run="$force_run" \
        -f dry_run="$dry_run"
    
    log_success "Workflow triggered successfully!"
}

# Function to run Testing Automation workflow
run_testing_automation() {
    local growth_mode="${1:-test-automation}"
    local cycle="${2:-3}"
    local generation="${3:-1}"
    local dry_run="${4:-false}"
    
    log_info "🧪 Running Testing Automation Workflow"
    log_info "Growth Mode: $growth_mode"
    log_info "Cycle: $cycle"
    log_info "Generation: $generation"
    log_info "Dry Run: $dry_run"
    
    gh workflow run testing_automation_evolver.yml \
        -f growth_mode="$growth_mode" \
        -f cycle="$cycle" \
        -f generation="$generation" \
        -f dry_run="$dry_run"
    
    log_success "Workflow triggered successfully!"
}

# Function to monitor workflow runs
monitor_workflows() {
    log_info "📜 Recent Workflow Runs"
    gh run list --limit 10
    echo
    
    log_info "To view logs for a specific run, use:"
    echo "gh run view <run-id> --log"
    echo
    log_info "To watch a running workflow:"
    echo "gh run watch <run-id>"
}

# Function to view workflow logs
view_logs() {
    local run_id="$1"
    log_info "🔍 Viewing Logs for Run: $run_id"
    gh run view "$run_id" --log
}

# Function to watch workflow
watch_workflow() {
    local run_id="$1"
    log_info "👀 Watching Workflow Run: $run_id"
    gh run watch "$run_id"
}

# Show usage information
show_usage() {
    echo "AI Evolution Workflow Runner - Usage Guide"
    echo
    echo "Basic Commands:"
    echo "  $0 list                                    # Show available workflows"
    echo "  $0 monitor                                 # Show recent workflow runs"
    echo "  $0 logs <run-id>                          # View logs for specific run"
    echo "  $0 watch <run-id>                         # Watch running workflow"
    echo
    echo "Run Workflows:"
    echo "  $0 ai \"<prompt>\" [growth_mode] [dry_run]   # Run AI Evolution"
    echo "  $0 daily [type] [intensity] [force] [dry] # Run Daily Evolution"
    echo "  $0 testing [mode] [cycle] [gen] [dry]     # Run Testing Automation"
    echo
    echo "Examples:"
    echo "  $0 ai \"Add user authentication\" experimental false"
    echo "  $0 daily error_fixing moderate true false"
    echo "  $0 testing test-automation 4 2 true"
    echo
    echo "Growth Modes (AI Evolution):"
    echo "  - conservative: Safe, minimal changes"
    echo "  - adaptive: Balanced approach (default)"
    echo "  - experimental: Advanced features"
    echo
    echo "Evolution Types (Daily):"
    echo "  - consistency: Fix inconsistencies"
    echo "  - error_fixing: Resolve errors"
    echo "  - documentation: Improve docs"
    echo "  - code_quality: Enhance code"
    echo "  - security_updates: Security improvements"
    echo
    echo "Testing Modes:"
    echo "  - test-automation: Focus on testing"
    echo "  - build-optimization: Build improvements"
    echo "  - error-resilience: Error handling"
    echo "  - ci-cd-enhancement: CI/CD improvements"
}

# Main script logic
main() {
    check_gh_cli
    
    case "${1:-help}" in
        "list")
            show_workflows
            ;;
        "monitor")
            monitor_workflows
            ;;
        "logs")
            if [ $# -lt 2 ]; then
                log_error "Run ID required for logs command"
                echo "Usage: $0 logs <run-id>"
                exit 1
            fi
            view_logs "$2"
            ;;
        "watch")
            if [ $# -lt 2 ]; then
                log_error "Run ID required for watch command"
                echo "Usage: $0 watch <run-id>"
                exit 1
            fi
            watch_workflow "$2"
            ;;
        "ai")
            if [ $# -lt 2 ]; then
                log_error "Prompt required for AI evolution"
                echo "Usage: $0 ai \"<prompt>\" [growth_mode] [dry_run]"
                exit 1
            fi
            run_ai_evolver "$2" "${3:-adaptive}" "${4:-false}" "${5:-true}" "${6:-true}"
            ;;
        "daily")
            run_daily_evolution "${2:-consistency}" "${3:-minimal}" "${4:-false}" "${5:-false}"
            ;;
        "testing")
            run_testing_automation "${2:-test-automation}" "${3:-3}" "${4:-1}" "${5:-false}"
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
