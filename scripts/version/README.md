<!--
@file scripts/version/README.md
@description Version management and tracking scripts
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories
  - #version-management: Advanced version tracking and correlation

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0 for script execution
  - jq: for JSON processing
  - git: for version control operations

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Version management, tracking, and correlation scripts
@notes Provides comprehensive version management with file change correlation
-->

# Version Management Scripts

This directory contains scripts for comprehensive version management, change tracking, and correlation analysis for the AI Evolution Engine.

## Purpose

The version management scripts provide:
- **Version Management**: Automated version incrementing and tracking
- **Change Correlation**: Linking version changes to specific file modifications
- **Evolution Integration**: Version management integrated with evolution cycles
- **Historical Analysis**: Tracking version history and change patterns
- **Reporting**: Comprehensive reports linking versions to changes

## Scripts Overview

### Core Version Management

| Script | Purpose | Usage |
|--------|---------|-------|
| `version-manager.sh` | Comprehensive version management system | `./version-manager.sh [command] [options]` |
| `version-tracker.sh` | Advanced version change tracking | `./version-tracker.sh [command] [options]` |
| `version-integration.sh` | Integration for version management in workflows | `./version-integration.sh [type] [description]` |

## Key Features

### Intelligent Version Management

**Automated Version Incrementing:**
- Semantic versioning (major.minor.patch)
- Context-aware version increments
- Evolution cycle integration
- Manual override capabilities

**Change Correlation:**
- File-level change tracking
- Version-to-file change mapping
- Git integration for change detection
- Historical correlation analysis

### Evolution Integration

**Evolution-Aware Versioning:**
- Automatic version increments during evolution cycles
- Change impact assessment
- Evolution context in version metadata
- Rollback version tracking

**Workflow Integration:**
- Pre/post evolution version management
- Automated changelog generation
- Pull request version correlation
- CI/CD version consistency

### Advanced Tracking

**Change Tracking Features:**
- File modification timestamps
- Git commit correlation
- User attribution tracking
- Change magnitude assessment

**Query Capabilities:**
- Version history queries
- File change history
- Cross-version correlation
- Trend analysis

## Usage Examples

### Basic Version Management

```bash
# Check current version status
./version/version-manager.sh check-status

# Increment patch version
./version/version-manager.sh increment patch "Bug fixes and improvements"

# Increment minor version
./version/version-manager.sh increment minor "New features added"

# Increment major version
./version/version-manager.sh increment major "Breaking changes"
```

### Evolution Integration

```bash
# Version increment for evolution cycle
./version/version-integration.sh evolution "Enhanced error handling"

# Pre-evolution version preparation
./version/version-integration.sh prepare-evolution

# Post-evolution version finalization
./version/version-integration.sh finalize-evolution
```

### Advanced Tracking and Analysis

```bash
# Show version history
./version/version-tracker.sh show-history --limit 10

# Find files changed in specific version
./version/version-tracker.sh correlate-files "1.2.3"

# Show version history for specific file
./version/version-tracker.sh file-history "README.md"

# Generate comprehensive report
./version/version-tracker.sh generate-report --format markdown --output report.md
```

### Query Operations

```bash
# Recent version changes
./version/version-tracker.sh show-history --since "7 days ago"

# Changes in version range
./version/version-tracker.sh version-range "1.0.0" "1.2.0"

# Files with most version changes
./version/version-tracker.sh most-changed-files --limit 5

# Version statistics
./version/version-tracker.sh statistics
```

## Version Management Configuration

### Configuration File (.version-config.json)

```json
{
  "current_version": "1.2.3",
  "version_pattern": "v{major}.{minor}.{patch}",
  "auto_increment": {
    "evolution": "patch",
    "feature": "minor",
    "breaking": "major"
  },
  "change_tracking": {
    "enabled": true,
    "track_files": true,
    "include_git_info": true,
    "backup_files": false
  },
  "files_to_update": [
    "README.md",
    "package.json",
    ".version-config.json"
  ],
  "version_patterns": {
    "README.md": "version: \"(.+)\"",
    "package.json": "\"version\": \"(.+)\""
  }
}
```

### Change Tracking Configuration

```json
{
  "tracking": {
    "log_file": "version-changes.json",
    "include_metadata": true,
    "track_file_hashes": true,
    "correlation_data": true
  },
  "changelog": {
    "auto_generate": true,
    "file": "CHANGELOG.md",
    "format": "standard",
    "include_links": true
  }
}
```

## Version Correlation Data

### Version-Changes Correlation

```json
{
  "version": "1.2.3",
  "timestamp": "2025-07-12T14:30:00Z",
  "type": "evolution",
  "description": "Enhanced error handling",
  "files_changed": [
    {
      "path": "src/error-handler.js",
      "lines_added": 45,
      "lines_removed": 12,
      "modification_type": "enhancement"
    },
    {
      "path": "tests/error-handler.test.js",
      "lines_added": 23,
      "lines_removed": 0,
      "modification_type": "test_addition"
    }
  ],
  "git_info": {
    "commit_hash": "abc123...",
    "author": "Evolution Engine",
    "branch": "main"
  }
}
```

### Historical Analysis

**Version Timeline:**
```bash
# Generate version timeline
./version/version-tracker.sh timeline --format json

# Visual version history
./version/version-tracker.sh history --graph
```

**Change Patterns:**
```bash
# Analyze change patterns
./version/version-tracker.sh analyze-patterns

# File modification frequency
./version/version-tracker.sh file-frequency

# Version increment patterns
./version/version-tracker.sh increment-patterns
```

## Integration Points

### Evolution Engine Integration

**Pre-Evolution:**
- Capture current repository state
- Initialize change tracking
- Set version baseline

**During Evolution:**
- Monitor file modifications
- Track change magnitude
- Correlate changes to evolution context

**Post-Evolution:**
- Increment version appropriately
- Generate correlation report
- Update changelog

### CI/CD Integration

**Automated Workflows:**
- Version consistency checking
- Automated version increments
- Change correlation reporting
- Release preparation

**Quality Gates:**
- Version increment validation
- Change impact assessment
- Correlation data verification
- Release readiness checking

## Reporting and Analytics

### Version Reports

**Comprehensive Reports:**
```bash
# Generate detailed version report
./version/version-tracker.sh generate-report \
  --format markdown \
  --include-changes \
  --include-statistics \
  --output version-report.md
```

**Report Contents:**
- Version history with dates
- File change correlations
- Evolution context
- Change statistics
- Trend analysis

### Analytics Queries

**Common Queries:**
```bash
# Most active files by version changes
./version/version-tracker.sh most-changed-files

# Version increment frequency
./version/version-tracker.sh increment-frequency

# Change volume per version
./version/version-tracker.sh change-volume

# Evolution impact analysis
./version/version-tracker.sh evolution-impact
```

## Best Practices

### Version Management
1. **Consistent versioning** following semantic versioning principles
2. **Meaningful descriptions** for version increments
3. **Regular correlation validation** to ensure data accuracy
4. **Backup version data** before major changes

### Change Tracking
1. **Enable comprehensive tracking** for detailed analysis
2. **Regular correlation reports** for insight generation
3. **Monitor change patterns** for process improvement
4. **Archive historical data** for long-term analysis

## Future Enhancements

- [ ] **Visual Analytics**: Interactive dashboards for version and change visualization
- [ ] **Predictive Analysis**: AI-powered prediction of version increment needs
- [ ] **Integration APIs**: RESTful APIs for external version management systems
- [ ] **Advanced Correlation**: Machine learning-powered change pattern analysis
- [ ] **Multi-Repository Tracking**: Cross-repository version correlation
- [ ] **Performance Metrics**: Version-based performance tracking and analysis
- [ ] **Automated Releases**: Intelligent release planning based on change analysis

## Related Documentation

- [Version Management Guide](../../docs/guides/version-management.md) - Comprehensive version management documentation
- [Change Tracking Guide](../../docs/guides/change-tracking.md) - Detailed change tracking and correlation
- [Evolution Integration](../../docs/guides/evolution-integration.md) - Version management in evolution cycles
- [Release Management](../../docs/guides/release-management.md) - Release planning and execution