#!/bin/bash
#
# @file src/lib/template/engine.sh
# @description Template processing and generation engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular template processing system
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#
# @changelog
#   - 2025-07-05: Initial creation of template engine module - ITJ
#
# @usage require_module "template/engine"; template_process_file
# @notes Handles template processing, variable substitution, and generation
#

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly TEMPLATE_ENGINE_VERSION="2.0.0"

# Template engine state
declare -A TEMPLATE_VARIABLES=()
declare -g TEMPLATE_DELIMITER_START="{{"
declare -g TEMPLATE_DELIMITER_END="}}"
declare -g TEMPLATE_BASE_DIR=""

# Initialize template engine
# Args:
#   $1: base_directory (optional)
#   $2: delimiter_start (optional)
#   $3: delimiter_end (optional)
# Returns:
#   0: success
template_init() {
    local base_dir="${1:-templates}"
    local delim_start="${2:-{{}"
    local delim_end="${3:-}}}"
    
    log_info "Initializing template engine v$TEMPLATE_ENGINE_VERSION"
    
    TEMPLATE_BASE_DIR="$base_dir"
    TEMPLATE_DELIMITER_START="$delim_start"
    TEMPLATE_DELIMITER_END="$delim_end"
    
    # Clear previous variables
    TEMPLATE_VARIABLES=()
    
    log_debug "Template base directory: $TEMPLATE_BASE_DIR"
    log_debug "Template delimiters: $TEMPLATE_DELIMITER_START ... $TEMPLATE_DELIMITER_END"
    
    return 0
}

# Set template variable
# Args:
#   $1: variable_name
#   $2: variable_value
# Returns:
#   0: success
#   1: failure
template_set_variable() {
    local var_name="$1"
    local var_value="$2"
    
    if [[ -z "$var_name" ]]; then
        log_error "Variable name cannot be empty"
        return 1
    fi
    
    TEMPLATE_VARIABLES["$var_name"]="$var_value"
    log_debug "Template variable set: $var_name=$var_value"
    
    return 0
}

# Get template variable
# Args:
#   $1: variable_name
# Returns:
#   0: success (prints value)
#   1: variable not found
template_get_variable() {
    local var_name="$1"
    
    if [[ -z "$var_name" ]]; then
        log_error "Variable name cannot be empty"
        return 1
    fi
    
    if [[ -n "${TEMPLATE_VARIABLES[$var_name]:-}" ]]; then
        echo "${TEMPLATE_VARIABLES[$var_name]}"
        return 0
    else
        log_debug "Template variable not found: $var_name"
        return 1
    fi
}

# Load variables from file
# Args:
#   $1: variables_file (JSON, YAML, or key=value format)
# Returns:
#   0: success
#   1: failure
template_load_variables() {
    local vars_file="$1"
    
    if [[ -z "$vars_file" ]]; then
        log_error "Variables file path is required"
        return 1
    fi
    
    if [[ ! -f "$vars_file" ]]; then
        log_error "Variables file not found: $vars_file"
        return 1
    fi
    
    log_info "Loading template variables from: $vars_file"
    
    local file_extension="${vars_file##*.}"
    
    case "$file_extension" in
        "json")
            template_load_json_variables "$vars_file"
            ;;
        "yml"|"yaml")
            template_load_yaml_variables "$vars_file"
            ;;
        *)
            template_load_env_variables "$vars_file"
            ;;
    esac
}

# Load variables from JSON file
# Args:
#   $1: json_file
# Returns:
#   0: success
#   1: failure
template_load_json_variables() {
    local json_file="$1"
    
    if ! command -v jq >/dev/null 2>&1; then
        log_error "jq is required for JSON variable loading"
        return 1
    fi
    
    while IFS='=' read -r key value; do
        if [[ -n "$key" && -n "$value" ]]; then
            template_set_variable "$key" "$value"
        fi
    done < <(jq -r 'to_entries[] | "\(.key)=\(.value)"' "$json_file" 2>/dev/null)
    
    log_debug "Loaded variables from JSON: $json_file"
    return 0
}

# Load variables from YAML file
# Args:
#   $1: yaml_file
# Returns:
#   0: success
#   1: failure
template_load_yaml_variables() {
    local yaml_file="$1"
    
    if ! command -v yq >/dev/null 2>&1; then
        log_warn "yq not available, attempting basic YAML parsing"
        # Basic YAML parsing for simple key: value pairs
        while IFS=': ' read -r key value; do
            if [[ -n "$key" && -n "$value" && ! "$key" =~ ^[[:space:]]*# ]]; then
                # Remove leading/trailing whitespace and quotes
                key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/^["'"'"']//;s/["'"'"']$//')
                template_set_variable "$key" "$value"
            fi
        done < "$yaml_file"
    else
        while IFS='=' read -r key value; do
            if [[ -n "$key" && -n "$value" ]]; then
                template_set_variable "$key" "$value"
            fi
        done < <(yq eval -o=props "$yaml_file" 2>/dev/null)
    fi
    
    log_debug "Loaded variables from YAML: $yaml_file"
    return 0
}

# Load variables from environment/key=value file
# Args:
#   $1: env_file
# Returns:
#   0: success
template_load_env_variables() {
    local env_file="$1"
    
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        if [[ -n "$key" && ! "$key" =~ ^[[:space:]]*# ]]; then
            # Remove leading/trailing whitespace and quotes
            key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/^["'"'"']//;s/["'"'"']$//')
            template_set_variable "$key" "$value"
        fi
    done < "$env_file"
    
    log_debug "Loaded variables from environment file: $env_file"
    return 0
}

# Process template string
# Args:
#   $1: template_string
# Returns:
#   0: success (prints processed string)
#   1: failure
template_process_string() {
    local template_string="$1"
    
    if [[ -z "$template_string" ]]; then
        return 0
    fi
    
    local processed_string="$template_string"
    
    # Find all variables in the template
    while [[ "$processed_string" =~ $TEMPLATE_DELIMITER_START([^}]+)$TEMPLATE_DELIMITER_END ]]; do
        local full_match="${BASH_REMATCH[0]}"
        local var_name="${BASH_REMATCH[1]}"
        
        # Remove leading/trailing whitespace from variable name
        var_name=$(echo "$var_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        local var_value
        if var_value=$(template_get_variable "$var_name"); then
            processed_string="${processed_string//$full_match/$var_value}"
        else
            log_warn "Template variable not found: $var_name"
            processed_string="${processed_string//$full_match/}"
        fi
    done
    
    echo "$processed_string"
    return 0
}

# Process template file
# Args:
#   $1: template_file
#   $2: output_file (optional, prints to stdout if not provided)
# Returns:
#   0: success
#   1: failure
template_process_file() {
    local template_file="$1"
    local output_file="${2:-}"
    
    if [[ -z "$template_file" ]]; then
        log_error "Template file path is required"
        return 1
    fi
    
    # Resolve template file path
    local resolved_template_file="$template_file"
    if [[ ! -f "$resolved_template_file" && -n "$TEMPLATE_BASE_DIR" ]]; then
        resolved_template_file="$TEMPLATE_BASE_DIR/$template_file"
    fi
    
    if [[ ! -f "$resolved_template_file" ]]; then
        log_error "Template file not found: $resolved_template_file"
        return 1
    fi
    
    log_info "Processing template: $resolved_template_file"
    
    local processed_content=""
    
    # Process file line by line to handle large files efficiently
    while IFS= read -r line; do
        local processed_line
        processed_line=$(template_process_string "$line")
        processed_content="$processed_content$processed_line"$'\n'
    done < "$resolved_template_file"
    
    # Remove trailing newline
    processed_content="${processed_content%$'\n'}"
    
    if [[ -n "$output_file" ]]; then
        echo "$processed_content" > "$output_file"
        log_info "Template processed and saved to: $output_file"
    else
        echo "$processed_content"
    fi
    
    return 0
}

# Generate file from template
# Args:
#   $1: template_name
#   $2: output_file
#   $3: variables_file (optional)
# Returns:
#   0: success
#   1: failure
template_generate_file() {
    local template_name="$1"
    local output_file="$2"
    local variables_file="${3:-}"
    
    if [[ -z "$template_name" || -z "$output_file" ]]; then
        log_error "Template name and output file are required"
        return 1
    fi
    
    # Load variables if provided
    if [[ -n "$variables_file" ]]; then
        template_load_variables "$variables_file" || {
            log_error "Failed to load variables from: $variables_file"
            return 1
        }
    fi
    
    # Process template
    template_process_file "$template_name" "$output_file" || {
        log_error "Failed to process template: $template_name"
        return 1
    }
    
    log_info "Generated file from template: $template_name -> $output_file"
    return 0
}

# Create template from existing file
# Args:
#   $1: source_file
#   $2: template_file
#   $3: variables_to_replace (comma-separated list)
# Returns:
#   0: success
#   1: failure
template_create_from_file() {
    local source_file="$1"
    local template_file="$2"
    local variables_to_replace="${3:-}"
    
    if [[ -z "$source_file" || -z "$template_file" ]]; then
        log_error "Source file and template file are required"
        return 1
    fi
    
    if [[ ! -f "$source_file" ]]; then
        log_error "Source file not found: $source_file"
        return 1
    fi
    
    log_info "Creating template from: $source_file -> $template_file"
    
    local template_content
    template_content=$(cat "$source_file")
    
    # Replace specified variables with template placeholders
    if [[ -n "$variables_to_replace" ]]; then
        IFS=',' read -ra VARS <<< "$variables_to_replace"
        for var in "${VARS[@]}"; do
            # Remove leading/trailing whitespace
            var=$(echo "$var" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            
            if [[ -n "$var" ]]; then
                local placeholder="$TEMPLATE_DELIMITER_START $var $TEMPLATE_DELIMITER_END"
                # Simple replacement for demonstration - could be enhanced with more sophisticated pattern matching
                template_content="${template_content//\$$var/$placeholder}"
                template_content="${template_content//$var/$placeholder}"
                log_debug "Replaced variable: $var -> $placeholder"
            fi
        done
    fi
    
    # Ensure template directory exists
    local template_dir
    template_dir=$(dirname "$template_file")
    mkdir -p "$template_dir"
    
    echo "$template_content" > "$template_file"
    log_info "Template created: $template_file"
    
    return 0
}

# List available templates
# Args:
#   $1: pattern (optional glob pattern)
# Returns:
#   0: success (prints template list)
template_list_available() {
    local pattern="${1:-*}"
    
    if [[ -z "$TEMPLATE_BASE_DIR" ]]; then
        log_warn "Template base directory not set"
        return 0
    fi
    
    if [[ ! -d "$TEMPLATE_BASE_DIR" ]]; then
        log_warn "Template directory not found: $TEMPLATE_BASE_DIR"
        return 0
    fi
    
    log_info "Available templates in $TEMPLATE_BASE_DIR:"
    
    find "$TEMPLATE_BASE_DIR" -name "$pattern" -type f | while read -r template; do
        local relative_path="${template#$TEMPLATE_BASE_DIR/}"
        echo "  $relative_path"
    done
    
    return 0
}

# Validate template syntax
# Args:
#   $1: template_file
# Returns:
#   0: valid
#   1: invalid
template_validate() {
    local template_file="$1"
    
    if [[ -z "$template_file" ]]; then
        log_error "Template file path is required"
        return 1
    fi
    
    # Resolve template file path
    local resolved_template_file="$template_file"
    if [[ ! -f "$resolved_template_file" && -n "$TEMPLATE_BASE_DIR" ]]; then
        resolved_template_file="$TEMPLATE_BASE_DIR/$template_file"
    fi
    
    if [[ ! -f "$resolved_template_file" ]]; then
        log_error "Template file not found: $resolved_template_file"
        return 1
    fi
    
    log_info "Validating template: $resolved_template_file"
    
    local issues=0
    local line_number=0
    
    while IFS= read -r line; do
        ((line_number++))
        
        # Check for unclosed template variables
        local open_count
        open_count=$(echo "$line" | grep -o "$TEMPLATE_DELIMITER_START" | wc -l)
        local close_count
        close_count=$(echo "$line" | grep -o "$TEMPLATE_DELIMITER_END" | wc -l)
        
        if [[ $open_count -ne $close_count ]]; then
            log_warn "Line $line_number: Mismatched template delimiters"
            ((issues++))
        fi
        
        # Check for nested template variables (not supported)
        if echo "$line" | grep -q "$TEMPLATE_DELIMITER_START.*$TEMPLATE_DELIMITER_START.*$TEMPLATE_DELIMITER_END"; then
            log_warn "Line $line_number: Nested template variables detected (not supported)"
            ((issues++))
        fi
        
    done < "$resolved_template_file"
    
    if [[ $issues -eq 0 ]]; then
        log_info "Template validation passed"
        return 0
    else
        log_error "Template validation failed with $issues issues"
        return 1
    fi
}

# Show template variables in file
# Args:
#   $1: template_file
# Returns:
#   0: success (prints variables found)
template_show_variables() {
    local template_file="$1"
    
    if [[ -z "$template_file" ]]; then
        log_error "Template file path is required"
        return 1
    fi
    
    # Resolve template file path
    local resolved_template_file="$template_file"
    if [[ ! -f "$resolved_template_file" && -n "$TEMPLATE_BASE_DIR" ]]; then
        resolved_template_file="$TEMPLATE_BASE_DIR/$template_file"
    fi
    
    if [[ ! -f "$resolved_template_file" ]]; then
        log_error "Template file not found: $resolved_template_file"
        return 1
    fi
    
    log_info "Template variables in: $resolved_template_file"
    
    # Extract unique variable names
    grep -o "$TEMPLATE_DELIMITER_START[^}]*$TEMPLATE_DELIMITER_END" "$resolved_template_file" | \
    sed "s/$TEMPLATE_DELIMITER_START//g; s/$TEMPLATE_DELIMITER_END//g" | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
    sort -u | \
    while read -r var; do
        if [[ -n "$var" ]]; then
            echo "  $var"
        fi
    done
    
    return 0
}

log_debug "Template engine module loaded (v$TEMPLATE_ENGINE_VERSION)"
