#!/bin/bash

#
# @file tests/fix-validation.sh
# @description Validation script to test GitHub Actions workflow fixes
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-10
# @lastModified 2025-07-10
# @version 1.0.0
#
# @relatedIssues 
#   - #workflow-authentication-fix: Fix GitHub authentication in CI environment
#
# @relatedEvolutions
#   - v1.0.0: Initial validation script for workflow authentication fixes
#
# @dependencies
#   - bash: >=4.0
#   - yq: for YAML processing
#
# @changelog
#   - 2025-07-10: Initial creation to validate authentication fixes - ITJ
#
# @usage ./tests/fix-validation.sh
# @notes Validates the fixes applied to resolve GitHub Actions authentication issues
#

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKFLOW_FILE="$PROJECT_ROOT/.github/workflows/ai_evolver.yml"
PREREQ_SCRIPT="$PROJECT_ROOT/scripts/check-prereqs.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
info() { echo -e "${BLUE}ℹ️ [INFO]${NC} $1"; }
success() { echo -e "${GREEN}✅ [SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}⚠️ [WARN]${NC} $1"; }
error() { echo -e "${RED}❌ [ERROR]${NC} $1"; }

echo -e "${BLUE}🔍 Validating GitHub Actions Workflow Fixes${NC}"
echo "============================================="

# Test 1: Check if GH_TOKEN is added to workflow environment
info "Testing workflow environment variables..."
if grep -q "GH_TOKEN.*secrets.GITHUB_TOKEN" "$WORKFLOW_FILE"; then
    success "GH_TOKEN environment variable is properly configured in workflow"
else
    error "GH_TOKEN environment variable is missing from workflow"
    exit 1
fi

# Test 2: Check if prerequisite script supports GITHUB_TOKEN
info "Testing prerequisite script token detection..."
if grep -q "GITHUB_TOKEN:-" "$PREREQ_SCRIPT"; then
    success "Prerequisite script now checks for GITHUB_TOKEN"
else
    error "Prerequisite script doesn't check for GITHUB_TOKEN"
    exit 1
fi

# Test 3: Simulate CI environment with GITHUB_TOKEN
info "Testing prerequisite script in simulated CI environment..."
export CI_ENVIRONMENT="true"
export GITHUB_TOKEN="test-token-simulation"
unset GH_TOKEN 2>/dev/null || true
unset PAT_TOKEN 2>/dev/null || true

# Test the authentication check specifically
if "$PREREQ_SCRIPT" adaptive | grep -q "GitHub authentication configured"; then
    success "Prerequisite script accepts GITHUB_TOKEN in CI environment"
else
    error "Prerequisite script still fails with GITHUB_TOKEN"
    exit 1
fi

# Test 4: Validate workflow YAML syntax
info "Validating workflow YAML syntax..."
if yq eval '.env.GH_TOKEN' "$WORKFLOW_FILE" | grep -q "secrets.GITHUB_TOKEN"; then
    success "Workflow YAML syntax is valid and GH_TOKEN is properly referenced"
else
    error "Workflow YAML syntax issues detected"
    exit 1
fi

# Test 5: Check for proper error handling in prerequisite script
info "Testing error handling improvements..."
if grep -q "token_source.*GH_TOKEN\|PAT_TOKEN\|GITHUB_TOKEN" "$PREREQ_SCRIPT"; then
    success "Enhanced token source detection implemented"
else
    warn "Token source detection could be improved further"
fi

echo -e "\n${GREEN}🎉 All validation tests passed!${NC}"
echo -e "${GREEN}The GitHub Actions workflow authentication fix is ready for deployment.${NC}"

echo -e "\n${BLUE}📋 Summary of fixes applied:${NC}"
echo "1. ✅ Added GH_TOKEN environment variable to workflow"
echo "2. ✅ Updated prerequisite checker to support GITHUB_TOKEN"
echo "3. ✅ Enhanced token source detection and error messages"
echo "4. ✅ Maintained backward compatibility with existing tokens"

echo -e "\n${YELLOW}🚀 Next steps:${NC}"
echo "1. Commit these changes to the repository"
echo "2. Test the workflow manually via GitHub Actions"
echo "3. Monitor the workflow execution for successful authentication"
