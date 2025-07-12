#!/bin/bash

#
# @file scripts/test-context-collection.sh
# @description Test script for context collection fixes
# @author IT-Journey Team
# @created 2025-07-12
# @version 1.0.0
#

set -euo pipefail

echo "🧪 Testing Context Collection Script Fixes"
echo "==========================================="

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "$PROJECT_ROOT"

echo "📍 Working directory: $(pwd)"
echo "🔍 Testing prerequisites..."

# Test required tools
tools=("jq" "find" "grep" "head" "wc" "sort")
for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool is available"
    else
        echo "❌ $tool is missing"
        exit 1
    fi
done

# Test optional tools
if command -v timeout >/dev/null 2>&1; then
    echo "✅ timeout is available"
else
    echo "⚠️  timeout is not available (will use alternatives)"
fi

echo ""
echo "🔍 Testing file discovery..."
file_count=$(find . -type f \( -name "*.md" -o -name "*.sh" -o -name "*.yml" \) 2>/dev/null | wc -l | tr -d ' ')
echo "📁 Found $file_count potential files for collection"

echo ""
echo "🔍 Testing .gptignore processing..."
if [[ -f .gptignore ]]; then
    echo "📋 .gptignore file exists"
    lines=$(wc -l < .gptignore)
    echo "📄 Contains $lines lines"
else
    echo "⚠️  No .gptignore file found"
fi

echo ""
echo "🔍 Testing JSON processing..."
test_json='{"test": "value", "number": 42}'
if echo "$test_json" | jq '.' >/dev/null 2>&1; then
    echo "✅ JSON processing works"
else
    echo "❌ JSON processing failed"
    exit 1
fi

echo ""
echo "🚀 Running context collection test (dry run)..."

# Create a minimal test
export EVOLUTION_PROMPT="Test prompt for validation"
export GROWTH_MODE="adaptive"
export CI_ENVIRONMENT="true"

# Test the script with minimal arguments
if ./scripts/collect-context.sh --prompt "Test collection" --growth-mode "adaptive" --context-file "/tmp/test_context.json"; then
    echo "✅ Context collection script completed successfully"
    
    if [[ -f "/tmp/test_context.json" ]]; then
        echo "📁 Context file created successfully"
        size=$(wc -c < /tmp/test_context.json)
        echo "📊 File size: $size bytes"
        
        if jq '.' /tmp/test_context.json >/dev/null 2>&1; then
            echo "✅ Context file contains valid JSON"
            
            # Check structure
            keys=$(jq 'keys[]' /tmp/test_context.json 2>/dev/null | tr -d '"' | tr '\n' ' ')
            echo "🔑 JSON keys: $keys"
            
            files_count=$(jq '.files | length' /tmp/test_context.json 2>/dev/null || echo "0")
            echo "📄 Files collected: $files_count"
        else
            echo "❌ Context file contains invalid JSON"
            echo "📄 First 200 characters:"
            head -c 200 /tmp/test_context.json
            exit 1
        fi
        
        # Clean up
        rm -f /tmp/test_context.json
    else
        echo "❌ Context file was not created"
        exit 1
    fi
else
    echo "❌ Context collection script failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Context collection should work in GitHub Actions."
echo ""
echo "📋 Summary:"
echo "  - Required tools: ✅"
echo "  - File discovery: ✅" 
echo "  - JSON processing: ✅"
echo "  - Context collection: ✅"
echo ""
echo "🚀 Ready for deployment!"
