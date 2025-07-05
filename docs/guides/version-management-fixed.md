<!--
@file docs/guides/version-management.md
@description Comprehensive guide for the AI Evolution Engine version management system
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 1.0.0

@relatedIssues 
  - #auto-version-management: Comprehensive version tracking and management

@relatedEvolutions
  - v0.4.0: Version management system implementation

@dependencies
  - scripts/version-manager.sh: Main version management script
  - scripts/version-integration.sh: Workflow integration helper

@changelog
  - 2025-07-05: Initial creation with comprehensive documentation - ITJ

@usage Referenced by developers and automation systems for version management
@notes Provides complete guide for understanding and using the version management system
-->

# 🔢 AI Evolution Engine Version Management System

## Overview

The AI Evolution Engine includes a comprehensive version management system that automatically tracks and updates version references across all files in the repository. This ensures consistent versioning as the repository evolves through AI-powered development cycles.

## 🎯 Key Features

### Automatic Version Tracking

- **File-Level Tracking**: Monitors individual files for changes since last version update
- **Pattern-Based Updates**: Uses configurable patterns to find and update version references  
- **Cross-Platform Support**: Works on macOS, Linux, and Windows environments
- **Git Integration**: Leverages git history to determine when files need version updates

### Intelligent Versioning

- **Semantic Versioning**: Follows semver principles (MAJOR.MINOR.PATCH)
- **Change-Based Increments**: Automatically determines increment type based on change scope
- **Evolution-Aware**: Special handling for AI evolution cycles
- **Manual Override**: Supports manual version management when needed

### Comprehensive File Coverage

- **Core Files**: README.md, init_setup.sh, workflow files, seed files
- **Documentation**: All documentation files with version references
- **Scripts**: Automatic detection and updating of script headers
- **Expandable**: Easy to add new file types and patterns

## 📁 System Components

### Configuration File: `.version-config.json`

Central configuration that defines:

- Current version
- Tracked files and their patterns
- Version history
- File tracking settings

### Main Script: `scripts/version-manager.sh`

Core version management functionality:

- Version increment logic
- File pattern matching and updating
- Git integration for change detection
- Changelog management

### Integration Helper: `scripts/version-integration.sh`

Workflow integration utilities:

- Simple interface for automation
- Evolution cycle handling
- Manual change processing
- Status reporting

## 🚀 Usage Guide

### Basic Operations

#### Check Current Status

```bash
./scripts/version-manager.sh check-status
```

Shows current version and file status.

#### Increment Version

```bash
# Patch increment (default)
./scripts/version-manager.sh increment

# Minor increment
./scripts/version-manager.sh increment minor

# Major increment
./scripts/version-manager.sh increment major

# With description
./scripts/version-manager.sh increment patch "Fixed authentication bug"
```

#### Update All Files

```bash
# Update all files to current version
./scripts/version-manager.sh update-all

# Dry run to preview changes
./scripts/version-manager.sh update-all --dry-run
```

#### Scan for Updates Needed

```bash
./scripts/version-manager.sh scan-files
```

### Evolution Integration

#### For AI Evolution Cycles

```bash
# Automatic evolution versioning
./scripts/version-integration.sh evolution "Added new AI features"

# Using the main script
./scripts/version-manager.sh evolution
```

#### For Manual Changes

```bash
# Integrate with manual changes
./scripts/version-integration.sh integrate manual "Updated documentation" patch

# Force version update
./scripts/version-integration.sh integrate force "Emergency fix" patch
```

### Advanced Usage

#### Dry Run Testing

```bash
# Test any operation without making changes
./scripts/version-manager.sh increment minor --dry-run
./scripts/version-integration.sh evolution "Test changes" true
```

#### Custom Descriptions

```bash
# Provide custom evolution descriptions
./scripts/version-manager.sh increment patch "Improved error handling in authentication module"
```

## 🔧 Configuration Details

### File Tracking Patterns

The system uses pattern-based matching to find version references in files:

#### Pattern Types

- **ascii_art**: Version in ASCII art headers
- **badge**: GitHub badge version references
- **marker_section**: AI evolution markers
- **header_version**: Script header versions
- **variable**: Variable assignments
- **workflow_name**: GitHub workflow names

#### Example Configuration

```json
{
  "path": "README.md",
  "patterns": [
    {
      "type": "ascii_art", 
      "pattern": "v[0-9]+\\.[0-9]+\\.[0-9]+(-seed)?",
      "line_context": "AI EVOLUTION ENGINE"
    },
    {
      "type": "badge",
      "pattern": "version-[0-9]+\\.[0-9]+\\.[0-9]+(--seed)?", 
      "line_context": "[![Version]"
    }
  ],
  "last_modified_version": "0.3.2"
}
```

### Adding New Files

To track version references in new files:

1. Add file configuration to `.version-config.json`
2. Define appropriate patterns for version references
3. Set initial `last_modified_version`
4. Run `./scripts/version-manager.sh scan-files` to verify

#### Example: Adding a New Script

```json
{
  "path": "scripts/new-script.sh",
  "patterns": [
    {
      "type": "header_version",
      "pattern": "# Version: [0-9]+\\.[0-9]+\\.[0-9]+",
      "line_context": "# Version:"
    }
  ],
  "last_modified_version": "0.4.0"
}
```

## 🔄 Integration with AI Evolution

### Automatic Integration

The version management system integrates seamlessly with AI evolution cycles:

1. **Pre-Evolution**: Check current version status
2. **During Evolution**: Track which files are being modified
3. **Post-Evolution**: Automatically increment version and update all references
4. **Changelog Update**: Add evolution details to CHANGELOG.md

### GitHub Actions Integration

Add to your workflow:

```yaml
- name: Manage Version for Evolution
  run: |
    ./scripts/version-integration.sh evolution "AI evolution cycle: ${{ github.event.inputs.prompt }}"
    
- name: Commit Version Updates
  run: |
    git add .
    git commit -m "chore: version update for evolution cycle" || exit 0
```

## 📊 Version History Tracking

The system maintains comprehensive version history:

### Automatic History

- Version number
- Date of change
- Type of increment (major/minor/patch)
- Description of changes

### File-Level Tracking

- Last version when each file was modified
- Git hash tracking for change detection
- Modification timestamp tracking

## 🛠️ Troubleshooting

### Common Issues

#### Version References Not Found

```bash
# Check pattern configuration
./scripts/version-manager.sh scan-files

# Verify file patterns match actual content
grep -n "v[0-9]\+\.[0-9]\+\.[0-9]\+" README.md
```

#### Files Not Being Updated

```bash
# Force update all files
./scripts/version-manager.sh update-all --force

# Check git status
git status --porcelain
```

#### Pattern Matching Issues

```bash
# Test patterns manually
grep -E "v[0-9]+\.[0-9]+\.[0-9]+(-seed)?" README.md

# Validate JSON configuration
jq empty .version-config.json
```

### Debug Mode

Enable verbose logging:

```bash
# Set debug environment
export DEBUG=true

# Run with maximum verbosity
./scripts/version-manager.sh check-status
```

## 🔐 Best Practices

### Version Increment Guidelines

1. **Patch Increments**: Bug fixes, documentation updates, small improvements
2. **Minor Increments**: New features, significant enhancements, API additions
3. **Major Increments**: Breaking changes, major architecture changes, API breaking changes

### Evolution Cycle Versioning

1. **Standard Evolution**: Use patch increments for regular AI cycles
2. **Feature Evolution**: Use minor increments when adding significant new capabilities
3. **Architecture Evolution**: Use major increments for fundamental changes

### File Management

1. **Consistent Patterns**: Use standardized version reference patterns across files
2. **Documentation**: Always include version information in file headers
3. **Backup Strategy**: The system creates backups before making changes

## 🚦 Status Indicators

The version management system provides clear status indicators:

- **UP_TO_DATE**: File version matches current repository version
- **NEEDS_UPDATE**: File version is behind current repository version
- **NOT_FOUND**: File doesn't exist (expected for optional files)
- **MODIFIED**: File has been changed and needs version update

## 🔮 Future Enhancements

The version management system is designed for extensibility:

### Planned Features

- **Automatic Changelog Generation**: Enhanced changelog creation from git history
- **Release Automation**: Integration with GitHub releases
- **Dependency Tracking**: Track version dependencies between files
- **Rollback Capabilities**: Ability to revert version changes

### Integration Possibilities

- **CI/CD Pipelines**: Enhanced integration with deployment workflows
- **Package Managers**: Integration with npm, gem, and other package systems
- **Documentation Sites**: Automatic version updates in documentation websites

## 📚 Related Documentation

- [Daily Evolution Guide](../evolution/DAILY_EVOLUTION.md) - How version management integrates with evolution cycles
- [Workflow Documentation](../workflows/) - GitHub Actions integration details
- [Architecture Guide](../architecture/) - Technical implementation details

---

*Last updated: July 5, 2025 - Version 1.0.0*
*Part of the AI Evolution Engine v0.4.0 evolution cycle*
