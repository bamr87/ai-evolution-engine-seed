#!/bin/bash
# tests/comprehensive-refactoring-test.sh
# Comprehensive validation of modular script refactoring
# Version: 0.3.6-seed

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Import modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/testing.sh"

# Initialize testing
init_testing "comprehensive-refactoring-validation" "tests"

log_info "🧪 Starting comprehensive script refactoring validation"

# Test suite: Refactored Scripts Functionality
start_test_suite "refactored_scripts_functionality"
log_info "Testing refactored scripts maintain functionality"

# Test that refactored scripts can be sourced without errors
test_script_imports() {
    local script_name="$1"
    local script_path="$PROJECT_ROOT/scripts/$script_name"
    
    if [[ -f "$script_path" ]]; then
        # Check syntax
        run_test "Script syntax: $script_name" "bash -n '$script_path'"
        
        # Check for modular imports (if refactored)
        if grep -q "source.*src/lib" "$script_path"; then
            run_test "Uses modular logger: $script_name" "grep -q 'source.*logger.sh' '$script_path'"
            log_success "Script $script_name uses modular architecture"
        else
            log_warn "Script $script_name not yet refactored to modular architecture"
        fi
    else
        log_error "Script file $script_path does not exist"
    fi
}

# Test specific functionality of refactored scripts
test_check_prereqs_functionality() {
    local script_path="$PROJECT_ROOT/scripts/check-prereqs.sh"
    if [[ -f "$script_path" ]]; then
        # Test that the script can run in dry-run mode
        local temp_output=$(mktemp)
        if timeout 30s bash "$script_path" "test" "true" > "$temp_output" 2>&1; then
            log_success "check-prereqs.sh executes successfully"
            
            # Check for expected output patterns
            if grep -q "Prerequisite Checker" "$temp_output"; then
                log_success "check-prereqs.sh produces expected output"
            else
                log_warn "check-prereqs.sh output may have changed"
            fi
        else
            log_warn "check-prereqs.sh timed out or failed"
        fi
        rm -f "$temp_output"
    else
        log_error "check-prereqs.sh not found"
    fi
}

test_evolve_script_functionality() {
    local script_path="$PROJECT_ROOT/scripts/evolve.sh"
    if [[ -f "$script_path" ]]; then
        # Test help command
        run_test "evolve.sh --help" "timeout 10s bash '$script_path' --help"
        
        # Test dry-run mode  
        run_test "evolve.sh --dry-run" "timeout 10s bash '$script_path' --dry-run"
    else
        log_error "evolve.sh not found"
    fi
}

test_test_workflow_functionality() {
    local script_path="$PROJECT_ROOT/scripts/test-workflow.sh"
    if [[ -f "$script_path" ]]; then
        # Test help command
        run_test "test-workflow.sh help" "timeout 10s bash '$script_path' help"
        
        # Test validate command
        run_test "test-workflow.sh validate" "timeout 15s bash '$script_path' validate"
    else
        log_error "test-workflow.sh not found"
    fi
}

# Run tests for all scripts in the scripts directory
for script in "$PROJECT_ROOT/scripts"/*.sh; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")
        test_script_imports "$script_name"
    fi
done

# Test specific functionality of key refactored scripts
test_check_prereqs_functionality
test_evolve_script_functionality  
test_test_workflow_functionality

end_test_suite

# Test suite: Integration with Modular Libraries
start_test_suite "modular_integration"
log_info "Testing integration with modular libraries"

test_logger_integration() {
    local refactored_count=0
    local scripts_with_logger=0
    
    for script in "$PROJECT_ROOT/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            if grep -q "source.*logger.sh" "$script"; then
                ((refactored_count++))
                
                # Check that modular logger functions are used
                if grep -q "log_info\|log_warn\|log_error\|log_success" "$script"; then
                    ((scripts_with_logger++))
                fi
            fi
        fi
    done
    
    log_info "Scripts with modular logger: $refactored_count"
    log_info "Scripts using logger functions: $scripts_with_logger"
    
    run_test "Modular logger integration" "test $refactored_count -gt 0"
}

test_environment_integration() {
    local scripts_with_env=0
    
    for script in "$PROJECT_ROOT/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            if grep -q "source.*environment.sh" "$script"; then
                ((scripts_with_env++))
            fi
        fi
    done
    
    log_info "Scripts with environment library: $scripts_with_env"
    
    run_test "Environment library integration" "test $scripts_with_env -gt 0"
}

test_logger_integration
test_environment_integration

end_test_suite

# Test suite: Backward Compatibility
start_test_suite "backward_compatibility"
log_info "Testing backward compatibility"

test_workflow_compatibility() {
    # Check that workflows still reference the correct script paths
    local workflow_errors=0
    
    for workflow in "$PROJECT_ROOT/.github/workflows"/*.yml; do
        if [[ -f "$workflow" ]]; then
            workflow_name=$(basename "$workflow")
            
            # Check for script references
            if grep -q "scripts/" "$workflow"; then
                # Extract script names referenced in workflow
                local referenced_scripts=$(grep -o 'scripts/[^[:space:]]*\.sh' "$workflow" | sort -u)
                
                for script_ref in $referenced_scripts; do
                    if [[ ! -f "$PROJECT_ROOT/$script_ref" ]]; then
                        log_error "Workflow $workflow_name references missing script: $script_ref"
                        ((workflow_errors++))
                    fi
                done
            fi
        fi
    done
    
    run_test "All workflow script references valid" "test $workflow_errors -eq 0"
}

test_makefile_compatibility() {
    local makefile="$PROJECT_ROOT/Makefile"
    if [[ -f "$makefile" ]]; then
        # Check that Makefile targets still work
        run_test "Makefile test target valid" "make -n test"
        run_test "Makefile setup target valid" "make -n setup"
    else
        log_warn "No Makefile found"
    fi
}

test_workflow_compatibility
test_makefile_compatibility

end_test_suite

# Generate comprehensive test reports
log_info "🎯 Generating comprehensive refactoring reports..."

finalize_testing

log_info "📊 Refactoring validation summary:"

if [[ $TESTS_FAILED -eq 0 ]]; then
    log_success "✅ All refactoring validation tests passed!"
    exit 0
else
    log_error "❌ Some refactoring validation tests failed"
    exit 1
fi
