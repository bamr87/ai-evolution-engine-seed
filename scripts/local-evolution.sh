#!/bin/bash

#############################################################################
# 🌱 AI Evolution Engine - Local Development Runner
# Version: 0.3.6-seed
# Purpose: Cross-platform script to run evolution cycles locally
#############################################################################

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/core/testing.sh"
source "$PROJECT_ROOT/src/lib/evolution/git.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

# Default values
USE_CONTAINER="false"
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
🌱 AI Evolution Engine - Local Development Runner

USAGE:
    ./scripts/local-evolution.sh [OPTIONS]

OPTIONS:
    -p, --prompt TEXT          Evolution prompt (required)
    -m, --mode MODE           Growth mode: conservative, adaptive, experimental
    -c, --container           Use containerized environment
    -d, --dry-run             Preview changes without applying them
    -n, --no-plant            Don't auto-plant seeds for next evolution
    -v, --verbose             Enable verbose output
    -h, --help                Show this help message

CONTAINER OPTIONS:
    --docker-build            Build container image before running
    --docker-clean            Clean up containers after run

EXAMPLES:
    # Basic evolution with prompt
    ./scripts/local-evolution.sh -p "Improve error handling"
    
    # Experimental mode with container
    ./scripts/local-evolution.sh -p "Add new feature" -m experimental -c
    
    # Dry run to preview changes
    ./scripts/local-evolution.sh -p "Refactor code" -d
    
    # Verbose mode for debugging
    ./scripts/local-evolution.sh -p "Update docs" -v

REQUIREMENTS:
    Local mode: bash, git, jq, gh (GitHub CLI)
    Container mode: docker, docker-compose
EOF
}

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

verbose_log() {
    if [ "$VERBOSE" = "true" ]; then
        echo -e "${CYAN}[DEBUG]${NC} $1"
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--prompt)
                PROMPT="$2"
                shift 2
                ;;
            -m|--mode)
                GROWTH_MODE="$2"
                shift 2
                ;;
            -c|--container)
                USE_CONTAINER="true"
                shift
                ;;
            -d|--dry-run)
                DRY_RUN="true"
                shift
                ;;
            -n|--no-plant)
                AUTO_PLANT="false"
                shift
                ;;
            -v|--verbose)
                VERBOSE="true"
                shift
                ;;
            --docker-build)
                DOCKER_BUILD="true"
                shift
                ;;
            --docker-clean)
                DOCKER_CLEAN="true"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Validate arguments
validate_args() {
    if [ -z "$PROMPT" ]; then
        error "Prompt is required. Use -p or --prompt to specify."
        exit 1
    fi

    case "$GROWTH_MODE" in
        conservative|adaptive|experimental)
            ;;
        *)
            error "Invalid growth mode: $GROWTH_MODE"
            error "Valid modes: conservative, adaptive, experimental"
            exit 1
            ;;
    esac
}

# Check prerequisites for local execution
check_local_prerequisites() {
    log "Checking local prerequisites..."
    
    local missing_tools=()
    
    for tool in bash git jq; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if ! command -v gh >/dev/null 2>&1; then
        warn "GitHub CLI (gh) not found. PR creation may fail."
        warn "Install from: https://cli.github.com/"
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        error "Missing required tools: ${missing_tools[*]}"
        error "Please install the missing tools and try again."
        exit 1
    fi
    
    success "Local prerequisites check passed"
}

# Check prerequisites for container execution
check_container_prerequisites() {
    log "Checking container prerequisites..."
    
    if ! command -v docker >/dev/null 2>&1; then
        error "Docker not found. Please install Docker to use container mode."
        exit 1
    fi
    
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        error "Docker Compose not found. Please install Docker Compose."
        exit 1
    fi
    
    success "Container prerequisites check passed"
}

# Run evolution in local environment
run_local_evolution() {
    log "Running evolution in local environment..."
    
    # Set environment variables
    export CI_ENVIRONMENT="false"
    export USE_CONTAINER="false"
    export PROMPT="$PROMPT"
    export GROWTH_MODE="$GROWTH_MODE"
    export AUTO_PLANT_SEEDS="$AUTO_PLANT"
    export DRY_RUN="$DRY_RUN"
    
    verbose_log "Environment configured:"
    verbose_log "  - Prompt: $PROMPT"
    verbose_log "  - Growth Mode: $GROWTH_MODE"
    verbose_log "  - Dry Run: $DRY_RUN"
    verbose_log "  - Auto Plant: $AUTO_PLANT"
    
    # Run the evolution steps
    log "🛠️  Setting up environment..."
    ./scripts/setup-environment.sh
    
    log "🔍 Validating prerequisites..."
    ./scripts/check-prereqs.sh "$GROWTH_MODE" "false"
    
    log "🧬 Collecting repository context..."
    ./scripts/collect-context.sh "$PROMPT" "$GROWTH_MODE" "/tmp/repo_context.json"
    
    log "🧠 Running AI simulation..."
    ./scripts/simulate-ai-growth.sh "$PROMPT" "$GROWTH_MODE" "/tmp/repo_context.json" "/tmp/evolution_response.json"
    
    if [ "$DRY_RUN" = "true" ]; then
        log "🔍 DRY RUN - Previewing changes..."
        if [ -f "/tmp/evolution_response.json" ]; then
            cat "/tmp/evolution_response.json" | jq -r '.changes[] | "\(.action): \(.path)"'
        fi
    else
        log "🌾 Applying changes..."
        ./scripts/apply-growth-changes.sh "/tmp/evolution_response.json"
        
        if [ "$AUTO_PLANT" = "true" ]; then
            log "🌰 Planting new seeds..."
            ./scripts/plant-new-seeds.sh "/tmp/evolution_response.json" "$AUTO_PLANT"
        fi
        
        log "🌳 Creating pull request..."
        ./scripts/create_pr.sh "/tmp/evolution_response.json" "$PROMPT" "$GROWTH_MODE"
    fi
    
    success "Evolution cycle completed!"
}

# Run evolution in container environment
run_container_evolution() {
    log "Running evolution in container environment..."
    
    local compose_file="docker/docker-compose.yml"
    
    if [ ! -f "$compose_file" ]; then
        error "Docker compose file not found: $compose_file"
        exit 1
    fi
    
    # Build container if requested
    if [ "${DOCKER_BUILD:-false}" = "true" ]; then
        log "Building container image..."
        docker-compose -f "$compose_file" build evolution-engine
    fi
    
    # Set environment variables for container
    export USE_CONTAINER="true"
    export CI_ENVIRONMENT="false"
    export PROMPT="$PROMPT"
    export GROWTH_MODE="$GROWTH_MODE"
    export AUTO_PLANT_SEEDS="$AUTO_PLANT"
    export DRY_RUN="$DRY_RUN"
    
    # Run evolution in container
    log "Starting evolution container..."
    docker-compose -f "$compose_file" run --rm evolution-engine bash -c "
        set -e
        echo '🌱 Running evolution in container...'
        ./scripts/setup-environment.sh
        ./scripts/check-prereqs.sh '$GROWTH_MODE' 'false'
        ./scripts/collect-context.sh '$PROMPT' '$GROWTH_MODE' '/tmp/repo_context.json'
        ./scripts/simulate-ai-growth.sh '$PROMPT' '$GROWTH_MODE' '/tmp/repo_context.json' '/tmp/evolution_response.json'
        
        if [ '$DRY_RUN' = 'true' ]; then
            echo '🔍 DRY RUN - Previewing changes...'
            cat '/tmp/evolution_response.json' | jq -r '.changes[] | \"\(.action): \(.path)\"' || true
        else
            ./scripts/apply-growth-changes.sh '/tmp/evolution_response.json'
            if [ '$AUTO_PLANT' = 'true' ]; then
                ./scripts/plant-new-seeds.sh '/tmp/evolution_response.json' '$AUTO_PLANT'
            fi
            ./scripts/create_pr.sh '/tmp/evolution_response.json' '$PROMPT' '$GROWTH_MODE'
        fi
        
        echo '✅ Container evolution completed!'
    "
    
    # Clean up if requested
    if [ "${DOCKER_CLEAN:-false}" = "true" ]; then
        log "Cleaning up containers..."
        docker-compose -f "$compose_file" down
    fi
    
    success "Container evolution completed!"
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║            AI EVOLUTION ENGINE - LOCAL RUNNER v0.3.0          ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    parse_args "$@"
    validate_args
    
    if [ "$USE_CONTAINER" = "true" ]; then
        check_container_prerequisites
        run_container_evolution
    else
        check_local_prerequisites
        run_local_evolution
    fi
    
    success "🌱 Evolution cycle completed successfully!"
    log "Check the created pull request for review and merge."
}

# Run main function with all arguments
main "$@"
