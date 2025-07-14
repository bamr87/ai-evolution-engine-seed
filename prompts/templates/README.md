<!--
@file prompts/templates/README.md
@description AI prompt templates for periodic evolution and automation
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-01
@lastModified 2025-07-12
@version 2.0.0

@relatedIssues 
  - #periodic-evolution: Automated repository maintenance through AI prompts
  - #prompt-standardization: Migration from Markdown to YAML format

@relatedEvolutions
  - v2.0.0: Migration to standardized YAML format with embedded testing
  - v1.5.0: Enhanced prompt templates with safety features
  - v1.0.0: Initial periodic evolution prompt system

@dependencies
  - GitHub Actions: for automated prompt execution
  - YAML processors: for prompt template parsing
  - AI models: gpt-4o-mini for prompt processing

@changelog
  - 2025-07-12: Added comprehensive file header and enhanced documentation - AEE
  - 2025-07-08: Completed migration to YAML format with embedded testing - AEE
  - 2025-07-01: Enhanced safety features and validation systems - AEE
  - 2025-06-15: Initial periodic evolution prompt implementation - AEE

@usage AI prompt templates for automated repository maintenance and evolution
@notes Contains both active YAML templates and deprecated Markdown templates
-->

# Periodic AI Evolution Prompts

This directory contains AI prompt templates for automated repository maintenance and evolution. These prompts are designed to be executed periodically via GitHub Actions to keep the repository healthy, secure, and up-to-date.

## Overview

The periodic AI evolution system automatically performs various maintenance tasks on a schedule:

- **Weekly**: Documentation harmonization, security scans, changelog updates
- **Bi-weekly**: Test suite enhancement
- **Monthly**: Code refactoring, dependency updates, performance optimization, workflow improvements

## Prompt Format Migration

**IMPORTANT**: This directory is migrating from Markdown (`.md`) to YAML (`.yml`) format for all prompts.

### Current YAML Templates (Active)

These templates use the standardized YAML format with embedded testing and validation:

#### 1. Text Summarizer (`text_summarizer.yml`)
- **Purpose**: Example template demonstrating the standardized YAML prompt format
- **Model**: gpt-4o-mini
- **Features**: Input validation, output testing, structured evaluators

#### 2. Documentation Harmonization (`doc_harmonization.yml`)
- **Schedule**: Mondays at 2 AM UTC
- **Purpose**: Standardize documentation styling, syntax, and frontmatter
- **Focus**: Consistency, readability, and SEO optimization
- **Safe Mode**: ✅ Enabled (low-risk changes)

#### 3. Security Scan (`security_scan.yml`)
- **Schedule**: Wednesdays at 3 AM UTC
- **Purpose**: Identify and fix security vulnerabilities
- **Focus**: Code security, configuration hardening, secret management
- **Safe Mode**: ✅ Enabled (critical security fixes only)

#### 4. Test Enhancement (`test_enhancement.yml`)
- **Schedule**: Tuesdays at 2 AM UTC (every other week)
- **Purpose**: Expand test coverage and improve test quality
- **Focus**: Unit tests, integration tests, edge cases
- **Safe Mode**: ❌ Disabled (can modify code)

#### 5. Code Refactoring (`code_refactor.yml`)
- **Schedule**: 1st of month at 1 AM UTC
- **Purpose**: Improve code quality and maintainability
- **Focus**: Readability, best practices, DRY principles
- **Safe Mode**: ❌ Disabled (code modifications)

### Legacy Markdown Templates (Deprecated)

The following `.md` files are deprecated and will be removed in future versions:
- **Schedule**: 1st of month at 1 AM UTC
- **Purpose**: Improve code quality and maintainability
- **Focus**: Readability, best practices, DRY principles
- **Safe Mode**: ❌ Disabled (code modifications)

#### 6. Dependency Updates (`dependency_updates.md`)
- **Schedule**: 15th of month at 2 AM UTC
- **Purpose**: Update dependencies for security and compatibility
- **Focus**: Security patches, minor updates, lock file updates
- **Safe Mode**: ✅ Enabled (conservative updates only)

#### 7. Performance Optimization (`performance_optimization.md`)
- **Schedule**: 8th of month at 3 AM UTC
- **Purpose**: Optimize performance bottlenecks
- **Focus**: Algorithm efficiency, resource usage, workflow speed
- **Safe Mode**: ❌ Disabled (performance modifications)

#### 8. Workflow Optimization (`workflow_optimization.md`)
- **Schedule**: 22nd of month at 4 AM UTC
- **Purpose**: Improve GitHub Actions workflows
- **Focus**: Efficiency, reliability, caching, parallelization
- **Safe Mode**: ✅ Enabled (workflow improvements)

#### 9. Community Guidelines (`community_guidelines.md`)
- **Schedule**: 28th of month at 5 AM UTC
- **Purpose**: Update contribution and community documentation
- **Focus**: Accessibility, inclusivity, contributor experience
- **Safe Mode**: ❌ Disabled (documentation enhancements)

#### 10. Prompt Refinement (`prompt_refinement.md`)
- **Schedule**: 30th of month at 6 AM UTC
- **Purpose**: Improve AI prompt templates themselves
- **Focus**: Self-improvement, effectiveness, clarity
- **Safe Mode**: ❌ Disabled (meta-improvements)

## Configuration

### Evolution Configuration (`.evolution.yml`)

The periodic prompts are configured in the repository's `.evolution.yml` file:

```yaml
periodic_prompts:
  enabled: true
  base_path: "prompts/templates"
  
  weekly:
    - name: doc_harmonization
      schedule: "0 2 * * 1"
      template: "doc_harmonization.md"
      priority: high
      safe_mode: true
  # ... additional prompts
```

### Workflow Configuration

The periodic evolution workflow (`.github/workflows/periodic_evolution.yml`) handles:
- Schedule-based prompt selection
- Manual trigger capabilities
- Context collection and validation
- Change application and PR creation
- Metrics collection and reporting

## Usage

### Automatic Execution

Prompts run automatically based on their configured schedules. No manual intervention is required.

### Manual Execution

You can manually trigger specific prompts via GitHub Actions:

1. Go to the Actions tab in your repository
2. Select "Periodic AI Evolution Engine"
3. Click "Run workflow"
4. Choose the specific prompt to execute
5. Optionally enable dry-run mode for testing

### Dry Run Mode

All prompts support dry-run mode for testing:
- Simulates prompt execution without making changes
- Generates sample outputs for validation
- Useful for testing prompt modifications

## Output Format

All prompts generate standardized JSON responses with:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/file",
      "action": "create|update|delete",
      "content": "file content",
      "summary": "description of changes"
    }
  ],
  "test_files": [...],
  "documentation_updates": {...},
  "impact_assessment": {...},
  "changelog_entry": {...},
  "metrics": {...}
}
```

## Quality Assurance

### Validation Steps
1. **Prompt Template Validation**: Structure and format checks
2. **Response Validation**: JSON format and required fields
3. **File Change Validation**: Path validation and safety checks
4. **Syntax Validation**: Language-specific syntax checking
5. **Test Execution**: Automated test validation

### Safety Features
- **Safe Mode**: Conservative changes for critical prompts
- **Backup Creation**: Automatic file backups before changes
- **Rollback Capability**: Easy reversion if issues occur
- **Pull Request Creation**: Changes reviewed before merging
- **Dry Run Testing**: Test changes without applying them

### Monitoring and Metrics

The system tracks:
- Execution success rates
- Change impact metrics
- Performance improvements
- Security vulnerability fixes
- Test coverage increases

## Best Practices

### Prompt Development
- Use clear, specific instructions
- Include concrete examples
- Specify exact output formats
- Define success criteria
- Include validation requirements

### Safety Considerations
- Enable safe mode for critical prompts
- Test prompts in dry-run mode first
- Review generated changes before merging
- Maintain comprehensive backups
- Monitor for unintended consequences

### Customization
- Adjust schedules based on project needs
- Modify prompt templates for specific requirements
- Configure safety settings appropriately
- Add project-specific validation rules

## Contributing

To add new periodic prompts:

1. Create a new prompt template in `prompts/templates/`
2. Follow the existing template structure
3. Add configuration to `.evolution.yml`
4. Update the workflow schedule if needed
5. Test with dry-run mode
6. Document the new prompt in this README

## Support

For issues with periodic prompts:
- Check the workflow logs in GitHub Actions
- Review the generated summary reports
- Examine backup files if changes need reverting
- Use dry-run mode to test modifications
- Consult the AI Evolution Engine documentation

## Metrics and Success Tracking

The system automatically tracks:
- **Execution Metrics**: Success rates, execution times, failure patterns
- **Quality Metrics**: Code quality improvements, test coverage increases
- **Security Metrics**: Vulnerabilities fixed, security score improvements
- **Performance Metrics**: Optimization gains, resource usage reductions
- **Community Metrics**: Documentation improvements, contribution facilitation

These metrics help evaluate the effectiveness of the periodic evolution system and guide future improvements.
