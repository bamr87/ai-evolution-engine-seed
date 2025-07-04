#!/bin/bash
# scripts/generate-evolution-prompt.sh
# Generates targeted evolution prompt based on analysis

set -euo pipefail

EVOLUTION_TYPE="${1:-consistency}"
INTENSITY="${2:-minimal}"

echo "🧬 Generating targeted evolution prompt..."

# Load health check results
if [ -f "/tmp/health_check_results.env" ]; then
    source /tmp/health_check_results.env
else
    echo "❌ Error: Health check results not found"
    exit 1
fi

# Load suggestions
SUGGESTIONS=""
if [ -f "/tmp/health_check_suggestions.txt" ]; then
    SUGGESTIONS=$(cat /tmp/health_check_suggestions.txt)
fi

# Base prompts for different evolution types
case "$EVOLUTION_TYPE" in
  "consistency")
    BASE_PROMPT="Focus on improving code consistency, formatting, and maintaining uniform standards across the repository."
    ;;
  "error_fixing")
    BASE_PROMPT="Identify and resolve errors, fix broken functionality, and improve error handling mechanisms."
    ;;
  "documentation")
    BASE_PROMPT="Enhance documentation quality, update outdated content, and improve code comments and examples."
    ;;
  "code_quality")
    BASE_PROMPT="Improve code quality through refactoring, optimization, and implementing best practices."
    ;;
  "security_updates")
    BASE_PROMPT="Focus on security improvements, vulnerability fixes, and implementing security best practices."
    ;;
  *)
    BASE_PROMPT="Perform general maintenance and improvements to enhance overall repository quality."
    ;;
esac

# Intensity modifiers
case "$INTENSITY" in
  "minimal")
    INTENSITY_MODIFIER="Make small, conservative changes that pose minimal risk. Focus on low-impact improvements."
    ;;
  "moderate")
    INTENSITY_MODIFIER="Implement moderate changes that provide good value while maintaining stability."
    ;;
  "comprehensive")
    INTENSITY_MODIFIER="Perform thorough improvements and refactoring where beneficial, with careful attention to testing."
    ;;
  *)
    INTENSITY_MODIFIER="Apply balanced improvements appropriate for the current state of the repository."
    ;;
esac

# Construct the full prompt
EVOLUTION_PROMPT="Daily Evolution Cycle - $BASE_PROMPT

$INTENSITY_MODIFIER

Detected improvement opportunities:
$SUGGESTIONS

Guidelines for this evolution:
- Maintain backward compatibility
- Follow DFF (Design for Failure) principles
- Keep changes atomic and well-documented
- Update relevant documentation
- Preserve existing functionality
- Focus on incremental improvements

Priority areas:
1. Fix any inconsistencies in formatting or structure
2. Address TODO/FIXME items where appropriate
3. Update outdated documentation or examples
4. Improve error handling and resilience
5. Enhance code readability and maintainability"

# Output the prompt to a file for the workflow to use
echo "$EVOLUTION_PROMPT" > /tmp/evolution_prompt.txt

echo "✅ Evolution prompt generated successfully"
echo "📝 Prompt type: $EVOLUTION_TYPE (intensity: $INTENSITY)"
echo "🎯 Found $ISSUES_FOUND issues to address"
