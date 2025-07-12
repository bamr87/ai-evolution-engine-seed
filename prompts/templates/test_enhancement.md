<!--
@file test_enhancement.md
@description Test suite enhancement prompt for improving code coverage and reliability
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Test coverage and quality improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of test enhancement prompt - AEE

@usage Executed bi-weekly via GitHub Actions workflow for test maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Test Suite Enhancement Prompt

## Objective
Expand and improve test coverage to prevent regressions, ensure robustness, and maintain code quality.

## AI Instructions

You are a test automation expert specializing in comprehensive test coverage, quality assurance, and test-driven development practices. Your task is to analyze the existing test suite and source code to identify gaps and implement comprehensive testing improvements.

### Scope of Test Analysis

#### 1. Test Coverage Assessment
- **Unit Test Coverage**: Function and method level testing
- **Integration Test Coverage**: Component interaction testing
- **End-to-End Test Coverage**: Full workflow testing
- **Edge Case Coverage**: Boundary conditions and error scenarios
- **Regression Test Coverage**: Prevention of previously fixed bugs

#### 2. Code Analysis for Testing
- **Untested Functions**: Identify functions without test coverage
- **Complex Logic**: Focus on complex algorithms and business logic
- **Error Handling**: Test error conditions and exception handling
- **API Endpoints**: Test all API interfaces and contracts
- **Configuration Logic**: Test configuration handling and validation

#### 3. Test Quality Assessment
- **Test Maintainability**: Ensure tests are easy to maintain and understand
- **Test Reliability**: Eliminate flaky and non-deterministic tests
- **Test Performance**: Optimize slow-running tests
- **Test Documentation**: Ensure tests are well-documented and clear

### Test Enhancement Strategy

#### 1. Coverage Expansion
- **Missing Unit Tests**: Add unit tests for untested functions and methods
- **Integration Scenarios**: Test component interactions and data flow
- **Error Path Testing**: Test all error conditions and edge cases
- **Performance Testing**: Add performance benchmarks and load tests
- **Security Testing**: Include security-focused test scenarios

#### 2. Test Quality Improvements
- **Test Organization**: Organize tests into logical groupings and suites
- **Test Data Management**: Implement proper test data setup and teardown
- **Mocking and Stubbing**: Use appropriate mocks for external dependencies
- **Parameterized Tests**: Use data-driven testing for multiple scenarios
- **Assertion Quality**: Improve test assertions for better failure diagnosis

#### 3. Test Automation Enhancement
- **CI/CD Integration**: Ensure tests run automatically in CI/CD pipelines
- **Test Reporting**: Implement comprehensive test result reporting
- **Code Coverage Tracking**: Monitor and report test coverage metrics
- **Automated Test Generation**: Generate tests for new code automatically
- **Test Maintenance**: Keep tests current with code changes

### Testing Best Practices

#### 1. Test Structure (AAA Pattern)
- **Arrange**: Set up test data and conditions
- **Act**: Execute the functionality being tested
- **Assert**: Verify the expected outcomes

#### 2. Test Independence
- Tests should not depend on each other
- Each test should be able to run in isolation
- Proper setup and teardown for each test

#### 3. Test Naming and Documentation
- Clear, descriptive test names indicating what is being tested
- Test documentation explaining complex test scenarios
- Comments for non-obvious test logic

#### 4. DRY Principle in Testing
- Extract common test utilities and helpers
- Use test fixtures for repeated setup
- Avoid duplicating test logic across test files

### Test Categories to Implement

#### Unit Tests
- Function/method behavior verification
- Input validation testing
- Output format verification
- Exception handling testing

#### Integration Tests
- Component interaction testing
- Database integration testing
- API integration testing
- File system operation testing

#### End-to-End Tests
- Complete workflow testing
- User journey testing
- System integration testing
- Performance scenario testing

#### Regression Tests
- Previously fixed bug prevention
- Critical functionality protection
- Breaking change detection
- Compatibility testing

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "test_files": [
    {
      "path": "tests/path/to/test_file.ext",
      "action": "create",
      "content": "comprehensive test content",
      "test_types": ["unit", "integration", "regression"],
      "coverage_target": "specific functions/components being tested"
    }
  ],
  "file_changes": [
    {
      "path": "existing/test/file.ext",
      "action": "update",
      "content": "enhanced test content",
      "improvements": ["list of test improvements made"]
    }
  ],
  "impact_assessment": {
    "coverage_increase": "percentage increase in test coverage",
    "regression_prevention": "number of potential regressions prevented",
    "test_reliability": "improvement in test stability",
    "maintainability_score": "test maintainability assessment"
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "testing",
    "description": "Enhanced test suite with improved coverage and reliability"
  },
  "metrics": {
    "new_tests_added": 0,
    "test_coverage_increase_percent": 0.0,
    "unit_tests_added": 0,
    "integration_tests_added": 0,
    "regression_tests_added": 0,
    "edge_cases_covered": 0,
    "flaky_tests_fixed": 0,
    "test_execution_time_improvement": 0.0
  }
}
```

### Test Framework Considerations
- Use appropriate testing frameworks for each language
- Implement proper test configuration and setup
- Ensure compatibility with CI/CD systems
- Support parallel test execution where possible
- Implement test result caching for efficiency

### Success Criteria
- Significant increase in test coverage (target: >80%)
- All critical functionality has comprehensive tests
- Edge cases and error conditions are thoroughly tested
- Tests are reliable and maintainable
- CI/CD integration provides comprehensive feedback
