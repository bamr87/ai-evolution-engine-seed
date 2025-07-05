#!/bin/bash
# Refactored AI Evolution Engine - Main Evolution Script
# Uses modular architecture for better maintainability and testing
# Version: 0.3.6-seed-modular

set -euo pipefail

# Script metadata
readonly SCRIPT_NAME="ai-evolution-engine"
readonly SCRIPT_VERSION="2.0.0-modular"
readonly SCRIPT_DESCRIPTION="AI-powered repository evolution with modular architecture"

# Determine script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source modular libraries
source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/core/testing.sh"
source "$PROJECT_ROOT/src/lib/evolution/git.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

# Configuration defaults
DEFAULT_EVOLUTION_TYPE="consistency"
DEFAULT_INTENSITY="minimal"
DEFAULT_GROWTH_MODE="adaptive"
DEFAULT_LOG_LEVEL="INFO"

# Global state
EVOLUTION_TYPE="$DEFAULT_EVOLUTION_TYPE"
INTENSITY="$DEFAULT_INTENSITY"
GROWTH_MODE="$DEFAULT_GROWTH_MODE"
DRY_RUN=false
AUTO_COMMIT=true
AUTO_PUSH=false
VERBOSE=false
QUIET=false
LOG_LEVEL="$DEFAULT_LOG_LEVEL"
CUSTOM_PROMPT=""
RUN_TESTS=true

# Show usage information
show_usage() {
    cat << EOF
$SCRIPT_DESCRIPTION

Usage: $0 [OPTIONS] [COMMAND]

Commands:
  evolve              Run evolution cycle (default)
  analyze             Analyze repository health
  test                Run comprehensive tests
  metrics             Generate metrics report
  setup               Setup environment
  status              Show current status

Options:
  --type TYPE         Evolution type (consistency|error_fixing|documentation|code_quality|security_updates)
  --intensity LEVEL   Evolution intensity (minimal|moderate|comprehensive)
  --growth-mode MODE  Growth mode (conservative|adaptive|experimental)
  --prompt TEXT       Custom evolution prompt
  --dry-run          Simulate changes without applying them
  --no-commit        Don't auto-commit changes
  --auto-push        Auto-push to remote after commit
  --run-tests        Run tests before and after evolution (default)
  --no-tests         Skip testing
  --log-level LEVEL  Log level (DEBUG|INFO|WARN|ERROR)
  --verbose          Enable verbose output
  --quiet            Minimal output
  --help             Show this help message

Examples:
  $0 evolve --type consistency --intensity minimal
  $0 evolve --type code_quality --intensity moderate --growth-mode adaptive
  $0 analyze
  $0 test --verbose
  $0 metrics --format markdown

Evolution Types:
  consistency         Fix inconsistencies and formatting issues
  error_fixing        Address errors and improve robustness
  documentation      Improve documentation and comments
  code_quality       Enhance code structure and readability
  security_updates   Apply security improvements

Growth Modes:
  conservative       Safe, minimal changes with high confidence
  adaptive          Balanced approach with moderate changes
  experimental      Advanced features and significant improvements

Environment Variables:
  LOG_LEVEL          Set default log level
  EVOLUTION_AUTO_PUSH Set default auto-push behavior
  AI_API_KEY         API key for AI integrations (optional)

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --type)
                EVOLUTION_TYPE="$2"
                shift 2
                ;;
            --intensity)
                INTENSITY="$2"
                shift 2
                ;;
            --growth-mode)
                GROWTH_MODE="$2"
                shift 2
                ;;
            --prompt)
                CUSTOM_PROMPT="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-commit)
                AUTO_COMMIT=false
                shift
                ;;
            --auto-push)
                AUTO_PUSH=true
                shift
                ;;
            --run-tests)
                RUN_TESTS=true
                shift
                ;;
            --no-tests)
                RUN_TESTS=false
                shift
                ;;
            --log-level)
                LOG_LEVEL="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=true
                LOG_LEVEL="DEBUG"
                shift
                ;;
            --quiet)
                QUIET=true
                LOG_LEVEL="ERROR"
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            evolve|analyze|test|metrics|setup|status)
                COMMAND="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Initialize the evolution environment
initialize_environment() {
    log_info "🌱 Initializing AI Evolution Engine v$SCRIPT_VERSION"
    
    # Setup logging
    init_logger "evolution-logs" "evolution-session"
    set_log_level "$LOG_LEVEL"
    
    if [[ "$QUIET" == "true" ]]; then
        enable_quiet_mode
    fi
    
    log_debug "Configuration:"
    log_debug "  Evolution Type: $EVOLUTION_TYPE"
    log_debug "  Intensity: $INTENSITY"
    log_debug "  Growth Mode: $GROWTH_MODE"
    log_debug "  Dry Run: $DRY_RUN"
    log_debug "  Auto Commit: $AUTO_COMMIT"
    log_debug "  Auto Push: $AUTO_PUSH"
    log_debug "  Run Tests: $RUN_TESTS"
    
    # Validate environment
    log_info "🔍 Validating environment..."
    if ! validate_environment; then
        log_error "Environment validation failed"
        exit 1
    fi
    
    # Initialize metrics
    log_info "📊 Initializing metrics..."
    init_metrics
    
    # Initialize git
    log_info "🔧 Initializing git repository..."
    init_git_repo
    
    log_success "Environment initialized successfully"
}

# Pre-evolution health check
run_pre_evolution_check() {
    log_info "🏥 Running pre-evolution health check..."
    
    # Check repository status
    if ! is_repo_clean; then
        log_warn "Repository has uncommitted changes"
        if [[ "$DRY_RUN" != "true" ]]; then
            log_info "Stashing changes before evolution..."
            git stash push -m "Pre-evolution stash: $(date)"
        fi
    fi
    
    # Analyze repository
    log_info "📈 Analyzing repository structure..."
    analyze_repository
    
    # Run tests if enabled
    if [[ "$RUN_TESTS" == "true" ]]; then
        log_info "🧪 Running pre-evolution tests..."
        run_evolution_tests "pre-evolution"
    fi
    
    log_success "Pre-evolution check completed"
}

# Run comprehensive tests
run_evolution_tests() {
    local test_phase="${1:-evolution}"
    
    log_info "🧪 Running $test_phase tests..."
    
    # Initialize testing framework
    init_testing "$test_phase-$EVOLUTION_TYPE"
    
    # Run modular architecture tests
    start_test_suite "modular_architecture" "Testing modular architecture"
    
    # Test core libraries
    run_test "Core libraries available" "
        source '$PROJECT_ROOT/src/lib/core/logger.sh' &&
        source '$PROJECT_ROOT/src/lib/core/environment.sh' &&
        source '$PROJECT_ROOT/src/lib/core/testing.sh'
    "
    
    # Test evolution libraries
    run_test "Evolution libraries available" "
        source '$PROJECT_ROOT/src/lib/evolution/git.sh' &&
        source '$PROJECT_ROOT/src/lib/evolution/metrics.sh'
    "
    
    # Test project structure
    run_test "Project structure valid" "
        test -f '$PROJECT_ROOT/README.md' &&
        test -d '$PROJECT_ROOT/src/lib' &&
        test -d '$PROJECT_ROOT/tests'
    "
    
    # Test scripts syntax
    for script in "$PROJECT_ROOT/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            script_name=$(basename "$script")
            run_test "Script syntax: $script_name" "bash -n '$script'"
        fi
    done
    
    end_test_suite
    
    # Run existing test suite integration
    if [[ -f "$PROJECT_ROOT/tests/test_runner.sh" ]]; then
        start_test_suite "existing_tests" "Running existing test suite"
        run_test "Existing test runner" "bash '$PROJECT_ROOT/tests/test_runner.sh' --type unit"
        end_test_suite
    fi
    
    # Finalize and get results
    local test_results
    if finalize_testing; then
        test_results="passed"
        log_success "$test_phase tests completed successfully"
    else
        test_results="failed"
        log_error "$test_phase tests failed"
        if [[ "$test_phase" == "pre-evolution" ]]; then
            log_error "Aborting evolution due to test failures"
            exit 1
        fi
    fi
    
    # Update metrics
    update_testing_metrics "evolution-metrics.json" "$TESTS_RUN" "$TESTS_PASSED" "$TESTS_FAILED" "modular-framework"
    
    return $([ "$test_results" = "passed" ] && echo 0 || echo 1)
}

# Generate evolution prompt based on type and analysis
generate_evolution_prompt() {
    local base_prompt=""
    local priority_areas=""
    
    log_info "🧠 Generating evolution prompt for type: $EVOLUTION_TYPE"
    
    case "$EVOLUTION_TYPE" in
        "consistency")
            base_prompt="Perform consistency improvements and minor fixes to enhance code quality and maintainability"
            priority_areas="1. Fix formatting inconsistencies
2. Standardize naming conventions
3. Remove redundant code
4. Improve code organization
5. Update documentation consistency"
            ;;
        "error_fixing")
            base_prompt="Address errors and improve system robustness through targeted fixes"
            priority_areas="1. Fix syntax and runtime errors
2. Improve error handling
3. Add input validation
4. Enhance logging and debugging
5. Resolve dependency issues"
            ;;
        "documentation")
            base_prompt="Enhance documentation quality and completeness"
            priority_areas="1. Update README files
2. Add inline code comments
3. Create usage examples
4. Document API interfaces
5. Improve installation instructions"
            ;;
        "code_quality")
            base_prompt="Improve code quality through refactoring and optimization"
            priority_areas="1. Refactor complex functions
2. Improve modularity
3. Optimize performance
4. Enhance readability
5. Apply best practices"
            ;;
        "security_updates")
            base_prompt="Apply security improvements and vulnerability fixes"
            priority_areas="1. Update dependencies
2. Fix security vulnerabilities
3. Improve input validation
4. Enhance authentication
5. Secure configuration"
            ;;
        *)
            base_prompt="Perform general improvements to the codebase"
            priority_areas="1. General code improvements
2. Bug fixes
3. Documentation updates
4. Performance enhancements
5. Best practice implementation"
            ;;
    esac
    
    # Add intensity modifier
    local intensity_modifier=""
    case "$INTENSITY" in
        "minimal") 
            intensity_modifier="Focus on small, safe changes with minimal risk. Make conservative improvements that have high confidence of success."
            ;;
        "moderate") 
            intensity_modifier="Make moderate improvements with balanced risk and benefit. Include meaningful changes that improve the system."
            ;;
        "comprehensive") 
            intensity_modifier="Perform comprehensive improvements with significant impact. Include substantial changes that transform the codebase."
            ;;
    esac
    
    # Combine into full prompt
    local full_prompt="$base_prompt

Intensity Level: $INTENSITY
$intensity_modifier

Priority Areas:
$priority_areas

Growth Mode: $GROWTH_MODE
Current Repository State: $(get_repo_info summary)

Please focus on modular architecture principles and ensure all changes:
1. Follow the DRY (Don't Repeat Yourself) principle
2. Implement proper error handling (Design for Failure)
3. Keep changes simple and maintainable (Keep It Simple)
4. Support incremental improvement (Release Early and Often)
5. Enable collaborative development (Collaboration)
6. Leverage AI-powered development practices (AI-Powered Development)"
    
    # Add custom prompt if provided
    if [[ -n "$CUSTOM_PROMPT" ]]; then
        full_prompt="$full_prompt

Additional Requirements:
$CUSTOM_PROMPT"
    fi
    
    echo "$full_prompt"
}

# Simulate AI evolution process
simulate_ai_evolution() {
    local prompt="$1"
    
    log_info "🤖 Simulating AI evolution process..."
    log_debug "Evolution prompt: $prompt"
    
    # Create evolution branch
    local evolution_branch
    evolution_branch=$(create_evolution_branch "$EVOLUTION_TYPE")
    
    if [[ -z "$evolution_branch" ]]; then
        log_error "Failed to create evolution branch"
        return 1
    fi
    
    log_info "🌿 Created evolution branch: $evolution_branch"
    
    # Simulate AI analysis and changes
    local changes_made=false
    local changes_list=()
    
    # Example modular improvements based on evolution type
    case "$EVOLUTION_TYPE" in
        "consistency")
            if [[ "$DRY_RUN" != "true" ]]; then
                # Create modular documentation
                create_modular_documentation
                changes_made=true
                changes_list+=("Added modular library documentation")
            fi
            ;;
        "code_quality")
            if [[ "$DRY_RUN" != "true" ]]; then
                # Create integration examples
                create_integration_examples
                changes_made=true
                changes_list+=("Added integration examples")
            fi
            ;;
        "documentation")
            if [[ "$DRY_RUN" != "true" ]]; then
                # Update documentation
                update_architecture_documentation
                changes_made=true
                changes_list+=("Updated architecture documentation")
            fi
            ;;
    esac
    
    # Record evolution metrics
    local evolution_success="true"
    local evolution_data
    evolution_data=$(cat << EOF
{
  "branch": "$evolution_branch",
  "prompt_length": ${#prompt},
  "changes_made": $changes_made,
  "changes": $(printf '%s\n' "${changes_list[@]}" | jq -R . | jq -s .),
  "dry_run": $DRY_RUN
}
EOF
)
    
    update_evolution_metrics "evolution-metrics.json" "$EVOLUTION_TYPE" "$evolution_success" "$evolution_data"
    
    # Commit changes if made and not in dry run
    if [[ "$changes_made" == "true" ]] && [[ "$DRY_RUN" != "true" ]] && [[ "$AUTO_COMMIT" == "true" ]]; then
        log_info "💾 Committing evolution changes..."
        
        stage_files
        local commit_hash
        commit_hash=$(create_evolution_commit "🌱 Evolution: $EVOLUTION_TYPE ($INTENSITY)" "$EVOLUTION_TYPE" "1" "1")
        
        if [[ -n "$commit_hash" ]]; then
            log_success "Created evolution commit: $commit_hash"
            
            # Push if requested
            if [[ "$AUTO_PUSH" == "true" ]]; then
                push_branch "$evolution_branch"
            fi
        fi
    fi
    
    # Update AI metrics
    update_ai_metrics "evolution-metrics.json" "true" "$changes_made" "$prompt" "0.8"
    
    log_success "AI evolution simulation completed"
    echo "$evolution_branch"
}

# Create modular documentation
create_modular_documentation() {
    log_info "📚 Creating modular library documentation..."
    
    # Core library README
    cat > "$PROJECT_ROOT/src/lib/core/README.md" << 'EOF'
# Core Libraries

This directory contains the core modular libraries for the AI Evolution Engine.

## Libraries

### `logger.sh` - Logging Framework
Provides consistent logging across all scripts with multiple log levels and output formats.

**Key Features:**
- Multiple log levels (DEBUG, INFO, WARN, ERROR, SUCCESS)
- File and console output
- CI/CD environment support
- Color-coded output

**Usage:**
```bash
source "src/lib/core/logger.sh"
init_logger "logs" "session-name"
log_info "This is an info message"
log_error "This is an error message"
```

### `environment.sh` - Environment Management
Handles environment detection, validation, and dependency management.

**Key Features:**
- OS detection (Linux, macOS, Windows)
- CI environment detection
- Dependency checking and installation
- GitHub CLI authentication

**Usage:**
```bash
source "src/lib/core/environment.sh"
validate_environment
check_command "git" "Git" "true"
setup_github_auth
```

### `testing.sh` - Testing Framework
Comprehensive testing framework with AI-powered insights and detailed reporting.

**Key Features:**
- Test discovery and execution
- Multiple assertion types
- JSON and Markdown reporting
- Test session management
- Performance tracking

**Usage:**
```bash
source "src/lib/core/testing.sh"
init_testing "test-session"
run_test "Test name" "command to test"
assert_equal "expected" "actual"
finalize_testing
```

## Design Principles

All core libraries follow these principles:

1. **Design for Failure (DFF)** - Comprehensive error handling
2. **Don't Repeat Yourself (DRY)** - Reusable, modular components
3. **Keep It Simple (KIS)** - Clear, readable implementations
4. **AI-Powered Development (AIPD)** - AI integration support
EOF

    # Evolution library README
    cat > "$PROJECT_ROOT/src/lib/evolution/README.md" << 'EOF'
# Evolution Libraries

This directory contains evolution-specific libraries for the AI Evolution Engine.

## Libraries

### `git.sh` - Git Operations
Provides consistent git operations for evolution workflows.

**Key Features:**
- Branch management for evolution cycles
- Automated commit creation with metadata
- Pull request automation
- Repository analysis and cleanup

**Usage:**
```bash
source "src/lib/evolution/git.sh"
init_git_repo
branch=$(create_evolution_branch "consistency")
create_evolution_commit "Evolution message" "type" "cycle" "generation"
```

### `metrics.sh` - Metrics Management
Handles collection, analysis, and reporting of evolution metrics.

**Key Features:**
- Comprehensive metrics tracking
- JSON-based data storage
- Multiple report formats
- AI effectiveness measurement
- Repository analysis

**Usage:**
```bash
source "src/lib/evolution/metrics.sh"
init_metrics
update_evolution_metrics "evolution-metrics.json" "consistency" "true"
generate_metrics_report "evolution-metrics.json" "markdown"
```

## Integration

Evolution libraries work together to provide:

- Automated evolution workflows
- Comprehensive metrics tracking
- Git-based version control
- AI-powered improvements
- Quality measurement and reporting

## Best Practices

1. Always initialize metrics before starting evolution
2. Use descriptive branch names for tracking
3. Record both successful and failed evolutions
4. Generate reports for analysis and improvement
5. Backup metrics before modifications
EOF

    log_success "Created modular library documentation"
}

# Create integration examples
create_integration_examples() {
    log_info "🔧 Creating integration examples..."
    
    mkdir -p "$PROJECT_ROOT/examples"
    
    cat > "$PROJECT_ROOT/examples/basic-evolution.sh" << 'EOF'
#!/bin/bash
# Basic Evolution Example
# Demonstrates how to use the modular AI Evolution Engine

set -euo pipefail

# Source the required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PROJECT_ROOT/src/lib/core/logger.sh"
source "$PROJECT_ROOT/src/lib/core/environment.sh"
source "$PROJECT_ROOT/src/lib/evolution/git.sh"
source "$PROJECT_ROOT/src/lib/evolution/metrics.sh"

# Initialize the environment
init_logger "example-logs" "basic-evolution"
log_info "🌱 Starting basic evolution example"

# Validate environment
if ! validate_environment; then
    log_error "Environment validation failed"
    exit 1
fi

# Initialize systems
init_git_repo
init_metrics "example-metrics.json"

# Simulate an evolution cycle
log_info "🚀 Running evolution cycle..."

# Create evolution branch
branch=$(create_evolution_branch "example")
log_info "Created branch: $branch"

# Make some changes (simulation)
echo "# Example Evolution" > example-change.md
echo "This file was created during an evolution cycle." >> example-change.md

# Commit changes
stage_files "example-change.md"
commit_hash=$(create_evolution_commit "Example evolution change" "example" "1" "1")
log_info "Created commit: $commit_hash"

# Update metrics
update_evolution_metrics "example-metrics.json" "example" "true" '{"files_changed": 1}'

# Generate report
generate_metrics_report "example-metrics.json" "summary"

log_success "✅ Basic evolution example completed"
EOF

    chmod +x "$PROJECT_ROOT/examples/basic-evolution.sh"
    
    log_success "Created integration examples"
}

# Update architecture documentation
update_architecture_documentation() {
    log_info "🏗️ Updating architecture documentation..."
    
    # Update main README with modular architecture section
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        cat >> "$PROJECT_ROOT/README.md" << 'EOF'

## 🏗️ Modular Architecture

The AI Evolution Engine has been refactored to use a modular architecture for better maintainability, testability, and extensibility.

### Architecture Overview

```
src/
├── lib/
│   ├── core/              # Core modular libraries
│   │   ├── logger.sh      # Logging framework
│   │   ├── environment.sh # Environment management
│   │   └── testing.sh     # Testing framework
│   └── evolution/         # Evolution-specific libraries
│       ├── git.sh         # Git operations
│       └── metrics.sh     # Metrics management
```

### Key Benefits

1. **Modularity** - Separate concerns into focused libraries
2. **Reusability** - Common functionality available across scripts
3. **Testability** - Each library can be tested independently
4. **Maintainability** - Easier to update and improve individual components
5. **AI Integration** - Enhanced support for AI-powered development

### Usage

```bash
# Source required libraries
source "src/lib/core/logger.sh"
source "src/lib/core/environment.sh"
source "src/lib/evolution/git.sh"
source "src/lib/evolution/metrics.sh"

# Initialize systems
init_logger "logs" "session"
validate_environment
init_git_repo
init_metrics
```

For detailed usage examples, see the `examples/` directory.
EOF
    fi
    
    log_success "Updated architecture documentation"
}

# Analyze repository health
analyze_repository_health() {
    log_info "🔍 Analyzing repository health..."
    
    # Initialize metrics and run analysis
    init_metrics
    analyze_repository
    
    # Generate comprehensive health report
    local health_report="$PROJECT_ROOT/health-report.md"
    generate_metrics_report "evolution-metrics.json" "markdown" "$health_report"
    
    log_success "Health analysis completed. Report saved to: $health_report"
    
    # Show summary
    generate_metrics_report "evolution-metrics.json" "summary"
}

# Main evolution command
run_evolution() {
    log_info "🌱 Starting evolution cycle: $EVOLUTION_TYPE"
    
    # Pre-evolution checks
    run_pre_evolution_check
    
    # Generate evolution prompt
    local evolution_prompt
    evolution_prompt=$(generate_evolution_prompt)
    
    # Run AI evolution simulation
    local evolution_branch
    evolution_branch=$(simulate_ai_evolution "$evolution_prompt")
    
    # Post-evolution tests
    if [[ "$RUN_TESTS" == "true" ]]; then
        log_info "🧪 Running post-evolution tests..."
        run_evolution_tests "post-evolution"
    fi
    
    # Generate final report
    log_info "📊 Generating evolution report..."
    generate_metrics_report "evolution-metrics.json" "markdown" "evolution-report-$(date +%Y%m%d-%H%M%S).md"
    
    log_success "🎉 Evolution cycle completed successfully!"
    log_info "Branch: $evolution_branch"
    log_info "Type: $EVOLUTION_TYPE"
    log_info "Intensity: $INTENSITY"
    log_info "Growth Mode: $GROWTH_MODE"
}

# Show current status
show_status() {
    log_info "📋 AI Evolution Engine Status"
    
    # Repository info
    echo
    log_info "Repository Information:"
    get_repo_info "summary"
    
    # Metrics summary
    echo
    log_info "Evolution Metrics:"
    if [[ -f "evolution-metrics.json" ]]; then
        generate_metrics_report "evolution-metrics.json" "summary"
    else
        log_warn "No metrics file found. Run 'setup' to initialize."
    fi
    
    # Environment status
    echo
    log_info "Environment Status:"
    validate_environment || log_warn "Environment validation issues detected"
}

# Setup command
setup_environment_command() {
    log_info "⚙️ Setting up AI Evolution Engine environment..."
    
    # Install dependencies
    install_dependencies
    
    # Initialize systems
    init_git_repo
    init_metrics
    
    # Setup GitHub authentication
    setup_github_auth || log_warn "GitHub CLI authentication not configured"
    
    # Run initial tests
    if [[ "$RUN_TESTS" == "true" ]]; then
        run_evolution_tests "setup"
    fi
    
    log_success "✅ Environment setup completed successfully!"
}

# Main execution function
main() {
    local command="${COMMAND:-evolve}"
    
    # Parse arguments
    parse_arguments "$@"
    
    # Initialize environment
    initialize_environment
    
    # Execute command
    case "$command" in
        "evolve")
            run_evolution
            ;;
        "analyze")
            analyze_repository_health
            ;;
        "test")
            run_evolution_tests "manual"
            ;;
        "metrics")
            if [[ -f "evolution-metrics.json" ]]; then
                generate_metrics_report "evolution-metrics.json" "markdown"
            else
                log_error "No metrics file found. Run evolution first."
                exit 1
            fi
            ;;
        "setup")
            setup_environment_command
            ;;
        "status")
            show_status
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
