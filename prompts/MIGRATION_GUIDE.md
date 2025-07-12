<!--
@file prompts/MIGRATION_GUIDE.md
@description Guide for migrating from Markdown to YAML prompt format
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #prompt-standardization: Standardize prompt format across repository

@relatedEvolutions
  - v1.0.0: Initial creation of migration guide

@dependencies
  - YAML parser for prompt processing

@changelog
  - 2025-07-12: Initial creation of migration guide - ITJ

@usage Guide for converting existing prompts to new YAML format
@notes Provides step-by-step migration instructions and best practices
-->

# YAML Prompt Format Migration Guide

This guide helps you migrate existing Markdown-based prompts to the new standardized YAML format.

## Why Migrate?

The new YAML format provides:

- **Structured Configuration**: Clear separation of metadata, model parameters, and content
- **Embedded Testing**: Built-in test data and evaluators for prompt validation
- **Model Parameters**: Explicit temperature, token limits, and model specifications
- **Evaluators**: Automated validation of prompt outputs for quality assurance
- **Consistency**: Standardized format across all prompts
- **Maintainability**: Easier to update and version control

## Migration Process

### Step 1: Analyze Existing Prompt

Before migrating, identify the key components of your existing Markdown prompt:

1. **Core Instructions**: The main prompt content
2. **Context/System Message**: Background information for the AI
3. **Variables**: Dynamic content that needs substitution
4. **Expected Outputs**: What format the response should take

### Step 2: Create YAML Structure

Use this template as a starting point:

```yaml
#
# @file prompts/your_prompt.yml
# @description Brief description of the prompt's purpose
# @author Your Name <your.email@domain.com>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - #issue-number: Description of related issue
#
# @relatedEvolutions
#   - v1.0.0: Initial creation with standardized YAML format
#
# @dependencies
#   - YAML parser for prompt processing
#   - model-name: for execution
#
# @changelog
#   - 2025-07-12: Initial creation - Author
#
# @usage Description of how this prompt is used
# @notes Additional notes about the prompt
#

name: Descriptive Prompt Name
description: Brief description of what this prompt does
model: gpt-4o-mini
modelParameters:
  temperature: 0.3
  max_tokens: 4000
messages:
  - role: system
    content: |
      System message that provides context and instructions for the AI.
      This should include the AI's role and key principles to follow.
  - role: user
    content: |
      The actual prompt content with variable placeholders.
      Use {{variable_name}} for dynamic content.
      
      Example: Analyze the following files: {{source_files}}
testData:
  - input: |
      variable_name: "example input value"
    expected: |
      Expected output format or content
evaluators:
  - name: Description of what this evaluator checks
    json:
      validJson: true
  - name: Check for specific content
    string:
      contains: "expected phrase"
```

### Step 3: Convert Content

#### System Message Conversion

Extract background information, context, and role definitions from your Markdown prompt:

**Before (Markdown):**
```markdown
You are an expert software engineer. Your task is to analyze code quality.
Follow these principles:
- Maintain backward compatibility
- Focus on readability
- Follow best practices
```

**After (YAML):**
```yaml
messages:
  - role: system
    content: |
      You are an expert software engineer specializing in code quality analysis. Your task is to analyze source code and provide improvement recommendations.
      
      Follow these principles:
      - Maintain backward compatibility
      - Focus on readability
      - Follow best practices
```

#### User Prompt Conversion

Convert the main prompt content, replacing dynamic elements with variables:

**Before (Markdown):**
```markdown
Analyze the following source files and provide recommendations:
- File 1: src/app.py
- File 2: src/utils.py

Focus on code quality and maintainability.
```

**After (YAML):**
```yaml
  - role: user
    content: |
      Analyze the following source files and provide recommendations:
      {{source_files}}
      
      Focus on code quality and maintainability.
```

### Step 4: Add Test Data

Create realistic test scenarios:

```yaml
testData:
  - input: |
      source_files: "src/app.py, src/utils.py, src/models.py"
    expected: |
      {
        "analysis": {
          "files_analyzed": 3,
          "issues_found": 5,
          "recommendations": [...]
        }
      }
```

### Step 5: Define Evaluators

Add validation rules to ensure prompt quality:

```yaml
evaluators:
  - name: Output should be valid JSON
    json:
      validJson: true
  - name: Should include analysis section
    json:
      hasKey: "analysis"
  - name: Should count files
    json:
      path: "analysis.files_analyzed"
      type: "number"
```

## Best Practices

### Variable Naming

Use clear, descriptive variable names:

- `{{source_files}}` instead of `{{files}}`
- `{{repository_state}}` instead of `{{state}}`
- `{{growth_objectives}}` instead of `{{goals}}`

### Model Parameters

Choose appropriate parameters for your use case:

- **Temperature**: 0.1-0.3 for consistent, focused outputs; 0.4-0.7 for creative tasks
- **Max Tokens**: Set based on expected output length (1000-4000 typically sufficient)

### Evaluator Types

Use appropriate evaluators for your output format:

#### JSON Validation
```yaml
evaluators:
  - name: Valid JSON output
    json:
      validJson: true
  - name: Has required field
    json:
      hasKey: "field_name"
  - name: Field is number
    json:
      path: "nested.field"
      type: "number"
```

#### String Validation
```yaml
evaluators:
  - name: Starts with expected text
    string:
      startsWith: "Summary -"
  - name: Contains required phrase
    string:
      contains: "analysis complete"
  - name: Matches pattern
    string:
      pattern: "\\d+ files processed"
```

### Content Organization

Structure your content logically:

1. **System Message**: Role definition and principles
2. **User Prompt**: Main instructions and context
3. **Test Data**: Realistic input scenarios
4. **Evaluators**: Quality validation rules

## Migration Checklist

- [ ] Header metadata completed with proper @file annotations
- [ ] Name and description clearly define the prompt's purpose
- [ ] Model and parameters are appropriate for the task
- [ ] System message provides clear role and context
- [ ] User prompt uses variables for dynamic content
- [ ] Test data covers realistic scenarios
- [ ] Evaluators validate key output requirements
- [ ] YAML syntax is valid and properly formatted
- [ ] Variables are consistently named and documented

## Common Pitfalls

1. **Variable Substitution**: Ensure all dynamic content uses `{{variable}}` syntax
2. **YAML Syntax**: Watch for proper indentation and escaping
3. **Test Coverage**: Include edge cases and error scenarios in test data
4. **Evaluator Scope**: Don't over-constrain outputs with too many evaluators
5. **Content Length**: Balance detail with conciseness in prompts

## Example Migration

### Before (Markdown)
```markdown
# Security Scan Prompt

You are a security expert. Analyze the repository for vulnerabilities.

Look at these files:
- src/*.py
- .github/workflows/*.yml

Provide a security report with findings and recommendations.
```

### After (YAML)
```yaml
name: Security Vulnerability Scanner
description: Analyzes repository files for security vulnerabilities and provides remediation recommendations
model: gpt-4o-mini
modelParameters:
  temperature: 0.2
  max_tokens: 4000
messages:
  - role: system
    content: |
      You are a cybersecurity expert specializing in application security and DevOps security practices. Your task is to analyze repository files for security vulnerabilities and provide actionable remediation recommendations.
  - role: user
    content: |
      Analyze the following repository files for security vulnerabilities:
      {{repository_files}}
      
      Provide a comprehensive security report with:
      - Identified vulnerabilities categorized by severity
      - Specific remediation recommendations
      - Risk assessment for each finding
testData:
  - input: |
      repository_files: "src/app.py, src/utils.py, .github/workflows/ci.yml"
    expected: |
      {
        "vulnerabilities": [
          {
            "file": "src/app.py",
            "severity": "high",
            "type": "hardcoded_secret",
            "recommendation": "Move to environment variables"
          }
        ],
        "summary": {
          "total_files": 3,
          "vulnerabilities_found": 1
        }
      }
evaluators:
  - name: Output should be valid JSON
    json:
      validJson: true
  - name: Should include vulnerabilities array
    json:
      hasKey: "vulnerabilities"
  - name: Should include summary
    json:
      hasKey: "summary"
```

## Support

If you need help with migration, refer to:

- Example templates in `prompts/templates/`
- This migration guide
- YAML validation tools
- Team documentation and guidelines
