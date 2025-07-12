#!/bin/bash
#
# @file scripts/test-simple-fallbacks.sh
# @description Test script for simple fallback scripts
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @version 1.0.0
#

set -euo pipefail

echo "🧪 Testing Simple Fallback Scripts"
echo "================================="

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "$PROJECT_ROOT"

# Test 1: Simple Context Collector
echo ""
echo "📊 Testing simple-context-collector.sh..."
if [[ -f "scripts/simple-context-collector.sh" ]]; then
    chmod +x scripts/simple-context-collector.sh
    if timeout 30 ./scripts/simple-context-collector.sh /tmp/test_context.json; then
        echo "✅ Context collector test passed"
        if [[ -f /tmp/test_context.json ]] && jq empty /tmp/test_context.json 2>/dev/null; then
            echo "✅ Output JSON is valid"
            echo "   Files collected: $(jq -r '.metadata.collection_summary.files_collected' /tmp/test_context.json)"
        else
            echo "❌ Output JSON is invalid"
        fi
    else
        echo "❌ Context collector test failed"
    fi
else
    echo "❌ simple-context-collector.sh not found"
fi

# Test 2: Simple AI Simulator
echo ""
echo "🤖 Testing simple-ai-simulator.sh..."
if [[ -f "scripts/simple-ai-simulator.sh" ]]; then
    chmod +x scripts/simple-ai-simulator.sh
    if timeout 30 ./scripts/simple-ai-simulator.sh /tmp/test_response.json "Test prompt" "adaptive"; then
        echo "✅ AI simulator test passed"
        if [[ -f /tmp/test_response.json ]] && jq empty /tmp/test_response.json 2>/dev/null; then
            echo "✅ Output JSON is valid"
            echo "   Status: $(jq -r '.status' /tmp/test_response.json)"
            echo "   New branch: $(jq -r '.new_branch' /tmp/test_response.json)"
        else
            echo "❌ Output JSON is invalid"
        fi
    else
        echo "❌ AI simulator test failed"
    fi
else
    echo "❌ simple-ai-simulator.sh not found"
fi

# Test 3: Simple Change Applier (dry run)
echo ""
echo "🔧 Testing simple-change-applier.sh (validation only)..."
if [[ -f "scripts/simple-change-applier.sh" ]] && [[ -f /tmp/test_response.json ]]; then
    chmod +x scripts/simple-change-applier.sh
    echo "✅ Change applier script found and response file available"
    echo "   (Skipping actual execution to avoid git changes)"
else
    echo "❌ simple-change-applier.sh or test response not available"
fi

# Cleanup
echo ""
echo "🧹 Cleaning up test files..."
rm -f /tmp/test_context.json /tmp/test_response.json

echo ""
echo "🎉 Fallback script testing completed!"
echo ""
echo "Summary:"
echo "- All scripts should be executable and produce valid JSON output"
echo "- Context collector should gather basic repository information"
echo "- AI simulator should create evolution responses with branch names"
echo "- Change applier should be able to process response files"
