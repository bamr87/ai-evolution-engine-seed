<!--
@file docs/guides/ai-prompts-configuration.md
@description Comprehensive guide for AI prompts evolution configuration
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - ai_prompts_evolution.json: Implementation and documentation

@relatedEvolutions
  - v1.0.0: Initial creation for AI prompts configuration system

@dependencies
  - ai_prompts_evolution.json: Main configuration file
  - jq: JSON processor for configuration parsing

@changelog
  - 2025-07-12: Initial creation of AI prompts configuration documentation - ITJ

@usage Referenced by main README.md and technical documentation
@notes Central documentation for AI evolution prompt management
-->

# AI Prompts Evolution Configuration Guide

## Overview

The `ai_prompts_evolution.json` file serves as the central configuration for the AI Evolution Engine's automated prompt execution system. This comprehensive configuration defines evolution strategies, prompt definitions, execution rules, and monitoring settings for all AI-driven evolution cycles.

## Configuration File Structure

### Location and Purpose

```
ai_prompts_evolution.json    # Root-level configuration file
```

This file centralizes all AI evolution prompt management, providing:
- **Structured prompt definitions** with metadata and execution settings
- **Evolution strategies** with safety levels and validation requirements  
- **Scheduling and automation** configuration for periodic evolution
- **Execution rules** and validation gates for safe operation
- **Monitoring and reporting** settings for tracking effectiveness

## Configuration Sections

### 1. Global Settings

Controls default behavior and execution parameters:

```json
{
  "global_settings": {
    "default_dry_run": false,
    "max_execution_time": "30m",
    "require_validation": true,
    "enable_rollback": true,
    "log_level": "info",
    "context_collection": {
      "max_files": 50,
      "max_lines_per_file": 1000,
      "include_tests": true,
      "include_docs": true,
      "exclude_patterns": ["*.log", "*.tmp", "*/node_modules/*"]
    }
  }
}
```

**Key Settings:**
- `default_dry_run`: Whether to run in simulation mode by default
- `max_execution_time`: Maximum time allowed for prompt execution
- `context_collection`: Parameters for gathering repository context

### 2. Evolution Strategies

Defines execution approaches with different safety and scope levels:

```json
{
  "evolution_strategies": {
    "conservative": {
      "description": "Safe, minimal changes with thorough validation",
      "safety_level": "high",
      "change_scope": "minimal",
      "require_tests": true,
      "max_file_changes": 5,
      "validation_steps": ["syntax", "tests", "lint"]
    },
    "adaptive": {
      "description": "Balanced approach with moderate changes",
      "safety_level": "medium",
      "change_scope": "moderate",
      "require_tests": true,
      "max_file_changes": 15,
      "validation_steps": ["syntax", "tests"]
    }
  }
}
```

**Available Strategies:**
- **Conservative**: High safety, minimal changes, extensive validation
- **Adaptive**: Balanced approach, moderate changes (default)
- **Experimental**: Low safety, extensive changes, minimal validation
- **Test-automation**: Testing-focused with high safety and coverage requirements

### 3. Prompt Categories

Organizes prompts by purpose and execution frequency:

```json
{
  "prompt_categories": {
    "maintenance": {
      "description": "Regular maintenance and code quality",
      "frequency": "weekly",
      "priority": "high",
      "prompts": ["doc_harmonization", "security_scan", "changelog_versioning"]
    },
    "enhancement": {
      "description": "Feature improvements and optimizations",
      "frequency": "monthly", 
      "priority": "medium",
      "prompts": ["code_refactor", "performance_optimization", "test_enhancement"]
    }
  }
}
```

**Categories:**
- **Maintenance**: Weekly high-priority tasks (documentation, security, versioning)
- **Enhancement**: Monthly medium-priority improvements (refactoring, optimization, testing)
- **Infrastructure**: Monthly workflow and dependency management
- **Community**: Monthly community-focused improvements

### 4. Prompt Definitions

Detailed configuration for each individual prompt:

```json
{
  "prompt_definitions": {
    "doc_harmonization": {
      "name": "Documentation Harmonization",
      "description": "Review and standardize all documentation for consistency",
      "category": "maintenance",
      "template_file": "prompts/templates/doc_harmonization.md",
      "schedule": {
        "cron": "0 2 * * 1",
        "description": "Mondays at 2 AM UTC"
      },
      "execution_settings": {
        "strategy": "conservative",
        "timeout": "15m",
        "max_changes": 10,
        "focus_areas": ["documentation", "formatting", "consistency"]
      },
      "success_criteria": {
        "documentation_score": ">= 8.0",
        "consistency_score": ">= 9.0",
        "no_broken_links": true
      }
    }
  }
}
```

**Prompt Properties:**
- `template_file`: Path to the markdown prompt template
- `schedule`: Cron schedule and description for automated execution
- `execution_settings`: Strategy, timeout, and focus areas
- `success_criteria`: Measurable goals for prompt effectiveness

## Usage Examples

### Loading Configuration

```bash
# Load configuration in scripts
source src/lib/utils/json_processor.sh
CONFIG=$(ai_prompts_load_config)
```

### Getting Prompt Information

```bash
# Get prompt definition
DEFINITION=$(ai_prompts_get_definition "doc_harmonization" "$CONFIG")

# Get execution strategy
STRATEGY=$(ai_prompts_get_strategy "doc_harmonization" "$CONFIG")

# Get schedule information
SCHEDULE=$(ai_prompts_get_schedule "doc_harmonization" "$CONFIG")
```

### Listing Prompts by Category

```bash
# List all prompts
ALL_PROMPTS=$(ai_prompts_list_by_category "" "$CONFIG")

# List maintenance prompts
MAINTENANCE_PROMPTS=$(ai_prompts_list_by_category "maintenance" "$CONFIG")
```

### Executing Prompts

```bash
# Execute with default settings
./scripts/execute-periodic-prompt.sh --prompt-name doc_harmonization

# Execute with custom settings
./scripts/execute-periodic-prompt.sh \
  --prompt-name security_scan \
  --dry-run false \
  --execution-mode manual
```

## Available Prompts

### Maintenance Category (Weekly)

1. **doc_harmonization** - Documentation consistency and formatting
   - Schedule: Mondays at 2 AM UTC
   - Strategy: Conservative
   - Focus: Documentation formatting and consistency

2. **security_scan** - Security vulnerability detection and fixes
   - Schedule: Wednesdays at 3 AM UTC  
   - Strategy: Conservative
   - Focus: Security vulnerabilities and permissions

3. **changelog_versioning** - Version tracking and changelog maintenance
   - Schedule: Fridays at 4 AM UTC
   - Strategy: Conservative
   - Focus: Version consistency and documentation

### Enhancement Category (Monthly)

4. **test_enhancement** - Test coverage and quality improvements
   - Schedule: Tuesdays at 2 AM UTC (bi-weekly)
   - Strategy: Adaptive
   - Focus: Test coverage and quality

5. **code_refactor** - Code quality and maintainability improvements
   - Schedule: 1st of month at 1 AM UTC
   - Strategy: Adaptive
   - Focus: Code quality and readability

6. **performance_optimization** - Performance improvements and optimization
   - Schedule: 8th of month at 3 AM UTC
   - Strategy: Adaptive
   - Focus: Performance and efficiency

### Infrastructure Category (Monthly)

7. **dependency_updates** - Dependency management and updates
   - Schedule: 15th of month at 2 AM UTC
   - Strategy: Conservative
   - Focus: Dependencies and compatibility

8. **workflow_optimization** - CI/CD and workflow improvements
   - Schedule: 22nd of month at 4 AM UTC
   - Strategy: Adaptive
   - Focus: Workflows and automation

### Community Category (Monthly)

9. **community_guidelines** - Community documentation and standards
   - Schedule: 28th of month at 5 AM UTC
   - Strategy: Conservative
   - Focus: Community guidelines and standards

10. **prompt_refinement** - AI prompt template improvements
    - Schedule: 30th of month at 6 AM UTC
    - Strategy: Experimental
    - Focus: Prompt effectiveness and self-improvement

## Advanced Configuration

### Execution Rules

Control when prompts should execute or be skipped:

```json
{
  "execution_rules": {
    "skip_conditions": [
      {
        "condition": "recent_commits",
        "threshold": "24h",
        "description": "Skip if commits made in last 24 hours"
      },
      {
        "condition": "open_issues", 
        "threshold": 10,
        "description": "Skip if more than 10 open issues"
      }
    ]
  }
}
```

### Monitoring and Reporting

Track prompt execution effectiveness:

```json
{
  "monitoring": {
    "metrics": {
      "track_execution_time": true,
      "track_success_rate": true,
      "track_change_impact": true
    },
    "alerting": {
      "on_failure": true,
      "on_quality_degradation": true
    }
  }
}
```

## Testing and Validation

### Test Configuration

```bash
# Test configuration loading and functions
./scripts/test-ai-prompts-config.sh

# Test specific prompt execution
./scripts/execute-periodic-prompt.sh --prompt-name doc_harmonization --dry-run true
```

### Validation Steps

1. **JSON Validation**: Ensure configuration is valid JSON
2. **Template Validation**: Verify all template files exist
3. **Schedule Validation**: Check cron expressions are valid
4. **Strategy Validation**: Ensure all referenced strategies exist

## Integration with Workflows

### GitHub Actions Integration

The configuration integrates with:
- `periodic_evolution.yml` - Scheduled prompt execution
- `ai_evolver.yml` - Manual evolution triggers
- Individual prompt workflows

### Script Integration

Enhanced scripts that use the configuration:
- `execute-periodic-prompt.sh` - Primary execution script
- `validate-periodic-prompts.sh` - Configuration validation
- `generate-evolution-prompt.sh` - Dynamic prompt generation

## Best Practices

### Configuration Management

1. **Version Control**: Keep configuration in version control
2. **Testing**: Test changes with dry-run mode first
3. **Validation**: Use validation scripts before deployment
4. **Documentation**: Update this guide when adding new prompts

### Prompt Development

1. **Template Consistency**: Follow established template patterns
2. **Success Criteria**: Define measurable success criteria
3. **Safety First**: Use conservative strategy for new prompts
4. **Incremental**: Start with minimal scope and expand gradually

### Monitoring and Maintenance

1. **Regular Review**: Review prompt effectiveness monthly
2. **Metrics Tracking**: Monitor success rates and execution times
3. **Strategy Adjustment**: Adjust strategies based on results
4. **Community Feedback**: Incorporate user feedback into improvements

## Troubleshooting

### Common Issues

1. **Configuration Not Found**: Ensure `ai_prompts_evolution.json` is in repository root
2. **Template Missing**: Verify template files exist at specified paths
3. **JSON Validation Error**: Use `jq` to validate JSON syntax
4. **Permission Issues**: Ensure scripts have execute permissions

### Debugging Commands

```bash
# Validate JSON syntax
jq '.' ai_prompts_evolution.json

# Check specific prompt configuration
jq '.prompt_definitions.doc_harmonization' ai_prompts_evolution.json

# Test configuration loading
./scripts/test-ai-prompts-config.sh

# Debug prompt execution
LOG_LEVEL=debug ./scripts/execute-periodic-prompt.sh --prompt-name doc_harmonization
```

## Future Enhancements

### Planned Features

1. **Dynamic Configuration**: Runtime configuration updates
2. **Conditional Execution**: Advanced condition checking
3. **Custom Strategies**: User-defined execution strategies
4. **Integration APIs**: REST API for configuration management
5. **Multi-Repository**: Configuration sharing across repositories

### Contributing

To contribute new prompts or enhance existing ones:

1. Add prompt template to `prompts/templates/`
2. Update `ai_prompts_evolution.json` with prompt definition
3. Test with `scripts/test-ai-prompts-config.sh`
4. Update this documentation
5. Submit pull request with changes

---

*This configuration system enables sophisticated AI-driven evolution with safety, monitoring, and flexibility built-in from the ground up.*