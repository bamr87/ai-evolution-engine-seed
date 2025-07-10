#!/bin/bash

# Simple validation of the GitHub Actions authentication fix

echo "🔍 Testing GitHub Actions Authentication Fix"
echo "============================================"

# Test 1: Check workflow has GH_TOKEN
echo -n "1. Workflow contains GH_TOKEN environment variable: "
if grep -q "GH_TOKEN.*secrets.GITHUB_TOKEN" /Users/bamr87/github/ai-evolution-engine-seed/.github/workflows/ai_evolver.yml; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    exit 1
fi

# Test 2: Check script supports GITHUB_TOKEN
echo -n "2. Script checks for GITHUB_TOKEN: "
if grep -q "GITHUB_TOKEN:-" /Users/bamr87/github/ai-evolution-engine-seed/scripts/check-prereqs.sh; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    exit 1
fi

# Test 3: Check for enhanced token source detection
echo -n "3. Enhanced token source detection: "
if grep -q "token_source.*GITHUB_TOKEN" /Users/bamr87/github/ai-evolution-engine-seed/scripts/check-prereqs.sh; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The fix is ready."
echo ""
echo "📋 Summary of changes:"
echo "  • Added GH_TOKEN: \${{ secrets.GITHUB_TOKEN }} to workflow env"
echo "  • Updated prerequisite script to check GITHUB_TOKEN"
echo "  • Enhanced error messages with token source detection"
echo ""
echo "🚀 The GitHub Actions workflow should now pass authentication checks!"
