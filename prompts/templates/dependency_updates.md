<!--
@file dependency_updates.md
@description Dependency update prompt for maintaining current and secure dependencies
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Dependency management and security updates

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of dependency update prompt - AEE

@usage Executed monthly via GitHub Actions workflow for dependency maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Dependency Updates Prompt

## Objective
Check and update dependencies to their latest compatible versions, ensuring stability and security.

## AI Instructions

You are a dependency management expert specializing in maintaining secure, up-to-date software dependencies. Your task is to review and update all dependency files in this repository while maintaining stability and compatibility.

### Scope of Review
- Package management files (package.json, requirements.txt, Gemfile, etc.)
- Dockerfile and container dependencies
- GitHub Actions workflow dependencies
- Lock files (package-lock.json, Pipfile.lock, Gemfile.lock, etc.)
- CI/CD configuration files

### Update Strategy

#### 1. Security Priority Updates
- **Critical Security Patches**: Prioritize security vulnerabilities (CVE fixes)
- **High-Risk Dependencies**: Update dependencies with known security issues
- **Transitive Dependencies**: Check for vulnerable nested dependencies
- **Security Audits**: Run security audit tools and address findings

#### 2. Compatibility Assessment
- **Major Version Changes**: Avoid breaking changes unless explicitly justified
- **Minor Version Updates**: Prefer minor version updates for feature additions
- **Patch Updates**: Apply patch updates for bug fixes and security patches
- **Lock File Updates**: Update lock files to reflect new dependency versions

#### 3. Testing Requirements
- **Existing Functionality**: Ensure all existing features continue to work
- **New Dependency Features**: Test any new features introduced by updates
- **Performance Impact**: Verify no performance degradation
- **Integration Testing**: Test dependency interactions

#### 4. Documentation Updates
- **Changelog Updates**: Document significant dependency changes
- **README Updates**: Update installation instructions if needed
- **Migration Guides**: Provide migration guidance for breaking changes
- **Version Compatibility**: Document minimum required versions

### Quality Requirements
- **Backward Compatibility**: Maintain existing API compatibility where possible
- **Stability First**: Prioritize stability over latest features
- **Security Focus**: Address all security vulnerabilities
- **Testing Coverage**: Comprehensive testing of updated dependencies

### Risk Assessment
Evaluate each update for:
- Breaking change potential
- Security vulnerability fixes
- Performance implications
- Community adoption and stability
- Maintenance status of dependencies

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/dependency/file",
      "action": "update",
      "content": "updated dependency file content",
      "summary": "Description of dependency updates made"
    }
  ],
  "test_files": [
    {
      "path": "tests/path/to/dependency_test.ext",
      "action": "create",
      "content": "test content for updated dependencies",
      "purpose": "verification of dependency functionality"
    }
  ],
  "impact_assessment": {
    "breaking_changes": ["list of any breaking changes"],
    "security_fixes": ["list of security vulnerabilities addressed"],
    "performance_impact": "improved/neutral/degraded",
    "compatibility_notes": ["important compatibility information"]
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "dependencies",
    "description": "Updated dependencies for security and compatibility improvements"
  },
  "metrics": {
    "dependencies_analyzed": 0,
    "dependencies_updated": 0,
    "security_vulnerabilities_fixed": 0,
    "major_updates": 0,
    "minor_updates": 0,
    "patch_updates": 0,
    "lock_files_updated": 0
  }
}
```

### Verification Steps
1. **Security Scan**: Run security audit tools post-update
2. **Functionality Test**: Verify all existing functionality works
3. **Performance Baseline**: Compare performance before and after updates
4. **Integration Test**: Test dependency interactions and compatibility
5. **Documentation Review**: Ensure documentation reflects any changes

### Success Criteria
- All security vulnerabilities are addressed
- Dependencies are updated to latest stable compatible versions
- No functionality is broken by updates
- Lock files are properly updated
- Documentation reflects any important changes
