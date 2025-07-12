#!/bin/bash

#
# @file test-context-collection.sh
# @description Test script to verify context collection functionality
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @usage ./test-context-collection.sh
# @notes Tests the collect-context.sh script locally before GitHub Actions deployment
#

set -e

echo "🧪 Testing Context Collection Script"
echo "===================================="

# Test 1: Basic functionality
echo "📋 Test 1: Basic context collection..."
if ./scripts/collect-context.sh --prompt "test run" --growth-mode "conservative"; then
    echo "✅ Basic test passed"
else
    echo "❌ Basic test failed"
    exit 1
fi

# Test 2: Check context file was created
echo "📋 Test 2: Verify context file creation..."
if [[ -f /tmp/repo_context.json ]]; then
    echo "✅ Context file created successfully"
    echo "📊 File size: $(wc -c < /tmp/repo_context.json) bytes"
    
    # Test 3: Verify JSON structure
    echo "📋 Test 3: Verify JSON structure..."
    if jq -e '.metadata' /tmp/repo_context.json >/dev/null; then
        echo "✅ JSON structure is valid"
        
        # Show summary
        echo "📊 Context Summary:"
        echo "  - Files collected: $(jq '.metadata.collection_summary.files_collected // 0' /tmp/repo_context.json)"
        echo "  - Growth mode: $(jq -r '.metadata.growth_mode' /tmp/repo_context.json)"
        echo "  - Timestamp: $(jq -r '.metadata.timestamp' /tmp/repo_context.json)"
    else
        echo "❌ Invalid JSON structure"
        exit 1
    fi
else
    echo "❌ Context file not created"
    exit 1
fi

# Test 4: Test with include flags
echo "📋 Test 4: Test with include flags..."
if ./scripts/collect-context.sh --prompt "test with flags" --growth-mode "adaptive" --include-health --include-tests; then
    echo "✅ Include flags test passed"
else
    echo "❌ Include flags test failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Context collection script is working correctly."
echo "📁 Context file location: /tmp/repo_context.json"
echo "🔍 You can examine the context with: jq . /tmp/repo_context.json"
