# Modular Architecture Migration Guide

This document provides comprehensive guidance for migrating the AI Evolution Engine Seed project to the new modular architecture and using the refactored library system.

## Table of Contents

1. [Overview](#overview)
2. [Architecture Changes](#architecture-changes)
3. [Migration Steps](#migration-steps)
4. [New Module System](#new-module-system)
5. [Updated Scripts](#updated-scripts)
6. [Testing Framework](#testing-framework)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

## Overview

The AI Evolution Engine Seed has been completely refactored to use a modular architecture that provides:

- **Improved Maintainability**: Modular components that can be independently updated and tested
- **Enhanced Reusability**: Library modules that can be installed and used across multiple repositories
- **Better Error Handling**: Comprehensive error handling and validation throughout the system
- **Comprehensive Testing**: Complete test coverage for all modules and functionality
- **Documentation Standards**: Standardized file headers and comprehensive documentation

## Architecture Changes

### Before: Direct Script Dependencies
```bash
# Old approach - direct sourcing
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"
```

### After: Modular Bootstrap System
```bash
# New approach - modular bootstrap
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

require_module "core/logger"
require_module "core/environment"
require_module "evolution/metrics"
```

### New Module Structure

```
src/lib/
├── README.md                    # Comprehensive module documentation
├── core/                        # Core system modules
│   ├── bootstrap.sh            # Module loading and dependency management
│   ├── logger.sh               # Enhanced logging with levels and formatting
│   ├── config.sh               # Configuration management
│   ├── validation.sh           # Input validation and error checking
│   ├── utils.sh                # Common utility functions
│   └── environment.sh          # Environment detection and setup
├── evolution/                   # Evolution and growth modules
│   ├── engine.sh               # Core evolution engine
│   ├── seeds.sh                # Seed generation and management
│   ├── metrics.sh              # Metrics collection and analysis
│   └── git.sh                  # Git operations and version control
├── integration/                 # External service integrations
│   ├── github.sh               # GitHub API and operations
│   └── ci.sh                   # CI/CD pipeline integration
├── analysis/                    # Analysis and health modules
│   └── health.sh               # Repository health analysis
└── template/                    # Template processing modules
    └── engine.sh               # Template engine for code generation
```

## Migration Steps

### 1. Update Script Headers

All scripts now use standardized headers with comprehensive metadata:

```bash
#!/bin/bash

#
# @file scripts/example-script.sh
# @description Brief description of script purpose and functionality
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - #modular-refactor: Migrate to modular architecture
#
# @relatedEvolutions
#   - v2.0.0: Migrated to modular architecture
#   - v1.0.0: Original implementation
#
# @dependencies
#   - ../src/lib/core/bootstrap.sh: Modular bootstrap system
#   - ../src/lib/core/logger.sh: Logging functionality
#
# @changelog
#   - 2025-07-05: Migrated to modular architecture - ITJ
#   - 2025-07-05: Enhanced functionality - ITJ
#
# @usage ./scripts/example-script.sh [arguments]
# @notes Additional important information
#

set -euo pipefail
```

### 2. Replace Direct Sourcing with Bootstrap

**Old Pattern:**
```bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
```

**New Pattern:**
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"

require_module "core/logger"
require_module "core/environment"
```

### 3. Update Function Calls

Many functions have been enhanced or renamed for consistency:

**Updated Function Names:**
- `log_info()` → Enhanced with better formatting
- `validate_argument()` → New validation system
- `metrics_get_current()` → Replaces `load_metrics_data()`
- `health_analyze_repository()` → New health analysis
- `github_create_pr()` → Enhanced GitHub integration

### 4. Use New Validation System

Replace manual validation with the modular validation system:

**Old Pattern:**
```bash
if [[ -z "$EVOLUTION_TYPE" ]]; then
    echo "Error: Evolution type required"
    exit 1
fi
```

**New Pattern:**
```bash
validate_argument "evolution_type" "$EVOLUTION_TYPE" "consistency|maintenance|enhancement|security"
validate_boolean "force_run" "$FORCE_RUN"
validate_file_path "output_file" "$OUTPUT_FILE" "writable"
```

## New Module System

### Core Modules

#### bootstrap.sh
- Module loading and dependency management
- Automatic dependency resolution
- Error handling for missing modules
- Performance optimization for repeated loads

#### logger.sh
- Multiple log levels (DEBUG, INFO, WARN, ERROR, SUCCESS)
- Structured log formatting
- File and console output
- Log rotation and cleanup

#### validation.sh
- Input argument validation
- File path validation
- Boolean value validation
- Custom validation patterns

#### config.sh
- Configuration file management
- Environment variable handling
- Default value management
- Configuration validation

### Evolution Modules

#### engine.sh
- Core evolution logic
- Growth cycle management
- Evolution state tracking
- Integration with metrics and health analysis

#### seeds.sh
- Seed generation and processing
- Template-based seed creation
- Seed validation and testing
- Cross-repository seed distribution

### Integration Modules

#### github.sh
- GitHub API authentication
- Pull request creation and management
- Repository information extraction
- Branch operations
- Error handling for GitHub operations

#### ci.sh
- CI/CD pipeline integration
- Workflow triggering
- Status monitoring
- Artifact management

### Analysis Modules

#### health.sh
- Repository health analysis
- Code quality metrics
- Security issue detection
- Performance analysis
- Recommendation generation

### Template Modules

#### engine.sh
- Template processing and rendering
- Variable substitution
- Template validation
- Template caching
- Include/inheritance support

## Updated Scripts

### Fully Migrated Scripts

1. **evolve.sh** - Main evolution script with modular architecture
2. **generate_seed.sh** - Seed generation using modular templates
3. **create_pr.sh** - GitHub integration using modular GitHub module
4. **analyze-repository-health.sh** - Health analysis using modular health module
5. **collect-context.sh** - Context collection with enhanced capabilities

### Migration Helper Scripts

1. **migrate-to-modular.sh** - Automated migration helper
2. **test-modular-library.sh** - Comprehensive testing framework

### Scripts Pending Migration

Several scripts still need migration to the modular system:
- `run-workflow.sh`
- `version-manager.sh` (partially migrated)
- `plant-new-seeds.sh`
- `update-evolution-metrics.sh`
- And others in the scripts/ directory

## Testing Framework

### New Test Structure

```
tests/
├── lib/                        # Module-specific tests
│   ├── integration/
│   │   ├── test_github.sh
│   │   └── test_ci.sh
│   ├── analysis/
│   │   └── test_health.sh
│   ├── template/
│   │   └── test_engine.sh
│   └── core/
│       ├── test_bootstrap.sh
│       ├── test_logger.sh
│       ├── test_config.sh
│       ├── test_validation.sh
│       └── test_utils.sh
├── run_modular_tests.sh        # Comprehensive test runner
└── coverage/                   # Test coverage reports
```

### Running Tests

```bash
# Run all tests
./tests/run_modular_tests.sh

# Run specific category
./tests/run_modular_tests.sh core

# Run with coverage report
./tests/run_modular_tests.sh all --coverage

# Run with verbose output
./tests/run_modular_tests.sh integration --verbose
```

### Test Categories

- **core**: Test core modules (bootstrap, logger, config, validation, utils)
- **evolution**: Test evolution modules (engine, seeds, metrics, git)
- **integration**: Test integration modules (github, ci)
- **analysis**: Test analysis modules (health)
- **template**: Test template modules (engine)
- **scripts**: Test refactored scripts
- **performance**: Run performance tests
- **security**: Run security tests

## Best Practices

### 1. Module Usage

Always use the bootstrap system:
```bash
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
require_module "core/logger"
require_module "core/validation"
```

### 2. Error Handling

Use modular error handling:
```bash
if ! validate_argument "type" "$TYPE" "valid|values"; then
    log_error "Invalid type: $TYPE"
    exit 1
fi
```

### 3. Logging

Use appropriate log levels:
```bash
log_debug "Detailed debugging information"
log_info "General information"
log_warn "Warning about potential issues"
log_error "Error that prevents continuation"
log_success "Successful operation completion"
```

### 4. Configuration

Use the config module for settings:
```bash
require_module "core/config"
MAX_FILES=$(config_get "evolution.max_context_files" "50")
```

### 5. Testing

Write tests for all new functionality:
```bash
# Create test file following naming convention
touch tests/lib/module/test_new_feature.sh

# Use standard test structure
run_test "Test Name" test_function_name
```

## Troubleshooting

### Common Issues

1. **Module Not Found**
   ```
   Error: Module 'core/logger' not found
   ```
   - Ensure the module file exists in `src/lib/core/logger.sh`
   - Check the require_module path is correct
   - Verify bootstrap.sh is properly sourced

2. **Function Not Available**
   ```
   bash: log_info: command not found
   ```
   - Ensure the module containing the function is loaded
   - Check for typos in function names
   - Verify the module exports the function properly

3. **Validation Failures**
   ```
   Validation failed for argument 'type'
   ```
   - Check the validation pattern matches your input
   - Ensure the argument is properly quoted
   - Use `validate_argument` with correct pattern syntax

### Debug Mode

Enable debug mode for detailed troubleshooting:
```bash
export DEBUG_MODE="true"
export LOG_LEVEL="DEBUG"
./scripts/your-script.sh
```

### Getting Help

1. Check the module documentation in `src/lib/README.md`
2. Run tests to identify issues: `./tests/run_modular_tests.sh`
3. Review the migration helper: `./scripts/migrate-to-modular.sh --help`
4. Check the comprehensive test suite: `./tests/lib/test-modular-library.sh`

## Migration Checklist

- [ ] Update script headers with standardized format
- [ ] Replace direct sourcing with bootstrap system
- [ ] Update function calls to use new module functions
- [ ] Add proper validation using validation module
- [ ] Update error handling to use logger module
- [ ] Create tests for new functionality
- [ ] Update documentation
- [ ] Run comprehensive test suite
- [ ] Verify backward compatibility where needed

## Future Enhancements

The modular architecture enables several future enhancements:

1. **Package Management**: Modules can be packaged and distributed independently
2. **Cross-Repository Usage**: Modules can be installed in other repositories
3. **Version Management**: Independent versioning of modules
4. **Plugin System**: Dynamic loading of additional modules
5. **Performance Optimization**: Lazy loading and caching of modules
6. **Integration Extensions**: Easy addition of new integration modules

---

This migration guide represents a significant evolution in the AI Evolution Engine Seed project, providing a solid foundation for future growth and development.
