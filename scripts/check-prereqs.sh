#!/usr/bin/env bash
# check-prereqs.sh - Prerequisite checker for AI Evolution Engine
# Usage: bash scripts/check-prereqs.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MISSING=0

function check_bin() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo -e "${RED}✗ $1 not found${NC}"
    MISSING=1
  else
    echo -e "${GREEN}✓ $1 found${NC}"
  fi
}

echo -e "${YELLOW}Checking required tools...${NC}"
check_bin git
check_bin curl
check_bin bash

# Optional but recommended
echo -e "${YELLOW}Checking recommended tools...${NC}"
check_bin gh
check_bin docker

# Check required environment variables
REQUIRED_VARS=(AI_PROVIDER AI_API_KEY GITHUB_TOKEN)
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo -e "${RED}✗ Environment variable $VAR is not set${NC}"
    MISSING=1
  else
    echo -e "${GREEN}✓ $VAR is set${NC}"
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo -e "\n${RED}Some prerequisites are missing. Please install missing tools and set required environment variables before proceeding.${NC}"
  exit 1
else
  echo -e "\n${GREEN}All prerequisites satisfied!${NC}"
fi
