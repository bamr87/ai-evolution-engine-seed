#!/bin/bash
#
# @file src/lib/utils/file_operations.sh
# @description File operations and manipulation utilities for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Modular refactoring: Extract file operation utilities
#
# @relatedEvolutions
#   - v1.0.0: Initial creation during modular refactoring
#
# @dependencies
#   - bash: >=4.0
#   - find, sed, awk: Standard POSIX utilities
#
# @changelog
#   - 2025-07-07: Initial creation with file operation functions - ITJ
#
# @usage require_module "utils/file_operations"
# @notes Provides standardized file manipulation and content processing
#

# Prevent multiple imports
[[ "${__FILE_OPERATIONS_LOADED:-}" == "true" ]] && return 0
readonly __FILE_OPERATIONS_LOADED=true

# Module dependencies
require_module "core/logger"
require_module "core/validation"

#
# Safely backup a file before modification
#
# Arguments:
#   $1 - file_path: Path to file to backup
#   $2 - backup_suffix: Suffix for backup file (default: .bak)
#
# Returns:
#   0 on success, 1 on failure
#
file_backup() {
    local file_path="$1"
    local backup_suffix="${2:-.bak}"
    
    validate_required "file_path" "$file_path"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "File not found for backup: $file_path"
        return 1
    fi
    
    local backup_path="${file_path}${backup_suffix}"
    
    if cp "$file_path" "$backup_path"; then
        log_debug "File backed up: $file_path -> $backup_path"
        return 0
    else
        log_error "Failed to backup file: $file_path"
        return 1
    fi
}

#
# Restore file from backup
#
# Arguments:
#   $1 - file_path: Original file path
#   $2 - backup_suffix: Backup file suffix (default: .bak)
#
# Returns:
#   0 on success, 1 on failure
#
file_restore() {
    local file_path="$1"
    local backup_suffix="${2:-.bak}"
    
    validate_required "file_path" "$file_path"
    
    local backup_path="${file_path}${backup_suffix}"
    
    if [[ ! -f "$backup_path" ]]; then
        log_error "Backup file not found: $backup_path"
        return 1
    fi
    
    if mv "$backup_path" "$file_path"; then
        log_info "File restored from backup: $file_path"
        return 0
    else
        log_error "Failed to restore file: $file_path"
        return 1
    fi
}

#
# Replace content between markers in a file
#
# Arguments:
#   $1 - file_path: Path to file to modify
#   $2 - start_marker: Start marker string
#   $3 - end_marker: End marker string
#   $4 - new_content: Content to insert between markers
#
# Returns:
#   0 on success, 1 on failure
#
file_replace_between_markers() {
    local file_path="$1"
    local start_marker="$2"
    local end_marker="$3"
    local new_content="$4"
    
    validate_required "file_path" "$file_path"
    validate_required "start_marker" "$start_marker"
    validate_required "end_marker" "$end_marker"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    # Create backup
    file_backup "$file_path" || return 1
    
    # Use awk for safer multiline replacement
    local temp_file=$(mktemp)
    
    awk -v start="$start_marker" -v end="$end_marker" -v content="$new_content" '
    BEGIN { in_section = 0 }
    $0 ~ start { 
        print $0
        print content
        in_section = 1
        next
    }
    $0 ~ end && in_section { 
        print $0
        in_section = 0
        next
    }
    !in_section { print }
    ' "$file_path" > "$temp_file"
    
    if mv "$temp_file" "$file_path"; then
        log_success "Content replaced between markers in: $file_path"
        return 0
    else
        log_error "Failed to replace content in: $file_path"
        rm -f "$temp_file"
        return 1
    fi
}

#
# Ensure directory exists, create if necessary
#
# Arguments:
#   $1 - dir_path: Directory path to ensure
#
# Returns:
#   0 on success, 1 on failure
#
ensure_directory() {
    local dir_path="$1"
    
    validate_required "dir_path" "$dir_path"
    
    if [[ -d "$dir_path" ]]; then
        log_debug "Directory already exists: $dir_path"
        return 0
    fi
    
    if mkdir -p "$dir_path"; then
        log_debug "Directory created: $dir_path"
        return 0
    else
        log_error "Failed to create directory: $dir_path"
        return 1
    fi
}

#
# Find files matching pattern recursively
#
# Arguments:
#   $1 - search_path: Directory to search in
#   $2 - pattern: File pattern to match
#   $3 - max_depth: Maximum search depth (optional)
#
# Returns:
#   0 on success, prints matching files
#
find_files() {
    local search_path="$1"
    local pattern="$2"
    local max_depth="${3:-}"
    
    validate_required "search_path" "$search_path"
    validate_required "pattern" "$pattern"
    
    if [[ ! -d "$search_path" ]]; then
        log_error "Search path not found: $search_path"
        return 1
    fi
    
    local find_cmd="find '$search_path'"
    
    if [[ -n "$max_depth" ]]; then
        find_cmd="$find_cmd -maxdepth $max_depth"
    fi
    
    find_cmd="$find_cmd -name '$pattern' -type f"
    
    eval "$find_cmd"
}

#
# Count lines in a file
#
# Arguments:
#   $1 - file_path: Path to file
#
# Returns:
#   Prints line count, 0 on success
#
file_line_count() {
    local file_path="$1"
    
    validate_required "file_path" "$file_path"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    wc -l < "$file_path" | tr -d ' '
}

#
# Check if file contains string
#
# Arguments:
#   $1 - file_path: Path to file
#   $2 - search_string: String to search for
#
# Returns:
#   0 if found, 1 if not found
#
file_contains() {
    local file_path="$1"
    local search_string="$2"
    
    validate_required "file_path" "$file_path"
    validate_required "search_string" "$search_string"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    if grep -q "$search_string" "$file_path"; then
        return 0
    else
        return 1
    fi
}

#
# Get file modification time in ISO format
#
# Arguments:
#   $1 - file_path: Path to file
#
# Returns:
#   Prints ISO timestamp, 0 on success
#
file_modification_time() {
    local file_path="$1"
    
    validate_required "file_path" "$file_path"
    
    if [[ ! -f "$file_path" ]]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    # Cross-platform date formatting
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$file_path"
    else
        # Linux
        stat -c "%y" "$file_path" | sed 's/ /T/' | sed 's/\.[0-9]* /Z/'
    fi
}

# Export functions
export -f file_backup
export -f file_restore
export -f file_replace_between_markers
export -f ensure_directory
export -f find_files
export -f file_line_count
export -f file_contains
export -f file_modification_time

log_debug "File operations module loaded"
