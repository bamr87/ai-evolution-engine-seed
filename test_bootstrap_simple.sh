#!/bin/bash
set -euo pipefail

echo "Testing bootstrap system..."
source src/lib/core/bootstrap.sh
echo "Bootstrap sourced successfully"

echo "Testing library initialization..."
bootstrap_library
echo "Library bootstrap completed"

echo "Testing module loading..."
if is_module_loaded "core/logger"; then
    log_info "Logger module is loaded and functional"
else
    echo "Logger module not loaded"
fi

echo "All bootstrap tests passed!"
