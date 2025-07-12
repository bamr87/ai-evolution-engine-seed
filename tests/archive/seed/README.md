<!--
@file tests/seed/README.md
@description Documentation for seed testing directory
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-06
@lastModified 2025-07-06
@version 1.0.0

@relatedIssues 
  - Seed testing organization and documentation

@relatedEvolutions
  - v1.0.0: Initial creation during test reorganization

@dependencies
  - Evolution engine seed generation

@changelog
  - 2025-07-06: Initial creation - ITJ

@usage Reference documentation for seed testing tools
@notes Centralized location for all seed-related tests
-->

# Seed Testing Directory

This directory contains all testing tools and scripts related to seed functionality and evolution engine testing.

## Purpose

The `tests/seed/` directory provides comprehensive testing capabilities for:

- Seed generation and validation
- Evolution cycle testing
- Seed planting and growth simulation
- Cross-generational seed testing
- Seed functionality verification

## Files Overview

### Core Testing Scripts

| File | Purpose | Usage |
|------|---------|-------|
| `test-evolved-seed.sh` | Tests evolved seed functionality | `./test-evolved-seed.sh [GROWTH_MODE]` |

## Key Features

### test-evolved-seed.sh

- **Seed Initialization Testing**: Validates seed setup processes
- **Growth Mode Simulation**: Tests different growth modes
- **Test Automation**: Runs generated tests from seeds
- **Build Process Validation**: Tests seed build processes
- **Environment Cleanup**: Manages test environments

## Usage Examples

### Basic Seed Testing

```bash
# Test evolved seed with default growth mode
./tests/seed/test-evolved-seed.sh

# Test with specific growth mode
./tests/seed/test-evolved-seed.sh test-automation
```

### Advanced Seed Testing

```bash
# Test all growth modes
for mode in conservative adaptive experimental; do
    ./tests/seed/test-evolved-seed.sh $mode
done
```

## Dependencies

### Required Tools

- **bash** >=4.0: Shell execution environment
- **src/lib/core/logger.sh**: Logging functionality
- **src/lib/utils/env_detect.sh**: Environment detection

### Optional Dependencies

- Various testing frameworks depending on seed type
- Build tools for specific project types
- Container runtimes for containerized seeds

## Integration with Evolution Engine

### Seed Lifecycle Testing

- **Pre-Generation**: Validate seed templates
- **Post-Generation**: Test generated seed functionality
- **Growth Simulation**: Test seed development over time
- **Cross-Generation**: Validate seed inheritance

### Quality Assurance

- **Functionality Testing**: Ensure seeds work as expected
- **Regression Testing**: Verify seeds maintain compatibility
- **Performance Testing**: Monitor seed generation performance
- **Integration Testing**: Test seeds in realistic environments

## Best Practices

### Seed Testing

1. **Test all growth modes** for comprehensive coverage
2. **Use isolated environments** for each test
3. **Clean up test artifacts** after completion
4. **Validate expected outputs** against requirements

### Test Development

1. **Follow established patterns** from existing tests
2. **Include comprehensive error handling**
3. **Document test purposes and expected outcomes**
4. **Add logging for debugging and monitoring

## Contributing

When adding new seed tests:

1. Follow the established file header format
2. Include comprehensive error handling
3. Add usage examples and documentation
4. Test thoroughly with various growth modes
5. Update this README with new capabilities

## Related Documentation

- [Evolution Engine Documentation](../../docs/EVOLUTION_ENGINE.md)
- [Seed Development Guide](../../docs/SEED_DEVELOPMENT.md)
- [Testing Strategy](../README.md)
- [Growth Modes Documentation](../../docs/GROWTH_MODES.md)
