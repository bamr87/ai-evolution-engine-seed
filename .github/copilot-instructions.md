# Copilot Instructions

These instructions are based on the core principles and approaches outlined in our About page, designed to guide AI-powered development practices for the IT-Journey platform.

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

## Technology-Specific Guidelines

### @azure Rule - Use Azure Best Practices
When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `azure_development-get_best_practices` tool if available.

### Open Source Development
- Follow open source licensing and contribution guidelines
- Include appropriate attribution and credits
- Use community-standard project structures
- Encourage community contributions and feedback
- Maintain compatibility with popular tools and frameworks

### Documentation Standards
- Generate comprehensive README files for all projects
- **Directory-Level Documentation**: Ensure every directory contains a README.md file that:
  - Fully describes the purpose and contents of the directory
  - Explains how the directory fits within the overall repository structure
  - Documents any special usage patterns or conventions for that directory
  - Includes links to related directories or external resources when relevant
  - Lists and describes key files and subdirectories within that directory
  - Provides examples of how to use or interact with directory contents
  - Maintains current and accurate information as directory contents evolve
- Include installation, usage, and contribution guidelines
- Add inline code documentation for complex logic
- Create user guides and API documentation when relevant
- Maintain changelogs and version documentation

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

### Content Management & Documentation Evolution

### Directory Structure Documentation
- **Mandatory README.md Files**: Every directory must contain a README.md file, no exceptions
- **Directory Purpose Documentation**: Each README.md must clearly explain:
  - The specific role and responsibility of that directory within the repository
  - How the directory's contents are organized and structured
  - Dependencies and relationships with other directories
  - Any special conventions, naming patterns, or organizational rules
  - Entry points for users or developers new to that directory
- **Content Inventory**: Directory README.md files should include:
  - Comprehensive listing of all files and subdirectories
  - Brief description of each item's purpose and function
  - Status indicators (active, deprecated, experimental, etc.)
  - Last updated information and maintenance responsibility
- **Navigation and Discovery**: Directory documentation should facilitate:
  - Easy navigation between related directories
  - Clear paths for different user personas (developers, users, contributors)
  - Search-friendly content with appropriate keywords and tags
  - Integration with repository-wide navigation and index systems

### Markdown Page Lifecycle Management

### Content Quality Assurance
- **Directory Documentation Audit**: Regularly verify that every directory has a current README.md file
- **Consistency Checks**: Ensure terminology, formatting, and style remain consistent across all .md files
- **Cross-Directory Links**: Validate that directory README.md files properly reference related directories
- **Repository Navigation**: Ensure directory documentation supports intuitive repository exploration
- **Documentation Completeness**: Verify that directory README.md files accurately reflect current contents
- **Accessibility Standards**: Follow markdown accessibility best practices (proper heading hierarchy, alt text for images)
- **SEO Optimization**: Use appropriate frontmatter, meta descriptions, and structured content
- **Multi-format Support**: Consider how content will render across different platforms (GitHub, Jekyll, static site generators)
- **Internationalization Ready**: Structure content to support future localization efforts

