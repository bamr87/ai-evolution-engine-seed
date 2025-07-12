#!/bin/bash
#
# @file scripts/collect-workflow-errors.sh
# @description Collects and aggregates errors and warnings from workflow runs for comprehensive issue tracking
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-01-27
# @lastModified 2025-01-27
# @version 1.0.0
#
# @relatedIssues 
#   - #workflow-error-logging: Enhance workflow files to capture and log errors and warnings
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation for comprehensive error and warning collection
#
# @dependencies
#   - ../src/lib/core/logger.sh: Modular logging system
#   - jq: JSON processing
#   - GitHub Actions environment variables
#
# @changelog
#   - 2025-01-27: Initial creation with error collection and summary functionality - ITJ
#
# @usage ./scripts/collect-workflow-errors.sh [--workflow-type TYPE] [--job-status STATUS] [--output-file FILE]
# @notes Designed to run as final step in GitHub Actions workflows
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Default values
WORKFLOW_TYPE="unknown"
JOB_STATUS="unknown"
OUTPUT_FILE=""
ERRORS_COLLECTED=0
WARNINGS_COLLECTED=0
WORKFLOW_ID="${GITHUB_RUN_ID:-$(date +%Y%m%d-%H%M%S)}"
WORKFLOW_ATTEMPT="${GITHUB_RUN_ATTEMPT:-1}"

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize arrays for collecting issues
declare -a ERRORS=()
declare -a WARNINGS=()
declare -a STEPS_WITH_ISSUES=()

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Collects and aggregates errors and warnings from GitHub Actions workflow runs.

Options:
    --workflow-type TYPE    Type of workflow (ai_evolver, testing_automation, daily_evolution, periodic_evolution)
    --job-status STATUS     Current job status (success, failure, cancelled)
    --output-file FILE      Path to save error summary (default: logs/workflow-errors-TIMESTAMP.json)
    --collect-from-logs     Scan log files for additional errors/warnings
    --include-context       Include additional context information
    --help                  Show this help message

Environment Variables (automatically set by GitHub Actions):
    GITHUB_RUN_ID          Workflow run ID
    GITHUB_RUN_ATTEMPT     Workflow run attempt number
    GITHUB_JOB             Current job name
    GITHUB_STEP_SUMMARY    Path to step summary file

Examples:
    $0 --workflow-type ai_evolver --job-status success
    $0 --workflow-type daily_evolution --job-status failure --collect-from-logs
    $0 --output-file /tmp/errors.json --include-context
EOF
}

# Function to log with color
log_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}$message${NC}"
}

# Function to extract errors from step outputs
collect_step_errors() {
    log_colored "$BLUE" "🔍 Collecting errors from workflow steps..."
    
    # Temporarily disable strict error checking for grep operations
    set +e
    
    # Check for failed steps in GITHUB_STEP_SUMMARY if available
    if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]] && [[ -f "${GITHUB_STEP_SUMMARY}" ]]; then
        log_colored "$BLUE" "📋 Analyzing step summary..."
        
        # Look for error patterns in step summary
        while IFS= read -r line; do
            if echo "$line" | grep -qi "ERROR\|FAILED\|❌\|error\|failed"; then
                ERRORS+=("Step Summary: $line")
                ((ERRORS_COLLECTED++))
            elif echo "$line" | grep -qi "WARNING\|WARN\|⚠️\|warning"; then
                WARNINGS+=("Step Summary: $line")
                ((WARNINGS_COLLECTED++))
            fi
        done < "${GITHUB_STEP_SUMMARY}"
    fi
    
    # Check for errors in recent log files
    if [[ -d "$PROJECT_ROOT/logs" ]]; then
        log_colored "$BLUE" "📂 Scanning log files for errors..."
        
        # Find recent log files (last 24 hours)
        while IFS= read -r -d '' logfile; do
            if [[ -f "$logfile" ]]; then
                # Extract filename for context
                local filename=$(basename "$logfile")
                
                # Scan for error patterns
                while IFS= read -r line; do
                    if echo "$line" | grep -qi "ERROR\|FAILED\|Fatal\|Exception\|error\|failed"; then
                        ERRORS+=("$filename: $line")
                        ((ERRORS_COLLECTED++))
                    elif echo "$line" | grep -qi "WARNING\|WARN\|deprecated\|warning"; then
                        WARNINGS+=("$filename: $line")
                        ((WARNINGS_COLLECTED++))
                    fi
                done < <(tail -n 100 "$logfile" 2>/dev/null || true)
            fi
        done < <(find "$PROJECT_ROOT/logs" -name "*.log" -o -name "*.json" -newermt "24 hours ago" -print0 2>/dev/null || true)
    fi
    
    # Re-enable strict error checking
    set -e
}

# Function to collect errors from specific step outputs
collect_from_step_outputs() {
    log_colored "$BLUE" "🎯 Collecting from step outputs..."
    
    # Temporarily disable strict error checking for grep operations
    set +e
    
    # Common error patterns to look for
    local error_patterns=(
        "exit code [1-9]"
        "command not found"
        "permission denied"
        "timeout"
        "failed"
        "error"
        "exception"
        "fatal"
    )
    
    local warning_patterns=(
        "warning"
        "deprecated"
        "skipping"
        "falling back"
        "retry"
    )
    
    # If we're in a GitHub Actions environment, we might have access to job logs
    # For now, we'll simulate collecting from environment or previous steps
    if [[ -n "${GITHUB_JOB:-}" ]]; then
        # Check if there are any environment variables that indicate errors
        for var in $(env | grep -E "(ERROR|FAILED|WARNING)" || true); do
            if echo "$var" | grep -qi "ERROR\|FAILED\|error\|failed"; then
                ERRORS+=("Environment: $var")
                ((ERRORS_COLLECTED++))
            elif echo "$var" | grep -qi "WARNING"; then
                WARNINGS+=("Environment: $var")
                ((WARNINGS_COLLECTED++))
            fi
        done
    fi
    
    # Re-enable strict error checking
    set -e
}

# Function to generate comprehensive error summary
generate_error_summary() {
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local summary_file="${OUTPUT_FILE:-$PROJECT_ROOT/logs/workflow-errors-$(date +%Y%m%d-%H%M%S).json}"
    
    log_colored "$BLUE" "📊 Generating error summary..."
    
    # Ensure logs directory exists
    mkdir -p "$(dirname "$summary_file")"
    
    # Create JSON summary
    cat > "$summary_file" << EOF
{
  "workflow_error_summary": {
    "metadata": {
      "generated_at": "$timestamp",
      "workflow_type": "$WORKFLOW_TYPE",
      "workflow_id": "$WORKFLOW_ID",
      "workflow_attempt": "$WORKFLOW_ATTEMPT",
      "job_status": "$JOB_STATUS",
      "job_name": "${GITHUB_JOB:-unknown}",
      "repository": "${GITHUB_REPOSITORY:-unknown}",
      "ref": "${GITHUB_REF:-unknown}",
      "actor": "${GITHUB_ACTOR:-unknown}"
    },
    "summary": {
      "total_errors": $ERRORS_COLLECTED,
      "total_warnings": $WARNINGS_COLLECTED,
      "overall_status": "$([ $ERRORS_COLLECTED -eq 0 ] && echo "clean" || echo "has_issues")",
      "severity": "$([ $ERRORS_COLLECTED -gt 0 ] && echo "high" || [ $WARNINGS_COLLECTED -gt 0 ] && echo "medium" || echo "low")"
    },
    "errors": [
EOF

    # Add errors to JSON
    local first=true
    for error in "${ERRORS[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$summary_file"
        fi
        echo -n "      \"$(echo "$error" | sed 's/"/\\"/g')\"" >> "$summary_file"
    done
    
    cat >> "$summary_file" << EOF

    ],
    "warnings": [
EOF

    # Add warnings to JSON
    first=true
    for warning in "${WARNINGS[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo "," >> "$summary_file"
        fi
        echo -n "      \"$(echo "$warning" | sed 's/"/\\"/g')\"" >> "$summary_file"
    done

    cat >> "$summary_file" << EOF

    ],
    "recommendations": [
EOF

    # Generate recommendations based on found issues
    first=true
    if [[ $ERRORS_COLLECTED -gt 0 ]]; then
        if [[ "$first" == "true" ]]; then first=false; else echo "," >> "$summary_file"; fi
        echo -n "      \"Review and fix $ERRORS_COLLECTED error(s) before next workflow run\"" >> "$summary_file"
    fi
    
    if [[ $WARNINGS_COLLECTED -gt 0 ]]; then
        if [[ "$first" == "true" ]]; then first=false; else echo "," >> "$summary_file"; fi
        echo -n "      \"Address $WARNINGS_COLLECTED warning(s) to improve workflow reliability\"" >> "$summary_file"
    fi
    
    if [[ $ERRORS_COLLECTED -eq 0 && $WARNINGS_COLLECTED -eq 0 ]]; then
        echo -n "      \"Workflow completed successfully with no issues detected\"" >> "$summary_file"
    fi

    cat >> "$summary_file" << EOF

    ]
  }
}
EOF

    log_colored "$GREEN" "✅ Error summary saved to: $summary_file"
    echo "$summary_file"
}

# Function to display console summary
display_console_summary() {
    log_colored "$BLUE" "📋 WORKFLOW ERROR & WARNING SUMMARY"
    echo "=================================================="
    echo "Workflow Type: $WORKFLOW_TYPE"
    echo "Workflow ID: $WORKFLOW_ID"
    echo "Job Status: $JOB_STATUS"
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo ""
    
    if [[ $ERRORS_COLLECTED -gt 0 ]]; then
        log_colored "$RED" "❌ ERRORS FOUND ($ERRORS_COLLECTED):"
        for error in "${ERRORS[@]}"; do
            log_colored "$RED" "  • $error"
        done
        echo ""
    fi
    
    if [[ $WARNINGS_COLLECTED -gt 0 ]]; then
        log_colored "$YELLOW" "⚠️  WARNINGS FOUND ($WARNINGS_COLLECTED):"
        for warning in "${WARNINGS[@]}"; do
            log_colored "$YELLOW" "  • $warning"
        done
        echo ""
    fi
    
    if [[ $ERRORS_COLLECTED -eq 0 && $WARNINGS_COLLECTED -eq 0 ]]; then
        log_colored "$GREEN" "✅ NO ISSUES DETECTED"
        log_colored "$GREEN" "   Workflow completed successfully!"
    else
        log_colored "$BLUE" "📊 SUMMARY:"
        echo "   Total Errors: $ERRORS_COLLECTED"
        echo "   Total Warnings: $WARNINGS_COLLECTED"
        echo "   Severity: $([ $ERRORS_COLLECTED -gt 0 ] && echo "HIGH" || [ $WARNINGS_COLLECTED -gt 0 ] && echo "MEDIUM" || echo "LOW")"
    fi
    
    echo "=================================================="
}

# Function to update GitHub Actions step summary
update_github_step_summary() {
    if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
        log_colored "$BLUE" "📝 Updating GitHub Actions step summary..."
        
        cat >> "${GITHUB_STEP_SUMMARY}" << EOF

## 📋 Workflow Error & Warning Summary

| Metric | Value |
|--------|-------|
| **Workflow Type** | \`$WORKFLOW_TYPE\` |
| **Total Errors** | $ERRORS_COLLECTED |
| **Total Warnings** | $WARNINGS_COLLECTED |
| **Status** | $([ $ERRORS_COLLECTED -eq 0 ] && echo "✅ Clean" || echo "❌ Has Issues") |
| **Severity** | $([ $ERRORS_COLLECTED -gt 0 ] && echo "🔴 High" || [ $WARNINGS_COLLECTED -gt 0 ] && echo "🟡 Medium" || echo "🟢 Low") |

EOF

        if [[ $ERRORS_COLLECTED -gt 0 ]]; then
            echo "### ❌ Errors Found:" >> "${GITHUB_STEP_SUMMARY}"
            for error in "${ERRORS[@]}"; do
                echo "- \`$error\`" >> "${GITHUB_STEP_SUMMARY}"
            done
            echo "" >> "${GITHUB_STEP_SUMMARY}"
        fi
        
        if [[ $WARNINGS_COLLECTED -gt 0 ]]; then
            echo "### ⚠️ Warnings Found:" >> "${GITHUB_STEP_SUMMARY}"
            for warning in "${WARNINGS[@]}"; do
                echo "- \`$warning\`" >> "${GITHUB_STEP_SUMMARY}"
            done
            echo "" >> "${GITHUB_STEP_SUMMARY}"
        fi
    fi
}

# Main execution function
main() {
    local collect_from_logs=false
    local include_context=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --workflow-type)
                WORKFLOW_TYPE="$2"
                shift 2
                ;;
            --job-status)
                JOB_STATUS="$2"
                shift 2
                ;;
            --output-file)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            --collect-from-logs)
                collect_from_logs=true
                shift
                ;;
            --include-context)
                include_context=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_usage
                exit 1
                ;;
        esac
    done
    
    log_colored "$GREEN" "🚀 Starting workflow error collection..."
    log_colored "$BLUE" "   Workflow Type: $WORKFLOW_TYPE"
    log_colored "$BLUE" "   Job Status: $JOB_STATUS"
    
    # Collect errors from various sources
    collect_step_errors
    collect_from_step_outputs
    
    # Generate and save summary
    local summary_file=$(generate_error_summary)
    
    # Display console summary
    display_console_summary
    
    # Update GitHub Actions step summary if available
    update_github_step_summary
    
    # Set outputs for subsequent steps
    if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
        echo "errors_found=$ERRORS_COLLECTED" >> "$GITHUB_OUTPUT"
        echo "warnings_found=$WARNINGS_COLLECTED" >> "$GITHUB_OUTPUT"
        echo "summary_file=$summary_file" >> "$GITHUB_OUTPUT"
        echo "overall_status=$([ $ERRORS_COLLECTED -eq 0 ] && echo "clean" || echo "has_issues")" >> "$GITHUB_OUTPUT"
    fi
    
    log_colored "$GREEN" "✅ Error collection completed!"
    
    # Exit with appropriate code
    if [[ $ERRORS_COLLECTED -gt 0 ]]; then
        log_colored "$YELLOW" "⚠️  Workflow completed with errors detected (check summary above)"
        exit 0  # Don't fail the workflow, just report
    else
        log_colored "$GREEN" "🎉 Workflow completed with no errors!"
        exit 0
    fi
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n$(log_colored "$YELLOW" "⚠️  Error collection interrupted by user")"; exit 1' INT

# Run main function
main "$@"