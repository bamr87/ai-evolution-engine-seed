#!/bin/bash
# scripts/trigger-evolution-workflow.sh
# Triggers the main evolution workflow with generated prompt

set -euo pipefail

EVOLUTION_TYPE="${1:-consistency}"
GROWTH_MODE="${2:-adaptive}"

echo "🚀 Triggering main evolution workflow..."

# Read the generated evolution prompt
if [ ! -f "/tmp/evolution_prompt.txt" ]; then
    echo "❌ Error: Evolution prompt not found"
    exit 1
fi

EVOLUTION_PROMPT=$(cat /tmp/evolution_prompt.txt)

# Trigger the main ai_evolver.yml workflow
gh workflow run ai_evolver.yml \
  --field prompt="$EVOLUTION_PROMPT" \
  --field growth_mode="$GROWTH_MODE" \
  --field auto_plant_seeds="true"

echo "✅ Daily evolution cycle initiated successfully"
echo "📝 View the evolution progress in the Actions tab"
echo "🔧 Evolution type: $EVOLUTION_TYPE"
echo "🌱 Growth mode: $GROWTH_MODE"
