#!/bin/bash

#
# @file validate_version_integration_fix.sh
# @description Validation script to verify the prepare command fix works correctly
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-10
# @lastModified 2025-07-10
# @version 1.0.0
#
# @relatedIssues 
#   - GitHub Actions workflow failure: Missing 'prepare' command
#
# @usage ./validate_version_integration_fix.sh
# @notes Validates that the version-integration.sh script now includes the prepare command
#

set -e

echo "🔍 Validating Version Integration Fix"
echo "======================================"

SCRIPT_PATH="./scripts/version-integration.sh"

# Check if script exists
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "❌ ERROR: Script not found: $SCRIPT_PATH"
    exit 1
fi

echo "✅ Script exists: $SCRIPT_PATH"

# Check if script is executable
if [[ ! -x "$SCRIPT_PATH" ]]; then
    echo "⚠️  Making script executable..."
    chmod +x "$SCRIPT_PATH"
fi

echo "✅ Script is executable"

# Test help command
echo ""
echo "🧪 Testing help command..."
if $SCRIPT_PATH help | grep -q "prepare"; then
    echo "✅ Help text includes 'prepare' command"
else
    echo "❌ ERROR: Help text does not include 'prepare' command"
    exit 1
fi

# Test prepare command specifically
echo ""
echo "🧪 Testing prepare command..."
if $SCRIPT_PATH prepare 2>/dev/null; then
    echo "✅ Prepare command executed successfully"
else
    echo "❌ ERROR: Prepare command failed"
    exit 1
fi

echo ""
echo "🎉 All validation tests passed!"
echo "The version-integration.sh fix is working correctly."
echo ""
echo "GitHub Actions workflow should now succeed with:"
echo "  ./scripts/version-integration.sh prepare"
