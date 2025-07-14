<!--
@file scripts/README.md
@description Directory index for utility scripts and automation tools
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Organize repository documentation structure

@relatedEvolutions
  - v1.0.0: Initial creation during documentation cleanup

@dependencies
  - bash: >=4.0 for script execution
  - Various tools depending on script functionality

@changelog
  - 2025-07-12: Initial creation during repository cleanup - ITJ

@usage Contains utility scripts for system operations
@notes Scripts should be executable and well-documented
-->

# Scripts Directory

This directory contains utility scripts, automation tools, and helper programs that support the AI Evolution Engine operations and development workflow, organized into subdirectories by category.

## Purpose

The scripts directory serves as a central location for:
- **Automation Tools**: Scripts that automate common development tasks
- **Utility Functions**: Helper scripts for system operations
- **Analysis Tools**: Scripts for analyzing system health and performance
- **Debug Helpers**: Tools for troubleshooting and debugging issues
- **Maintenance Scripts**: Automated maintenance and cleanup operations

## Script Categories and Structure

### Core Scripts (scripts/core/)
- `evolve.sh` - Core evolution cycle orchestration
- `local-evolution.sh` - Local development runner for evolution cycles
- `modular-evolution.sh` - Main evolution script using modular architecture
- `simulate-ai-growth.sh` - Simulates AI growth and generates evolution response
- `apply-growth-changes.sh` - Applies evolutionary changes from AI response
- `create_pr.sh` - Creates a pull request with evolution changes
- `setup-environment.sh` - Sets up the necessary environment for evolution workflows
- `run-workflow.sh` - Manual workflow runner

### Analysis Scripts (scripts/analysis/)
- `analyze-repository-health.sh` - Analyzes repository health and suggests improvements
- `analyze-repository-health-simple.sh` - Simple repository health analysis
- `check-prereqs.sh` - Validates environment setup for workflows
- `collect-context.sh` - Collects repository context and metrics for AI evolution
- `collect-evolution-metrics.sh` - Collects and updates evolution metrics
- `collect-workflow-errors.sh` - Collects and aggregates workflow errors

### Debug Scripts (scripts/debug/)
- `ai-debug-helper.sh` - Debugging assistance and troubleshooting tools
- `debug-prereqs.sh` - Debug version of prerequisite checker
- `monitor-logs.sh` - Real-time log monitoring

### Fallback Scripts (scripts/fallback/)
- `emergency-fallback.sh` - Emergency fallback for critical failures
- `simple-ai-simulator.sh` - Simple AI growth simulator
- `simple-change-applier.sh` - Simple change application
- `simple-context-collector.sh` - Simple context collection

### Generation Scripts (scripts/generation/)
- `generate_ai_response.sh` - Generates simulated AI response
- `generate-evolution-prompt.sh` - Generates targeted evolution prompt
- `generate_seed.sh` - Generates the next .seed.md content
- `plant-new-seeds.sh` - Plants new seeds for next evolution

### Notification Scripts (scripts/notification/)
- `send-evolution-notification.sh` - Sends notifications about evolution cycles

### Periodic Scripts (scripts/periodic/)
- `apply-periodic-changes.sh` - Applies changes from periodic prompts
- `execute-periodic-prompt.sh` - Executes periodic AI prompts

### Test Scripts (scripts/test/)
- `test-ai-prompts-config.sh` - Tests AI prompts configuration
- `test-context-collection.sh` - Tests context collection
- `test-enhanced-workflows.sh` - Tests enhanced workflows
- `test-fixes.sh` - Tests workflow fixes
- `test-simple-fallbacks.sh` - Tests simple fallback scripts

### Trigger Scripts (scripts/trigger/)
- `trigger-evolution-workflow.sh` - Triggers main evolution workflow

### Update Scripts (scripts/update/)
- `update-evolution-metrics.sh` - Updates daily evolution metrics

### Validation Scripts (scripts/validation/)
- `validate-docs-organization.sh` - Validates documentation organization
- `validate-evolution.sh` - Validates evolution results
- `validate-periodic-prompts.sh` - Validates periodic prompts system
- `validate-workflows.sh` - Validates workflow structures
- `post-ai-validation.sh` - Post-AI prompt cycle validation
- `final-validation.sh` - Final workflow validation

### Version Scripts (scripts/version/)
- `version-integration.sh` - Integration for version management in workflows
- `version-manager.sh` - Comprehensive version management system
- `version-tracker.sh` - Advanced version change tracking

### Migration Scripts (scripts/migration/)
- `migrate-to-modular.sh` - Migration helper to modular architecture

## Usage Guidelines

1. **Executable**: All scripts have appropriate execute permissions
2. **Documentation**: Each script has proper header and usage information
3. **Error Handling**: Robust error handling following DFF principles
4. **Dependencies**: Documented external dependencies
5. **Testing**: Validate scripts before use

## Best Practices

- Keep scripts focused on specific tasks
- Design for reusability
- Include safeguards and validation
- Provide logging and output
- Regularly review and update