#!/bin/bash

#
# @file scripts/collect-context.sh
# @description Collects repository context and metrics for AI evolution using modular architecture
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-12
# @version 2.1.0
#
# @relatedIssues 
#   - #modular-refactor: Migrate to modular architecture
#   - #context-collection: Enhanced context collection capabilities
#   - #workflow-fix: Fix command line argument parsing for GitHub Actions
#
# @relatedEvolutions
#   - v2.1.0: Fixed command line argument parsing to support flags
#   - v2.0.0: Migrated to modular architecture with enhanced context collection
#   - v0.3.6: Original implementation with basic context collection
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../src/lib/evolution/metrics.sh: Metrics collection module
#   - ../src/lib/analysis/health.sh: Health analysis for context
#
# @changelog
#   - 2025-07-12: Fixed command line argument parsing to support --flags - ITJ
#   - 2025-07-05: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced context collection with health analysis - ITJ
#
# @usage ./scripts/collect-context.sh [--prompt "text"] [--growth-mode mode] [--context-file path] [--include-health] [--include-tests]
# @notes Collects comprehensive repository context for AI evolution processing
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

# Load required modules
require_module "core/logger"
require_module "core/environment"
require_module "core/validation"
require_module "evolution/metrics"
require_module "analysis/health"

# Parse command line arguments
PROMPT=""
GROWTH_MODE="adaptive"
CONTEXT_FILE="/tmp/repo_context.json"
INCLUDE_HEALTH=false
INCLUDE_TESTS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --prompt)
            PROMPT="$2"
            shift 2
            ;;
        --growth-mode)
            GROWTH_MODE="$2"
            shift 2
            ;;
        --context-file)
            CONTEXT_FILE="$2"
            shift 2
            ;;
        --include-health)
            INCLUDE_HEALTH=true
            shift
            ;;
        --include-tests)
            INCLUDE_TESTS=true
            shift
            ;;
        *)
            # Handle positional arguments for backward compatibility
            if [[ -z "$PROMPT" ]]; then
                PROMPT="$1"
            elif [[ "$GROWTH_MODE" == "adaptive" ]]; then
                GROWTH_MODE="$1"
            elif [[ "$CONTEXT_FILE" == "/tmp/repo_context.json" ]]; then
                CONTEXT_FILE="$1"
            else
                log_error "Unknown argument: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate arguments using modular validation
validate_argument "growth_mode" "$GROWTH_MODE" "adaptive|conservative|aggressive|experimental"
validate_file_path "context_file" "$CONTEXT_FILE" "writable"

log_info "🧬 Analyzing repository genome and collecting comprehensive context..."
log_info "Growth Mode: $GROWTH_MODE | Context File: $CONTEXT_FILE"

# Initialize context collection with metadata and metrics using modular functions
log_info "📊 Loading current metrics and health data..."
METRICS_CONTENT=$(metrics_get_current)
HEALTH_DATA=$(health_analyze_repository "context" "comprehensive")

# Collect repository structure using tree command or fallback
log_info "🌳 Analyzing repository structure..."
if command -v tree >/dev/null 2>&1; then
    REPO_STRUCTURE=$(tree -J -L 3 -I ".git|node_modules|venv|dist|build|_site|.next" 2>/dev/null || echo "[]")
else
    log_warn "tree command not available, using find as fallback"
    REPO_STRUCTURE=$(find . -maxdepth 3 -type d -not -path "./.git*" -not -path "./node_modules*" | jq -R -s 'split("\n")[:-1] | map(select(length > 0))')
fi

# Create comprehensive base context
log_info "🔧 Building comprehensive context structure..."
jq -n \
  --argjson metrics "$METRICS_CONTENT" \
  --argjson health "$HEALTH_DATA" \
  --arg prompt "$PROMPT" \
  --arg growth_mode "$GROWTH_MODE" \
  --argjson repository_structure "$REPO_STRUCTURE" \
  --arg collection_timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg project_root "$PROJECT_ROOT" \
  '{
    "metadata": {
      "timestamp": $collection_timestamp,
      "user_prompt": $prompt,
      "growth_mode": $growth_mode,
      "project_root": $project_root,
      "collection_version": "2.0.0"
    },
    "metrics": $metrics,
    "health_analysis": $health,
    "repository_structure": $repository_structure,
    "files": {},
    "git_context": {},
    "environment": {}
  }' > "$CONTEXT_FILE"

# Collect git context information
log_info "📝 Collecting git context and history..."
GIT_CONTEXT=$(environment_collect_git_context)
jq --argjson git_context "$GIT_CONTEXT" '.git_context = $git_context' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Collect environment information
log_info "🖥️ Collecting environment information..."
ENV_CONTEXT=$(environment_collect_system_info)
jq --argjson env_context "$ENV_CONTEXT" '.environment = $env_context' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Determine file collection strategy based on growth mode and repository size
log_info "📁 Determining file collection strategy..."
case "$GROWTH_MODE" in
    "conservative")
        MAX_FILES=25
        MAX_LINES=500
        ;;
    "adaptive")
        MAX_FILES=50
        MAX_LINES=1000
        ;;
    "aggressive")
        MAX_FILES=100
        MAX_LINES=2000
        ;;
    "experimental")
        MAX_FILES=200
        MAX_LINES=5000
        ;;
    *)
        MAX_FILES=50
        MAX_LINES=1000
        ;;
esac

# Override with configuration if available
if [[ -f ".evolution.yml" ]]; then
    CONFIG_MAX_FILES=$(yq eval '.evolution.max_context_files // 0' .evolution.yml 2>/dev/null || echo 0)
    CONFIG_MAX_LINES=$(yq eval '.evolution.max_context_line_per_file // 0' .evolution.yml 2>/dev/null || echo 0)
    
    [[ $CONFIG_MAX_FILES -gt 0 ]] && MAX_FILES=$CONFIG_MAX_FILES
    [[ $CONFIG_MAX_LINES -gt 0 ]] && MAX_LINES=$CONFIG_MAX_LINES
fi

log_info "📂 File collection limits: $MAX_FILES files, $MAX_LINES lines each"

# Build ignore patterns (respecting .gptignore if present)
IGNORE_PATTERNS='\.git|\.DS_Store|node_modules|venv|env|dist|build|_site|\.next|\*.pyc|__pycache__|\*.log|\*.tmp|\*.swp|\*.lock'

if [[ -f .gptignore ]]; then
    log_info "📋 Found .gptignore file, applying custom ignore patterns"
    GPTIGNORE_PATTERNS=$(grep -v '^#' .gptignore | grep -v '^[[:space:]]*$' | sed 's|/$|/.*|' | paste -sd '|' || echo "")
    if [[ -n "$GPTIGNORE_PATTERNS" ]]; then
        IGNORE_PATTERNS="$IGNORE_PATTERNS|$GPTIGNORE_PATTERNS"
    fi
fi

# Collect file contents with progress tracking
log_info "📁 Adding file contents to context..."
FILES_ADDED=0
FILES_SKIPPED=0

while IFS= read -r file; do
    if [[ $FILES_ADDED -ge $MAX_FILES ]]; then
        log_info "Reached maximum file limit ($MAX_FILES), stopping collection"
        break
    fi
    
    # Skip empty files and very large files
    if [[ ! -s "$file" ]]; then
        ((FILES_SKIPPED++))
        continue
    fi
    
    FILE_SIZE=$(wc -l < "$file" 2>/dev/null || echo 0)
    if [[ $FILE_SIZE -gt $((MAX_LINES * 5)) ]]; then
        log_warn "Skipping very large file: $file ($FILE_SIZE lines)"
        ((FILES_SKIPPED++))
        continue
    fi
    
    # Process file content
    file_key=$(echo "$file" | sed 's|^\./||')
    file_content=$(head -n "$MAX_LINES" "$file" 2>/dev/null || echo "")
    
    if [[ -n "$file_content" ]]; then
        jq --arg path "$file_key" \
           --arg content "$file_content" \
           '.files[$path] = $content' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"
        ((FILES_ADDED++))
        
        if [[ $((FILES_ADDED % 10)) -eq 0 ]]; then
            log_info "Progress: $FILES_ADDED files processed..."
        fi
    else
        ((FILES_SKIPPED++))
    fi
done < <(find . -type f -name "*.md" -o -name "*.sh" -o -name "*.yml" -o -name "*.yaml" -o -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.txt" | grep -Ev "$IGNORE_PATTERNS" | sort)

# Finalize context with summary information
log_info "📊 Finalizing context with collection summary..."
CONTEXT_SUMMARY=$(jq -n \
    --arg files_added "$FILES_ADDED" \
    --arg files_skipped "$FILES_SKIPPED" \
    --arg growth_mode "$GROWTH_MODE" \
    --arg max_files "$MAX_FILES" \
    --arg max_lines "$MAX_LINES" \
    '{
        "files_collected": ($files_added | tonumber),
        "files_skipped": ($files_skipped | tonumber),
        "growth_mode": $growth_mode,
        "collection_limits": {
            "max_files": ($max_files | tonumber),
            "max_lines_per_file": ($max_lines | tonumber)
        }
    }')

jq --argjson summary "$CONTEXT_SUMMARY" '.metadata.collection_summary = $summary' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Display comprehensive results
log_header "🧬 Context Collection Complete"
log_success "Context successfully collected in: $CONTEXT_FILE"

TOTAL_FILES=$(jq '.files | length' "$CONTEXT_FILE")
TOTAL_METRICS=$(jq '.metrics | length' "$CONTEXT_FILE")
HEALTH_SCORE=$(jq '.health_analysis.health_score // "N/A"' "$CONTEXT_FILE")

log_info "📊 Collection Summary:"
log_info "  • Files collected: $FILES_ADDED"
log_info "  • Files skipped: $FILES_SKIPPED"
log_info "  • Total files in context: $TOTAL_FILES"
log_info "  • Metrics included: $TOTAL_METRICS"
log_info "  • Health score: $HEALTH_SCORE"
log_info "  • Growth mode: $GROWTH_MODE"
log_info "  • Collection limits: $MAX_FILES files, $MAX_LINES lines each"

if [[ -n "$PROMPT" ]]; then
    log_info "  • User prompt: $PROMPT"
fi

log_success "Context collection completed successfully!"
