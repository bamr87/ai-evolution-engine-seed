#!/bin/bash
#
# @file scripts/setup.sh
# @description Consolidated setup script for AI Evolution Engine
# @author AI Evolution Engine Team
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 3.0.0
#
# @relatedIssues 
#   - Repository cleanup and refactoring
#
# @relatedEvolutions
#   - v3.0.0: Consolidated setup script combining multiple setup scripts
#
# @dependencies
#   - bash: >=4.0
#   - git: Version control
#
# @changelog
#   - 2025-07-12: Initial creation of consolidated setup script - AEE
#
# @usage ./scripts/setup.sh [options]
# @notes Sets up environment and dependencies for AI Evolution Engine
#

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Default values
INSTALL_DEPENDENCIES="true"
CHECK_PREREQUISITES="true"
SETUP_GIT="true"
VERBOSE="false"
DRY_RUN="false"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Show help message
show_help() {
    cat << EOF
🔧 AI Evolution Engine - Setup Script

DESCRIPTION:
    Sets up the environment and dependencies for the AI Evolution Engine.
    Installs required tools, configures git, and validates prerequisites.

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --no-deps              Skip dependency installation
    --no-prereqs           Skip prerequisite checks
    --no-git               Skip git configuration
    -v, --verbose          Enable verbose output
    -d, --dry-run          Show what would be done without executing
    -h, --help             Show this help message

EXAMPLES:
    # Full setup
    $0

    # Setup without installing dependencies
    $0 --no-deps

    # Dry run to see what would be done
    $0 --dry-run

SETUP FEATURES:
    ✅ Dependency installation (jq, git, curl)
    ✅ Prerequisite validation
    ✅ Git configuration
    ✅ Script permissions setup
    ✅ Directory structure validation
    ✅ Cross-platform compatibility

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-deps)
                INSTALL_DEPENDENCIES="false"
                shift
                ;;
            --no-prereqs)
                CHECK_PREREQUISITES="false"
                shift
                ;;
            --no-git)
                SETUP_GIT="false"
                shift
                ;;
            -v|--verbose)
                VERBOSE="true"
                shift
                ;;
            -d|--dry-run)
                DRY_RUN="true"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies
install_dependencies() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would install dependencies..."
        return 0
    fi
    
    log_info "Installing dependencies..."
    
    local os=$(detect_os)
    local install_errors=0
    
    case "$os" in
        "linux")
            # Ubuntu/Debian
            if command_exists apt-get; then
                log_info "Installing dependencies via apt-get..."
                sudo apt-get update -qq
                sudo apt-get install -y -qq jq curl git tree
            # CentOS/RHEL
            elif command_exists yum; then
                log_info "Installing dependencies via yum..."
                sudo yum install -y jq curl git tree
            # Arch Linux
            elif command_exists pacman; then
                log_info "Installing dependencies via pacman..."
                sudo pacman -S --noconfirm jq curl git tree
            else
                log_error "No supported package manager found"
                ((install_errors++))
            fi
            ;;
        "macos")
            log_info "Installing dependencies via Homebrew..."
            if command_exists brew; then
                brew install jq curl git tree
            else
                log_error "Homebrew not found. Install from https://brew.sh/"
                ((install_errors++))
            fi
            ;;
        "windows")
            log_warning "Windows detected - please install dependencies manually:"
            log_warning "  - jq: https://stedolan.github.io/jq/download/"
            log_warning "  - git: https://git-scm.com/download/win"
            log_warning "  - curl: https://curl.se/windows/"
            ;;
        *)
            log_error "Unsupported operating system: $os"
            ((install_errors++))
            ;;
    esac
    
    if [[ $install_errors -eq 0 ]]; then
        log_success "Dependencies installed successfully"
    else
        log_error "Failed to install some dependencies"
        return 1
    fi
}

# Check prerequisites
check_prerequisites() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would check prerequisites..."
        return 0
    fi
    
    log_info "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check required commands
    local required_commands=("git" "jq" "curl")
    for cmd in "${required_commands[@]}"; do
        if command_exists "$cmd"; then
            log_success "✅ $cmd is available"
        else
            log_error "❌ $cmd is not available"
            missing_deps+=("$cmd")
        fi
    done
    
    # Check bash version
    local bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    if [[ -n "$bash_version" ]]; then
        log_success "✅ Bash version: $bash_version"
    else
        log_warning "⚠️  Could not determine bash version"
    fi
    
    # Check if we're in a git repository
    if git rev-parse --git-dir >/dev/null 2>&1; then
        log_success "✅ Git repository detected"
    else
        log_warning "⚠️  Not in a git repository"
    fi
    
    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        log_success "All prerequisites satisfied"
        return 0
    else
        log_error "Missing dependencies: ${missing_deps[*]}"
        return 1
    fi
}

# Setup git configuration
setup_git() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would configure git..."
        return 0
    fi
    
    log_info "Configuring git..."
    
    # Set git user if not configured
    if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
        log_info "Setting git user name..."
        git config --global user.name "AI Evolution Engine"
    fi
    
    if [[ -z "$(git config --global user.email 2>/dev/null)" ]]; then
        log_info "Setting git user email..."
        git config --global user.email "ai-evolution@engine.dev"
    fi
    
    # Configure git for better workflow
    git config --global pull.rebase false
    git config --global init.defaultBranch main
    
    log_success "Git configuration completed"
}

# Setup script permissions
setup_permissions() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would set script permissions..."
        return 0
    fi
    
    log_info "Setting script permissions..."
    
    # Make all scripts executable
    find "$PROJECT_ROOT/scripts" -name "*.sh" -type f -exec chmod +x {} \;
    find "$PROJECT_ROOT/src" -name "*.sh" -type f -exec chmod +x {} \;
    
    log_success "Script permissions set"
}

# Create required directories
create_directories() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would create required directories..."
        return 0
    fi
    
    log_info "Creating required directories..."
    
    local required_dirs=("logs" "evolution-output" "tests/results" "tests/logs")
    
    for dir in "${required_dirs[@]}"; do
        local full_path="$PROJECT_ROOT/$dir"
        if [[ ! -d "$full_path" ]]; then
            mkdir -p "$full_path"
            log_info "Created directory: $dir"
        else
            log_info "Directory exists: $dir"
        fi
    done
    
    log_success "Required directories created"
}

# Validate setup
validate_setup() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Would validate setup..."
        return 0
    fi
    
    log_info "Validating setup..."
    
    local validation_errors=0
    
    # Check if main script is executable
    if [[ -x "$PROJECT_ROOT/scripts/evolve.sh" ]]; then
        log_success "✅ evolve.sh is executable"
    else
        log_error "❌ evolve.sh is not executable"
        ((validation_errors++))
    fi
    
    # Check if required directories exist
    local required_dirs=("logs" "scripts" "src")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PROJECT_ROOT/$dir" ]]; then
            log_success "✅ $dir directory exists"
        else
            log_error "❌ $dir directory missing"
            ((validation_errors++))
        fi
    done
    
    # Check if essential files exist
    local essential_files=("README.md" "scripts/evolve.sh")
    for file in "${essential_files[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            log_success "✅ $file exists"
        else
            log_error "❌ $file missing"
            ((validation_errors++))
        fi
    done
    
    if [[ $validation_errors -eq 0 ]]; then
        log_success "Setup validation passed"
        return 0
    else
        log_error "Setup validation failed with $validation_errors errors"
        return 1
    fi
}

# Main setup function
main() {
    log_info "🔧 AI Evolution Engine Setup v3.0.0"
    log_info "OS: $(detect_os)"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No changes will be made"
    fi
    
    # Install dependencies
    if [[ "$INSTALL_DEPENDENCIES" == "true" ]]; then
        install_dependencies
    fi
    
    # Check prerequisites
    if [[ "$CHECK_PREREQUISITES" == "true" ]]; then
        check_prerequisites
    fi
    
    # Setup git
    if [[ "$SETUP_GIT" == "true" ]]; then
        setup_git
    fi
    
    # Setup permissions
    setup_permissions
    
    # Create directories
    create_directories
    
    # Validate setup
    validate_setup
    
    log_success "🎉 Setup completed successfully!"
    log_info "You can now run: ./scripts/evolve.sh --help"
}

# Parse arguments and execute
parse_arguments "$@"
main "$@" 