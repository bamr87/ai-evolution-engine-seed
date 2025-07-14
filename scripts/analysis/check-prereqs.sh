#!/bin/bash

# 🌱 AI Evolution Engine: Prerequisite Checker
# Version: v2.0.0 - Modular Architecture
# Description: Validates environment setup for the AI Evolution Engine
# Supports both CI/CD and local development environments

# Note: Removed set -e to allow better error handling

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Import modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"

# Input parameters
GROWTH_MODE="${1:-adaptive}"
CI_ENVIRONMENT="${2:-${CI_ENVIRONMENT:-false}}"

# Initialize environment and logging
init_environment_config "$CI_ENVIRONMENT"
init_logger "logs" "check-prereqs"

# Global status tracking
PREREQ_FAILED=0
WARNINGS=0

# Display banner using modular logger
log_info "🌱 AI Evolution Engine Prerequisite Checker"
log_info "Version: v2.0.0 - Modular Architecture"
log_info "Environment: $(if [[ "$CI_ENVIRONMENT" == "true" ]]; then echo "CI/CD Pipeline"; else echo "Local Development"; fi)"
log_info "Growth Mode: $GROWTH_MODE"

print_status() {
    local status=$1
    local message=$2
    local details=$3
    
    case "$status" in
        "pass")
            log_success "$message"
            [[ -n "$details" ]] && log_debug "   $details"
            ;;
        "fail")
            log_error "$message"
            [[ -n "$details" ]] && log_error "   $details"
            PREREQ_FAILED=1
            ;;
        "warn")
            log_warn "$message"
            [[ -n "$details" ]] && log_warn "   $details"
            WARNINGS=$((WARNINGS + 1))
            ;;
        *)
            log_info "$message"
            [[ -n "$details" ]] && log_debug "   $details"
            ;;
    esac
}

check_command() {
    local cmd=$1
    local friendly_name=$2
    local required=$3
    local install_hint=$4
    
    if command -v "$cmd" >/dev/null 2>&1; then
        # Use timeout to prevent hanging on version commands
        local version=$(timeout 3 "$cmd" --version 2>/dev/null | head -n1 || echo "Version unknown")
        print_status "pass" "$friendly_name is installed" "$version"
        return 0
    else
        if [ "$required" = "true" ]; then
            print_status "fail" "$friendly_name is not installed" "$install_hint"
            PREREQ_FAILED=1
            return 1
        else
            print_status "warn" "$friendly_name is not installed (optional)" "$install_hint"
            WARNINGS=$((WARNINGS + 1))
            return 0
        fi
    fi
}

check_git_config() {
    local config_key=$1
    local friendly_name=$2
    
    local value=$(git config --global "$config_key" 2>/dev/null || echo "")
    if [ -n "$value" ]; then
        print_status "pass" "Git $friendly_name is configured" "$config_key = $value"
        return 0
    else
        print_status "warn" "Git $friendly_name is not configured" "Run: git config --global $config_key \"your-value\""
        return 0
    fi
}

check_file_permissions() {
    local file=$1
    local friendly_name=$2
    
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            print_status "pass" "$friendly_name is executable"
            return 0
        else
            print_status "warn" "$friendly_name exists but is not executable" "Run: chmod +x $file"
            return 0
        fi
    else
        print_status "info" "$friendly_name does not exist yet" "Will be created during setup"
        return 0
    fi
}

echo -e "\n${PURPLE}🔍 Checking Core Prerequisites...${NC}"

# Check essential commands
check_command "git" "Git" "true" "Install from: https://git-scm.com/"
check_command "bash" "Bash" "true" "Should be available on most systems"
check_command "curl" "cURL" "true" "Install via package manager (brew, apt, yum, etc.)"

echo -e "\n${PURPLE}🔍 Checking GitHub Integration...${NC}"

# Check GitHub CLI
check_command "gh" "GitHub CLI" "true" "Install from: https://cli.github.com/"

# Check if GitHub CLI is authenticated (context-aware)
if command -v gh >/dev/null 2>&1; then
    if [ "$CI_ENVIRONMENT" = "true" ]; then
        # In CI, check for token availability (multiple possible token variables)
        if [ -n "${GH_TOKEN:-}" ] || [ -n "${PAT_TOKEN:-}" ] || [ -n "${GITHUB_TOKEN:-}" ]; then
            token_source=""
            if [ -n "${GH_TOKEN:-}" ]; then
                token_source="GH_TOKEN"
            elif [ -n "${PAT_TOKEN:-}" ]; then
                token_source="PAT_TOKEN"
            elif [ -n "${GITHUB_TOKEN:-}" ]; then
                token_source="GITHUB_TOKEN"
            fi
            print_status "pass" "GitHub authentication configured" "Token available in environment ($token_source)"
        else
            print_status "fail" "GitHub authentication not configured" "Set GH_TOKEN, PAT_TOKEN, or GITHUB_TOKEN secret"
        fi
    else
        # Local development - check auth status
        if gh auth status >/dev/null 2>&1; then
            gh_user=$(gh api user --jq '.login' 2>/dev/null || echo "Unknown")
            print_status "pass" "GitHub CLI is authenticated" "Logged in as: $gh_user"
        else
            print_status "fail" "GitHub CLI is not authenticated" "Run: gh auth login"
        fi
    fi
else
    print_status "fail" "GitHub CLI not available" "Required for PR creation"
fi

echo -e "\n${PURPLE}🔍 Checking Git Configuration...${NC}"

check_git_config "user.name" "username"
check_git_config "user.email" "email"

# Check if we're in a git repository
if git rev-parse --git-dir >/dev/null 2>&1; then
    print_status "pass" "Current directory is a Git repository"
    
    # Check for remote origin
    if git remote get-url origin >/dev/null 2>&1; then
        origin_url=$(git remote get-url origin)
        print_status "pass" "Git remote 'origin' is configured" "$origin_url"
    else
        print_status "warn" "Git remote 'origin' is not configured" "You may need to set up a GitHub repository"
    fi
else
    print_status "warn" "Current directory is not a Git repository" "Run: git init"
fi

echo -e "\n${PURPLE}🔍 Checking Development Tools...${NC}"

# Check optional but useful tools
check_command "jq" "jq (JSON processor)" "false" "Install via package manager: brew install jq / apt install jq"
check_command "code" "VS Code CLI" "false" "Install VS Code and enable shell command"
check_command "node" "Node.js" "false" "Install from: https://nodejs.org/ (useful for future features)"
check_command "python3" "Python 3" "false" "Install from: https://python.org/ (useful for AI integrations)"

echo -e "\n${PURPLE}🔍 Checking File Permissions...${NC}"

check_file_permissions "./init_setup.sh" "Initialization script"
check_file_permissions "./scripts/check-prereqs.sh" "This prerequisite checker"

echo -e "\n${PURPLE}🔍 Checking Environment Variables...${NC}"

# Check for AI API key (environment-aware)
if [ "$CI_ENVIRONMENT" = "true" ]; then
    print_status "info" "AI API integration" "Using simulated AI for CI pipeline"
else
    if [ -n "${AI_API_KEY:-}" ]; then
        print_status "pass" "AI_API_KEY environment variable is set" "Value: ${AI_API_KEY:0:8}..."
    else
        print_status "info" "AI_API_KEY environment variable is not set" "Using simulated AI (v0.3.0)"
    fi
fi

# Check shell
current_shell=$(basename "$SHELL" 2>/dev/null || echo "unknown")
print_status "info" "Current shell detected" "$current_shell"

# Check container environment
if [ -n "${KUBERNETES_SERVICE_HOST:-}" ] || [ -f "/.dockerenv" ]; then
    print_status "info" "Container environment detected" "Running in containerized environment"
elif [ "$CI_ENVIRONMENT" = "true" ]; then
    print_status "info" "CI environment detected" "GitHub Actions runner"
fi

echo -e "\n${PURPLE}🔍 System Information...${NC}"

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    os_version=$(sw_vers -productVersion 2>/dev/null || echo "Unknown")
    print_status "info" "Operating System: macOS" "Version: $os_version"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_status "info" "Operating System: Linux" "Distribution: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    print_status "info" "Operating System: Windows" "Running in: $OSTYPE"
else
    print_status "info" "Operating System: Unknown" "Type: $OSTYPE"
fi

echo -e "\n${BLUE}════════════════════════════════════════════════════════════════${NC}"

# Final summary
if [ $PREREQ_FAILED -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}🌱 All prerequisites are met! You're ready to plant the seed.${NC}"
        echo -e "${GREEN}   Run: ${YELLOW}bash init_setup.sh${GREEN} to get started.${NC}"
    else
        echo -e "${YELLOW}🌿 Core prerequisites are met with $WARNINGS warnings.${NC}"
        echo -e "${YELLOW}   You can proceed, but consider addressing the warnings above.${NC}"
        echo -e "${GREEN}   Run: ${YELLOW}bash init_setup.sh${GREEN} to get started.${NC}"
    fi
    exit 0
else
    echo -e "${RED}💀 Some required prerequisites are missing.${NC}"
    echo -e "${RED}   Please install the required tools above before proceeding.${NC}"
    exit 1
fi
