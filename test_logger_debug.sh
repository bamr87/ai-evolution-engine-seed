#!/bin/bash
set -euo pipefail

echo "Step 1: Testing logger function calls directly"
source src/lib/core/logger.sh

echo "Step 2: Calling _log function directly"
_log "INFO" "Direct test message"

echo "Step 3: Calling log_info function"
log_info "Test info message"

echo "Step 4: All tests completed successfully"
