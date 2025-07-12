<!--
@file code_refactor.md
@description Code quality and refactoring prompt for improving maintainability
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Code quality and maintainability improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of code refactoring prompt - AEE

@usage Executed monthly via GitHub Actions workflow for code quality maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Code Quality and Refactoring Prompt

## Objective
Improve code readability, maintainability, and adherence to best practices without altering functionality.

## AI Instructions

You are an expert software engineer specializing in code quality and refactoring. Your task is to analyze all source code files in this repository and improve their quality while maintaining backward compatibility and functionality.

### Scope of Analysis
- All source code files (*.py, *.js, *.sh, *.ts, *.rb, etc.)
- Code structure and organization
- Function and variable naming
- Code documentation and comments
- Adherence to language-specific best practices

### Refactoring Objectives

#### 1. Readability Improvements
- **Consistent Naming**: Use clear, descriptive names for variables, functions, and classes
- **Code Comments**: Add meaningful comments for complex logic
- **Code Structure**: Organize code logically with appropriate spacing and indentation
- **Magic Numbers**: Replace magic numbers with named constants

#### 2. Maintainability Enhancements
- **Function Modularity**: Break down large functions into smaller, focused units
- **Code Duplication**: Identify and eliminate duplicate code patterns
- **Error Handling**: Improve error handling and exception management
- **Configuration**: Extract hardcoded values to configuration files

#### 3. Best Practices Adherence
- **Python**: Follow PEP8 guidelines, use type hints where appropriate
- **JavaScript**: Follow ESLint rules, use modern ES6+ features appropriately
- **Shell Scripts**: Follow POSIX standards, add proper error checking
- **General**: Follow language-specific conventions and community standards

#### 4. Performance Considerations
- **Algorithm Efficiency**: Identify and improve inefficient algorithms
- **Memory Usage**: Optimize memory allocation and cleanup
- **I/O Operations**: Improve file and network operation efficiency
- **Caching**: Add appropriate caching where beneficial

### Quality Requirements
- **Backward Compatibility**: Ensure all changes maintain existing functionality
- **DRY Principle**: Eliminate code duplication
- **KISS Principle**: Keep solutions simple and understandable
- **Test Coverage**: Generate tests for refactored code
- **Documentation**: Update code documentation to reflect changes

### Testing Requirements
Generate comprehensive unit tests for all refactored code including:
- Function input/output validation
- Edge case handling
- Error condition testing
- Integration testing where applicable

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/file.ext",
      "action": "update",
      "content": "refactored code content",
      "summary": "Description of refactoring changes made"
    }
  ],
  "test_files": [
    {
      "path": "tests/path/to/test_file.ext",
      "action": "create",
      "content": "unit test content for refactored code",
      "coverage_target": "functions/classes being tested"
    }
  ],
  "impact_assessment": {
    "complexity_change": "reduced/maintained/increased",
    "performance_impact": "improved/neutral/degraded",
    "maintainability_score": "percentage or qualitative measure",
    "test_coverage_increase": "percentage increase"
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "refactor",
    "description": "Improved code quality and maintainability through refactoring"
  },
  "metrics": {
    "files_processed": 0,
    "files_refactored": 0,
    "lines_refactored": 0,
    "code_duplication_reduction": "percentage",
    "complexity_reduction": "percentage",
    "test_coverage_increase": "percentage",
    "functions_modularized": 0
  }
}
```

### Success Criteria
- Code is more readable and maintainable
- No functionality is broken or changed
- Test coverage is improved
- Code follows language-specific best practices
- Technical debt is reduced
