#!/bin/bash
#
# @file tests/manage-test-artifacts.sh
# @description Test artifact management script for AI Evolution Engine with category-specific storage
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - #test-artifact-management: Comprehensive artifact lifecycle management
#   - #test-framework-reorganization: Category-specific artifact directories
#
# @relatedEvolutions
#   - v2.0.0: Major restructure for category-specific artifact management
#   - v1.0.0: Initial implementation with basic artifact management
#
# @dependencies
#   - bash: >=4.0
#   - find: for file system operations
#   - tar: for archiving operations
#   - jq: for JSON processing
#
# @changelog
#   - 2025-07-05: Restructured for category-specific artifact directories - ITJ
#   - 2025-07-05: Added proper file header and enhanced functionality - ITJ
#
# @usage ./manage-test-artifacts.sh <command> [options]
# @notes Provides commands for archiving, cleaning up, and managing test artifacts across categories
#

# Test artifact management script for AI Evolution Engine
# Provides commands for archiving, cleaning up, and managing test outputs

set -euo pipefail

# Save script location before sourcing other scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Configuration  
TEST_BASE_DIR="$SCRIPT_DIR"

# Test categories with artifact directories
TEST_CATEGORIES=("unit" "integration" "unit/workflows")
ARTIFACT_TYPES=("logs" "results" "reports")

# Simple logging functions
log_info() { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; }
log_success() { echo "[SUCCESS] $*"; }

# Debug information
log_info "Script directory: $SCRIPT_DIR"
log_info "Project root: $PROJECT_ROOT"
log_info "Test base directory: $TEST_BASE_DIR"

# Show usage information
show_usage() {
    cat << EOF
Test Artifact Management Script

Usage: $0 <command> [options]

Commands:
    status                  Show current test artifacts status
    cleanup [keep-reports]  Clean up test artifacts (optionally keep reports)
    archive [name]          Archive current test artifacts
    auto-cleanup [days]     Clean up artifacts older than specified days (default: 7)
    purge                   Remove all test artifacts including archives

Options:
    keep-reports           When cleaning up, preserve test reports
    -h, --help            Show this help message

Examples:
    $0 status                    # Show what test artifacts exist
    $0 cleanup                   # Remove all temporary test artifacts
    $0 cleanup keep-reports      # Remove artifacts but keep reports
    $0 archive "sprint-1-tests"  # Archive with custom name
    $0 auto-cleanup 3           # Remove artifacts older than 3 days
    $0 purge                    # Remove everything including archives

Test Artifact Structure:
    tests/
    ├── test-results/           # JSON test result files (temporary)
    ├── test-reports/           # Markdown/HTML reports (temporary)
    ├── test-logs/              # Execution logs (temporary)
    └── archives/               # Long-term storage (optional)
EOF
}

# Show current status of test artifacts
show_status() {
    local target_category="${1:-}"
    
    log_info "Test Artifacts Status for: $TEST_BASE_DIR"
    
    if [[ -n "$target_category" ]]; then
        log_info "Filtering by category: $target_category"
        show_category_status "$target_category"
    else
        log_info "Showing all categories"
        for category in "${TEST_CATEGORIES[@]}"; do
            show_category_status "$category"
        done
    fi
    
    # Check archives
    show_archives_status
}

# Show status for a specific test category
show_category_status() {
    local category="$1"
    local category_path="$TEST_BASE_DIR/$category"
    
    echo ""
    log_info "📂 Category: $category"
    
    if [[ ! -d "$category_path" ]]; then
        log_info "  ❌ Category directory not found: $category_path"
        return
    fi
    
    # Check each artifact type in this category
    for artifact_type in "${ARTIFACT_TYPES[@]}"; do
        local artifact_path="$category_path/$artifact_type"
        
        if [[ -d "$artifact_path" ]]; then
            local file_count=$(find "$artifact_path" -type f | wc -l)
            local dir_size=$(du -sh "$artifact_path" 2>/dev/null | cut -f1 || echo "unknown")
            local latest_file=$(find "$artifact_path" -type f -exec stat -f "%m %N" {} \; 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)
            local age="unknown"
            
            if [[ -n "$latest_file" ]]; then
                age=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$latest_file" 2>/dev/null || echo "unknown")
            fi
            
            log_info "    📁 $artifact_type: $file_count files, $dir_size (latest: $age)"
            
            # Show sample files if verbose
            if [[ "$file_count" -gt 0 ]]; then
                echo "      Recent files:"
                find "$artifact_path" -type f | head -3 | while read -r file; do
                    echo "        - $(basename "$file")"
                done
                if [[ "$file_count" -gt 3 ]]; then
                    echo "        ... and $((file_count - 3)) more"
                fi
            fi
        else
            log_info "    📁 $artifact_type: not found"
        fi
    done
}

# Show archives status
show_archives_status() {
    local archive_dir="$TEST_BASE_DIR/archives"
    
    echo ""
    log_info "📦 Archives"
    
    if [[ -d "$archive_dir" ]]; then
        local archive_count=$(find "$archive_dir" -name "*.tar.gz" | wc -l)
        if [[ "$archive_count" -gt 0 ]]; then
            local archive_size=$(du -sh "$archive_dir" 2>/dev/null | cut -f1 || echo "unknown")
            log_info "  $archive_count files, $archive_size total"
            
            echo "  Available archives:"
            find "$archive_dir" -name "*.tar.gz" | sort | while read -r archive; do
                local name=$(basename "$archive" .tar.gz)
                local size=$(du -sh "$archive" 2>/dev/null | cut -f1 || echo "unknown")
                local date=$(stat -f "%Sm" -t "%Y-%m-%d" "$archive" 2>/dev/null || echo "unknown")
                echo "    - $name ($size, created: $date)"
            done
        else
            log_info "  Directory exists but empty"
        fi
    else
        log_info "  Directory not found"
    fi
}

# Clean up test artifacts
cleanup_artifacts() {
    local keep_reports="${1:-false}"
    local target_category="${2:-}"
    
    log_info "Cleaning up test artifacts..."
    
    # Set test base directory for cleanup functions
    TEST_BASE_DIR="$SCRIPT_DIR"
    TEST_RESULTS_DIR="$TEST_BASE_DIR/test-results"
    TEST_REPORTS_DIR="$TEST_BASE_DIR/test-reports"
    TEST_LOGS_DIR="$TEST_BASE_DIR/test-logs"
    
    cleanup_test_artifacts "$keep_reports"
    
    log_success "Cleanup completed"
}

# Archive current test artifacts
archive_artifacts() {
    local archive_name="${1:-test-archive-$(date +%Y%m%d-%H%M%S)}"
    
    # Set test base directory for archive functions
    TEST_BASE_DIR="$SCRIPT_DIR"
    
    # Check if there are artifacts to archive
    local has_artifacts=false
    for dir in test-results test-reports test-logs; do
        if [[ -d "$TEST_BASE_DIR/$dir" ]] && [[ $(find "$TEST_BASE_DIR/$dir" -type f | wc -l) -gt 0 ]]; then
            has_artifacts=true
            break
        fi
    done
    
    if [[ "$has_artifacts" == "false" ]]; then
        log_warn "No test artifacts found to archive"
        return 1
    fi
    
    archive_test_results "$archive_name"
}

# Auto-cleanup old artifacts
auto_cleanup_artifacts() {
    local max_age_days="${1:-7}"
    
    log_info "Auto-cleaning artifacts older than $max_age_days days..."
    
    cleanup_old_test_artifacts "$max_age_days" "$SCRIPT_DIR"
    
    log_success "Auto-cleanup completed"
}

# Purge all test artifacts including archives
purge_all_artifacts() {
    log_warn "This will permanently delete ALL test artifacts including archives!"
    
    # In non-interactive mode, require explicit confirmation
    if [[ "${PURGE_CONFIRM:-false}" != "true" ]]; then
        log_error "Purge operation requires explicit confirmation"
        log_info "Set PURGE_CONFIRM=true to confirm this destructive operation"
        return 1
    fi
    
    log_info "Purging all test artifacts..."
    
    # Remove all test directories
    for dir in test-results test-reports test-logs archives; do
        local full_path="$TEST_BASE_DIR/$dir"
        if [[ -d "$full_path" ]]; then
            log_info "Removing: $full_path"
            rm -rf "$full_path"
        fi
    done
    
    # Clean up any temporary files
    rm -rf /tmp/test-output-* 2>/dev/null || true
    
    log_success "All test artifacts purged"
}

# Main command processing
main() {
    local command="${1:-status}"
    shift || true
    
    case "$command" in
        "status")
            # Parse category argument
            local category=""
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --category)
                        category="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            show_status "$category"
            ;;
        "cleanup")
            # Parse cleanup arguments
            local keep_reports="false"
            local category=""
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --keep-reports)
                        keep_reports="true"
                        shift
                        ;;
                    --category)
                        category="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            cleanup_artifacts "$keep_reports" "$category"
            ;;
        "archive")
            archive_artifacts "$@"
            ;;
        "auto-cleanup")
            auto_cleanup_artifacts "$@"
            ;;
        "purge-all")
            # Check for confirmation
            local confirmed="false"
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --confirm)
                        confirmed="true"
                        shift
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            
            if [[ "$confirmed" == "true" ]]; then
                purge_all_artifacts
            else
                log_error "Purge command requires --confirm flag for safety"
                exit 1
            fi
            ;;
        "list-archives")
            show_archives_status
            ;;
        "-h"|"--help"|"help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
