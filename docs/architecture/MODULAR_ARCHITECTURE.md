# AI Evolution Engine - Modular Architecture Guide

## Overview

This document describes the modular architecture implemented for the AI Evolution Engine shell scripts. The refactoring introduces a library-based system that promotes code reusability, maintainability, and testability while following the core principles of **DRY** (Don't Repeat Yourself), **DFF** (Design for Failure), and **KIS** (Keep It Simple).

## Architecture Structure

```
src/
├── lib/
│   ├── core/                    # Core foundational libraries
│   │   ├── logger.sh           # Unified logging system
│   │   ├── environment.sh      # Environment detection & validation
│   │   └── testing.sh          # Testing framework utilities
│   └── evolution/              # Evolution-specific libraries
│       ├── git.sh              # Git operations and branch management
│       └── metrics.sh          # Metrics collection and analysis
├── evolution-engine.sh         # Main orchestration script
└── README.md                   # Source architecture documentation

scripts/                        # Legacy and refactored scripts
├── evolve.sh                   # ✅ Refactored (uses modular libs)
├── check-prereqs.sh           # ✅ Refactored (uses modular libs)
├── collect-context.sh         # ✅ Refactored (uses modular libs)
├── test-workflow.sh           # ✅ Refactored (uses modular libs)
└── ...                        # 🔄 Additional scripts (to be refactored)

tests/
├── modular-architecture-test.sh    # Modular architecture validation
├── comprehensive-refactoring-test.sh # Script refactoring validation
└── ...                              # Additional test suites
```

## Core Libraries

### 1. Logger Library (`src/lib/core/logger.sh`)

**Purpose**: Provides consistent, configurable logging across all scripts.

**Key Features**:
- Multi-level logging (DEBUG, INFO, WARN, ERROR, SUCCESS)
- CI/CD environment detection with appropriate formatting
- File logging with rotation
- Colored output for local development
- Silent mode support

**Usage Example**:
```bash
source "$PROJECT_ROOT/src/lib/core/logger.sh"
init_logger "logs" "my-script"

log_info "Starting process..."
log_warn "This is a warning"
log_error "An error occurred"
log_success "Process completed successfully"
```

### 2. Environment Library (`src/lib/core/environment.sh`)

**Purpose**: Handles environment detection, validation, and setup.

**Key Features**:
- Operating system detection (Linux, macOS, Windows)
- CI/CD environment configuration
- Command availability checking
- Tool version validation
- Environment-specific color and symbol configuration

**Usage Example**:
```bash
source "$PROJECT_ROOT/src/lib/core/environment.sh"
init_environment_config

if check_command "git" "Git" true "Install from https://git-scm.com"; then
    log_success "Git is available"
fi

OS=$(detect_os)
log_info "Running on: $OS"
```

### 3. Testing Library (`src/lib/core/testing.sh`)

**Purpose**: Comprehensive testing framework with AI-powered insights.

**Key Features**:
- Test suite organization and execution
- Assertion utilities (equal, file_exists, command_succeeds)
- JSON and Markdown test reporting
- Test discovery and automated execution
- Performance tracking and timeout handling

**Usage Example**:
```bash
source "$PROJECT_ROOT/src/lib/core/testing.sh"
init_testing "my-test-session"

start_test_suite "functionality_tests"
run_test "File exists" "test -f '$MY_FILE'"
assert_equal "$(echo 'test')" "test" "String comparison"
end_test_suite

finalize_testing
```

### 4. Git Library (`src/lib/evolution/git.sh`)

**Purpose**: Git operations specifically for evolution workflows.

**Key Features**:
- Repository state detection and validation
- Branch management for evolution cycles
- Commit and push operations with standardized messages
- Merge conflict detection and resolution guidance
- Evolution-specific git workflows

**Usage Example**:
```bash
source "$PROJECT_ROOT/src/lib/evolution/git.sh"

if is_git_repository; then
    create_evolution_branch "feature-enhancement"
    commit_evolution_changes "Add new modular architecture"
fi
```

### 5. Metrics Library (`src/lib/evolution/metrics.sh`)

**Purpose**: Evolution metrics collection, analysis, and reporting.

**Key Features**:
- Metrics data loading and validation
- Evolution cycle tracking
- Performance trend analysis
- Metrics backup and restore
- JSON-based metrics persistence

**Usage Example**:
```bash
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

METRICS=$(load_metrics_data)
update_evolution_cycle_count 1
record_evolution_event "modular-refactoring" "major"
```

## Migration Guide

### Converting Existing Scripts

Follow these steps to migrate legacy scripts to the modular architecture:

1. **Add modular imports**:
```bash
# Get script directory for relative imports
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Import required libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
# Add other libraries as needed
```

2. **Initialize libraries**:
```bash
# Initialize environment and logging
init_environment_config
init_logger "logs" "script-name"
```

3. **Replace inline functions with library calls**:
```bash
# Old approach
echo -e "${GREEN}[SUCCESS]${NC} Operation completed"

# New modular approach
log_success "Operation completed"
```

4. **Validate the migration**:
```bash
# Test syntax
bash -n scripts/your-script.sh

# Run refactoring validation
./tests/comprehensive-refactoring-test.sh
```

### Refactoring Progress

| Script | Status | Libraries Used | Notes |
|--------|--------|----------------|-------|
| `evolve.sh` | ✅ Complete | logger, environment, git, metrics | Full modular integration |
| `check-prereqs.sh` | ✅ Complete | logger, environment | Environment detection |
| `collect-context.sh` | ✅ Complete | logger, environment, metrics | Metrics integration |
| `test-workflow.sh` | ✅ Complete | logger, environment, testing | Testing framework |
| `analyze-repository-health.sh` | 🔄 Pending | - | Scheduled for next iteration |
| `local-evolution.sh` | 🔄 Pending | - | Complex script requiring careful migration |
| ... | 🔄 Pending | - | Additional scripts to follow |

## Testing and Validation

### Automated Testing

The modular architecture includes comprehensive testing:

1. **Modular Architecture Test**: `./tests/modular-architecture-test.sh`
   - Validates library structure and functionality
   - Tests integration between libraries
   - Ensures backward compatibility

2. **Comprehensive Refactoring Test**: `./tests/comprehensive-refactoring-test.sh`
   - Validates script functionality after refactoring
   - Tests modular library integration
   - Checks backward compatibility with workflows

3. **Continuous Integration**: Tests run automatically in CI/CD pipelines

### Running Tests

```bash
# Test modular architecture
./tests/modular-architecture-test.sh

# Test refactoring progress
./tests/comprehensive-refactoring-test.sh

# Run all tests
./tests/run_tests.sh run all
```

## Benefits of Modular Architecture

### 1. **Code Reusability**
- Common functionality shared across scripts
- Reduced code duplication
- Consistent behavior patterns

### 2. **Maintainability**
- Centralized library updates affect all dependent scripts
- Clear separation of concerns
- Easier debugging and troubleshooting

### 3. **Testability**
- Individual library testing
- Mocked dependencies for unit tests
- Comprehensive integration testing

### 4. **Scalability**
- Easy addition of new functionality
- Modular expansion of capabilities
- Clear extension points

### 5. **AI Agent Integration**
- Standardized interfaces for AI analysis
- Consistent logging for AI learning
- Structured data collection for AI insights

## Best Practices

### 1. **Library Development**
- Each library should have a single, clear responsibility
- Include comprehensive error handling
- Provide both synchronous and asynchronous options where applicable
- Document all public functions

### 2. **Script Migration**
- Migrate incrementally, one script at a time
- Maintain backward compatibility during transition
- Test thoroughly after each migration
- Update documentation simultaneously

### 3. **Testing Integration**
- Write tests before migrating scripts
- Validate both functionality and integration
- Include performance benchmarks
- Test in multiple environments (local, CI/CD)

### 4. **Documentation**
- Keep this guide updated as architecture evolves
- Document any breaking changes
- Include migration examples
- Provide troubleshooting guides

## Future Enhancements

### Planned Improvements

1. **Additional Libraries**:
   - `notification.sh` - Unified notification system
   - `config.sh` - Configuration management
   - `security.sh` - Security validation and encryption

2. **Enhanced Testing**:
   - Performance benchmarking
   - Security testing integration
   - AI-powered test generation

3. **AI Integration**:
   - Automated script analysis and suggestions
   - Intelligent error recovery
   - Predictive maintenance recommendations

### Contributing

When adding new libraries or migrating scripts:

1. Follow the established patterns in existing libraries
2. Include comprehensive tests
3. Update this documentation
4. Ensure CI/CD pipeline compatibility
5. Validate with the refactoring test suite

## Troubleshooting

### Common Issues

1. **Import Path Errors**:
   ```bash
   # Ensure correct relative paths
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
   ```

2. **Color Variable Conflicts**:
   ```bash
   # Libraries handle variable initialization gracefully
   # Avoid redefining readonly variables
   ```

3. **CI/CD Environment Issues**:
   ```bash
   # Use init_environment_config to handle CI detection
   init_environment_config
   ```

For additional help, run the diagnostic tests or consult the test reports in `test-reports/`.

---

**Version**: 2.0.0 - Modular Architecture  
**Last Updated**: 2025-07-05  
**Next Review**: After completing script migration phase
