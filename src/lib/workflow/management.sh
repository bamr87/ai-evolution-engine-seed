#!/bin/bash
#
# @file src/lib/workflow/management.sh
# @description Workflow management and execution utilities for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Modular refactoring: Extract workflow management functionality
#
# @relatedEvolutions
#   - v1.0.0: Initial creation during modular refactoring
#
# @dependencies
#   - bash: >=4.0
#   - gh: GitHub CLI for workflow operations
#
# @changelog
#   - 2025-07-07: Initial creation with workflow management functions - ITJ
#
# @usage require_module "workflow/management"
# @notes Provides standardized workflow execution and monitoring
#

# Prevent multiple imports
[[ "${__WORKFLOW_MANAGEMENT_LOADED:-}" == "true" ]] && return 0
readonly __WORKFLOW_MANAGEMENT_LOADED=true

# Module dependencies
require_module "core/logger"
require_module "core/validation"

#
# Trigger a GitHub workflow with parameters
#
# Arguments:
#   $1 - workflow_name: Name of the workflow file (e.g., ai_evolver.yml)
#   $2 - parameters: JSON string of parameters to pass
#
# Returns:
#   0 on success, 1 on failure
#
workflow_trigger() {
    local workflow_name="$1"
    local parameters="$2"
    
    validate_required "workflow_name" "$workflow_name"
    validate_required "parameters" "$parameters"
    
    log_info "Triggering workflow: $workflow_name"
    
    # Parse parameters and build gh workflow run command
    local gh_args=""
    
    # Convert JSON parameters to gh command line arguments
    while IFS= read -r key_value; do
        local key=$(echo "$key_value" | jq -r '.key')
        local value=$(echo "$key_value" | jq -r '.value')
        gh_args="$gh_args -f $key=\"$value\""
    done < <(echo "$parameters" | jq -r 'to_entries[] | {key: .key, value: .value}')
    
    # Execute the workflow
    if eval "gh workflow run $workflow_name $gh_args"; then
        log_success "Workflow triggered successfully: $workflow_name"
        return 0
    else
        log_error "Failed to trigger workflow: $workflow_name"
        return 1
    fi
}

#
# Monitor workflow execution status
#
# Arguments:
#   $1 - workflow_name: Name of the workflow to monitor
#   $2 - timeout: Timeout in seconds (default: 300)
#
# Returns:
#   0 if workflow completes successfully, 1 on failure or timeout
#
workflow_monitor() {
    local workflow_name="$1"
    local timeout="${2:-300}"
    
    validate_required "workflow_name" "$workflow_name"
    
    log_info "Monitoring workflow: $workflow_name (timeout: ${timeout}s)"
    
    local start_time=$(date +%s)
    local run_id=""
    
    # Get the latest run ID for this workflow
    run_id=$(gh run list --workflow="$workflow_name" --limit=1 --json databaseId --jq '.[0].databaseId' 2>/dev/null)
    
    if [[ -z "$run_id" ]]; then
        log_error "Could not find recent run for workflow: $workflow_name"
        return 1
    fi
    
    log_info "Monitoring run ID: $run_id"
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [[ $elapsed -gt $timeout ]]; then
            log_error "Workflow monitoring timeout after ${timeout}s"
            return 1
        fi
        
        local status=$(gh run view "$run_id" --json status --jq '.status' 2>/dev/null)
        local conclusion=$(gh run view "$run_id" --json conclusion --jq '.conclusion' 2>/dev/null)
        
        case "$status" in
            "completed")
                if [[ "$conclusion" == "success" ]]; then
                    log_success "Workflow completed successfully"
                    return 0
                else
                    log_error "Workflow failed with conclusion: $conclusion"
                    return 1
                fi
                ;;
            "in_progress"|"queued")
                log_info "Workflow status: $status (elapsed: ${elapsed}s)"
                sleep 10
                ;;
            *)
                log_error "Unexpected workflow status: $status"
                return 1
                ;;
        esac
    done
}

#
# Get workflow run logs
#
# Arguments:
#   $1 - run_id: Workflow run ID
#   $2 - output_file: File to save logs (optional)
#
# Returns:
#   0 on success, 1 on failure
#
workflow_get_logs() {
    local run_id="$1"
    local output_file="${2:-}"
    
    validate_required "run_id" "$run_id"
    
    log_info "Retrieving logs for run: $run_id"
    
    if [[ -n "$output_file" ]]; then
        if gh run view "$run_id" --log > "$output_file"; then
            log_success "Logs saved to: $output_file"
            return 0
        else
            log_error "Failed to retrieve logs"
            return 1
        fi
    else
        gh run view "$run_id" --log
        return $?
    fi
}

#
# List recent workflow runs
#
# Arguments:
#   $1 - workflow_name: Name of workflow to list runs for
#   $2 - limit: Number of runs to list (default: 10)
#
# Returns:
#   0 on success, 1 on failure
#
workflow_list_runs() {
    local workflow_name="$1"
    local limit="${2:-10}"
    
    validate_required "workflow_name" "$workflow_name"
    
    log_info "Listing recent runs for workflow: $workflow_name"
    
    if gh run list --workflow="$workflow_name" --limit="$limit"; then
        return 0
    else
        log_error "Failed to list workflow runs"
        return 1
    fi
}

#
# Wait for workflow to start
#
# Arguments:
#   $1 - workflow_name: Name of workflow to wait for
#   $2 - wait_timeout: Timeout in seconds (default: 60)
#
# Returns:
#   0 when workflow starts, 1 on timeout
#
workflow_wait_for_start() {
    local workflow_name="$1"
    local wait_timeout="${2:-60}"
    
    validate_required "workflow_name" "$workflow_name"
    
    log_info "Waiting for workflow to start: $workflow_name"
    
    local start_time=$(date +%s)
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [[ $elapsed -gt $wait_timeout ]]; then
            log_error "Timeout waiting for workflow to start"
            return 1
        fi
        
        # Check if there's a recent run
        local recent_run_count=$(gh run list --workflow="$workflow_name" --limit=1 --json status --jq 'length' 2>/dev/null)
        
        if [[ "$recent_run_count" -gt 0 ]]; then
            log_success "Workflow started: $workflow_name"
            return 0
        fi
        
        log_info "Waiting for workflow to start... (elapsed: ${elapsed}s)"
        sleep 5
    done
}

# Export functions
export -f workflow_trigger
export -f workflow_monitor  
export -f workflow_get_logs
export -f workflow_list_runs
export -f workflow_wait_for_start

log_debug "Workflow management module loaded"
