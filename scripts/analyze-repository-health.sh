#!/bin/bash

#
# @file scripts/analyze-repository-health.sh
# @description Analyzes repository health and suggests improvements using modular analysis
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-09
# @version 2.1.0
#
# @relatedIssues 
#   - #modular-refactor: Migrate to modular architecture
#   - #health-analysis: Comprehensive repository health analysis
#   - #bash-compatibility: Add fallback for bash 3.2 compatibility
#
# @relatedEvolutions
#   - v2.1.0: Added fallback to simple version for bash 3.2 compatibility
#   - v2.0.0: Migrated to modular architecture with enhanced analysis
#   - v1.0.0: Original implementation with basic health checks
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system (bash 4+)
#   - ../scripts/analyze-repository-health-simple.sh: Fallback for bash 3.2
#
# @changelog
#   - 2025-07-09: Added bash 3.2 compatibility fallback - ITJ
#   - 2025-07-05: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced health analysis capabilities - ITJ
#
# @usage ./scripts/analyze-repository-health.sh [evolution_type] [intensity] [force_run]
# @notes Provides comprehensive repository health analysis with compatibility fallback
#

set -euo pipefail

# Check bash version and decide on implementation
BASH_VERSION_MAJOR=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | cut -d. -f1)

if [[ "${BASH_VERSION_MAJOR:-3}" -lt 4 ]]; then
    echo "Bash version $BASH_VERSION_MAJOR detected - using compatibility mode" >&2
    
    # Get script directory and fall back to simple version
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SIMPLE_SCRIPT="$SCRIPT_DIR/analyze-repository-health-simple.sh"
    
    if [[ -f "$SIMPLE_SCRIPT" ]]; then
        echo "Falling back to simple health analysis script..." >&2
        exec "$SIMPLE_SCRIPT" "$@"
    else
        echo "❌ Simple health analysis script not found: $SIMPLE_SCRIPT" >&2
        echo "❌ Cannot run health analysis with bash $BASH_VERSION_MAJOR" >&2
        exit 1
    fi
fi

# Continue with modern implementation for bash 4+
echo "Bash version $BASH_VERSION_MAJOR detected - using modern features" >&2

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

# Parse and validate arguments
EVOLUTION_TYPE="${1:-consistency}"
INTENSITY="${2:-minimal}"
FORCE_RUN="${3:-false}"

# Validate arguments using modular validation
validate_argument "evolution_type" "$EVOLUTION_TYPE" "consistency|maintenance|enhancement|security"
validate_argument "intensity" "$INTENSITY" "minimal|moderate|comprehensive"
validate_boolean "force_run" "$FORCE_RUN"

log_info "🔍 Analyzing repository health and detecting improvement opportunities..."
log_info "Evolution Type: $EVOLUTION_TYPE | Intensity: $INTENSITY | Force Run: $FORCE_RUN"

# Initialize health analysis
if ! health_initialize; then
    log_error "Failed to initialize health analysis module"
    exit 1
fi

# Perform comprehensive repository health analysis
log_info "Running comprehensive health analysis..."
HEALTH_REPORT=$(health_analyze_repository "$EVOLUTION_TYPE" "$INTENSITY")

if [[ -z "$HEALTH_REPORT" ]]; then
    log_error "Health analysis failed to generate report"
    exit 1
fi

# Extract key metrics from health report
HEALTH_SCORE=$(echo "$HEALTH_REPORT" | jq -r '.health_score // 0')
ISSUES_FOUND=$(echo "$HEALTH_REPORT" | jq -r '.issues_found // 0')
SUGGESTIONS=$(echo "$HEALTH_REPORT" | jq -r '.suggestions[]? // empty')

log_info "Health Analysis Results:"
log_info "  Health Score: $HEALTH_SCORE/100"
log_info "  Issues Found: $ISSUES_FOUND"

# Display suggestions if any
if [[ -n "$SUGGESTIONS" ]]; then
    log_info "📋 Improvement Recommendations:"
    echo "$SUGGESTIONS" | while read -r suggestion; do
        log_info "  • $suggestion"
    done
else
    log_success "✅ No immediate issues detected!"
fi

# Check evolution metrics for staleness using modular metrics functions
log_info "📊 Checking evolution metrics and staleness..."
EVOLUTION_METRICS=$(metrics_get_current)

if [[ -n "$EVOLUTION_METRICS" ]]; then
    LAST_EVOLUTION=$(echo "$EVOLUTION_METRICS" | jq -r '.last_growth_spurt // "Never"')
    
    if [[ "$LAST_EVOLUTION" != "null" && "$LAST_EVOLUTION" != "Never" ]]; then
        DAYS_SINCE=$(metrics_calculate_days_since "$LAST_EVOLUTION")
        
        if [[ $DAYS_SINCE -gt 7 ]]; then
            log_warn "Repository hasn't evolved in $DAYS_SINCE days - recommending growth cycle"
            # Add to health report suggestions
            HEALTH_REPORT=$(echo "$HEALTH_REPORT" | jq --arg suggestion "Repository hasn't evolved in $DAYS_SINCE days - time for growth" '.suggestions += [$suggestion]')
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    fi
fi

# Determine evolution recommendation
log_info "🤔 Determining evolution recommendation..."
SHOULD_EVOLVE=$(health_should_evolve "$HEALTH_SCORE" "$ISSUES_FOUND" "$FORCE_RUN")

# Generate comprehensive recommendations
log_info "💡 Generating actionable recommendations..."
RECOMMENDATIONS=$(health_generate_recommendations "$EVOLUTION_TYPE" "$INTENSITY" "$HEALTH_REPORT")

# Save results in standardized format
RESULTS_FILE="/tmp/health_check_results.json"
jq -n \
    --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg evolution_type "$EVOLUTION_TYPE" \
    --arg intensity "$INTENSITY" \
    --argjson health_score "$HEALTH_SCORE" \
    --argjson issues_found "$ISSUES_FOUND" \
    --arg should_evolve "$SHOULD_EVOLVE" \
    --argjson recommendations "$RECOMMENDATIONS" \
    --argjson full_report "$HEALTH_REPORT" \
    '{
        "timestamp": $timestamp,
        "evolution_type": $evolution_type,
        "intensity": $intensity,
        "health_score": $health_score,
        "issues_found": $issues_found,
        "should_evolve": ($should_evolve == "true"),
        "recommendations": $recommendations,
        "full_report": $full_report
    }' > "$RESULTS_FILE"

# Also save legacy format for backward compatibility
cat > /tmp/health_check_results.env << EOF
ISSUES_FOUND=$ISSUES_FOUND
SHOULD_EVOLVE=$SHOULD_EVOLVE
HEALTH_SCORE=$HEALTH_SCORE
EVOLUTION_TYPE=$EVOLUTION_TYPE
INTENSITY=$INTENSITY
EOF

# Save recommendations to text file for easy reading
echo "$RECOMMENDATIONS" | jq -r '.[] // empty' > /tmp/health_check_suggestions.txt

# Display final results
log_header "🏥 Repository Health Analysis Complete"
log_info "Health Score: $HEALTH_SCORE/100"
log_info "Issues Found: $ISSUES_FOUND"
log_info "Evolution Recommended: $SHOULD_EVOLVE"
log_info "Analysis Type: $EVOLUTION_TYPE ($INTENSITY intensity)"

if [[ "$SHOULD_EVOLVE" == "true" ]]; then
    log_info "📈 Evolution is recommended based on analysis"
    
    if [[ -n "$RECOMMENDATIONS" ]] && [[ "$RECOMMENDATIONS" != "[]" ]]; then
        log_info "� Key Recommendations:"
        echo "$RECOMMENDATIONS" | jq -r '.[]' | while read -r recommendation; do
            log_info "  • $recommendation"
        done
    fi
else
    log_success "✨ Repository is in excellent health - no immediate evolution needed"
fi

log_info "📄 Detailed results saved to: $RESULTS_FILE"
log_success "Health analysis completed successfully"
