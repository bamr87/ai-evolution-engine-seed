<!--
@file scripts/validation/README.md
@description Validation scripts for repository compliance and quality assurance
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories
  - #validation-automation: Automated compliance and quality validation

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0 for script execution
  - Documentation organization validation rules
  - Evolution validation logic

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Repository validation, compliance checking, and quality assurance scripts
@notes Ensures repository maintains standards and organizational compliance
-->

# Validation Scripts

This directory contains validation scripts that ensure repository compliance, maintain organizational standards, and provide quality assurance for the AI Evolution Engine.

## Purpose

The validation scripts provide:
- **Documentation Organization**: Validates documentation structure and compliance
- **Evolution Validation**: Ensures evolution cycles meet quality standards
- **Workflow Validation**: Validates GitHub Actions workflows and configurations
- **Post-AI Validation**: Comprehensive validation after AI prompt cycles
- **Periodic Validation**: Validates periodic prompt systems and configurations

## Scripts Overview

### Core Validation

| Script | Purpose | Usage |
|--------|---------|-------|
| `validate-docs-organization.sh` | Validates documentation organization rules | `./validate-docs-organization.sh` |
| `post-ai-validation.sh` | Post-AI prompt cycle validation runner | `./post-ai-validation.sh` |
| `final-validation.sh` | Final comprehensive validation | `./final-validation.sh` |

### Specific Validation

| Script | Purpose | Usage |
|--------|---------|-------|
| `validate-evolution.sh` | Validates evolution results and outcomes | `./validate-evolution.sh [cycle-id]` |
| `validate-workflows.sh` | Validates GitHub Actions workflow structure | `./validate-workflows.sh` |
| `validate-periodic-prompts.sh` | Validates periodic prompts system | `./validate-periodic-prompts.sh` |

## Key Features

### Documentation Organization Validation

**Organization Rules Enforcement:**
- All non-README markdown files must reside in `docs/` directory
- Every directory must contain a README.md file
- CHANGELOG.md allowed only at repository root
- Proper file header validation

**Validation Process:**
```bash
# Check for misplaced markdown files
find . -name "*.md" ! -path "./docs/*" ! -name "README.md" ! -name "CHANGELOG.md"

# Verify README.md exists in all directories
find . -type d ! -empty -exec test -f {}/README.md \; -print
```

### Evolution Validation

**Quality Assurance:**
- Evolution cycle completeness validation
- Change impact assessment
- Rollback capability verification
- Success criteria validation

**Validation Criteria:**
- All required files are present
- Changes are syntactically valid
- Tests pass after evolution
- Documentation is updated appropriately

### Workflow Validation

**GitHub Actions Validation:**
- YAML syntax validation
- Required permissions verification
- Input/output parameter validation
- Security best practices compliance

**Validation Checks:**
- Workflow file syntax is valid YAML
- All referenced scripts exist
- Permissions are appropriately scoped
- Security tokens are handled safely

## Usage Examples

### Documentation Organization

```bash
# Validate documentation organization
./validation/validate-docs-organization.sh

# Check specific aspects
./validation/validate-docs-organization.sh --check-headers
./validation/validate-docs-organization.sh --check-structure
```

### Evolution Validation

```bash
# Validate completed evolution cycle
./validation/validate-evolution.sh latest

# Validate specific evolution
./validation/validate-evolution.sh evolution-2025-07-12

# Comprehensive validation
./validation/validate-evolution.sh --comprehensive
```

### Post-AI Validation

```bash
# Run standard post-AI validation
./validation/post-ai-validation.sh

# Verbose post-AI validation
./validation/post-ai-validation.sh --verbose

# Quick validation check
./validation/post-ai-validation.sh --quick
```

### Workflow Validation

```bash
# Validate all workflows
./validation/validate-workflows.sh

# Validate specific workflow
./validation/validate-workflows.sh ai_evolver.yml

# Security-focused validation
./validation/validate-workflows.sh --security-check
```

## Validation Rules

### Documentation Organization Rules

1. **Markdown File Placement:**
   - All `.md` files except `README.md` and `CHANGELOG.md` must be in `docs/`
   - `README.md` files required in every directory
   - `CHANGELOG.md` allowed only at repository root

2. **File Header Requirements:**
   - All files must have standardized headers
   - Headers must include creation date, author, and changelog
   - Version tracking and related issues documentation

3. **Content Standards:**
   - Clear purpose and usage documentation
   - Comprehensive examples and troubleshooting
   - Cross-references to related documentation

### Evolution Validation Rules

1. **Completeness:**
   - All evolution phases completed successfully
   - Required artifacts generated
   - Documentation updated appropriately

2. **Quality:**
   - No syntax errors introduced
   - Test coverage maintained or improved
   - Performance not degraded

3. **Safety:**
   - Rollback capability verified
   - No security vulnerabilities introduced
   - Backwards compatibility maintained

### Workflow Validation Rules

1. **Syntax:**
   - Valid YAML structure
   - Proper GitHub Actions syntax
   - No deprecated actions used

2. **Security:**
   - Minimal required permissions
   - Secure token handling
   - No secret exposure

3. **Functionality:**
   - All referenced files exist
   - Input validation present
   - Error handling implemented

## Validation Reports

### Documentation Organization Report

```
🔍 Validating Documentation Organization
Repository: /path/to/repo
==========================================

1. Checking for misplaced markdown files...
✅ All markdown files are properly organized

2. Checking for missing README.md files...
✅ All directories have README.md files

3. Checking docs/ directory structure...
✅ docs/ directory exists
ℹ️  Found 23 markdown files in docs/ directory

4. Validation Summary
====================
✅ All documentation organization rules are satisfied!
```

### Evolution Validation Report

```
🔄 Validating Evolution Cycle: evolution-2025-07-12
=====================================================

Phase Validation:
✅ Environment Setup - Completed successfully
✅ Context Collection - All required data collected
✅ AI Processing - Response generated and validated
✅ Change Application - 15 files modified safely
✅ Testing - All tests passing
✅ Documentation - Updated appropriately

Quality Checks:
✅ Syntax Validation - No errors detected
✅ Test Coverage - Maintained at 87%
✅ Performance - No degradation detected
✅ Security - No vulnerabilities introduced

Overall Result: ✅ PASSED
```

## Integration with Evolution Engine

The validation scripts integrate with:
- [Core Evolution Scripts](../core/README.md) - Quality gates in evolution cycles
- [Testing Framework](../../tests/README.md) - Validation test execution
- [GitHub Workflows](../../.github/workflows/README.md) - Automated validation
- [Documentation System](../../docs/README.md) - Organization compliance

## Automation and CI/CD

### Automated Validation

**GitHub Actions Integration:**
- Pre-commit validation hooks
- Post-evolution validation checks
- Pull request validation gates
- Scheduled compliance audits

**Validation Triggers:**
- Before evolution cycle execution
- After AI prompt processing
- On pull request creation
- During CI/CD pipeline execution

### Quality Gates

**Validation Gates:**
- Documentation organization compliance
- Evolution cycle quality standards
- Workflow security requirements
- Code quality thresholds

## Best Practices

### Validation Execution
1. **Run validation early** in development cycles
2. **Use comprehensive validation** before releases
3. **Monitor validation trends** for process improvement
4. **Address validation failures promptly**

### Validation Development
1. **Create specific validation rules** for project needs
2. **Maintain validation scripts** as requirements evolve
3. **Document validation criteria** clearly
4. **Test validation scripts** thoroughly

## Future Enhancements

- [ ] **Custom Validation Rules**: User-defined validation criteria and rules
- [ ] **Validation Metrics**: Tracking validation success rates and trends
- [ ] **Automated Remediation**: Self-healing validation with automatic fixes
- [ ] **Integration Testing**: Cross-system validation capabilities
- [ ] **Performance Validation**: Automated performance regression testing
- [ ] **Security Validation**: Advanced security compliance checking
- [ ] **Accessibility Validation**: Automated accessibility compliance testing

## Related Documentation

- [Documentation Organization Guide](../../docs/guides/documentation-organization.md) - Detailed organization standards
- [Evolution Quality Standards](../../docs/guides/evolution-quality.md) - Quality criteria and standards
- [Workflow Standards](../../docs/guides/workflow-standards.md) - GitHub Actions best practices
- [Validation Configuration](../../docs/guides/validation-config.md) - Validation setup and configuration