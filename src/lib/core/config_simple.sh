#!/bin/bash
#
# @file src/lib/core/config_simple.sh
# @description Simple configuration management compatible with bash 3.2
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Bash 3.2 compatibility: Create simple config system for older bash
#
# @relatedEvolutions
#   - v1.0.0: Initial creation for bash 3.2 compatibility
#
# @dependencies
#   - bash: >=3.2 (compatible with macOS default)
#
# @changelog
#   - 2025-07-07: Initial creation for bash 3.2 compatibility - ITJ
#
# @usage require_module "core/config_simple"
# @notes Simple configuration system without associative arrays
#

# Prevent multiple imports
[[ "${__CONFIG_SIMPLE_LOADED:-}" == "true" ]] && return 0
readonly __CONFIG_SIMPLE_LOADED=true

# Simple configuration variables
CONFIG_FILE=""
CONFIG_LOADED=false

# Default values (can be overridden)
EVOLUTION_TYPE="${EVOLUTION_TYPE:-consistency}"
INTENSITY="${INTENSITY:-minimal}"
GROWTH_MODE="${GROWTH_MODE:-conservative}"

#
# Load simple configuration from environment or file
#
# Arguments:
#   $1 - config_file: Optional configuration file path
#
# Returns:
#   0 on success, 1 on failure
#
load_simple_config() {
    local config_file="${1:-}"
    
    if [[ -n "$config_file" && -f "$config_file" ]]; then
        CONFIG_FILE="$config_file"
        
        # Try to source as shell config
        if [[ "$config_file" =~ \.(sh|bash|env)$ ]]; then
            # shellcheck source=/dev/null
            if source "$config_file" 2>/dev/null; then
                CONFIG_LOADED=true
                log_debug "Loaded shell config: $config_file"
                return 0
            fi
        fi
        
        # Try to load as simple key=value pairs
        while IFS= read -r line; do
            # Skip comments and empty lines
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line// }" ]] && continue
            
            # Extract key=value pairs
            if [[ "$line" =~ ^[[:space:]]*([A-Z_][A-Z0-9_]*)=(.*)$ ]]; then
                local key="${BASH_REMATCH[1]}"
                local value="${BASH_REMATCH[2]}"
                # Remove quotes if present
                value="${value#\"}"
                value="${value%\"}"
                value="${value#\'}"
                value="${value%\'}"
                
                export "$key"="$value"
                log_debug "Set config: $key=$value"
            fi
        done < "$config_file"
        
        CONFIG_LOADED=true
        log_debug "Loaded simple config: $config_file"
    else
        log_debug "No config file specified or file not found, using defaults"
        CONFIG_LOADED=true
    fi
    
    return 0
}

#
# Get configuration value with default
#
# Arguments:
#   $1 - key: Configuration key name
#   $2 - default: Default value if key not found
#
# Returns:
#   Prints value or default
#
get_config_value() {
    local key="$1"
    local default="${2:-}"
    
    # Check if variable is set and not empty
    if [[ -n "${!key:-}" ]]; then
        echo "${!key}"
    else
        echo "$default"
    fi
}

#
# Set configuration value
#
# Arguments:
#   $1 - key: Configuration key name
#   $2 - value: Value to set
#
# Returns:
#   0 on success
#
set_config_value() {
    local key="$1"
    local value="$2"
    
    export "$key"="$value"
    log_debug "Set config: $key=$value"
}

#
# Check if configuration key exists
#
# Arguments:
#   $1 - key: Configuration key name
#
# Returns:
#   0 if key exists, 1 if not
#
has_config_key() {
    local key="$1"
    [[ -n "${!key:-}" ]]
}

#
# Display current configuration
#
# Returns:
#   0 on success
#
show_config() {
    log_info "Current Configuration:"
    log_info "  EVOLUTION_TYPE: $(get_config_value "EVOLUTION_TYPE" "not set")"
    log_info "  INTENSITY: $(get_config_value "INTENSITY" "not set")"
    log_info "  GROWTH_MODE: $(get_config_value "GROWTH_MODE" "not set")"
    log_info "  CONFIG_FILE: ${CONFIG_FILE:-none}"
    log_info "  CONFIG_LOADED: $CONFIG_LOADED"
}

#
# Create default configuration file
#
# Arguments:
#   $1 - output_file: Path to create configuration file
#
# Returns:
#   0 on success, 1 on failure
#
create_default_config() {
    local output_file="$1"
    
    cat > "$output_file" << 'EOF'
# AI Evolution Engine Configuration
# Simple key=value format for bash 3.2 compatibility

# Evolution settings
EVOLUTION_TYPE=consistency
INTENSITY=minimal
GROWTH_MODE=conservative

# Output settings
OUTPUT_DIR=./evolution-output
DRY_RUN=false
VERBOSE=false

# GitHub settings (set these as needed)
# GITHUB_TOKEN=your_token_here
# GITHUB_REPO=your_repo_here

# Evolution cycle settings
AUTO_PLANT=true
MAX_RETRIES=3
TIMEOUT=300
EOF
    
    if [[ $? -eq 0 ]]; then
        log_info "Default configuration created: $output_file"
        return 0
    else
        log_error "Failed to create configuration file: $output_file"
        return 1
    fi
}

# Export functions
export -f load_simple_config
export -f get_config_value
export -f set_config_value
export -f has_config_key
export -f show_config
export -f create_default_config

log_debug "Simple config module loaded (bash 3.2 compatible)"
