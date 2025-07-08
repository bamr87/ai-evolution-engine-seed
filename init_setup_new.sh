#!/bin/bash
#
# @file init_setup.sh
# @description Modular AI Evolution Engine initialization script
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-07
# @version 0.4.0
#
# @relatedIssues 
#   - Complete modular refactoring for sustainable architecture
#
# @relatedEvolutions
#   - v0.4.0: Modular architecture initialization with cross-platform support
#   - v0.3.6: Documentation organization and workflow optimization
#   - v0.3.0: Growth simulation and basic setup
#
# @dependencies
#   - bash: >=3.2 (macOS/Linux compatibility)
#   - git: >=2.0
#   - Basic POSIX utilities (find, mkdir, chmod)
#
# @changelog
#   - 2025-07-07: Complete modular architecture setup - ITJ
#   - 2025-07-05: Enhanced with modular library bootstrap - ITJ
#   - 2025-07-01: Initial modular setup implementation - ITJ
#
# @usage ./init_setup.sh [--skip-deps] [--verbose] [--test]
# @notes Cross-platform initialization for modular AI Evolution Engine
#

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Initialize logging before loading modules
LOG_FILE="$PROJECT_ROOT/logs/init-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$PROJECT_ROOT/logs"

# Simple logging function for initialization
init_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

init_log "INFO" "🌱 AI Evolution Engine - Modular Architecture Initialization"
init_log "INFO" "=========================================================="

# Check for basic requirements
check_requirements() {
    init_log "INFO" "Checking system requirements..."
    
    # Check bash version
    if ! command -v bash >/dev/null 2>&1; then
        init_log "ERROR" "Bash is required but not found"
        exit 1
    fi
    
    local bash_version
    bash_version=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "unknown")
    init_log "INFO" "Bash version: $bash_version"
    
    # Check git
    if ! command -v git >/dev/null 2>&1; then
        init_log "ERROR" "Git is required but not found"
        exit 1
    fi
    
    local git_version
    git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "unknown")
    init_log "INFO" "Git version: $git_version"
    
    init_log "SUCCESS" "System requirements check passed"
}

# Create necessary directories
create_directories() {
    init_log "INFO" "Creating directory structure..."
    
    local directories=(
        "logs"
        "tests/logs"
        "tests/results"
        "src/lib/core"
        "src/lib/evolution"
        "src/lib/workflow"
        "src/lib/utils"
        "src/lib/integration"
        "src/lib/analysis"
        "src/lib/template"
        "docs/architecture"
        "docs/guides"
        "docs/evolution"
        "docs/workflows"
        ".github/workflows"
    )
    
    for dir in "${directories[@]}"; do
        if [[ ! -d "$PROJECT_ROOT/$dir" ]]; then
            mkdir -p "$PROJECT_ROOT/$dir"
            init_log "INFO" "Created directory: $dir"
        else
            init_log "INFO" "Directory exists: $dir"
        fi
    done
    
    init_log "SUCCESS" "Directory structure created"
}

# Set script permissions
set_permissions() {
    init_log "INFO" "Setting script permissions..."
    
    # Find and make executable all .sh files
    find "$PROJECT_ROOT" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
    
    # Specifically ensure key scripts are executable
    local key_scripts=(
        "init_setup.sh"
        "scripts/modular-evolution.sh"
        "scripts/simulate-ai-growth.sh"
        "scripts/apply-growth-changes.sh"
        "scripts/setup-environment.sh"
        "scripts/evolve.sh"
        "scripts/collect-context.sh"
        "scripts/generate_seed.sh"
        "scripts/analyze-repository-health.sh"
        "tests/comprehensive-modular-test.sh"
    )
    
    for script in "${key_scripts[@]}"; do
        if [[ -f "$PROJECT_ROOT/$script" ]]; then
            chmod +x "$PROJECT_ROOT/$script"
            init_log "INFO" "Made executable: $script"
        else
            init_log "WARN" "Script not found: $script"
        fi
    done
    
    init_log "SUCCESS" "Script permissions set"
}

# Initialize Git repository if needed
init_git() {
    init_log "INFO" "Initializing Git repository..."
    
    if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
        cd "$PROJECT_ROOT"
        git init
        init_log "INFO" "Git repository initialized"
        
        # Create initial .gitignore if it doesn't exist
        if [[ ! -f ".gitignore" ]]; then
            cat > .gitignore << 'EOF'
# Logs
logs/
*.log

# Dependencies
node_modules/
.npm

# Environment
.env
.env.local

# Test results
tests/results/
coverage/

# Temporary files
tmp/
temp/
.tmp/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
EOF
            init_log "INFO" "Created .gitignore"
        fi
    else
        init_log "INFO" "Git repository already exists"
    fi
    
    init_log "SUCCESS" "Git initialization complete"
}

# Test modular system
test_modular_system() {
    init_log "INFO" "Testing modular system..."
    
    # Test bootstrap loading
    if [[ -f "$PROJECT_ROOT/src/lib/core/bootstrap.sh" ]]; then
        init_log "INFO" "Testing bootstrap system..."
        
        # Create a simple test script
        cat > "$PROJECT_ROOT/test_bootstrap.sh" << 'EOF'
#!/bin/bash
set -euo pipefail
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
echo "Bootstrap test: SUCCESS"
EOF
        chmod +x "$PROJECT_ROOT/test_bootstrap.sh"
        
        if "$PROJECT_ROOT/test_bootstrap.sh" 2>/dev/null; then
            init_log "SUCCESS" "Bootstrap system test passed"
        else
            init_log "WARN" "Bootstrap system test failed (may need manual setup)"
        fi
        
        # Clean up test file
        rm -f "$PROJECT_ROOT/test_bootstrap.sh"
    else
        init_log "WARN" "Bootstrap system not found - manual setup may be required"
    fi
}

# Validate installation
validate_installation() {
    init_log "INFO" "Validating installation..."
    
    local validation_items=(
        "src/lib/core/bootstrap.sh:Bootstrap system"
        "src/lib/core/logger.sh:Logging system"
        "scripts/modular-evolution.sh:Modular evolution script"
        "tests/comprehensive-modular-test.sh:Test suite"
        "README.md:Documentation"
    )
    
    local missing_items=0
    
    for item in "${validation_items[@]}"; do
        local file_path="${item%%:*}"
        local description="${item##*:}"
        
        if [[ -f "$PROJECT_ROOT/$file_path" ]]; then
            init_log "INFO" "✓ $description found"
        else
            init_log "WARN" "✗ $description missing: $file_path"
            ((missing_items++))
        fi
    done
    
    if [[ $missing_items -eq 0 ]]; then
        init_log "SUCCESS" "Installation validation passed"
    else
        init_log "WARN" "Installation validation found $missing_items missing items"
    fi
}

# Main initialization function
main() {
    local skip_deps=false
    local verbose=false
    local run_tests=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-deps)
                skip_deps=true
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            --test)
                run_tests=true
                shift
                ;;
            --help|-h)
                echo "AI Evolution Engine - Modular Architecture Initialization"
                echo ""
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --skip-deps    Skip dependency checks"
                echo "  --verbose      Enable verbose output"
                echo "  --test         Run system tests after initialization"
                echo "  --help, -h     Show this help message"
                echo ""
                exit 0
                ;;
            *)
                init_log "ERROR" "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    init_log "INFO" "Starting AI Evolution Engine initialization..."
    init_log "INFO" "Project root: $PROJECT_ROOT"
    init_log "INFO" "Log file: $LOG_FILE"
    
    # Run initialization steps
    if [[ "$skip_deps" != "true" ]]; then
        check_requirements
    fi
    
    create_directories
    set_permissions
    init_git
    test_modular_system
    validate_installation
    
    # Run tests if requested
    if [[ "$run_tests" == "true" ]]; then
        init_log "INFO" "Running comprehensive system tests..."
        if [[ -f "$PROJECT_ROOT/tests/comprehensive-modular-test.sh" ]]; then
            if "$PROJECT_ROOT/tests/comprehensive-modular-test.sh" 2>&1 | tee -a "$LOG_FILE"; then
                init_log "SUCCESS" "System tests completed successfully"
            else
                init_log "WARN" "System tests completed with warnings or errors"
            fi
        else
            init_log "WARN" "Test suite not found"
        fi
    fi
    
    # Final success message
    init_log "SUCCESS" "🎉 AI Evolution Engine initialization complete!"
    echo ""
    echo "🌱 Next Steps:"
    echo "   1. Review the modular architecture in src/lib/"
    echo "   2. Run './scripts/modular-evolution.sh --help' to see evolution options"
    echo "   3. Execute './tests/comprehensive-modular-test.sh' to validate the system"
    echo "   4. Check the documentation in docs/ for detailed usage guides"
    echo ""
    echo "📋 Quick Start:"
    echo "   ./scripts/modular-evolution.sh --mode=sustainable"
    echo ""
    echo "📊 View logs: $LOG_FILE"
    echo ""
    init_log "INFO" "Happy evolving! 🚀"
}

# Run main function with all arguments
main "$@"
