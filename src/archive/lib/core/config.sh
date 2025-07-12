#!/bin/bash
#
# @file src/lib/core/config.sh
# @description Configuration management system for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete configuration management system
#
# @dependencies
#   - bash: >=4.0
#   - jq: >=1.6 (for JSON configuration)
#   - yq: >=4.0 (for YAML configuration, optional)
#
# @changelog
#   - 2025-07-05: Initial creation of configuration system - ITJ
#
# @usage require_module "core/config"; load_config "config.yml"
# @notes Supports JSON, YAML, and shell-style configuration files
#

# Prevent multiple imports
[[ "${__CONFIG_LOADED:-}" == "true" ]] && return 0
readonly __CONFIG_LOADED=true

# Source dependencies if not already loaded
if ! declare -F log_info >/dev/null 2>&1; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/logger.sh"
fi

readonly CONFIG_VERSION="2.0.0"

# Configuration state - using bash 3.2 compatible syntax
if [[ "${BASH_VERSION_MODERN:-false}" == "true" ]]; then
    # Modern bash with associative arrays
    declare -A CONFIG_VALUES=()
    declare -A CONFIG_METADATA=()
else
    # Bash 3.2 compatibility - use regular arrays and string manipulation
    CONFIG_VALUES=()
    CONFIG_METADATA=()
fi

CONFIG_FILE=""
CONFIG_FORMAT=""
CONFIG_LOADED=false

# Default configuration structure
readonly DEFAULT_CONFIG='{
  "metadata": {
    "version": "2.0.0",
    "created_at": null,
    "last_updated": null
  },
  "evolution": {
    "type": "consistency",
    "intensity": "minimal",
    "growth_mode": "adaptive",
    "auto_commit": true,
    "auto_push": false,
    "branch_prefix": "evolution"
  },
  "ai": {
    "provider": "openai",
    "model": "gpt-4",
    "temperature": 0.7,
    "max_tokens": 2000,
    "timeout": 30
  },
  "testing": {
    "enabled": true,
    "framework": "bash",
    "coverage_threshold": 80,
    "timeout": 300
  },
  "logging": {
    "level": "INFO",
    "format": "standard",
    "file_enabled": true,
    "console_enabled": true
  },
  "security": {
    "scan_enabled": true,
    "secrets_detection": true,
    "dependency_check": true
  },
  "notifications": {
    "slack_webhook": "",
    "email_enabled": false,
    "github_mentions": true
  }
}'

# Detect configuration file format
# Args:
#   $1: config_file_path
# Returns:
#   Prints format: json, yaml, shell, or unknown
detect_config_format() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        echo "unknown"
        return 1
    fi
    
    local extension="${config_file##*.}"
    case "$extension" in
        json) echo "json" ;;
        yml|yaml) echo "yaml" ;;
        sh|bash|env) echo "shell" ;;
        *)
            # Try to detect by content
            if jq empty "$config_file" >/dev/null 2>&1; then
                echo "json"
            elif command -v yq >/dev/null 2>&1 && yq eval '.' "$config_file" >/dev/null 2>&1; then
                echo "yaml"
            elif head -n5 "$config_file" | grep -E '^[A-Z_]+='; then
                echo "shell"
            else
                echo "unknown"
            fi
            ;;
    esac
}

# Load JSON configuration
# Args:
#   $1: config_file_path
# Returns:
#   0: success
#   1: failure
load_json_config() {
    local config_file="$1"
    
    if ! jq empty "$config_file" >/dev/null 2>&1; then
        log_error "Invalid JSON in config file: $config_file"
        return 1
    fi
    
    log_info "Loading JSON configuration from: $config_file"
    
    # Read all key-value pairs from JSON
    while IFS= read -r line; do
        local key value
        key=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2-)
        CONFIG_VALUES["$key"]="$value"
    done < <(jq -r 'to_entries | map("\(.key)=\(.value|tostring)") | .[]' "$config_file" 2>/dev/null)
    
    # Store metadata
    CONFIG_METADATA["format"]="json"
    CONFIG_METADATA["source"]="$config_file"
    CONFIG_METADATA["loaded_at"]="$(date -Iseconds)"
    
    return 0
}

# Load YAML configuration
# Args:
#   $1: config_file_path
# Returns:
#   0: success
#   1: failure
load_yaml_config() {
    local config_file="$1"
    
    if ! command -v yq >/dev/null 2>&1; then
        log_warn "yq not available, cannot load YAML config"
        return 1
    fi
    
    if ! yq eval '.' "$config_file" >/dev/null 2>&1; then
        log_error "Invalid YAML in config file: $config_file"
        return 1
    fi
    
    log_info "Loading YAML configuration from: $config_file"
    
    # Convert YAML to JSON and process
    local json_content
    json_content=$(yq eval -o json "$config_file" 2>/dev/null)
    
    if [[ -n "$json_content" ]]; then
        # Process the JSON content
        while IFS= read -r line; do
            local key value
            key=$(echo "$line" | cut -d'=' -f1)
            value=$(echo "$line" | cut -d'=' -f2-)
            CONFIG_VALUES["$key"]="$value"
        done < <(echo "$json_content" | jq -r 'to_entries | map("\(.key)=\(.value|tostring)") | .[]' 2>/dev/null)
    fi
    
    # Store metadata
    CONFIG_METADATA["format"]="yaml"
    CONFIG_METADATA["source"]="$config_file"
    CONFIG_METADATA["loaded_at"]="$(date -Iseconds)"
    
    return 0
}

# Load shell-style configuration
# Args:
#   $1: config_file_path
# Returns:
#   0: success
#   1: failure
load_shell_config() {
    local config_file="$1"
    
    log_info "Loading shell configuration from: $config_file"
    
    # Source the file in a subshell and extract variables
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
            
            CONFIG_VALUES["$key"]="$value"
        fi
    done < "$config_file"
    
    # Store metadata
    CONFIG_METADATA["format"]="shell"
    CONFIG_METADATA["source"]="$config_file"
    CONFIG_METADATA["loaded_at"]="$(date -Iseconds)"
    
    return 0
}

# Create default configuration file
# Args:
#   $1: config_file_path
#   $2: format (json, yaml, shell) - default: json
# Returns:
#   0: success
#   1: failure
create_default_config() {
    local config_file="$1"
    local format="${2:-json}"
    
    log_info "Creating default configuration: $config_file (format: $format)"
    
    # Ensure directory exists
    local config_dir
    config_dir="$(dirname "$config_file")"
    [[ ! -d "$config_dir" ]] && mkdir -p "$config_dir"
    
    case "$format" in
        json)
            echo "$DEFAULT_CONFIG" | jq --arg timestamp "$(date -Iseconds)" \
                '.metadata.created_at = $timestamp | .metadata.last_updated = $timestamp' \
                > "$config_file"
            ;;
        yaml)
            if command -v yq >/dev/null 2>&1; then
                echo "$DEFAULT_CONFIG" | yq eval -P '.' > "$config_file"
            else
                log_error "yq not available for YAML config creation"
                return 1
            fi
            ;;
        shell)
            cat > "$config_file" << 'EOF'
#!/bin/bash
# AI Evolution Engine Configuration
# Generated automatically - modify as needed

# Evolution settings
EVOLUTION_TYPE="consistency"
EVOLUTION_INTENSITY="minimal"
GROWTH_MODE="adaptive"
AUTO_COMMIT="true"
AUTO_PUSH="false"
BRANCH_PREFIX="evolution"

# AI settings
AI_PROVIDER="openai"
AI_MODEL="gpt-4"
AI_TEMPERATURE="0.7"
AI_MAX_TOKENS="2000"
AI_TIMEOUT="30"

# Testing settings
TESTING_ENABLED="true"
TESTING_FRAMEWORK="bash"
COVERAGE_THRESHOLD="80"
TESTING_TIMEOUT="300"

# Logging settings
LOG_LEVEL="INFO"
LOG_FORMAT="standard"
LOG_FILE_ENABLED="true"
LOG_CONSOLE_ENABLED="true"

# Security settings
SECURITY_SCAN_ENABLED="true"
SECRETS_DETECTION="true"
DEPENDENCY_CHECK="true"

# Notification settings
SLACK_WEBHOOK=""
EMAIL_ENABLED="false"
GITHUB_MENTIONS="true"
EOF
            ;;
        *)
            log_error "Unsupported configuration format: $format"
            return 1
            ;;
    esac
    
    log_success "Created default configuration: $config_file"
    return 0
}

# Load configuration from file
# Args:
#   $1: config_file_path
# Returns:
#   0: success
#   1: failure
load_config() {
    local config_file="$1"
    
    # Reset previous configuration
    CONFIG_VALUES=()
    CONFIG_METADATA=()
    CONFIG_LOADED=false
    
    # Check if file exists
    if [[ ! -f "$config_file" ]]; then
        log_warn "Configuration file not found: $config_file"
        log_info "Creating default configuration..."
        
        local format
        format=$(detect_config_format "$config_file")
        [[ "$format" == "unknown" ]] && format="json"
        
        if ! create_default_config "$config_file" "$format"; then
            log_error "Failed to create default configuration"
            return 1
        fi
    fi
    
    # Detect format and load accordingly
    local format
    format=$(detect_config_format "$config_file")
    
    case "$format" in
        json)
            load_json_config "$config_file"
            ;;
        yaml)
            load_yaml_config "$config_file"
            ;;
        shell)
            load_shell_config "$config_file"
            ;;
        *)
            log_error "Unsupported configuration format: $format"
            return 1
            ;;
    esac
    
    local result=$?
    if [[ $result -eq 0 ]]; then
        CONFIG_FILE="$config_file"
        CONFIG_FORMAT="$format"
        CONFIG_LOADED=true
        log_success "Configuration loaded successfully from: $config_file"
    else
        log_error "Failed to load configuration from: $config_file"
    fi
    
    return $result
}

# Get configuration value
# Args:
#   $1: key
#   $2: default_value (optional)
# Returns:
#   Prints the configuration value or default
get_config() {
    local key="$1"
    local default="${2:-}"
    
    if [[ -n "${CONFIG_VALUES[$key]:-}" ]]; then
        echo "${CONFIG_VALUES[$key]}"
    else
        echo "$default"
    fi
}

# Set configuration value
# Args:
#   $1: key
#   $2: value
# Returns:
#   0: success
set_config() {
    local key="$1"
    local value="$2"
    
    CONFIG_VALUES["$key"]="$value"
    log_debug "Set configuration: $key=$value"
}

# Check if configuration key exists
# Args:
#   $1: key
# Returns:
#   0: key exists
#   1: key does not exist
has_config() {
    local key="$1"
    [[ -n "${CONFIG_VALUES[$key]:-}" ]]
}

# List all configuration keys
list_config_keys() {
    if [[ ${#CONFIG_VALUES[@]} -eq 0 ]]; then
        echo "No configuration loaded"
        return 0
    fi
    
    echo "📋 Configuration Keys:"
    for key in "${!CONFIG_VALUES[@]}"; do
        echo "  $key=${CONFIG_VALUES[$key]}"
    done
}

# Show configuration metadata
show_config_info() {
    if [[ "$CONFIG_LOADED" != "true" ]]; then
        echo "❌ No configuration loaded"
        return 1
    fi
    
    echo "📊 Configuration Information:"
    echo "  File: ${CONFIG_METADATA[source]:-unknown}"
    echo "  Format: ${CONFIG_METADATA[format]:-unknown}"
    echo "  Loaded: ${CONFIG_METADATA[loaded_at]:-unknown}"
    echo "  Keys: ${#CONFIG_VALUES[@]}"
}

# Validate configuration
# Returns:
#   0: configuration is valid
#   1: configuration has issues
validate_config() {
    if [[ "$CONFIG_LOADED" != "true" ]]; then
        log_error "No configuration loaded"
        return 1
    fi
    
    local issues=0
    
    # Check required keys
    local required_keys=(
        "evolution.type"
        "evolution.intensity"
        "evolution.growth_mode"
        "logging.level"
    )
    
    for key in "${required_keys[@]}"; do
        if ! has_config "$key"; then
            log_error "Required configuration key missing: $key"
            ((issues++))
        fi
    done
    
    # Validate enum values
    local evolution_type
    evolution_type=$(get_config "evolution.type")
    if [[ -n "$evolution_type" ]] && [[ ! "$evolution_type" =~ ^(consistency|error_fixing|documentation|code_quality|security_updates|custom)$ ]]; then
        log_error "Invalid evolution type: $evolution_type"
        ((issues++))
    fi
    
    local log_level
    log_level=$(get_config "logging.level")
    if [[ -n "$log_level" ]] && [[ ! "$log_level" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
        log_error "Invalid log level: $log_level"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        log_success "Configuration validation passed"
        return 0
    else
        log_error "Configuration validation failed with $issues issues"
        return 1
    fi
}

# Save current configuration to file
# Args:
#   $1: output_file (optional, uses current CONFIG_FILE if not provided)
# Returns:
#   0: success
#   1: failure
save_config() {
    local output_file="${1:-$CONFIG_FILE}"
    
    if [[ -z "$output_file" ]]; then
        log_error "No output file specified and no configuration file loaded"
        return 1
    fi
    
    local format="${CONFIG_FORMAT:-json}"
    
    log_info "Saving configuration to: $output_file (format: $format)"
    
    case "$format" in
        json)
            # Build JSON from CONFIG_VALUES
            local json_content="{}"
            for key in "${!CONFIG_VALUES[@]}"; do
                local value="${CONFIG_VALUES[$key]}"
                json_content=$(echo "$json_content" | jq --arg k "$key" --arg v "$value" '. + {($k): $v}')
            done
            
            # Add metadata
            json_content=$(echo "$json_content" | jq --arg timestamp "$(date -Iseconds)" \
                '. + {"metadata": {"last_updated": $timestamp, "version": "'"$CONFIG_VERSION"'"}}')
            
            echo "$json_content" > "$output_file"
            ;;
        yaml)
            if ! command -v yq >/dev/null 2>&1; then
                log_error "yq not available for YAML config saving"
                return 1
            fi
            
            # Convert to JSON first, then to YAML
            local json_content="{}"
            for key in "${!CONFIG_VALUES[@]}"; do
                local value="${CONFIG_VALUES[$key]}"
                json_content=$(echo "$json_content" | jq --arg k "$key" --arg v "$value" '. + {($k): $v}')
            done
            
            echo "$json_content" | yq eval -P '.' > "$output_file"
            ;;
        shell)
            cat > "$output_file" << 'EOF'
#!/bin/bash
# AI Evolution Engine Configuration
# Auto-generated - Last updated: $(date -Iseconds)

EOF
            for key in "${!CONFIG_VALUES[@]}"; do
                local value="${CONFIG_VALUES[$key]}"
                echo "${key}=\"${value}\"" >> "$output_file"
            done
            ;;
        *)
            log_error "Unsupported format for saving: $format"
            return 1
            ;;
    esac
    
    log_success "Configuration saved to: $output_file"
    return 0
}

# Export configuration as environment variables
# Args:
#   $1: prefix (optional, default: "CONFIG_")
export_config() {
    local prefix="${1:-CONFIG_}"
    
    if [[ "$CONFIG_LOADED" != "true" ]]; then
        log_error "No configuration loaded"
        return 1
    fi
    
    log_info "Exporting configuration as environment variables with prefix: $prefix"
    
    for key in "${!CONFIG_VALUES[@]}"; do
        local env_var="${prefix}${key//\./_}"
        local value="${CONFIG_VALUES[$key]}"
        export "$env_var"="$value"
        log_debug "Exported: $env_var=$value"
    done
    
    log_success "Exported ${#CONFIG_VALUES[@]} configuration values"
}

# Reset configuration
reset_config() {
    CONFIG_VALUES=()
    CONFIG_METADATA=()
    CONFIG_FILE=""
    CONFIG_FORMAT=""
    CONFIG_LOADED=false
    log_info "Configuration reset"
}
