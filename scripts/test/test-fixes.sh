#!/bin/bash

#
# @file scripts/test-fixes.sh
# @description Test script to validate the workflow fixes
# @author GitHub Copilot
# @created 2025-07-12
# @version 1.0.0
#

set -euo pipefail

echo "🧪 Testing Workflow Fixes v0.4.2"
echo "================================="
echo

# Test 1: Check if collect-context.sh runs without immediate errors
echo "Test 1: Basic collect-context.sh execution"
if timeout 10s ./scripts/collect-context.sh --prompt "test" --growth-mode "adaptive" >/dev/null 2>&1; then
    echo "✅ collect-context.sh basic execution passed"
else
    echo "❌ collect-context.sh basic execution failed"
fi
echo

# Test 2: Check if analyze-repository-health.sh runs without immediate errors  
echo "Test 2: Basic analyze-repository-health.sh execution"
if timeout 10s ./scripts/analyze-repository-health.sh >/dev/null 2>&1; then
    echo "✅ analyze-repository-health.sh basic execution passed"
else
    echo "❌ analyze-repository-health.sh basic execution failed"
fi
echo

# Test 3: Check if version-manager.sh runs without immediate errors
echo "Test 3: Basic version-manager.sh execution"
if timeout 5s ./scripts/version-manager.sh --help >/dev/null 2>&1; then
    echo "✅ version-manager.sh basic execution passed"
else
    echo "❌ version-manager.sh basic execution failed"
fi
echo

# Test 4: Verify workflow syntax
echo "Test 4: Workflow YAML syntax validation"
if command -v yamllint >/dev/null 2>&1; then
    if yamllint .github/workflows/ai_evolver.yml >/dev/null 2>&1; then
        echo "✅ Workflow YAML syntax is valid"
    else
        echo "❌ Workflow YAML syntax has issues"
    fi
else
    echo "ℹ️ yamllint not available, skipping syntax check"
fi
echo

# Test 5: Check version consistency
echo "Test 5: Version consistency check"
WORKFLOW_VERSION=$(grep "EVOLUTION_VERSION:" .github/workflows/ai_evolver.yml | cut -d'"' -f2)
WORKFLOW_NAME_VERSION=$(grep "name: 🌱 AI Evolution Growth Engine" .github/workflows/ai_evolver.yml | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')

if [[ "$WORKFLOW_VERSION" == "${WORKFLOW_NAME_VERSION#v}" ]]; then
    echo "✅ Workflow version consistency check passed ($WORKFLOW_VERSION)"
else
    echo "❌ Workflow version inconsistency: ENV=$WORKFLOW_VERSION, NAME=$WORKFLOW_NAME_VERSION"
fi
echo

echo "🎉 Fix validation completed!"
