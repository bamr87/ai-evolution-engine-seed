#!/bin/bash
# scripts/analyze-repository-health.sh
# Analyzes repository health and suggests improvements

set -euo pipefail

EVOLUTION_TYPE="${1:-consistency}"
INTENSITY="${2:-minimal}"
FORCE_RUN="${3:-false}"

echo "🔍 Analyzing repository health and detecting improvement opportunities..."

# Check for common issues
ISSUES_FOUND=0
SUGGESTIONS=()

# Check for inconsistent formatting
if find . -name "*.md" -exec grep -l "	" {} \; | head -1 > /dev/null; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  SUGGESTIONS+=("Fix tab/space inconsistencies in Markdown files")
fi

# Check for TODO comments
if grep -r "TODO\|FIXME\|XXX" --include="*.md" --include="*.sh" --include="*.yml" . | head -1 > /dev/null; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  SUGGESTIONS+=("Address pending TODO/FIXME items")
fi

# Check for outdated documentation
LAST_COMMIT=$(git log -1 --format="%ct")
README_MODIFIED=$(stat -c %Y README.md 2>/dev/null || stat -f %m README.md 2>/dev/null || echo 0)
if [ $((LAST_COMMIT - README_MODIFIED)) -gt 604800 ]; then # 7 days
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  SUGGESTIONS+=("Update documentation to reflect recent changes")
fi

# Check for broken links (basic check)
if grep -r "http" --include="*.md" . | grep -v "https://" | head -1 > /dev/null; then
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
  SUGGESTIONS+=("Update insecure HTTP links to HTTPS")
fi

# Check evolution metrics for staleness
if [ -f "evolution-metrics.json" ]; then
  LAST_EVOLUTION=$(jq -r '.last_growth_spurt' evolution-metrics.json 2>/dev/null || echo "Never")
  if [ "$LAST_EVOLUTION" != "null" ] && [ "$LAST_EVOLUTION" != "Never" ]; then
    # Check if the date parsing works on this system
    if date -d "$LAST_EVOLUTION" +%s >/dev/null 2>&1; then
      DAYS_SINCE=$(( ($(date +%s) - $(date -d "$LAST_EVOLUTION" +%s)) / 86400 ))
    elif date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_EVOLUTION" +%s >/dev/null 2>&1; then
      # macOS date format
      DAYS_SINCE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_EVOLUTION" +%s)) / 86400 ))
    else
      DAYS_SINCE=0
    fi
    
    if [ $DAYS_SINCE -gt 7 ]; then
      ISSUES_FOUND=$((ISSUES_FOUND + 1))
      SUGGESTIONS+=("Repository hasn't evolved in $DAYS_SINCE days - time for growth")
    fi
  fi
fi

# Decide if evolution should proceed
SHOULD_EVOLVE="false"
if [ "$FORCE_RUN" = "true" ] || [ $ISSUES_FOUND -gt 0 ]; then
  SHOULD_EVOLVE="true"
fi

# Output results in a format that can be sourced
cat > /tmp/health_check_results.env << EOF
ISSUES_FOUND=$ISSUES_FOUND
SHOULD_EVOLVE=$SHOULD_EVOLVE
SUGGESTIONS_COUNT=${#SUGGESTIONS[@]}
EOF

# Output suggestions to a separate file for easy reading
printf '%s\n' "${SUGGESTIONS[@]}" > /tmp/health_check_suggestions.txt

echo "🔍 Health Check Complete:"
echo "  - Issues Found: $ISSUES_FOUND"
echo "  - Should Evolve: $SHOULD_EVOLVE"
echo "  - Evolution Type: $EVOLUTION_TYPE"
echo "  - Intensity: $INTENSITY"

if [ ${#SUGGESTIONS[@]} -gt 0 ]; then
  echo "📋 Suggestions:"
  printf '  - %s\n' "${SUGGESTIONS[@]}"
fi
