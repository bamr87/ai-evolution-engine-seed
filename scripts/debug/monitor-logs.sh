#!/bin/bash
# scripts/monitor-logs.sh
# Real-time log monitoring for GitHub Actions and local testing
# Provides live updates and analysis for debugging

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

# Configuration
LOG_DIR="./logs"
MONITOR_INTERVAL=5
MAX_TAIL_LINES=50

show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
  local       Monitor local log files
  github      Monitor GitHub Actions runs
  both        Monitor both local and GitHub (default)
  tail        Follow a specific log file

Options:
  --file FILE     Specific log file to monitor
  --interval SEC  Monitoring interval in seconds (default: 5)
  --lines NUM     Number of lines to show (default: 50)
  --filter TEXT   Filter logs containing specific text
  --help          Show this help message

Examples:
  $0 local                              # Monitor local logs
  $0 github                             # Monitor GitHub Actions
  $0 tail --file logs/latest.log        # Follow specific file
  $0 both --filter "error"              # Monitor all with error filter
EOF
}

# Function to monitor local log files
monitor_local_logs() {
    local filter_text="${1:-}"
    
    log_info "Starting local log monitoring..."
    log_info "Log directory: $LOG_DIR"
    log_info "Filter: ${filter_text:-none}"
    
    if [ ! -d "$LOG_DIR" ]; then
        log_warn "Log directory not found. Creating: $LOG_DIR"
        mkdir -p "$LOG_DIR"
    fi
    
    while true; do
        clear
        echo "=== LOCAL LOG MONITOR - $(date) ==="
        echo ""
        
        # Show available log files
        if ls "$LOG_DIR"/*.log >/dev/null 2>&1; then
            echo "📁 Available log files:"
            ls -lt "$LOG_DIR"/*.log | head -5
            echo ""
            
            # Get the most recent log file
            local recent_log=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
            
            if [ -n "$recent_log" ]; then
                echo "🔍 Monitoring: $recent_log"
                echo "📊 File size: $(du -h "$recent_log" | cut -f1)"
                if is_macos; then
                    echo "🕐 Last modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$recent_log" 2>/dev/null || echo "Unknown")"
                else
                    echo "🕐 Last modified: $(date -r "$recent_log" 2>/dev/null || echo "Unknown")"
                fi
                echo ""
                echo "--- Latest $MAX_TAIL_LINES lines ---"
                
                if [ -n "$filter_text" ]; then
                    tail -n "$MAX_TAIL_LINES" "$recent_log" | grep -i "$filter_text" --color=always || echo "No matches for '$filter_text'"
                else
                    tail -n "$MAX_TAIL_LINES" "$recent_log"
                fi
            fi
        else
            echo "📭 No log files found in $LOG_DIR"
            echo "💡 Run a local test to generate logs:"
            echo "   ./scripts/test-workflow.sh local --prompt 'Test run'"
        fi
        
        echo ""
        echo "🔄 Refreshing in $MONITOR_INTERVAL seconds... (Ctrl+C to stop)"
        sleep "$MONITOR_INTERVAL"
    done
}

# Function to monitor GitHub Actions
monitor_github_actions() {
    local filter_text="${1:-}"
    
    log_info "Starting GitHub Actions monitoring..."
    
    # Check GitHub CLI authentication
    if ! command -v gh >/dev/null 2>&1; then
        log_error "GitHub CLI not installed. Install with: brew install gh"
        exit 1
    fi
    
    if ! gh auth status >/dev/null 2>&1; then
        log_error "GitHub CLI not authenticated. Run: gh auth login"
        exit 1
    fi
    
    while true; do
        clear
        echo "=== GITHUB ACTIONS MONITOR - $(date) ==="
        echo ""
        
        # Show recent workflow runs
        echo "🚀 Recent workflow runs:"
        gh run list --limit 10 2>/dev/null || echo "Failed to fetch runs"
        echo ""
        
        # Get the most recent run
        local latest_run_id=$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || echo "")
        
        if [ -n "$latest_run_id" ] && [ "$latest_run_id" != "null" ]; then
            echo "🔍 Latest run ID: $latest_run_id"
            
            # Show run details
            echo "📋 Run details:"
            gh run view "$latest_run_id" 2>/dev/null | head -10 || echo "Failed to fetch run details"
            echo ""
            
            # Show recent logs
            echo "📜 Recent log output:"
            if [ -n "$filter_text" ]; then
                timeout 30 gh run view "$latest_run_id" --log 2>/dev/null | tail -n "$MAX_TAIL_LINES" | grep -i "$filter_text" --color=always || echo "No matches for '$filter_text'"
            else
                timeout 30 gh run view "$latest_run_id" --log 2>/dev/null | tail -n "$MAX_TAIL_LINES" || echo "Could not fetch logs"
            fi
        else
            echo "📭 No workflow runs found"
            echo "💡 Trigger a workflow run:"
            echo "   gh workflow run ai_evolver.yml"
        fi
        
        echo ""
        echo "🔄 Refreshing in $MONITOR_INTERVAL seconds... (Ctrl+C to stop)"
        sleep "$MONITOR_INTERVAL"
    done
}

# Function to monitor both local and GitHub
monitor_both() {
    local filter_text="${1:-}"
    
    log_info "Starting combined monitoring..."
    
    while true; do
        clear
        echo "=== COMBINED LOG MONITOR - $(date) ==="
        echo ""
        
        # Local logs section
        echo "🏠 === LOCAL LOGS ==="
        if [ -d "$LOG_DIR" ] && ls "$LOG_DIR"/*.log >/dev/null 2>&1; then
            local recent_local=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
            echo "📂 Latest: $(basename "$recent_local")"
            echo "📊 Size: $(du -h "$recent_local" | cut -f1)"
            echo ""
            
            if [ -n "$filter_text" ]; then
                tail -n 20 "$recent_local" | grep -i "$filter_text" --color=always || echo "No local matches"
            else
                tail -n 20 "$recent_local"
            fi
        else
            echo "📭 No local logs"
        fi
        
        echo ""
        echo "☁️  === GITHUB ACTIONS ==="
        
        # GitHub Actions section
        if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
            echo "🚀 Recent runs:"
            gh run list --limit 3 2>/dev/null || echo "Failed to fetch"
            echo ""
            
            local latest_run_id=$(gh run list --limit 1 --json databaseId,status,conclusion --jq '.[0] | "\(.databaseId) \(.status) \(.conclusion)"' 2>/dev/null || echo "")
            
            if [ -n "$latest_run_id" ]; then
                local run_id=$(echo "$latest_run_id" | cut -d' ' -f1)
                local status=$(echo "$latest_run_id" | cut -d' ' -f2)
                local conclusion=$(echo "$latest_run_id" | cut -d' ' -f3)
                
                echo "🔍 Latest: $run_id ($status/$conclusion)"
                
                if [ -n "$filter_text" ]; then
                    timeout 20 gh run view "$run_id" --log 2>/dev/null | tail -n 15 | grep -i "$filter_text" --color=always || echo "No GitHub matches"
                else
                    timeout 20 gh run view "$run_id" --log 2>/dev/null | tail -n 15 || echo "Could not fetch"
                fi
            fi
        else
            echo "⚠️  GitHub CLI not available"
        fi
        
        echo ""
        echo "🔄 Refreshing in $MONITOR_INTERVAL seconds... (Ctrl+C to stop)"
        sleep "$MONITOR_INTERVAL"
    done
}

# Function to tail a specific file
tail_specific_file() {
    local file_path="$1"
    local filter_text="${2:-}"
    
    if [ ! -f "$file_path" ]; then
        log_error "File not found: $file_path"
        exit 1
    fi
    
    log_info "Following file: $file_path"
    
    if [ -n "$filter_text" ]; then
        tail -f "$file_path" | grep -i "$filter_text" --color=always --line-buffered
    else
        tail -f "$file_path"
    fi
}

# Main script logic
main() {
    local command="${1:-both}"
    local file_path=""
    local filter_text=""
    
    # Parse arguments
    shift || true
    while [[ $# -gt 0 ]]; do
        case $1 in
            --file)
                file_path="$2"
                shift 2
                ;;
            --interval)
                MONITOR_INTERVAL="$2"
                shift 2
                ;;
            --lines)
                MAX_TAIL_LINES="$2"
                shift 2
                ;;
            --filter)
                filter_text="$2"
                shift 2
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Create logs directory if it doesn't exist
    mkdir -p "$LOG_DIR"
    
    # Execute command
    case $command in
        "local")
            monitor_local_logs "$filter_text"
            ;;
        "github")
            monitor_github_actions "$filter_text"
            ;;
        "both")
            monitor_both "$filter_text"
            ;;
        "tail")
            if [ -z "$file_path" ]; then
                log_error "File path required for tail command. Use --file option."
                exit 1
            fi
            tail_specific_file "$file_path" "$filter_text"
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n\n$(log_warn "Monitoring stopped by user")"; exit 0' INT

# Run main function
main "$@"
