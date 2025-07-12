# GitHub Models Migration Summary

## Overview

This document summarizes the migration of all prompt files in the repository to follow the [GitHub Models standard format](https://docs.github.com/en/github-models/use-github-models/storing-prompts-in-github-repositories).

## Changes Made

### File Naming Convention

- **Before**: Files used `.yml` extension (e.g., `code_refactor.yml`)
- **After**: Files now use `.prompt.yml` extension (e.g., `code_refactor.prompt.yml`)

### File Structure Changes

- **Removed**: Custom header comments with metadata (author, created date, version, etc.)
- **Kept**: Core GitHub Models structure with required fields

### Required GitHub Models Format

All prompt files now follow this structure:

```yaml
name: [Prompt Name]
description: [Brief description of what the prompt does]
model: [AI model to use, e.g., gpt-4o-mini]
modelParameters:
  temperature: [0.0-1.0]
  max_tokens: [optional]
messages:
  - role: system
    content: [System message]
  - role: user
    content: [User prompt with {{variable}} placeholders]
testData:
  - input: [Test input]
    expected: [Expected output]
evaluators:
  - name: [Evaluator description]
    [evaluation criteria]
```

## Files Migrated

### Main Prompts

- `prompts/first_growth.yml` → `prompts/first_growth.prompt.yml`
- `prompts/next_evolution.yml` → `prompts/next_evolution.prompt.yml`

### Template Prompts

- `prompts/templates/code_refactor.yml` → `prompts/templates/code_refactor.prompt.yml`
- `prompts/templates/doc_harmonization.yml` → `prompts/templates/doc_harmonization.prompt.yml`
- `prompts/templates/performance_optimization.yml` → `prompts/templates/performance_optimization.prompt.yml`
- `prompts/templates/security_scan.yml` → `prompts/templates/security_scan.prompt.yml`
- `prompts/templates/test_enhancement.yml` → `prompts/templates/test_enhancement.prompt.yml`
- `prompts/templates/text_summarizer.yml` → `prompts/templates/text_summarizer.prompt.yml`

## Benefits of GitHub Models Format

1. **Easy Integration**: Direct integration with GitHub's AI development tools
2. **Scalability**: Simple to complex use cases supported
3. **Compatibility**: Uses widely supported YAML format
4. **Organization**: Clean UI for viewing prompts in repositories
5. **Sharing**: Easier sharing with non-technical stakeholders
6. **Testing**: Built-in test data and evaluation framework

## Key Features Preserved

- All original prompt logic and content
- Variable placeholders using `{{variable}}` syntax
- Test data for validation
- Evaluation criteria for quality assurance
- Model parameters for fine-tuning

## Migration Date

July 12, 2025

## Next Steps

1. Update any scripts or workflows that reference the old file names
2. Test the prompts using GitHub Models tools
3. Consider adding more comprehensive test data and evaluators
4. Update documentation to reference the new file locations

## Notes

- Old `.yml` files have been removed to avoid confusion
- All prompts maintain their original functionality
- The migration is backward compatible with existing YAML parsers
- Custom metadata from headers has been removed as it's not part of the GitHub Models standard
