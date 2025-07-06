#!/bin/bash
#
# @file tests/validate-test-migration.sh
# @description Validates that all migrated test files are working correctly
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-06
# @lastModified 2025-07-06
# @version 1.0.0
#
# @relatedIssues 
#   - Test file migration validation
#
# @relatedEvolutions
#   - v1.0.0: Initial validation script for test migration
#
# @dependencies
#   - bash: >=4.0
#
# @changelog
#   - 2025-07-06: Initial creation - ITJ
#
# @usage ./tests/validate-test-migration.sh
# @notes Validates that all migrated test files are working correctly
#

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🔍 Validating Test File Migration"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test validation counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
validate_test() {
    local test_file="$1"
    local test_name="$(basename "$test_file")"
    
    echo -e "\n${YELLOW}🧪 Testing: $test_name${NC}"
    ((TESTS_RUN++))
    
    # Check if file exists
    if [ ! -f "$test_file" ]; then
        echo -e "${RED}❌ File not found: $test_file${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
    
    # Check if file is executable
    if [ ! -x "$test_file" ]; then
        echo "Making file executable..."
        chmod +x "$test_file"
    fi
    
    # Check if file can be sourced without errors
    if bash -n "$test_file"; then
        echo -e "${GREEN}✅ Syntax validation passed${NC}"
    else
        echo -e "${RED}❌ Syntax validation failed${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
    
    # Check PROJECT_ROOT path calculation
    local project_root_line=$(grep -n "PROJECT_ROOT=" "$test_file" | head -1)
    if [ -n "$project_root_line" ]; then
        echo -e "${GREEN}✅ PROJECT_ROOT path found${NC}"
    else
        echo -e "${YELLOW}⚠️  No PROJECT_ROOT path found${NC}"
    fi
    
    ((TESTS_PASSED++))
    echo -e "${GREEN}✅ $test_name validation passed${NC}"
    return 0
}

echo ""
echo "📋 Phase 1: Workflow Test Files"
echo "==============================="

validate_test "tests/workflows/test-all-workflows-local.sh"
validate_test "tests/workflows/test-daily-evolution-local.sh"
validate_test "tests/workflows/test-workflow.sh"

echo ""
echo "📋 Phase 2: Seed Test Files"
echo "==========================="

validate_test "tests/seed/test-evolved-seed.sh"

echo ""
echo "📋 Phase 3: Library Test Files"
echo "=============================="

validate_test "tests/lib/test-modular-library.sh"

echo ""
echo "📋 Phase 4: Check References Updated"
echo "===================================="

echo "Checking documentation references..."
if grep -r "scripts/test-" docs/ >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Found old script references in docs/${NC}"
    grep -r "scripts/test-" docs/ | head -5
else
    echo -e "${GREEN}✅ No old script references found in docs/${NC}"
fi

echo "Checking workflow references..."
if grep -r "scripts/test-evolved-seed.sh" .github/workflows/ >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Found old script references in workflows${NC}"
    grep -r "scripts/test-evolved-seed.sh" .github/workflows/
else
    echo -e "${GREEN}✅ No old script references found in workflows${NC}"
fi

echo ""
echo "🎉 VALIDATION RESULTS"
echo "===================="
echo -e "Tests Run: $TESTS_RUN"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✅ All test file migrations validated successfully!${NC}"
    echo -e "${GREEN}🚀 Test framework reorganization completed${NC}"
    exit 0
else
    echo -e "\n${RED}❌ $TESTS_FAILED test(s) failed validation${NC}"
    echo -e "${RED}🔧 Please review and fix the issues above${NC}"
    exit 1
fi
