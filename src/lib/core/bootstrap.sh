#!/bin/bash
#
# @file src/lib/core/bootstrap.sh
# @description Library initialization and dependency management for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular refactor with bootstrap system
#
# @dependencies
#   - bash: >=4.0
#   - find: POSIX compliant
#
# @changelog
#   - 2025-07-05: Initial creation of bootstrap system - ITJ
#
# @usage source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"; bootstrap_library
# @notes This module must be sourced before any other library modules
#

set -euo pipefail

# Bootstrap constants
# Check bash version and set compatibility mode
check_bash_version() {
    local bash_version
    bash_version=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' || echo "3.2")
    
    local major_version
    major_version=$(echo "$bash_version" | cut -d. -f1)
    
    if [[ $major_version -ge 4 ]]; then
        BASH_VERSION_MODERN=true
        echo "Bash version $bash_version detected - using modern features" >&2
    else
        BASH_VERSION_MODERN=false
        echo "Bash version $bash_version detected - using compatibility mode" >&2
    fi
    
    return 0
}

# Initialize bash version check
check_bash_version

readonly BOOTSTRAP_VERSION="2.0.0"
readonly MIN_BASH_VERSION="3.2"
readonly LIBRARY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PROJECT_ROOT="$(cd "$LIBRARY_ROOT/../.." && pwd)"

# Global state tracking - compatible with bash 3.2+
if [[ "$BASH_VERSION_MODERN" == "true" ]]; then
    # Modern bash (4+) with associative arrays
    declare -A LOADED_MODULES
    declare -A MODULE_VERSIONS
else
    # Legacy bash (3.2+) with simple variables
    LOADED_MODULES_LIST=""
    MODULE_VERSIONS_LIST=""
fi

BOOTSTRAP_INITIALIZED=false
LIBRARY_DEBUG=${LIBRARY_DEBUG:-false}

# Bootstrap error handling
bootstrap_error() {
    echo "🚨 BOOTSTRAP ERROR: $1" >&2
    echo "📍 Location: ${BASH_SOURCE[1]:-unknown}:${BASH_LINENO[0]:-unknown}" >&2
    echo "🔧 Debug info: Bootstrap v$BOOTSTRAP_VERSION" >&2
    exit 1
}

# Bootstrap info logging
bootstrap_info() {
    if [[ "$LIBRARY_DEBUG" == "true" ]]; then
        echo "🌱 BOOTSTRAP: $1" >&2
    fi
}

# Check bash version compatibility
check_bash_version() {
    local bash_version
    bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    
    if [[ -z "$bash_version" ]]; then
        bootstrap_error "Unable to determine bash version"
    fi
    
    # Simple version comparison (assumes X.Y format)
    local major minor required_major required_minor
    IFS='.' read -r major minor <<< "$bash_version"
    IFS='.' read -r required_major required_minor <<< "$MIN_BASH_VERSION"
    
    if [[ "$major" -lt "$required_major" ]] || 
       [[ "$major" -eq "$required_major" && "$minor" -lt "$required_minor" ]]; then
        bootstrap_error "Bash $MIN_BASH_VERSION+ required, found $bash_version"
    fi
    
    bootstrap_info "Bash version $bash_version is compatible"
}

# Validate library structure
validate_library_structure() {
    local core_modules=(
        "core/logger.sh"
        "core/environment.sh" 
        "core/config.sh"
        "core/utils.sh"
        "core/validation.sh"
        "core/testing.sh"
    )
    
    for module in "${core_modules[@]}"; do
        local module_path="$LIBRARY_ROOT/$module"
        if [[ ! -f "$module_path" ]]; then
            bootstrap_error "Required core module missing: $module"
        fi
    done
    
    bootstrap_info "Library structure validation passed"
}

# Load a specific module
# Args:
#   $1: module_path (relative to lib directory, e.g., "core/logger")
# Returns:
#   0: success
#   1: failure
# Compatibility functions for module tracking
is_module_loaded() {
    local module_path="$1"
    
    if [[ "$BASH_VERSION_MODERN" == "true" ]]; then
        [[ -n "${LOADED_MODULES[$module_path]:-}" ]]
    else
        echo "$LOADED_MODULES_LIST" | grep -q ":$module_path:"
    fi
}

mark_module_loaded() {
    local module_path="$1"
    local version="${2:-unknown}"
    
    if [[ "$BASH_VERSION_MODERN" == "true" ]]; then
        LOADED_MODULES[$module_path]="loaded"
        MODULE_VERSIONS[$module_path]="$version"
    else
        LOADED_MODULES_LIST="$LOADED_MODULES_LIST:$module_path:"
        MODULE_VERSIONS_LIST="$MODULE_VERSIONS_LIST:$module_path=$version:"
    fi
}

# Load a specific module
# Args:
#   $1: module_path (relative to lib directory, e.g., "core/logger")
# Returns:
#   0: success
#   1: failure
load_module() {
    local module_path="$1"
    local module_file="$LIBRARY_ROOT/${module_path}.sh"
    
    # Check if already loaded
    if is_module_loaded "$module_path"; then
        bootstrap_info "Module $module_path already loaded"
        return 0
    fi
    
    # Bash 3.2 compatibility: skip modules that require modern bash features
    if [[ "${BASH_VERSION_MODERN:-false}" != "true" ]]; then
        case "$module_path" in
            "core/config")
                bootstrap_info "Skipping $module_path (requires bash 4.0+), loading simple version instead"
                load_module "core/config_simple"
                return $?
                ;;
        esac
    fi
    
    # Validate module exists
    if [[ ! -f "$module_file" ]]; then
        bootstrap_error "Module not found: $module_path"
    fi
    
    # Source the module
    bootstrap_info "Loading module: $module_path"
    if ! source "$module_file"; then
        bootstrap_error "Failed to load module: $module_path"
    fi
    
    # Extract version if available (look for VERSION= in module)
    local version
    version=$(grep -E '^[[:space:]]*readonly[[:space:]]+.*VERSION=' "$module_file" 2>/dev/null | head -n1 | cut -d'"' -f2 2>/dev/null || echo "unknown")
    
    # Track loaded module
    mark_module_loaded "$module_path" "$version"
    
    bootstrap_info "Successfully loaded $module_path (version: $version)"
    return 0
}

# Load all modules in a directory
# Args:
#   $1: directory_path (relative to lib directory, e.g., "core")
# Returns:
#   0: success
#   1: failure
load_module_directory() {
    local dir_path="$1"
    local full_dir_path="$LIBRARY_ROOT/$dir_path"
    
    if [[ ! -d "$full_dir_path" ]]; then
        bootstrap_error "Module directory not found: $dir_path"
    fi
    
    bootstrap_info "Loading all modules from: $dir_path"
    
    # Find all .sh files in directory (excluding bootstrap.sh)
    local modules
    mapfile -t modules < <(find "$full_dir_path" -name "*.sh" -not -name "bootstrap.sh" -exec basename {} .sh \;)
    
    for module in "${modules[@]}"; do
        load_module "$dir_path/$module"
    done
    
    bootstrap_info "Loaded ${#modules[@]} modules from $dir_path"
}

# Get information about loaded modules
list_loaded_modules() {
    if [[ ${#LOADED_MODULES[@]} -eq 0 ]]; then
        echo "No modules loaded"
        return 0
    fi
    
# List all loaded modules
list_loaded_modules() {
    bootstrap_info "Listing all loaded modules..."
    
    if [[ "$BASH_VERSION_MODERN" == "true" ]]; then
        echo "📦 Loaded Modules:"
        for module in "${!LOADED_MODULES[@]}"; do
            local version="${MODULE_VERSIONS[$module]:-unknown}"
            echo "  ✅ $module (v$version)"
        done
    else
        echo "📦 Loaded Modules:"
        if [[ -n "$LOADED_MODULES_LIST" ]]; then
            echo "$LOADED_MODULES_LIST" | tr ':' '\n' | grep -v '^$' | while read -r module; do
                if [[ -n "$module" ]]; then
                    echo "  ✅ $module"
                fi
            done
        else
            echo "  (no modules loaded)"
        fi
    fi
}
}

# Check if a module is loaded (this function was already updated above)

# Require a module (load if not already loaded)
# Args:
#   $1: module_path
# Returns:
#   0: success
#   1: failure
require_module() {
    local module_path="$1"
    
    if ! is_module_loaded "$module_path"; then
        load_module "$module_path"
    fi
}

# Setup essential environment variables
setup_environment() {
    # Export key paths for use by modules
    export LIBRARY_ROOT
    export PROJECT_ROOT
    export BOOTSTRAP_VERSION
    
    # Set default log level if not set
    export LOG_LEVEL="${LOG_LEVEL:-INFO}"
    
    # Detect and export environment type
    export CI_ENVIRONMENT="${CI:-false}"
    export GITHUB_ACTIONS="${GITHUB_ACTIONS:-false}"
    
    bootstrap_info "Environment setup complete"
}

# Initialize the library system
# This is the main entry point for the bootstrap system
bootstrap_library() {
    if [[ "$BOOTSTRAP_INITIALIZED" == "true" ]]; then
        bootstrap_info "Library already initialized"
        return 0
    fi
    
    bootstrap_info "Initializing AI Evolution Engine Library v$BOOTSTRAP_VERSION"
    
    # Core validation
    check_bash_version
    validate_library_structure
    setup_environment
    
    # Load essential core modules in order
    load_module "core/logger"
    load_module "core/environment" 
    load_module "core/config"
    load_module "core/utils"
    load_module "core/validation"
    
    # Mark as initialized
    BOOTSTRAP_INITIALIZED=true
    
    bootstrap_info "Library initialization complete"
    
    # If debug mode is on, show loaded modules
    if [[ "$LIBRARY_DEBUG" == "true" ]]; then
        list_loaded_modules
    fi
}

# Cleanup function for graceful shutdown
cleanup_library() {
    bootstrap_info "Cleaning up library resources"
    
    # Reset global state
    LOADED_MODULES=()
    MODULE_VERSIONS=()
    BOOTSTRAP_INITIALIZED=false
    
    bootstrap_info "Library cleanup complete"
}

# Version information
show_bootstrap_version() {
    echo "AI Evolution Engine Bootstrap v$BOOTSTRAP_VERSION"
    echo "Library Root: $LIBRARY_ROOT"
    echo "Project Root: $PROJECT_ROOT"
    echo "Minimum Bash: $MIN_BASH_VERSION"
}

# Help information
show_bootstrap_help() {
    cat << 'EOF'
🌱 AI Evolution Engine - Bootstrap System

USAGE:
    source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
    bootstrap_library

FUNCTIONS:
    bootstrap_library()       - Initialize the entire library system
    load_module(path)         - Load a specific module
    load_module_directory(dir) - Load all modules in a directory
    require_module(path)      - Load module if not already loaded
    is_module_loaded(path)    - Check if module is loaded
    list_loaded_modules()     - Show all loaded modules
    cleanup_library()         - Clean up library resources

ENVIRONMENT VARIABLES:
    LIBRARY_DEBUG=true        - Enable debug output
    LOG_LEVEL=DEBUG           - Set logging level

EXAMPLES:
    # Basic initialization
    bootstrap_library
    
    # Load specific modules
    load_module "evolution/engine"
    load_module "integration/github"
    
    # Load all modules from a directory
    load_module_directory "evolution"
    
    # Check module status
    if is_module_loaded "core/logger"; then
        echo "Logger is available"
    fi

EOF
}

# If script is run directly (not sourced), show help
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_bootstrap_help
    show_bootstrap_version
fi
