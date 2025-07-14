#!/bin/bash
#
# @file tests/integration/test_full_workflow.sh
# @description Integration tests for complete AI Evolution Engine workflow validation
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #integration-testing: Complete workflow integration validation
#   - #test-framework-reorganization: Category-specific artifact management
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation with comprehensive integration testing
#
# @dependencies
#   - bash: >=4.0
#   - find: for repository structure validation
#   - make: for Makefile testing
#
# @changelog
#   - 2025-07-05: Added proper file header and artifact management - ITJ
#   - 2025-07-05: Refactored to use integration-specific artifact directories - ITJ
#
# @usage ./test_full_workflow.sh
# @notes Tests the AI Evolution Engine repository organization and structure
#

# Integration Test: Repository Structure Validation
# Tests the AI Evolution Engine repository organization and structure

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Running AI Evolution Engine integration tests..."

# Setup artifact directories for integration tests
INTEGRATION_LOGS_DIR="$SCRIPT_DIR/logs"
INTEGRATION_RESULTS_DIR="$SCRIPT_DIR/results"
INTEGRATION_REPORTS_DIR="$SCRIPT_DIR/reports"

# Create artifact directories if they don't exist
mkdir -p "$INTEGRATION_LOGS_DIR" "$INTEGRATION_RESULTS_DIR" "$INTEGRATION_REPORTS_DIR"

# Initialize test run timestamp for artifacts
TEST_RUN_TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
TEST_LOG_FILE="$INTEGRATION_LOGS_DIR/full_workflow_test_${TEST_RUN_TIMESTAMP}.log"
TEST_RESULTS_FILE="$INTEGRATION_RESULTS_DIR/full_workflow_results_${TEST_RUN_TIMESTAMP}.json"
TEST_REPORT_FILE="$INTEGRATION_REPORTS_DIR/full_workflow_report_${TEST_RUN_TIMESTAMP}.md"

# Redirect all output to log file as well as console
exec > >(tee -a "$TEST_LOG_FILE")
exec 2>&1

# Initialize results JSON
echo "{\"test_run_id\": \"full_workflow_test_${TEST_RUN_TIMESTAMP}\", \"start_time\": \"$(date -Iseconds)\", \"tests\": []}" > "$TEST_RESULTS_FILE"

# Test 1: Verify main test runner works
echo -e "${YELLOW}Testing main test runner...${NC}"

if "$PROJECT_ROOT/tests/run_tests.sh" run unit; then
    echo -e "${GREEN}✓${NC} Main test runner works correctly"
else
    echo -e "${RED}✗${NC} Main test runner failed"
    exit 1
fi

# Test 2: Verify documentation structure
echo -e "${YELLOW}Testing documentation structure...${NC}"

required_docs=(
    "docs/README.md"
    "docs/ORGANIZATION.md"
    "docs/seeds/seed_prompt_testing_automation.md"
)

for doc in "${required_docs[@]}"; do
    if [[ -f "$PROJECT_ROOT/$doc" ]]; then
        echo -e "${GREEN}✓${NC} Documentation file: $doc"
    else
        echo -e "${RED}✗${NC} Missing documentation: $doc"
        exit 1
    fi
done

# Test 3: Verify template structure
echo -e "${YELLOW}Testing template structure...${NC}"

template_files=(
    "templates/testing-automation/testing_automation_init.sh"
)

for template in "${template_files[@]}"; do
    if [[ -f "$PROJECT_ROOT/$template" ]]; then
        echo -e "${GREEN}✓${NC} Template exists: $template"
    else
        echo -e "${RED}✗${NC} Missing template: $template"
        exit 1
    fi
done

# Test 4: Verify scripts are executable and have valid syntax
echo -e "${YELLOW}Testing script executability...${NC}"

while IFS= read -r -d '' script; do
    script_name=$(basename "$script")
    
    if [[ -x "$script" ]]; then
        echo -e "${GREEN}✓${NC} Script $script_name is executable"
    else
        echo -e "${RED}✗${NC} Script $script_name is not executable"
        exit 1
    fi
    
    # Test syntax
    if bash -n "$script"; then
        echo -e "${GREEN}✓${NC} Script $script_name has valid syntax"
    else
        echo -e "${RED}✗${NC} Script $script_name has syntax errors"
        exit 1
    fi
done < <(find "$PROJECT_ROOT/scripts" -name "*.sh" -print0 2>/dev/null || true)

# Test 5: Verify JSON and YAML files
echo -e "${YELLOW}Testing configuration files...${NC}"

if [[ -f "$PROJECT_ROOT/evolution-metrics.json" ]]; then
    if jq empty "$PROJECT_ROOT/evolution-metrics.json"; then
        echo -e "${GREEN}✓${NC} evolution-metrics.json is valid"
    else
        echo -e "${RED}✗${NC} evolution-metrics.json has invalid syntax"
        exit 1
    fi
fi

# Test 6: Verify Makefile functionality
echo -e "${YELLOW}Testing Makefile...${NC}"

if [[ -f "$PROJECT_ROOT/Makefile" ]]; then
    cd "$PROJECT_ROOT"
    if make help >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Makefile help target works"
    else
        echo -e "${RED}✗${NC} Makefile help target failed"
        exit 1
    fi
fi

echo
echo -e "${GREEN}All integration tests passed!${NC}"
echo "The AI Evolution Engine repository structure is properly organized and functional."
