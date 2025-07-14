<!--
@file scripts/periodic/README.md
@description Periodic evolution and maintenance scripts
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0, Periodic prompt system, AI prompt templates

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Scripts for executing and managing periodic AI evolution prompts
@notes Handles automated repository maintenance through scheduled AI prompts
-->

# Periodic Evolution Scripts

This directory contains scripts for executing and managing periodic AI evolution prompts that provide automated repository maintenance and improvement.

## Scripts Overview

| Script | Purpose | Usage |
|--------|---------|-------|
| `apply-periodic-changes.sh` | Applies changes from periodic prompts | `./apply-periodic-changes.sh [prompt-name]` |
| `execute-periodic-prompt.sh` | Executes periodic AI prompts | `./execute-periodic-prompt.sh --prompt-name [name]` |

## Key Features

- **Automated Execution**: Scheduled execution of periodic maintenance prompts
- **Change Application**: Safe application of AI-generated changes
- **Prompt Management**: Management of periodic prompt configurations
- **Safety Validation**: Comprehensive validation before applying changes

## Integration

These scripts work with the [Periodic Prompt Templates](../../prompts/templates/README.md) and integrate with [GitHub Workflows](../../.github/workflows/README.md) for automated execution.

## Usage Examples

```bash
# Execute documentation harmonization prompt
./execute-periodic-prompt.sh --prompt-name doc_harmonization --dry-run true

# Apply security scan changes
./apply-periodic-changes.sh security_scan

# Execute with custom settings
./execute-periodic-prompt.sh --prompt-name code_refactor --execution-mode manual
```