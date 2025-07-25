<!--
@file docs/README.md
@description Documentation index and organization guide for AI Evolution Engine
@author AI Evolution Engine <team@ai-evolution-engine.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 1.0.0

@relatedIssues 
  - Documentation organization implementation
  - Repository structure standardization

@relatedEvolutions
  - v0.3.6: Implemented documentation organization rule

@dependencies
  - Repository structure following documentation organization rule

@changelog
  - 2025-07-05: Updated for documentation organization implementation - AEE
  - 2025-07-04: Initial creation - AEE

@usage Central documentation index - entry point for all project documentation
@notes All documentation resides in docs/ except README.md and CHANGELOG.md in root
-->

# Documentation Structure

This directory contains comprehensive documentation for the AI Evolution Engine, organized following our **Documentation Organization Rule**.

## 📋 Documentation Organization Rule

**All documentation files MUST reside in the `docs/` directory, with only two exceptions:**
- `README.md` - Main project documentation at repository root
- `CHANGELOG.md` - Version change log at repository root

## 📁 Directory Organization

### `/docs/evolution/`

Contains evolution cycle documentation and tracking:

- `EVOLUTION_SUMMARY.md` - Overview of evolution cycles and achievements
- `CROSS_PLATFORM_UPDATE.md` - Cross-platform compatibility implementation  
- `v0.3.0_IMPLEMENTATION_SUMMARY.md` - Detailed v0.3.0 implementation summary
- `TEST_RESULTS.md` - Comprehensive testing results and validation
- `FULL_TEST_VALIDATION_COMPLETE.md` - Complete test validation documentation

### `/docs/architecture/`

Contains technical architecture and design decisions:

- `MODULAR_ARCHITECTURE.md` - Modular architecture guide and implementation
- `REFACTORING_SUMMARY.md` - Code refactoring summaries and improvements

### `/docs/workflows/`

Contains CI/CD and automation documentation:

- `WORKFLOW_QUICK_REFERENCE.md` - Quick reference for workflow execution
- `MANUAL_WORKFLOW_EXECUTION.md` - Manual workflow execution guide
- `WORKFLOW_REFACTORING.md` - Workflow refactoring documentation
- `workflow-testing.md` - GitHub Actions workflow testing guide

### `/docs/guides/`

User guides and tutorials (expanding):

- Getting started guides
- Template usage instructions
- Best practices documentation

### `/docs/seeds/`

Seed documentation and evolution prompts:

- `seed_prompt_testing_automation.md` - Testing automation seed prompt
- `testing-automation-seed.md` - Testing automation seed documentation  
- `.seed_testing_automation.md` - Seed metadata and configuration

### Root Documentation

Core documentation at repository root:

- `DAILY_EVOLUTION.md` - Daily evolution and automated maintenance guide
- `GITHUB_ACTIONS_DEBUGGING.md` - GitHub Actions debugging guide
- `ORGANIZATION.md` - Repository organization guide
- `REORGANIZATION_SUMMARY.md` - Repository reorganization summary

## 📖 Documentation Standards

All documentation follows these principles:

### Design for Failure (DFF)

- Include troubleshooting sections
- Document common failure scenarios
- Provide recovery procedures

### Don't Repeat Yourself (DRY)

- Use cross-references instead of duplicating content
- Maintain single source of truth for each concept
- Link to canonical documentation

### Keep It Simple (KIS)

- Use clear, concise language
- Include practical examples
- Maintain logical organization

### Documentation Organization

- Consistent file naming conventions
- Logical directory hierarchy
- Clear cross-references between documents
- Scalable structure supporting growth

## 🔍 Finding Documentation

### By Topic

- **Getting Started**: `README.md` (repository root)
- **Evolution History**: `docs/evolution/`
- **Technical Architecture**: `docs/architecture/`
- **Workflow Usage**: `docs/workflows/`
- **User Guides**: `docs/guides/`
- **Seed Templates**: `docs/seeds/`

### By Audience

- **New Contributors**: Start with `README.md`, then `docs/guides/`
- **Developers**: `docs/architecture/` and `docs/workflows/`
- **Evolution Tracking**: `docs/evolution/`
- **System Administrators**: `docs/workflows/`

## 🔄 Maintenance Guidelines

### Adding New Documentation

1. **Determine appropriate directory** based on content type and audience
2. **Follow naming conventions** (lowercase with hyphens)
3. **Include file headers** with metadata and tracking information
4. **Update this index** when adding new major documentation sections
5. **Add cross-references** to related documentation

### Updating Existing Documentation

1. **Update file headers** with modification date and changelog entry
2. **Verify cross-references** remain accurate
3. **Update related documentation** when making significant changes
4. **Test documentation examples** to ensure they still work

### Documentation Quality Assurance

- **Consistency**: Follow established patterns and conventions
- **Accuracy**: Keep documentation synchronized with implementation
- **Completeness**: Cover all user-facing features and workflows
- **Accessibility**: Use clear language and logical organization

## 🚀 Quick Links

### Essential Documentation
- [Main README](../README.md) - Project overview and quick start
- [Change Log](../CHANGELOG.md) - Version history and updates
- [Evolution Summary](evolution/EVOLUTION_SUMMARY.md) - Recent evolution achievements

### Technical Documentation
- [Modular Architecture](architecture/MODULAR_ARCHITECTURE.md) - Code organization
- [Workflow Reference](workflows/WORKFLOW_QUICK_REFERENCE.md) - CI/CD usage
- [Testing Guide](workflow-testing.md) - Testing framework

### Evolution Documentation
- [Cross-Platform Update](evolution/CROSS_PLATFORM_UPDATE.md) - Platform compatibility
- [Implementation Summary](evolution/v0.3.0_IMPLEMENTATION_SUMMARY.md) - Technical details
- [Test Results](evolution/TEST_RESULTS.md) - Validation outcomes

---

*This documentation structure supports the AI Evolution Engine's mission to create sustainable, evolving software through organized knowledge management and clear communication.*
- Structure content logically

### Collaboration (COLAB)

- Include contribution guidelines
- Use consistent formatting
- Provide templates for new documentation

## Documentation Lifecycle

1. **Planning**: Document requirements and scope
2. **Development**: Create initial documentation during feature development
3. **Review**: Peer review for accuracy and clarity
4. **Evolution**: Update documentation as features evolve
5. **Archive**: Move outdated documentation to archive with clear migration paths

## Maintenance

Documentation is automatically updated through:

- AI evolution cycles
- CI/CD processes
- Community contributions
- Regular reviews and audits
