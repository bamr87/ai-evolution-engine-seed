#!/bin/bash

#
# @file scripts/collect-context.sh
# @description Collects repository context and metrics for AI evolution using modular architecture
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-12
# @version 2.4.0
#
# @relatedIssues 
#   - #modular-refactor: Migrate to modular architecture
#   - #context-collection: Enhanced context collection capabilities
#   - #workflow-fix: Fix command line argument parsing for GitHub Actions
#   - #v0.4.6-compatibility: Enhanced GitHub Actions compatibility and fallback mechanisms
#
# @relatedEvolutions
#   - v2.4.0: Enhanced GitHub Actions compatibility with robust fallback mechanisms and improved error handling for v0.4.6
#   - v2.3.0: Enhanced error handling, timeout protection, and pipeline fixes for GitHub Actions compatibility
#   - v2.2.0: Major rewrite of file processing and .gptignore pattern handling for GitHub Actions compatibility
#   - v2.1.5: Added comprehensive error handling and safe file processing
#   - v2.1.4: Completely rewrote .gptignore pattern processing for better regex compatibility
#   - v2.1.3: Fixed grep pattern escaping for .gptignore processing
#   - v2.1.2: Simplified health analysis to avoid CI environment hanging
#   - v2.1.1: Fixed function call signatures for metrics and health analysis
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
#   - 2025-07-12: Enhanced GitHub Actions compatibility with robust fallback mechanisms and improved error handling for v0.4.6 - ITJ
#   - 2025-07-12: Enhanced error handling, timeout protection, and pipeline fixes for GitHub Actions compatibility - ITJ
#   - 2025-07-12: Major rewrite of file processing and .gptignore pattern handling for GitHub Actions compatibility - ITJ
#   - 2025-07-12: Added comprehensive error handling and safe file processing - ITJ
#   - 2025-07-12: Completely rewrote .gptignore pattern processing for better regex compatibility - ITJ
#   - 2025-07-12: Fixed grep pattern escaping for .gptignore processing - ITJ
#   - 2025-07-12: Simplified health analysis to avoid hanging in CI environment - ITJ
#   - 2025-07-12: Fixed function call signatures for metrics and health analysis - ITJ
#   - 2025-07-12: Fixed command line argument parsing to support --flags - ITJ
#   - 2025-07-05: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced context collection with health analysis - ITJ
#
# @usage ./scripts/collect-context.sh [--prompt "text"] [--growth-mode mode] [--context-file path] [--include-health] [--include-tests]
# @notes Collects comprehensive repository context for AI evolution processing
#

set -euo pipefail

# Set global timeout for CI environments
if [[ "${CI_ENVIRONMENT:-false}" == "true" ]]; then
    # Set alarm for 90 seconds in CI
    (
        sleep 90
        echo "⚠️ Context collection timed out after 90 seconds in CI"
        pkill -P $$ 2>/dev/null || true
        exit 124
    ) &
    TIMEOUT_PID=$!
    
    # Cleanup function for timeout
    cleanup_timeout() {
        kill $TIMEOUT_PID 2>/dev/null || true
    }
    trap cleanup_timeout EXIT
fi

# Custom error handler for better debugging
error_handler() {
    local line_no=$1
    local error_code=$2
    echo "❌ Error on line $line_no: Command exited with status $error_code" >&2
    echo "🔍 Context: Current working directory: $(pwd)" >&2
    echo "🔍 Context: Available files: $(find . -name "*.md" -o -name "*.sh" 2>/dev/null | head -3 | tr '\n' ' ')" >&2
    exit "$error_code"
}

# Set up error trapping
trap 'error_handler ${LINENO} $?' ERR

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Validate required tools are available
validate_tools() {
    local tools=("jq" "find" "grep" "head" "wc" "sort")
    local optional_tools=("timeout")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo "❌ Missing required tools: ${missing_tools[*]}"
        echo "Please install the missing tools and try again."
        exit 1
    fi
    
    # Check optional tools
    for tool in "${optional_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            echo "⚠️ Optional tool missing: $tool (will use alternatives)"
        fi
    done
}

# Validate tools before proceeding
validate_tools

# Bootstrap the modular system
if [[ -f "$PROJECT_ROOT/src/lib/core/bootstrap.sh" ]]; then
    source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
    bootstrap_library
    
    # Load required modules
    require_module "core/logger" 2>/dev/null || {
        echo "⚠️ Warning: Could not load logger module, using basic logging" >&2
        log_info() { echo "ℹ️ [INFO] $*"; }
        log_warn() { echo "⚠️ [WARN] $*"; }
        log_error() { echo "❌ [ERROR] $*"; }
        log_success() { echo "✅ [SUCCESS] $*"; }
    }
    require_module "core/environment" 2>/dev/null || echo "⚠️ Warning: Could not load environment module" >&2
    require_module "core/validation" 2>/dev/null || echo "⚠️ Warning: Could not load validation module" >&2
    require_module "evolution/metrics" 2>/dev/null || echo "⚠️ Warning: Could not load metrics module" >&2
    require_module "analysis/health" 2>/dev/null || echo "⚠️ Warning: Could not load health module" >&2
else
    echo "⚠️ Warning: Bootstrap system not found, using basic logging" >&2
    log_info() { echo "ℹ️ [INFO] $*"; }
    log_warn() { echo "⚠️ [WARN] $*"; }
    log_error() { echo "❌ [ERROR] $*"; }
    log_success() { echo "✅ [SUCCESS] $*"; }
fi

# Parse command line arguments
PROMPT=""
GROWTH_MODE="adaptive"
CONTEXT_FILE="/tmp/repo_context.json"
INCLUDE_HEALTH=false
INCLUDE_TESTS=false
CI_MODE=false

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
        --ci-mode)
            CI_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Validate arguments using modular validation
if command -v validate_argument >/dev/null 2>&1; then
    validate_argument "growth_mode" "$GROWTH_MODE" "adaptive|conservative|aggressive|experimental" 2>/dev/null || {
        log_warn "Validation function failed, using basic validation"
        case "$GROWTH_MODE" in
            adaptive|conservative|aggressive|experimental) ;;
            *) log_error "Invalid growth mode: $GROWTH_MODE"; exit 1 ;;
        esac
    }
else
    # Basic validation fallback
    case "$GROWTH_MODE" in
        adaptive|conservative|aggressive|experimental) ;;
        *) log_error "Invalid growth mode: $GROWTH_MODE"; exit 1 ;;
    esac
fi

# Validate context file is writable (create directory if needed)
CONTEXT_DIR="$(dirname "$CONTEXT_FILE")"
if [[ ! -d "$CONTEXT_DIR" ]]; then
    log_info "Creating context directory: $CONTEXT_DIR"
    mkdir -p "$CONTEXT_DIR"
fi

# Test if we can write to the context file
if ! touch "$CONTEXT_FILE" 2>/dev/null; then
    log_error "Cannot write to context file: $CONTEXT_FILE"
    exit 1
fi

log_info "🧬 Analyzing repository genome and collecting comprehensive context..."
log_info "Growth Mode: $GROWTH_MODE | Context File: $CONTEXT_FILE"

# Initialize context collection with metadata and metrics using modular functions
log_info "📊 Loading current metrics and health data..."

# Initialize metrics if not already done - with fallback
if command -v init_metrics >/dev/null 2>&1; then
    init_metrics "metrics/evolution-metrics.json" 2>/dev/null || log_warn "Could not initialize metrics system"
else
    log_warn "Metrics system not available, using basic collection"
fi

# Try to get metrics, but don't fail if it doesn't work
METRICS_CONTENT="{}"
if [[ -f "metrics/evolution-metrics.json" ]]; then
    if command -v generate_metrics_report >/dev/null 2>&1; then
        METRICS_CONTENT=$(generate_metrics_report "metrics/evolution-metrics.json" "json" 2>/dev/null || echo "{}")
    else
        # Basic metrics collection fallback
        METRICS_CONTENT=$(cat "metrics/evolution-metrics.json" 2>/dev/null | jq '.' 2>/dev/null || echo "{}")
    fi
fi

# Simplified health data for now - avoid complex analysis that might hang
HEALTH_DATA='{"status": "basic_check", "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'", "version": "fallback"}'

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
GIT_CONTEXT=$(cat <<EOF
{
  "branch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')",
  "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "status": "$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')",
  "remote": "$(git remote get-url origin 2>/dev/null || echo 'unknown')",
  "last_commit": {
    "message": "$(git log -1 --pretty=format:'%s' 2>/dev/null || echo 'unknown')",
    "author": "$(git log -1 --pretty=format:'%an' 2>/dev/null || echo 'unknown')",
    "date": "$(git log -1 --pretty=format:'%ci' 2>/dev/null || echo 'unknown')"
  }
}
EOF
)
jq --argjson git_context "$GIT_CONTEXT" '.git_context = $git_context' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Collect environment information
log_info "🖥️ Collecting environment information..."
ENV_CONTEXT=$(cat <<EOF
{
  "os": "$(uname -s 2>/dev/null || echo 'unknown')",
  "arch": "$(uname -m 2>/dev/null || echo 'unknown')",
  "shell": "${SHELL:-unknown}",
  "user": "${USER:-unknown}",
  "pwd": "$(pwd)",
  "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "ci_environment": "${CI_ENVIRONMENT:-false}"
}
EOF
)
jq --argjson env_context "$ENV_CONTEXT" '.environment = $env_context' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Determine file collection strategy based on growth mode and repository size
log_info "📁 Determining file collection strategy..."

# Apply CI mode optimizations
if [[ "$CI_MODE" == "true" ]]; then
    log_info "🤖 CI mode enabled - using optimized settings"
    MAX_FILES=20
    MAX_LINES=300
    INCLUDE_HEALTH=false  # Skip health analysis in CI
    SKIP_LARGE_FILES=true
else
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
    SKIP_LARGE_FILES=false
fi

# Override with configuration if available
if [[ -f "config/.evolution.yml" ]]; then
    CONFIG_MAX_FILES=$(yq eval '.evolution.max_context_files // 0' config/.evolution.yml 2>/dev/null || echo 0)
    CONFIG_MAX_LINES=$(yq eval '.evolution.max_context_line_per_file // 0' config/.evolution.yml 2>/dev/null || echo 0)
    
    [[ $CONFIG_MAX_FILES -gt 0 ]] && MAX_FILES=$CONFIG_MAX_FILES
    [[ $CONFIG_MAX_LINES -gt 0 ]] && MAX_LINES=$CONFIG_MAX_LINES
fi

log_info "📂 File collection limits: $MAX_FILES files, $MAX_LINES lines each"

# Build ignore patterns (respecting .gptignore if present)
IGNORE_PATTERNS='\.git|\.DS_Store|node_modules|venv|env|dist|build|_site|\.next|\.pyc|__pycache__|\.log|\.tmp|\.swp|\.lock'

# Process .gptignore with improved error handling
if [[ -f .gptignore ]]; then
    log_info "📋 Found .gptignore file, applying custom ignore patterns"
    
    # Read .gptignore line by line with robust pattern conversion
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Clean the line and escape special characters safely
        pattern=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        if [[ -n "$pattern" ]]; then
            # Simple and safe pattern conversion
            if [[ "$pattern" == *"/"* ]]; then
                # Directory pattern - escape dots and keep as-is
                escaped_pattern=$(echo "$pattern" | sed 's/\./\\./g')
            elif [[ "$pattern" == "*."* ]]; then
                # Extension pattern like *.ext -> \.ext$
                escaped_pattern=$(echo "$pattern" | sed 's/\*//' | sed 's/\./\\./g')"$"
            else
                # Filename pattern - escape dots
                escaped_pattern=$(echo "$pattern" | sed 's/\./\\./g')
            fi
            
            # Only add valid non-empty patterns
            if [[ -n "$escaped_pattern" ]]; then
                IGNORE_PATTERNS="$IGNORE_PATTERNS|$escaped_pattern"
            fi
        fi
    done < .gptignore
fi

# Collect file contents with improved error handling
log_info "📁 Adding file contents to context..."
FILES_ADDED=0
FILES_SKIPPED=0

# Create a temporary file list to avoid pipeline issues
TEMP_FILE_LIST="/tmp/evolution_files_$$"

# Use a more robust approach to find files
{
    find . -type f \( -name "*.md" -o -name "*.sh" -o -name "*.yml" -o -name "*.yaml" -o -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.txt" \) 2>/dev/null || true
} | {
    sort 2>/dev/null || cat
} > "$TEMP_FILE_LIST"

# Filter out ignored patterns if we have any
if [[ -s "$TEMP_FILE_LIST" ]]; then
    if command -v grep >/dev/null 2>&1 && [[ -n "$IGNORE_PATTERNS" ]]; then
        {
            grep -Ev "$IGNORE_PATTERNS" "$TEMP_FILE_LIST" 2>/dev/null || cat "$TEMP_FILE_LIST"
        } > "${TEMP_FILE_LIST}.filtered"
        mv "${TEMP_FILE_LIST}.filtered" "$TEMP_FILE_LIST"
    fi
fi

# Process files from the filtered list with timeout protection
file_count=0
while IFS= read -r file && [[ $file_count -lt 1000 ]]; do
    ((file_count++))
    
    # Skip if we've reached our limit
    if [[ $FILES_ADDED -ge $MAX_FILES ]]; then
        log_info "Reached maximum file limit ($MAX_FILES), stopping collection"
        break
    fi
    
    # Skip if file doesn't exist or is empty
    if [[ ! -f "$file" ]] || [[ ! -s "$file" ]]; then
        ((FILES_SKIPPED++))
        continue
    fi
    
    # Check file size
    FILE_SIZE=$(wc -l < "$file" 2>/dev/null || echo 0)
    if [[ $FILE_SIZE -gt $((MAX_LINES * 5)) ]]; then
        log_warn "Skipping very large file: $file ($FILE_SIZE lines)"
        ((FILES_SKIPPED++))
        continue
    fi
    
    # Process file content safely
    file_key=$(echo "$file" | sed 's|^\./||')
    file_content=""
    
    # Read file content with error handling
    if [[ -r "$file" ]]; then
        file_content=$(head -n "$MAX_LINES" "$file" 2>/dev/null | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' || echo "")
    fi
    
    # Add to context if we have content
    if [[ -n "$file_content" ]]; then
        # Use safer jq operation with proper JSON encoding
        temp_content_file="/tmp/file_content_$$"
        printf '%s' "$file_content" > "$temp_content_file"
        
        # Try to add to context with better error handling
        if command -v timeout >/dev/null 2>&1; then
            if timeout 10 jq --arg path "$file_key" \
               --rawfile content "$temp_content_file" \
               '.files[$path] = $content' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" 2>/dev/null; then
                mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"
                ((FILES_ADDED++))
                
                # Progress logging every 10 files
                if [[ $((FILES_ADDED % 10)) -eq 0 ]]; then
                    log_info "Progress: $FILES_ADDED files processed..."
                fi
            else
                log_warn "Failed to process file: $file_key (timeout or JSON error)"
                rm -f "${CONTEXT_FILE}.tmp" 2>/dev/null || true
                ((FILES_SKIPPED++))
            fi
        else
            # No timeout available, run without timeout
            if jq --arg path "$file_key" \
               --rawfile content "$temp_content_file" \
               '.files[$path] = $content' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" 2>/dev/null; then
                mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"
                ((FILES_ADDED++))
                
                # Progress logging every 10 files
                if [[ $((FILES_ADDED % 10)) -eq 0 ]]; then
                    log_info "Progress: $FILES_ADDED files processed..."
                fi
            else
                log_warn "Failed to process file: $file_key (JSON error)"
                rm -f "${CONTEXT_FILE}.tmp" 2>/dev/null || true
                ((FILES_SKIPPED++))
            fi
        fi
        
        # Clean up temp file
        rm -f "$temp_content_file" 2>/dev/null || true
    else
        ((FILES_SKIPPED++))
    fi
done < "$TEMP_FILE_LIST"

# Clean up temporary file
rm -f "$TEMP_FILE_LIST" 2>/dev/null || true

# Finalize context with summary information
log_info "📊 Finalizing context with collection summary..."

# Create summary with error handling
if ! CONTEXT_SUMMARY=$(jq -n \
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
    }' 2>/dev/null); then
    log_warn "Failed to create context summary, using basic summary"
    CONTEXT_SUMMARY='{"files_collected": '$FILES_ADDED', "files_skipped": '$FILES_SKIPPED', "growth_mode": "'$GROWTH_MODE'"}'
fi

# Try to add summary to context, but don't fail if it doesn't work
if ! jq --argjson summary "$CONTEXT_SUMMARY" '.metadata.collection_summary = $summary' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" 2>/dev/null; then
    log_warn "Failed to add summary to context file, but continuing"
    cp "$CONTEXT_FILE" "${CONTEXT_FILE}.tmp"
fi
mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

# Display comprehensive results
log_info "🧬 Context Collection Complete"
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
