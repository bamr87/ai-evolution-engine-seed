# Copilot Instructions

These instructions guide AI-powered development practices, focusing on programming standards, design patterns, and best practices across various technology stacks. The guidelines emphasize container-first development, ensuring all activities occur within isolated, reproducible environments. We prioritize Bash/Shell scripting due to its prevalence in the codebase, followed by Python and JavaScript/Node.js as accessible, open-source frameworks. For other languages or frameworks, extend these patterns analogously while adhering to core principles.

## Bash/Shell Scripting Standards and Design Patterns

### Naming Conventions
- Variables: Use lowercase with underscores (e.g., `my_variable`) to enhance readability and avoid conflicts.
- Constants: Use uppercase letters (e.g., `readonly MY_CONSTANT=value`) to signal immutability.
- Functions: Lowercase with underscores, descriptive of purpose (e.g., `process_input_data()`).
- Script Files: End with `.sh` extension; use meaningful, descriptive names (e.g., `deploy_application.sh`).

### Code Structure
- Shebang: Always start with `#!/bin/bash` or `#!/usr/bin/env bash` for portability.
- Strict Mode: Enable with `set -euo pipefail` to exit on errors, treat unset variables as errors, and prevent pipeline failures from going unnoticed.
- Modularization: Break code into functions; keep scripts under 200 lines where possible. Source reusable functions from a `lib/` directory (e.g., `source lib/utils.sh`).
- Comments and Headers: Include comprehensive inline comments. Adhere to file header standards (detailed in the Documentation Standards section) for every script, ensuring consistent metadata and documentation.

### Error Handling
- Traps: Use `trap cleanup_function ERR EXIT` for resource cleanup on errors or termination.
- Exit Status Checks: Explicitly check statuses (e.g., `command || { echo "Error: command failed"; exit 1; }`).
- Messages and Logging: Provide user-friendly error messages (e.g., `echo "Error: File not found at $path" >&2`). Log to stderr for errors and use a centralized logging function.

### Design Patterns
- **Modular Functions**: Encapsulate logic in reusable functions sourced from shared libraries to promote reuse across scripts.
- **Configuration Management**: Use associative arrays (e.g., `declare -A config`) or external config files (e.g., `.env` files loaded via `source`) for dynamic settings.
- **Logging Pattern**: Create a centralized logger function supporting levels (e.g., `log_info()`, `log_error()`) with timestamps and optional file output.
- **Idempotency**: Ensure scripts can run multiple times without side effects (e.g., check if a file exists before creating it).
- **Dependency Injection**: Pass paths, commands, or tools as parameters (e.g., `function process { local tool=$1; ... }`) instead of hardcoding.

### Best Practices
- Variables: Avoid globals; use `local` for function-scoped variables. Declare constants with `readonly`.
- Quoting: Always quote expansions (e.g., `"$variable"`) to prevent word splitting and globbing.
- Data Structures: Use arrays for lists (e.g., `files=(file1 file2)`) over space-separated strings.
- Portability: Adhere to POSIX standards; test on multiple shells (e.g., bash, sh).
- Security: Avoid `eval`; use secure practices like input sanitization.

## Python Standards and Design Patterns

### Naming Conventions
- Variables/Functions: snake_case (e.g., `process_data()`).
- Classes: CamelCase (e.g., `DataProcessor`).
- Constants: UPPER_CASE (e.g., `MAX_RETRIES = 5`).
- Compliance: Follow PEP 8 for style, including line length (79 characters) and indentation (4 spaces).

### Code Structure
- Entry Point: Use `if __name__ == '__main__':` for executable scripts to allow module imports.
- Organization: Structure into modules/packages (e.g., `src/utils/data.py`); use relative imports.
- Documentation: Include docstrings (Google or NumPy style) for functions, classes, and modules, describing parameters, returns, and examples. Adhere to file header standards for consistent metadata.

### Error Handling
- Exceptions: Use `try-except` for specific exceptions (e.g., `except ValueError as e:`); avoid bare `except`.
- Custom Exceptions: Define classes like `class AppError(Exception): pass` for domain-specific errors.
- Logging: Use `logging` module with tracebacks (e.g., `logging.exception("Error occurred")`); configure levels (debug, info, error).

### Design Patterns
- **Singleton**: Use metaclasses or modules for single instances (e.g., configuration managers).
- **Factory**: Abstract object creation (e.g., `def create_processor(type): return ProcessorA() if type == 'A' else ProcessorB()`).
- **Decorator**: Enhance functions (e.g., `@cache` for memoization).
- **MVC**: Separate concerns in apps (Model for data, View for UI, Controller for logic).
- **Observer**: Implement event systems (e.g., using callbacks or `asyncio` for async notifications).

### Best Practices
- Environments: Use `venv` or `poetry` for isolation; pin dependencies in `requirements.txt`.
- Typing: Add type hints (e.g., `def func(x: int) -> str:`); validate with `mypy`.
- Testing: Write unit tests with `pytest`; aim for >80% coverage.
- Output: Use `logging` over `print`; format logs consistently.
- Philosophy: Adhere to PEP 20 (e.g., "Simple is better than complex").

## JavaScript/Node.js Standards and Design Patterns

### Naming Conventions
- Variables/Functions: camelCase (e.g., `processData()`).
- Classes/Constructors: PascalCase (e.g., `DataProcessor`).
- Constants: UPPER_CASE (e.g., `MAX_RETRIES = 5`).

### Code Structure
- Modules: Use ES modules with `import/export`; organize into logical directories (e.g., `src/utils/`, `src/services/`).
- Documentation: Add JSDoc comments (e.g., `/** @param {string} input - The input data */`). Adhere to file header standards for consistent metadata.

### Error Handling
- Synchronous: Use `try-catch` (e.g., `try { ... } catch (err) { console.error(err); }`).
- Asynchronous: Handle promises with `.catch()` or `async/await` in `try-catch`; propagate errors.
- Custom Errors: Extend `Error` (e.g., `class AppError extends Error { constructor(msg) { super(msg); } }`).

### Design Patterns
- **Module Pattern**: Encapsulate code with IIFEs for private scopes.
- **Singleton**: Use modules or classes for singletons (e.g., exported object).
- **Factory**: Dynamic object creation (e.g., `function create(type) { return type === 'A' ? new A() : new B(); }`).
- **Observer/Pub-Sub**: Use `EventEmitter` for events.
- **Middleware**: In Express.js, chain functions (e.g., `app.use(loggerMiddleware)`).

### Best Practices
- Linting: Use ESLint with standard configs (e.g., Airbnb style).
- Async: Prefer `async/await` for readability; avoid callback hell.
- Packages: Manage with `npm` or `yarn`; lock versions in `package-lock.json`.
- Testing: Use Jest/Mocha for unit/integration tests; mock dependencies.
- Performance: Avoid blocking operations; use streams for large data.

## General Guidelines Across Stacks

Follow core principles: DRY (Don't Repeat Yourself), KIS (Keep It Simple), DFF (Design for Failure), REnO (Release Early and Often), MVP (Minimum Viable Product), COLAB (Collaboration), AIPD (AI-Powered Development), RFD (README-First Development), and SCD (Script-Centric Development). Ensure container-first development for all activities.

### Container-First Development (CFD)
- **Ephemeral Environments**: Run all development, testing, and deployment in containers for reproducibility.
- **Cross-Platform Compatibility**: Design for container portability; avoid OS-specific accommodations.
- **Local Machine Isolation**: Execute no scripts/tests directly on host; use Docker wrappers.
- **Infrastructure as Code**: Define environments via Dockerfiles, Compose, or Kubernetes manifests.
- **Stateless Operations**: Make processes stateless; use volumes for persistence.
- **Multi-Stage Builds**: Optimize images (e.g., build stage for dependencies, runtime for minimal footprint).
- **Orchestration**: Use Docker Compose for local, Kubernetes for production.
- **Volume Management**: Employ named volumes/bind mounts; document data persistence.
- **Network Isolation**: Secure networks; use policies for communication.
- **Resource Constraints**: Set CPU/memory limits/requests.
- **Health Checks**: Implement probes (e.g., HTTP endpoints or commands).
- **Logging Strategy**: Centralize logs (e.g., via ELK stack or container stdout).

### Design for Failure (DFF)
- Implement error handling, try-catch, and meaningful messages.
- Add redundancy (e.g., retries), fallbacks, and logging/monitoring.
- Consider edge cases; include container resilience (auto-restarts) and health monitoring.

### Don't Repeat Yourself (DRY)
- Extract reusable code into functions/modules.
- Refactor duplicates; use configs for constants.
- Employ templates for similar structures.

### Keep It Simple (KIS)
- Prioritize readable code; use descriptive names.
- Break down complex logic; avoid over-abstraction.

### Release Early and Often (REnO)
- Use incremental development, feature flags, and versioning.
- Integrate CI/CD in containers; use registries for artifacts.

### Minimum Viable Product (MVP)
- Focus on core features; iterate later.
- Start with simple containers, evolve to complex architectures.

### Collaboration (COLAB)
- Write self-documenting code; follow standards.
- Include READMEs; use semantic commits/PRs.

### AI-Powered Development (AIPD)
- Use AI for generation/review; balance with human oversight.
- Integrate AI for testing/documentation; document usage.

### README-First Development (RFD)
- Use README.md as primary context for AI/development.
- Document directories comprehensively; distinguish implemented vs. future features.
- Update before changes; optimize for AI comprehension.

### Script-Centric Development (SCD)
- Scripts in `scripts/` orchestrate workflows, relying on `src/` for functions.
- Design for container execution; provide Docker wrappers.

## Technology-Specific Guidelines

### Container Infrastructure Requirements
- **Docker Foundation**: Include Dockerfiles with multi-stage builds for dev/test/prod.
- **Composition**: Use Docker Compose for multi-service apps.
- **Cross-Platform**: Build multi-arch images (AMD64/ARM64).
- **Security**: Scan images; use minimal bases (e.g., Alpine).
- **Dependencies**: Manage in images; use registries.

### Containerized Development Workflows
- **Devcontainers**: Configure for VS Code/Codespaces with hot reload/debug.
- **Parity**: Ensure identical envs across stages.

### @azure Rule - Use Azure Best Practices
Invoke `azure_development-get_best_practices` tool for Azure-related operations.
- Integrate Azure Container Instances/Apps/Kubernetes; use Azure Container Registry.

### GitHub Models Prompt Format
- Use `.prompt.yml` files with structure: name, description, model (e.g., gpt-4o-mini), parameters, messages, testData, evaluators.
- Placeholders: `{{variable}}`.
- Reference: GitHub Models Documentation.

### Open Source Development
- Follow licensing; include attributions.
- Use standard structures; encourage contributions.

## Documentation Standards
- **Container-First**: Provide container-specific guidance; assume containerized envs.
- **Directory-Level**: Every directory must contain a README.md file that:
  - Purpose: Explains the directory's role in the project.
  - Contents: Lists and describes all files and subdirectories.
  - Usage: Provides examples of how to interact with the directory.
  - Features: Details implemented functionality.
  - Future Enhancements: Lists planned features with status (e.g., "Planned", "In Progress").
  - Integration: Describes how it connects to other parts of the project.
  - Container Context: Includes setup, ports, volumes, volumes, networks, and examples.
- **Organization**: Non-README.md/CHANGELOG.md Markdown files must be in `docs/` subdirectories (e.g., `docs/guides/`, `docs/reference/api/`). Use consistent naming (lowercase with hyphens) and cross-references.
- **Synchronization**: Update documentation concurrently with code changes. Use sections for technical accuracy and validation.
- **General Standards**: Include installation (container-based), usage, contribution guidelines. Add inline comments for logic; generate API/user guides. Maintain CHANGELOG.md at root with semantic versioning).
- **Container-Specific**: Document ports (e.g., "Exposed: 8080/tcp for API"), volumes (e.g., "/app/data: persistent data"), environment variables, networks, resources (e.g., "Min CPU: 1 vCPU, Memory: 512MiB"), security, and health checks (e.g., "CMD: curl -f /health").

### Automatic Documentation Generation
- Run tools (e.g., JSDoc, shdoc) in containers to generate MD from comments.
- Store in `docs/`; validate for completeness/bidirectionality.
- Generate for configs/orchestration; ensure examples container-agnostic.

## Testing Approaches

### Container-Based Testing Strategy
- Run tests in isolated containers; create dedicated images.
- Orchestrate integration/E2E; manage data via volumes.
- Parallelize; ensure cross-platform.

### Testing Framework Integration
- Unit/integration/E2E/performance/security tests in containers matching prod.

### Test Execution and Reporting
- Orchestrate runs; generate reports; integrate into CI/CD; cleanup.

## Code Quality Standards

### Container Security Best Practices
- Secure bases; scan vulnerabilities; run as non-root; manage secrets; secure networks; sign images; monitor runtime.

### Performance Considerations
- Optimize readability; use caching; monitor; minimize layers/resources.

### Accessibility & Inclusivity
- Follow WCAG; inclusive language; i18n/l10n; test assistive tech.

## Learning & Education Focus

### Beginner-Friendly Approach
- Explain simply; steps/resources/exercises.
- Introduce containers early; hands-on.

### Real-World Applications
- Practical examples; theory/practice.
- Containerized projects; prod patterns.

### Community Learning
- Reviews/forums; share container configs.

## AI Integration Guidelines

### AI-Assisted Container Development
- AI for configs/optimization/security.
- Run tools in containers; constraint-aware.

### Best Practices for AI Tools
- Clear context; review; document.
- Templates/feedback.

### Post-AI Prompt Cycle Validation
- Run `post-ai-validation.sh`; check configs/docs.
- Address errors; refine.

## Container Development Workflows

### Development Environment Setup
- Devcontainers/Compose; hot reload/ports/envs/tools.

### Container Lifecycle Management
- Automate builds/tagging/cleanup/scanning/updates.

### Monitoring and Observability
- Metrics/logs/tracing; health/alerting.

## File Header Standards

### Universal File Header Requirements
Every file MUST begin with a commented header containing standardized metadata. This applies to all types: source code (e.g., .py, .js, .sh), configuration (e.g., .yaml, .json), documentation (e.g., .md), scripts, templates, and others. 

**Exceptions**: 
- `.prompt.yml` or `.prompt.yaml` files follow GitHub Models format without custom headers.
- Binary files (e.g., images, executables) are exempt.

Headers use language-appropriate comment syntax (e.g., `/** */` for JS, `""" """` for Python, `#` for Shell/YAML). All fields are required unless marked optional; use "N/A" or "TBD" if not applicable. Fields must appear in the specified order. Lists (e.g., @relatedIssues) use bullet points with "- " prefix. Dates use YYYY-MM-DD format. Versions follow semantic versioning (major.minor.patch) or iteration number (e.g., v1.0.0).

### Header Template Structure
```
/**
 * @file [filename.ext] - Exact file name including extension.
 * @description [Brief one-sentence description of the file's purpose and primary functionality. Be concise yet informative.]
 * @author [Full Name or Team] <[email@domain.com]> - Creator or maintaining team; use consistent format.
 * @created [YYYY-MM-DD] - Date of initial creation.
 * @lastModified [YYYY-MM-DD] - Date of last update; update on every change.
 * @version [semantic.version or iteration.number] - Current version; increment on changes (e.g., 1.0.0 for initial, 1.0.1 for patches).
 * 
 * @relatedIssues 
 *   - #[issue-number]: [Brief description of related GitHub issue or ticket.]
 *   - #[issue-number]: [Another description.] (List at least one if applicable; use "N/A" if none.)
 * 
 * @relatedEvolutions
 *   - [evolution-cycle or version]: [Description of changes in AI/evolution cycles or major updates.]
 *   - [evolution-cycle]: [Another description.] (Document iterative improvements; "N/A" if none.)
 * 
 * @dependencies
 *   - [dependency-name]: [version or brief description, e.g., lodash: ^4.17.21.]
 *   - [dependency-name]: [Another.] (List external libraries/tools; "N/A" if none.)
 * 
 * @containerRequirements
 *   - baseImage: [Base container image and tag, e.g., node:18-alpine.]
 *   - exposedPorts: [Comma-separated list, e.g., 3000/tcp, 8080.]
 *   - volumes: [List of mounts, e.g., /app/data:rw.]
 *   - environment: [Required vars, e.g., NODE_ENV=production, LOG_LEVEL=info.]
 *   - resources: [Limits/requests, e.g., CPU: 0.5, Memory: 512MiB.]
 *   - healthCheck: [Command or endpoint, e.g., GET /health or curl -f http://localhost/health.] (All subfields required; "N/A" if not container-relevant.)
 * 
 * @changelog
 *   - [YYYY-MM-DD]: [Description of change] - [Author initials or name.]
 *   - [YYYY-MM-DD]: [Another change] - [Initials.]
 *   - [YYYY-MM-DD]: Initial creation - [Initials.] (At least one entry; add new at top.)
 * 
 * @usage [Brief example of how to use/invoke the file, e.g., node script.js --input file.txt. Include container context if applicable.]
 * @notes [Optional additional info, warnings, or TODOs. Use "N/A" if empty.]
 */
```

### Language-Specific Header Examples

#### JavaScript/TypeScript Files
```javascript
/**
 * @file utils/dataProcessor.js
 * @description Utility functions for processing and transforming data structures in a performant manner.
 * @author IT-Journey Team <team@it-journey.org>
 * @created 2025-07-05
 * @lastModified 2025-07-16
 * @version 1.2.0
 * 
 * @relatedIssues 
 *   - #145: Implement data validation pipeline.
 *   - #167: Add error handling for malformed data.
 * 
 * @relatedEvolutions
 *   - v0.3.0: Enhanced error handling and validation.
 *   - v0.2.1: Added support for nested object processing.
 * 
 * @dependencies
 *   - lodash: ^4.17.21
 *   - joi: ^17.9.2
 * 
 * @containerRequirements
 *   - baseImage: node:18-alpine
 *   - exposedPorts: 3000/tcp
 *   - volumes: /app/data:rw
 *   - environment: NODE_ENV=production, LOG_LEVEL=debug
 *   - resources: CPU: 0.5, Memory: 512MiB
 *   - healthCheck: GET /health
 * 
 * @changelog
 *   - 2025-07-16: Updated validation logic for edge cases - ITJ
 *   - 2025-07-05: Added input sanitization functions - ITJ
 *   - 2025-07-01: Initial creation - ITJ
 * 
 * @usage docker run -p 3000:3000 data-processor:latest process --file input.json
 * @notes Ensure all input data is validated before processing; optimized for containerized environments.
 */
```

#### Python Files
```python
"""
@file data_analyzer.py
@description Machine learning data analysis and visualization tools with support for large datasets.
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-16
@version 2.1.0

@relatedIssues 
  - #234: Implement advanced analytics dashboard.
  - #245: Add support for real-time data streams.

@relatedEvolutions
  - v2.1.0: Added real-time processing capabilities.
  - v2.0.0: Complete rewrite with pandas integration.

@dependencies
  - pandas: >=1.5.0
  - numpy: >=1.24.0
  - matplotlib: >=3.6.0

@containerRequirements
  - baseImage: python:3.11-slim
  - exposedPorts: 8080/tcp, 8081/udp
  - volumes: /app/data:rw, /app/models:ro
  - environment: PYTHONPATH=/app/src, DATA_SOURCE_URL=http://db:5432
  - resources: CPU: 1.0, Memory: 2GiB
  - healthCheck: GET /api/health

@changelog
  - 2025-07-16: Optimized memory usage for large datasets - ITJ
  - 2025-07-05: Added streaming data support - ITJ
  - 2025-06-28: Initial creation - ITJ

@usage docker run -p 8080:8080 -v ./data:/app/data data-analyzer:latest analyze --mode real-time
@notes Requires Python 3.9+; designed for stateless container deployment.
"""
```

#### Shell Scripts
```bash
#!/bin/bash
#
# @file deploy.sh
# @description Automated deployment script for production environments with rollback support.
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-16
# @version 1.0.0
#
# @relatedIssues 
#   - #198: Automate production deployment process.
#   - #201: Add rollback functionality.
#
# @relatedEvolutions
#   - v1.0.0: Initial automated deployment implementation.
#
# @dependencies
#   - docker: >=20.10.0
#   - kubectl: >=1.25.0
#
# @containerRequirements
#   - baseImage: alpine:3.18
#   - exposedPorts: N/A
#   - volumes: /var/run/docker.sock:/var/run/docker.sock:rw, /root/.kube:ro
#   - environment: KUBECONFIG=/root/.kube/config, DOCKER_HOST=unix:///var/run/docker.sock
#   - resources: CPU: 0.2, Memory: 256MiB
#   - healthCheck: kubectl cluster-info
#
# @changelog
#   - 2025-07-16: Added dry-run option - ITJ
#   - 2025-07-05: Initial creation with basic deployment logic - ITJ
#
# @usage docker run -v /var/run/docker.sock:/var/run/docker.sock deployer:latest deploy --env prod --version 1.0.0
# @notes Requires kubectl context and docker auth; executes in ephemeral containers.
#
```

#### YAML/Configuration Files
```yaml
# @file docker-compose.yml
# @description Docker Compose configuration for development environment with multi-service setup.
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-16
# @version 1.3.0
#
# @relatedIssues 
#   - #156: Standardize development environment setup.
#   - #178: Add database persistence for local development.
#
# @relatedEvolutions
#   - v1.3.0: Added Redis cache and volume persistence.
#   - v1.2.0: Integrated development database.
#
# @dependencies
#   - docker: >=20.10.0
#   - docker-compose: >=2.0.0
#
# @containerRequirements
#   - baseImage: postgres:15, redis:7-alpine, nginx:alpine
#   - exposedPorts: 5432/tcp, 6379/tcp, 80/tcp, 443/tcp
#   - volumes: postgres_data:rw, redis_data:rw, app_uploads:ro
#   - environment: POSTGRES_DB=dev, POSTGRES_USER=user, POSTGRES_PASSWORD=pass, REDIS_URL=redis://redis:6379
#   - resources: CPU: 2.0 total, Memory: 4GiB total
#   - healthCheck: pg_isready -U user -d dev; redis-cli ping; nginx -t /health
#
# @changelog
#   - 2025-07-16: Added health checks for services - ITJ
#   - 2025-07-05: Added Redis service configuration - ITJ
#   - 2025-07-01: Initial creation - ITJ
#
# @usage docker-compose up -d --build
# @notes Ensure Docker Desktop running; all services containerized with parity to prod.
```

#### Markdown Files (non-README)
```markdown
---
file: project-overview.md
description: Comprehensive overview of project architecture, goals, and high-level design decisions.
author: IT-Journey Team <team@it-journey.org>
created: 2025-07-05
lastModified: 2025-07-16
version: 2.0.0

relatedIssues:
  - "#123: Update project documentation."
  - "#134: Clarify architecture decisions."

relatedEvolutions:
  - "v2.0.0: Major restructure with new sections."
  - "v1.5.0: Added technical specifications."

dependencies:
  - "Jekyll: >=4.0.0 (for rendering if used)."

containerRequirements:
  baseImage: jekyll/jekyll:4.0
  exposedPorts: 4000/tcp
  volumes: /srv/jekyll:rw, /usr/gem:ro
  environment: JEKYLL_ENV=production
  resources: "CPU: 0.5, Memory: 512MiB"
  healthCheck: "curl -f http://localhost:4000/health"

changelog:
  - "2025-07-16: Updated diagrams for clarity - ITJ"
  - "2025-07-05: Added new architecture diagrams - ITJ"
  - "2025-06-30: Initial creation - ITJ"

usage: "docker run -p 4000:4000 -v $(pwd):/srv/jekyll jekyll/jekyll:4.0 jekyll serve --host 0.0.0.0"
notes: "Synchronize with implementation; builds in containerized env."
---
```

#### Additional File Types (Extend as Needed)
For other types (e.g., JSON, HTML, CSS):
- Use comment syntax (e.g., /* */ for CSS, // for JSON if allowed, or leading comment block).
- Follow the template exactly, adapting syntax.

### Header Maintenance Requirements

#### Creation Standards
- Include complete header in every new file before content.
- Required fields mandatory; lists require at least "N/A" entry if empty.
- Use consistent formatting: Indent sub-items with 2-4 spaces; no trailing spaces.

#### Update Obligations
- Update @lastModified on any change (content or header).
- Increment @version: Patch for minor, minor for features, major for breaking.
- Add @changelog entry at top: Date, description (start with verb, e.g., "Added..."), initials.
- Link new @relatedIssues/@relatedEvolutions as relevant.
- Review @description/@usage for accuracy post-change.

#### Validation and Compliance
- Pre-commit hooks validate header presence/format/completeness.
- CI/CD pipelines fail on missing/invalid headers.
- Code reviews check accuracy (e.g., dates match commits).
- Automated tools (e.g., scripts in containers) assist updates/audits.
- Quarterly audits ensure currency.

### Integration with AI Evolution Engine
- Document @relatedEvolutions for AI cycles (e.g., "cycle-3: AI-refactored for performance").
- AI agents auto-update headers on modifications.
- Maintain cross-file relationships in headers.
- Use headers as context for AI-generated code/docs.

## Deployment Guidelines

### Container-First Deployment
- Orchestration for immutable/blue-green/canary/rollback; service mesh/auto-scaling.

### Environment Management
- Parity via configs/vars/resources/networks/monitoring.

### Infrastructure as Code
- Define/version configs; automate pipelines.

## Migration and Legacy System Integration

### Container Migration Strategy
- Gradual; wrap legacies; data/config/testing/rollback.

### Hybrid Environment Management
- Gateways/discovery/security/monitoring; gradual replacement.