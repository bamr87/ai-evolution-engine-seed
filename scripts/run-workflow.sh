#!/bin/bash

# AI Evolution Engine - Manual Workflow Runner
# This script helps you manually invoke GitHub Actions workflows and monitor their execution
# Version: 0.3.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

# Check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed."
        echo "Install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated."
        echo "Run: gh auth login"
        exit 1
    fi
    
    print_success "GitHub CLI is installed and authenticated"
}

# Show available workflows
show_workflows() {
    print_header "Available AI Evolution Workflows"
    echo
    echo -e "${CYAN}1. ai_evolver.yml${NC} - Manual AI Evolution Engine"
    echo "   Purpose: Custom AI-driven evolution with human prompts"
    echo "   Use cases: Feature development, custom improvements"
    echo
    echo -e "${CYAN}2. daily_evolution.yml${NC} - Automated Maintenance"
    echo "   Purpose: Repository health checks and maintenance"
    echo "   Use cases: Consistency fixes, error resolution, documentation"
    echo
    echo -e "${CYAN}3. testing_automation_evolver.yml${NC} - Testing & Build Optimization"
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
    
    print_header "Running AI Evolution Workflow"
    print_status "Prompt: $prompt"
    print_status "Growth Mode: $growth_mode"
    print_status "Dry Run: $dry_run"
    
    gh workflow run ai_evolver.yml \
        -f prompt="$prompt" \
        -f growth_mode="$growth_mode" \
        -f dry_run="$dry_run" \
        -f auto_plant_seeds="$auto_plant_seeds" \
        -f use_container="$use_container"
    
    print_success "Workflow triggered successfully!"
}

# Function to run Daily Evolution workflow
run_daily_evolution() {
    local evolution_type="${1:-consistency}"
    local intensity="${2:-minimal}"
    local force_run="${3:-false}"
    local dry_run="${4:-false}"
    
    print_header "Running Daily Evolution Workflow"
    print_status "Evolution Type: $evolution_type"
    print_status "Intensity: $intensity"
    print_status "Force Run: $force_run"
    print_status "Dry Run: $dry_run"
    
    gh workflow run daily_evolution.yml \
        -f evolution_type="$evolution_type" \
        -f intensity="$intensity" \
        -f force_run="$force_run" \
        -f dry_run="$dry_run"
    
    print_success "Workflow triggered successfully!"
}

# Function to run Testing Automation workflow
run_testing_automation() {
    local growth_mode="${1:-test-automation}"
    local cycle="${2:-3}"
    local generation="${3:-1}"
    local dry_run="${4:-false}"
    
    print_header "Running Testing Automation Workflow"
    print_status "Growth Mode: $growth_mode"
    print_status "Cycle: $cycle"
    print_status "Generation: $generation"
    print_status "Dry Run: $dry_run"
    
    gh workflow run testing_automation_evolver.yml \
        -f growth_mode="$growth_mode" \
        -f cycle="$cycle" \
        -f generation="$generation" \
        -f dry_run="$dry_run"
    
    print_success "Workflow triggered successfully!"
}

# Function to monitor workflow runs
monitor_workflows() {
    print_header "Recent Workflow Runs"
    gh run list --limit 10
    echo
    
    print_status "To view logs for a specific run, use:"
    echo "gh run view <run-id> --log"
    echo
    print_status "To watch a running workflow:"
    echo "gh run watch <run-id>"
}

# Function to view workflow logs
view_logs() {
    local run_id="$1"
    print_header "Viewing Logs for Run: $run_id"
    gh run view "$run_id" --log
}

# Function to watch workflow
watch_workflow() {
    local run_id="$1"
    print_header "Watching Workflow Run: $run_id"
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
                print_error "Run ID required for logs command"
                echo "Usage: $0 logs <run-id>"
                exit 1
            fi
            view_logs "$2"
            ;;
        "watch")
            if [ $# -lt 2 ]; then
                print_error "Run ID required for watch command"
                echo "Usage: $0 watch <run-id>"
                exit 1
            fi
            watch_workflow "$2"
            ;;
        "ai")
            if [ $# -lt 2 ]; then
                print_error "Prompt required for AI evolution"
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
            print_error "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
