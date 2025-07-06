#!/bin/bash
#
# @file scripts/test-modular-library.sh
# @description Test script for the new modular library system
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Test suite for modular library system
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#
# @changelog
#   - 2025-07-05: Initial creation of test script - ITJ
#
# @usage ./test-modular-library.sh [module_name]
# @notes Tests the modular library system and validates functionality
#

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test helper functions
test_start() {
    echo -e "${YELLOW}🧪 Testing: $1${NC}"
    ((TESTS_RUN++))
}

test_pass() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
    ((TESTS_PASSED++))
}

test_fail() {
    echo -e "${RED}❌ FAIL: $1${NC}"
    ((TESTS_FAILED++))
}

test_info() {
    echo -e "ℹ️  $1"
}

# Test bootstrap system
test_bootstrap() {
    test_start "Bootstrap system initialization"
    
    # Test bootstrap loading
    if source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"; then
        test_pass "Bootstrap source loaded"
    else
        test_fail "Bootstrap source failed"
        return 1
    fi
    
    # Test bootstrap initialization
    if bootstrap_library; then
        test_pass "Bootstrap library initialized"
    else
        test_fail "Bootstrap library initialization failed"
        return 1
    fi
    
    # Test global state
    if [[ "$BOOTSTRAP_INITIALIZED" == "true" ]]; then
        test_pass "Bootstrap global state set correctly"
    else
        test_fail "Bootstrap global state incorrect"
        return 1
    fi
}

# Test module loading
test_module_loading() {
    test_start "Module loading system"
    
    # Test core module loading
    if require_module "core/logger"; then
        test_pass "Core logger module loaded"
    else
        test_fail "Core logger module loading failed"
        return 1
    fi
    
    # Test function availability
    if declare -F log_info >/dev/null 2>&1; then
        test_pass "Logger functions available"
    else
        test_fail "Logger functions not available"
        return 1
    fi
    
    # Test duplicate loading prevention
    local initial_count=${#LOADED_MODULES[@]}
    require_module "core/logger"
    if [[ ${#LOADED_MODULES[@]} -eq $initial_count ]]; then
        test_pass "Duplicate module loading prevented"
    else
        test_fail "Duplicate module loading not prevented"
        return 1
    fi
}

# Test logging system
test_logging() {
    test_start "Logging system"
    
    # Initialize logger
    if init_logger "test-logs" "test"; then
        test_pass "Logger initialization successful"
    else
        test_fail "Logger initialization failed"
        return 1
    fi
    
    # Test log functions
    if log_info "Test info message" >/dev/null 2>&1; then
        test_pass "Info logging works"
    else
        test_fail "Info logging failed"
        return 1
    fi
    
    if log_warn "Test warning message" >/dev/null 2>&1; then
        test_pass "Warning logging works"
    else
        test_fail "Warning logging failed"
        return 1
    fi
    
    if log_error "Test error message" >/dev/null 2>&1; then
        test_pass "Error logging works"
    else
        test_fail "Error logging failed"
        return 1
    fi
}

# Test configuration system
test_configuration() {
    test_start "Configuration system"
    
    # Load config module
    if require_module "core/config"; then
        test_pass "Configuration module loaded"
    else
        test_fail "Configuration module loading failed"
        return 1
    fi
    
    # Test configuration functions
    if declare -F config_init >/dev/null 2>&1; then
        test_pass "Configuration functions available"
    else
        test_fail "Configuration functions not available"
        return 1
    fi
}

# Test validation system
test_validation() {
    test_start "Validation system"
    
    # Load validation module
    if require_module "core/validation"; then
        test_pass "Validation module loaded"
    else
        test_fail "Validation module loading failed"
        return 1
    fi
    
    # Test validation functions
    if validate_not_empty "test_value"; then
        test_pass "Not empty validation works"
    else
        test_fail "Not empty validation failed"
        return 1
    fi
    
    if ! validate_not_empty ""; then
        test_pass "Empty validation correctly fails"
    else
        test_fail "Empty validation incorrectly passes"
        return 1
    fi
}

# Test evolution engine
test_evolution_engine() {
    test_start "Evolution engine"
    
    # Load evolution engine
    if require_module "evolution/engine"; then
        test_pass "Evolution engine module loaded"
    else
        test_fail "Evolution engine module loading failed"
        return 1
    fi
    
    # Test engine initialization
    if evolution_init; then
        test_pass "Evolution engine initialization successful"
    else
        test_fail "Evolution engine initialization failed"
        return 1
    fi
}

# Test GitHub integration
test_github_integration() {
    test_start "GitHub integration"
    
    # Load GitHub module
    if require_module "integration/github"; then
        test_pass "GitHub integration module loaded"
    else
        test_fail "GitHub integration module loading failed"
        return 1
    fi
    
    # Test GitHub functions
    if declare -F github_init >/dev/null 2>&1; then
        test_pass "GitHub functions available"
    else
        test_fail "GitHub functions not available"
        return 1
    fi
}

# Test health analysis
test_health_analysis() {
    test_start "Health analysis"
    
    # Load health module
    if require_module "analysis/health"; then
        test_pass "Health analysis module loaded"
    else
        test_fail "Health analysis module loading failed"
        return 1
    fi
    
    # Test health functions
    if declare -F health_init >/dev/null 2>&1; then
        test_pass "Health analysis functions available"
    else
        test_fail "Health analysis functions not available"
        return 1
    fi
}

# Test template engine
test_template_engine() {
    test_start "Template engine"
    
    # Load template module
    if require_module "template/engine"; then
        test_pass "Template engine module loaded"
    else
        test_fail "Template engine module loading failed"
        return 1
    fi
    
    # Test template functions
    if declare -F template_init >/dev/null 2>&1; then
        test_pass "Template engine functions available"
    else
        test_fail "Template engine functions not available"
        return 1
    fi
}

# Test CI integration
test_ci_integration() {
    test_start "CI integration"
    
    # Load CI module
    if require_module "integration/ci"; then
        test_pass "CI integration module loaded"
    else
        test_fail "CI integration module loading failed"
        return 1
    fi
    
    # Test CI functions
    if declare -F ci_init >/dev/null 2>&1; then
        test_pass "CI integration functions available"
    else
        test_fail "CI integration functions not available"
        return 1
    fi
}

# Main test execution
main() {
    echo -e "${GREEN}🧪 AI Evolution Engine - Modular Library Test Suite${NC}"
    echo "=================================================="
    echo ""
    
    local test_module="${1:-all}"
    
    case "$test_module" in
        "bootstrap")
            test_bootstrap
            ;;
        "logging")
            test_bootstrap
            test_logging
            ;;
        "config")
            test_bootstrap
            test_configuration
            ;;
        "validation")
            test_bootstrap
            test_validation
            ;;
        "evolution")
            test_bootstrap
            test_evolution_engine
            ;;
        "github")
            test_bootstrap
            test_github_integration
            ;;
        "health")
            test_bootstrap
            test_health_analysis
            ;;
        "template")
            test_bootstrap
            test_template_engine
            ;;
        "ci")
            test_bootstrap
            test_ci_integration
            ;;
        "all"|*)
            test_bootstrap
            test_module_loading
            test_logging
            test_configuration
            test_validation
            test_evolution_engine
            test_github_integration
            test_health_analysis
            test_template_engine
            test_ci_integration
            ;;
    esac
    
    echo ""
    echo "=================================================="
    echo -e "${GREEN}📊 Test Results:${NC}"
    echo "  Tests Run: $TESTS_RUN"
    echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✅ All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Some tests failed!${NC}"
        exit 1
    fi
}

# Show help if requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    cat << EOF
🧪 AI Evolution Engine - Modular Library Test Suite

USAGE:
    $0 [module_name]

OPTIONS:
    bootstrap    Test bootstrap system only
    logging      Test logging system only
    config       Test configuration system only
    validation   Test validation system only
    evolution    Test evolution engine only
    github       Test GitHub integration only
    health       Test health analysis only
    template     Test template engine only
    ci           Test CI integration only
    all          Test all modules (default)
    -h, --help   Show this help message

EXAMPLES:
    $0              # Test all modules
    $0 bootstrap    # Test only bootstrap system
    $0 logging      # Test only logging system
EOF
    exit 0
fi

# Execute main function
main "$@"
