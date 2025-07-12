<!--
@file changelog_versioning.md
@description Changelog and versioning update prompt for release management
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Changelog maintenance and semantic versioning

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of changelog and versioning prompt - AEE

@usage Executed weekly via GitHub Actions workflow for release management
@notes Part of the periodic AI prompts system for repository evolution
-->

# Changelog and Versioning Update Prompt

## Objective
Ensure the changelog is up-to-date and semantic versioning is correctly applied based on recent changes and commit history.

## AI Instructions

You are an expert in release management, semantic versioning, and changelog maintenance. Your task is to analyze the repository's commit history and current state to update the changelog and suggest appropriate version increments.

### Scope of Analysis

#### 1. Version History Review
- **Current Version**: Identify the current version from tags, package files, or version files
- **Commit History**: Analyze commits since the last version release
- **Change Categories**: Categorize changes as major, minor, or patch according to semantic versioning
- **Breaking Changes**: Identify any breaking changes that require major version increment

#### 2. Changelog Analysis
- **Existing Changelog**: Review current changelog format and content
- **Missing Entries**: Identify changes not reflected in the changelog
- **Format Consistency**: Ensure consistent formatting and structure
- **Version Organization**: Organize entries by version and date

#### 3. Change Impact Assessment
- **API Changes**: Identify changes to public APIs or interfaces
- **Feature Additions**: New features and capabilities added
- **Bug Fixes**: Issues resolved and bugs fixed
- **Security Updates**: Security improvements and vulnerability fixes
- **Performance Improvements**: Optimizations and performance enhancements

### Semantic Versioning Guidelines

#### Major Version (X.0.0)
- Breaking changes to public APIs
- Removal of deprecated features
- Significant architectural changes
- Changes that require user action for upgrade

#### Minor Version (0.X.0)
- New features that are backward compatible
- New public API additions
- Deprecation of features (without removal)
- Significant improvements that don't break compatibility

#### Patch Version (0.0.X)
- Bug fixes that are backward compatible
- Security patches
- Documentation updates
- Internal improvements without API changes

### Changelog Format Standards

#### Structure
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Now removed features

### Fixed
- Bug fixes

### Security
- Security vulnerability fixes

## [1.0.0] - YYYY-MM-DD
```

#### Entry Categories
- **Added**: New features and capabilities
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Now removed features
- **Fixed**: Bug fixes and issue resolutions
- **Security**: Security vulnerability fixes

### Change Detection Methods

#### 1. Git Commit Analysis
- Parse commit messages for conventional commit format
- Identify commit types (feat, fix, docs, style, refactor, etc.)
- Extract scope and breaking change indicators
- Group commits by category and impact

#### 2. File Change Analysis
- Analyze modified files to understand change scope
- Identify API changes through file diffs
- Detect configuration changes and their impact
- Review documentation updates

#### 3. Issue and PR Analysis
- Review closed issues and merged pull requests
- Extract change descriptions and impact information
- Identify feature requests and bug reports
- Correlate changes with user-reported issues

### Version Recommendation Logic

#### Algorithm for Version Increment
1. **Scan for breaking changes**: If found, recommend major version increment
2. **Check for new features**: If found without breaking changes, recommend minor version increment
3. **Identify bug fixes only**: If only fixes and patches, recommend patch version increment
4. **Consider special cases**: Security updates, dependency updates, etc.

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "CHANGELOG.md",
      "action": "update",
      "content": "updated changelog content with new entries",
      "summary": "Added entries for recent changes and updated version information"
    }
  ],
  "impact_assessment": {
    "recommended_version": "X.Y.Z",
    "version_increment_type": "major/minor/patch",
    "breaking_changes": ["list of breaking changes if any"],
    "new_features": ["list of new features added"],
    "bug_fixes": ["list of bugs fixed"],
    "change_summary": "overall summary of changes"
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "recommended version",
    "type": "release",
    "description": "Updated changelog and version for latest release"
  },
  "metrics": {
    "commits_analyzed": 0,
    "changes_categorized": 0,
    "changelog_entries_added": 0,
    "version_accuracy_score": 0.0,
    "breaking_changes_identified": 0,
    "features_documented": 0,
    "fixes_documented": 0
  }
}
```

### Quality Assurance

#### 1. Accuracy Verification
- Cross-reference commits with changelog entries
- Verify version increment follows semantic versioning rules
- Ensure all significant changes are documented
- Validate change categorization

#### 2. Format Consistency
- Maintain consistent formatting across changelog
- Use standard date formats and version numbering
- Ensure proper markdown formatting
- Validate links and references

#### 3. Completeness Check
- Ensure no significant changes are missed
- Verify all categories are properly used
- Check for proper attribution where needed
- Validate chronological ordering

### Success Criteria
- Changelog accurately reflects all recent changes
- Version increment follows semantic versioning principles
- All breaking changes are clearly documented
- Changelog maintains consistent format and structure
- Users can easily understand what changed between versions
