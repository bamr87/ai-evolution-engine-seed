#!/bin/bash
#
# @file src/lib/core/utils.sh
# @description Common utility functions for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Comprehensive utility module with enhanced functions
#
# @dependencies
#   - bash: >=4.0
#   - coreutils: Standard Unix utilities
#
# @changelog
#   - 2025-07-05: Initial creation of enhanced utilities module - ITJ
#
# @usage require_module "core/utils"; utils_function_name
# @notes Provides cross-platform utilities and common operations
#

readonly UTILS_VERSION="2.0.0"

# String manipulation utilities
# ===========================================

# Trim whitespace from string
# Args:
#   $1: input_string
# Returns:
#   Prints trimmed string
trim() {
    local input="$1"
    # Remove leading whitespace
    input="${input#"${input%%[![:space:]]*}"}"
    # Remove trailing whitespace
    input="${input%"${input##*[![:space:]]}"}"
    echo "$input"
}

# Convert string to lowercase
# Args:
#   $1: input_string
# Returns:
#   Prints lowercase string
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Convert string to uppercase
# Args:
#   $1: input_string
# Returns:
#   Prints uppercase string
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Check if string contains substring
# Args:
#   $1: haystack
#   $2: needle
# Returns:
#   0: contains substring
#   1: does not contain substring
contains() {
    local haystack="$1"
    local needle="$2"
    [[ "$haystack" == *"$needle"* ]]
}

# Replace all occurrences of a substring
# Args:
#   $1: input_string
#   $2: search_pattern
#   $3: replacement
# Returns:
#   Prints modified string
replace_all() {
    local input="$1"
    local search="$2"
    local replace="$3"
    echo "${input//$search/$replace}"
}

# Generate random string
# Args:
#   $1: length (default: 8)
#   $2: character_set (default: alphanumeric)
# Returns:
#   Prints random string
generate_random_string() {
    local length="${1:-8}"
    local charset="${2:-alphanumeric}"
    
    case "$charset" in
        alphanumeric)
            tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$length"
            ;;
        alpha)
            tr -dc 'a-zA-Z' < /dev/urandom | head -c "$length"
            ;;
        numeric)
            tr -dc '0-9' < /dev/urandom | head -c "$length"
            ;;
        hex)
            tr -dc 'a-f0-9' < /dev/urandom | head -c "$length"
            ;;
        *)
            tr -dc "$charset" < /dev/urandom | head -c "$length"
            ;;
    esac
}

# URL encode string
# Args:
#   $1: input_string
# Returns:
#   Prints URL-encoded string
url_encode() {
    local input="$1"
    local encoded=""
    local length="${#input}"
    
    for (( i = 0; i < length; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            [a-zA-Z0-9.~_-])
                encoded+="$char"
                ;;
            *)
                encoded+=$(printf '%%%02X' "'$char")
                ;;
        esac
    done
    
    echo "$encoded"
}

# File and directory utilities
# ===========================================

# Get absolute path
# Args:
#   $1: path
# Returns:
#   Prints absolute path
get_absolute_path() {
    local path="$1"
    
    if [[ -d "$path" ]]; then
        (cd "$path" && pwd)
    elif [[ -f "$path" ]]; then
        local dir
        dir="$(dirname "$path")"
        local file
        file="$(basename "$path")"
        echo "$(cd "$dir" && pwd)/$file"
    else
        # Path doesn't exist, construct absolute path
        if [[ "$path" = /* ]]; then
            echo "$path"
        else
            echo "$(pwd)/$path"
        fi
    fi
}

# Get relative path from one directory to another
# Args:
#   $1: from_path
#   $2: to_path
# Returns:
#   Prints relative path
get_relative_path() {
    local from_path
    from_path="$(get_absolute_path "$1")"
    local to_path
    to_path="$(get_absolute_path "$2")"
    
    python3 -c "import os.path; print(os.path.relpath('$to_path', '$from_path'))" 2>/dev/null || {
        # Fallback for systems without Python
        echo "$to_path"
    }
}

# Create directory with parents if needed
# Args:
#   $1: directory_path
#   $2: permissions (optional, default: 755)
# Returns:
#   0: success
#   1: failure
ensure_directory() {
    local dir_path="$1"
    local permissions="${2:-755}"
    
    if [[ ! -d "$dir_path" ]]; then
        mkdir -p "$dir_path" && chmod "$permissions" "$dir_path"
    fi
}

# Backup file with timestamp
# Args:
#   $1: file_path
#   $2: backup_suffix (optional, default: timestamp)
# Returns:
#   0: success, prints backup path
#   1: failure
backup_file() {
    local file_path="$1"
    local suffix="${2:-$(date +%Y%m%d-%H%M%S)}"
    
    if [[ ! -f "$file_path" ]]; then
        return 1
    fi
    
    local backup_path="${file_path}.backup.${suffix}"
    cp "$file_path" "$backup_path" && echo "$backup_path"
}

# Get file size in bytes
# Args:
#   $1: file_path
# Returns:
#   Prints file size in bytes
get_file_size() {
    local file_path="$1"
    
    if [[ ! -f "$file_path" ]]; then
        echo "0"
        return 1
    fi
    
    # Cross-platform file size detection
    if command -v stat >/dev/null 2>&1; then
        if stat --version >/dev/null 2>&1; then
            # GNU stat (Linux)
            stat -c%s "$file_path"
        else
            # BSD stat (macOS)
            stat -f%z "$file_path"
        fi
    else
        # Fallback using wc
        wc -c < "$file_path"
    fi
}

# Get human-readable file size
# Args:
#   $1: file_path
# Returns:
#   Prints human-readable file size
get_human_file_size() {
    local file_path="$1"
    local size_bytes
    size_bytes="$(get_file_size "$file_path")"
    
    if [[ $size_bytes -lt 1024 ]]; then
        echo "${size_bytes}B"
    elif [[ $size_bytes -lt 1048576 ]]; then
        echo "$(( size_bytes / 1024 ))KB"
    elif [[ $size_bytes -lt 1073741824 ]]; then
        echo "$(( size_bytes / 1048576 ))MB"
    else
        echo "$(( size_bytes / 1073741824 ))GB"
    fi
}

# Date and time utilities
# ===========================================

# Get current timestamp in ISO format
# Returns:
#   Prints ISO timestamp
get_iso_timestamp() {
    date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S%z'
}

# Get current timestamp in Unix format
# Returns:
#   Prints Unix timestamp
get_unix_timestamp() {
    date +%s
}

# Get human-readable timestamp
# Args:
#   $1: format (optional, default: standard)
# Returns:
#   Prints formatted timestamp
get_human_timestamp() {
    local format="${1:-standard}"
    
    case "$format" in
        standard)
            date '+%Y-%m-%d %H:%M:%S'
            ;;
        iso)
            get_iso_timestamp
            ;;
        unix)
            get_unix_timestamp
            ;;
        compact)
            date '+%Y%m%d-%H%M%S'
            ;;
        *)
            date "+$format"
            ;;
    esac
}

# Calculate time difference in seconds
# Args:
#   $1: start_timestamp (Unix timestamp)
#   $2: end_timestamp (Unix timestamp, optional - defaults to now)
# Returns:
#   Prints time difference in seconds
time_diff() {
    local start="$1"
    local end="${2:-$(get_unix_timestamp)}"
    echo $(( end - start ))
}

# Format duration in human-readable format
# Args:
#   $1: duration_seconds
# Returns:
#   Prints human-readable duration
format_duration() {
    local duration="$1"
    
    if [[ $duration -lt 60 ]]; then
        echo "${duration}s"
    elif [[ $duration -lt 3600 ]]; then
        local minutes=$(( duration / 60 ))
        local seconds=$(( duration % 60 ))
        echo "${minutes}m${seconds}s"
    else
        local hours=$(( duration / 3600 ))
        local minutes=$(( (duration % 3600) / 60 ))
        local seconds=$(( duration % 60 ))
        echo "${hours}h${minutes}m${seconds}s"
    fi
}

# Process and system utilities
# ===========================================

# Check if process is running
# Args:
#   $1: process_name or PID
# Returns:
#   0: process is running
#   1: process is not running
is_process_running() {
    local process="$1"
    
    if [[ "$process" =~ ^[0-9]+$ ]]; then
        # Check by PID
        kill -0 "$process" 2>/dev/null
    else
        # Check by process name
        pgrep "$process" >/dev/null 2>&1
    fi
}

# Get system memory usage percentage
# Returns:
#   Prints memory usage percentage
get_memory_usage() {
    if command -v free >/dev/null 2>&1; then
        # Linux
        free | awk 'NR==2{printf "%.0f", $3*100/$2}'
    elif [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        vm_stat | awk '
            /Pages free/ { free = $3 }
            /Pages active/ { active = $3 }
            /Pages inactive/ { inactive = $3 }
            /Pages speculative/ { speculative = $3 }
            /Pages wired/ { wired = $3 }
            END {
                total = free + active + inactive + speculative + wired
                used = active + inactive + wired
                printf "%.0f", used * 100 / total
            }'
    else
        echo "Unknown"
    fi
}

# Get system CPU usage percentage
# Returns:
#   Prints CPU usage percentage
get_cpu_usage() {
    if command -v top >/dev/null 2>&1; then
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS
            top -l 1 -n 0 | awk '/CPU usage/ {printf "%.0f", 100-$7}'
        else
            # Linux
            top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f", 100-$8}'
        fi
    else
        echo "Unknown"
    fi
}

# Validation utilities
# ===========================================

# Validate email address format
# Args:
#   $1: email_address
# Returns:
#   0: valid email
#   1: invalid email
is_valid_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Validate URL format
# Args:
#   $1: url
# Returns:
#   0: valid URL
#   1: invalid URL
is_valid_url() {
    local url="$1"
    [[ "$url" =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]]
}

# Validate IP address format
# Args:
#   $1: ip_address
# Returns:
#   0: valid IP
#   1: invalid IP
is_valid_ip() {
    local ip="$1"
    [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && {
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            [[ $octet -ge 0 && $octet -le 255 ]] || return 1
        done
        return 0
    }
    return 1
}

# Validate semantic version format
# Args:
#   $1: version_string
# Returns:
#   0: valid semantic version
#   1: invalid semantic version
is_valid_semver() {
    local version="$1"
    [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$ ]]
}

# Network utilities
# ===========================================

# Check if network connection is available
# Args:
#   $1: host (optional, default: 8.8.8.8)
#   $2: timeout (optional, default: 5)
# Returns:
#   0: network is available
#   1: network is not available
is_network_available() {
    local host="${1:-8.8.8.8}"
    local timeout="${2:-5}"
    
    if command -v ping >/dev/null 2>&1; then
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS ping
            ping -c 1 -t "$timeout" "$host" >/dev/null 2>&1
        else
            # Linux ping
            ping -c 1 -W "$timeout" "$host" >/dev/null 2>&1
        fi
    else
        # Fallback using nc if available
        if command -v nc >/dev/null 2>&1; then
            nc -z -w "$timeout" "$host" 53 >/dev/null 2>&1
        else
            return 1
        fi
    fi
}

# Download file with progress and retry
# Args:
#   $1: url
#   $2: output_file
#   $3: max_retries (optional, default: 3)
# Returns:
#   0: success
#   1: failure
download_file() {
    local url="$1"
    local output_file="$2"
    local max_retries="${3:-3}"
    
    local attempt=1
    while [[ $attempt -le $max_retries ]]; do
        if command -v curl >/dev/null 2>&1; then
            if curl -fSL --progress-bar -o "$output_file" "$url"; then
                return 0
            fi
        elif command -v wget >/dev/null 2>&1; then
            if wget --progress=bar -O "$output_file" "$url"; then
                return 0
            fi
        else
            return 1
        fi
        
        ((attempt++))
        [[ $attempt -le $max_retries ]] && sleep 2
    done
    
    return 1
}

# Array utilities
# ===========================================

# Check if array contains element
# Args:
#   $1: element
#   $2-$N: array elements
# Returns:
#   0: array contains element
#   1: array does not contain element
array_contains() {
    local element="$1"
    shift
    local array=("$@")
    
    for item in "${array[@]}"; do
        [[ "$item" == "$element" ]] && return 0
    done
    return 1
}

# Join array elements with delimiter
# Args:
#   $1: delimiter
#   $2-$N: array elements
# Returns:
#   Prints joined string
join_array() {
    local delimiter="$1"
    shift
    local array=("$@")
    
    local result=""
    for item in "${array[@]}"; do
        [[ -n "$result" ]] && result+="$delimiter"
        result+="$item"
    done
    echo "$result"
}

# Remove duplicates from array
# Args:
#   $1-$N: array elements
# Returns:
#   Prints unique elements, one per line
unique_array() {
    local array=("$@")
    printf '%s\n' "${array[@]}" | sort -u
}

# JSON utilities (if jq is available)
# ===========================================

# Pretty print JSON
# Args:
#   $1: json_string or file
# Returns:
#   Prints formatted JSON
json_pretty() {
    local input="$1"
    
    if ! command -v jq >/dev/null 2>&1; then
        echo "$input"
        return 1
    fi
    
    if [[ -f "$input" ]]; then
        jq '.' "$input"
    else
        echo "$input" | jq '.'
    fi
}

# Extract value from JSON
# Args:
#   $1: json_string or file
#   $2: jq_expression
# Returns:
#   Prints extracted value
json_extract() {
    local input="$1"
    local expression="$2"
    
    if ! command -v jq >/dev/null 2>&1; then
        return 1
    fi
    
    if [[ -f "$input" ]]; then
        jq -r "$expression" "$input"
    else
        echo "$input" | jq -r "$expression"
    fi
}

# Error handling utilities
# ===========================================

# Retry function with exponential backoff
# Args:
#   $1: max_attempts
#   $2: base_delay (seconds)
#   $3-$N: command to execute
# Returns:
#   Exit code of the command
retry_with_backoff() {
    local max_attempts="$1"
    local base_delay="$2"
    shift 2
    local command=("$@")
    
    local attempt=1
    local delay="$base_delay"
    
    while [[ $attempt -le $max_attempts ]]; do
        if "${command[@]}"; then
            return 0
        fi
        
        if [[ $attempt -lt $max_attempts ]]; then
            sleep "$delay"
            delay=$((delay * 2))
        fi
        
        ((attempt++))
    done
    
    return 1
}

# Performance monitoring
# ===========================================

# Measure execution time of a command
# Args:
#   $1-$N: command to execute
# Returns:
#   Prints execution time and runs the command
measure_time() {
    local start_time
    start_time="$(get_unix_timestamp)"
    
    "$@"
    local exit_code=$?
    
    local end_time
    end_time="$(get_unix_timestamp)"
    local duration
    duration="$(time_diff "$start_time" "$end_time")"
    
    echo "⏱️  Execution time: $(format_duration "$duration")" >&2
    return $exit_code
}

# Show module information
show_utils_info() {
    cat << EOF
🛠️  AI Evolution Engine - Utilities Module v$UTILS_VERSION

Available function categories:
  📝 String manipulation: trim, to_lower, to_upper, contains, replace_all, etc.
  📁 File operations: get_absolute_path, ensure_directory, backup_file, etc.
  ⏰ Date/time: get_iso_timestamp, format_duration, time_diff, etc.
  🔍 Process monitoring: is_process_running, get_memory_usage, get_cpu_usage
  ✅ Validation: is_valid_email, is_valid_url, is_valid_ip, is_valid_semver
  🌐 Network: is_network_available, download_file
  🔢 Array operations: array_contains, join_array, unique_array
  📊 JSON utilities: json_pretty, json_extract (requires jq)
  🔄 Error handling: retry_with_backoff
  📈 Performance: measure_time

Use 'type function_name' to see individual function documentation.
EOF
}
