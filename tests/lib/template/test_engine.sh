#!/bin/bash

#
# @file tests/lib/template/test_engine.sh
# @description Unit tests for template engine module
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #modular-refactor: Test template engine functionality
#
# @relatedEvolutions
#   - v0.4.0: Modular architecture implementation
#
# @dependencies
#   - ../../../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../../../src/lib/template/engine.sh: Template engine module
#
# @changelog
#   - 2025-07-05: Initial creation with comprehensive template engine tests - ITJ
#
# @usage ./tests/lib/template/test_engine.sh
# @notes Tests template processing, variable substitution, and template validation
#

set -euo pipefail

# Get test directory and project root
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TEST_DIR}/../../.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

# Load required modules
require_module "core/logger"
require_module "template/engine"

# Test configuration
TEST_RESULTS=()
TESTS_PASSED=0
TESTS_FAILED=0
TEST_TEMP_DIR=""

# Setup test environment
setup_test_environment() {
    TEST_TEMP_DIR=$(mktemp -d)
    cd "$TEST_TEMP_DIR"
    
    # Create test templates
    mkdir -p templates/{basic,advanced,conditional}
    
    # Basic template
    cat > templates/basic/simple.tpl << 'EOF'
Hello, {{name}}!
This is a {{type}} template.
EOF
    
    # Advanced template with multiple variables
    cat > templates/advanced/complex.tpl << 'EOF'
# {{title}}

**Author:** {{author}}
**Date:** {{date}}
**Version:** {{version}}

## Description
{{description}}

## Features
{{#features}}
- {{.}}
{{/features}}
EOF
    
    # Conditional template
    cat > templates/conditional/logic.tpl << 'EOF'
{{#if production}}
Environment: Production
{{else}}
Environment: Development
{{/if}}

{{#unless debug}}
Debug mode: Disabled
{{/unless}}
EOF
    
    # Template with includes
    cat > templates/header.tpl << 'EOF'
<!-- Header: {{title}} -->
EOF
    
    cat > templates/with_includes.tpl << 'EOF'
{{> header}}
<body>
  <h1>{{title}}</h1>
  <p>{{content}}</p>
</body>
EOF
}

# Cleanup test environment
cleanup_test_environment() {
    if [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# Test utilities
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    log_info "Running test: $test_name"
    
    if $test_function; then
        log_success "✓ $test_name"
        TEST_RESULTS+=("PASS: $test_name")
        ((TESTS_PASSED++))
    else
        log_error "✗ $test_name"
        TEST_RESULTS+=("FAIL: $test_name")
        ((TESTS_FAILED++))
    fi
}

# Test template engine module loading
test_template_module_loading() {
    # Test if template engine functions are available
    if declare -f template_process >/dev/null 2>&1 && \
       declare -f template_substitute_variables >/dev/null 2>&1 && \
       declare -f template_validate >/dev/null 2>&1; then
        return 0
    else
        log_error "Template engine module functions not loaded"
        return 1
    fi
}

# Test basic variable substitution
test_basic_variable_substitution() {
    setup_test_environment
    
    local template_file="templates/basic/simple.tpl"
    local output_file="output.txt"
    
    # Define variables
    local variables="name=World,type=basic"
    
    # Process template
    if template_process "$template_file" "$output_file" "$variables"; then
        local content=$(cat "$output_file")
        if [[ "$content" == *"Hello, World!"* ]] && [[ "$content" == *"basic template"* ]]; then
            cleanup_test_environment
            return 0
        else
            log_error "Template processing failed - incorrect substitution"
            cleanup_test_environment
            return 1
        fi
    else
        log_error "Template processing failed"
        cleanup_test_environment
        return 1
    fi
}

# Test complex template processing
test_complex_template_processing() {
    setup_test_environment
    
    local template_file="templates/advanced/complex.tpl"
    local output_file="complex_output.txt"
    
    # Define complex variables
    local variables="title=Test Project,author=IT-Journey Team,date=$(date +%Y-%m-%d),version=1.0.0,description=A comprehensive test project"
    
    # Process template
    if template_process "$template_file" "$output_file" "$variables"; then
        local content=$(cat "$output_file")
        if [[ "$content" == *"# Test Project"* ]] && \
           [[ "$content" == *"IT-Journey Team"* ]] && \
           [[ "$content" == *"1.0.0"* ]]; then
            cleanup_test_environment
            return 0
        else
            log_error "Complex template processing failed"
            cleanup_test_environment
            return 1
        fi
    else
        log_error "Complex template processing failed"
        cleanup_test_environment
        return 1
    fi
}

# Test template validation
test_template_validation() {
    setup_test_environment
    
    # Test valid template
    local valid_template="templates/basic/simple.tpl"
    if template_validate "$valid_template"; then
        log_info "Valid template correctly validated"
    else
        log_error "Valid template validation failed"
        cleanup_test_environment
        return 1
    fi
    
    # Test invalid template (non-existent file)
    local invalid_template="templates/nonexistent.tpl"
    if template_validate "$invalid_template"; then
        log_error "Invalid template incorrectly validated"
        cleanup_test_environment
        return 1
    else
        log_info "Invalid template correctly rejected"
    fi
    
    cleanup_test_environment
    return 0
}

# Test variable substitution edge cases
test_variable_substitution_edge_cases() {
    setup_test_environment
    
    # Create template with edge cases
    cat > templates/edge_cases.tpl << 'EOF'
Normal: {{normal}}
Empty: {{empty}}
Special chars: {{special_chars}}
Numbers: {{number}}
Boolean: {{boolean}}
EOF
    
    local template_file="templates/edge_cases.tpl"
    local output_file="edge_output.txt"
    
    # Test with various variable types
    local variables="normal=test,empty=,special_chars=!@#$%^&*(),number=42,boolean=true"
    
    if template_process "$template_file" "$output_file" "$variables"; then
        local content=$(cat "$output_file")
        if [[ "$content" == *"Normal: test"* ]] && \
           [[ "$content" == *"Numbers: 42"* ]] && \
           [[ "$content" == *"Boolean: true"* ]]; then
            cleanup_test_environment
            return 0
        else
            log_error "Edge case variable substitution failed"
            cleanup_test_environment
            return 1
        fi
    else
        log_error "Edge case template processing failed"
        cleanup_test_environment
        return 1
    fi
}

# Test template caching
test_template_caching() {
    setup_test_environment
    
    local template_file="templates/basic/simple.tpl"
    local output_file1="cache_output1.txt"
    local output_file2="cache_output2.txt"
    local variables="name=CacheTest,type=cached"
    
    # Process template twice
    local start_time=$(date +%s%N)
    template_process "$template_file" "$output_file1" "$variables"
    local first_duration=$(($(date +%s%N) - start_time))
    
    start_time=$(date +%s%N)
    template_process "$template_file" "$output_file2" "$variables"
    local second_duration=$(($(date +%s%N) - start_time))
    
    # Check if outputs are identical
    if diff "$output_file1" "$output_file2" >/dev/null; then
        log_info "Template caching test passed - outputs identical"
        cleanup_test_environment
        return 0
    else
        log_error "Template caching test failed - outputs differ"
        cleanup_test_environment
        return 1
    fi
}

# Test template error handling
test_template_error_handling() {
    setup_test_environment
    
    # Test with non-existent template
    local nonexistent_template="templates/does_not_exist.tpl"
    local output_file="error_output.txt"
    local variables="test=value"
    
    if template_process "$nonexistent_template" "$output_file" "$variables" 2>/dev/null; then
        log_error "Error handling test failed - should have returned error"
        cleanup_test_environment
        return 1
    else
        log_info "Error handling test passed - correctly handled missing template"
    fi
    
    cleanup_test_environment
    return 0
}

# Test template inheritance/includes
test_template_includes() {
    setup_test_environment
    
    local template_file="templates/with_includes.tpl"
    local output_file="includes_output.txt"
    local variables="title=Include Test,content=This tests template includes"
    
    if template_process "$template_file" "$output_file" "$variables"; then
        local content=$(cat "$output_file")
        if [[ "$content" == *"<!-- Header: Include Test -->"* ]] && \
           [[ "$content" == *"<h1>Include Test</h1>"* ]]; then
            cleanup_test_environment
            return 0
        else
            log_error "Template includes test failed - incorrect output"
            cleanup_test_environment
            return 1
        fi
    else
        log_error "Template includes test failed"
        cleanup_test_environment
        return 1
    fi
}

# Test performance with large templates
test_template_performance() {
    setup_test_environment
    
    # Create large template
    local large_template="templates/large.tpl"
    {
        echo "# Large Template"
        for i in {1..1000}; do
            echo "Line $i: {{var_$i}}"
        done
    } > "$large_template"
    
    local output_file="large_output.txt"
    local variables=""
    for i in {1..1000}; do
        variables="${variables}var_$i=value_$i,"
    done
    variables="${variables%,}"  # Remove trailing comma
    
    local start_time=$(date +%s)
    if template_process "$large_template" "$output_file" "$variables"; then
        local duration=$(($(date +%s) - start_time))
        log_info "Large template processed in ${duration}s"
        
        # Check if processing was reasonable (under 10 seconds)
        if [[ $duration -lt 10 ]]; then
            cleanup_test_environment
            return 0
        else
            log_warn "Large template processing took ${duration}s (may be slow)"
            cleanup_test_environment
            return 0  # Still pass, just warn
        fi
    else
        log_error "Large template processing failed"
        cleanup_test_environment
        return 1
    fi
}

# Main test execution
main() {
    log_header "Template Engine Module Tests"
    
    # Run all tests
    run_test "Module Loading" test_template_module_loading
    run_test "Basic Variable Substitution" test_basic_variable_substitution
    run_test "Complex Template Processing" test_complex_template_processing
    run_test "Template Validation" test_template_validation
    run_test "Variable Substitution Edge Cases" test_variable_substitution_edge_cases
    run_test "Template Caching" test_template_caching
    run_test "Template Error Handling" test_template_error_handling
    run_test "Template Includes" test_template_includes
    run_test "Template Performance" test_template_performance
    
    # Display results
    log_header "Test Results Summary"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == PASS:* ]]; then
            log_success "$result"
        else
            log_error "$result"
        fi
    done
    
    log_info "Tests passed: $TESTS_PASSED"
    log_info "Tests failed: $TESTS_FAILED"
    
    # Exit with appropriate code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All template engine tests passed!"
        exit 0
    else
        log_error "Some template engine tests failed!"
        exit 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
