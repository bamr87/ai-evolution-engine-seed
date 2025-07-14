#!/usr/bin/env bash
#
# @file scripts/collect-evolution-metrics.sh
# @description Collects and updates evolution metrics and analytics
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - Missing metrics collection script for evolution workflow
#
# @relatedEvolutions
#   - v1.0.0: Initial creation for evolution metrics collection
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#   - src/lib/evolution/metrics.sh: Metrics functions
#
# @changelog
#   - 2025-07-12: Initial creation for evolution metrics - ITJ
#
# @usage ./collect-evolution-metrics.sh [--cycle ID] [--growth-mode MODE]
# @notes Collects evolution metrics and updates analytics
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/validation"
require_module "utils/json_processor"

# Initialize logging
init_logger "logs" "collect-evolution-metrics"

# Parse command line arguments
CYCLE_ID=""
GROWTH_MODE=""
OUTPUT_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --cycle)
            CYCLE_ID="$2"
            shift 2
            ;;
        --growth-mode)
            GROWTH_MODE="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Set defaults
CYCLE_ID="${CYCLE_ID:-$(date +%Y%m%d%H%M%S)}"
GROWTH_MODE="${GROWTH_MODE:-adaptive}"
OUTPUT_FILE="${OUTPUT_FILE:-evolution-metrics.json}"

log_info "Collecting evolution metrics..."
log_info "Cycle ID: $CYCLE_ID"
log_info "Growth mode: $GROWTH_MODE"

# Initialize metrics structure
METRICS_JSON="{
  \"cycle_id\": \"$CYCLE_ID\",
  \"timestamp\": \"$(date -Iseconds)\",
  \"growth_mode\": \"$GROWTH_MODE\",
  \"metrics\": {}
}"

# Collect git metrics
if git rev-parse --git-dir >/dev/null 2>&1; then
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    BRANCH_COUNT=$(git branch -r 2>/dev/null | wc -l | tr -d ' ')
    LAST_COMMIT_DATE=$(git log -1 --format=%ci 2>/dev/null || echo "unknown")
    
    METRICS_JSON=$(echo "$METRICS_JSON" | jq --arg commits "$COMMIT_COUNT" \
        --arg branches "$BRANCH_COUNT" \
        --arg last_commit "$LAST_COMMIT_DATE" \
        '.metrics.git = {
            "total_commits": ($commits | tonumber),
            "total_branches": ($branches | tonumber),
            "last_commit_date": $last_commit
        }')
    
    log_info "Git metrics collected: $COMMIT_COUNT commits, $BRANCH_COUNT branches"
fi

# Collect file metrics
if [[ -d "$PROJECT_ROOT" ]]; then
    TOTAL_FILES=$(find "$PROJECT_ROOT" -type f ! -path '*/.*' ! -path '*/node_modules/*' 2>/dev/null | wc -l | tr -d ' ')
    SCRIPT_FILES=$(find "$PROJECT_ROOT" -name "*.sh" ! -path '*/.*' 2>/dev/null | wc -l | tr -d ' ')
    YAML_FILES=$(find "$PROJECT_ROOT" -name "*.yml" -o -name "*.yaml" ! -path '*/.*' 2>/dev/null | wc -l | tr -d ' ')
    
    METRICS_JSON=$(echo "$METRICS_JSON" | jq --arg total "$TOTAL_FILES" \
        --arg scripts "$SCRIPT_FILES" \
        --arg yaml "$YAML_FILES" \
        '.metrics.files = {
            "total_files": ($total | tonumber),
            "script_files": ($scripts | tonumber),
            "yaml_files": ($yaml | tonumber)
        }')
    
    log_info "File metrics collected: $TOTAL_FILES files ($SCRIPT_FILES scripts, $YAML_FILES YAML)"
fi

# Collect test metrics if test directory exists
if [[ -d "$PROJECT_ROOT/tests" ]]; then
    TEST_FILES=$(find "$PROJECT_ROOT/tests" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
    
    METRICS_JSON=$(echo "$METRICS_JSON" | jq --arg tests "$TEST_FILES" \
        '.metrics.testing = {
            "test_files": ($tests | tonumber)
        }')
    
    log_info "Test metrics collected: $TEST_FILES test files"
fi

# Collect workflow metrics
if [[ -d "$PROJECT_ROOT/.github/workflows" ]]; then
    WORKFLOW_FILES=$(find "$PROJECT_ROOT/.github/workflows" -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l | tr -d ' ')
    
    METRICS_JSON=$(echo "$METRICS_JSON" | jq --arg workflows "$WORKFLOW_FILES" \
        '.metrics.workflows = {
            "workflow_files": ($workflows | tonumber)
        }')
    
    log_info "Workflow metrics collected: $WORKFLOW_FILES workflows"
fi

# Add evolution metadata
METRICS_JSON=$(echo "$METRICS_JSON" | jq --arg version "${EVOLUTION_VERSION:-unknown}" \
    '.metadata = {
        "evolution_version": $version,
        "collection_date": (now | todate),
        "hostname": env.HOSTNAME
    }')

# Write metrics to file
echo "$METRICS_JSON" | jq '.' > "$OUTPUT_FILE"

log_success "Evolution metrics collected and saved to: $OUTPUT_FILE"

# Show summary
log_info "Metrics Summary:"
echo "$METRICS_JSON" | jq -r '.metrics | to_entries[] | "  \(.key): \(.value | tostring)"'

exit 0
