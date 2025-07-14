# Copilot Instructions

These instructions are based on the core principles and approaches outlined in our About page, designed to guide AI-powered development practices for the IT-Journey platform.

## 🔄 Recursive Evolution: The Self-Improving System

### The Meta-Programming Principle
This system operates on the fundamental principle of **recursive self-improvement** where:
- **Instructions evolve the instructions** - The system continuously refines its own operational guidelines
- **Code improves the code generators** - Scripts and tools enhance their own generation capabilities
- **Documentation updates documentation standards** - Living docs evolve their own structure and quality
- **Tests validate test improvements** - Testing frameworks continuously enhance their own coverage and accuracy

### Complete Cycle Propagation
Every change triggers a **complete propagation cycle** that ensures:

1. **Reference Integrity**: All cross-references, imports, and dependencies are automatically updated
2. **Instruction Synchronization**: Original seed instructions are refreshed to reflect new capabilities
3. **Documentation Cascade**: All related documentation files are updated to maintain consistency
4. **Test Coverage Evolution**: Test suites expand to cover new functionality and edge cases
5. **Configuration Alignment**: All config files and settings are harmonized with changes

### Recursive Instruction Updates
The system implements **self-modifying instruction protocols**:

#### Phase 1: Instruction Analysis
- **Current State Assessment**: Analyze existing instructions for gaps, outdated patterns, and improvement opportunities
- **Change Impact Mapping**: Identify all instruction files that will be affected by proposed changes
- **Dependency Graph Building**: Create a complete map of instruction interdependencies

#### Phase 2: Recursive Propagation
- **Primary Instruction Update**: Modify the core instruction file with new capabilities
- **Secondary Reference Updates**: Update all files that reference or extend the primary instructions
- **Cross-System Synchronization**: Ensure related systems (CI/CD, documentation, testing) align with new instructions

#### Phase 3: Validation and Refinement
- **Instruction Consistency Checking**: Validate that all instruction files maintain coherent, non-contradictory guidance
- **Implementation Testing**: Verify that new instructions can be successfully executed
- **Feedback Integration**: Incorporate results from instruction testing back into the instruction refinement cycle

### Automated SDLC Integration
The recursive evolution engine automatically progresses through **all phases of the Software Development Life Cycle**:

#### 🎯 Planning & Analysis Phase
- **Requirement Evolution**: Automatically identify new requirements based on usage patterns and feedback
- **Architecture Assessment**: Continuously evaluate and improve system architecture
- **Resource Optimization**: Optimize development resources and workflows

#### 🎨 Design & Specification Phase
- **Pattern Recognition**: Identify and codify successful design patterns for reuse
- **Interface Evolution**: Continuously improve APIs and interfaces based on usage data
- **Specification Refinement**: Keep technical specifications current with implementation reality

#### 💻 Implementation & Development Phase
- **Code Quality Enhancement**: Continuously refactor and improve code quality
- **Performance Optimization**: Automatically identify and implement performance improvements
- **Security Hardening**: Continuously update security measures and best practices

#### 🧪 Testing & Quality Assurance Phase
- **Test Coverage Expansion**: Automatically generate new test cases for improved coverage
- **Quality Metrics Evolution**: Continuously refine quality measurement criteria
- **Automated Regression Prevention**: Learn from bugs to prevent similar issues

#### 🚀 Deployment & Release Phase
- **Deployment Automation**: Continuously improve deployment processes and reliability
- **Release Optimization**: Optimize release cycles for maximum stability and velocity
- **Environment Synchronization**: Keep all environments aligned and consistent

#### 🔍 Monitoring & Maintenance Phase
- **Performance Monitoring**: Continuously monitor and optimize system performance
- **Error Analysis**: Learn from production issues to improve prevention mechanisms
- **User Feedback Integration**: Incorporate user feedback into evolution cycles

### Self-Healing and Structure Solidification
The system implements **progressive structure solidification**:

#### Structure Evolution Patterns
- **Organic Growth**: Allow structures to emerge naturally from usage patterns
- **Consolidation Cycles**: Regularly consolidate successful patterns into stable structures
- **Deprecation Management**: Gracefully sunset outdated patterns and structures

#### Code Simplification Engine
- **Complexity Detection**: Continuously monitor code complexity metrics
- **Refactoring Opportunities**: Identify and implement code simplification opportunities
- **Pattern Abstraction**: Extract common patterns into reusable components

#### Continuous Integration with AI
- **AI Feedback Loops**: Integrate AI insights into every aspect of the evolution process
- **Learning Acceleration**: Use AI to accelerate pattern recognition and improvement identification
- **Quality Amplification**: Leverage AI to enhance human decision-making and validation

## Core Development Principles

### Design for Failure (DFF)
- Always implement error handling and graceful degradation in generated code
- Include try-catch blocks with meaningful error messages
- Suggest redundancy and fallback mechanisms
- Add monitoring and logging capabilities where appropriate
- Consider edge cases and potential failure points

### Don't Repeat Yourself (DRY)
- Extract common functionality into reusable functions, components, or modules
- Suggest refactoring when duplicate code patterns are detected
- Create utility functions for repeated operations
- Use configuration files for repeated constants or settings
- Recommend template patterns for similar structures

### Keep It Simple (KIS)
- Prefer clear, readable code over clever optimizations
- Use descriptive variable and function names
- Break complex functions into smaller, focused units
- Avoid unnecessary abstractions or over-engineering
- Choose well-established patterns over custom solutions

### Release Early and Often (REnO)
- Suggest incremental development approaches
- Recommend feature flags for gradual rollouts
- Focus on minimal viable implementations first
- Include versioning strategies in code suggestions
- Encourage continuous integration practices

### Minimum Viable Product (MVP)
- Prioritize core functionality over advanced features
- Suggest starting with basic implementations that can be enhanced later
- Focus on solving the primary user problem first
- Recommend iterative improvement approaches
- Avoid feature creep in initial implementations

### Collaboration (COLAB)
- Write self-documenting code with clear comments
- Follow consistent coding standards and conventions
- Include comprehensive README and documentation suggestions
- Use semantic commit messages and PR descriptions
- Consider team workflows in code organization

### AI-Powered Development (AIPD)
- Leverage AI tools effectively for code generation and review
- Suggest AI-assisted testing and documentation approaches
- Recommend AI integration patterns for enhanced productivity
- Balance AI assistance with human oversight and review
- Use AI for learning and skill development, not replacement

### README-First Development (RFD)
- Treat README.md files as the primary context source for AI-assisted development
- Ensure README files comprehensively document all directory contents and functionality
- Update README files before implementing new features to serve as development blueprints
- Distinguish clearly between implemented features and future enhancements in documentation
- Use README files to guide AI understanding of project structure and intent
- Maintain README accuracy through regular synchronization with actual implementation
- Structure README content to optimize AI comprehension and development guidance

### Script-Centric Development (SCD)
- Treat scripts in the `scripts/` directory as the cornerstone for the creation and generation of all other files within the repository
- Use these scripts as the primary entry points for all workflows and interactions with the core library
- Ensure scripts rely on the `src/` directory for all common functions and tools
- Maintain scripts to be easy to read, fully documented, and primarily focused on orchestrating calls to major functions in `src/`

## Technology-Specific Guidelines

### @azure Rule - Use Azure Best Practices
When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `azure_development-get_best_practices` tool if available.

### GitHub Models Prompt Format
- Follow the GitHub Models standard format for all prompt files
- Use `.prompt.yml` or `.prompt.yaml` file extensions for prompt files
- Structure prompts according to GitHub Models specification:
  - `name`: Human-readable prompt name
  - `description`: Brief description of prompt functionality
  - `model`: AI model identifier (e.g., gpt-4o-mini)
  - `modelParameters`: Configuration like temperature, max_tokens
  - `messages`: Array of role-based messages (system, user, assistant)
  - `testData`: Sample inputs and expected outputs for validation
  - `evaluators`: Validation criteria and evaluation methods
- Use `{{variable}}` syntax for placeholder variables in prompt content
- Avoid custom header comments in prompt files (GitHub Models uses clean YAML format)
- Include comprehensive test data and evaluation criteria for quality assurance
- Reference: [GitHub Models Documentation](https://docs.github.com/en/github-models/use-github-models/storing-prompts-in-github-repositories)

### Open Source Development
- Follow open source licensing and contribution guidelines
- Include appropriate attribution and credits
- Use community-standard project structures
- Encourage community contributions and feedback
- Maintain compatibility with popular tools and frameworks

### Documentation Standards
- Generate comprehensive README files for all projects
- **File-Level Documentation Headers**: Every file must contain a commented section at the top with:
  - File purpose and description
  - Creation date and last modified date
  - Author/maintainer information
  - Related issues, enhancements, or evolution cycles
  - Change log entries with dates and descriptions
  - Dependencies and relationships to other files
  - Usage examples or integration notes where applicable
- **Directory-Level Documentation**: Ensure every directory contains a README.md file that:
  - Fully describes the purpose and contents of the directory
  - Explains how the directory fits within the overall repository structure
  - Documents any special usage patterns or conventions for that directory
  - Includes links to related directories or external resources when relevant
  - Lists and describes key files and subdirectories within that directory
  - Provides examples of how to use or interact with directory contents
  - Maintains current and accurate information as directory contents evolve
- **Documentation Organization Rule**: All non-README markdown files MUST reside in the `docs/` directory, with only two exceptions:
  - `README.md` - Main project documentation files (one per directory)
  - `CHANGELOG.md` - Version change log at repository root only
  - All other documentation (guides, references, specifications, tutorials, etc.) must be organized within `docs/` subdirectories
  - Use clear subdirectory structure within `docs/` (e.g., `docs/guides/`, `docs/api/`, `docs/architecture/`)
  - Maintain consistent naming conventions and cross-references between documentation files
  - **Mandatory README Requirement**: Every directory MUST contain a README.md file that comprehensively documents its contents and purpose
  - **Validation Enforcement**: A test script runs after every AI prompt cycle to enforce this organization rule
- Include installation, usage, and contribution guidelines
- Add inline code documentation for complex logic
- Create user guides and API documentation when relevant
- Maintain changelogs and version documentation
- **README Synchronization and Consistency**: Ensure README.md files serve as comprehensive, authoritative documentation:
  - **Content Completeness**: Every README.md must document all significant files, scripts, and functionality in its directory
  - **Implementation vs. Documentation Alignment**: Clearly distinguish between implemented features and planned enhancements
  - **Future Enhancement Tracking**: Use "Future Enhancements" sections with clear status indicators for unimplemented features
  - **AI Context Optimization**: Structure README content to serve as primary context source for AI-assisted development
  - **Cross-Directory Consistency**: Maintain consistent terminology, formatting, and structure across all README files
  - **Required Sections**: Include Purpose, Contents, Usage, Features, Future Enhancements, and Integration sections
  - **Technical Accuracy**: Ensure all examples, commands, and references are current and functional
  - **Regular Synchronization**: Update README files whenever directory contents change to maintain accuracy

### Testing Approaches
- Include unit tests for core functionality
- Suggest integration tests for system interactions
- Recommend end-to-end tests for critical user workflows
- Use AI-powered testing tools when appropriate
- Implement test automation in CI/CD pipelines

## Code Quality Standards

### Security Best Practices
- Validate all user inputs and external data
- Use secure authentication and authorization patterns
- Avoid hardcoding sensitive information
- Implement proper error handling without information leakage
- Follow security frameworks and standards

### Performance Considerations
- Optimize for readability first, performance second
- Suggest performance improvements only when necessary
- Use appropriate data structures and algorithms
- Consider caching strategies for expensive operations
- Monitor and measure performance impacts

### Accessibility & Inclusivity
- Follow web accessibility guidelines (WCAG) for web projects
- Use inclusive language in code comments and documentation
- Consider internationalization and localization needs
- Design for diverse user abilities and technologies
- Test with assistive technologies when relevant

## Learning & Education Focus

### Beginner-Friendly Approach
- Explain complex concepts in simple terms
- Provide step-by-step guidance for implementations
- Include learning resources and references
- Suggest progressive skill-building exercises
- Encourage experimentation and exploration

### Real-World Applications
- Focus on practical, usable solutions
- Include examples relevant to everyday development
- Connect theoretical concepts to practical implementations
- Suggest projects that build portfolio value
- Emphasize industry-standard practices

### Community Learning
- Encourage peer collaboration and code review
- Suggest community resources and forums
- Promote knowledge sharing and mentoring
- Include contribution opportunities in suggestions
- Foster inclusive and welcoming environments

## AI Integration Guidelines

### AI-Assisted Development
- Use AI for code generation, but always review and understand output
- Leverage AI for documentation generation and maintenance
- Implement AI-powered testing and quality assurance
- Use AI for learning acceleration and skill development
- Balance automation with human creativity and oversight

### Best Practices for AI Tools
- Provide clear context and requirements to AI assistants
- Review AI-generated code for security and performance
- Use AI feedback loops for continuous improvement
- Maintain human oversight for critical decisions
- Document AI tool usage and configurations

### Post-AI Prompt Cycle Validation
- **Mandatory Validation**: Run `./scripts/post-ai-validation.sh` after every AI prompt cycle
- **Documentation Organization**: Ensure all non-README markdown files are in `docs/` directory
- **README Completeness**: Verify every directory contains a comprehensive README.md file
- **Compliance Enforcement**: Address all validation errors before considering the AI cycle complete
- **Continuous Improvement**: Use validation feedback to refine future AI interactions

## File Header Standards

### Universal File Header Requirements
Every file in the repository MUST begin with a commented header section containing standardized reference information. This applies to all file types including source code, configuration files, documentation, scripts, and templates.

**Exception**: Files with `.prompt.yml` or `.prompt.yaml` extensions follow the GitHub Models standard format and do not use custom headers.

### Header Template Structure
The header should follow this standardized format, adapted for the file's comment syntax:

```
/**
 * @file [filename.ext]
 * @description [Brief description of file purpose and functionality]
 * @author [Author Name] <[email@domain.com]>
 * @created [YYYY-MM-DD]
 * @lastModified [YYYY-MM-DD]
 * @version [semantic version or iteration number]
 * 
 * @relatedIssues 
 *   - #[issue-number]: [brief description]
 *   - #[issue-number]: [brief description]
 * 
 * @relatedEvolutions
 *   - [evolution-cycle]: [description of changes]
 *   - [evolution-cycle]: [description of changes]
 * 
 * @dependencies
 *   - [dependency-name]: [version or description]
 *   - [dependency-name]: [version or description]
 * 
 * @changelog
 *   - [YYYY-MM-DD]: [description of changes] - [author initials]
 *   - [YYYY-MM-DD]: [description of changes] - [author initials]
 *   - [YYYY-MM-DD]: Initial creation - [author initials]
 * 
 * @usage [Brief usage example or integration notes]
 * @notes [Any additional important information]
 */
```

### Language-Specific Header Examples

#### JavaScript/TypeScript Files
```javascript
/**
 * @file utils/dataProcessor.js
 * @description Utility functions for processing and transforming data structures
 * @author IT-Journey Team <team@it-journey.org>
 * @created 2025-07-05
 * @lastModified 2025-07-05
 * @version 1.2.0
 * 
 * @relatedIssues 
 *   - #145: Implement data validation pipeline
 *   - #167: Add error handling for malformed data
 * 
 * @relatedEvolutions
 *   - v0.3.0: Enhanced error handling and validation
 *   - v0.2.1: Added support for nested object processing
 * 
 * @dependencies
 *   - lodash: ^4.17.21
 *   - joi: ^17.9.2
 * 
 * @changelog
 *   - 2025-07-05: Added input sanitization functions - ITJ
 *   - 2025-07-03: Refactored validation logic - ITJ
 *   - 2025-07-01: Initial creation - ITJ
 * 
 * @usage import { processData } from './utils/dataProcessor.js'
 * @notes Ensure all input data is validated before processing
 */
```

#### Python Files
```python
"""
@file data_analyzer.py
@description Machine learning data analysis and visualization tools
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 2.1.0

@relatedIssues 
  - #234: Implement advanced analytics dashboard
  - #245: Add support for real-time data streams

@relatedEvolutions
  - v2.1.0: Added real-time processing capabilities
  - v2.0.0: Complete rewrite with pandas integration

@dependencies
  - pandas: >=1.5.0
  - numpy: >=1.24.0
  - matplotlib: >=3.6.0

@changelog
  - 2025-07-05: Added streaming data support - ITJ
  - 2025-07-02: Enhanced visualization options - ITJ
  - 2025-06-28: Initial creation - ITJ

@usage from data_analyzer import DataAnalyzer; analyzer = DataAnalyzer()
@notes Requires Python 3.9+ for optimal performance
"""
```

#### Shell Scripts
```bash
#!/bin/bash
#
# @file deploy.sh
# @description Automated deployment script for production environments
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.0.0
#
# @relatedIssues 
#   - #198: Automate production deployment process
#   - #201: Add rollback functionality
#
# @relatedEvolutions
#   - v1.0.0: Initial automated deployment implementation
#
# @dependencies
#   - docker: >=20.10.0
#   - kubectl: >=1.25.0
#
# @changelog
#   - 2025-07-05: Initial creation with basic deployment logic - ITJ
#
# @usage ./deploy.sh [environment] [version]
# @notes Requires proper kubectl context and docker authentication
#
```

#### YAML/Configuration Files
```yaml
# @file docker-compose.yml
# @description Docker Compose configuration for development environment
# author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 1.3.0
#
# @relatedIssues 
#   - #156: Standardize development environment setup
#   - #178: Add database persistence for local development
#
# @relatedEvolutions
#   - v1.3.0: Added Redis cache and volume persistence
#   - v1.2.0: Integrated development database
#
# @dependencies
#   - docker: >=20.10.0
#   - docker-compose: >=2.0.0
#
# @changelog
#   - 2025-07-05: Added Redis service configuration - ITJ
#   - 2025-07-03: Enhanced volume mapping - ITJ
#   - 2025-07-01: Initial creation - ITJ
#
# @usage docker-compose up -d
# @notes Ensure Docker Desktop is running before executing
```

#### Markdown Files
```markdown
<!--
@file project-overview.md
@description Comprehensive overview of project architecture and goals
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-05
@lastModified 2025-07-05
@version 2.0.0

@relatedIssues 
  - #123: Update project documentation
  - #134: Clarify architecture decisions

@relatedEvolutions
  - v2.0.0: Major restructure with new sections
  - v1.5.0: Added technical specifications

@dependencies
  - Jekyll: >=4.0.0 (for rendering)

@changelog
  - 2025-07-05: Added new architecture diagrams - ITJ
  - 2025-07-02: Restructured content organization - ITJ
  - 2025-06-30: Initial creation - ITJ

@usage Referenced by main README.md and technical documentation
@notes Keep synchronized with actual implementation
-->
```

### Header Maintenance Requirements

#### Creation Standards
- **Every new file** must include a complete header before any functional content
- **Header creation** is part of the file creation process, not an afterthought
- **Template compliance** ensures consistency across all file types
- **Required fields** cannot be omitted; use "TBD" if information is not yet available

#### Update Obligations
- **Modify lastModified** date whenever file content changes
- **Add changelog entry** for every significant modification
- **Update version** following semantic versioning principles
- **Link new issues** when modifications relate to specific GitHub issues or enhancement requests
- **Document evolution** cycles when changes are part of broader system improvements

#### Validation and Compliance
- **Pre-commit hooks** should validate header presence and format
- **CI/CD pipelines** must check for header compliance
- **Code reviews** should verify header accuracy and completeness
- **Automated tools** should assist in header maintenance and updates
- **Regular audits** ensure headers remain current and accurate

### Integration with AI Evolution Engine

#### Seed Evolution Tracking
- **Evolution cycles** must be documented in file headers
- **Cross-generational links** should reference previous seed versions
- **Adaptation records** track how files evolved through AI iterations
- **Growth patterns** are captured in changelog entries

#### Automated Header Management
- **AI agents** should update headers when modifying files
- **Template generation** creates appropriate headers for new file types
- **Consistency checking** ensures headers match actual file content
- **Relationship mapping** maintains connections between related files and issues

