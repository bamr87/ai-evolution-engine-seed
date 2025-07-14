<!--
@file prompts/README.md
@description Directory index for evolution prompts and growth instructions
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Organize repository documentation structure

@relatedEvolutions
  - v1.0.0: Initial creation during documentation cleanup

@dependencies
  - markdown: for prompt formatting

@changelog
  - 2025-07-12: Initial creation during repository cleanup - ITJ

@usage Contains evolution prompts and growth instructions
@notes Prompts guide AI evolution cycles and system growth
-->

# Prompts Directory

This directory contains evolution prompts, growth instructions, and AI guidance documents that drive the evolution cycles of the AI Evolution Engine.

## Directory Contents

### Prompt Files

#### Core Growth Prompts (YAML Format)

- `first_growth.yml` - Initial growth prompt for starting evolution cycles with Idea Incubator feature
- `next_evolution.yml` - Template for subsequent evolution prompts based on current state

#### Legacy Files (Markdown Format - Deprecated)

- `first_growth.md` - Original markdown format (superseded by YAML version)
- `next_prompt.md` - Empty template file (superseded by next_evolution.yml)

### Template Directory (`templates/`)

#### YAML Format Templates (Current Standard)

- `text_summarizer.yml` - Example text summarization prompt with testing framework
- `doc_harmonization.yml` - Documentation standardization and consistency
- `security_scan.yml` - Security vulnerability scanning and remediation
- `test_enhancement.yml` - Test coverage and quality improvements
- `code_refactor.yml` - Code quality and maintainability improvements

#### Legacy Markdown Templates (Deprecated)

- Various `.md` files - Original markdown format templates

## Purpose

The prompts directory serves as a repository for:

- **Evolution Instructions**: Specific prompts that guide AI evolution behavior
- **Growth Templates**: Reusable prompt templates for different evolution types
- **AI Guidance**: Instructions that define how the AI should approach different tasks
- **Evolution Strategies**: Prompts that implement specific evolution methodologies
- **Testing Framework**: Embedded testing and validation for prompt reliability

## Prompt Format Standards

### YAML Format (Current Standard)

The repository has migrated to a standardized YAML format for all prompts, providing:

- **Structured Configuration**: Clear separation of metadata, model parameters, and content
- **Embedded Testing**: Built-in test data and evaluators for prompt validation
- **Model Parameters**: Explicit temperature, token limits, and model specifications
- **Evaluators**: Automated validation of prompt outputs for quality assurance

#### Standard YAML Structure

```yaml
name: Prompt Name
description: Brief description of the prompt's purpose
model: gpt-4o-mini
modelParameters:
  temperature: 0.3
  max_tokens: 4000
messages:
  - role: system
    content: System instructions and context
  - role: user
    content: User prompt with placeholder variables {{variable}}
testData:
  - input: |
      variable: "example input"
    expected: "expected output format"
evaluators:
  - name: Validation rule description
    json:
      validJson: true
```

### Template Variables

Prompts use double-brace syntax for variable substitution:

- `{{repository_files}}` - List of repository files to analyze
- `{{current_state}}` - Current repository state and metrics
- `{{growth_objectives}}` - Specific evolution goals and targets
- `{{source_files}}` - Source code files for analysis

## Prompt Types

### Growth Prompts

- **Initial Growth**: Starting prompts for new evolution cycles
- **Incremental Growth**: Prompts for ongoing development and improvement
- **Specialized Growth**: Targeted prompts for specific areas (testing, documentation, etc.)

### Instruction Templates

- **Reusable Templates**: Standard prompt formats for common operations
- **Customizable Prompts**: Templates that can be adapted for specific needs
- **Context-Specific**: Prompts tailored for particular development contexts

## Usage Guidelines

1. **Clear Instructions**: Prompts should be clear and specific
2. **Consistent Format**: Follow established prompt formatting conventions
3. **Version Control**: Track prompt changes and their effects
4. **Testing**: Validate prompts before using in production evolution cycles

## Best Practices

- **Specificity**: Make prompts as specific as possible for better results
- **Context**: Include relevant context and constraints
- **Goals**: Clearly define the desired outcomes
- **Safety**: Include appropriate safeguards and limitations
- **Evolution**: Update prompts based on results and learning

## Future Enhancements

- [ ] **Multi-Language Support**: Prompts for non-English repositories
- [ ] **Custom Model Integration**: Support for different AI models and providers
- [ ] **Advanced Validation**: Enhanced testing frameworks for prompt outputs
- [ ] **Interactive Prompts**: Dynamic prompts that adapt based on repository state
- [ ] **Prompt Analytics**: Detailed metrics and success tracking for prompt effectiveness
- [ ] **Template Marketplace**: Sharing and discovery system for community prompt templates
- [ ] **Visual Prompt Builder**: GUI tool for creating and editing prompt templates
- [ ] **Conditional Execution**: Smart prompt triggering based on repository conditions

## Integration with Evolution Engine

This directory integrates seamlessly with:
- [GitHub Actions Workflows](../.github/workflows/README.md) - Automated execution
- [Evolution Engine Scripts](../scripts/README.md) - Processing and validation
- [Testing Framework](../tests/README.md) - Quality assurance and validation
- [Documentation System](../docs/README.md) - Knowledge management and organization

## Related Documentation

- [Main Repository README](../README.md) - Project overview and quick start
- [Evolution Engine Documentation](../docs/evolution/) - Detailed evolution cycle information
- [AI Prompts Configuration Guide](../docs/guides/ai-prompts-configuration.md) - Complete configuration reference
- [Periodic Evolution Implementation](../PERIODIC_PROMPTS_IMPLEMENTATION.md) - Technical implementation details