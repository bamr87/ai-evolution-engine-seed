#!/bin/bash
set -e

echo "Testing prepare command..."

# Simple logging functions
log_info() { echo "[INFO] $1"; }
log_warn() { echo "[WARN] $1"; }
log_error() { echo "[ERROR] $1"; exit 1; }
log_success() { echo "[SUCCESS] $1"; }

# Test the prepare logic
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_MANAGER="$SCRIPT_DIR/scripts/version-manager.sh"

echo "Script dir: $SCRIPT_DIR"
echo "Version manager: $VERSION_MANAGER"

if [[ ! -f "$VERSION_MANAGER" ]]; then
    log_error "Version manager script not found: $VERSION_MANAGER"
fi

log_info "Preparing version management for evolution cycle"

# Check if version manager is executable
if [[ ! -x "$VERSION_MANAGER" ]]; then
    chmod +x "$VERSION_MANAGER"
    log_info "Made version manager executable"
fi

log_success "Version management preparation complete"
