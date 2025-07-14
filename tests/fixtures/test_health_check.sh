#!/bin/bash
set -euo pipefail

# Simulate health check logic from daily_evolution.yml
ISSUES_FOUND=0
SUGGESTIONS=()

# Check for inconsistent formatting (simulate finding issues)
echo "Checking formatting..."
if find . -name "*.md" -exec grep -l "	" {} \; 2>/dev/null | head -1 > /dev/null; then
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    SUGGESTIONS+=("Fix tab/space inconsistencies in Markdown files")
fi

# Check for TODO comments
echo "Checking TODO items..."
if grep -r "TODO\|FIXME\|XXX" --include="*.md" --include="*.sh" --include="*.yml" . 2>/dev/null | head -1 > /dev/null; then
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    SUGGESTIONS+=("Address pending TODO/FIXME items")
fi

# Check evolution metrics for staleness (simulate old metrics)
echo "Checking evolution metrics..."
if [ -f "evolution-metrics.json" ]; then
    LAST_EVOLUTION=$(jq -r '.last_growth_spurt // "Never"' evolution-metrics.json)
    if [ "$LAST_EVOLUTION" != "null" ] && [ "$LAST_EVOLUTION" != "Never" ]; then
        # Simulate old evolution (more than 7 days)
        DAYS_SINCE=8
        if [ $DAYS_SINCE -gt 7 ]; then
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
            SUGGESTIONS+=("Repository hasn't evolved in $DAYS_SINCE days - time for growth")
        fi
    fi
fi

# Output results
echo "Issues found: $ISSUES_FOUND"
echo "Suggestions: ${SUGGESTIONS[*]}"

# Decide if evolution should proceed
SHOULD_EVOLVE="false"
if [ $ISSUES_FOUND -gt 0 ]; then
    SHOULD_EVOLVE="true"
fi

echo "Should evolve: $SHOULD_EVOLVE"
exit 0
