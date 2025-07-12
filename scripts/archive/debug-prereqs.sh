#!/bin/bash
# scripts/debug-prereqs.sh
# Debug version of prerequisite checker

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🧪 Debug Prerequisite Checker"
echo "=============================="

# Source libraries
echo "Step 1: Sourcing libraries..."
source "$PROJECT_ROOT/src/lib/core/logger.sh"
echo "✅ Logger sourced"

source "$PROJECT_ROOT/src/lib/core/environment.sh"
echo "✅ Environment sourced"

# Initialize
echo "Step 2: Initializing..."
GROWTH_MODE="${1:-adaptive}"
CI_ENVIRONMENT="${2:-false}"

init_environment_config "$CI_ENVIRONMENT"
echo "✅ Environment config initialized"

init_logger "logs" "debug-prereqs"
echo "✅ Logger initialized"

# Status tracking
PREREQ_FAILED=0
WARNINGS=0

echo "Step 3: Basic checks..."

# Check git
if command -v git >/dev/null 2>&1; then
    echo "✅ Git found: $(git --version)"
else
    echo "❌ Git not found"
    PREREQ_FAILED=1
fi

# Check if we're in a git repo
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "✅ In git repository"
else
    echo "❌ Not in git repository"
    PREREQ_FAILED=1
fi

echo "Step 4: Final status..."
echo "PREREQ_FAILED: $PREREQ_FAILED"
echo "WARNINGS: $WARNINGS"

if [ $PREREQ_FAILED -eq 0 ]; then
    echo "✅ All checks passed"
    exit 0
else
    echo "❌ Some checks failed"
    exit 1
fi
