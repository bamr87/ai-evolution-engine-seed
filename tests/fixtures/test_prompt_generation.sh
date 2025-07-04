#!/bin/bash

# Test Prompt Generation Script
# Simulates the prompt generation logic from daily evolution workflow

set -euo pipefail

# Get inputs from environment or defaults
EVOLUTION_TYPE="${EVOLUTION_TYPE:-consistency}"
INTENSITY="${INTENSITY:-minimal}"

# Generate base prompt based on evolution type
case "$EVOLUTION_TYPE" in
    "consistency")
        BASE_PROMPT="Perform consistency improvements and minor fixes"
        ;;
    "error_fixing")
        BASE_PROMPT="Fix minor errors and improve robustness"
        ;;
    "documentation")
        BASE_PROMPT="Update and improve documentation quality"
        ;;
    "code_quality")
        BASE_PROMPT="Enhance code quality and maintainability"
        ;;
    "security_updates")
        BASE_PROMPT="Apply security updates and hardening"
        ;;
    *)
        BASE_PROMPT="Perform general improvements"
        ;;
esac

# Add intensity modifier
case "$INTENSITY" in
    "minimal")
        INTENSITY_MODIFIER="Focus on safe, minimal changes that improve consistency without altering functionality."
        ;;
    "moderate")
        INTENSITY_MODIFIER="Balance improvements with stability, making thoughtful enhancements."
        ;;
    "comprehensive")
        INTENSITY_MODIFIER="Perform comprehensive improvements including significant enhancements."
        ;;
    *)
        INTENSITY_MODIFIER="Use balanced approach to improvements."
        ;;
esac

# Create the evolution prompt
EVOLUTION_PROMPT="$BASE_PROMPT. $INTENSITY_MODIFIER Evolution type: $EVOLUTION_TYPE, Intensity: $INTENSITY"

# Output the prompt (simulating what the workflow would generate)
echo "$EVOLUTION_PROMPT"

# Create a mock prompt file for testing
echo "$EVOLUTION_PROMPT" > /tmp/test_evolution_prompt.txt

exit 0
