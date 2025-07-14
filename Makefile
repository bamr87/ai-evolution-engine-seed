# AI Evolution Engine - Makefile
# Simplified commands for common operations

.PHONY: help test test-unit test-integration clean init setup

# Default target
help:
	@echo "AI Evolution Engine - Available Commands:"
	@echo ""
	@echo "Testing:"
	@echo "  make test              - Run comprehensive test suite with AI analysis"
	@echo "  make test-original     - Run tests with original test runner"
	@echo "  make test-unit         - Run only unit tests"
	@echo "  make test-integration  - Run only integration tests"
	@echo "  make test-workflow     - Run only GitHub Actions workflow tests"
	@echo "  make test-verbose      - Run comprehensive tests with verbose output"
	@echo "  make test-with-reports - Run tests with human-readable reports"
	@echo "  make test-ai-analysis  - Run tests with full AI analysis and issue creation"
	@echo ""
	@echo "Setup:"
	@echo "  make init              - Initialize the repository"
	@echo "  make setup             - Set up development environment"
	@echo "  make clean             - Clean temporary files"
	@echo ""
	@echo "Templates:"
	@echo "  make template-testing  - Initialize testing automation template"
	@echo ""
	@echo "Evolution:"
	@echo "  make evolve            - Run default evolution cycle (consistency, minimal)"
	@echo "  make evolve-docs       - Update documentation (moderate intensity)"
	@echo "  make evolve-quality    - Improve code quality (moderate intensity)"
	@echo "  make evolve-security   - Apply security updates (minimal intensity)"
	@echo "  make evolve-custom     - Run custom evolution (set PROMPT variable)"
	@echo "  make evolve-dry-run    - Preview evolution changes without applying"
	@echo ""

# Testing commands
test:
	@echo "🧪 Running comprehensive test suite..."
	@./tests/comprehensive_test_runner.sh

test-original:
	@echo "🧪 Running tests with original runner..."
	@./tests/run_tests.sh

test-unit:
	@echo "🔬 Running unit tests..."
	@./tests/run_tests.sh run unit

test-integration:
	@echo "🔗 Running integration tests..."
	@./tests/run_tests.sh run integration

test-workflow:
	@echo "⚙️ Running GitHub Actions workflow tests..."
	@./tests/run_tests.sh run workflow

test-verbose:
	@echo "🔊 Running comprehensive tests with verbose output..."
	@./tests/comprehensive_test_runner.sh --verbose

test-with-reports:
	@echo "📊 Running tests with human-readable reports..."
	@./tests/comprehensive_test_runner.sh --human-reports

test-ai-analysis:
	@echo "🤖 Running tests with AI analysis and issue creation..."
	@./tests/comprehensive_test_runner.sh --verbose --human-reports --create-issues

# Setup commands
init:
	@echo "🌱 Initializing AI Evolution Engine..."
	@chmod +x ./init_setup.sh
	@./init_setup.sh

setup: init
	@echo "⚙️ Setting up development environment..."
	@chmod +x ./tests/test_runner.sh
	@chmod +x ./scripts/*.sh
	@echo "✅ Setup complete!"

clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -name "*.tmp" -delete
	@find . -name "*.log" -delete
	@find . -name ".DS_Store" -delete
	@echo "✅ Cleanup complete!"

# Template commands
template-testing:
	@echo "🧪 Initializing testing automation template..."
	@cd templates/testing-automation && ./testing_automation_init.sh

# Development helpers
check-structure:
	@echo "📁 Checking repository structure..."
	@./tests/test_runner.sh --type unit

validate:
	@echo "✅ Running validation checks..."
	@make test
	@echo "🎉 All validations passed!"

# Advanced commands
docs:
	@echo "📚 Opening documentation..."
	@open docs/README.md 2>/dev/null || cat docs/README.md

structure:
	@echo "📁 Repository structure:"
	@tree -I 'node_modules|.git|_site' -a

# Quick start
quickstart: setup test
	@echo "🚀 AI Evolution Engine is ready!"
	@echo "📖 Read docs/ORGANIZATION.md for detailed information"
	@echo "🧪 Run 'make test' to verify everything is working"

# Evolution commands
evolve:
	@echo "🌱 Running default evolution cycle..."
	@./scripts/evolve.sh --type consistency --intensity minimal

evolve-docs:
	@echo "📚 Updating documentation..."
	@./scripts/evolve.sh --type documentation --intensity moderate

evolve-quality:
	@echo "⚡ Improving code quality..."
	@./scripts/evolve.sh --type code_quality --intensity moderate

evolve-security:
	@echo "🔒 Applying security updates..."
	@./scripts/evolve.sh --type security_updates --intensity minimal

evolve-custom:
	@if [ -z "$(PROMPT)" ]; then \
		echo "❌ Error: PROMPT variable is required for custom evolution"; \
		echo "Usage: make evolve-custom PROMPT='your custom prompt here'"; \
		exit 1; \
	fi
	@echo "🎯 Running custom evolution: $(PROMPT)"
	@./scripts/evolve.sh --type custom --prompt "$(PROMPT)"

evolve-dry-run:
	@echo "🔍 Previewing evolution changes (dry run)..."
	@./scripts/evolve.sh --type consistency --intensity minimal --dry-run

evolve-force:
	@echo "🚀 Force running evolution cycle..."
	@./scripts/evolve.sh --type consistency --intensity minimal --force-run
