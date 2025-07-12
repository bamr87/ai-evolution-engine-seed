#!/bin/bash
#
# @file scripts/simple-context-collector.sh
# @description Simple, robust context collection script for CI environments
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @usage ./scripts/simple-context-collector.sh [output_file]
# @notes Minimal context collection without complex dependencies
#

set -e  # Exit on error, but not on pipeline failures

# Enable better error handling
trap 'log_error "Script failed at line $LINENO"' ERR

# Simple logging functions
log_info() { echo "ℹ️ [INFO] $*"; }
log_warn() { echo "⚠️ [WARN] $*"; }
log_error() { echo "❌ [ERROR] $*"; }
log_success() { echo "✅ [SUCCESS] $*"; }

# Set output file
OUTPUT_FILE="${1:-/tmp/repo_context.json}"

log_info "🔧 Simple context collection starting..."

# Create basic context structure
cat > "$OUTPUT_FILE" << 'EOF'
{
  "metadata": {
    "timestamp": "",
    "collection_version": "simple-1.0.0",
    "collection_summary": {
      "files_collected": 0,
      "status": "in_progress"
    }
  },
  "git_context": {},
  "environment": {},
  "files": {},
  "repository_structure": []
}
EOF

# Add timestamp
jq --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
   '.metadata.timestamp = $timestamp' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && \
   mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

# Collect git information
log_info "📝 Collecting git context..."
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo "0")

jq --arg branch "$GIT_BRANCH" \
   --arg commit "$GIT_COMMIT" \
   --argjson status "$GIT_STATUS" \
   '.git_context = {
     "branch": $branch,
     "commit": $commit,
     "modified_files": $status
   }' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" 2>/dev/null && \
   mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" || {
     log_warn "Failed to update git context, continuing..."
   }

# Collect environment
log_info "🖥️ Collecting environment..."
jq --arg os "$(uname -s 2>/dev/null || echo 'unknown')" \
   --arg pwd "$(pwd)" \
   --arg ci "${CI_ENVIRONMENT:-false}" \
   '.environment = {
     "os": $os,
     "pwd": $pwd,
     "ci_environment": $ci
   }' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" 2>/dev/null && \
   mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" || {
     log_warn "Failed to update environment, continuing..."
   }

# Collect key files (limit to essential ones)
log_info "📁 Collecting key files..."
FILES_COLLECTED=0

# Essential files to collect
KEY_FILES=(
  "README.md"
  "CHANGELOG.md"
  ".evolution.yml"
  "init_setup.sh"
  "Makefile"
)

for file in "${KEY_FILES[@]}"; do
  if [[ -f "$file" && -r "$file" ]]; then
    log_info "Adding file: $file"
    
    # Read file content safely
    if file_content=$(head -n 100 "$file" 2>/dev/null); then
      # Add to JSON
      jq --arg path "$file" \
         --arg content "$file_content" \
         '.files[$path] = $content' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" 2>/dev/null && \
         mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" && \
         ((FILES_COLLECTED++)) || {
           log_warn "Failed to add file $file, skipping..."
         }
    else
      log_warn "Could not read file $file, skipping..."
    fi
  fi
done

# Add a few more important files if they exist
ADDITIONAL_FILES=(
  "scripts/README.md"
  "src/lib/core/bootstrap.sh"
  ".github/workflows/ai_evolver.yml"
)

for file in "${ADDITIONAL_FILES[@]}"; do
  if [[ -f "$file" && -r "$file" && $FILES_COLLECTED -lt 10 ]]; then
    log_info "Adding additional file: $file"
    
    # Read file content safely (smaller chunks for these)
    if file_content=$(head -n 50 "$file" 2>/dev/null); then
      # Add to JSON
      jq --arg path "$file" \
         --arg content "$file_content" \
         '.files[$path] = $content' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" 2>/dev/null && \
         mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" && \
         ((FILES_COLLECTED++)) || {
           log_warn "Failed to add additional file $file, skipping..."
         }
    else
      log_warn "Could not read additional file $file, skipping..."
    fi
  fi
done

# Update summary
jq --arg files_collected "$FILES_COLLECTED" \
   '.metadata.collection_summary.files_collected = ($files_collected | tonumber) |
    .metadata.collection_summary.status = "completed"' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" 2>/dev/null && \
   mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE" || {
     log_warn "Failed to update summary, but continuing..."
   }

log_success "Context collection completed successfully"
log_info "Files collected: $FILES_COLLECTED"
log_info "Output file: $OUTPUT_FILE"

# Validate output
if jq empty "$OUTPUT_FILE" 2>/dev/null; then
  log_success "Output JSON is valid"
else
  log_error "Output JSON is invalid!"
  exit 1
fi
