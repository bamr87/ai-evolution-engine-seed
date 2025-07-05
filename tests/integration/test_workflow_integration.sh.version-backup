#!/bin/bash

# Integration Tests for GitHub Actions Workflows
# Tests workflow execution in a controlled environment
# Version: 1.0.0

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
success() { echo -e "${GREEN}✓${NC} $1"; ((TESTS_PASSED++)); }
fail() { echo -e "${RED}✗${NC} $1"; ((TESTS_FAILED++)); }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Run a test with error handling
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((TESTS_RUN++))
    
    if eval "$test_command" &>/dev/null; then
        success "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Run a test but don't exit on failure
run_test_safe() {
    local test_name="$1"
    local test_command="$2"
    
    ((TESTS_RUN++))
    
    if eval "$test_command" &>/dev/null; then
        success "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Test workflow context collection simulation
test_context_collection() {
    info "Testing workflow context collection logic..."
    
    # Simulate the context collection script from ai_evolver.yml
    local test_script="$PROJECT_ROOT/tests/fixtures/test_context_collection.sh"
    
    cat > "$test_script" << 'EOF'
#!/bin/bash
set -euo pipefail

# Simulate the context collection from ai_evolver.yml
CONTEXT_FILE="/tmp/test_repo_context.json"

# Initialize context with test metrics
METRICS_CONTENT='{"seed_version": "0.2.0-seed", "growth_cycles": 0, "current_generation": 0, "adaptations_logged": 0, "last_growth_spurt": "Never", "last_prompt": null, "evolution_history": []}'

# Ensure METRICS_CONTENT is valid JSON
if ! echo "$METRICS_CONTENT" | jq empty > /dev/null 2>&1; then
    echo "Error: Invalid JSON in test metrics"
    exit 1
fi

# Collect repository structure (simplified for test)
REPO_STRUCTURE='[{"type": "directory", "name": "test"}]'

jq -n \
  --argjson metrics "$METRICS_CONTENT" \
  --arg prompt "test prompt" \
  --arg growth_mode "adaptive" \
  --argjson repository_structure "$REPO_STRUCTURE" \
  '{
    "timestamp": "2025-07-04T12:00:00Z",
    "user_prompt": $prompt,
    "growth_mode": $growth_mode,
    "current_metrics": $metrics,
    "repository_structure": $repository_structure,
    "files": {}
  }' > "$CONTEXT_FILE"

# Validate the output
if jq empty "$CONTEXT_FILE" > /dev/null 2>&1; then
    echo "Context collection successful"
    exit 0
else
    echo "Context collection failed"
    exit 1
fi
EOF

    chmod +x "$test_script"
    
    run_test "Context collection script execution" "bash '$test_script'"
    run_test "Context file generation" "test -f '/tmp/test_repo_context.json'"
    run_test "Context file contains valid JSON" "jq empty '/tmp/test_repo_context.json'"
    
    # Cleanup
    rm -f "$test_script" "/tmp/test_repo_context.json"
}

# Test metrics update simulation
test_metrics_update() {
    info "Testing metrics update logic..."
    
    # Create test metrics file
    local test_metrics="$PROJECT_ROOT/tests/fixtures/test_evolution_metrics.json"
    cat > "$test_metrics" << 'EOF'
{
  "seed_version": "0.2.0-seed",
  "planted_at": "2025-07-01T00:00:00Z",
  "growth_cycles": 5,
  "current_generation": 10,
  "adaptations_logged": 15,
  "last_growth_spurt": "2025-07-03T12:00:00Z",
  "last_prompt": "previous test prompt",
  "evolution_history": [
    {"cycle": 1, "prompt": "initial prompt", "timestamp": "2025-07-01T12:00:00Z"}
  ]
}
EOF

    # Test metrics update simulation
    local update_script="$PROJECT_ROOT/tests/fixtures/test_metrics_update.sh"
    cat > "$update_script" << 'EOF'
#!/bin/bash
set -euo pipefail

METRICS_FILE="tests/fixtures/test_evolution_metrics.json"
CURRENT_METRICS_JSON=$(cat "$METRICS_FILE")

# Validate input JSON
if ! echo "$CURRENT_METRICS_JSON" | jq empty > /dev/null 2>&1; then
    echo "Error: Invalid input JSON"
    exit 1
fi

CURRENT_CYCLE=$(echo "$CURRENT_METRICS_JSON" | jq -r '.growth_cycles // 0')
CURRENT_GENERATION=$(echo "$CURRENT_METRICS_JSON" | jq -r '.current_generation // 0')
NEW_CYCLE=$((CURRENT_CYCLE + 1))
NEW_GENERATION=$((CURRENT_GENERATION + 1))

# Update metrics
NEW_METRICS_CONTENT=$(echo "$CURRENT_METRICS_JSON" | jq \
  --arg new_cycle "$NEW_CYCLE" \
  --arg new_gen "$NEW_GENERATION" \
  --arg last_prompt "test evolution prompt" \
  --arg last_growth "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{
    "seed_version": (.seed_version // "0.2.0-seed"),
    "planted_at": (.planted_at // $last_growth),
    "growth_cycles": ($new_cycle | tonumber),
    "current_generation": ($new_gen | tonumber),
    "adaptations_logged": ((.adaptations_logged // 0) | tonumber + 1),
    "last_growth_spurt": $last_growth,
    "last_prompt": $last_prompt,
    "evolution_history": ((.evolution_history // []) + [{"cycle": ($new_cycle | tonumber), "prompt": $last_prompt, "timestamp": $last_growth}])
  }')

# Validate output JSON
if echo "$NEW_METRICS_CONTENT" | jq empty > /dev/null 2>&1; then
    echo "Metrics update successful"
    # Write to test output file
    echo "$NEW_METRICS_CONTENT" > "tests/fixtures/test_updated_metrics.json"
    exit 0
else
    echo "Metrics update failed - invalid JSON generated"
    exit 1
fi
EOF

    chmod +x "$update_script"
    
    run_test "Metrics file is valid JSON" "jq empty '$test_metrics'"
    run_test "Metrics update script execution" "bash '$update_script'"
    run_test "Updated metrics file created" "test -f '$PROJECT_ROOT/tests/fixtures/test_updated_metrics.json'"
    run_test "Updated metrics is valid JSON" "jq empty '$PROJECT_ROOT/tests/fixtures/test_updated_metrics.json'"
    
    # Test that values were correctly incremented
    local old_cycles new_cycles
    old_cycles=$(jq -r '.growth_cycles' "$test_metrics")
    new_cycles=$(jq -r '.growth_cycles' "$PROJECT_ROOT/tests/fixtures/test_updated_metrics.json")
    run_test "Growth cycles incremented correctly" "test '$new_cycles' -eq $((old_cycles + 1))"
    
    # Cleanup
    rm -f "$update_script" "$test_metrics" "$PROJECT_ROOT/tests/fixtures/test_updated_metrics.json"
}

# Test daily evolution health check logic
test_health_check_logic() {
    info "Testing daily evolution health check logic..."
    
    # Create test script that simulates health check
    local health_check_script="$PROJECT_ROOT/tests/fixtures/test_health_check.sh"
    cat > "$health_check_script" << 'EOF'
#!/bin/bash
set -euo pipefail

# Simulate health check logic from daily_evolution.yml
ISSUES_FOUND=0
SUGGESTIONS=()

# Check for inconsistent formatting (simulate finding issues)
echo "Checking formatting..."
if find . -name "*.md" -exec grep -l "	" {} \; 2>/dev/null | head -1 > /dev/null; then
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    SUGGESTIONS+=("Fix tab/space inconsistencies in Markdown files")
fi

# Check for TODO comments
echo "Checking TODO items..."
if grep -r "TODO\|FIXME\|XXX" --include="*.md" --include="*.sh" --include="*.yml" . 2>/dev/null | head -1 > /dev/null; then
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    SUGGESTIONS+=("Address pending TODO/FIXME items")
fi

# Check evolution metrics for staleness (simulate old metrics)
echo "Checking evolution metrics..."
if [ -f "evolution-metrics.json" ]; then
    LAST_EVOLUTION=$(jq -r '.last_growth_spurt // "Never"' evolution-metrics.json)
    if [ "$LAST_EVOLUTION" != "null" ] && [ "$LAST_EVOLUTION" != "Never" ]; then
        # Simulate old evolution (more than 7 days)
        DAYS_SINCE=8
        if [ $DAYS_SINCE -gt 7 ]; then
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            SUGGESTIONS+=("Repository hasn't evolved in $DAYS_SINCE days - time for growth")
        fi
    fi
fi

# Output results
echo "Issues found: $ISSUES_FOUND"
echo "Suggestions: ${SUGGESTIONS[*]}"

# Decide if evolution should proceed
SHOULD_EVOLVE="false"
if [ $ISSUES_FOUND -gt 0 ]; then
    SHOULD_EVOLVE="true"
fi

echo "Should evolve: $SHOULD_EVOLVE"
exit 0
EOF

    chmod +x "$health_check_script"
    
    run_test "Health check script execution" "bash '$health_check_script'"
    run_test "Health check detects issues" "bash '$health_check_script' | grep -q 'Should evolve: true'"
    
    # Cleanup
    rm -f "$health_check_script"
}

# Test prompt generation logic
test_prompt_generation() {
    info "Testing evolution prompt generation..."
    
    # Create test health check results that the actual script needs
    cat > "/tmp/health_check_results.env" << 'EOF'
ISSUES_FOUND=3
SHOULD_EVOLVE=true
EOF
    
    # Create test suggestions that the actual script needs
    cat > "/tmp/health_check_suggestions.txt" << 'EOF'
Fix tab/space inconsistencies in Markdown files
Address pending TODO/FIXME items
Repository hasn't evolved in 8 days - time for growth
EOF
    
    # Test the actual prompt generation script
    run_test "Prompt generation script execution" "./scripts/generate-evolution-prompt.sh consistency minimal"
    
    # Check if the prompt file was created and contains expected content
    run_test "Generated prompt contains evolution type" "test -f '/tmp/evolution_prompt.txt' && grep -q 'consistency' '/tmp/evolution_prompt.txt'"
    run_test "Generated prompt contains intensity" "test -f '/tmp/evolution_prompt.txt' && grep -q 'minimal' '/tmp/evolution_prompt.txt'"
    
    # Cleanup
    rm -f "/tmp/health_check_results.env" "/tmp/health_check_suggestions.txt" "/tmp/evolution_prompt.txt"
}

# Test script integration
test_script_integration() {
    info "Testing helper script integration..."
    
    # Test that helper scripts exist
    run_test "generate_seed.sh exists" "test -f '$PROJECT_ROOT/scripts/generate_seed.sh'"
    run_test "generate_ai_response.sh exists" "test -f '$PROJECT_ROOT/scripts/generate_ai_response.sh'"
    run_test "create_pr.sh exists" "test -f '$PROJECT_ROOT/scripts/create_pr.sh'"
    
    # Test that scripts are executable
    run_test "generate_seed.sh is executable" "test -x '$PROJECT_ROOT/scripts/generate_seed.sh'"
    run_test "generate_ai_response.sh is executable" "test -x '$PROJECT_ROOT/scripts/generate_ai_response.sh'"
    run_test "create_pr.sh is executable" "test -x '$PROJECT_ROOT/scripts/create_pr.sh'"
    
    # Test that scripts have basic structure (no syntax errors)
    run_test "generate_seed.sh has valid syntax" "bash -n '$PROJECT_ROOT/scripts/generate_seed.sh'"
    run_test "generate_ai_response.sh has valid syntax" "bash -n '$PROJECT_ROOT/scripts/generate_ai_response.sh'"
    run_test "create_pr.sh has valid syntax" "bash -n '$PROJECT_ROOT/scripts/create_pr.sh'"
}

# Test environment variable handling
test_environment_variables() {
    info "Testing environment variable handling..."
    
    # Test GitHub context variable patterns
    local test_env_script="$PROJECT_ROOT/tests/fixtures/test_env_vars.sh"
    cat > "$test_env_script" << 'EOF'
#!/bin/bash
set -euo pipefail

# Simulate GitHub Actions environment variables
export GITHUB_WORKSPACE="/tmp/test-workspace"
export GITHUB_REPOSITORY="test/ai-evolution-engine"
export GITHUB_REF="refs/heads/main"
export GITHUB_SHA="abcd1234"

# Test variable patterns used in workflows
TEST_INPUT_PROMPT="Test evolution prompt"
TEST_GROWTH_MODE="adaptive"
TEST_AUTO_PLANT_SEEDS="true"

# Validate required variables are set
if [[ -n "$GITHUB_WORKSPACE" ]] && [[ -n "$TEST_INPUT_PROMPT" ]] && [[ -n "$TEST_GROWTH_MODE" ]]; then
    echo "Environment variables validation successful"
    exit 0
else
    echo "Environment variables validation failed"
    exit 1
fi
EOF

    chmod +x "$test_env_script"
    
    run_test "Environment variable simulation" "bash '$test_env_script'"
    
    # Cleanup
    rm -f "$test_env_script"
}

# Create test fixtures directory
setup_test_fixtures() {
    local fixtures_dir="$PROJECT_ROOT/tests/fixtures"
    mkdir -p "$fixtures_dir"
    
    # Create test evolution-metrics.json if it doesn't exist
    if [[ ! -f "$PROJECT_ROOT/evolution-metrics.json" ]]; then
        cat > "$PROJECT_ROOT/evolution-metrics.json" << 'EOF'
{
  "seed_version": "0.2.0-seed",
  "planted_at": "2025-07-01T00:00:00Z",
  "growth_cycles": 0,
  "current_generation": 0,
  "adaptations_logged": 0,
  "last_growth_spurt": "Never",
  "last_prompt": null,
  "evolution_history": []
}
EOF
    fi
}

# Cleanup test fixtures
cleanup_test_fixtures() {
    local fixtures_dir="$PROJECT_ROOT/tests/fixtures"
    if [[ -d "$fixtures_dir" ]]; then
        rm -f "$fixtures_dir"/*.sh "$fixtures_dir"/*.json
    fi
}

# Main test execution
run_all_tests() {
    info "Starting GitHub Actions Workflow Integration Tests..."
    
    setup_test_fixtures || true
    
    test_context_collection || true
    test_metrics_update || true
    test_health_check_logic || true
    test_prompt_generation || true
    test_script_integration || true
    test_environment_variables || true
    
    cleanup_test_fixtures || true
    
    echo ""
    echo "=== Integration Test Results ==="
    echo "Tests Run: $TESTS_RUN"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All integration tests passed!${NC}"
        return 0
    else
        echo -e "${RED}Some integration tests failed!${NC}"
        return 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
