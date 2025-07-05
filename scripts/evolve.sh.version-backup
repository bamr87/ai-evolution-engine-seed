#!/bin/bash

#############################################################################
# 🌱 AI Evolution Engine - On-Demand Evolution Runner 🌱
# Version: 2.0.0 - Modular Architecture
# Purpose: Command-line interface for triggering evolution cycles
#############################################################################

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Import modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/git.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

# Initialize logging
init_logger "logs" "evolve"

# Default values
EVOLUTION_TYPE="consistency"
INTENSITY="minimal"
PROMPT=""
GROWTH_MODE="conservative"
AUTO_PLANT="true"
DRY_RUN="false"
VERBOSE="false"

# Show help message
show_help() {
    cat << EOF
🌱 AI Evolution Engine - On-Demand Evolution Runner

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -t, --type TYPE          Evolution type (consistency, error_fixing, documentation, 
                           code_quality, security_updates, custom) [default: consistency]
    -i, --intensity LEVEL    Evolution intensity (minimal, moderate, comprehensive) [default: minimal]
    -p, --prompt TEXT        Custom evolution prompt (required for 'custom' type)
    -m, --mode MODE          Growth mode (conservative, adaptive, experimental) [default: conservative]
    -s, --no-seed           Don't auto-plant seeds for next evolution
    -d, --dry-run           Show what would be done without executing
    -v, --verbose           Enable verbose output
    -h, --help              Show this help message

EVOLUTION TYPES:
    consistency      Fix formatting, naming, and structural inconsistencies
    error_fixing     Address bugs, errors, and robustness issues  
    documentation    Update and improve documentation quality
    code_quality     Enhance code maintainability and readability
    security_updates Apply security improvements and updates
    custom          Use a custom prompt (requires -p/--prompt)

INTENSITY LEVELS:
    minimal         Safe, minimal changes preserving functionality
    moderate        Moderate improvements including minor refactoring
    comprehensive   Significant enhancements and optimizations

EXAMPLES:
    # Quick consistency check and fixes
    $0

    # Documentation improvements with moderate intensity
    $0 --type documentation --intensity moderate

    # Custom evolution with specific prompt
    $0 --type custom --prompt "Add error handling to shell scripts"

    # Comprehensive code quality improvements
    $0 --type code_quality --intensity comprehensive --mode adaptive

    # Dry run to see what would happen
    $0 --type error_fixing --dry-run

REQUIREMENTS:
    - GitHub CLI (gh) installed and authenticated
    - Repository with AI Evolution Engine setup
    - Appropriate permissions for triggering workflows
EOF
}

# Logging functions (using modular logger)
log() {
    log_info "$1"
}

warn() {
    log_warn "$1"
}

error() {
    log_error "$1"
}

success() {
    log_success "$1"
}

verbose_log() {
    if [[ "$VERBOSE" == "true" ]]; then
        log_debug "$1"
    fi
}

# Parse command line arguments
parse_args() {
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
            -s|--no-seed)
                AUTO_PLANT="false"
                shift
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
            *)
                error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

# Validate arguments
validate_args() {
    # Validate evolution type
    case "$EVOLUTION_TYPE" in
        consistency|error_fixing|documentation|code_quality|security_updates|custom)
            ;;
        *)
            error "Invalid evolution type: $EVOLUTION_TYPE"
            echo "Valid types: consistency, error_fixing, documentation, code_quality, security_updates, custom"
            exit 1
            ;;
    esac
    
    # Validate intensity
    case "$INTENSITY" in
        minimal|moderate|comprehensive)
            ;;
        *)
            error "Invalid intensity: $INTENSITY"
            echo "Valid intensities: minimal, moderate, comprehensive"
            exit 1
            ;;
    esac
    
    # Validate growth mode
    case "$GROWTH_MODE" in
        conservative|adaptive|experimental)
            ;;
        *)
            error "Invalid growth mode: $GROWTH_MODE"
            echo "Valid modes: conservative, adaptive, experimental"
            exit 1
            ;;
    esac
    
    # Check for custom prompt when type is custom
    if [[ "$EVOLUTION_TYPE" == "custom" && -z "$PROMPT" ]]; then
        error "Custom evolution type requires a prompt (-p/--prompt)"
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    verbose_log "Checking prerequisites..."
    
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        error "GitHub CLI (gh) is not installed"
        echo "Install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        error "GitHub CLI is not authenticated"
        echo "Run: gh auth login"
        exit 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        error "Not in a git repository"
        exit 1
    fi
    
    # Check for evolution files
    if [[ ! -f "evolution-metrics.json" ]]; then
        warn "evolution-metrics.json not found - this may not be an AI Evolution Engine repository"
    fi
    
    verbose_log "Prerequisites check passed"
}

# Generate evolution prompt
generate_prompt() {
    if [[ "$EVOLUTION_TYPE" == "custom" ]]; then
        echo "$PROMPT"
        return
    fi
    
    verbose_log "Generating evolution prompt for type: $EVOLUTION_TYPE"
    
    # Base prompts for different evolution types
    local base_prompt
    case "$EVOLUTION_TYPE" in
        "consistency")
            base_prompt="Perform consistency improvements and minor fixes across the repository"
            ;;
        "error_fixing")
            base_prompt="Fix errors, bugs, and improve robustness throughout the codebase"
            ;;
        "documentation")
            base_prompt="Update and improve documentation quality, accuracy, and completeness"
            ;;
        "code_quality")
            base_prompt="Enhance code quality, maintainability, and readability"
            ;;
        "security_updates")
            base_prompt="Apply security improvements, updates, and vulnerability fixes"
            ;;
    esac
    
    # Intensity modifiers
    local intensity_modifier
    case "$INTENSITY" in
        "minimal")
            intensity_modifier="Focus on safe, minimal changes that improve quality without altering core functionality."
            ;;
        "moderate")
            intensity_modifier="Apply moderate improvements including minor refactoring and optimization."
            ;;
        "comprehensive")
            intensity_modifier="Perform comprehensive improvements including significant enhancements and modernization."
            ;;
    esac
    
    # Construct the full prompt
    local priority_areas=""
    case "$EVOLUTION_TYPE" in
        "consistency")
            priority_areas="1. Fix formatting inconsistencies (tabs vs spaces, line endings)
2. Standardize naming conventions across files
3. Align code style and structure patterns
4. Harmonize documentation formatting
5. Ensure consistent error handling patterns"
            ;;
        "error_fixing")
            priority_areas="1. Address any TODO/FIXME items where appropriate
2. Fix broken links or references
3. Improve error handling and edge case coverage
4. Resolve any lint warnings or validation issues
5. Strengthen input validation and sanitization"
            ;;
        "documentation")
            priority_areas="1. Update outdated examples and instructions
2. Improve clarity and readability of explanations
3. Add missing documentation for new features
4. Enhance code comments and inline documentation
5. Ensure all public APIs are properly documented"
            ;;
        "code_quality")
            priority_areas="1. Refactor complex functions for better readability
2. Remove dead code and unused variables
3. Improve variable and function naming
4. Enhance modularity and separation of concerns
5. Optimize performance where beneficial"
            ;;
        "security_updates")
            priority_areas="1. Update dependencies to latest secure versions
2. Fix any security vulnerabilities
3. Improve input validation and sanitization
4. Enhance authentication and authorization where applicable
5. Review and improve file permissions and access controls"
            ;;
    esac
    
    local expected_scope=""
    case "$INTENSITY" in
        "minimal") expected_scope="Small, focused changes with minimal risk";;
        "moderate") expected_scope="Moderate improvements with controlled impact";;
        "comprehensive") expected_scope="Significant enhancements with careful validation";;
    esac
    
    cat << EOF
On-Demand Evolution Cycle - $base_prompt

$intensity_modifier

Guidelines for this evolution:
- Maintain backward compatibility unless explicitly requested otherwise
- Follow Design for Failure (DFF) principles throughout
- Keep changes atomic and well-documented
- Update relevant documentation automatically
- Preserve existing functionality and APIs
- Focus on incremental, sustainable improvements
- Apply the principle: "Release Early and Often (REnO)"

Priority areas based on evolution type ($EVOLUTION_TYPE):
$priority_areas

Evolution intensity: $INTENSITY
Expected scope: $expected_scope
EOF
}

# Show dry run information
show_dry_run() {
    log "🔍 DRY RUN MODE - No changes will be made"
    echo ""
    echo "Evolution Configuration:"
    echo "  Type: $EVOLUTION_TYPE"
    echo "  Intensity: $INTENSITY"
    echo "  Growth Mode: $GROWTH_MODE"
    echo "  Auto Plant Seeds: $AUTO_PLANT"
    echo ""
    echo "Generated Prompt:"
    echo "────────────────────────────────────────────────────────────────"
    generate_prompt
    echo "────────────────────────────────────────────────────────────────"
    echo ""
    echo "Would execute:"
    echo "  gh workflow run ai_evolver.yml \\"
    echo "    -f prompt=\"<generated prompt>\" \\"
    echo "    -f growth_mode=\"$GROWTH_MODE\" \\"
    echo "    -f auto_plant_seeds=\"$AUTO_PLANT\""
    echo ""
    echo "To run for real, remove the --dry-run flag"
}

# Main execution function
main() {
    parse_args "$@"
    validate_args
    check_prerequisites
    
    # Show banner
    echo -e "${GREEN}"
    cat << 'EOF'
🌱 ═══════════════════════════════════════════════════════════════════ 🌱
║                   AI EVOLUTION ENGINE                                ║
║                  On-Demand Evolution Runner                          ║
🌱 ═══════════════════════════════════════════════════════════════════ 🌱
EOF
    echo -e "${NC}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        show_dry_run
        exit 0
    fi
    
    log "Starting evolution cycle..."
    verbose_log "Configuration: type=$EVOLUTION_TYPE, intensity=$INTENSITY, mode=$GROWTH_MODE"
    
    # Generate the evolution prompt
    local evolution_prompt
    evolution_prompt=$(generate_prompt)
    
    if [[ "$VERBOSE" == "true" ]]; then
        echo ""
        echo "Generated Evolution Prompt:"
        echo "────────────────────────────────────────────────────────────────"
        echo "$evolution_prompt"
        echo "────────────────────────────────────────────────────────────────"
        echo ""
    fi
    
    # Trigger the evolution workflow
    log "🚀 Triggering AI evolution workflow..."
    
    if gh workflow run ai_evolver.yml \
        -f prompt="$evolution_prompt" \
        -f growth_mode="$GROWTH_MODE" \
        -f auto_plant_seeds="$AUTO_PLANT"; then
        
        success "Evolution cycle initiated successfully!"
        echo ""
        log "📊 View progress: gh run list --workflow=ai_evolver.yml"
        log "📋 Watch logs: gh run watch"
        log "🌐 Web interface: gh repo view --web"
        echo ""
        log "🌱 Your repository is now evolving..."
        
    else
        error "Failed to trigger evolution workflow"
        echo "Check your GitHub CLI authentication and repository permissions"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
