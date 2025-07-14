<!--
@file scripts/test/README.md
@description Testing and validation scripts for development workflows
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0, Testing frameworks, Core library modules

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Testing scripts for AI prompts, workflows, and system validation
@notes Provides comprehensive testing capabilities for all system components
-->

# Testing Scripts

This directory contains testing scripts for validating AI prompts, workflows, system configurations, and integration testing for the AI Evolution Engine.

## Scripts Overview

| Script | Purpose | Usage |
|--------|---------|-------|
| `test-ai-prompts-config.sh` | Tests AI prompts configuration | `./test-ai-prompts-config.sh` |
| `test-context-collection.sh` | Tests context collection functionality | `./test-context-collection.sh` |
| `test-enhanced-workflows.sh` | Tests enhanced workflow configurations | `./test-enhanced-workflows.sh` |
| `test-fixes.sh` | Tests workflow fixes and improvements | `./test-fixes.sh` |
| `test-simple-fallbacks.sh` | Tests simple fallback mechanisms | `./test-simple-fallbacks.sh` |

## Key Features

- **AI Prompt Testing**: Validation of prompt configurations and responses
- **Workflow Testing**: GitHub Actions workflow validation and testing
- **Context Testing**: Repository context collection validation
- **Fallback Testing**: Emergency fallback mechanism validation
- **Integration Testing**: End-to-end system validation

## Integration

These scripts integrate with the main [Testing Framework](../../tests/README.md) and support [Core Evolution Scripts](../core/README.md) validation.

## Usage

```bash
# Test all components
for script in test-*.sh; do ./$script; done

# Test specific component
./test-ai-prompts-config.sh --verbose
```