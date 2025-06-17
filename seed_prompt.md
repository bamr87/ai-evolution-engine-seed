# 🌱 AI-Agent Super Seed Prompt v2.1: Fully Autonomous & Context-Aware Repository Evolution System 🌱

## 1. Overview & Purpose

You are an advanced AI agent tasked with generating the foundational components for a GitHub repository that is not just interactive but **autonomously self-evolving**. This repository will leverage an AI agent (external to the workflow, called via API) that takes the **entire repository context** to make intelligent decisions about its own evolution, including code changes, documentation updates, structural modifications, and even meta-improvements to its own evolution process.

This v2.1 evolution includes critical stability improvements and enhanced error handling to ensure robust operation of the AI evolution engine.

Each significant evolution will occur in a new, dedicated branch with semantic versioning considerations, ensuring a traceable, reviewable, and rollback-capable history. The system should be sophisticated enough to handle complex transformations while remaining accessible to users of varying technical backgrounds.

## 2. Core Principles & Advanced Features

### 2.1 Foundational Principles
*   **Autonomous Evolution:** The system should be capable of evolving with minimal human intervention beyond providing high-level prompts or goals.
*   **Full Repository Context:** The AI agent guiding the evolution will receive a comprehensive snapshot of the entire repository to make informed decisions.
*   **Traceable Changes:** Evolutions are isolated into timestamped and descriptively named branches, allowing for review before integration.
*   **Self-Updating Documentation:** The `README.md` is a living document, updated by the AI as the repository evolves, reflecting new features, structure, and usage instructions.
*   **Extensibility:** The initial setup should be a robust foundation, designed for future enhancements in AI interaction, context handling, and workflow capabilities.

### 2.2 Advanced Features to Implement
*   **Multi-Model AI Support:** Configuration for different AI providers (OpenAI, Anthropic, Google, local models)
*   **Evolution Strategies:** Different evolution modes (conservative, experimental, refactor-focused)
*   **Semantic Versioning:** AI-aware version bumping based on change impact
*   **Change Impact Analysis:** AI assessment of how changes affect the overall system
*   **Rollback Capabilities:** Easy reversion of unsuccessful evolutions
*   **Evolution Metrics:** Track success/failure rates, common patterns, and improvement areas
*   **Self-Healing:** AI can detect and fix its own errors or inconsistencies

## 3. Repository Meta-Information

*   **Intended Repository Owner:** `bamr87`
*   **Target Initialization Timestamp (UTC):** `2025-06-14 04:26:26`
* **This Seed Prompt Version:** `2.1`
* **Seed Prompt Last Updated:** `2025-06-16 20:30:00 UTC`
*   **Default Repository Name:** `ai-evolution-engine`
*   **Initial Version:** `0.1.0`

## 4. Required Deliverables with Enhanced Specifications

### 4.1. `README.md` (The Living Manual & Evolution Chronicle)

Create a comprehensive, visually appealing Markdown document with:

#### Structure Requirements:

1. **Header Section:**
   - Eye-catching ASCII art or emoji banner
   - Dynamic badges (version, build status, last evolution, etc.)
   - One-line description and expanded vision statement

2. **Table of Contents:**
   - Auto-generated with links to all major sections
   - Collapsible for better navigation

3. **Quick Start Guide:**
   - 5-minute setup process
   - Prerequisites checker
   - One-command initialization option

4. **Detailed Sections:**

   **Introduction & Philosophy:**
   - The concept of self-evolving repositories
   - Benefits and use cases
   - Comparison with traditional development workflows
   - Mermaid diagrams showing the evolution flow

   **Architecture Overview:**
   - System components diagram
   - Data flow visualization
   - Security considerations
   - Performance considerations

   **Installation & Configuration:**
   - Multiple installation methods (script, manual, Docker)
   - Configuration options explained
   - Troubleshooting guide
   - Health check procedures

   **Usage Guide:**
   - Basic evolution cycles
   - Advanced prompt engineering
   - Evolution strategies and modes
   - Best practices and anti-patterns

   **AI Integration:**
   - Supported AI models and providers
   - Custom model integration guide
   - Token usage optimization
   - Cost estimation tools

   **Evolution Management:**
   - Branch naming conventions
   - Merge strategies
   - Conflict resolution
   - Rollback procedures

   **Examples & Tutorials:**
   - Step-by-step evolution examples
   - Common evolution patterns
   - Case studies

   **API Reference:**
   - Workflow inputs/outputs
   - Environment variables
   - Secret management
   - Extension points

   **Contributing:**
   - How to contribute to the evolution engine itself
   - Community guidelines
   - Evolution prompt templates

   **Changelog & Evolution History:**
   - Semantic versioning explanation
   - Detailed evolution log with:
     - Timestamp
     - Version change
     - Summary of changes
     - Impact assessment
     - Success metrics

   **FAQ & Troubleshooting:**
   - Common issues and solutions
   - Performance optimization tips
   - Security best practices

   **Appendices:**
   - Glossary of terms
   - Related projects and resources
   - Academic papers and inspiration

### 4.2. `init_setup.sh` (The Enhanced Genesis Script)

Create a sophisticated, user-friendly bash script with:

#### Features:

1. **Interactive Mode vs Silent Mode:**
   - Full interactive setup with guided prompts
   - Silent mode with environment variables or config file
   - Dry-run option to preview actions

2. **Dependency Management:**
   - Check for required tools (git, gh, jq, curl, etc.)
   - Offer to install missing dependencies (where possible)
   - Version compatibility checks

3. **Multi-Platform Support:**
   - Detect OS (Linux, macOS, WSL)
   - Platform-specific adjustments
   - Docker option for consistency

4. **Advanced Configuration:**
   - Multiple AI provider presets
   - Custom endpoint configuration
   - Rate limiting settings
   - Retry policies
   - Webhook configurations

5. **Security Enhancements:**
   - Encrypted local credential storage option
   - SSH key generation for Git operations
   - GPG signing setup
   - Security audit checklist

6. **Initial Repository Setup:**
   - Create comprehensive directory structure
   - Initialize with example code in multiple languages
   - Set up pre-commit hooks
   - Configure branch protection rules (via API)

7. **Validation & Testing:**
   - Test AI API connectivity
   - Validate GitHub permissions
   - Run initial health check
   - Generate setup report

8. **Post-Setup Actions:**
   - Optional immediate test evolution
   - Schedule first automated evolution
   - Set up monitoring/alerts
   - Generate setup documentation

### 4.3. `.github/workflows/ai_evolver.yml` (The Sophisticated Evolution Engine)

Create an advanced GitHub Actions workflow with:

#### Enhanced Features:

1. **Multiple Trigger Mechanisms:**
   - Manual with rich parameter options
   - Scheduled (cron) with configurable frequency
   - Event-based (issues, PRs with specific labels)
   - Webhook-triggered
   - Repository dispatch events

2. **Advanced Context Collection:**
   - Intelligent file filtering (respect .gptignore)
   - Dependency graph analysis
   - Test coverage reports
   - Performance metrics
   - Issue/PR context
   - Commit history analysis
   - Code complexity metrics

3. **AI Interaction Enhancements:**
   - Multi-model support with fallback
   - Streaming responses for large changes
   - Token usage optimization
   - Cost tracking and limits
   - Response caching for similar prompts
   - A/B testing different models

4. **Evolution Strategies:**
   - Conservative: Minimal, safe changes
   - Balanced: Standard evolution mode
   - Experimental: Allow breaking changes
   - Refactor: Focus on code quality
   - Performance: Optimize for speed/efficiency
   - Security: Focus on vulnerability fixes

5. **Change Application Intelligence:**
   - Syntax validation before applying
   - Unit test generation for new code
   - Automatic formatting and linting
   - Dependency updates
   - Migration scripts for breaking changes

6. **Quality Assurance:**
   - Run existing tests
   - Generate new tests
   - Security scanning
   - Performance benchmarking
   - Code quality metrics
   - Documentation completeness check

7. **Advanced Branching:**
   - Semantic branch naming
   - Automatic PR creation with detailed description
   - Review assignment based on code ownership
   - Conflict detection and AI-assisted resolution
   - Change preview deployments

8. **Monitoring & Observability:**
   - Detailed logs with log levels
   - Metrics collection (evolution time, success rate)
   - Error tracking and alerting
   - Evolution analytics dashboard
   - Cost tracking and optimization

9. **Rollback & Recovery:**
   - Automatic rollback on test failure
   - Checkpoint creation before changes
   - Disaster recovery procedures
   - Evolution undo capability

### 4.4. `prompts/` Directory Structure

Create a comprehensive prompt template system:

1. **`prompts/README.md`** - Guide to writing effective prompts
2. **`prompts/templates/`** - Reusable prompt templates:
   - `feature_request.md`
   - `bug_fix.md`
   - `refactor.md`
   - `documentation.md`
   - `performance.md`
   - `security.md`
3. **`prompts/examples/`** - Concrete examples:
   - `add_api_endpoint.md`
   - `implement_caching.md`
   - `upgrade_dependencies.md`
   - `add_docker_support.md`

### 4.5. Additional Configuration Files

1. **`.gptignore`** - Files to exclude from AI context
2. **`.evolution.yml`** - Evolution configuration:
   ```yaml
   version: 1.0
   evolution:
     default_strategy: balanced
     max_tokens_per_evolution: 100000
     require_tests: true
     auto_merge_threshold: 0.95
   ai:
     providers:
       - name: openai
         model: gpt-4
         temperature: 0.7
       - name: anthropic
         model: claude-3-opus
         temperature: 0.6
   ```

3. **`evolution-metrics.json`** - Tracking evolution success
4. **`.github/ISSUE_TEMPLATE/evolution_request.yml`** - Template for evolution requests via issues
5. **`.github/CODEOWNERS`** - Define ownership for automated reviews

## 5. Enhanced AI Agent Behavior Guidance

The AI receiving the workflow context should:

### Response Format:
```json
{
  "evolution_id": "uuid",
  "timestamp": "ISO-8601",
  "version_bump": "major|minor|patch",
  "new_branch_name_suffix": "descriptive-suffix",
  "commit_message": "Conventional commit format message",
  "pr_title": "Clear PR title",
  "pr_body": "Detailed PR description with checklist",
  "impact_assessment": {
    "breaking_changes": [],
    "new_features": [],
    "improvements": [],
    "fixes": [],
    "risk_level": "low|medium|high"
  },
  "file_changes": [
    {
      "path": "relative/path",
      "content": "file content or base64",
      "action": "create|update|delete",
      "language": "detected language",
      "tests_required": true
    }
  ],
  "test_files": [],
  "documentation_updates": [],
  "migration_guide": "if breaking changes",
  "readme_update": {
    "changelog_entry": "formatted changelog",
    "sections_to_update": []
  },
  "post_evolution_tasks": [
    "Run specific commands",
    "Update external services"
  ],
  "metrics": {
    "complexity_change": 0,
    "test_coverage_change": 0,
    "documentation_completeness": 0
  }
}
```

### Behavioral Guidelines:
1. Always maintain backward compatibility unless explicitly requested
2. Generate comprehensive tests for new functionality
3. Update documentation in sync with code changes
4. Follow established coding patterns in the repository
5. Optimize for readability and maintainability
6. Consider security implications of all changes
7. Provide detailed rationale for significant decisions
8. Suggest follow-up evolutions when appropriate

## 6. Success Criteria

The generated repository should:
1. Be immediately functional after running `init_setup.sh`
2. Successfully complete a test evolution cycle
3. Have comprehensive documentation that a new user can follow
4. Include error handling for common failure scenarios
5. Support multiple AI providers out of the box
6. Scale from simple scripts to complex applications
7. Maintain a clear audit trail of all evolutions
8. Enable rollback of any evolution
9. Provide cost visibility and controls
10. Foster a community of users and contributors

## 7. Testing & Validation

Include in the initial setup:
1. **Smoke tests** - Verify basic functionality
2. **Integration tests** - Test workflow end-to-end
3. **Example evolutions** - Pre-written evolution cycles to try
4. **Validation checklist** - Manual verification steps
5. **Performance benchmarks** - Baseline metrics

## 8. Future Roadmap Suggestions

The AI should propose innovative enhancements such as:
1. Multi-repository evolution orchestration
2. AI pair programming mode
3. Evolution marketplace for sharing patterns
4. Visual evolution designer
5. Real-time collaboration on evolutions
6. Evolution impact prediction
7. Automated evolution scheduling based on metrics
8. Cross-repository knowledge sharing
9. Evolution simulation/dry-run with full preview
10. Natural language voice-commanded evolutions
