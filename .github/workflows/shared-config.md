# AI Evolution Workflows - Shared Configuration Documentation
#
# This file documents common patterns, configurations, and standards
# used across all AI Evolution workflows for consistency.
#
# Version: 0.3.0

# COMMON ENVIRONMENT VARIABLES
# These should be used consistently across all workflows:
# - EVOLUTION_VERSION: "0.3.0"
# - WORKFLOW_TYPE: Descriptive name (e.g., "manual_evolution", "scheduled_evolution", "testing_automation")

# COMMON PERMISSIONS
# All workflows should use these permissions:
# permissions:
#   contents: write
#   pull-requests: write
#   issues: write

# STANDARD CHECKOUT CONFIGURATION
# Use this checkout configuration for consistency:
# - name: 🌱 Prepare Evolution Environment
#   uses: actions/checkout@v4
#   with:
#     fetch-depth: 0
#     token: ${{ secrets.PAT_TOKEN }}

# COMMON INPUT PARAMETERS
# Growth Modes:
# - conservative: Safe, minimal changes
# - adaptive: Balanced approach with moderate changes
# - experimental: Advanced features and experimental changes
# - test-automation: Focus on testing improvements
# - build-optimization: Focus on build and CI/CD improvements
# - error-resilience: Focus on error handling and recovery
# - ci-cd-enhancement: Focus on CI/CD pipeline improvements

# Evolution Types (for daily evolution):
# - consistency: Fix inconsistencies across files
# - error_fixing: Resolve errors and issues
# - documentation: Improve documentation
# - code_quality: Enhance code quality
# - security_updates: Apply security improvements

# Intensity Levels:
# - minimal: Small, safe changes
# - moderate: Medium-sized improvements
# - comprehensive: Large-scale improvements

# STANDARD ENVIRONMENT SETUP PATTERN
# All workflows should follow this pattern:
# - name: 🛠️ Setup Environment
#   run: |
#     if [ ! -f "./scripts/setup-environment.sh" ]; then
#       echo "❌ Setup script not found!"
#       exit 1
#     fi
#     chmod +x ./scripts/setup-environment.sh
#     ./scripts/setup-environment.sh

# SCRIPT EXECUTION PATTERN
# Always make scripts executable and use error handling:
# - name: Script Name
#   run: |
#     chmod +x ./scripts/script-name.sh
#     ./scripts/script-name.sh arg1 arg2

# DRY RUN PATTERN
# Include dry run support in all workflows:
# - name: 🔍 Dry Run - Preview Changes
#   if: env.DRY_RUN == 'true'
#   run: |
#     echo "🔍 DRY RUN MODE - Changes that would be applied:"
#     # Preview logic here

# ERROR HANDLING
# Use set -euo pipefail for robust error handling in multi-line scripts

# NAMING CONVENTIONS
# - Use emojis for step names to improve readability
# - Use descriptive job names
# - Use consistent variable naming (UPPER_CASE for environment variables)

# FILE PATHS
# - Use consistent temp directory: /tmp/
# - Use relative paths for scripts: ./scripts/
# - Store outputs in /tmp/ for consistency
