# 🌱 AI Evolution Engine: The Self-Growing Repository 🌱

## 🌟 NEW: Enhanced AI Evolution Workflow (v0.4.1)

**Latest Update**: The AI Evolution Engine has been upgraded with a completely modernized workflow system!

### ✨ Revolutionary Workflow Improvements
- **🔧 Enhanced Growth Modes**: Added `test-automation` mode for dedicated testing workflows
- **� Advanced Version Management**: Pre and post-processing with intelligent change correlation
- **🧪 Comprehensive Testing Integration**: Automated validation and component testing
- **🏷️ Evolution Cycle Tracking**: Detailed tracking with enhanced metrics and reporting
- **� Streamlined Architecture**: Complete restructure for better organization and reliability
- **�️ Enhanced Safety**: Improved error handling and validation at every stage
- **� Better Analytics**: Enhanced logging and tracking throughout evolution processes
- **🌱 Intelligent Seed Management**: Enhanced generation with better metadata and integration

### 🎯 Growth Mode Options
- **`conservative`**: Safe, minimal changes with thorough validation
- **`adaptive`**: Balanced approach with moderate changes (default)
- **`experimental`**: Advanced features and experimental changes
- **`test-automation`**: 🆕 Focus on testing infrastructure and automation

### 🏗️ Modular Architecture Overview

The repository features a sophisticated modular architecture that serves as the foundation for AI-powered development workflows:

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
├── workflow/              # Workflow management modules
│   └── management.sh     # GitHub workflow operations
├── analysis/              # Analysis and reporting modules
│   └── health.sh         # Repository health analysis and reporting
├── utils/                 # Utility modules
│   ├── json_processor.sh # JSON processing and manipulation
│   └── file_operations.sh # File operations and content processing
└── template/              # Template processing modules
    └── engine.sh         # Template processing and generation engine
```

### 🚀 Quick Start with Enhanced Evolution System

```bash
# Use the new unified modular interface
./scripts/modular-evolution.sh help

# Run comprehensive health analysis
./scripts/modular-evolution.sh analyze -v

# Test the entire modular system
./tests/comprehensive-modular-test.sh

# Perform evolution with full modular features
./scripts/modular-evolution.sh evolve -t consistency -i moderate -v

# Simulate evolution changes without applying
./scripts/modular-evolution.sh simulate -p "Improve error handling" -d

# Manage GitHub workflows
./scripts/modular-evolution.sh workflows
```

### 🧪 Comprehensive Testing

The modular system includes extensive testing capabilities:

```bash
# Run all tests
./tests/comprehensive-modular-test.sh

# Test specific categories
./tests/comprehensive-modular-test.sh core
./tests/comprehensive-modular-test.sh evolution
./tests/comprehensive-modular-test.sh utilities

# View test results and reports
ls tests/results/
ls tests/logs/
```

### Migration Guide
See [docs/MODULAR_MIGRATION_GUIDE.md](docs/MODULAR_MIGRATION_GUIDE.md) for complete migration instructions and best practices.

```
╔═══════════════════════════════════════════════════════════════╗
║                   AI EVOLUTION ENGINE                         ║
║         Where Seeds Grow Into Intelligent Software            ║
║                      v0.4.0-modular                           ║
╚═══════════════════════════════════════════════════════════════╝
```

[![Version](https://img.shields.io/badge/version-0.3.6--seed-blue.svg)](https://github.com/bamr87/ai-evolution-engine)
![Evolution Status](https://img.shields.io/badge/status-documentation--organized-green.svg)
![Growth Potential](https://img.shields.io/badge/potential-universal-purple.svg)

> 🌱 **Now with organized documentation! All docs properly structured in `/docs` following best practices for maintainable repositories.**

This repository is a living experiment in AI-driven software evolution. It's designed to adapt, learn, and improve itself with each "growth cycle," guided by your prompts and an AI engine.

## 🌿 Core Philosophy: Digital Symbiosis

We believe in software that grows organically, much like a plant from a seed. This involves:
- **Sustainability**: Each evolution builds upon stable foundations.
- **Adaptability**: The system learns and refines its growth patterns.
- **Acceleration**: AI handles boilerplate and complex transformations, letting humans focus on vision.

## 📚 Documentation Structure

Following our **Documentation Organization Rule**, all documentation resides in the `docs/` directory:

### Core Documentation (Repository Root)

- `README.md` - This file (main project documentation)
- `CHANGELOG.md` - Version history and change tracking

### Organized Documentation (`docs/`)

- `docs/guides/` - User guides and tutorials
- `docs/architecture/` - Technical architecture and design decisions
- `docs/evolution/` - Evolution cycle documentation and metrics
- `docs/workflows/` - CI/CD and automation documentation
- `docs/seeds/` - Seed templates and evolution prompts

**Key Benefits:**

- **Consistency**: Standardized location for all documentation
- **Maintainability**: Easy to find and update documentation
- **Scalability**: Clear structure supports growing documentation needs
- **Collaboration**: Team members always know where to find docs

## 🌍 Cross-Platform Evolution (New in v0.3.6-seed!)

The AI Evolution Engine now runs everywhere with full cross-platform support:

### 🏠 Local Development
- **Native execution** on macOS, Linux, and Windows
- **Automatic dependency management** with OS-specific package managers
- **Interactive local runner** with `./scripts/local-evolution.sh`

### 🐳 Containerized Environment
- **Docker support** for isolated, reproducible environments
- **Pre-built container** with all dependencies included
- **Volume mounting** for seamless local development integration

### ☁️ CI/CD Ready
- **GitHub Actions** with enhanced authentication handling
- **Multiple token strategies** (PAT_TOKEN, GITHUB_TOKEN)
- **Container option** for pipeline isolation

**Quick Start Options:**
```bash
# Local development (native)
./scripts/local-evolution.sh -p "Your evolution prompt"

# Container development
docker-compose -f docker/docker-compose.yml run evolution-engine \
  ./scripts/local-evolution.sh -p "Your prompt"

# CI/CD (GitHub Actions)
# Use the workflow_dispatch trigger in GitHub
```

➡️ **[Cross-Platform Setup Guide](CROSS_PLATFORM_UPDATE.md)**

## 📁 Repository Structure

The repository is now organized following software engineering best practices:

```text
📁 Root Files               # Core seed components
├── 📁 docs/               # Comprehensive documentation 
├── 📁 tests/              # Testing framework (unit & integration)
├── 📁 scripts/            # Automation utilities
├── 📁 templates/          # Reusable project templates
├── 📁 src/                # Source code
└── 📁 prompts/            # AI prompts and instructions
```

For detailed structure information, see [`docs/ORGANIZATION.md`](docs/ORGANIZATION.md).

## 🧬 Seed Anatomy (v0.3.6-seed)

1. **`README.md` (This file)**: A dynamic chronicle of the repository's evolution. The section below is updated by the AI.
    <!-- AI-EVOLUTION-MARKER:START -->
    **Evolutionary State:**
    - Generation: 0.3.6.5.4.3 (Cross-Platform Evolution)
    - Adaptations Logged: 12 major enhancement categories implemented
    - Last Growth Spurt: 2025-07-04 (comprehensive cross-platform compatibility)
    - Last Prompt: Enhanced cross-platform compatibility with containerization and local development support
    - Cross-Platform Support: Universal (macOS, Linux, Windows, Container)
    - Authentication Handling: Multi-strategy (PAT_TOKEN, GITHUB_TOKEN, local gh auth)
    - Container Ready: Full Docker support with isolated execution
    - Local Development: Enhanced CLI with ./scripts/local-evolution.sh
    - CI/CD Integration: Robust GitHub Actions with fallback strategies
    <!-- AI-EVOLUTION-MARKER:END -->
2. **`init_setup.sh`**: The germination script. Now supports cross-platform setup with OS detection and proper dependency management.
3. **`.github/workflows/ai_evolver.yml`**: The heart of the growth engine. v0.3.6-seed includes container support, enhanced authentication, and cross-platform compatibility.
4. **`.seed.md`**: The blueprint for the *next* generation. The v0.3.6-seed workflow generates advanced evolution strategies.
5. **`evolution-metrics.json`**: Tracks quantitative and qualitative aspects of growth with environment awareness.
6. **`docker/`**: Complete containerization support with Dockerfile, docker-compose, and documentation.
7. **`scripts/local-evolution.sh`**: Cross-platform local development runner with comprehensive CLI interface.
8. **Enhanced Scripts**: All scripts now support multiple platforms and execution environments.

## 🤖 Automated Daily Evolution (New in v0.3.6-seed!)

The repository now includes an intelligent daily evolution system that automatically maintains code quality and consistency:

### 🌅 Daily Maintenance Features

- **Automated Health Checks**: Scans for inconsistencies, errors, and improvement opportunities
- **Smart Triggering**: Only runs when actual improvements are detected
- **Conservative Approach**: Focuses on safe, minimal changes by default
- **Command Line Interface**: On-demand evolution cycles with full control

### 🚀 Quick Daily Evolution Commands

```bash
# Run quick consistency check and fixes
./scripts/evolve.sh

# Documentation improvements
./scripts/evolve.sh --type documentation --intensity moderate

# Custom evolution with specific goals
./scripts/evolve.sh --type custom --prompt "Improve error handling in scripts"

# Dry run to preview changes
./scripts/evolve.sh --type code_quality --dry-run
```

**Daily Schedule**: Automatically runs at 3 AM UTC daily (configurable)
**On-Demand**: Use `./scripts/evolve.sh` anytime for immediate improvements

➡️ **[Complete Daily Evolution Guide](docs/DAILY_EVOLUTION.md)**

## 🚀 Quick Germination & Growth

```bash
# 1. Plant the v0.3.6-seed seed (if you haven't already)
# Ensure you're in an empty directory for a new project
# curl -fsSL https://raw.githubusercontent.com/bamr87/ai-evolution-engine/main/init_setup.sh -o init_setup.sh # Get latest
# For this specific v0.3.6-seed, ensure you're using the v0.3.6-seed version of this script.
bash init_setup.sh

# 2. Set your AI API Key (if using a real AI in the future)
# export AI_API_KEY="your_actual_ai_key_here"

# 3. Initiate a growth cycle via GitHub Actions
gh workflow run ai_evolver.yml -f prompt="Evolve the project to include a basic REST API for tracking plant growth." -f growth_mode="adaptive"
```
*(Requires GitHub CLI `gh` to be installed and authenticated)*

## 🏗️ Modular Architecture (New in v0.3.6-seed!)

The AI Evolution Engine features a completely refactored modular architecture for improved maintainability, testing, and extensibility:

### 📦 Core Libraries

**`src/lib/core/`** - Foundation libraries used across all scripts:

- **`logger.sh`** - Unified logging with color support and CI/local awareness
- **`environment.sh`** - Environment detection, OS handling, and command checking
- **`testing.sh`** - Comprehensive test framework with assertions and reporting

**`src/lib/evolution/`** - Evolution-specific functionality:

- **`git.sh`** - Git operations (branching, committing, pushing)
- **`metrics.sh`** - Evolution metrics tracking and analysis

### 🔧 Refactored Scripts

Scripts now use modular imports instead of inline duplicated code:

```bash
# Before: Inline logging and environment detection
echo "Starting process..."

# After: Modular approach
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
log_info "Starting process..."
```

**Currently Refactored:**

- ✅ `evolve.sh` - Main evolution orchestrator
- ✅ `ai-debug-helper.sh` - Debug information collector
- ✅ `analyze-repository-health.sh` - Health analysis
- ✅ `apply-growth-changes.sh` - Change application
- ✅ `check-prereqs.sh` - Prerequisite validation
- ✅ `collect-context.sh` - Context gathering
- ✅ `generate-evolution-prompt.sh` - Prompt generation
- ✅ `local-evolution.sh` - Local development runner
- ✅ `setup-environment.sh` - Environment setup
- ✅ `tests/workflows/test-workflow.sh` - Workflow testing
- ✅ `update-evolution-metrics.sh` - Metrics updates

### 🧪 Enhanced Testing Framework

- **Modular test suites** for each library component
- **Integration testing** between libraries
- **Backward compatibility validation**
- **Comprehensive test reporting** with JSON and Markdown outputs

➡️ **[Complete Modular Architecture Guide](MODULAR_ARCHITECTURE.md)**

## 🔢 Advanced Version Management & Change Tracking (Complete in v0.3.6-seed!)

The AI Evolution Engine features a comprehensive, automated version management system with intelligent change tracking, correlation reporting, and no backup file creation - providing complete visibility into what changed when across all evolution cycles.

### 🎯 Intelligent Change Correlation

- **File-Level Tracking**: Monitors individual files for changes since last version update
- **Pattern-Based Updates**: Uses configurable patterns to find and update version references
- **Evolution-Aware**: Special handling for AI evolution cycles with automatic incrementing
- **Cross-File Consistency**: Ensures all version references stay synchronized
- **Change History**: Maintains detailed logs of which files changed in each release
- **No Backup Files**: Clean workflow without cluttering the repository with backup files
- **Correlation Reports**: Generate detailed reports linking versions to file changes
- **Query Interface**: Rich CLI for exploring version and file history

### 🚀 Version Management Commands

```bash
# Check current version status and change tracking
./scripts/version-manager.sh check-status

# Increment version for evolution cycles with automatic tracking
./scripts/version-integration.sh evolution "Added new features"

# Manual version increment with change correlation
./scripts/version-manager.sh increment patch "Bug fixes and improvements"

# Query version history and correlations
./scripts/version-tracker.sh show-history          # Recent version changes
./scripts/version-tracker.sh correlate-files 0.3.6  # Files changed in version
./scripts/version-tracker.sh file-history README.md # Version history for file

# Generate comprehensive reports
./scripts/version-tracker.sh generate-report markdown report.md
./scripts/version-tracker.sh generate-report json data.json

# Query which files changed in a specific version
./scripts/version-tracker.sh correlate-files --version "0.3.3"

# Show version history for a specific file
./scripts/version-tracker.sh file-history README.md

# Generate comprehensive correlation report
./scripts/version-tracker.sh generate-report --format markdown --output evolution-report.md
```

### 🔄 Enhanced Evolution Integration

The version management system provides complete visibility into evolution cycles:

- **Pre-Evolution**: Captures current state and initializes change tracking
- **During Evolution**: Monitors which files are being modified in real-time
- **Post-Evolution**: Automatically increments version, correlates changes, and updates changelog
- **Change Correlation**: Links version increments to specific file modifications
- **Report Generation**: Creates detailed reports showing file-to-version relationships

### � Change Tracking Features

- **Version-File Correlation**: Easily see which files were modified in any release
- **File-Version History**: Track all versions that affected a specific file
- **Automated Changelog**: Enhanced changelog entries with file-level links
- **Git Integration**: Leverages git metadata for comprehensive change tracking
- **Query Interface**: CLI tools for investigating change history
- **Report Generation**: Markdown, JSON, and CSV export formats

### 📁 Configuration-Driven Tracking

```json
{
  "change_tracking": {
    "enabled": true,
    "log_file": "version-changes.json",
    "include_git_info": true,
    "track_file_hashes": true,
    "backup_files": false
  },
  "changelog_integration": {
    "enabled": true,
    "auto_generate_entries": true,
    "link_to_files": true,
    "include_git_refs": true
  }
}
```

### 🔍 Quick Reference Commands

```bash
# Find all files changed in version 0.3.3
./scripts/version-tracker.sh correlate-files "0.3.3"

# See which versions affected README.md
./scripts/version-tracker.sh file-history "README.md"

# Show recent version changes with file counts
./scripts/version-tracker.sh show-history --limit 5

# Generate evolution report for latest version
./scripts/version-tracker.sh generate-report --format markdown
```

➡️ **[Complete Version Management Guide](docs/guides/version-management.md)**

## 🌳 The Growth Cycle Explained

```mermaid
graph TD
    A[🌱 Seed v0.3.6-seed] --> B[💡 User Prompt (e.g., 'Add feature X')]
    B --> C[🤖 ai_evolver.yml Workflow Triggered]
    C --> D[🧬 Context Collection (incl. .gptignore)]
    D --> E[🧠 Simulated AI Processing]
    E --> F[📝 Changes Proposed (Code, README, Metrics)]
    F --> G[BRANCH{New Git Branch}]
    G -- Apply Changes --> H[💻 Codebase Evolves]
    H --> I[📊 Metrics Updated]
    I --> J[📄 README Updated (see markers)]
    J --> K[🌰 New .seed.md Generated (for v0.3.6-seed)]
    K --> L[✅ PR Created for Review]
    L -- Merge --> A_NEXT[🌱 Evolved Seed (ready for next cycle)]
```

## 🧪 Comprehensive Testing Framework

The AI Evolution Engine includes a robust testing framework that ensures reliability and quality across all components, with special focus on GitHub Actions workflow validation.

### 🔬 Testing Categories

| Test Type | Purpose | Coverage |
|-----------|---------|----------|
| **Unit Tests** | Individual component validation | ✅ Workflow YAML structure<br>✅ Script syntax validation<br>✅ JSON/YAML file integrity |
| **Integration Tests** | End-to-end workflow testing | ✅ Context collection simulation<br>✅ Metrics update verification<br>✅ Script integration validation |
| **Workflow Tests** | GitHub Actions specific | ✅ Security permissions<br>✅ Input/output validation<br>✅ Error handling patterns |
| **Security Tests** | Safety and compliance | ✅ Secret handling<br>✅ Permission scoping<br>✅ Action version currency |

### 🚀 Running Tests

```bash
# Run all tests (unit + integration + workflow)
make test

# Run specific test categories
make test-unit          # Unit tests only
make test-integration   # Integration tests only
make test-workflow      # GitHub Actions workflow tests only

# Enhanced test runner with detailed options
./tests/test_runner.sh --type all --verbose
./tests/workflow_test_runner.sh
```

### 📊 Test Documentation

Comprehensive testing documentation is available at:
- [Workflow Testing Guide](docs/workflow-testing.md) - Complete framework documentation
- [Test Standards](tests/unit/workflows/README.md) - Unit testing guidelines
- [Integration Patterns](tests/integration/README.md) - End-to-end testing approaches

## 🧪 Evolution Generation 3.1: Testing & Build Automation

This evolution cycle focused on **real-world problem-solving** in CI/CD automation, derived from fixing actual issues in the zer0-mistakes Jekyll theme project.

### 🎯 Problems Solved & Solutions Encoded

| Issue Category | Problem | Solution | Pattern Encoded |
|---------------|---------|----------|-----------------|
| **Gemspec Validation** | `gem specification` failed on unbuilt gems | `ruby -c` syntax checking | Syntax validation patterns |
| **YAML Parsing** | `grep -q '---'` treated as option | `grep -q -- '---'` proper escaping | Argument escaping methods |
| **File Permissions** | Non-world-readable assets | Automated `chmod 644` corrections | Permission management |
| **Authentication** | `gem whoami` doesn't exist in RubyGems 3.x | Credential file checking | Version-agnostic auth |
| **Version Conflicts** | Republishing existing versions | Proactive remote registry checking | Conflict prevention |
| **Build Verification** | `gem contents` fails on uninstalled gems | `tar -tzf` for gem inspection | Alternative verification |
| **Dependencies** | Open-ended version constraints | Semantic versioning patterns | Dependency best practices |

### 🚀 Automation Capabilities

- **26 comprehensive test cases** with automated error resolution
- **Multi-format build support** (npm, gem, Makefile, generic)
- **Verbose debugging modes** for troubleshooting
- **Proactive conflict detection** before publish attempts
- **Self-healing scripts** that fix common issues automatically

### 🌱 Seeds Generated

1. **`testing_automation_init.sh`** - Complete testing framework setup
2. **`.seed_testing_automation.md`** - Detailed evolution DNA
3. **`seed_prompt_testing_automation.md`** - Next generation prompt
4. **Enhanced workflow** - `testing_automation_evolver.yml`

## 🧪 Seed Vitality Metrics (Generation 3.1)

- **Germination Success**: Aiming for >98% clean setup.
- **Simulated Adaptation Rate**: 100% (as it's currently simulated).
- **Documentation Cohesion**: README and code evolve together.

## 🌍 Join the Digital Arboretum

This is more than just a template; it's a call to explore a new way of building software. By planting this seed, you're participating in an experiment to create self-evolving, intelligent applications.

---

*🌱 Generated by AI Evolution Engine Seed v0.3.6-seed*
*"The code that grows itself, knows itself."*
