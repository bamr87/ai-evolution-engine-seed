<!--
@file scripts/generation/README.md
@description Generation and creation scripts
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0, Generation utilities

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Scripts for generating AI responses, seeds, and evolution content
@notes Handles generation of various evolution artifacts and content
-->

# Generation Scripts

Scripts for generating AI responses, evolution seeds, and various evolution artifacts.

## Scripts Overview

| Script | Purpose |
|--------|---------|
| `generate_ai_response.sh` | Generates simulated AI response |
| `generate-evolution-prompt.sh` | Generates targeted evolution prompt |
| `generate_seed.sh` | Generates the next .seed.md content |
| `plant-new-seeds.sh` | Plants new seeds for next evolution |

## Features

- AI response generation and simulation
- Evolution prompt creation
- Seed generation and planting
- Content creation automation

## Usage

```bash
# Generate AI response
./generate_ai_response.sh --prompt "Improve documentation"

# Generate evolution prompt
./generate-evolution-prompt.sh --type security --target vulnerabilities
```