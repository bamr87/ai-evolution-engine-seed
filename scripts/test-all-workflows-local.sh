#!/bin/bash
# scripts/test-all-workflows-local.sh
# Comprehensive local testing for all workflows in the repository

set -euo pipefail

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🧪 Comprehensive Workflow Testing"
echo "=================================="

# Function to test YAML syntax
test_yaml_syntax() {
    local file="$1"
    echo "  Testing YAML syntax: $(basename "$file")"
    
    if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
        echo "    ✅ Valid YAML syntax"
        return 0
    else
        echo "    ❌ Invalid YAML syntax"
        return 1
    fi
}

# Function to check required scripts
check_required_scripts() {
    local workflow_file="$1"
    echo "  Checking required scripts for: $(basename "$workflow_file")"
    
    local scripts_found=0
    local scripts_missing=0
    
    # Extract script calls from workflow file
    while IFS= read -r line; do
        if [[ "$line" =~ \./scripts/([a-zA-Z0-9_-]+\.sh) ]]; then
            script_name="${BASH_REMATCH[1]}"
            script_path="./scripts/$script_name"
            
            if [ -f "$script_path" ]; then
                echo "    ✅ Found: $script_name"
                scripts_found=$((scripts_found + 1))
            else
                echo "    ❌ Missing: $script_name"
                scripts_missing=$((scripts_missing + 1))
            fi
        fi
    done < "$workflow_file"
    
    echo "    📊 Scripts: $scripts_found found, $scripts_missing missing"
    return $scripts_missing
}

# Function to test specific workflow
test_workflow() {
    local workflow_file="$1"
    local workflow_name="$(basename "$workflow_file" .yml)"
    
    echo ""
    echo "🔍 Testing workflow: $workflow_name"
    echo "-----------------------------------"
    
    # Test YAML syntax
    if ! test_yaml_syntax "$workflow_file"; then
        return 1
    fi
    
    # Check required scripts
    if ! check_required_scripts "$workflow_file"; then
        echo "    ⚠️  Some scripts are missing"
    fi
    
    # Workflow-specific tests
    case "$workflow_name" in
        "daily_evolution")
            echo "  Running daily evolution simulation..."
            ./scripts/test-daily-evolution-local.sh > /tmp/daily_evolution_test.log 2>&1
            if [ $? -eq 0 ]; then
                echo "    ✅ Daily evolution workflow test passed"
            else
                echo "    ❌ Daily evolution workflow test failed"
                echo "    📋 Check log: /tmp/daily_evolution_test.log"
                return 1
            fi
            ;;
        "ai_evolver")
            echo "  Testing AI evolver prerequisites..."
            if ./scripts/check-prereqs.sh "adaptive" "false" > /tmp/ai_evolver_prereq.log 2>&1; then
                echo "    ✅ AI evolver prerequisites passed"
            else
                echo "    ❌ AI evolver prerequisites failed"
                echo "    📋 Check log: /tmp/ai_evolver_prereq.log"
                return 1
            fi
            ;;
        "testing_automation_evolver")
            echo "  Testing automation evolver prerequisites..."
            if ./scripts/check-prereqs.sh "test-automation" > /tmp/testing_automation_prereq.log 2>&1; then
                echo "    ✅ Testing automation prerequisites passed"
            else
                echo "    ❌ Testing automation prerequisites failed"
                echo "    📋 Check log: /tmp/testing_automation_prereq.log"
                return 1
            fi
            ;;
    esac
    
    echo "    🎉 Workflow test completed successfully"
    return 0
}

# Main testing execution
echo ""
echo "📋 Phase 1: YAML Syntax Validation"
echo "=================================="

YAML_ERRORS=0
for workflow_file in .github/workflows/*.yml; do
    if [ -f "$workflow_file" ]; then
        if ! test_yaml_syntax "$workflow_file"; then
            YAML_ERRORS=$((YAML_ERRORS + 1))
        fi
    fi
done

if [ $YAML_ERRORS -gt 0 ]; then
    echo ""
    echo "❌ Found $YAML_ERRORS YAML syntax errors. Please fix before proceeding."
    exit 1
else
    echo ""
    echo "✅ All YAML files have valid syntax"
fi

echo ""
echo "📋 Phase 2: Individual Workflow Testing"
echo "======================================="

WORKFLOW_ERRORS=0
for workflow_file in .github/workflows/*.yml; do
    if [ -f "$workflow_file" ]; then
        if ! test_workflow "$workflow_file"; then
            WORKFLOW_ERRORS=$((WORKFLOW_ERRORS + 1))
        fi
    fi
done

echo ""
echo "📋 Phase 3: Script Dependencies Check"
echo "====================================="

echo "Ensuring all scripts are executable..."
find ./scripts -name "*.sh" -exec chmod +x {} \;
echo "✅ All scripts made executable"

echo ""
echo "🎉 COMPREHENSIVE TEST RESULTS"
echo "============================="

if [ $WORKFLOW_ERRORS -eq 0 ]; then
    echo "✅ All workflows passed local testing!"
    echo "🚀 Workflows are ready for CI/CD execution"
    echo ""
    echo "💡 To run workflows manually:"
    echo "   gh workflow run daily_evolution.yml --repo $(git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git$//')"
    echo "   gh workflow run ai_evolver.yml --repo $(git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git$//')"
    echo "   gh workflow run testing_automation_evolver.yml --repo $(git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git$//')"
else
    echo "❌ $WORKFLOW_ERRORS workflow(s) failed testing"
    echo "🔧 Please review the issues above and fix before deploying"
    exit 1
fi
