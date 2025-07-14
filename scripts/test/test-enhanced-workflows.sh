#!/bin/bash
#
# @file scripts/test-enhanced-workflows.sh
# @description Test script to validate enhanced workflow error collection functionality
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-01-27
# @lastModified 2025-01-27
# @version 1.0.0
#
# @relatedIssues 
#   - #workflow-error-logging: Test enhanced workflow files
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation for testing enhanced workflows
#
# @dependencies
#   - ./scripts/collect-workflow-errors.sh: Error collection script
#
# @changelog
#   - 2025-01-27: Initial creation - ITJ
#
# @usage ./scripts/test-enhanced-workflows.sh
# @notes Simulates workflow runs to test error collection
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Test configuration
TEST_LOG_DIR="/tmp/workflow-test-logs"
COLLECT_SCRIPT="$PROJECT_ROOT/scripts/collect-workflow-errors.sh"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧪 Testing Enhanced Workflow Error Collection${NC}"
echo "=============================================="

# Setup test environment
mkdir -p "$TEST_LOG_DIR"

# Test each workflow type
workflow_types=("ai_evolver" "testing_automation" "daily_evolution" "periodic_evolution")

for workflow_type in "${workflow_types[@]}"; do
    echo -e "${BLUE}Testing $workflow_type workflow...${NC}"
    
    # Test success case
    echo "  📊 Testing success scenario..."
    output_file="$TEST_LOG_DIR/${workflow_type}-success.json"
    if "$COLLECT_SCRIPT" --workflow-type "$workflow_type" --job-status "success" --output-file "$output_file" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Success case completed${NC}"
        
        # Validate output
        if [[ -f "$output_file" ]] && jq empty "$output_file" 2>/dev/null; then
            status=$(jq -r '.workflow_error_summary.summary.overall_status' "$output_file")
            echo "    Status: $status"
        fi
    else
        echo -e "  ${YELLOW}⚠ Success case failed${NC}"
    fi
    
    # Test failure case
    echo "  📊 Testing failure scenario..."
    output_file="$TEST_LOG_DIR/${workflow_type}-failure.json"
    if "$COLLECT_SCRIPT" --workflow-type "$workflow_type" --job-status "failure" --output-file "$output_file" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Failure case completed${NC}"
        
        # Validate output
        if [[ -f "$output_file" ]] && jq empty "$output_file" 2>/dev/null; then
            status=$(jq -r '.workflow_error_summary.summary.overall_status' "$output_file")
            errors=$(jq -r '.workflow_error_summary.summary.total_errors' "$output_file")
            echo "    Status: $status, Errors: $errors"
        fi
    else
        echo -e "  ${YELLOW}⚠ Failure case failed${NC}"
    fi
    
    echo ""
done

# Test with simulated log files
echo -e "${BLUE}Testing with simulated error logs...${NC}"

# Create sample error logs in the project logs directory
mkdir -p "$PROJECT_ROOT/logs"
cat > "$PROJECT_ROOT/logs/test-error-simulation.log" << EOF
[INFO] Process started
[ERROR] Timeout occurred while connecting to service
[WARNING] Deprecated API method used
[ERROR] Authentication failed
[INFO] Process completed with errors
EOF

echo "  📊 Running error collection with simulated logs..."
output_file="$TEST_LOG_DIR/simulated-errors.json"
if "$COLLECT_SCRIPT" --workflow-type "simulation" --job-status "failure" --output-file "$output_file" --collect-from-logs 2>/dev/null; then
    echo -e "  ${GREEN}✓ Error simulation completed${NC}"
    
    if [[ -f "$output_file" ]]; then
        errors=$(jq -r '.workflow_error_summary.summary.total_errors' "$output_file")
        warnings=$(jq -r '.workflow_error_summary.summary.total_warnings' "$output_file")
        echo "    Detected - Errors: $errors, Warnings: $warnings"
    fi
else
    echo -e "  ${YELLOW}⚠ Error simulation failed${NC}"
fi

# Clean up
rm -f "$PROJECT_ROOT/logs/test-error-simulation.log"

echo ""
echo -e "${GREEN}🎉 Enhanced workflow testing completed!${NC}"
echo "Check generated files in: $TEST_LOG_DIR"
echo ""
echo "Summary files created:"
ls -la "$TEST_LOG_DIR"/*.json 2>/dev/null || echo "No summary files created"