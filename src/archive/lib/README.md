<!--
@file src/lib/README.md
@description Modular library structure for AI Evolution Engine
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 2.0.0

@relatedIssues 
  - Refactor scripts to be modular with well-structured library

@relatedEvolutions
  - v2.0.0: Complete modular refactor of script architecture

@dependencies
  - bash: >=4.0
  - jq: >=1.6

@changelog
  - 2025-07-05: Initial creation of modular library structure - ITJ

@usage Source individual modules as needed from scripts
@notes This modular architecture enables reuse across repositories
-->

# 🧬 AI Evolution Engine - Modular Library Architecture

This directory contains the modular library architecture for the AI Evolution Engine, designed to provide reusable, testable, and maintainable components for repository evolution and AI-powered development workflows.

## 📁 Library Structure

```
src/lib/
├── core/                   # Core infrastructure modules
│   ├── bootstrap.sh        # Library initialization and dependency management
│   ├── config.sh          # Configuration management
│   ├── logger.sh          # Logging system
│   ├── environment.sh     # Environment detection and validation
│   ├── testing.sh         # Testing framework
│   ├── validation.sh      # Input/output validation
│   └── utils.sh           # Common utilities
├── evolution/             # Evolution-specific modules
│   ├── engine.sh          # Main evolution engine
│   ├── git.sh            # Git operations
│   ├── metrics.sh        # Metrics collection and analysis
│   └── seeds.sh          # Seed generation and management
├── integration/           # Integration and deployment modules
│   ├── github.sh         # GitHub API and workflow integration
│   └── ci.sh             # CI/CD integration and workflow management
├── analysis/              # Analysis and reporting modules
│   └── health.sh         # Repository health analysis and reporting
├── template/              # Template processing modules
│   └── engine.sh         # Template processing and generation engine
│   ├── docker.sh         # Container operations
│   ├── ci-cd.sh          # CI/CD pipeline management
│   └── deployment.sh     # Deployment strategies
├── analysis/              # Analysis and reporting modules
│   ├── repository.sh     # Repository analysis
│   ├── code-quality.sh   # Code quality assessment
│   ├── security.sh       # Security scanning and validation
│   └── performance.sh    # Performance analysis
└── templates/             # Template generation modules
    ├── README.sh          # README.md generation
    ├── workflows.sh       # GitHub Actions workflow generation
    └── documentation.sh   # Documentation generation
```

## 🚀 Usage Patterns

### Basic Library Import
```bash
#!/bin/bash
# Import the bootstrap module to initialize the library system
source "$(dirname "${BASH_SOURCE[0]}")/../src/lib/core/bootstrap.sh"

# Bootstrap will handle loading core dependencies
bootstrap_library

# Load specific modules as needed
load_module "evolution/engine"
load_module "integration/github"
```

### Error Handling
All modules follow consistent error handling patterns:
```bash
# Functions return 0 for success, non-zero for failure
if ! some_library_function; then
    log_error "Operation failed"
    exit 1
fi
```

### Configuration Management
```bash
# Load configuration with defaults
load_config "evolution.yml" || create_default_config

# Access configuration values
EVOLUTION_TYPE=$(get_config "evolution.type" "consistency")
```

## 🔧 Module Standards

### Function Naming Conventions
- Public functions: `module_function_name`
- Private functions: `_module_function_name`
- Constants: `MODULE_CONSTANT_NAME`

### Documentation Standards
Each function must include:
```bash
# Brief description of function purpose
# Args:
#   $1: parameter description
#   $2: optional parameter (default: value)
# Returns:
#   0: success
#   1: failure
# Examples:
#   function_name "arg1" "arg2"
function_name() {
    # Implementation
}
```

### Testing Requirements
- All public functions must have unit tests
- Tests located in `tests/lib/` directory
- Use the testing framework from `core/testing.sh`

## 🌱 Evolution Integration

This modular architecture supports:
- **Cross-repository deployment**: Library can be installed in any repository
- **Incremental adoption**: Modules can be used independently
- **AI-powered enhancement**: Modules provide hooks for AI interaction
- **Version management**: Each module tracks its own version and dependencies

## 📦 Installation

The library can be installed in any repository using:
```bash
# Option 1: Direct installation script
curl -fsSL https://raw.githubusercontent.com/your-org/ai-evolution-engine-seed/main/install.sh | bash

# Option 2: Git submodule
git submodule add https://github.com/your-org/ai-evolution-engine-seed.git ai-evolution

# Option 3: Download and extract
wget -O - https://github.com/your-org/ai-evolution-engine-seed/archive/main.tar.gz | tar -xz
```

## 🧪 Testing

Run the complete test suite:
```bash
# Run all library tests
./src/lib/core/testing.sh --run-all

# Run specific module tests
./src/lib/core/testing.sh --module evolution/engine

# Run integration tests
./src/lib/core/testing.sh --integration
```

## 📈 Metrics and Monitoring

The library includes comprehensive metrics collection:
- Function call tracking
- Performance monitoring
- Error rate analysis
- Usage pattern identification

Access metrics through:
```bash
# View current metrics
./scripts/show-metrics.sh

# Generate metrics report
./scripts/generate-metrics-report.sh
```
