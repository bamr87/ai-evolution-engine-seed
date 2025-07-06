#!/bin/bash
#
# @file src/lib/evolution/seeds.sh
# @description Seed generation and management system for AI Evolution Engine
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular seed management system
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#
# @changelog
#   - 2025-07-05: Initial creation of modular seed system - ITJ
#
# @usage require_module "evolution/seeds"; seeds_generate_next
# @notes Manages the complete seed lifecycle and evolution tracking
#

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly SEEDS_VERSION="2.0.0"

# Seed system configuration
declare -g SEEDS_DIRECTORY="${SEEDS_DIRECTORY:-seeds}"
declare -g CURRENT_SEED_FILE="${CURRENT_SEED_FILE:-.seed.md}"
declare -g SEED_GENERATION=1
declare -g SEED_CYCLE=0
declare -A SEED_METADATA=()
declare -A SEED_HISTORY=()

# Seed file templates
readonly SEED_TEMPLATE_README='#!/usr/bin/env bash
#
# @file README.md
# @description {{DESCRIPTION}}
# @author {{AUTHOR}}
# @created {{CREATED_DATE}}
# @lastModified {{LAST_MODIFIED}}
# @version {{VERSION}}
#
# @relatedIssues 
#   - {{RELATED_ISSUES}}
#
# @relatedEvolutions
#   - {{EVOLUTION_CYCLE}}: {{EVOLUTION_DESCRIPTION}}
#
# @dependencies
#   - {{DEPENDENCIES}}
#
# @changelog
#   - {{CREATED_DATE}}: Initial seed creation - {{AUTHOR_INITIALS}}
#
# @usage {{USAGE_INSTRUCTIONS}}
# @notes {{NOTES}}
#

# 🌱 {{PROJECT_NAME}} - AI Evolution Engine Seed

{{PROJECT_DESCRIPTION}}

## 🚀 Quick Start

\`\`\`bash
# Clone and initialize
git clone {{REPOSITORY_URL}}
cd {{PROJECT_NAME}}
chmod +x init_setup.sh
./init_setup.sh
\`\`\`

## 📦 What This Seed Contains

This seed includes the essential components for AI-powered repository evolution:

- **Core Evolution Engine**: Modular system for automated code improvement
- **AI Integration Layer**: Interfaces for AI-powered development assistance  
- **Automated Workflows**: GitHub Actions for continuous evolution
- **Testing Framework**: Comprehensive testing and validation system
- **Documentation System**: Self-updating documentation with Jekyll integration

## 🧬 Evolution Tracking

- **Current Generation**: {{SEED_GENERATION}}
- **Evolution Cycle**: {{SEED_CYCLE}}
- **Last Evolution**: {{LAST_EVOLUTION_DATE}}
- **Growth Mode**: {{GROWTH_MODE}}

## 📊 Metrics

<!-- AI-EVOLUTION-MARKER-START -->
- **Total Evolutions**: {{TOTAL_EVOLUTIONS}}
- **Success Rate**: {{SUCCESS_RATE}}%
- **Code Quality Score**: {{QUALITY_SCORE}}/100
- **Test Coverage**: {{TEST_COVERAGE}}%
- **Documentation Score**: {{DOC_SCORE}}%
<!-- AI-EVOLUTION-MARKER-END -->

## 🛠️ Core Components

### Evolution Engine (`src/lib/evolution/`)
- `engine.sh` - Main evolution orchestrator
- `git.sh` - Git operations and branch management
- `metrics.sh` - Evolution metrics and analytics
- `seeds.sh` - Seed generation and management

### Core Infrastructure (`src/lib/core/`)
- `bootstrap.sh` - Library initialization system
- `logger.sh` - Comprehensive logging framework
- `config.sh` - Configuration management
- `utils.sh` - Common utility functions
- `validation.sh` - Input/output validation

### Integration Layer (`src/lib/integration/`)
- `github.sh` - GitHub API and workflow integration
- `docker.sh` - Container operations
- `ci-cd.sh` - CI/CD pipeline management

## 📋 Usage Examples

### Basic Evolution Cycle
\`\`\`bash
# Initialize the system
source src/lib/core/bootstrap.sh
bootstrap_library

# Load evolution engine
require_module "evolution/engine"
evolution_init

# Run a consistency evolution
evolution_run_cycle "consistency" "minimal" "adaptive"
\`\`\`

### Custom Evolution
\`\`\`bash
# Run custom evolution with specific prompt
evolution_run_cycle "custom" "moderate" "experimental" \\
  "Implement advanced AI-powered code analysis features"
\`\`\`

### Seed Generation
\`\`\`bash
# Generate next evolution seed
require_module "evolution/seeds"
seeds_generate_next "feature_enhancement" "comprehensive"
\`\`\`

## 🔧 Configuration

Create `evolution.yml` to customize behavior:

\`\`\`yaml
evolution:
  type: "consistency"
  intensity: "minimal"
  growth_mode: "adaptive"
  auto_commit: true
  auto_push: false

ai:
  provider: "openai"
  model: "gpt-4"
  temperature: 0.7

testing:
  enabled: true
  coverage_threshold: 80

logging:
  level: "INFO"
  file_enabled: true
\`\`\`

## 🧪 Testing

\`\`\`bash
# Run all tests
./tests/workflows/test-all-workflows-local.sh

# Test specific module
src/lib/core/testing.sh --module evolution/engine

# Benchmark performance
src/lib/core/validation.sh benchmark_validation
\`\`\`

## 📈 Monitoring

Track evolution progress with built-in metrics:

\`\`\`bash
# View current metrics
./scripts/show-metrics.sh

# Generate evolution report
./scripts/generate-evolution-report.sh

# Monitor evolution logs
./scripts/monitor-logs.sh
\`\`\`

## 🚀 Deployment

### Local Development
\`\`\`bash
# Start local evolution environment
./scripts/local-evolution.sh --prompt "Your evolution goal"
\`\`\`

### GitHub Actions
\`\`\`bash
# Trigger automated evolution
gh workflow run ai_evolver.yml -f evolution_type=consistency
\`\`\`

### Container Deployment
\`\`\`bash
# Build and run in container
docker-compose up evolution-engine
\`\`\`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Run evolution cycle: `evolution_run_cycle "feature_enhancement" "moderate" "adaptive"`
4. Commit changes: `git commit -m "Add amazing feature"`
5. Push to branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## 📄 License

This project is licensed under the {{LICENSE}} License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with AI Evolution Engine v{{SEEDS_VERSION}}
- Powered by modular architecture patterns
- Inspired by natural evolution and adaptive systems
- Community-driven development approach

---

🌱 **This seed evolves**: This README is automatically updated through AI-powered evolution cycles to reflect the current state and capabilities of the project.

*Last updated: {{LAST_MODIFIED}} | Generation: {{SEED_GENERATION}} | Cycle: {{SEED_CYCLE}}*'

readonly SEED_TEMPLATE_INIT='#!/bin/bash
#
# @file init_setup.sh
# @description Initialization script for AI Evolution Engine seed
# @author {{AUTHOR}}
# @created {{CREATED_DATE}}
# @lastModified {{LAST_MODIFIED}}
# @version {{VERSION}}
#
# @relatedIssues 
#   - {{RELATED_ISSUES}}
#
# @relatedEvolutions
#   - {{EVOLUTION_CYCLE}}: {{EVOLUTION_DESCRIPTION}}
#
# @dependencies
#   - bash: >=4.0
#   - git: >=2.0
#   - jq: >=1.6
#
# @changelog
#   - {{CREATED_DATE}}: Initial seed setup script - {{AUTHOR_INITIALS}}
#
# @usage ./init_setup.sh [--skip-deps] [--config-only]
# @notes Handles complete environment setup and dependency installation
#

set -euo pipefail

# Script metadata
readonly SCRIPT_NAME="AI Evolution Engine Seed Initializer"
readonly SCRIPT_VERSION="{{VERSION}}"
readonly SEED_GENERATION="{{SEED_GENERATION}}"
readonly SEED_CYCLE="{{SEED_CYCLE}}"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Configuration
SKIP_DEPENDENCIES=false
CONFIG_ONLY=false
VERBOSE=false
DRY_RUN=false

# Show banner
show_banner() {
    cat << EOF
${PURPLE}
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  🌱 AI Evolution Engine - Seed Initializer v${SCRIPT_VERSION}     ║
║                                                              ║
║  Generation: ${SEED_GENERATION} | Cycle: ${SEED_CYCLE}                                    ║
║  Preparing your repository for AI-powered evolution...      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
${NC}
EOF
}

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  INFO:${NC} $1"; }
log_success() { echo -e "${GREEN}✅ SUCCESS:${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️  WARNING:${NC} $1"; }
log_error() { echo -e "${RED}❌ ERROR:${NC} $1"; }
log_debug() { [[ "$VERBOSE" == "true" ]] && echo -e "${CYAN}🔍 DEBUG:${NC} $1"; }

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-deps)
                SKIP_DEPENDENCIES=true
                shift
                ;;
            --config-only)
                CONFIG_ONLY=true
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help
show_help() {
    cat << EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --skip-deps         Skip dependency installation
    --config-only       Only create configuration files
    --verbose, -v       Enable verbose output
    --dry-run           Show what would be done without executing
    --help, -h          Show this help message

EXAMPLES:
    $0                  # Full initialization
    $0 --skip-deps      # Skip dependency installation
    $0 --config-only    # Only setup configuration
    $0 --verbose        # Detailed output

DESCRIPTION:
    This script initializes a repository with the AI Evolution Engine,
    setting up all necessary components for automated code evolution,
    testing, and continuous improvement workflows.

EOF
}

# Check if running in supported environment
check_environment() {
    log_info "Checking environment compatibility..."
    
    # Check OS
    case "$OSTYPE" in
        "linux-gnu"*) 
            log_success "Detected Linux environment"
            ;;
        "darwin"*) 
            log_success "Detected macOS environment"
            ;;
        "cygwin"|"msys") 
            log_warn "Detected Windows environment - some features may be limited"
            ;;
        *) 
            log_warn "Unknown OS type: $OSTYPE - proceeding with caution"
            ;;
    esac
    
    # Check bash version
    local bash_version
    bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    if [[ -n "$bash_version" ]] && (( $(echo "$bash_version >= 4.0" | bc -l 2>/dev/null || echo 0) )); then
        log_success "Bash version $bash_version is compatible"
    else
        log_error "Bash 4.0+ required, found: $bash_version"
        exit 1
    fi
    
    # Check if in git repository
    if git rev-parse --git-dir >/dev/null 2>&1; then
        log_success "Git repository detected"
    else
        log_warn "Not in a git repository - initializing git..."
        if [[ "$DRY_RUN" != "true" ]]; then
            git init
            log_success "Git repository initialized"
        fi
    fi
}

# Install dependencies
install_dependencies() {
    if [[ "$SKIP_DEPENDENCIES" == "true" ]]; then
        log_info "Skipping dependency installation"
        return 0
    fi
    
    log_info "Installing required dependencies..."
    
    # Check for package managers and install dependencies
    if command -v apt-get >/dev/null 2>&1; then
        # Ubuntu/Debian
        log_info "Using apt-get package manager"
        if [[ "$DRY_RUN" != "true" ]]; then
            sudo apt-get update
            sudo apt-get install -y jq curl git
        fi
    elif command -v brew >/dev/null 2>&1; then
        # macOS
        log_info "Using Homebrew package manager"
        if [[ "$DRY_RUN" != "true" ]]; then
            brew install jq curl git
        fi
    elif command -v yum >/dev/null 2>&1; then
        # RHEL/CentOS
        log_info "Using yum package manager"
        if [[ "$DRY_RUN" != "true" ]]; then
            sudo yum install -y jq curl git
        fi
    else
        log_warn "No supported package manager found - manual installation required"
        log_info "Please install: jq, curl, git"
    fi
    
    # Verify installations
    local deps=("jq" "curl" "git")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            log_success "$dep is available"
        else
            log_error "$dep is required but not installed"
            exit 1
        fi
    done
}

# Create directory structure
create_directory_structure() {
    log_info "Creating directory structure..."
    
    local directories=(
        "src/lib/core"
        "src/lib/evolution"
        "src/lib/integration"
        "src/lib/analysis"
        "src/lib/templates"
        "scripts"
        "tests/lib"
        "tests/integration"
        "docs"
        "logs"
        "seeds"
        "templates"
        ".github/workflows"
    )
    
    for dir in "${directories[@]}"; do
        if [[ "$DRY_RUN" != "true" ]]; then
            mkdir -p "$dir"
        fi
        log_debug "Created directory: $dir"
    done
    
    log_success "Directory structure created"
}

# Generate configuration files
generate_config_files() {
    log_info "Generating configuration files..."
    
    # Create evolution.yml
    if [[ "$DRY_RUN" != "true" ]]; then
        cat > evolution.yml << EOF
# AI Evolution Engine Configuration
# Generated: $(date -Iseconds)

metadata:
  version: "{{VERSION}}"
  seed_generation: {{SEED_GENERATION}}
  seed_cycle: {{SEED_CYCLE}}
  created_at: "$(date -Iseconds)"

evolution:
  type: "consistency"
  intensity: "minimal"
  growth_mode: "adaptive"
  auto_commit: true
  auto_push: false
  branch_prefix: "evolution"

ai:
  provider: "openai"
  model: "gpt-4"
  temperature: 0.7
  max_tokens: 2000
  timeout: 30

testing:
  enabled: true
  framework: "bash"
  coverage_threshold: 80
  timeout: 300

logging:
  level: "INFO"
  format: "standard"
  file_enabled: true
  console_enabled: true

security:
  scan_enabled: true
  secrets_detection: true
  dependency_check: true

notifications:
  slack_webhook: ""
  email_enabled: false
  github_mentions: true
EOF
    fi
    
    log_success "Configuration files generated"
}

# Initialize evolution engine
initialize_evolution_engine() {
    if [[ "$CONFIG_ONLY" == "true" ]]; then
        log_info "Config-only mode - skipping evolution engine initialization"
        return 0
    fi
    
    log_info "Initializing AI Evolution Engine..."
    
    # Bootstrap the library system
    if [[ -f "src/lib/core/bootstrap.sh" ]]; then
        if [[ "$DRY_RUN" != "true" ]]; then
            source src/lib/core/bootstrap.sh
            bootstrap_library
        fi
        log_success "Evolution engine bootstrapped"
    else
        log_warn "Bootstrap module not found - engine initialization deferred"
    fi
}

# Set up git hooks
setup_git_hooks() {
    log_info "Setting up Git hooks..."
    
    if [[ "$DRY_RUN" != "true" ]]; then
        # Create pre-commit hook
        cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# AI Evolution Engine - Pre-commit hook

# Run syntax checks
find . -name "*.sh" -exec bash -n {} \; || {
    echo "❌ Shell script syntax errors detected"
    exit 1
}

# Run JSON validation
find . -name "*.json" -exec jq empty {} \; 2>/dev/null || {
    echo "❌ JSON validation errors detected"
    exit 1
}

echo "✅ Pre-commit checks passed"
EOF
        
        chmod +x .git/hooks/pre-commit
    fi
    
    log_success "Git hooks configured"
}

# Create initial documentation
create_documentation() {
    log_info "Creating initial documentation..."
    
    if [[ "$DRY_RUN" != "true" ]]; then
        # Create docs/README.md
        cat > docs/README.md << EOF
# AI Evolution Engine Documentation

This directory contains comprehensive documentation for the AI Evolution Engine.

## Structure

- \`installation.md\` - Installation and setup guide
- \`usage.md\` - Usage examples and tutorials
- \`api.md\` - API reference documentation
- \`architecture.md\` - System architecture overview
- \`evolution-guide.md\` - Evolution process guide

## Getting Started

1. Read the [Installation Guide](installation.md)
2. Follow the [Usage Examples](usage.md)
3. Explore the [API Reference](api.md)

---
*Documentation generated by AI Evolution Engine v{{VERSION}}*
EOF
    fi
    
    log_success "Initial documentation created"
}

# Create sample evolution workflow
create_sample_workflow() {
    log_info "Creating sample GitHub Actions workflow..."
    
    if [[ "$DRY_RUN" != "true" ]]; then
        cat > .github/workflows/ai_evolver.yml << 'EOF'
name: AI Evolution Engine

on:
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM
  workflow_dispatch:
    inputs:
      evolution_type:
        description: 'Evolution type'
        required: true
        default: 'consistency'
        type: choice
        options:
          - consistency
          - error_fixing
          - documentation
          - code_quality
          - security_updates
          - custom
      intensity:
        description: 'Evolution intensity'
        required: true
        default: 'minimal'
        type: choice
        options:
          - minimal
          - moderate
          - comprehensive
          - experimental

jobs:
  evolve:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
      
    - name: Setup environment
      run: |
        chmod +x init_setup.sh
        ./init_setup.sh --skip-deps
        
    - name: Run evolution cycle
      run: |
        source src/lib/core/bootstrap.sh
        bootstrap_library
        require_module "evolution/engine"
        evolution_init
        evolution_run_cycle "${{ github.event.inputs.evolution_type || 'consistency' }}" \\
                           "${{ github.event.inputs.intensity || 'minimal' }}" \\
                           "adaptive"
        
    - name: Create Pull Request
      if: success()
      uses: peter-evans/create-pull-request@v5
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        commit-message: "AI Evolution: ${{ github.event.inputs.evolution_type || 'consistency' }}"
        title: "🌱 AI Evolution Cycle #${{ github.run_number }}"
        body: |
          ## AI Evolution Report
          
          - **Type**: ${{ github.event.inputs.evolution_type || 'consistency' }}
          - **Intensity**: ${{ github.event.inputs.intensity || 'minimal' }}
          - **Mode**: adaptive
          - **Cycle**: #${{ github.run_number }}
          
          This pull request contains automated improvements generated by the AI Evolution Engine.
          
          ### Changes Made
          - Code consistency improvements
          - Documentation updates  
          - Error handling enhancements
          - Quality optimizations
          
          ### Review Checklist
          - [ ] All tests pass
          - [ ] No breaking changes
          - [ ] Documentation is updated
          - [ ] Changes align with project goals
        branch: evolution/cycle-${{ github.run_number }}
        delete-branch: true
EOF
    fi
    
    log_success "Sample workflow created"
}

# Final setup and validation
finalize_setup() {
    log_info "Finalizing setup..."
    
    # Create .gitignore if it doesn't exist
    if [[ ! -f ".gitignore" ]] && [[ "$DRY_RUN" != "true" ]]; then
        cat > .gitignore << EOF
# AI Evolution Engine
logs/
*.log
.env
.secrets

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
.cache/
EOF
    fi
    
    # Set executable permissions
    if [[ "$DRY_RUN" != "true" ]]; then
        find scripts/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
        find src/lib/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    fi
    
    log_success "Setup finalized"
}

# Main execution
main() {
    parse_args "$@"
    
    show_banner
    
    log_info "Starting AI Evolution Engine initialization..."
    log_info "Mode: $([ "$DRY_RUN" == "true" ] && echo "DRY RUN" || echo "EXECUTION")"
    
    check_environment
    install_dependencies
    create_directory_structure
    generate_config_files
    initialize_evolution_engine
    setup_git_hooks
    create_documentation
    create_sample_workflow
    finalize_setup
    
    cat << EOF

${GREEN}
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  🎉 AI Evolution Engine Setup Complete!                     ║
║                                                              ║
║  Your repository is now ready for AI-powered evolution.     ║
║                                                              ║
║  Next steps:                                                 ║
║  1. Review configuration in evolution.yml                   ║
║  2. Run your first evolution cycle                          ║
║  3. Explore the documentation in docs/                      ║
║                                                              ║
║  Get started:                                                ║
║  source src/lib/core/bootstrap.sh && bootstrap_library      ║
║  evolution_run_cycle "consistency" "minimal" "adaptive"     ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
${NC}

EOF
    
    log_success "Initialization completed successfully!"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi'

# Initialize seed system
# Returns:
#   0: success
#   1: failure
seeds_init() {
    log_info "Initializing seed management system v$SEEDS_VERSION"
    
    # Create seeds directory if it doesn't exist
    if [[ ! -d "$SEEDS_DIRECTORY" ]]; then
        mkdir -p "$SEEDS_DIRECTORY"
        log_success "Created seeds directory: $SEEDS_DIRECTORY"
    fi
    
    # Load current seed metadata if available
    if [[ -f "$CURRENT_SEED_FILE" ]]; then
        seeds_load_metadata
    else
        log_info "No current seed file found"
    fi
    
    return 0
}

# Load seed metadata from current seed file
# Returns:
#   0: success
#   1: failure
seeds_load_metadata() {
    local seed_file="${1:-$CURRENT_SEED_FILE}"
    
    if [[ ! -f "$seed_file" ]]; then
        log_warn "Seed file not found: $seed_file"
        return 1
    fi
    
    log_info "Loading seed metadata from: $seed_file"
    
    # Extract metadata from seed file
    if grep -q "Generation:" "$seed_file"; then
        SEED_GENERATION=$(grep "Generation:" "$seed_file" | head -n1 | grep -oE '[0-9]+' || echo "1")
    fi
    
    if grep -q "Evolution Cycle:" "$seed_file"; then
        SEED_CYCLE=$(grep "Evolution Cycle:" "$seed_file" | head -n1 | grep -oE '[0-9]+' || echo "0")
    fi
    
    # Store in metadata array
    SEED_METADATA[generation]="$SEED_GENERATION"
    SEED_METADATA[cycle]="$SEED_CYCLE"
    SEED_METADATA[file]="$seed_file"
    SEED_METADATA[loaded_at]="$(date -Iseconds)"
    
    log_success "Loaded seed metadata - Generation: $SEED_GENERATION, Cycle: $SEED_CYCLE"
    return 0
}

# Generate template variables for seed creation
# Args:
#   $1: evolution_type
#   $2: growth_mode
# Returns:
#   Populates global SEED_METADATA array
seeds_prepare_variables() {
    local evolution_type="${1:-consistency}"
    local growth_mode="${2:-adaptive}"
    
    log_info "Preparing seed variables for evolution type: $evolution_type"
    
    # Basic metadata
    SEED_METADATA[project_name]="${PROJECT_NAME:-ai-evolution-engine-seed}"
    SEED_METADATA[description]="${PROJECT_DESCRIPTION:-AI-powered repository evolution and development assistance}"
    SEED_METADATA[author]="${AUTHOR:-IT-Journey Team}"
    SEED_METADATA[author_initials]="${AUTHOR_INITIALS:-ITJ}"
    SEED_METADATA[created_date]="$(date '+%Y-%m-%d')"
    SEED_METADATA[last_modified]="$(date -Iseconds)"
    SEED_METADATA[version]="$SEEDS_VERSION"
    
    # Evolution-specific metadata
    SEED_METADATA[evolution_cycle]="$SEED_CYCLE"
    SEED_METADATA[evolution_description]="$evolution_type evolution with $growth_mode growth mode"
    SEED_METADATA[growth_mode]="$growth_mode"
    SEED_METADATA[seed_generation]="$SEED_GENERATION"
    
    # Repository metadata
    if is_git_repository; then
        SEED_METADATA[repository_url]="$(git remote get-url origin 2>/dev/null || echo 'https://github.com/your-org/your-repo.git')"
        SEED_METADATA[current_branch]="$(get_current_branch 2>/dev/null || echo 'main')"
    else
        SEED_METADATA[repository_url]="https://github.com/your-org/your-repo.git"
        SEED_METADATA[current_branch]="main"
    fi
    
    # Technical metadata
    SEED_METADATA[dependencies]="bash >=4.0, git >=2.0, jq >=1.6"
    SEED_METADATA[license]="${LICENSE:-MIT}"
    SEED_METADATA[usage_instructions]="See README.md for detailed usage instructions"
    SEED_METADATA[notes]="Generated by AI Evolution Engine seed system"
    SEED_METADATA[related_issues]="Generated seed for $evolution_type evolution"
    
    # Metrics (placeholder values that would be replaced with actual metrics)
    SEED_METADATA[total_evolutions]="${TOTAL_EVOLUTIONS:-0}"
    SEED_METADATA[success_rate]="${SUCCESS_RATE:-100}"
    SEED_METADATA[quality_score]="${QUALITY_SCORE:-85}"
    SEED_METADATA[test_coverage]="${TEST_COVERAGE:-75}"
    SEED_METADATA[doc_score]="${DOC_SCORE:-90}"
    SEED_METADATA[last_evolution_date]="$(date '+%Y-%m-%d')"
    
    log_success "Seed variables prepared"
}

# Apply template variables to content
# Args:
#   $1: template_content
# Returns:
#   Prints content with variables replaced
seeds_apply_template() {
    local content="$1"
    
    # Replace all template variables
    for key in "${!SEED_METADATA[@]}"; do
        local value="${SEED_METADATA[$key]}"
        local placeholder="{{${key^^}}}"  # Convert to uppercase
        content="${content//$placeholder/$value}"
    done
    
    echo "$content"
}

# Generate README.md seed file
# Args:
#   $1: output_file (optional, default: README.md)
# Returns:
#   0: success
#   1: failure
seeds_generate_readme() {
    local output_file="${1:-README.md}"
    
    log_info "Generating README.md seed file: $output_file"
    
    # Apply template variables and create file
    local readme_content
    readme_content="$(seeds_apply_template "$SEED_TEMPLATE_README")"
    
    echo "$readme_content" > "$output_file"
    
    log_success "README.md seed generated: $output_file"
    return 0
}

# Generate init_setup.sh seed file
# Args:
#   $1: output_file (optional, default: init_setup.sh)
# Returns:
#   0: success
#   1: failure
seeds_generate_init_setup() {
    local output_file="${1:-init_setup.sh}"
    
    log_info "Generating init_setup.sh seed file: $output_file"
    
    # Apply template variables and create file
    local init_content
    init_content="$(seeds_apply_template "$SEED_TEMPLATE_INIT")"
    
    echo "$init_content" > "$output_file"
    chmod +x "$output_file"
    
    log_success "init_setup.sh seed generated: $output_file"
    return 0
}

# Generate GitHub Actions workflow
# Args:
#   $1: output_file (optional, default: .github/workflows/ai_evolver.yml)
# Returns:
#   0: success
#   1: failure
seeds_generate_workflow() {
    local output_file="${1:-.github/workflows/ai_evolver.yml}"
    
    log_info "Generating GitHub Actions workflow: $output_file"
    
    # Ensure directory exists
    mkdir -p "$(dirname "$output_file")"
    
    # Create workflow file
    cat > "$output_file" << 'EOF'
name: AI Evolution Engine

on:
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM
  workflow_dispatch:
    inputs:
      evolution_type:
        description: 'Evolution type'
        required: true
        default: 'consistency'
        type: choice
        options:
          - consistency
          - error_fixing
          - documentation
          - code_quality
          - security_updates
          - custom
      intensity:
        description: 'Evolution intensity'
        required: true
        default: 'minimal'
        type: choice
        options:
          - minimal
          - moderate
          - comprehensive
          - experimental
      growth_mode:
        description: 'Growth mode'
        required: true
        default: 'adaptive'
        type: choice
        options:
          - conservative
          - adaptive
          - experimental
          - aggressive
      custom_prompt:
        description: 'Custom evolution prompt (for custom type)'
        required: false
        default: ''

jobs:
  evolve:
    runs-on: ubuntu-latest
    
    permissions:
      contents: write
      pull-requests: write
      
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
      with:
        fetch-depth: 0
        
    - name: Setup environment
      run: |
        sudo apt-get update
        sudo apt-get install -y jq curl
        
    - name: Initialize evolution engine
      run: |
        chmod +x init_setup.sh
        ./init_setup.sh --skip-deps
        
    - name: Bootstrap library system
      run: |
        source src/lib/core/bootstrap.sh
        bootstrap_library
        
    - name: Run evolution cycle
      id: evolution
      run: |
        source src/lib/core/bootstrap.sh
        bootstrap_library
        require_module "evolution/engine"
        evolution_init
        
        EVOLUTION_TYPE="${{ github.event.inputs.evolution_type || 'consistency' }}"
        INTENSITY="${{ github.event.inputs.intensity || 'minimal' }}"
        GROWTH_MODE="${{ github.event.inputs.growth_mode || 'adaptive' }}"
        CUSTOM_PROMPT="${{ github.event.inputs.custom_prompt || '' }}"
        
        echo "Running evolution: $EVOLUTION_TYPE/$INTENSITY/$GROWTH_MODE"
        
        if evolution_run_cycle "$EVOLUTION_TYPE" "$INTENSITY" "$GROWTH_MODE" "$CUSTOM_PROMPT"; then
          echo "evolution_success=true" >> $GITHUB_OUTPUT
          echo "Evolution cycle completed successfully"
        else
          echo "evolution_success=false" >> $GITHUB_OUTPUT
          echo "Evolution cycle failed"
          exit 1
        fi
        
    - name: Generate evolution report
      if: always()
      run: |
        if [[ -f "evolution-cycle-*-report.md" ]]; then
          echo "EVOLUTION_REPORT<<EOF" >> $GITHUB_ENV
          cat evolution-cycle-*-report.md >> $GITHUB_ENV
          echo "EOF" >> $GITHUB_ENV
        fi
        
    - name: Create Pull Request
      if: steps.evolution.outputs.evolution_success == 'true'
      uses: peter-evans/create-pull-request@v5
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        commit-message: |
          🌱 AI Evolution: ${{ github.event.inputs.evolution_type || 'consistency' }}
          
          - Type: ${{ github.event.inputs.evolution_type || 'consistency' }}
          - Intensity: ${{ github.event.inputs.intensity || 'minimal' }}
          - Mode: ${{ github.event.inputs.growth_mode || 'adaptive' }}
          - Cycle: #${{ github.run_number }}
        title: "🌱 AI Evolution Cycle #${{ github.run_number }} (${{ github.event.inputs.evolution_type || 'consistency' }})"
        body: |
          ## 🌱 AI Evolution Report - Cycle #${{ github.run_number }}
          
          **Evolution Details:**
          - **Type**: ${{ github.event.inputs.evolution_type || 'consistency' }}
          - **Intensity**: ${{ github.event.inputs.intensity || 'minimal' }}
          - **Growth Mode**: ${{ github.event.inputs.growth_mode || 'adaptive' }}
          - **Triggered**: ${{ github.event_name }}
          - **Workflow Run**: [${{ github.run_number }}](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})
          
          **Custom Prompt:**
          ```
          ${{ github.event.inputs.custom_prompt || 'Default evolution prompt based on type' }}
          ```
          
          ### 📊 Evolution Results
          
          This pull request contains automated improvements generated by the AI Evolution Engine. The changes have been carefully analyzed and implemented according to the specified evolution parameters.
          
          ### 🔍 Review Checklist
          
          - [ ] **Functionality**: All existing functionality works as expected
          - [ ] **Tests**: All tests pass and coverage is maintained
          - [ ] **Documentation**: Changes are properly documented
          - [ ] **Security**: No security vulnerabilities introduced
          - [ ] **Performance**: No performance regressions
          - [ ] **Style**: Code follows project conventions
          
          ### 📈 Evolution Metrics
          
          - **Files Modified**: Check the "Files changed" tab
          - **Lines Added/Removed**: See diff statistics
          - **Commits**: Single evolution commit with detailed message
          
          ### 🚀 Next Steps
          
          1. Review the changes thoroughly
          2. Test the modifications locally if needed
          3. Merge if approved, or request modifications
          4. Monitor for any issues post-merge
          
          ---
          
          🤖 *This PR was automatically generated by the AI Evolution Engine v${{ env.SEEDS_VERSION || '2.0.0' }}*
          
          📋 **Full Evolution Report:**
          
          <details>
          <summary>Click to expand detailed report</summary>
          
          ```
          ${{ env.EVOLUTION_REPORT || 'Report not available' }}
          ```
          
          </details>
        branch: evolution/cycle-${{ github.run_number }}-${{ github.event.inputs.evolution_type || 'consistency' }}
        delete-branch: true
        draft: false
        
    - name: Comment on failure
      if: failure()
      uses: actions/github-script@v7
      with:
        script: |
          github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.repo,
            title: '🚨 AI Evolution Cycle Failed - #${{ github.run_number }}',
            body: `## Evolution Cycle Failure Report
            
            **Failed Evolution Details:**
            - **Type**: ${{ github.event.inputs.evolution_type || 'consistency' }}
            - **Intensity**: ${{ github.event.inputs.intensity || 'minimal' }}
            - **Growth Mode**: ${{ github.event.inputs.growth_mode || 'adaptive' }}
            - **Workflow Run**: [${{ github.run_number }}](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})
            - **Failure Time**: ${new Date().toISOString()}
            
            **Next Steps:**
            1. Review the workflow logs for error details
            2. Check for environment or dependency issues
            3. Verify evolution engine configuration
            4. Re-run the workflow after addressing issues
            
            This issue was automatically created by the AI Evolution Engine failure handler.`,
            labels: ['bug', 'ai-evolution', 'automated']
          });
EOF
    
    log_success "GitHub Actions workflow generated: $output_file"
    return 0
}

# Generate seed manifest file
# Args:
#   $1: output_file (optional, default: .seed.md)
# Returns:
#   0: success
#   1: failure
seeds_generate_manifest() {
    local output_file="${1:-$CURRENT_SEED_FILE}"
    
    log_info "Generating seed manifest: $output_file"
    
    cat > "$output_file" << EOF
# 🌱 AI Evolution Engine - Seed Manifest

**Seed Version**: ${SEEDS_VERSION}
**Generation**: ${SEED_GENERATION}
**Evolution Cycle**: ${SEED_CYCLE}
**Created**: $(date -Iseconds)

## 🧬 Seed Components

This seed contains the following evolved components:

### Core Files
- \`README.md\` - Project documentation and usage guide
- \`init_setup.sh\` - Environment initialization script
- \`.github/workflows/ai_evolver.yml\` - Automated evolution workflow
- \`.seed.md\` - This seed manifest file
- \`seed_prompt.md\` - Evolution prompt documentation

### Library Structure
- \`src/lib/core/\` - Core infrastructure modules
- \`src/lib/evolution/\` - Evolution engine components
- \`src/lib/integration/\` - Integration and deployment tools
- \`src/lib/analysis/\` - Code analysis and quality tools
- \`src/lib/templates/\` - Template generation modules

### Configuration
- \`evolution.yml\` - Evolution engine configuration
- \`evolution-metrics.json\` - Evolution metrics tracking

## 🔄 Evolution History

### Generation ${SEED_GENERATION}
- **Cycle**: ${SEED_CYCLE}
- **Type**: ${SEED_METADATA[evolution_description]:-Unknown}
- **Date**: $(date '+%Y-%m-%d')
- **Growth Mode**: ${SEED_METADATA[growth_mode]:-adaptive}

## 🚀 Deployment Instructions

1. **Initialize Repository**:
   \`\`\`bash
   chmod +x init_setup.sh
   ./init_setup.sh
   \`\`\`

2. **Bootstrap Evolution Engine**:
   \`\`\`bash
   source src/lib/core/bootstrap.sh
   bootstrap_library
   \`\`\`

3. **Run Evolution Cycle**:
   \`\`\`bash
   require_module "evolution/engine"
   evolution_init
   evolution_run_cycle "consistency" "minimal" "adaptive"
   \`\`\`

## 📊 Seed Metrics

- **Files**: ${SEED_METADATA[analysis_file_count]:-Unknown}
- **Code Quality**: ${SEED_METADATA[quality_score]:-85}/100
- **Test Coverage**: ${SEED_METADATA[test_coverage]:-75}%
- **Documentation**: ${SEED_METADATA[doc_score]:-90}%

## 🌱 Next Evolution

This seed is designed to evolve further. The next evolution cycle will:
- Analyze current implementation
- Identify improvement opportunities
- Generate enhanced seed components
- Update metrics and documentation

---

*Seed generated by AI Evolution Engine v${SEEDS_VERSION} on $(date -Iseconds)*
EOF
    
    log_success "Seed manifest generated: $output_file"
    return 0
}

# Generate complete seed package
# Args:
#   $1: evolution_type (default: consistency)
#   $2: growth_mode (default: adaptive)
#   $3: output_directory (default: current directory)
# Returns:
#   0: success
#   1: failure
seeds_generate_complete() {
    local evolution_type="${1:-consistency}"
    local growth_mode="${2:-adaptive}"
    local output_dir="${3:-.}"
    
    log_info "Generating complete seed package for $evolution_type evolution"
    
    # Increment generation for new seed
    ((SEED_GENERATION++))
    ((SEED_CYCLE++))
    
    # Prepare template variables
    seeds_prepare_variables "$evolution_type" "$growth_mode"
    
    # Change to output directory
    local original_dir="$(pwd)"
    if [[ "$output_dir" != "." ]]; then
        mkdir -p "$output_dir"
        cd "$output_dir"
    fi
    
    # Generate all seed components
    local components=(
        "seeds_generate_readme"
        "seeds_generate_init_setup" 
        "seeds_generate_workflow"
        "seeds_generate_manifest"
    )
    
    local generated_count=0
    for component in "${components[@]}"; do
        if "$component"; then
            ((generated_count++))
        else
            log_error "Failed to generate component: $component"
        fi
    done
    
    # Return to original directory
    cd "$original_dir"
    
    # Update seed history
    SEED_HISTORY["generation_${SEED_GENERATION}"]="$(date -Iseconds):$evolution_type:$growth_mode"
    
    log_success "Generated complete seed package ($generated_count components)"
    log_info "  Generation: $SEED_GENERATION"
    log_info "  Cycle: $SEED_CYCLE"
    log_info "  Type: $evolution_type"
    log_info "  Mode: $growth_mode"
    log_info "  Output: $output_dir"
    
    return 0
}

# Generate next evolution seed
# Args:
#   $1: evolution_type (default: consistency)
#   $2: intensity (default: minimal)
#   $3: growth_mode (default: adaptive)
# Returns:
#   0: success
#   1: failure
seeds_generate_next() {
    local evolution_type="${1:-consistency}"
    local intensity="${2:-minimal}"
    local growth_mode="${3:-adaptive}"
    
    log_info "Generating next evolution seed"
    log_info "  Current generation: $SEED_GENERATION"
    log_info "  Current cycle: $SEED_CYCLE"
    log_info "  Evolution: $evolution_type ($intensity, $growth_mode)"
    
    # Create timestamped output directory
    local timestamp
    timestamp="$(date '+%Y%m%d-%H%M%S')"
    local output_dir="$SEEDS_DIRECTORY/generation-$((SEED_GENERATION + 1))-${timestamp}"
    
    # Generate complete seed package
    if seeds_generate_complete "$evolution_type" "$growth_mode" "$output_dir"; then
        log_success "Next evolution seed generated in: $output_dir"
        
        # Create symlink to latest seed
        local latest_link="$SEEDS_DIRECTORY/latest"
        if [[ -L "$latest_link" ]]; then
            rm "$latest_link"
        fi
        ln -s "$(basename "$output_dir")" "$latest_link"
        
        log_info "Latest seed symlink updated: $latest_link"
        return 0
    else
        log_error "Failed to generate next evolution seed"
        return 1
    fi
}

# List all generated seeds
seeds_list() {
    log_info "Available seeds in $SEEDS_DIRECTORY:"
    
    if [[ ! -d "$SEEDS_DIRECTORY" ]]; then
        log_warn "Seeds directory does not exist: $SEEDS_DIRECTORY"
        return 1
    fi
    
    local seed_count=0
    for seed_dir in "$SEEDS_DIRECTORY"/generation-*; do
        if [[ -d "$seed_dir" ]]; then
            local dir_name
            dir_name="$(basename "$seed_dir")"
            local seed_file="$seed_dir/.seed.md"
            
            if [[ -f "$seed_file" ]]; then
                local generation
                generation="$(grep "Generation:" "$seed_file" | grep -oE '[0-9]+' | head -n1 || echo "unknown")"
                local cycle
                cycle="$(grep "Evolution Cycle:" "$seed_file" | grep -oE '[0-9]+' | head -n1 || echo "unknown")"
                local created
                created="$(grep "Created:" "$seed_file" | cut -d' ' -f2- || echo "unknown")"
                
                echo "  🌱 $dir_name (Gen: $generation, Cycle: $cycle, Created: $created)"
                ((seed_count++))
            else
                echo "  📁 $dir_name (no manifest)"
            fi
        fi
    done
    
    if [[ $seed_count -eq 0 ]]; then
        log_info "No seeds found"
    else
        log_success "Found $seed_count seeds"
    fi
    
    # Show latest symlink if it exists
    local latest_link="$SEEDS_DIRECTORY/latest"
    if [[ -L "$latest_link" ]]; then
        local target
        target="$(readlink "$latest_link")"
        echo "  🔗 latest -> $target"
    fi
}

# Deploy seed to current directory
# Args:
#   $1: seed_path (default: latest seed)
# Returns:
#   0: success
#   1: failure
seeds_deploy() {
    local seed_path="${1:-$SEEDS_DIRECTORY/latest}"
    
    if [[ ! -d "$seed_path" ]]; then
        log_error "Seed path does not exist: $seed_path"
        return 1
    fi
    
    log_info "Deploying seed from: $seed_path"
    
    # Copy seed files to current directory
    local files_copied=0
    while IFS= read -r -d '' file; do
        local relative_path
        relative_path="$(realpath --relative-to="$seed_path" "$file")"
        
        # Skip hidden files except specific ones
        if [[ "$relative_path" == .* ]] && [[ "$relative_path" != ".seed.md" ]]; then
            continue
        fi
        
        # Create directory if needed
        local target_dir
        target_dir="$(dirname "$relative_path")"
        [[ "$target_dir" != "." ]] && mkdir -p "$target_dir"
        
        # Copy file
        cp "$file" "$relative_path"
        log_debug "Copied: $relative_path"
        ((files_copied++))
    done < <(find "$seed_path" -type f -print0)
    
    log_success "Deployed seed ($files_copied files copied)"
    
    # Make scripts executable
    find . -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    log_info "Set executable permissions on shell scripts"
    return 0
}

# Show seed system status
seeds_status() {
    cat << EOF
🌱 AI Evolution Engine - Seed Management System v$SEEDS_VERSION

Current State:
  Generation: $SEED_GENERATION
  Cycle: $SEED_CYCLE
  Seeds Directory: $SEEDS_DIRECTORY
  Current Seed File: $CURRENT_SEED_FILE

Metadata:
$(for key in "${!SEED_METADATA[@]}"; do
    echo "  $key: ${SEED_METADATA[$key]}"
done)

History:
$(for key in "${!SEED_HISTORY[@]}"; do
    echo "  $key: ${SEED_HISTORY[$key]}"
done)

Available Commands:
  seeds_init                    - Initialize seed system
  seeds_generate_next [type] [intensity] [mode] - Generate next evolution seed
  seeds_generate_complete [type] [mode] [dir]   - Generate complete seed package
  seeds_list                    - List all generated seeds
  seeds_deploy [path]           - Deploy seed to current directory
  seeds_status                  - Show this status information

EOF
}
