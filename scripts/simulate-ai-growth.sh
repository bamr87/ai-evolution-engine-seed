#!/bin/bash
# scripts/simulate-ai-growth.sh
# Simulates AI growth and generates evolution response

set -euo pipefail

# Source modular libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source logger
source "$PROJECT_ROOT/src/lib/core/logger.sh"

# Source environment detection
source "$PROJECT_ROOT/src/lib/utils/env_detect.sh"

PROMPT="${1:-}"
GROWTH_MODE="${2:-adaptive}"
CONTEXT_FILE="${3:-/tmp/repo_context.json}"
RESPONSE_FILE="${4:-/tmp/evolution_response.json}"

log_info "Simulating AI growth cycle based on prompt: $PROMPT"

# Safely extract current metrics with proper JSON handling
CURRENT_METRICS_JSON=$(jq -r '.current_metrics // {}' "$CONTEXT_FILE")

# Ensure we have a valid JSON object, not a string
if ! echo "$CURRENT_METRICS_JSON" | jq empty > /dev/null 2>&1; then
    log_warn "Invalid metrics JSON detected, using defaults"
    CURRENT_METRICS_JSON='{"growth_cycles": 0, "current_generation": 0, "adaptations_logged": 0}'
fi

CURRENT_CYCLE=$(echo "$CURRENT_METRICS_JSON" | jq -r '.growth_cycles // 0')
CURRENT_GENERATION=$(echo "$CURRENT_METRICS_JSON" | jq -r '.current_generation // 0')
NEW_CYCLE=$((CURRENT_CYCLE + 1))
NEW_GENERATION=$((CURRENT_GENERATION + 1))

log_info "Evolution metrics:"
log_info "  - Current cycle: $CURRENT_CYCLE → $NEW_CYCLE"
log_info "  - Current generation: $CURRENT_GENERATION → $NEW_GENERATION"

# Simulate updating evolution-metrics.json with safer jq operations
if is_macos; then
    LAST_GROWTH=$(date -u +%Y-%m-%dT%H:%M:%SZ)
else
    LAST_GROWTH=$(date -u +%Y-%m-%dT%H:%M:%SZ)
fi

NEW_METRICS_CONTENT=$(echo "$CURRENT_METRICS_JSON" | jq \
  --arg new_cycle "$NEW_CYCLE" \
  --arg new_gen "$NEW_GENERATION" \
  --arg last_prompt "$PROMPT" \
  --arg last_growth "$LAST_GROWTH" \
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

# Generate README update content
ADAPTATIONS_COUNT=$(echo "$NEW_METRICS_CONTENT" | jq -r '.adaptations_logged // 0')
LAST_GROWTH=$(echo "$NEW_METRICS_CONTENT" | jq -r '.last_growth_spurt // "Never"')
README_DYNAMIC_CONTENT="    **Evolutionary State:**\\n    - Generation: $NEW_GENERATION\\n    - Adaptations Logged: $ADAPTATIONS_COUNT\\n    - Last Growth Spurt: $LAST_GROWTH\\n    - Last Prompt: $PROMPT"

# Generate next seed content
NEXT_SEED_CONTENT=$(./scripts/generate_seed.sh "$NEW_CYCLE" "$NEW_GENERATION" "$PROMPT" "$GROWTH_MODE")

# Generate the AI response JSON
./scripts/generate_ai_response.sh \
  "$NEW_CYCLE" \
  "$NEW_GENERATION" \
  "$PROMPT" \
  "$GROWTH_MODE" \
  "$NEW_METRICS_CONTENT" \
  "<!-- AI-EVOLUTION-MARKER:START -->" \
  "<!-- AI-EVOLUTION-MARKER:END -->" \
  "$README_DYNAMIC_CONTENT" \
  "$NEXT_SEED_CONTENT" \
  "$RESPONSE_FILE"

log_success "AI simulation response generated: $RESPONSE_FILE"
log_info "Response summary:"
log_info "  - Branch: $(jq -r '.new_branch' "$RESPONSE_FILE")"
log_info "  - Changes: $(jq '.changes | length' "$RESPONSE_FILE")"
