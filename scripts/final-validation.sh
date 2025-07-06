#!/bin/bash
# scripts/final-validation.sh
# Final validation that all workflow issues have been resolved

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🎯 Final Workflow Validation Report"
echo "===================================="
echo ""

# Test 1: YAML Syntax Validation
echo "📋 1. YAML Syntax Validation"
echo "----------------------------"
YAML_ERRORS=0
for workflow in .github/workflows/*.yml; do
    if python3 -c "import yaml; yaml.safe_load(open('$workflow'))" 2>/dev/null; then
        echo "  ✅ $(basename "$workflow"): Valid syntax"
    else
        echo "  ❌ $(basename "$workflow"): Invalid syntax"
        YAML_ERRORS=$((YAML_ERRORS + 1))
    fi
done

# Test 2: Character Encoding Check
echo ""
echo "📋 2. Character Encoding Validation"
echo "-----------------------------------"
ENCODING_ISSUES=0
for workflow in .github/workflows/*.yml; do
    if file "$workflow" | grep -q "UTF-8"; then
        echo "  ✅ $(basename "$workflow"): Proper UTF-8 encoding"
    else
        echo "  ⚠️  $(basename "$workflow"): Encoding check needed"
        ENCODING_ISSUES=$((ENCODING_ISSUES + 1))
    fi
done

# Test 3: Script Functionality
echo ""
echo "📋 3. Core Script Functionality"
echo "-------------------------------"
SCRIPT_ERRORS=0

# Test check-prereqs.sh
if ./scripts/check-prereqs.sh "adaptive" "false" >/dev/null 2>&1; then
    echo "  ✅ check-prereqs.sh: Working correctly"
else
    echo "  ❌ check-prereqs.sh: Still failing"
    SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
fi

# Test analyze-repository-health.sh
if ./scripts/analyze-repository-health.sh "consistency" "minimal" "false" >/dev/null 2>&1; then
    echo "  ✅ analyze-repository-health.sh: Working correctly"
else
    echo "  ❌ analyze-repository-health.sh: Still failing"
    SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
fi

# Test 4: Workflow Dependencies
echo ""
echo "📋 4. Workflow Script Dependencies"
echo "----------------------------------"
MISSING_SCRIPTS=0
required_scripts=(
    "setup-environment.sh"
    "check-prereqs.sh"
    "analyze-repository-health.sh"
    "generate-evolution-prompt.sh"
    "trigger-evolution-workflow.sh"
    "update-evolution-metrics.sh"
    "collect-context.sh"
    "simulate-ai-growth.sh"
    "apply-growth-changes.sh"
    "generate_seed.sh"
    "plant-new-seeds.sh"
    "generate_ai_response.sh"
    "create_pr.sh"
    "test-evolved-seed.sh"
)

for script in "${required_scripts[@]}"; do
    if [ -f "./scripts/$script" ] && [ -x "./scripts/$script" ]; then
        echo "  ✅ $script: Found and executable"
    else
        echo "  ❌ $script: Missing or not executable"
        MISSING_SCRIPTS=$((MISSING_SCRIPTS + 1))
    fi
done

# Test 5: End-to-End Workflow Simulation
echo ""
echo "📋 5. End-to-End Workflow Simulation"
echo "------------------------------------"
E2E_ERRORS=0

# Simulate daily evolution workflow in dry-run mode
export EVOLUTION_TYPE="consistency"
export INTENSITY="minimal"
export FORCE_RUN="false"
export DRY_RUN="true"

echo "  🧪 Testing daily evolution workflow..."
if ./scripts/test-daily-evolution-local.sh >/dev/null 2>&1; then
    echo "  ✅ Daily evolution workflow: Complete simulation successful"
else
    echo "  ❌ Daily evolution workflow: Simulation failed"
    E2E_ERRORS=$((E2E_ERRORS + 1))
fi

# Final Report
echo ""
echo "🎯 FINAL VALIDATION SUMMARY"
echo "============================"
echo ""

TOTAL_ERRORS=$((YAML_ERRORS + ENCODING_ISSUES + SCRIPT_ERRORS + MISSING_SCRIPTS + E2E_ERRORS))

if [ $TOTAL_ERRORS -eq 0 ]; then
    echo "🎉 ALL VALIDATIONS PASSED!"
    echo ""
    echo "✅ YAML syntax is valid across all workflows"
    echo "✅ Character encoding issues have been resolved"
    echo "✅ Core scripts are functioning correctly"
    echo "✅ All required script dependencies are present"
    echo "✅ End-to-end workflow simulation completed successfully"
    echo ""
    echo "🚀 The workflows are ready for production deployment!"
    echo ""
    echo "💡 Next steps:"
    echo "   1. Commit the fixes to the repository"
    echo "   2. Test the workflows in the GitHub Actions environment"
    echo "   3. Monitor the daily evolution workflow execution"
    echo ""
    echo "📋 To manually trigger workflows:"
    echo "   gh workflow run daily_evolution.yml -f dry_run=true"
    echo "   gh workflow run ai_evolver.yml -f dry_run=true"
    echo "   gh workflow run testing_automation_evolver.yml -f dry_run=true"
    
    exit 0
else
    echo "❌ VALIDATION FAILED: $TOTAL_ERRORS issues found"
    echo ""
    [ $YAML_ERRORS -gt 0 ] && echo "  • $YAML_ERRORS YAML syntax errors"
    [ $ENCODING_ISSUES -gt 0 ] && echo "  • $ENCODING_ISSUES character encoding issues"
    [ $SCRIPT_ERRORS -gt 0 ] && echo "  • $SCRIPT_ERRORS script functionality errors"
    [ $MISSING_SCRIPTS -gt 0 ] && echo "  • $MISSING_SCRIPTS missing script dependencies"
    [ $E2E_ERRORS -gt 0 ] && echo "  • $E2E_ERRORS end-to-end workflow errors"
    echo ""
    echo "🔧 Please review and fix the issues above before proceeding."
    
    exit 1
fi
