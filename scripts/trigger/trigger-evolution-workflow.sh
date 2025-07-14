#!/bin/bash
# scripts/trigger-evolution-workflow.sh
# Triggers the main evolution workflow with generated prompt

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

EVOLUTION_TYPE="${1:-consistency}"
GROWTH_MODE="${2:-adaptive}"

log_info "Triggering main evolution workflow..."

# Read the generated evolution prompt
if [ ! -f "/tmp/evolution_prompt.txt" ]; then
    log_error "Evolution prompt not found"
    exit 1
fi

EVOLUTION_PROMPT=$(cat /tmp/evolution_prompt.txt)

# Trigger the main ai_evolver.yml workflow
gh workflow run ai_evolver.yml \
  --field prompt="$EVOLUTION_PROMPT" \
  --field growth_mode="$GROWTH_MODE" \
  --field auto_plant_seeds="true"

log_success "Daily evolution cycle initiated successfully"
log_info "View the evolution progress in the Actions tab"
log_info "Evolution type: $EVOLUTION_TYPE"
log_info "Growth mode: $GROWTH_MODE"
