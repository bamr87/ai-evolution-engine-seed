#!/bin/bash
#
# @file tests/comprehensive-modular-test.sh
# @description Comprehensive testing suite for the modular AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-07
# @lastModified 2025-07-07
# @version 1.0.0
#
# @relatedIssues 
#   - Modular refactoring: Comprehensive testing for modular architecture
#
# @relatedEvolutions
#   - v1.0.0: Initial creation with comprehensive modular testing
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - All modular library components
#
# @changelog
#   - 2025-07-07: Initial creation with comprehensive testing suite - ITJ
#
# @usage ./tests/comprehensive-modular-test.sh [test_category]
# @notes Tests all aspects of the modular architecture
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Test configuration
TEST_RESULTS_DIR="$PROJECT_ROOT/tests/results"
TEST_LOGS_DIR="$PROJECT_ROOT/tests/logs"
TEST_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TEST_LOG_FILE="$TEST_LOGS_DIR/comprehensive-test-$TEST_TIMESTAMP.log"

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0
CURRENT_TEST_CATEGORY=""

# Ensure test directories exist
mkdir -p "$TEST_RESULTS_DIR" "$TEST_LOGS_DIR"

# Initialize test environment
init_test_environment() {
    echo "🧪 AI Evolution Engine - Comprehensive Modular Test Suite"
    echo "========================================================"
    echo "Test started at: $(date)"
    echo "Test log: $TEST_LOG_FILE"
    echo ""
    
    # Log to file
    exec 3>&1 4>&2
    exec 1> >(tee -a "$TEST_LOG_FILE")
    exec 2> >(tee -a "$TEST_LOG_FILE" >&2)
}

# Test result tracking
test_start() {
    local test_name="$1"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo "🔬 TEST: $test_name"
}

test_pass() {
    local test_name="$1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "✅ PASS: $test_name"
    echo ""
}

test_fail() {
    local test_name="$1"
    local error_msg="${2:-Unknown error}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo "❌ FAIL: $test_name"
    echo "   Error: $error_msg"
    echo ""
}

# Test bootstrap system
test_bootstrap_system() {
    CURRENT_TEST_CATEGORY="Bootstrap System"
    echo "📦 Testing Bootstrap System"
    echo "=========================="
    
    # Test 1: Bootstrap loading
    test_start "Bootstrap system loading"
    if source "$PROJECT_ROOT/src/lib/core/bootstrap.sh" 2>/dev/null; then
        test_pass "Bootstrap system loading"
    else
        test_fail "Bootstrap system loading" "Failed to source bootstrap.sh"
        return 1
    fi
    
    # Test 2: Library initialization
    test_start "Library initialization"
    if bootstrap_library 2>/dev/null; then
        test_pass "Library initialization"
    else
        test_fail "Library initialization" "bootstrap_library function failed"
    fi
    
    # Test 3: Module loading function
    test_start "Module loading function availability"
    if declare -f require_module >/dev/null 2>&1; then
        test_pass "Module loading function availability"
    else
        test_fail "Module loading function availability" "require_module function not found"
    fi
}

# Test core modules
test_core_modules() {
    CURRENT_TEST_CATEGORY="Core Modules"
    echo "🏗️ Testing Core Modules"
    echo "======================"
    
    # Test basic core modules first
    local basic_modules=("logger" "environment" "validation" "utils")
    
    for module in "${basic_modules[@]}"; do
        test_start "Core module: $module"
        if require_module "core/$module" 2>/dev/null; then
            test_pass "Core module: $module"
        else
            test_fail "Core module: $module" "Failed to load module"
        fi
    done
    
    # Test config module with compatibility check
    test_start "Core module: config (with compatibility check)"
    if [[ "${BASH_VERSION_MODERN:-false}" == "true" ]]; then
        if require_module "core/config" 2>/dev/null; then
            test_pass "Core module: config (advanced)"
        else
            test_fail "Core module: config (advanced)" "Failed to load advanced config module"
        fi
    else
        if require_module "core/config_simple" 2>/dev/null; then
            test_pass "Core module: config (simple - bash 3.2 compatible)"
        else
            test_fail "Core module: config (simple)" "Failed to load simple config module"
        fi
    fi
}

# Test evolution modules
test_evolution_modules() {
    CURRENT_TEST_CATEGORY="Evolution Modules"
    echo "🧬 Testing Evolution Modules"
    echo "============================"
    
    local evolution_modules=("engine" "git" "metrics" "seeds")
    
    for module in "${evolution_modules[@]}"; do
        test_start "Evolution module: $module"
        if require_module "evolution/$module" 2>/dev/null; then
            test_pass "Evolution module: $module"
        else
            test_fail "Evolution module: $module" "Failed to load module"
        fi
    done
}

# Test utility modules
test_utility_modules() {
    CURRENT_TEST_CATEGORY="Utility Modules"
    echo "🔧 Testing Utility Modules"
    echo "=========================="
    
    local utility_modules=("json_processor" "file_operations")
    
    for module in "${utility_modules[@]}"; do
        test_start "Utility module: $module"
        if require_module "utils/$module" 2>/dev/null; then
            test_pass "Utility module: $module"
        else
            test_fail "Utility module: $module" "Failed to load module"
        fi
    done
}

# Test integration modules
test_integration_modules() {
    CURRENT_TEST_CATEGORY="Integration Modules"
    echo "🔗 Testing Integration Modules"
    echo "=============================="
    
    local integration_modules=("github" "ci")
    
    for module in "${integration_modules[@]}"; do
        test_start "Integration module: $module"
        if require_module "integration/$module" 2>/dev/null; then
            test_pass "Integration module: $module"
        else
            test_fail "Integration module: $module" "Failed to load module"
        fi
    done
}

# Test workflow modules
test_workflow_modules() {
    CURRENT_TEST_CATEGORY="Workflow Modules"
    echo "⚙️ Testing Workflow Modules"
    echo "==========================="
    
    test_start "Workflow management module"
    if require_module "workflow/management" 2>/dev/null; then
        test_pass "Workflow management module"
    else
        test_fail "Workflow management module" "Failed to load module"
    fi
}

# Test function availability
test_function_availability() {
    CURRENT_TEST_CATEGORY="Function Availability"
    echo "🎯 Testing Function Availability"
    echo "================================"
    
    # Test logging functions
    local log_functions=("log_info" "log_error" "log_success" "log_warn" "log_debug")
    for func in "${log_functions[@]}"; do
        test_start "Logging function: $func"
        if declare -f "$func" >/dev/null 2>&1; then
            test_pass "Logging function: $func"
        else
            test_fail "Logging function: $func" "Function not available"
        fi
    done
    
    # Test validation functions
    local validation_functions=("validate_required" "validate_file_readable")
    for func in "${validation_functions[@]}"; do
        test_start "Validation function: $func"
        if declare -f "$func" >/dev/null 2>&1; then
            test_pass "Validation function: $func"
        else
            test_fail "Validation function: $func" "Function not available"
        fi
    done
    
    # Test JSON functions
    local json_functions=("json_validate" "json_get_value" "json_set_value")
    for func in "${json_functions[@]}"; do
        test_start "JSON function: $func"
        if declare -f "$func" >/dev/null 2>&1; then
            test_pass "JSON function: $func"
        else
            test_fail "JSON function: $func" "Function not available"
        fi
    done
}

# Test JSON processing functionality
test_json_processing() {
    CURRENT_TEST_CATEGORY="JSON Processing"
    echo "📄 Testing JSON Processing"
    echo "=========================="
    
    # Test JSON validation
    test_start "JSON validation - valid JSON"
    if json_validate '{"test": "value"}' 2>/dev/null; then
        test_pass "JSON validation - valid JSON"
    else
        test_fail "JSON validation - valid JSON" "Valid JSON rejected"
    fi
    
    test_start "JSON validation - invalid JSON"
    if ! json_validate '{"test": value}' 2>/dev/null; then
        test_pass "JSON validation - invalid JSON"
    else
        test_fail "JSON validation - invalid JSON" "Invalid JSON accepted"
    fi
    
    # Test JSON value extraction
    test_start "JSON value extraction"
    local test_json='{"name": "test", "value": 123}'
    local extracted_value=$(json_get_value "$test_json" ".name" "default")
    if [[ "$extracted_value" == "test" ]]; then
        test_pass "JSON value extraction"
    else
        test_fail "JSON value extraction" "Expected 'test', got '$extracted_value'"
    fi
}

# Test file operations
test_file_operations() {
    CURRENT_TEST_CATEGORY="File Operations"
    echo "📁 Testing File Operations"
    echo "=========================="
    
    local test_dir="$TEST_RESULTS_DIR/file-ops-test"
    local test_file="$test_dir/test.txt"
    
    # Test directory creation
    test_start "Directory creation"
    if ensure_directory "$test_dir" 2>/dev/null; then
        test_pass "Directory creation"
    else
        test_fail "Directory creation" "Failed to create directory"
    fi
    
    # Test file backup
    test_start "File backup"
    echo "test content" > "$test_file"
    if file_backup "$test_file" 2>/dev/null; then
        test_pass "File backup"
    else
        test_fail "File backup" "Failed to backup file"
    fi
    
    # Test file restore
    test_start "File restore"
    echo "modified content" > "$test_file"
    if file_restore "$test_file" 2>/dev/null; then
        test_pass "File restore"
    else
        test_fail "File restore" "Failed to restore file"
    fi
    
    # Cleanup
    rm -rf "$test_dir" 2>/dev/null || true
}

# Test environment detection
test_environment_detection() {
    CURRENT_TEST_CATEGORY="Environment Detection"
    echo "🌍 Testing Environment Detection"
    echo "==============================="
    
    test_start "OS detection"
    local detected_os=$(detect_os 2>/dev/null)
    if [[ -n "$detected_os" ]]; then
        test_pass "OS detection (detected: $detected_os)"
    else
        test_fail "OS detection" "No OS detected"
    fi
    
    test_start "ISO timestamp generation"
    local timestamp=$(get_iso_timestamp 2>/dev/null)
    if [[ "$timestamp" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
        test_pass "ISO timestamp generation"
    else
        test_fail "ISO timestamp generation" "Invalid timestamp format: $timestamp"
    fi
}

# Test script integration
test_script_integration() {
    CURRENT_TEST_CATEGORY="Script Integration"
    echo "🔄 Testing Script Integration"
    echo "============================"
    
    # Test modular evolution script
    test_start "Modular evolution script"
    if [[ -x "$PROJECT_ROOT/scripts/modular-evolution.sh" ]]; then
        if "$PROJECT_ROOT/scripts/modular-evolution.sh" help >/dev/null 2>&1; then
            test_pass "Modular evolution script"
        else
            test_fail "Modular evolution script" "Script execution failed"
        fi
    else
        test_fail "Modular evolution script" "Script not found or not executable"
    fi
}

# Generate test report
generate_test_report() {
    echo "📊 Test Results Summary"
    echo "======================="
    echo "Total Tests: $TESTS_TOTAL"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    echo "Success Rate: $(( (TESTS_PASSED * 100) / TESTS_TOTAL ))%"
    echo ""
    
    # Generate JSON report
    local report_file="$TEST_RESULTS_DIR/modular-test-report-$TEST_TIMESTAMP.json"
    cat > "$report_file" << EOF
{
    "test_run": {
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
        "duration": "$(date -d @$(($(date +%s) - $(stat -c %Y "$TEST_LOG_FILE" 2>/dev/null || echo 0))) -u +%H:%M:%S 2>/dev/null || echo "00:00:00")",
        "environment": "$(detect_os 2>/dev/null || echo "unknown")"
    },
    "results": {
        "total": $TESTS_TOTAL,
        "passed": $TESTS_PASSED,
        "failed": $TESTS_FAILED,
        "success_rate": $(( (TESTS_PASSED * 100) / TESTS_TOTAL ))
    },
    "categories_tested": [
        "Bootstrap System",
        "Core Modules", 
        "Evolution Modules",
        "Utility Modules",
        "Integration Modules",
        "Workflow Modules",
        "Function Availability",
        "JSON Processing",
        "File Operations",
        "Environment Detection",
        "Script Integration"
    ]
}
EOF
    
    echo "Test report saved to: $report_file"
    echo "Test log saved to: $TEST_LOG_FILE"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo ""
        echo "🎉 All tests passed! Modular architecture is working correctly."
        return 0
    else
        echo ""
        echo "⚠️  Some tests failed. Please review the test log for details."
        return 1
    fi
}

# Main test execution
main() {
    local test_category="${1:-all}"
    
    init_test_environment
    
    # Source the bootstrap system
    source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
    bootstrap_library
    
    case "$test_category" in
        "bootstrap")
            test_bootstrap_system
            ;;
        "core")
            test_core_modules
            ;;
        "evolution")
            test_evolution_modules
            ;;
        "utilities")
            test_utility_modules
            ;;
        "integration")
            test_integration_modules
            ;;
        "workflows")
            test_workflow_modules
            ;;
        "functions")
            test_function_availability
            ;;
        "json")
            test_json_processing
            ;;
        "files")
            test_file_operations
            ;;
        "environment")
            test_environment_detection
            ;;
        "scripts")
            test_script_integration
            ;;
        "all"|*)
            test_bootstrap_system
            test_core_modules
            test_evolution_modules
            test_utility_modules
            test_integration_modules
            test_workflow_modules
            test_function_availability
            test_json_processing
            test_file_operations
            test_environment_detection
            test_script_integration
            ;;
    esac
    
    generate_test_report
}

# Execute main function with arguments
main "$@"
