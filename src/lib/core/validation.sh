#!/bin/bash
#
# @file src/lib/core/validation.sh
# @description Input/output validation system for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Comprehensive validation framework
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#
# @changelog
#   - 2025-07-05: Initial creation of validation framework - ITJ
#
# @usage require_module "core/validation"; validate_input "email" "user@example.com"
# @notes Provides type-safe validation with detailed error reporting
#

# Prevent multiple imports
[[ "${__VALIDATION_LOADED:-}" == "true" ]] && return 0
readonly __VALIDATION_LOADED=true

# Source dependencies if not already loaded
if ! declare -F log_info >/dev/null 2>&1; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/logger.sh"
fi

if ! declare -F is_valid_email >/dev/null 2>&1; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/utils.sh"
fi

readonly VALIDATION_VERSION="2.0.0"

# Check bash version for compatibility
BASH_VERSION_MAJOR=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | cut -d. -f1)

# Validation state tracking - compatible with bash 3.2+
if [[ "${BASH_VERSION_MAJOR:-3}" -ge 4 ]]; then
    # Modern bash (4+) with associative arrays
    declare -A VALIDATION_ERRORS=()
    declare -A VALIDATION_RULES=(
        [required]="not_empty"
        [string]="is_string"
        [integer]="is_integer"
        [float]="is_float"
        [boolean]="is_boolean"
        [email]="is_valid_email"
        [url]="is_valid_url"
        [ip]="is_valid_ip"
        [semver]="is_valid_semver"
        [path]="is_valid_path"
        [file]="file_exists"
        [directory]="directory_exists"
        [executable]="is_executable"
        [readable]="is_readable"
        [writable]="is_writable"
        [json]="is_valid_json"
        [yaml]="is_valid_yaml"
        [git_repo]="is_git_repository"
        [git_branch]="is_valid_git_branch"
        [github_repo]="is_valid_github_repo"
        [docker_image]="is_valid_docker_image"
        [port]="is_valid_port"
        [uuid]="is_valid_uuid"
    )
    VALIDATION_USE_ARRAYS=true
else
    # Legacy bash (3.2+) with simple variables
    VALIDATION_ERRORS_LIST=""
    VALIDATION_USE_ARRAYS=false
fi

VALIDATION_ERROR_COUNT=0
VALIDATION_STRICT_MODE=false

# Error handling for validation
validation_error() {
    local message="$1"
    local field="${2:-unknown}"
    local value="${3:-}"
    
    if [[ "$VALIDATION_USE_ARRAYS" == "true" ]]; then
        VALIDATION_ERRORS["$field"]="$message"
    else
        VALIDATION_ERRORS_LIST="$VALIDATION_ERRORS_LIST|$field:$message"
    fi
    ((VALIDATION_ERROR_COUNT++))
    
    if [[ "$VALIDATION_STRICT_MODE" == "true" ]]; then
        log_error "Validation failed for '$field': $message"
        [[ -n "$value" ]] && log_debug "Invalid value: '$value'"
        return 1
    else
        log_warn "Validation warning for '$field': $message"
        [[ -n "$value" ]] && log_debug "Warning value: '$value'"
        return 0
    fi
}

# Clear validation errors
clear_validation_errors() {
    if [[ "$VALIDATION_USE_ARRAYS" == "true" ]]; then
        VALIDATION_ERRORS=()
    else
        VALIDATION_ERRORS_LIST=""
    fi
    VALIDATION_ERROR_COUNT=0
}

# Get validation errors
get_validation_errors() {
    if [[ $VALIDATION_ERROR_COUNT -eq 0 ]]; then
        echo "No validation errors"
        return 0
    fi
    
    echo "🚨 Validation Errors ($VALIDATION_ERROR_COUNT):"
    if [[ "$VALIDATION_USE_ARRAYS" == "true" ]]; then
        for field in "${!VALIDATION_ERRORS[@]}"; do
            echo "  ❌ $field: ${VALIDATION_ERRORS[$field]}"
        done
    else
        # Parse the list format
        IFS='|' read -ra error_list <<< "$VALIDATION_ERRORS_LIST"
        for error_item in "${error_list[@]}"; do
            if [[ -n "$error_item" ]]; then
                local field="${error_item%%:*}"
                local message="${error_item#*:}"
                echo "  ❌ $field: $message"
            fi
        done
    fi
}

# Enable/disable strict validation mode
set_validation_mode() {
    local mode="$1"
    case "$mode" in
        strict|true)
            VALIDATION_STRICT_MODE=true
            log_info "Validation set to strict mode"
            ;;
        lenient|false)
            VALIDATION_STRICT_MODE=false
            log_info "Validation set to lenient mode"
            ;;
        *)
            log_error "Invalid validation mode: $mode (use 'strict' or 'lenient')"
            return 1
            ;;
    esac
}

# Basic type validators
# ===========================================

# Check if value is not empty
# Args:
#   $1: value
# Returns:
#   0: not empty
#   1: empty
not_empty() {
    local value="$1"
    [[ -n "$value" ]]
}

# Check if value is a string (always true for bash)
# Args:
#   $1: value
# Returns:
#   0: is string
is_string() {
    local value="$1"
    [[ -n "$value" ]] || [[ "$value" == "" ]]
}

# Check if value is an integer
# Args:
#   $1: value
# Returns:
#   0: is integer
#   1: not integer
is_integer() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

# Check if value is a float
# Args:
#   $1: value
# Returns:
#   0: is float
#   1: not float
is_float() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+\.?[0-9]*$ ]] || [[ "$value" =~ ^-?\.[0-9]+$ ]]
}

# Check if value is a boolean
# Args:
#   $1: value
# Returns:
#   0: is boolean
#   1: not boolean
is_boolean() {
    local value="$1"
    [[ "$value" =~ ^(true|false|1|0|yes|no|on|off)$ ]]
}

# File system validators
# ===========================================

# Check if path is valid (not necessarily existing)
# Args:
#   $1: path
# Returns:
#   0: valid path format
#   1: invalid path format
is_valid_path() {
    local path="$1"
    # Basic path validation - no null bytes, reasonable length
    [[ -n "$path" ]] && [[ ${#path} -lt 4096 ]] && [[ "$path" != *$'\0'* ]]
}

# Check if file exists
# Args:
#   $1: file_path
# Returns:
#   0: file exists
#   1: file does not exist
file_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]]
}

# Check if directory exists
# Args:
#   $1: directory_path
# Returns:
#   0: directory exists
#   1: directory does not exist
directory_exists() {
    local dir_path="$1"
    [[ -d "$dir_path" ]]
}

# Check if file/directory is executable
# Args:
#   $1: path
# Returns:
#   0: is executable
#   1: not executable
is_executable() {
    local path="$1"
    [[ -x "$path" ]]
}

# Check if file/directory is readable
# Args:
#   $1: path
# Returns:
#   0: is readable
#   1: not readable
is_readable() {
    local path="$1"
    [[ -r "$path" ]]
}

# Check if file/directory is writable
# Args:
#   $1: path
# Returns:
#   0: is writable
#   1: not writable
is_writable() {
    local path="$1"
    [[ -w "$path" ]]
}

# Data format validators
# ===========================================

# Check if string is valid JSON
# Args:
#   $1: json_string
# Returns:
#   0: valid JSON
#   1: invalid JSON
is_valid_json() {
    local json_string="$1"
    
    if ! command -v jq >/dev/null 2>&1; then
        log_warn "jq not available for JSON validation"
        return 0  # Assume valid if we can't validate
    fi
    
    echo "$json_string" | jq empty >/dev/null 2>&1
}

# Check if file contains valid YAML
# Args:
#   $1: yaml_string or file_path
# Returns:
#   0: valid YAML
#   1: invalid YAML
is_valid_yaml() {
    local input="$1"
    
    if ! command -v yq >/dev/null 2>&1; then
        log_warn "yq not available for YAML validation"
        return 0  # Assume valid if we can't validate
    fi
    
    if [[ -f "$input" ]]; then
        yq eval '.' "$input" >/dev/null 2>&1
    else
        echo "$input" | yq eval '.' >/dev/null 2>&1
    fi
}

# Version Control validators
# ===========================================

# Check if directory is a Git repository
# Args:
#   $1: directory_path
# Returns:
#   0: is Git repository
#   1: not Git repository
is_git_repository() {
    local dir_path="${1:-.}"
    
    if [[ ! -d "$dir_path" ]]; then
        return 1
    fi
    
    (cd "$dir_path" && git rev-parse --git-dir >/dev/null 2>&1)
}

# Check if Git branch name is valid
# Args:
#   $1: branch_name
# Returns:
#   0: valid branch name
#   1: invalid branch name
is_valid_git_branch() {
    local branch_name="$1"
    
    # Git branch naming rules
    [[ -n "$branch_name" ]] && \
    [[ ! "$branch_name" =~ ^\. ]] && \
    [[ ! "$branch_name" =~ \.$ ]] && \
    [[ ! "$branch_name" =~ \.\. ]] && \
    [[ ! "$branch_name" =~ [[:space:]] ]] && \
    [[ ! "$branch_name" =~ [\~\^\:\?\*\[] ]] && \
    [[ ! "$branch_name" =~ \/$ ]] && \
    [[ ! "$branch_name" =~ ^\/$ ]]
}

# Check if GitHub repository format is valid
# Args:
#   $1: repo_format (owner/repo)
# Returns:
#   0: valid format
#   1: invalid format
is_valid_github_repo() {
    local repo_format="$1"
    [[ "$repo_format" =~ ^[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+$ ]]
}

# Network validators
# ===========================================

# Check if port number is valid
# Args:
#   $1: port_number
# Returns:
#   0: valid port
#   1: invalid port
is_valid_port() {
    local port="$1"
    
    if ! is_integer "$port"; then
        return 1
    fi
    
    [[ $port -ge 1 && $port -le 65535 ]]
}

# Container validators
# ===========================================

# Check if Docker image name is valid
# Args:
#   $1: image_name
# Returns:
#   0: valid image name
#   1: invalid image name
is_valid_docker_image() {
    local image_name="$1"
    
    # Docker image naming rules (simplified)
    [[ "$image_name" =~ ^[a-z0-9]+([._-][a-z0-9]+)*(/[a-z0-9]+([._-][a-z0-9]+)*)*(:[a-zA-Z0-9._-]+)?$ ]]
}

# Special format validators
# ===========================================

# Check if string is a valid UUID
# Args:
#   $1: uuid_string
# Returns:
#   0: valid UUID
#   1: invalid UUID
is_valid_uuid() {
    local uuid="$1"
    [[ "$uuid" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]
}

# Check if string is valid base64
# Args:
#   $1: base64_string
# Returns:
#   0: valid base64
#   1: invalid base64
is_valid_base64() {
    local base64_string="$1"
    
    # Basic base64 pattern check
    [[ "$base64_string" =~ ^[A-Za-z0-9+/]*={0,2}$ ]] && \
    [[ $(( ${#base64_string} % 4 )) -eq 0 ]]
}

# Check if string is valid hexadecimal
# Args:
#   $1: hex_string
# Returns:
#   0: valid hex
#   1: invalid hex
is_valid_hex() {
    local hex_string="$1"
    [[ "$hex_string" =~ ^[0-9a-fA-F]+$ ]]
}

# Range validators
# ===========================================

# Validate integer is within range
# Args:
#   $1: value
#   $2: min_value
#   $3: max_value
# Returns:
#   0: within range
#   1: outside range
validate_integer_range() {
    local value="$1"
    local min_value="$2"
    local max_value="$3"
    
    if ! is_integer "$value"; then
        return 1
    fi
    
    [[ $value -ge $min_value && $value -le $max_value ]]
}

# Validate string length
# Args:
#   $1: string
#   $2: min_length
#   $3: max_length (optional)
# Returns:
#   0: valid length
#   1: invalid length
validate_string_length() {
    local string="$1"
    local min_length="$2"
    local max_length="${3:-999999}"
    
    local length=${#string}
    [[ $length -ge $min_length && $length -le $max_length ]]
}

# Main validation functions
# ===========================================

# Helper function to get validation rule (compatibility with bash 3.2)
get_validation_rule() {
    local rule="$1"
    
    if [[ "$VALIDATION_USE_ARRAYS" == "true" ]]; then
        echo "${VALIDATION_RULES[$rule]:-}"
    else
        # Legacy mode - use case statement for rules
        case "$rule" in
            required) echo "not_empty" ;;
            string) echo "is_string" ;;
            integer) echo "is_integer" ;;
            float) echo "is_float" ;;
            boolean) echo "is_boolean" ;;
            email) echo "is_valid_email" ;;
            url) echo "is_valid_url" ;;
            ip) echo "is_valid_ip" ;;
            semver) echo "is_valid_semver" ;;
            path) echo "is_valid_path" ;;
            file) echo "file_exists" ;;
            directory) echo "directory_exists" ;;
            executable) echo "is_executable" ;;
            readable) echo "is_readable" ;;
            writable) echo "is_writable" ;;
            json) echo "is_valid_json" ;;
            yaml) echo "is_valid_yaml" ;;
            git_repo) echo "is_git_repository" ;;
            git_branch) echo "is_valid_git_branch" ;;
            github_repo) echo "is_valid_github_repo" ;;
            docker_image) echo "is_valid_docker_image" ;;
            port) echo "is_valid_port" ;;
            uuid) echo "is_valid_uuid" ;;
            *) echo "" ;;
        esac
    fi
}

# Validate single input against a rule
# Args:
#   $1: rule_name
#   $2: value
#   $3: field_name (optional, for error reporting)
# Returns:
#   0: validation passed
#   1: validation failed
validate_input() {
    local rule="$1"
    local value="$2"
    local field_name="${3:-$rule}"
    
    # Check if rule exists
    local validator_function
    validator_function=$(get_validation_rule "$rule")
    if [[ -z "$validator_function" ]]; then
        validation_error "Unknown validation rule: $rule" "$field_name" "$value"
        return 1
    fi
    
    # Execute validator function
    if ! "$validator_function" "$value"; then
        validation_error "Validation failed for rule '$rule'" "$field_name" "$value"
        return 1
    fi
    
    return 0
}

# Validate multiple inputs with different rules
# Args:
#   Pairs of "rule:value" or "rule:value:field_name"
# Returns:
#   0: all validations passed
#   1: one or more validations failed
validate_multiple() {
    local validation_pairs=("$@")
    local failed_count=0
    
    clear_validation_errors
    
    for pair in "${validation_pairs[@]}"; do
        IFS=':' read -ra parts <<< "$pair"
        local rule="${parts[0]}"
        local value="${parts[1]:-}"
        local field_name="${parts[2]:-$rule}"
        
        if ! validate_input "$rule" "$value" "$field_name"; then
            ((failed_count++))
        fi
    done
    
    if [[ $failed_count -gt 0 ]]; then
        log_error "Validation failed for $failed_count inputs"
        get_validation_errors
        return 1
    fi
    
    log_success "All validations passed"
    return 0
}

# Validate configuration object
# Args:
#   $1: config_object (JSON or associative array reference)
#   $2: validation_schema (JSON file or inline JSON)
# Returns:
#   0: configuration is valid
#   1: configuration is invalid
validate_config_object() {
    local config_object="$1"
    local validation_schema="$2"
    
    # This is a placeholder for advanced JSON schema validation
    # Would require a more sophisticated implementation
    log_info "Config validation not yet implemented"
    return 0
}

# Custom validation rule registration
# ===========================================

# Register a custom validation rule
# Args:
#   $1: rule_name
#   $2: validator_function_name
# Returns:
#   0: rule registered
#   1: rule registration failed
register_validation_rule() {
    local rule_name="$1"
    local function_name="$2"
    
    # Check if function exists
    if ! declare -F "$function_name" >/dev/null 2>&1; then
        log_error "Validator function '$function_name' does not exist"
        return 1
    fi
    
    VALIDATION_RULES["$rule_name"]="$function_name"
    log_info "Registered validation rule: $rule_name -> $function_name"
    return 0
}

# List available validation rules
list_validation_rules() {
    echo "📋 Available Validation Rules:"
    for rule in "${!VALIDATION_RULES[@]}"; do
        local function_name="${VALIDATION_RULES[$rule]}"
        echo "  ✅ $rule -> $function_name"
    done
}

# Validation testing utilities
# ===========================================

# Test all validation rules with sample data
test_validation_rules() {
    log_info "Testing validation rules..."
    
    local test_cases=(
        "required:test_value"
        "string:hello world"
        "integer:42"
        "float:3.14"
        "boolean:true"
        "email:test@example.com"
        "url:https://example.com"
        "ip:192.168.1.1"
        "semver:1.0.0"
        "path:/tmp/test"
        "port:8080"
        "uuid:550e8400-e29b-41d4-a716-446655440000"
        "base64:SGVsbG9Xb3JsZA=="
        "hex:deadbeef"
    )
    
    local passed=0
    local failed=0
    
    for test_case in "${test_cases[@]}"; do
        IFS=':' read -ra parts <<< "$test_case"
        local rule="${parts[0]}"
        local value="${parts[1]}"
        
        if validate_input "$rule" "$value" "test_$rule"; then
            ((passed++))
            echo "  ✅ $rule: $value"
        else
            ((failed++))
            echo "  ❌ $rule: $value"
        fi
    done
    
    echo
    echo "📊 Test Results:"
    echo "  ✅ Passed: $passed"
    echo "  ❌ Failed: $failed"
    echo "  📝 Total: $((passed + failed))"
    
    [[ $failed -eq 0 ]]
}

# Performance benchmarking
benchmark_validation() {
    local iterations="${1:-1000}"
    
    log_info "Benchmarking validation performance ($iterations iterations)..."
    
    local start_time
    start_time="$(date +%s.%N)"
    
    for ((i=1; i<=iterations; i++)); do
        validate_input "email" "test@example.com" >/dev/null 2>&1
    done
    
    local end_time
    end_time="$(date +%s.%N)"
    local duration
    duration="$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "unknown")"
    
    if [[ "$duration" != "unknown" ]]; then
        local per_validation
        per_validation="$(echo "scale=6; $duration / $iterations" | bc -l)"
        echo "⏱️  Total time: ${duration}s"
        echo "⚡ Per validation: ${per_validation}s"
        echo "🚀 Validations/second: $(echo "scale=0; $iterations / $duration" | bc -l)"
    else
        echo "⏱️  Benchmark completed (timing unavailable)"
    fi
}

# Backward compatibility functions for legacy scripts
# These functions provide a simpler interface for basic argument validation

# Validate an argument against allowed values
# Args:
#   $1: argument_name
#   $2: value
#   $3: allowed_values (pipe-separated, e.g., "option1|option2|option3")
# Returns:
#   0: validation passed
#   1: validation failed
validate_argument() {
    local arg_name="$1"
    local value="$2"
    local allowed_values="$3"
    
    if [[ -z "$value" ]]; then
        log_error "Missing required argument: $arg_name"
        return 1
    fi
    
    # Convert pipe-separated values to array for checking
    IFS='|' read -ra allowed_array <<< "$allowed_values"
    
    for allowed in "${allowed_array[@]}"; do
        if [[ "$value" == "$allowed" ]]; then
            return 0
        fi
    done
    
    log_error "Invalid value for $arg_name: '$value'. Allowed values: $allowed_values"
    return 1
}

# Validate a boolean argument
# Args:
#   $1: argument_name
#   $2: value
# Returns:
#   0: validation passed
#   1: validation failed
validate_boolean() {
    local arg_name="$1"
    local value="$2"
    
    case "${value,,}" in
        true|false|1|0|yes|no|y|n)
            return 0
            ;;
        *)
            log_error "Invalid boolean value for $arg_name: '$value'. Expected: true/false, 1/0, yes/no, y/n"
            return 1
            ;;
    esac
}

# Show validation module information
show_validation_info() {
    cat << EOF
🔍 AI Evolution Engine - Validation Module v$VALIDATION_VERSION

Available validation rules:
$(list_validation_rules)

Usage examples:
  validate_input "email" "user@example.com"
  validate_multiple "email:user@domain.com" "port:8080" "integer:42"
  set_validation_mode "strict"
  register_validation_rule "custom_rule" "my_validator_function"

Current state:
  Mode: $([ "$VALIDATION_STRICT_MODE" == "true" ] && echo "strict" || echo "lenient")
  Errors: $VALIDATION_ERROR_COUNT
  Rules: ${#VALIDATION_RULES[@]}

Testing:
  test_validation_rules    - Test all built-in rules
  benchmark_validation     - Performance benchmark
  get_validation_errors    - Show current errors

EOF
}
