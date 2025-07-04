#!/bin/bash
# scripts/setup-environment.sh
# Sets up the necessary environment for evolution workflows
# Supports both CI/CD environments and local development

set -euo pipefail

# Detect environment
CI_ENVIRONMENT="${CI_ENVIRONMENT:-false}"
USE_CONTAINER="${USE_CONTAINER:-false}"

echo "🌱 Setting up evolution environment..."
echo "  - CI Environment: $CI_ENVIRONMENT"
echo "  - Container Mode: $USE_CONTAINER"

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install dependencies based on environment
install_dependencies() {
    local os=$(detect_os)
    
    echo "📦 Installing dependencies for $os..."
    
    if [ "$CI_ENVIRONMENT" = "true" ]; then
        # CI environment - use package manager available
        if command -v apt-get >/dev/null 2>&1; then
            # Ubuntu/Debian CI
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -qq
            apt-get install -y -qq jq tree curl git gh
        elif command -v yum >/dev/null 2>&1; then
            # RHEL/CentOS CI
            yum install -y jq tree curl git
        elif command -v brew >/dev/null 2>&1; then
            # macOS CI (rare but possible)
            brew install jq tree gh
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
                    sudo apt-get install -y jq tree curl
                elif command -v yum >/dev/null 2>&1; then
                    sudo yum install -y jq tree curl
                elif command -v pacman >/dev/null 2>&1; then
                    sudo pacman -S jq tree curl
                else
                    echo "⚠️  Package manager not detected. Please install jq, tree, curl manually"
                fi
                ;;
            "windows")
                echo "⚠️  Windows detected. Please ensure WSL2 or use Git Bash with manual tool installation"
                ;;
            *)
                echo "⚠️  Unknown OS. Please install jq, tree, curl manually"
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
