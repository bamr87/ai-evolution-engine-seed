#!/bin/bash
#
# @file test_unbound_variable_fix.sh
# @description Test to validate that the logger.sh unbound variable fix works correctly
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-08
# @lastModified 2025-07-08
# @version 1.0.0
#
# @relatedIssues 
#   - Workflow run failed due to "unbound variable" error from src/lib/core/logger.sh
#
# @relatedEvolutions
#   - v0.3.0: Fixed unbound variable error in logger.sh
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/logger.sh
#
# @changelog
#   - 2025-07-08: Initial creation to test unbound variable fix - ITJ
#
# @usage ./test_unbound_variable_fix.sh
# @notes Tests the specific scenario that was causing workflow failures
#

# Enable strict mode - this will catch unbound variables
set -euo pipefail

echo "=== Testing logger.sh with strict mode (set -u) ==="
echo "This test validates that the unbound variable fix works correctly."
echo

# Test 1: Source the logger with strict mode enabled
echo "Test 1: Sourcing logger.sh with set -u enabled..."
source src/lib/core/logger.sh
echo "✅ Logger sourced successfully"

# Test 2: Test all log level functions
echo
echo "Test 2: Testing all log level functions..."
log_debug "Debug message test"
log_info "Info message test"
log_warn "Warning message test"
log_error "Error message test"
log_success "Success message test"
echo "✅ All log functions work correctly"

# Test 3: Test set_log_level function
echo
echo "Test 3: Testing set_log_level function..."
set_log_level "DEBUG"
set_log_level "INFO"
set_log_level "WARN"
set_log_level "ERROR"
set_log_level "SUCCESS"
echo "✅ set_log_level function works correctly"

# Test 4: Test edge case - what happens when LOG_LEVELS was already defined
echo
echo "Test 4: Testing scenario where LOG_LEVELS is pre-defined..."
LOG_LEVELS=("EXISTING")
LOG_LEVEL_INFO=999
source src/lib/core/logger.sh
echo "Current LOG_LEVEL_INFO: $LOG_LEVEL_INFO"
if [[ "$LOG_LEVEL_INFO" == "999" ]]; then
    echo "✅ Pre-existing variables are preserved"
else
    echo "❌ Pre-existing variables were overwritten"
    exit 1
fi

echo
echo "🎉 All tests passed! The unbound variable fix is working correctly."
echo "The workflow should now complete without 'unbound variable' errors."
