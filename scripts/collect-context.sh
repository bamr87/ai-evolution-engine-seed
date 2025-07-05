#!/bin/bash
# scripts/collect-context.sh
# Collects repository context and metrics for AI evolution
# Version: 0.3.6-seed - Modular Architecture

set -euo pipefail

# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Import modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

# Initialize logging
init_logger "logs" "collect-context"

PROMPT="${1:-}"
GROWTH_MODE="${2:-adaptive}"
CONTEXT_FILE="${3:-/tmp/repo_context.json}"

log_info "🧬 Analyzing repository genome and current metrics..."

# Initialize context with metadata and metrics using modular function
METRICS_CONTENT=$(load_metrics_data)

# Collect repository structure using tree command
REPO_STRUCTURE=$(tree -J -L 3 -I ".git|node_modules|venv|dist|build" || echo "[]")

# Create base context
jq -n \
  --argjson metrics "$METRICS_CONTENT" \
  --arg prompt "$PROMPT" \
  --arg growth_mode "$GROWTH_MODE" \
  --argjson repository_structure "$REPO_STRUCTURE" \
  '{
    "timestamp": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'",
    "user_prompt": $prompt,
    "growth_mode": $growth_mode,
    "current_metrics": $metrics,
    "repository_structure": $repository_structure,
    "files": {}
  }' > "$CONTEXT_FILE"

# Add file contents (respecting .gptignore if present, else common ignores)
IGNORE_PATTERNS='\.git|\.DS_Store|node_modules|venv|env|dist|build|\*.pyc|__pycache__|\*.log|\*.tmp|\*.swp'

if [ -f .gptignore ]; then
  GPTIGNORE_PATTERNS=$(cat .gptignore | grep -v '^#' | grep -v '^[[:space:]]*$' | sed 's|/$|/.*|' | paste -sd '|')
  if [ -n "$GPTIGNORE_PATTERNS" ]; then
    IGNORE_PATTERNS="$IGNORE_PATTERNS|$GPTIGNORE_PATTERNS"
  fi
fi

MAX_FILES=$(jq -r '.evolution.max_context_files // 50' .evolution.yml 2>/dev/null || echo 50)
MAX_LINES=$(jq -r '.evolution.max_context_line_per_file // 1000' .evolution.yml 2>/dev/null || echo 1000)

echo "📁 Adding file contents to context (max $MAX_FILES files, $MAX_LINES lines each)..."

find . -type f | grep -Ev "$IGNORE_PATTERNS" | head -n "$MAX_FILES" | \
while IFS= read -r file; do
  echo "Adding $file to context..."
  # Ensure file path is a valid JSON string key
  file_key=$(echo "$file" | sed 's|^\./||')
  jq --arg path "$file_key" \
     --arg content "$(cat "$file" | head -n "$MAX_LINES")" \
    '.files[$path] = $content' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"
done

echo "✅ Context collected in $CONTEXT_FILE"
echo "📊 Context summary:"
echo "  - Files: $(jq '.files | length' "$CONTEXT_FILE")"
echo "  - Growth mode: $GROWTH_MODE"
echo "  - Current cycle: $(jq -r '.current_metrics.growth_cycles // 0' "$CONTEXT_FILE")"
