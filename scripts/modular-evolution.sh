#!/bin/bash
#
# @file scripts/modular-evolution.sh
# @description Main evolution script using fully modular architecture
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Modular refactoring: Create unified modular evolution interface
#
# @relatedEvolutions
#   - v1.0.0: Initial creation with full modular architecture
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - All evolution engine modules
#
# @changelog
#   - 2025-07-07: Initial creation with modular architecture - ITJ
#
# @usage ./scripts/modular-evolution.sh [options]
# @notes Unified interface for all evolution operations using modular design
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load all required modules
require_module "core/logger"
require_module "core/environment"
require_module "core/validation"
require_module "core/config"
require_module "evolution/engine"
require_module "evolution/git"
require_module "evolution/metrics"
require_module "evolution/seeds"
require_module "integration/github"
require_module "integration/ci"
require_module "analysis/health"
require_module "workflow/management"
require_module "utils/json_processor"
require_module "utils/file_operations"
require_module "template/engine"

# Initialize logging
init_logger "logs" "modular-evolution"

# Default configuration
EVOLUTION_TYPE="consistency"
INTENSITY="minimal"
PROMPT=""
GROWTH_MODE="conservative"
AUTO_PLANT="true"
DRY_RUN="false"
VERBOSE="false"
OUTPUT_DIR="./evolution-output"

# Show help message
show_help() {
    cat << EOF
🌱 AI Evolution Engine - Modular Evolution Interface

DESCRIPTION:
    Unified interface for AI-driven repository evolution using modular architecture.
    Supports comprehensive evolution workflows with enhanced error handling and validation.

USAGE:
    $0 [OPTIONS] [COMMAND]

COMMANDS:
    evolve          Perform evolution cycle
    analyze         Analyze repository health
    simulate        Simulate evolution changes
    workflows       Manage GitHub workflows
    test            Run modular system tests
    help            Show this help message

OPTIONS:
    -t, --type TYPE          Evolution type (consistency, error_fixing, documentation, 
                           code_quality, security_updates, custom) [default: consistency]
    -i, --intensity LEVEL    Evolution intensity (minimal, moderate, comprehensive) [default: minimal]
    -p, --prompt TEXT        Custom evolution prompt (required for 'custom' type)
    -m, --mode MODE          Growth mode (conservative, adaptive, experimental) [default: conservative]
    -o, --output DIR         Output directory for results [default: ./evolution-output]
    -d, --dry-run           Simulate changes without applying them
    -v, --verbose           Enable verbose logging
    -h, --help              Show this help message

EXAMPLES:
    # Basic consistency evolution
    $0 evolve -t consistency -i minimal

    # Custom feature evolution
    $0 evolve -t custom -p "Add user authentication" -m adaptive

    # Repository health analysis
    $0 analyze -v

    # Simulate evolution changes
    $0 simulate -p "Improve error handling" -d

    # Test modular system
    $0 test

MODULAR FEATURES:
    ✅ Comprehensive error handling and validation
    ✅ Enhanced logging with multiple output formats
    ✅ Cross-platform compatibility (macOS, Linux)
    ✅ GitHub integration with workflow management
    ✅ Repository health analysis and recommendations
    ✅ Template-based content generation
    ✅ Robust JSON processing and file operations
    ✅ Automated testing and validation

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                EVOLUTION_TYPE="$2"
                shift 2
                ;;
            -i|--intensity)
                INTENSITY="$2"
                shift 2
                ;;
            -p|--prompt)
                PROMPT="$2"
                shift 2
                ;;
            -m|--mode)
                GROWTH_MODE="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -d|--dry-run)
                DRY_RUN="true"
                shift
                ;;
            -v|--verbose)
                VERBOSE="true"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            evolve|analyze|simulate|workflows|test|help)
                COMMAND="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Execute evolution command
cmd_evolve() {
    log_info "Starting modular evolution process..."
    
    # Validate evolution type
    case "$EVOLUTION_TYPE" in
        consistency|error_fixing|documentation|code_quality|security_updates)
            log_info "Using predefined evolution type: $EVOLUTION_TYPE"
            ;;
        custom)
            if [[ -z "$PROMPT" ]]; then
                log_error "Custom evolution type requires a prompt. Use -p/--prompt option."
                exit 1
            fi
            log_info "Using custom evolution prompt: $PROMPT"
            ;;
        *)
            log_error "Invalid evolution type: $EVOLUTION_TYPE"
            exit 1
            ;;
    esac
    
    # Ensure output directory
    ensure_directory "$OUTPUT_DIR"
    
    # Step 1: Environment setup
    log_info "Setting up evolution environment..."
    setup_evolution_environment
    
    # Step 2: Repository health analysis
    log_info "Analyzing repository health..."
    local health_report="$OUTPUT_DIR/health-report.json"
    analyze_repository_health_full "$health_report"
    
    # Step 3: Context collection
    log_info "Collecting repository context..."
    local context_file="$OUTPUT_DIR/repo-context.json"
    collect_evolution_context "$PROMPT" "$GROWTH_MODE" "$context_file"
    
    # Step 4: Evolution simulation
    log_info "Simulating evolution changes..."
    local response_file="$OUTPUT_DIR/evolution-response.json"
    simulate_evolution "$PROMPT" "$GROWTH_MODE" "$context_file" "$response_file"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Dry run mode - changes simulated but not applied"
        log_info "Evolution response saved to: $response_file"
        return 0
    fi
    
    # Step 5: Apply changes
    log_info "Applying evolution changes..."
    apply_evolution_changes "$response_file"
    
    # Step 6: Validation
    log_info "Validating applied changes..."
    validate_evolution_changes "$response_file"
    
    log_success "Evolution cycle completed successfully!"
    log_info "Results saved to: $OUTPUT_DIR"
}

# Execute analyze command
cmd_analyze() {
    log_info "Starting repository health analysis..."
    
    ensure_directory "$OUTPUT_DIR"
    local health_report="$OUTPUT_DIR/health-analysis.json"
    
    if analyze_repository_health_full "$health_report"; then
        log_success "Health analysis completed successfully!"
        log_info "Report saved to: $health_report"
        
        # Display summary if verbose
        if [[ "$VERBOSE" == "true" ]]; then
            local score=$(json_get_value "$(cat "$health_report")" ".overall_score" "0")
            local recommendations=$(json_array_length "$(json_get_value "$(cat "$health_report")" ".recommendations" "[]")")
            log_info "Overall Health Score: $score/100"
            log_info "Recommendations: $recommendations"
        fi
    else
        log_error "Health analysis failed"
        exit 1
    fi
}

# Execute simulate command
cmd_simulate() {
    log_info "Starting evolution simulation..."
    
    if [[ -z "$PROMPT" ]]; then
        log_error "Simulation requires a prompt. Use -p/--prompt option."
        exit 1
    fi
    
    ensure_directory "$OUTPUT_DIR"
    
    local context_file="$OUTPUT_DIR/simulation-context.json"
    local response_file="$OUTPUT_DIR/simulation-response.json"
    
    # Collect context
    collect_evolution_context "$PROMPT" "$GROWTH_MODE" "$context_file"
    
    # Simulate evolution
    simulate_evolution "$PROMPT" "$GROWTH_MODE" "$context_file" "$response_file"
    
    log_success "Evolution simulation completed!"
    log_info "Simulation results saved to: $response_file"
    
    if [[ "$VERBOSE" == "true" ]]; then
        local changes=$(json_array_length "$(json_get_value "$(cat "$response_file")" ".changes" "[]")")
        log_info "Simulated changes: $changes"
    fi
}

# Execute workflows command
cmd_workflows() {
    log_info "Managing GitHub workflows..."
    
    log_info "Available workflows:"
    workflow_list_runs "ai_evolver.yml" 5
    workflow_list_runs "daily_evolution.yml" 5
}

# Execute test command
cmd_test() {
    log_info "Running modular system tests..."
    
    # Test core modules
    log_info "Testing core modules..."
    test_module_loading "core/logger"
    test_module_loading "core/environment"
    test_module_loading "core/validation"
    
    # Test evolution modules
    log_info "Testing evolution modules..."
    test_module_loading "evolution/engine"
    test_module_loading "evolution/git"
    test_module_loading "evolution/metrics"
    
    # Test utility modules
    log_info "Testing utility modules..."
    test_module_loading "utils/json_processor"
    test_module_loading "utils/file_operations"
    
    log_success "All modular system tests passed!"
}

# Main execution
main() {
    local COMMAND="${1:-evolve}"
    
    # Set verbose logging if requested
    if [[ "$VERBOSE" == "true" ]]; then
        set_log_level "DEBUG"
    fi
    
    log_info "🌱 AI Evolution Engine - Modular Architecture v1.0.0"
    log_info "Command: $COMMAND"
    log_info "Mode: $GROWTH_MODE | Intensity: $INTENSITY | Type: $EVOLUTION_TYPE"
    
    case "$COMMAND" in
        evolve)
            cmd_evolve
            ;;
        analyze)
            cmd_analyze
            ;;
        simulate)
            cmd_simulate
            ;;
        workflows)
            cmd_workflows
            ;;
        test)
            cmd_test
            ;;
        help)
            show_help
            ;;
        *)
            log_error "Unknown command: $COMMAND"
            show_help
            exit 1
            ;;
    esac
}

# Parse arguments and execute
parse_arguments "$@"
main "$@"
