#!/bin/bash
#
# @file tests/seed/test-evolved-seed.sh
# @description Tests the evolved seed functionality
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-06
# @version 1.0.0
#
# @relatedIssues 
#   - Evolved seed functionality testing
#
# @relatedEvolutions
#   - v1.0.0: Migrated from scripts/ to tests/seed/
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/logger.sh: Logging functionality
#   - src/lib/utils/env_detect.sh: Environment detection
#
# @changelog
#   - 2025-07-06: Migrated to tests/seed/ directory - ITJ
#   - 2025-07-05: Initial creation - ITJ
#
# @usage ./tests/seed/test-evolved-seed.sh [GROWTH_MODE]
# @notes Tests the evolved seed functionality
#

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

GROWTH_MODE="${1:-test-automation}"

log_info "Testing evolved seed functionality..."

# Check if testing automation init script exists
if [ -f "testing_automation_init.sh" ]; then
    log_info "Found testing automation init script"
    chmod +x testing_automation_init.sh
    
    # Create a test directory and run the seed
    log_info "Setting up test environment..."
    mkdir -p test-evolution
    cd test-evolution
    
    log_info "Running seed initialization..."
    if ../testing_automation_init.sh; then
        log_success "Seed initialization successful"
    else
        log_error "Seed initialization failed"
        exit 1
    fi
    
    # Run the generated tests
    if [ -x "scripts/test.sh" ]; then
        log_info "Running generated tests..."
        if ./scripts/test.sh --verbose; then
            log_success "Tests passed"
        else
            log_error "Tests failed"
            exit 1
        fi
    else
        log_warn "No test script found, skipping tests"
    fi
    
    # Test the build process
    if [ -x "scripts/build.sh" ]; then
        log_info "Testing build process..."
        if ./scripts/build.sh --dry-run; then
            log_success "Build test successful"
        else
            log_error "Build test failed"
            exit 1
        fi
    else
        log_warn "No build script found, skipping build test"
    fi
    
    cd ..
    log_info "Cleaning up test environment..."
    rm -rf test-evolution
    
else
    log_warn "No testing automation init script found"
    log_info "Available scripts:"
    ls -la scripts/ 2>/dev/null || echo "No scripts directory found"
fi

log_success "Seed testing completed for growth mode: $GROWTH_MODE"
