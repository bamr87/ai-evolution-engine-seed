#!/bin/bash
#
# @file tests/unit/test_project_structure.sh
# @description Unit tests for AI Evolution Engine project structure validation
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #project-structure-validation: Comprehensive project structure testing
#   - #test-framework-reorganization: Category-specific artifact management
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation with modular testing framework integration
#
# @dependencies
#   - bash: >=4.0
#   - find: for file system traversal
#
# @changelog
#   - 2025-07-05: Added proper file header and artifact management - ITJ
#   - 2025-07-05: Refactored to use category-specific artifact directories - ITJ
#
# @usage ./test_project_structure.sh
# @notes Tests the basic structure and files required for the AI Evolution Engine
#

# Unit Test: Project Structure Validation
# Tests the basic structure and files required for the AI Evolution Engine

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test counter
TESTS=0
PASSED=0

# Setup artifact directories
UNIT_LOGS_DIR="$SCRIPT_DIR/logs"
UNIT_RESULTS_DIR="$SCRIPT_DIR/results"
UNIT_REPORTS_DIR="$SCRIPT_DIR/reports"

# Create artifact directories if they don't exist
mkdir -p "$UNIT_LOGS_DIR" "$UNIT_RESULTS_DIR" "$UNIT_REPORTS_DIR"

# Initialize test run timestamp for artifacts
TEST_RUN_TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
TEST_LOG_FILE="$UNIT_LOGS_DIR/project_structure_test_${TEST_RUN_TIMESTAMP}.log"
TEST_RESULTS_FILE="$UNIT_RESULTS_DIR/project_structure_results_${TEST_RUN_TIMESTAMP}.json"
TEST_REPORT_FILE="$UNIT_REPORTS_DIR/project_structure_report_${TEST_RUN_TIMESTAMP}.md"

# Redirect all output to log file as well as console
exec > >(tee -a "$TEST_LOG_FILE")
exec 2>&1

# Initialize results JSON
echo "{\"test_run_id\": \"project_structure_test_${TEST_RUN_TIMESTAMP}\", \"start_time\": \"$(date -Iseconds)\", \"tests\": []}" > "$TEST_RESULTS_FILE"

# Test function
test_assert() {
    local description="$1"
    local condition="$2"
    
    ((TESTS++))
    
    if eval "$condition"; then
        ((PASSED++))
        echo -e "${GREEN}✓${NC} $description"
        # Update results JSON
        jq --arg desc "$description" '.tests += [{description: $desc, status: "passed"}]' "$TEST_RESULTS_FILE" > tmp.$$.json && mv tmp.$$.json "$TEST_RESULTS_FILE"
        return 0
    else
        echo -e "${RED}✗${NC} $description"
        # Update results JSON
        jq --arg desc "$description" '.tests += [{description: $desc, status: "failed"}]' "$TEST_RESULTS_FILE" > tmp.$$.json && mv tmp.$$.json "$TEST_RESULTS_FILE"
        return 1
    fi
}

echo "Running project structure unit tests..."

# Test essential files exist
test_assert "README.md exists and is not empty" "test -s '$PROJECT_ROOT/README.md'"
test_assert "LICENSE file exists" "test -f '$PROJECT_ROOT/LICENSE' || test -f '$PROJECT_ROOT/LICENSE.md'"
test_assert "Evolution metrics exists" "test -f '$PROJECT_ROOT/evolution-metrics.json'"

# Test directory structure
test_assert "Scripts directory exists" "test -d '$PROJECT_ROOT/scripts'"
test_assert "Tests directory exists" "test -d '$PROJECT_ROOT/tests'"
test_assert "Source directory exists" "test -d '$PROJECT_ROOT/src'"
test_assert "Documentation directory exists" "test -d '$PROJECT_ROOT/docs'"

# Test configuration files
test_assert ".gitignore exists" "test -f '$PROJECT_ROOT/.gitignore'"
test_assert ".gptignore exists" "test -f '$PROJECT_ROOT/.gptignore'"

# Test GitHub Actions
test_assert "GitHub Actions directory exists" "test -d '$PROJECT_ROOT/.github/workflows'"

# Test seed files
test_assert "Seed documentation exists" "test -f '$PROJECT_ROOT/.seed.md' || test -f '$PROJECT_ROOT/docs/seeds/seed_prompt_testing_automation.md'"

# Summary
echo
echo "Unit Test Results:"
echo "  Tests run: $TESTS"
echo "  Passed: $PASSED"
echo "  Failed: $((TESTS - PASSED))"

if [[ $PASSED -eq $TESTS ]]; then
    echo -e "${GREEN}All unit tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some unit tests failed.${NC}"
    exit 1
fi
