#!/bin/bash
set -euo pipefail

echo "Testing logger.sh isolation..."
source src/lib/core/logger.sh
echo "Logger sourced successfully"

log_info "Testing info log"
log_warn "Testing warn log"
log_error "Testing error log"
log_success "Testing success log"

echo "All logger tests passed!"
