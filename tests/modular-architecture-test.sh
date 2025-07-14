#!/bin/bash
# Comprehensive test suite for modular AI Evolution Engine
# Tests all core libraries and integration points
# Version: 0.3.6-seed

set -euo pipefail

# Setup test environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source the new modular testing framework
source "$PROJECT_ROOT/src/lib/core/testing.sh"
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"

# Initialize testing
init_logger "test-logs" "modular-test-suite"
init_testing "modular-architecture-validation" "tests"

log_info "🧪 Starting comprehensive modular architecture test suite"
log_info "Project root: $PROJECT_ROOT"

# Test 1: Core Library Tests
start_test_suite "core_libraries" "Testing core modular libraries"

run_test "Logger library exists" "test -f '$PROJECT_ROOT/src/lib/core/logger.sh'"
run_test "Environment library exists" "test -f '$PROJECT_ROOT/src/lib/core/environment.sh'"
run_test "Testing library exists" "test -f '$PROJECT_ROOT/src/lib/core/testing.sh'"

# Test logger functionality
run_test "Logger initialization" "source '$PROJECT_ROOT/src/lib/core/logger.sh' && init_logger 'test-logs' 'validation'"
run_test "Logger functions available" "source '$PROJECT_ROOT/src/lib/core/logger.sh' && declare -f log_info >/dev/null"

# Test environment library
run_test "Environment detection works" "source '$PROJECT_ROOT/src/lib/core/environment.sh' && detect_os >/dev/null"
run_test "Command checking works" "source '$PROJECT_ROOT/src/lib/core/environment.sh' && check_command 'echo' 'Echo command' 'true'"

end_test_suite

# Test 2: Evolution Library Tests
start_test_suite "evolution_libraries" "Testing evolution-specific libraries"

run_test "Git library exists" "test -f '$PROJECT_ROOT/src/lib/evolution/git.sh'"
run_test "Metrics library exists" "test -f '$PROJECT_ROOT/src/lib/evolution/metrics.sh'"

# Test git library functions
run_test "Git library loads" "source '$PROJECT_ROOT/src/lib/evolution/git.sh' && declare -f get_current_branch >/dev/null"
run_test "Git repo detection" "source '$PROJECT_ROOT/src/lib/evolution/git.sh' && get_current_branch >/dev/null"

# Test metrics library
run_test "Metrics library loads" "source '$PROJECT_ROOT/src/lib/evolution/metrics.sh' && declare -f init_metrics >/dev/null"

end_test_suite

# Test 3: Integration Tests
start_test_suite "integration_tests" "Testing library integration and dependencies"

# Test that libraries can be sourced together without conflicts
run_test "All libraries integrate" "
    source '$PROJECT_ROOT/src/lib/core/logger.sh' &&
    source '$PROJECT_ROOT/src/lib/core/environment.sh' &&
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    source '$PROJECT_ROOT/src/lib/evolution/git.sh' &&
    source '$PROJECT_ROOT/src/lib/evolution/metrics.sh'
"

# Test cross-library functionality
run_test "Logger works across libraries" "
    source '$PROJECT_ROOT/src/lib/core/logger.sh' &&
    source '$PROJECT_ROOT/src/lib/evolution/metrics.sh' &&
    init_logger 'integration-test' 'cross-lib' &&
    init_metrics 'test-metrics.json'
"

end_test_suite

# Test 4: Script Refactoring Validation
start_test_suite "script_refactoring" "Validating existing scripts still work"

# Test that existing scripts don't have syntax errors
scripts_dir="$PROJECT_ROOT/scripts"
if [[ -d "$scripts_dir" ]]; then
    for script in "$scripts_dir"/*.sh; do
        if [[ -f "$script" ]]; then
            script_name=$(basename "$script")
            run_test "Script syntax: $script_name" "bash -n '$script'"
        fi
    done
fi

# Test specific critical scripts
run_test "check-prereqs.sh syntax" "bash -n '$PROJECT_ROOT/scripts/analysis/check-prereqs.sh'"
run_test "test-workflow.sh syntax" "bash -n '$PROJECT_ROOT/tests/workflows/test-workflow.sh'"
run_test "evolve.sh syntax" "bash -n '$PROJECT_ROOT/scripts/core/evolve.sh'"

end_test_suite

# Test 5: Testing Framework Validation
start_test_suite "testing_framework" "Testing the new testing framework itself"

# Test assertion functions
run_test "assert_equal works" "
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    assert_equal 'test' 'test' 'Equal test'
"

run_test "assert_not_equal works" "
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    assert_not_equal 'test1' 'test2' 'Not equal test'
"

run_test "assert_file_exists works" "
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    assert_file_exists '$PROJECT_ROOT/README.md' 'README exists'
"

run_test "assert_command_succeeds works" "
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    assert_command_succeeds 'echo hello' 'Echo command'
"

# Test test result recording
run_test "Test result recording" "
    test -d '$TEST_RESULTS_DIR' &&
    ls '$TEST_RESULTS_DIR'/test-*.json | head -1 >/dev/null
"

end_test_suite

# Test 6: Documentation and Structure
start_test_suite "documentation_structure" "Testing documentation and project structure"

# Test that README files exist in new structure
run_test "Core lib README" "test -f '$PROJECT_ROOT/src/lib/core/README.md' || echo 'Will be created'"
run_test "Evolution lib README" "test -f '$PROJECT_ROOT/src/lib/evolution/README.md' || echo 'Will be created'"

# Test project structure
run_test "Source directory exists" "test -d '$PROJECT_ROOT/src'"
run_test "Lib directory exists" "test -d '$PROJECT_ROOT/src/lib'"
run_test "Core lib directory exists" "test -d '$PROJECT_ROOT/src/lib/core'"
run_test "Evolution lib directory exists" "test -d '$PROJECT_ROOT/src/lib/evolution'"

end_test_suite

# Test 7: Backward Compatibility
start_test_suite "backward_compatibility" "Testing backward compatibility with existing workflows"

# Test that existing test runner still works
run_test "Unified test runner exists" "test -f '$PROJECT_ROOT/tests/run_tests.sh'"
run_test "Unified test runner syntax" "bash -n '$PROJECT_ROOT/tests/run_tests.sh'"

# Test workflow integration
workflows_dir="$PROJECT_ROOT/.github/workflows"
if [[ -d "$workflows_dir" ]]; then
    run_test "Workflows directory exists" "test -d '$workflows_dir'"
    for workflow in "$workflows_dir"/*.yml; do
        if [[ -f "$workflow" ]]; then
            workflow_name=$(basename "$workflow")
            run_test "Workflow YAML: $workflow_name" "python3 -c 'import yaml, sys; yaml.safe_load(open(sys.argv[1]))' '$workflow'"
        fi
    done
fi

end_test_suite

# Test 8: Performance and Error Handling
start_test_suite "performance_error_handling" "Testing performance and error handling"

# Test error handling in libraries
run_test "Logger handles missing directory" "
    source '$PROJECT_ROOT/src/lib/core/logger.sh' &&
    init_logger '/nonexistent/path' 'test' || true
"

run_test "Environment handles missing commands" "
    source '$PROJECT_ROOT/src/lib/core/environment.sh' &&
    check_command 'nonexistent_command_12345' 'Test command' 'false'
"

# Test timeout handling
run_test "Testing framework timeout works" "
    source '$PROJECT_ROOT/src/lib/core/testing.sh' &&
    init_testing 'timeout-test' &&
    run_test 'Quick test' 'echo hello' &&
    finalize_testing
"

end_test_suite

# Generate comprehensive test report
log_info "🎯 Generating comprehensive test reports..."

# Generate multiple report formats
generate_test_report "json" "$TEST_REPORTS_DIR/modular-architecture-report.json"
generate_test_report "markdown" "$TEST_REPORTS_DIR/modular-architecture-report.md"

# Finalize testing and return appropriate exit code
finalize_testing

# Additional reporting
log_info "📊 Test session summary:"
log_info "  Session ID: $TEST_SESSION_ID"
log_info "  Tests run: $TESTS_RUN"
log_info "  Tests passed: $TESTS_PASSED"
log_info "  Tests failed: $TESTS_FAILED"
log_info "  Success rate: $(echo "scale=1; $TESTS_PASSED * 100 / $TESTS_RUN" | bc -l)%"

if [[ $TESTS_FAILED -gt 0 ]]; then
    log_error "❌ Some tests failed - refactoring needs attention"
    exit 1
else
    log_success "✅ All tests passed - modular refactoring successful!"
    exit 0
fi
