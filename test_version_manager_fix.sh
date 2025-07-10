#!/bin/bash

#
# @file test_version_manager_fix.sh
# @description Test script to validate version manager hanging fix
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-10
# @lastModified 2025-07-10
# @version 1.0.0
#
# @relatedIssues 
#   - #version-manager-hanging: Fix hanging issues in CI/CD pipelines
#
# @changelog
#   - 2025-07-10: Initial creation to test hanging fix - ITJ
#
# @usage ./test_version_manager_fix.sh
# @notes Tests the version manager with timeout protection
#

set -e

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_MANAGER="$SCRIPT_DIR/scripts/version-manager.sh"

echo "🧪 Testing Version Manager Fix"
echo "==============================="

# Test 1: Check if version manager exists and is executable
echo "Test 1: Version manager script validation..."
if [[ -f "$VERSION_MANAGER" && -x "$VERSION_MANAGER" ]]; then
    echo "✅ Version manager script found and executable"
else
    echo "❌ Version manager script not found or not executable"
    exit 1
fi

# Test 2: Test check-status with timeout protection
echo ""
echo "Test 2: Testing check-status with timeout protection..."
echo "Running: timeout 60s $VERSION_MANAGER check-status"

if timeout 60s "$VERSION_MANAGER" check-status; then
    echo "✅ check-status completed successfully within timeout"
else
    exit_code=$?
    if [[ $exit_code -eq 124 ]]; then
        echo "❌ check-status timed out after 60 seconds"
        exit 1
    else
        echo "❌ check-status failed with exit code: $exit_code"
        exit 1
    fi
fi

# Test 3: Test version retrieval
echo ""
echo "Test 3: Testing version retrieval..."
if current_version=$("$VERSION_MANAGER" version 2>/dev/null); then
    echo "✅ Version retrieval successful: $current_version"
else
    echo "❌ Version retrieval failed"
    exit 1
fi

# Test 4: Test scan-files directly with timeout
echo ""
echo "Test 4: Testing scan-files with timeout protection..."
if timeout 30s "$VERSION_MANAGER" scan-files; then
    echo "✅ scan-files completed successfully within timeout"
else
    exit_code=$?
    if [[ $exit_code -eq 124 ]]; then
        echo "❌ scan-files timed out after 30 seconds"
        exit 1
    else
        echo "❌ scan-files failed with exit code: $exit_code"
        exit 1
    fi
fi

echo ""
echo "🎉 All tests passed! Version manager fix validated."
echo "   The hanging issue should now be resolved."
