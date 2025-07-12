#!/bin/bash

# 🧪 AI Evolution Engine Test Suite (v3.0.0)
# Simplified testing framework for the evolution engine

set -euo pipefail

# Configuration
TEST_VERSION="3.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Test functions
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((TOTAL_TESTS++))
    log_info "Running test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        log_success "PASS: $test_name"
        ((PASSED_TESTS++))
        return 0
    else
        log_error "FAIL: $test_name"
        ((FAILED_TESTS++))
        return 1
    fi
}

# Test categories
test_scripts() {
    log_info "Testing scripts..."
    
    # Test main scripts exist and are executable
    run_test "evolve.sh exists" "[[ -f '$PROJECT_ROOT/scripts/evolve.sh' ]]"
    run_test "setup.sh exists" "[[ -f '$PROJECT_ROOT/scripts/setup.sh' ]]"
    run_test "test.sh exists" "[[ -f '$PROJECT_ROOT/scripts/test.sh' ]]"
    run_test "evolve.sh executable" "[[ -x '$PROJECT_ROOT/scripts/evolve.sh' ]]"
    run_test "setup.sh executable" "[[ -x '$PROJECT_ROOT/scripts/setup.sh' ]]"
    run_test "test.sh executable" "[[ -x '$PROJECT_ROOT/scripts/test.sh' ]]"
    
    # Test core engine
    run_test "evolution-core.sh exists" "[[ -f '$PROJECT_ROOT/src/evolution-core.sh' ]]"
    run_test "evolution-core.sh executable" "[[ -x '$PROJECT_ROOT/src/evolution-core.sh' ]]"
    
    # Test script functionality
    run_test "evolve.sh help" "$PROJECT_ROOT/scripts/evolve.sh help >/dev/null"
    run_test "setup.sh help" "$PROJECT_ROOT/scripts/setup.sh help >/dev/null"
    run_test "test.sh help" "$PROJECT_ROOT/scripts/test.sh help >/dev/null"
    run_test "evolution-core.sh help" "$PROJECT_ROOT/src/evolution-core.sh help >/dev/null"
}

test_workflows() {
    log_info "Testing workflows..."
    
    # Test workflow files exist
    run_test "evolve.yml exists" "[[ -f '$PROJECT_ROOT/.github/workflows/evolve.yml' ]]"
    run_test "test.yml exists" "[[ -f '$PROJECT_ROOT/.github/workflows/test.yml' ]]"
    
    # Test workflow YAML syntax (basic check)
    run_test "evolve.yml valid YAML" "grep -q 'name:' '$PROJECT_ROOT/.github/workflows/evolve.yml'"
    run_test "test.yml valid YAML" "grep -q 'name:' '$PROJECT_ROOT/.github/workflows/test.yml'"
    
    # Test workflow structure
    run_test "evolve.yml has jobs" "grep -q 'jobs:' '$PROJECT_ROOT/.github/workflows/evolve.yml'"
    run_test "test.yml has jobs" "grep -q 'jobs:' '$PROJECT_ROOT/.github/workflows/test.yml'"
}

test_integration() {
    log_info "Testing integration..."
    
    # Test environment setup
    run_test "setup environment" "$PROJECT_ROOT/scripts/setup.sh --no-deps --no-prereqs >/dev/null"
    
    # Test context collection
    run_test "context collection" "$PROJECT_ROOT/src/evolution-core.sh context test-output >/dev/null"
    run_test "context file created" "[[ -f 'test-output/repo-context.json' ]]"
    
    # Test evolution simulation
    run_test "evolution simulation" "$PROJECT_ROOT/src/evolution-core.sh simulate -p 'test' -m conservative test-output >/dev/null"
    run_test "response file created" "[[ -f 'test-output/evolution-response.json' ]]"
    
    # Test validation
    run_test "validation" "$PROJECT_ROOT/src/evolution-core.sh validate >/dev/null"
    
    # Cleanup test output
    rm -rf test-output 2>/dev/null || true
}

test_validation() {
    log_info "Testing validation..."
    
    # Test JSON syntax
    if [[ -f "evolution-output/repo-context.json" ]]; then
        run_test "context JSON valid" "jq empty evolution-output/repo-context.json >/dev/null"
    fi
    
    if [[ -f "evolution-output/evolution-response.json" ]]; then
        run_test "response JSON valid" "jq empty evolution-output/evolution-response.json >/dev/null"
    fi
    
    # Test directory structure
    run_test "scripts directory exists" "[[ -d '$PROJECT_ROOT/scripts' ]]"
    run_test "src directory exists" "[[ -d '$PROJECT_ROOT/src' ]]"
    run_test "docs directory exists" "[[ -d '$PROJECT_ROOT/docs' ]]"
    run_test "tests directory exists" "[[ -d '$PROJECT_ROOT/tests' ]]"
    
    # Test essential files
    run_test "README.md exists" "[[ -f '$PROJECT_ROOT/README.md' ]]"
    run_test "LICENSE exists" "[[ -f '$PROJECT_ROOT/LICENSE' ]]"
}

test_all() {
    log_info "Running all tests..."
    
    test_scripts
    test_workflows
    test_integration
    test_validation
}

# Report generation
generate_report() {
    local output_format="${1:-text}"
    local report_file="tests/results/test-report-$(date +%Y%m%d-%H%M%S).txt"
    
    mkdir -p tests/results
    
    case "$output_format" in
        "text")
            cat > "$report_file" << EOF
🧪 AI Evolution Engine Test Report
==================================

Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Version: $TEST_VERSION

Summary:
- Total Tests: $TOTAL_TESTS
- Passed: $PASSED_TESTS
- Failed: $FAILED_TESTS
- Success Rate: $((PASSED_TESTS * 100 / TOTAL_TESTS))%

Status: $([[ $FAILED_TESTS -eq 0 ]] && echo "✅ ALL TESTS PASSED" || echo "❌ SOME TESTS FAILED")

Test Categories:
- Scripts: $(grep -c "PASS.*script" tests/results/*.txt 2>/dev/null || echo "0") passed
- Workflows: $(grep -c "PASS.*workflow" tests/results/*.txt 2>/dev/null || echo "0") passed
- Integration: $(grep -c "PASS.*integration" tests/results/*.txt 2>/dev/null || echo "0") passed
- Validation: $(grep -c "PASS.*validation" tests/results/*.txt 2>/dev/null || echo "0") passed
EOF
            ;;
        "json")
            cat > "$report_file" << EOF
{
  "metadata": {
    "version": "$TEST_VERSION",
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "test_suite": "ai-evolution-engine"
  },
  "summary": {
    "total_tests": $TOTAL_TESTS,
    "passed_tests": $PASSED_TESTS,
    "failed_tests": $FAILED_TESTS,
    "success_rate": $((PASSED_TESTS * 100 / TOTAL_TESTS))
  },
  "status": "$([[ $FAILED_TESTS -eq 0 ]] && echo "success" || echo "failure")",
  "categories": {
    "scripts": $(grep -c "PASS.*script" tests/results/*.txt 2>/dev/null || echo "0"),
    "workflows": $(grep -c "PASS.*workflow" tests/results/*.txt 2>/dev/null || echo "0"),
    "integration": $(grep -c "PASS.*integration" tests/results/*.txt 2>/dev/null || echo "0"),
    "validation": $(grep -c "PASS.*validation" tests/results/*.txt 2>/dev/null || echo "0")
  }
}
EOF
            ;;
        "html")
            cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>AI Evolution Engine Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
        .summary { margin: 20px 0; }
        .success { color: green; }
        .failure { color: red; }
        .warning { color: orange; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🧪 AI Evolution Engine Test Report</h1>
        <p><strong>Date:</strong> $(date -u +"%Y-%m-%dT%H:%M:%SZ")</p>
        <p><strong>Version:</strong> $TEST_VERSION</p>
    </div>
    
    <div class="summary">
        <h2>Summary</h2>
        <ul>
            <li><strong>Total Tests:</strong> $TOTAL_TESTS</li>
            <li><strong>Passed:</strong> <span class="success">$PASSED_TESTS</span></li>
            <li><strong>Failed:</strong> <span class="failure">$FAILED_TESTS</span></li>
            <li><strong>Success Rate:</strong> $((PASSED_TESTS * 100 / TOTAL_TESTS))%</li>
        </ul>
        
        <p><strong>Status:</strong> 
            <span class="$([[ $FAILED_TESTS -eq 0 ]] && echo "success" || echo "failure")">
                $([[ $FAILED_TESTS -eq 0 ]] && echo "✅ ALL TESTS PASSED" || echo "❌ SOME TESTS FAILED")
            </span>
        </p>
    </div>
</body>
</html>
EOF
            ;;
    esac
    
    echo "$report_file"
}

# Main function
main() {
    local test_type="${1:-all}"
    local output_format="${2:-text}"
    local verbose="${3:-false}"
    
    # Reset counters
    TOTAL_TESTS=0
    PASSED_TESTS=0
    FAILED_TESTS=0
    
    log_info "🧪 Starting AI Evolution Engine Test Suite (v$TEST_VERSION)"
    
    # Create results directory
    mkdir -p tests/results
    
    # Run tests based on type
    case "$test_type" in
        "scripts")
            test_scripts
            ;;
        "workflows")
            test_workflows
            ;;
        "integration")
            test_integration
            ;;
        "validation")
            test_validation
            ;;
        "all")
            test_all
            ;;
        "help"|*)
            cat << EOF
🧪 AI Evolution Engine Test Suite (v$TEST_VERSION)

Usage: $0 <test_type> [output_format] [verbose]

Test Types:
  all         Run all tests (default)
  scripts     Test script functionality
  workflows   Test workflow files
  integration Test integration scenarios
  validation  Test validation checks
  help        Show this help

Output Formats:
  text        Text report (default)
  json        JSON report
  html        HTML report

Examples:
  $0 all
  $0 scripts text
  $0 integration json
  $0 validation html

EOF
            exit 0
            ;;
    esac
    
    # Generate report
    local report_file=$(generate_report "$output_format")
    
    # Display summary
    echo ""
    log_info "📊 Test Summary"
    echo "================"
    echo "Total Tests: $TOTAL_TESTS"
    echo "Passed: $PASSED_TESTS"
    echo "Failed: $FAILED_TESTS"
    echo "Success Rate: $((PASSED_TESTS * 100 / TOTAL_TESTS))%"
    echo ""
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        log_success "🎉 ALL TESTS PASSED!"
        echo "Report saved to: $report_file"
        exit 0
    else
        log_error "❌ $FAILED_TESTS TESTS FAILED"
        echo "Report saved to: $report_file"
        exit 1
    fi
}

# Run main function with all arguments
main "$@" 