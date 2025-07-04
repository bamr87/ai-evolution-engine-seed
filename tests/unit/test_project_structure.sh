#!/bin/bash

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

# Test function
test_assert() {
    local description="$1"
    local condition="$2"
    
    ((TESTS++))
    
    if eval "$condition"; then
        ((PASSED++))
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description"
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
