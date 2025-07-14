<!--
@file scripts/core/README.md
@description Core evolution scripts and orchestration tools
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories
  - #core-evolution-scripts: Central orchestration and core functionality

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0 for script execution
  - Core library system: src/lib/core/ modules
  - Git: for version control operations

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Core evolution orchestration and fundamental operation scripts
@notes Contains the primary scripts that drive evolution cycles and core functionality
-->

# Core Evolution Scripts

This directory contains the core evolution scripts that orchestrate AI-driven evolution cycles and provide fundamental operations for the AI Evolution Engine.

## Purpose

The core scripts directory provides:
- **Evolution Orchestration**: Main scripts that coordinate evolution cycles
- **Local Development**: Tools for local evolution testing and development
- **Growth Simulation**: AI growth simulation and response generation
- **Change Application**: Safe application of evolutionary changes
- **Environment Setup**: Core environment preparation and validation

## Scripts Overview

### Primary Evolution Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `evolve.sh` | Main evolution cycle orchestrator | `./evolve.sh [options]` |
| `local-evolution.sh` | Local development evolution runner | `./local-evolution.sh -p "prompt"` |
| `modular-evolution.sh` | Modular architecture evolution script | `./modular-evolution.sh [command]` |

### Simulation and Processing

| Script | Purpose | Usage |
|--------|---------|-------|
| `simulate-ai-growth.sh` | AI growth simulation engine | `./simulate-ai-growth.sh [prompt] [mode]` |
| `apply-growth-changes.sh` | Apply evolutionary changes safely | `./apply-growth-changes.sh [changes-file]` |

### Infrastructure

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-environment.sh` | Environment setup and validation | `./setup-environment.sh [mode]` |
| `create_pr.sh` | Pull request creation automation | `./create_pr.sh [branch] [title]` |
| `run-workflow.sh` | Manual workflow execution | `./run-workflow.sh [workflow] [inputs]` |

## Key Features

### Evolution Orchestration

**Comprehensive Evolution Cycle Management:**
- Multi-mode evolution support (conservative, adaptive, experimental)
- Dry-run capabilities for safe testing
- Rollback and recovery mechanisms
- Progress tracking and logging

**Integration Points:**
- GitHub Actions workflow integration
- Local development environment support
- CI/CD pipeline compatibility
- Cross-platform execution support

### Safety and Validation

**Change Validation:**
- Pre-application change analysis
- Syntax validation for code changes
- Dependency checking and validation
- Rollback preparation and execution

**Error Handling:**
- Comprehensive error detection
- Graceful failure recovery
- Detailed error logging
- Human-readable error messages

## Usage Examples

### Basic Evolution Cycle

```bash
# Run default evolution cycle
./core/evolve.sh

# Custom evolution with specific prompt
./core/evolve.sh --type custom --prompt "Improve error handling"

# Conservative evolution with dry-run
./core/evolve.sh --type consistency --intensity minimal --dry-run
```

### Local Development

```bash
# Local evolution with custom prompt
./core/local-evolution.sh -p "Add user authentication" -m adaptive

# Verbose local evolution
./core/local-evolution.sh -p "Optimize performance" -v -d

# Test environment setup
./core/setup-environment.sh test
```

### Advanced Operations

```bash
# Modular evolution with specific target
./core/modular-evolution.sh evolve -t documentation -i moderate

# Simulate changes without applying
./core/modular-evolution.sh simulate -p "Add new feature"

# Manual workflow execution
./core/run-workflow.sh ai_evolver.yml '{"prompt": "test", "growth_mode": "conservative"}'
```

## Integration with Evolution Engine

The core scripts integrate with:
- [Core Library System](../../src/lib/README.md) - Shared functionality and utilities
- [Testing Framework](../../tests/README.md) - Validation and quality assurance
- [GitHub Workflows](../../.github/workflows/README.md) - Automated execution
- [Analysis Scripts](../analysis/README.md) - Health analysis and metrics

## Dependencies

### Required Tools
- **bash** >=4.0: Shell execution environment
- **git**: Version control operations
- **jq**: JSON processing and manipulation
- **curl**: HTTP requests for API integration

### Optional Dependencies
- **gh**: GitHub CLI for enhanced workflow management
- **docker**: Container runtime for isolated execution
- **act**: Local GitHub Actions testing

## Best Practices

### Script Execution
1. **Always test locally** before pushing changes
2. **Use dry-run mode** for initial testing
3. **Monitor logs** for execution details
4. **Validate changes** before applying

### Error Handling
1. **Check prerequisites** before execution
2. **Use proper error codes** for automation
3. **Log errors comprehensively** for debugging
4. **Provide recovery suggestions** in error messages

## Future Enhancements

- [ ] **Enhanced AI Integration**: Direct AI model integration for real-time evolution
- [ ] **Multi-Repository Support**: Coordinated evolution across multiple repositories
- [ ] **Advanced Validation**: Machine learning-powered change validation
- [ ] **Performance Optimization**: Parallel execution and caching improvements
- [ ] **User Interface**: Web-based interface for evolution management
- [ ] **Plugin System**: Extensible architecture for custom evolution strategies

## Related Documentation

- [Evolution Engine Overview](../../README.md) - Main project documentation
- [Modular Architecture Guide](../../docs/architecture/MODULAR_ARCHITECTURE.md) - Technical architecture
- [Local Development Guide](../../docs/guides/local-development.md) - Development workflows
- [Troubleshooting Guide](../../docs/guides/troubleshooting.md) - Common issues and solutions