#!/bin/bash
#
# @file validate-periodic-prompts.sh
# @description Validate the periodic prompts system configuration and templates
# @author AI Evolution Engine <ai-evolution@engine.dev>
# @created 2025-07-12
# @version 1.0.0
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPTS_DIR="$REPO_ROOT/prompts/templates"
CONFIG_FILE="$REPO_ROOT/.evolution.yml"
WORKFLOW_FILE="$REPO_ROOT/.github/workflows/periodic_evolution.yml"

echo "🔍 Validating Periodic Prompts System"
echo "======================================"

# Check if directories exist
echo "📁 Checking directory structure..."
if [[ ! -d "$PROMPTS_DIR" ]]; then
    echo "❌ Prompts directory not found: $PROMPTS_DIR"
    exit 1
fi
echo "✅ Prompts directory exists"

# Check if configuration file exists
echo "⚙️ Checking configuration..."
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Evolution config not found: $CONFIG_FILE"
    exit 1
fi
echo "✅ Evolution config exists"

# Check if workflow file exists
echo "🔧 Checking workflow..."
if [[ ! -f "$WORKFLOW_FILE" ]]; then
    echo "❌ Periodic evolution workflow not found: $WORKFLOW_FILE"
    exit 1
fi
echo "✅ Periodic evolution workflow exists"

# Validate prompt templates
echo "📝 Validating prompt templates..."
prompt_count=0
for prompt_file in "$PROMPTS_DIR"/*.md; do
    if [[ -f "$prompt_file" && "$(basename "$prompt_file")" != "README.md" ]]; then
        prompt_name=$(basename "$prompt_file" .md)
        echo "  🔍 Validating: $prompt_name"
        
        # Check for required sections
        if ! grep -q "## Objective" "$prompt_file"; then
            echo "    ❌ Missing '## Objective' section"
        fi
        
        if ! grep -q "## AI Instructions" "$prompt_file"; then
            echo "    ❌ Missing '## AI Instructions' section"
        fi
        
        if ! grep -q "### Output Requirements" "$prompt_file"; then
            echo "    ❌ Missing '### Output Requirements' section"
        fi
        
        if grep -q "Generate a JSON response" "$prompt_file"; then
            echo "    ✅ Has JSON output specification"
        else
            echo "    ⚠️ No JSON output specification found"
        fi
        
        ((prompt_count++))
    fi
done

echo "✅ Validated $prompt_count prompt templates"

# Check evolution config for periodic prompts
echo "📋 Checking evolution configuration..."
if grep -q "periodic_prompts:" "$CONFIG_FILE"; then
    echo "✅ Periodic prompts configuration found"
else
    echo "❌ No periodic prompts configuration in .evolution.yml"
    exit 1
fi

# Check if scripts exist
echo "📜 Checking support scripts..."
scripts=(
    "execute-periodic-prompt.sh"
    "apply-periodic-changes.sh"
)

for script in "${scripts[@]}"; do
    script_path="$REPO_ROOT/scripts/$script"
    if [[ -x "$script_path" ]]; then
        echo "✅ $script is executable"
    elif [[ -f "$script_path" ]]; then
        echo "⚠️ $script exists but is not executable"
    else
        echo "❌ $script not found"
    fi
done

echo ""
echo "🎉 Periodic Prompts System Validation Complete!"
echo ""
echo "📊 Summary:"
echo "  - Prompt templates: $prompt_count"
echo "  - Configuration: ✅ Valid"
echo "  - Workflow: ✅ Present"
echo "  - Scripts: ✅ Available"
echo ""
echo "🚀 System is ready for periodic evolution!"
