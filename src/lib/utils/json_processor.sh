#!/bin/bash
#
# @file src/lib/utils/json_processor.sh
# @description JSON processing and manipulation utilities for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Modular refactoring: Extract JSON processing utilities
#
# @relatedEvolutions
#   - v1.0.0: Initial creation during modular refactoring
#
# @dependencies
#   - bash: >=4.0
#   - jq: JSON processor
#
# @changelog
#   - 2025-07-07: Initial creation with JSON processing functions - ITJ
#
# @usage require_module "utils/json_processor"
# @notes Provides standardized JSON manipulation and validation
#

# Prevent multiple imports
[[ "${__JSON_PROCESSOR_LOADED:-}" == "true" ]] && return 0
readonly __JSON_PROCESSOR_LOADED=true

# Module dependencies
require_module "core/logger"
require_module "core/validation"

#
# Validate JSON string
#
# Arguments:
#   $1 - json_string: JSON string to validate
#
# Returns:
#   0 if valid JSON, 1 if invalid
#
json_validate() {
    local json_string="$1"
    
    validate_required "json_string" "$json_string"
    
    if echo "$json_string" | jq empty > /dev/null 2>&1; then
        return 0
    else
        log_error "Invalid JSON provided"
        return 1
    fi
}

#
# Safely extract value from JSON with default
#
# Arguments:
#   $1 - json_string: JSON string
#   $2 - key_path: JQ key path (e.g., ".key", ".nested.key")
#   $3 - default_value: Default value if key not found
#
# Returns:
#   Prints extracted value or default
#
json_get_value() {
    local json_string="$1"
    local key_path="$2"
    local default_value="${3:-null}"
    
    validate_required "json_string" "$json_string"
    validate_required "key_path" "$key_path"
    
    if ! json_validate "$json_string"; then
        echo "$default_value"
        return 1
    fi
    
    local result
    result=$(echo "$json_string" | jq -r "$key_path // \"$default_value\"" 2>/dev/null)
    
    if [[ $? -eq 0 ]]; then
        echo "$result"
        return 0
    else
        echo "$default_value"
        return 1
    fi
}

#
# Set value in JSON object
#
# Arguments:
#   $1 - json_string: JSON string
#   $2 - key_path: JQ key path
#   $3 - new_value: Value to set
#
# Returns:
#   Prints modified JSON, 0 on success
#
json_set_value() {
    local json_string="$1"
    local key_path="$2"
    local new_value="$3"
    
    validate_required "json_string" "$json_string"
    validate_required "key_path" "$key_path"
    validate_required "new_value" "$new_value"
    
    if ! json_validate "$json_string"; then
        return 1
    fi
    
    echo "$json_string" | jq --arg value "$new_value" "$key_path = \$value"
}

#
# Merge two JSON objects
#
# Arguments:
#   $1 - base_json: Base JSON object
#   $2 - overlay_json: JSON object to merge over base
#
# Returns:
#   Prints merged JSON, 0 on success
#
json_merge() {
    local base_json="$1"
    local overlay_json="$2"
    
    validate_required "base_json" "$base_json"
    validate_required "overlay_json" "$overlay_json"
    
    if ! json_validate "$base_json" || ! json_validate "$overlay_json"; then
        return 1
    fi
    
    echo "$base_json" | jq --argjson overlay "$overlay_json" '. * $overlay'
}

#
# Convert JSON to key-value pairs
#
# Arguments:
#   $1 - json_string: JSON object
#   $2 - separator: Key-value separator (default: =)
#
# Returns:
#   Prints key-value pairs, 0 on success
#
json_to_keyvalue() {
    local json_string="$1"
    local separator="${2:-=}"
    
    validate_required "json_string" "$json_string"
    
    if ! json_validate "$json_string"; then
        return 1
    fi
    
    echo "$json_string" | jq -r "to_entries[] | \"\(.key)${separator}\(.value)\""
}

#
# Filter JSON array by condition
#
# Arguments:
#   $1 - json_array: JSON array
#   $2 - filter_expression: JQ filter expression
#
# Returns:
#   Prints filtered array, 0 on success
#
json_filter_array() {
    local json_array="$1"
    local filter_expression="$2"
    
    validate_required "json_array" "$json_array"
    validate_required "filter_expression" "$filter_expression"
    
    if ! json_validate "$json_array"; then
        return 1
    fi
    
    echo "$json_array" | jq "map(select($filter_expression))"
}

#
# Count elements in JSON array
#
# Arguments:
#   $1 - json_array: JSON array
#
# Returns:
#   Prints count, 0 on success
#
json_array_length() {
    local json_array="$1"
    
    validate_required "json_array" "$json_array"
    
    if ! json_validate "$json_array"; then
        return 1
    fi
    
    echo "$json_array" | jq 'length'
}

#
# Pretty print JSON
#
# Arguments:
#   $1 - json_string: JSON to format
#
# Returns:
#   Prints formatted JSON, 0 on success
#
json_pretty_print() {
    local json_string="$1"
    
    validate_required "json_string" "$json_string"
    
    if ! json_validate "$json_string"; then
        return 1
    fi
    
    echo "$json_string" | jq '.'
}

#
# Compact JSON (remove whitespace)
#
# Arguments:
#   $1 - json_string: JSON to compact
#
# Returns:
#   Prints compacted JSON, 0 on success
#
json_compact() {
    local json_string="$1"
    
    validate_required "json_string" "$json_string"
    
    if ! json_validate "$json_string"; then
        return 1
    fi
    
    echo "$json_string" | jq -c '.'
}

#
# Create JSON object from key-value pairs
#
# Arguments:
#   $@ - key=value pairs
#
# Returns:
#   Prints JSON object, 0 on success
#
json_create_object() {
    local json_obj="{}"
    
    for arg in "$@"; do
        if [[ "$arg" =~ ^([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            json_obj=$(echo "$json_obj" | jq --arg k "$key" --arg v "$value" '. + {($k): $v}')
        else
            log_error "Invalid key=value format: $arg"
            return 1
        fi
    done
    
    echo "$json_obj"
}

#
# Load JSON from file with validation
#
# Arguments:
#   $1 - file_path: Path to JSON file
#
# Returns:
#   Prints JSON content, 0 on success
#
json_load_file() {
    local file_path="$1"
    
    validate_required "file_path" "$file_path"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "JSON file not found: $file_path"
        return 1
    fi
    
    local content
    content=$(cat "$file_path")
    
    if json_validate "$content"; then
        echo "$content"
        return 0
    else
        log_error "Invalid JSON in file: $file_path"
        return 1
    fi
}

#
# Save JSON to file with validation
#
# Arguments:
#   $1 - json_string: JSON to save
#   $2 - file_path: Output file path
#
# Returns:
#   0 on success, 1 on failure
#
json_save_file() {
    local json_string="$1"
    local file_path="$2"
    
    validate_required "json_string" "$json_string"
    validate_required "file_path" "$file_path"
    
    if ! json_validate "$json_string"; then
        return 1
    fi
    
    # Ensure directory exists
    local dir_path=$(dirname "$file_path")
    mkdir -p "$dir_path"
    
    if echo "$json_string" | jq '.' > "$file_path"; then
        log_debug "JSON saved to: $file_path"
        return 0
    else
        log_error "Failed to save JSON to: $file_path"
        return 1
    fi
}

# Export functions
export -f json_validate
export -f json_get_value
export -f json_set_value
export -f json_merge
export -f json_to_keyvalue
export -f json_filter_array
export -f json_array_length
export -f json_pretty_print
export -f json_compact
export -f json_create_object
export -f json_load_file
export -f json_save_file

log_debug "JSON processor module loaded"
