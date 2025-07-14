#!/bin/bash
#
# @file scripts/setup-environment.sh
# @description Sets up the necessary environment for evolution workflows using modular architecture
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-12
# @version 2.1.0
#
# @relatedIssues 
#   - Modular refactoring: Migrate to modular architecture
#   - Environment setup: Enhanced environment configuration
#   - #v0.4.6-compatibility: Enhanced GitHub Actions compatibility
#
# @relatedEvolutions
#   - v2.1.0: Enhanced GitHub Actions compatibility with improved dependency management for v0.4.6
#   - v2.0.0: Migrated to modular architecture with enhanced setup
#   - v1.0.0: Original implementation
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../src/lib/core/environment.sh: Environment detection module
#
# @changelog
#   - 2025-07-12: Enhanced GitHub Actions compatibility with improved dependency management for v0.4.6 - ITJ
#   - 2025-07-10: Fixed CI permission issue by adding sudo for package management - ITJ
#   - 2025-07-10: Fixed syntax error by removing orphaned duplicate code - ITJ
#   - 2025-07-07: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced environment setup logic - ITJ
#
# @usage ./scripts/setup-environment.sh
# @notes Supports both CI/CD environments and local development
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/environment"
require_module "core/validation"

# Initialize logging
init_logger "logs" "setup-environment"

# Detect environment
CI_ENVIRONMENT="${CI_ENVIRONMENT:-false}"
USE_CONTAINER="${USE_CONTAINER:-false}"

log_info "Setting up evolution environment..."
log_info "CI Environment: $CI_ENVIRONMENT"
log_info "Container Mode: $USE_CONTAINER"

# Function to install dependencies based on environment
install_dependencies() {
    local os=$(detect_os)
    
    log_info "Installing dependencies for $os..."
    
    if [[ "$CI_ENVIRONMENT" == "true" ]]; then
        # CI environment - use package manager available
        if command -v apt-get >/dev/null 2>&1; then
            # Ubuntu/Debian CI
            export DEBIAN_FRONTEND=noninteractive
            sudo apt-get update -qq || {
                log_warn "apt-get update failed, retrying..."
                sleep 2
                sudo apt-get update -qq
            }
            sudo apt-get install -y -qq jq tree curl git gh || {
                log_warn "Some packages failed to install, continuing..."
            }
        elif command -v yum >/dev/null 2>&1; then
            # RHEL/CentOS CI
            sudo yum install -y jq tree curl git || {
                log_warn "Some packages failed to install, continuing..."
            }
        elif command -v brew >/dev/null 2>&1; then
            # macOS CI (rare but possible)
            brew install jq tree gh || {
                log_warn "Some packages failed to install, continuing..."
            }
        fi
    else
        # Local development environment
        case "$os" in
            "macos")
                if command -v brew >/dev/null 2>&1; then
                    brew install jq tree gh || echo "⚠️  Brew install failed, trying alternatives..."
                else
                    echo "⚠️  Homebrew not found. Please install: https://brew.sh/"
                fi
                ;;
            "linux")
                if command -v apt-get >/dev/null 2>&1; then
                    sudo apt-get update
                    sudo apt-get install -y jq tree curl git
                elif command -v yum >/dev/null 2>&1; then
                    sudo yum install -y jq tree curl git
                elif command -v pacman >/dev/null 2>&1; then
                    sudo pacman -S --noconfirm jq tree curl git
                fi
                ;;
            *)
                log_warn "Unknown OS: $os, manual dependency installation may be required"
                ;;
        esac
    fi
    
    # Verify essential tools are available
    for tool in jq git curl; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            echo "❌ $tool not found after installation attempt"
            if [ "$CI_ENVIRONMENT" = "true" ]; then
                exit 1
            else
                echo "   Please install $tool manually"
            fi
        else
            echo "✅ $tool is available"
        fi
    done
}

# Function to setup GitHub CLI authentication
setup_github_auth() {
    echo "🔐 Setting up GitHub authentication..."
    
    if [ "$CI_ENVIRONMENT" = "true" ]; then
        # In CI, authentication should be handled via environment variables
        if [ -n "${GH_TOKEN:-}" ] || [ -n "${PAT_TOKEN:-}" ]; then
            export GH_TOKEN="${PAT_TOKEN:-$GH_TOKEN}"
            echo "✅ GitHub token configured from environment"
        else
            echo "⚠️  No GitHub token found in environment variables"
            echo "   Please set PAT_TOKEN or GH_TOKEN secret"
        fi
    else
        # Local development - check if already authenticated
        if command -v gh >/dev/null 2>&1; then
            if gh auth status >/dev/null 2>&1; then
                echo "✅ GitHub CLI already authenticated"
            else
                echo "⚠️  GitHub CLI not authenticated"
                echo "   Run: gh auth login"
            fi
        else
            echo "⚠️  GitHub CLI not installed"
        fi
    fi
}

# Install dependencies
install_dependencies

# Setup GitHub authentication
setup_github_auth

# Validate required files exist
echo "🔍 Validating required files..."
if [ ! -f "evolution-metrics.json" ]; then
    echo "⚠️  evolution-metrics.json not found, creating default..."
    cat > evolution-metrics.json << 'EOF'
{
  "seed_version": "0.3.0",
  "growth_cycles": 0,
  "current_generation": 0,
  "adaptations_logged": 0,
  "last_growth_spurt": "Never",
  "last_prompt": null,
  "evolution_history": [],
  "environment": {
    "ci_mode": false,
    "container_mode": false,
    "last_setup": ""
  }
}
EOF
fi

# Update environment info in metrics
if command -v jq >/dev/null 2>&1; then
    jq --arg ci "$CI_ENVIRONMENT" \
       --arg container "$USE_CONTAINER" \
       --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       '.environment.ci_mode = ($ci == "true") | 
        .environment.container_mode = ($container == "true") | 
        .environment.last_setup = $timestamp' \
       evolution-metrics.json > evolution-metrics.json.tmp && \
       mv evolution-metrics.json.tmp evolution-metrics.json
fi

# Ensure scripts are executable
echo "🔧 Setting script permissions..."
find ./scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Set git configuration for CI if needed
if [ "$CI_ENVIRONMENT" = "true" ]; then
    echo "⚙️  Configuring git for CI environment..."
    git config --global --add safe.directory "${GITHUB_WORKSPACE:-$(pwd)}"
    if [ -z "$(git config --global user.name 2>/dev/null || true)" ]; then
        git config --global user.name "AI Evolution Engine"
    fi
    if [ -z "$(git config --global user.email 2>/dev/null || true)" ]; then
        git config --global user.email "ai-evolution@users.noreply.github.com"
    fi
fi

echo "✅ Environment setup complete"
echo "  - Working directory: $(pwd)"
echo "  - Git configured: $(git config user.name 2>/dev/null || echo 'Not set')"
echo "  - Environment ready for evolution cycles"
