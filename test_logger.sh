#!/bin/bash
set -euo pipefail

echo "Testing logger with strict mode..."
source src/lib/core/logger.sh
echo "Logger loaded successfully"
log_info "Test info message"
log_warn "Test warning message"
log_error "Test error message"
echo "All tests passed!"
