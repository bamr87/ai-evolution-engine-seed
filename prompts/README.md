---
title: "Prompts Directory: Evolution Prompts and Growth Instructions"
description: "Directory index for evolution prompts, growth instructions, and AI guidance documents that drive the evolution cycles of the AI Evolution Engine"
author: "AI Evolution Engine Team"
created: "2025-07-12"
lastModified: "2025-07-12"
version: "1.0.0"
tags: ["prompts", "ai-evolution", "growth-instructions", "templates"]
category: "core-documentation"
---

# Prompts Directory

This directory contains evolution prompts, growth instructions, and AI guidance documents that drive the evolution cycles of the AI Evolution Engine.

## Purpose

The prompts directory serves as a repository for:

- **Evolution Instructions**: Specific prompts that guide AI evolution behavior
- **Growth Templates**: Reusable prompt templates for different evolution types
- **AI Guidance**: Instructions that define how the AI should approach different tasks
- **Evolution Strategies**: Prompts that implement specific evolution methodologies
- **Testing Framework**: Embedded testing and validation for prompt reliability

## Directory Contents

### Core Growth Prompts

#### `first_growth.prompt.md`

- **Purpose**: Initial growth prompt for starting evolution cycles with Idea Incubator feature
- **Format**: Structured YAML-format with testing framework
- **Usage**: First evolution cycle execution
- **Features**: Complete implementation specifications, testing requirements, evaluation criteria

#### `next_evolution.prompt.md`

- **Purpose**: Template for subsequent evolution prompts based on current repository state
- **Format**: Standardized GitHub prompt format
- **Usage**: Ongoing evolution cycles after initial growth
- **Features**: Context-aware evolution, state-based recommendations, incremental improvements

### Template Directory (`templates/`)

The `templates/` directory contains periodic evolution prompt templates for automated repository maintenance. See [templates/README.md](templates/README.md) for complete documentation.

#### Standardized Prompt Templates

All templates follow the standardized GitHub prompt format with YAML front matter:

- **`text_summarizer.prompt.md`** - Example text summarization prompt with testing framework
- **`doc_harmonization.prompt.md`** - Documentation standardization and consistency
- **`security_scan.prompt.md`** - Security vulnerability scanning and remediation
- **`test_enhancement.prompt.md`** - Test coverage and quality improvements
- **`code_refactor.prompt.md`** - Code quality and maintainability improvements
- **`performance_optimization.prompt.md`** - Performance bottleneck detection and fixes
- **`workflow_optimization.prompt.md`** - CI/CD and workflow improvements
- **`dependency_updates.prompt.md`** - Dependency management and security patches
- **`changelog_versioning.prompt.md`** - Version tracking and changelog maintenance
- **`community_guidelines.prompt.md`** - Contribution guidelines and community documentation
- **`prompt_refinement.prompt.md`** - AI prompt template self-improvement
- **`readme_synchronization.prompt.md`** - README consistency and synchronization

## Prompt Format Standards

### Standardized GitHub Prompt Format

All prompts follow the standardized GitHub prompt format, providing:

- **YAML Front Matter**: Metadata, mode, and description configuration
- **Structured Markdown**: Clear sections with consistent organization
- **Embedded Testing**: Built-in test scenarios and evaluation criteria
- **Model Parameters**: Explicit AI model configuration and settings
- **Comprehensive Documentation**: Detailed usage examples and guidelines

#### Standard Format Structure

```markdown
---
mode: agent
description: Brief description of the prompt's purpose and scope
---

# 🎯 Prompt Title: Clear, Descriptive Name

You are an [AI role description]...

## Core Mission

[Primary objective and scope]

## [Section Name]

[Detailed content with subsections]

## Technical Specifications

### Model Configuration
- Model: [model-name]
- Temperature: [value] ([reasoning])
- Max Tokens: [value] ([purpose])

## [Template/Variables Section]

Execute with these parameters:
- `{{variable1}}` - Description
- `{{variable2}}` - Description

## Test Scenarios

### Primary Test Case

**Input:**

```text
variables: "example values"
```

**Expected Output:**

```json
{
  "structure": "example"
}
```

## Evaluation Criteria

### Output Validation

- [ ] Criteria 1
- [ ] Criteria 2

## Success Metrics

- [ ] Measurable outcome 1
- [ ] Measurable outcome 2

```

### Template Variables

Prompts use double-brace syntax for variable substitution:

- `{{repository_files}}` - List of repository files to analyze
- `{{current_state}}` - Current repository state and metrics
- `{{growth_objectives}}` - Specific evolution goals and targets
- `{{source_files}}` - Source code files for analysis

## Prompt Types

### Growth Prompts

- **Initial Growth**: Starting prompts for new evolution cycles (`first_growth.prompt.md`)
- **Incremental Growth**: Prompts for ongoing development and improvement (`next_evolution.prompt.md`)
- **Specialized Growth**: Targeted prompts for specific areas (testing, documentation, etc.)

### Periodic Evolution Templates

- **Maintenance Prompts**: Weekly automated maintenance (documentation, security, versioning)
- **Enhancement Prompts**: Monthly improvements (code quality, testing, performance)
- **Infrastructure Prompts**: System-level improvements (dependencies, workflows)
- **Community Prompts**: Documentation and contribution guidelines

## Usage Guidelines

1. **Clear Instructions**: Prompts should be clear and specific
2. **Consistent Format**: Follow established prompt formatting conventions
3. **Version Control**: Track prompt changes and their effects
4. **Testing**: Validate prompts before using in production evolution cycles
5. **Documentation**: Maintain comprehensive documentation for each prompt

## Best Practices

### Prompt Development

- **Specificity**: Make prompts as specific as possible for better results
- **Context**: Include relevant context and constraints
- **Goals**: Clearly define the desired outcomes
- **Safety**: Include appropriate safeguards and limitations
- **Evolution**: Update prompts based on results and learning

### Template Usage

- **Consistency**: Use standardized format across all prompts
- **Testing**: Include embedded test scenarios and validation
- **Documentation**: Provide clear usage examples and guidelines
- **Maintenance**: Keep prompts updated with repository evolution

## Integration with Evolution Engine

This directory integrates seamlessly with:

- **[GitHub Actions Workflows](../.github/workflows/)** - Automated execution
- **[Evolution Engine Scripts](../scripts/)** - Processing and validation
- **[Testing Framework](../tests/)** - Quality assurance and validation
- **[Documentation System](../docs/)** - Knowledge management and organization
- **[AI Prompts Configuration](../config/ai_prompts_evolution.json)** - Centralized prompt configuration

## Related Documentation

- **[Main Repository README](../README.md)** - Project overview and quick start
- **[Templates README](templates/README.md)** - Periodic evolution prompt templates
- **[AI Prompts Configuration Guide](../docs/guides/ai-prompts-configuration.md)** - Complete configuration reference
- **[Periodic Evolution Implementation](../PERIODIC_PROMPTS_IMPLEMENTATION.md)** - Technical implementation details
- **[Documentation Organization Guide](../docs/guides/documentation-organization.md)** - Documentation standards

## Future Enhancements

- [ ] **Multi-Language Support**: Prompts for non-English repositories
- [ ] **Custom Model Integration**: Support for different AI models and providers
- [ ] **Advanced Validation**: Enhanced testing frameworks for prompt outputs
- [ ] **Interactive Prompts**: Dynamic prompts that adapt based on repository state
- [ ] **Prompt Analytics**: Detailed metrics and success tracking for prompt effectiveness
- [ ] **Template Marketplace**: Sharing and discovery system for community prompt templates
- [ ] **Visual Prompt Builder**: GUI tool for creating and editing prompt templates
- [ ] **Conditional Execution**: Smart prompt triggering based on repository conditions
