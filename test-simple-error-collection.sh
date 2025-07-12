#!/bin/bash
# Simple test for workflow error collection

cd /home/runner/work/ai-evolution-engine-seed/ai-evolution-engine-seed

echo "🧪 Testing workflow error collection script..."

# Test 1: Basic functionality
echo "Test 1: Basic help"
./scripts/collect-workflow-errors.sh --help >/dev/null && echo "✓ Help works" || echo "✗ Help failed"

# Test 2: Basic execution
echo "Test 2: Basic execution"
./scripts/collect-workflow-errors.sh --workflow-type test --job-status success --output-file /tmp/simple-test.json 2>/dev/null && echo "✓ Basic execution works" || echo "✗ Basic execution failed"

# Test 3: Output file validation
echo "Test 3: Output file validation"
if [[ -f /tmp/simple-test.json ]] && jq empty /tmp/simple-test.json 2>/dev/null; then
    echo "✓ Output file is valid JSON"
else
    echo "✗ Output file is invalid or missing"
fi

# Test 4: JSON content validation
echo "Test 4: JSON content validation"
workflow_type=$(jq -r '.workflow_error_summary.metadata.workflow_type' /tmp/simple-test.json 2>/dev/null)
if [[ "$workflow_type" == "test" ]]; then
    echo "✓ Workflow type captured correctly"
else
    echo "✗ Workflow type not captured correctly"
fi

echo "🎉 Simple tests completed!"