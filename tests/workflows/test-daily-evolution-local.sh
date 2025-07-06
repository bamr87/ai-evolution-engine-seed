#!/bin/bash
#
# @file tests/workflows/test-daily-evolution-local.sh
# @description Test the daily evolution workflow locally to identify failures
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-06
# @version 1.0.0
#
# @relatedIssues 
#   - Daily evolution workflow testing
#
# @relatedEvolutions
#   - v1.0.0: Migrated from scripts/ to tests/workflows/
#
# @dependencies
#   - bash: >=4.0
#   - scripts/setup-environment.sh: Environment setup
#
# @changelog
#   - 2025-07-06: Migrated to tests/workflows/ directory - ITJ
#   - 2025-07-05: Initial creation - ITJ
#
# @usage ./tests/workflows/test-daily-evolution-local.sh
# @notes Test the daily evolution workflow locally to identify failures
#

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

echo "🧪 Testing Daily Evolution Workflow Locally"
echo "=============================================="

# Simulate environment variables from the workflow
export EVOLUTION_TYPE="consistency"
export INTENSITY="minimal"
export FORCE_RUN="false"
export DRY_RUN="true"
export CI_ENVIRONMENT="false"

echo ""
echo "📋 Testing Prerequisites..."

# Test 1: Check if setup-environment.sh exists and is executable
echo "1. Checking setup-environment.sh..."
if [ ! -f "./scripts/setup-environment.sh" ]; then
    echo "❌ Setup script not found!"
    exit 1
else
    echo "✅ Setup script found"
fi

# Test 2: Make scripts executable
echo "2. Making scripts executable..."
find ./scripts -name "*.sh" -exec chmod +x {} \;
echo "✅ Scripts made executable"

# Test 3: Check dependencies for setup-environment.sh
echo "3. Testing setup-environment.sh..."
if ! ./scripts/setup-environment.sh; then
    echo "❌ Setup environment failed"
    exit 1
else
    echo "✅ Setup environment successful"
fi

# Test 4: Check analyze-repository-health.sh
echo "4. Testing analyze-repository-health.sh..."
if ! ./scripts/analyze-repository-health.sh "$EVOLUTION_TYPE" "$INTENSITY" "$FORCE_RUN"; then
    echo "❌ Repository health analysis failed"
    exit 1
else
    echo "✅ Repository health analysis successful"
fi

# Test 5: Check if output files are created
echo "5. Checking output files..."
if [ -f "/tmp/health_check_results.env" ]; then
    echo "✅ Health check results file created"
    cat /tmp/health_check_results.env
else
    echo "⚠️  Health check results file not found"
fi

if [ -f "/tmp/health_check_suggestions.txt" ]; then
    echo "✅ Health check suggestions file created"
    echo "Suggestions:"
    cat /tmp/health_check_suggestions.txt
else
    echo "⚠️  Health check suggestions file not found"
fi

# Test 6: Test generate-evolution-prompt.sh if it should evolve
echo "6. Testing generate-evolution-prompt.sh..."
if [ -f "/tmp/health_check_results.env" ]; then
    source /tmp/health_check_results.env
    if [ "${SHOULD_EVOLVE:-false}" = "true" ]; then
        if ! ./scripts/generate-evolution-prompt.sh "$EVOLUTION_TYPE" "$INTENSITY"; then
            echo "❌ Evolution prompt generation failed"
        else
            echo "✅ Evolution prompt generation successful"
        fi
    else
        echo "🔄 No evolution needed based on health check"
    fi
fi

echo ""
echo "🎉 Local test completed!"
