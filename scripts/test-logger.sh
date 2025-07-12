#!/bin/bash
#
# @file scripts/test-logger.sh
# @description Test script to verify logger functionality
# @author AI Evolution Engine Team
# @created 2025-07-12
# @version 1.0.0
#

set -euo pipefail

echo "🧪 Testing logger functionality..."

# Test 1: Basic logger functionality
echo "Test 1: Basic logger functionality"
if [[ -f "./src/archive/lib/core/logger.sh" ]]; then
    source ./src/archive/lib/core/logger.sh
    log_info "Logger test message"
    log_success "Logger test successful"
    echo "✅ Logger basic functionality test passed"
else
    echo "❌ Logger script not found"
    exit 1
fi

# Test 2: Strict mode compatibility
echo "Test 2: Strict mode compatibility"
set -euo pipefail
if source ./src/archive/lib/core/logger.sh 2>/dev/null; then
    log_info "Strict mode test passed"
    echo "✅ Logger strict mode compatibility test passed"
else
    echo "❌ Logger strict mode compatibility test failed"
    exit 1
fi

# Test 3: CI environment compatibility
echo "Test 3: CI environment compatibility"
export CI_ENVIRONMENT=true
if source ./src/archive/lib/core/logger.sh 2>/dev/null; then
    log_info "CI environment test passed"
    echo "✅ Logger CI environment compatibility test passed"
else
    echo "❌ Logger CI environment compatibility test failed"
    exit 1
fi

echo "🎉 All logger tests passed!" 