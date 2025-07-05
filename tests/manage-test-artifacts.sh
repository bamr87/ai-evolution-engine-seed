#!/bin/bash
# tests/manage-test-artifacts.sh
# Test artifact management script for AI Evolution Engine
# Provides commands for archiving, cleaning up, and managing test outputs

set -euo pipefail

# Save script location before sourcing other scripts
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TESTS_DIR}/.." && pwd)"

# Configuration  
TEST_BASE_DIR="$TESTS_DIR"

# Source modular libraries  
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/testing.sh"

# Initialize logger in tests directory (use relative path)
init_logger "test-logs" "test-management"

# Debug information
log_info "Tests directory: $TESTS_DIR"
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
    log_info "Test Artifacts Status for: $TEST_BASE_DIR"
    echo ""
    
    # Check each test artifact directory
    for dir in test-results test-reports test-logs; do
        local full_path="$TEST_BASE_DIR/$dir"
        if [[ -d "$full_path" ]]; then
            local file_count=$(find "$full_path" -type f | wc -l)
            local dir_size=$(du -sh "$full_path" 2>/dev/null | cut -f1 || echo "unknown")
            local latest_file=$(find "$full_path" -type f -name "*.json" -o -name "*.log" -o -name "*.md" | head -1)
            local age="unknown"
            
            if [[ -n "$latest_file" ]]; then
                age=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$latest_file" 2>/dev/null || echo "unknown")
            fi
            
            log_info "  📁 $dir: $file_count files, $dir_size (latest: $age)"
            
            # Show sample files if verbose
            if [[ "$file_count" -gt 0 ]]; then
                echo "    Recent files:"
                find "$full_path" -type f | head -3 | while read -r file; do
                    echo "      - $(basename "$file")"
                done
                if [[ "$file_count" -gt 3 ]]; then
                    echo "      ... and $((file_count - 3)) more"
                fi
            fi
        else
            log_info "  📁 $dir: not found"
        fi
        echo ""
    done
    
    # Check archives
    local archive_dir="$TEST_BASE_DIR/archives"
    if [[ -d "$archive_dir" ]]; then
        local archive_count=$(find "$archive_dir" -name "*.tar.gz" | wc -l)
        if [[ "$archive_count" -gt 0 ]]; then
            local archive_size=$(du -sh "$archive_dir" 2>/dev/null | cut -f1 || echo "unknown")
            log_info "  📦 archives: $archive_count files, $archive_size"
            
            echo "    Available archives:"
            find "$archive_dir" -name "*.tar.gz" | sort | while read -r archive; do
                local name=$(basename "$archive" .tar.gz)
                local size=$(du -sh "$archive" 2>/dev/null | cut -f1 || echo "unknown")
                echo "      - $name ($size)"
            done
        else
            log_info "  📦 archives: directory exists but empty"
        fi
    else
        log_info "  📦 archives: not found"
    fi
    
    echo ""
    
    # Disk usage summary
    local total_size=$(du -sh "$TEST_BASE_DIR" 2>/dev/null | cut -f1 || echo "unknown")
    log_info "Total test directory size: $total_size"
}

# Clean up test artifacts
cleanup_artifacts() {
    local keep_reports="${1:-false}"
    
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
            show_status
            ;;
        "cleanup")
            cleanup_artifacts "$@"
            ;;
        "archive")
            archive_artifacts "$@"
            ;;
        "auto-cleanup")
            auto_cleanup_artifacts "$@"
            ;;
        "purge")
            purge_all_artifacts
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
