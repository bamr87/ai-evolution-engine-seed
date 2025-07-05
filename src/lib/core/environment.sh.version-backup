#!/bin/bash
# Environment validation and setup library
# Provides consistent environment checking across all scripts
# Version: 1.0.0

# Source the logger
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/logger.sh"

# Environment detection
detect_os() {
    case "$OSTYPE" in
        "linux-gnu"*) echo "linux" ;;
        "darwin"*) echo "macos" ;;
        "cygwin") echo "windows" ;;
        "msys") echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

detect_ci_environment() {
    if [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ -n "${TRAVIS:-}" ]] || [[ -n "${CIRCLECI:-}" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Command checking utilities
check_command() {
    local cmd="$1"
    local name="${2:-$cmd}"
    local required="${3:-true}"
    local install_hint="${4:-}"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        log_success "$name is available"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log_error "$name is required but not installed"
            [[ -n "$install_hint" ]] && log_info "Install hint: $install_hint"
            return 1
        else
            log_warn "$name is not installed (optional)"
            [[ -n "$install_hint" ]] && log_info "Install hint: $install_hint"
            return 0
        fi
    fi
}

# File permission checking
check_file_permissions() {
    local file="$1"
    local description="${2:-$file}"
    
    if [[ ! -f "$file" ]]; then
        log_error "$description does not exist"
        return 1
    fi
    
    if [[ ! -x "$file" ]]; then
        log_warn "$description is not executable - fixing permissions"
        chmod +x "$file"
        log_success "Fixed permissions for $description"
    else
        log_success "$description has correct permissions"
    fi
    
    return 0
}

# Environment variable validation
validate_env_var() {
    local var_name="$1"
    local required="${2:-false}"
    local description="${3:-$var_name}"
    
    if [[ -n "${!var_name:-}" ]]; then
        log_success "$description is set"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log_error "$description is required but not set"
            return 1
        else
            log_warn "$description is not set (optional)"
            return 0
        fi
    fi
}

# GitHub CLI authentication
setup_github_auth() {
    local token_var="${1:-GITHUB_TOKEN}"
    
    log_info "Setting up GitHub CLI authentication..."
    
    # Check if already authenticated
    if gh auth status >/dev/null 2>&1; then
        log_success "GitHub CLI is already authenticated"
        return 0
    fi
    
    # Try token authentication
    if [[ -n "${!token_var:-}" ]]; then
        log_info "Authenticating with token from $token_var"
        echo "${!token_var}" | gh auth login --with-token
        if gh auth status >/dev/null 2>&1; then
            log_success "GitHub CLI authentication successful"
            return 0
        fi
    fi
    
    # Fallback for local development
    if [[ "$(detect_ci_environment)" == "false" ]]; then
        log_warn "No valid token found. Please run: gh auth login"
        return 1
    fi
    
    log_error "GitHub CLI authentication failed"
    return 1
}

# Install dependencies based on OS and environment
install_dependencies() {
    local os=$(detect_os)
    local ci_env=$(detect_ci_environment)
    
    log_info "Installing dependencies for $os (CI: $ci_env)"
    
    case "$os" in
        "linux")
            if [[ "$ci_env" == "true" ]]; then
                # CI environment - use apt
                export DEBIAN_FRONTEND=noninteractive
                apt-get update -qq
                apt-get install -y -qq jq curl git gh yq tree
            else
                # Local Linux development
                if command -v apt-get >/dev/null 2>&1; then
                    sudo apt-get update
                    sudo apt-get install -y jq curl git tree
                    # Install gh and yq separately if needed
                    install_gh_linux
                    install_yq_linux
                elif command -v yum >/dev/null 2>&1; then
                    sudo yum install -y jq curl git tree
                    install_gh_linux
                    install_yq_linux
                fi
            fi
            ;;
        "macos")
            if command -v brew >/dev/null 2>&1; then
                brew install jq curl git gh yq tree
            else
                log_warn "Homebrew not found. Please install manually or install Homebrew first."
                return 1
            fi
            ;;
        *)
            log_warn "Unsupported OS: $os. Please install dependencies manually."
            return 1
            ;;
    esac
}

# Helper functions for specific tools
install_gh_linux() {
    if ! command -v gh >/dev/null 2>&1; then
        log_info "Installing GitHub CLI..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
    fi
}

install_yq_linux() {
    if ! command -v yq >/dev/null 2>&1; then
        log_info "Installing yq..."
        if command -v wget >/dev/null 2>&1; then
            sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        elif command -v curl >/dev/null 2>&1; then
            sudo curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq
        fi
        sudo chmod +x /usr/local/bin/yq
    fi
}

# Initialize environment configuration
init_environment_config() {
    local ci_env="${1:-$(detect_ci_environment)}"
    
    # Set CI environment
    export CI_ENVIRONMENT="$ci_env"
    
    # Configure colors based on environment
    if [[ "$CI_ENVIRONMENT" == "true" ]]; then
        # Disable colors in CI environment
        export RED=''
        export GREEN=''
        export YELLOW=''
        export BLUE=''
        export PURPLE=''
        export CYAN=''
        export NC=''
        
        # Set CI-friendly symbols
        export CHECK_MARK="[OK]"
        export CROSS_MARK="[FAIL]"
        export WARNING="[WARN]"
        export INFO="[INFO]"
    else
        # Enable colors for local development
        export RED='\033[0;31m'
        export GREEN='\033[0;32m'
        export YELLOW='\033[1;33m'
        export BLUE='\033[0;34m'
        export PURPLE='\033[0;35m'
        export CYAN='\033[0;36m'
        export NC='\033[0m'
        
        # Set Unicode symbols
        export CHECK_MARK="✅"
        export CROSS_MARK="❌"
        export WARNING="⚠️"
        export INFO="ℹ️"
    fi
}

# Full environment validation
validate_environment() {
    local failed=0
    
    log_info "Validating environment..."
    
    # Core tools
    check_command "git" "Git" "true" "https://git-scm.com/" || ((failed++))
    check_command "jq" "jq" "true" "apt-get install jq or brew install jq" || ((failed++))
    check_command "curl" "curl" "true" "Built into most systems" || ((failed++))
    
    # Optional but recommended
    check_command "gh" "GitHub CLI" "false" "https://cli.github.com/"
    check_command "yq" "yq" "false" "https://github.com/mikefarah/yq"
    check_command "tree" "tree" "false" "apt-get install tree or brew install tree"
    
    # Environment variables
    validate_env_var "GITHUB_WORKSPACE" "false" "GitHub Workspace"
    validate_env_var "GITHUB_TOKEN" "false" "GitHub Token"
    validate_env_var "CI_ENVIRONMENT" "false" "CI Environment Flag"
    
    if [[ $failed -gt 0 ]]; then
        log_error "$failed required dependencies are missing"
        return 1
    else
        log_success "Environment validation passed"
        return 0
    fi
}
