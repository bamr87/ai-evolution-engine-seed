#!/bin/bash
#
# @file post-ai-validation.sh
# @description Post-AI prompt cycle validation runner
# @author AI Evolution Engine <ai@evolution-engine.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - AI prompt cycle validation automation
#   - Documentation organization enforcement
#
# @relatedEvolutions
#   - v1.0.0: Initial post-AI validation workflow
#
# @dependencies
#   - bash: >=4.0
#   - validate-docs-organization.sh: documentation validation script
#
# @changelog
#   - 2025-07-12: Initial creation - AEE
#
# @usage ./scripts/post-ai-validation.sh
# @notes Automatically run after AI prompt cycles to ensure compliance
#

set -euo pipefail

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}🤖 Post-AI Prompt Cycle Validation${NC}"
echo "====================================="

# Run documentation organization validation
echo -e "\n${BLUE}Running documentation organization validation...${NC}"
if ./scripts/validate-docs-organization.sh; then
    echo -e "${GREEN}✅ All validation checks passed!${NC}"
    exit 0
else
    echo -e "\n${BLUE}⚠️  Validation issues found. Please address them before continuing.${NC}"
    echo "This script should be run after every AI prompt cycle to ensure compliance."
    exit 1
fi
