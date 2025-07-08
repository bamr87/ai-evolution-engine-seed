#!/bin/bash
set -euo pipefail

echo "Testing logger.sh with set -u (strict mode)..."

# Source the logger
source src/lib/core/logger.sh

echo "Logger sourced successfully"

# Test all log functions
log_debug "Testing debug log"
log_info "Testing info log"
log_warn "Testing warn log"
log_error "Testing error log"
log_success "Testing success log"

echo "All logger tests passed with set -u!"
