#!/bin/bash

#
# @file scripts/analyze-repository-health-simple.sh
# @description Simple repository health analysis compatible with bash 3.2+
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-09
# @lastModified 2025-07-09
# @version 1.0.0
#
# @relatedIssues 
#   - #github-actions-failure: Fix compatibility issues with bash 3.2
#
# @relatedEvolutions
#   - v1.0.0: Initial simple implementation for compatibility
#
# @dependencies
#   - bash: >=3.2
#   - jq: for JSON processing
#
# @changelog
#   - 2025-07-09: Initial creation for bash 3.2 compatibility - ITJ
#
# @usage ./scripts/analyze-repository-health-simple.sh [evolution_type] [intensity] [force_run]
# @notes Simplified version that works with older bash versions
#

set -euo pipefail

# Simple logging functions
log_info() {
    echo "ℹ️ [INFO] $*" >&2
}

log_error() {
    echo "❌ [ERROR] $*" >&2
}

log_warn() {
    echo "⚠️ [WARN] $*" >&2
}

# Simple validation functions
validate_argument() {
    local arg_name="$1"
    local value="$2"
    local allowed_values="$3"
    
    if [[ -z "$value" ]]; then
        log_error "Missing required argument: $arg_name"
        return 1
    fi
    
    # Convert pipe-separated values to array for checking
    IFS='|' read -ra allowed_array <<< "$allowed_values"
    
    for allowed in "${allowed_array[@]}"; do
        if [[ "$value" == "$allowed" ]]; then
            return 0
        fi
    done
    
    log_error "Invalid value for $arg_name: '$value'. Allowed values: $allowed_values"
    return 1
}

validate_boolean() {
    local arg_name="$1"
    local value="$2"
    
    # Convert to lowercase using tr for bash 3.2 compatibility
    local value_lower
    value_lower=$(echo "$value" | tr '[:upper:]' '[:lower:]')
    
    case "$value_lower" in
        true|false|1|0|yes|no|y|n)
            return 0
            ;;
        *)
            log_error "Invalid boolean value for $arg_name: '$value'. Expected: true/false, 1/0, yes/no, y/n"
            return 1
            ;;
    esac
}

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Parse and validate arguments
EVOLUTION_TYPE="${1:-consistency}"
INTENSITY="${2:-minimal}"
FORCE_RUN="${3:-false}"

# Validate arguments
validate_argument "evolution_type" "$EVOLUTION_TYPE" "consistency|maintenance|enhancement|security"
validate_argument "intensity" "$INTENSITY" "minimal|moderate|comprehensive"
validate_boolean "force_run" "$FORCE_RUN"

log_info "🔍 Analyzing repository health and detecting improvement opportunities..."
log_info "Evolution Type: $EVOLUTION_TYPE | Intensity: $INTENSITY | Force Run: $FORCE_RUN"

# Simple health checks
ISSUES_FOUND=0
SHOULD_EVOLVE=false
SUGGESTIONS=""

# Check if essential files exist
log_info "Checking essential files..."
ESSENTIAL_FILES=("README.md" "LICENSE" "CHANGELOG.md" ".gitignore")

for file in "${ESSENTIAL_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
        log_warn "Missing essential file: $file"
        SUGGESTIONS="$SUGGESTIONS\n- Add missing file: $file"
        ((ISSUES_FOUND++))
    fi
done

# Check for executable scripts
log_info "Checking script permissions..."
if [[ -d "$PROJECT_ROOT/scripts" ]]; then
    while IFS= read -r -d '' script_file; do
        if [[ ! -x "$script_file" ]]; then
            log_warn "Script not executable: $(basename "$script_file")"
            SUGGESTIONS="$SUGGESTIONS\n- Make script executable: chmod +x $(basename "$script_file")"
            ((ISSUES_FOUND++))
        fi
    done < <(find "$PROJECT_ROOT/scripts" -name "*.sh" -print0 2>/dev/null || true)
fi

# Check git repository health
log_info "Checking git repository health..."
if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
    log_warn "Not a git repository"
    SUGGESTIONS="$SUGGESTIONS\n- Initialize git repository: git init"
    ((ISSUES_FOUND++))
else
    # Check for uncommitted changes
    if ! git -C "$PROJECT_ROOT" diff-index --quiet HEAD -- 2>/dev/null; then
        log_info "Uncommitted changes detected"
        if [[ "$FORCE_RUN" == "true" ]]; then
            SHOULD_EVOLVE=true
        fi
    fi
fi

# Check for configuration files
log_info "Checking configuration files..."
CONFIG_FILES=(".github/workflows" "docker-compose.yml" "Dockerfile")

for config in "${CONFIG_FILES[@]}"; do
    if [[ ! -e "$PROJECT_ROOT/$config" ]]; then
        log_info "Optional configuration missing: $config"
    fi
done

# Determine if evolution should proceed
if [[ $ISSUES_FOUND -gt 0 ]] || [[ "$FORCE_RUN" == "true" ]]; then
    SHOULD_EVOLVE=true
fi

# Create simple health report in JSON format
HEALTH_REPORT=$(cat <<EOF
{
  "health_score": $((100 - ISSUES_FOUND * 10)),
  "issues_found": $ISSUES_FOUND,
  "should_evolve": $SHOULD_EVOLVE,
  "evolution_type": "$EVOLUTION_TYPE",
  "intensity": "$INTENSITY",
  "suggestions": ["$(echo -e "$SUGGESTIONS" | sed 's/^- //' | tr '\n' '"' | sed 's/"$//; s/"/", "/g' | sed 's/, $//')"],
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
)

# Output results
log_info "Health Analysis Results:"
log_info "  Health Score: $((100 - ISSUES_FOUND * 10))/100"
log_info "  Issues Found: $ISSUES_FOUND"
log_info "  Should Evolve: $SHOULD_EVOLVE"

# Save results for GitHub Actions
echo "ISSUES_FOUND=$ISSUES_FOUND" > /tmp/health_check_results.env
echo "SHOULD_EVOLVE=$SHOULD_EVOLVE" >> /tmp/health_check_results.env

# Save suggestions for GitHub Actions
if [[ -n "$SUGGESTIONS" ]]; then
    echo -e "$SUGGESTIONS" > /tmp/health_check_suggestions.txt
else
    echo "No suggestions at this time." > /tmp/health_check_suggestions.txt
fi

log_info "✅ Repository health analysis complete"
exit 0
