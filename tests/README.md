# 🧪 AI Evolution Engine - Testing Framework (v3.0.0)

This directory contains the simplified testing framework for the AI Evolution Engine.

## 📁 Current Structure

### 🧪 `test-suite.sh` - Main Test Suite
**Purpose**: Comprehensive testing framework with multiple test categories

**Features**:
- Script functionality testing
- Workflow validation
- Integration testing
- Validation checks
- Multiple output formats (text, JSON, HTML)
- Detailed reporting

**Usage**:
```bash
# Run all tests
./tests/test-suite.sh all

# Test specific components
./tests/test-suite.sh scripts
./tests/test-suite.sh workflows
./tests/test-suite.sh integration
./tests/test-suite.sh validation

# Generate different report formats
./tests/test-suite.sh all text
./tests/test-suite.sh all json
./tests/test-suite.sh all html
```

## 🔄 Testing Framework Simplification

### Before (Complex)
```
tests/
├── lib/ (complex testing library)
├── unit/ (unit tests)
├── integration/ (integration tests)
├── workflows/ (workflow tests)
├── seed/ (seed tests)
├── fixtures/ (test data)
├── debug-output/ (debug files)
├── *.sh (multiple test scripts)
└── *.md (documentation files)
```

### After (Simplified)
```
tests/
├── test-suite.sh (unified test suite)
├── results/ (test reports)
├── logs/ (test logs)
└── archive/ (old complex structure)
```

**Benefits**:
- **Reduced complexity**: 20+ files → 1 test suite
- **Easier maintenance**: Single file to update and debug
- **Clear functionality**: All test categories in one place
- **Better integration**: Works seamlessly with consolidated scripts

## 🎯 Test Categories

### ✅ Script Testing
- **File existence**: Check if all required scripts exist
- **Executable permissions**: Verify scripts are executable
- **Help functionality**: Test help commands work
- **Basic functionality**: Test core script operations

### ✅ Workflow Testing
- **File existence**: Check if workflow files exist
- **YAML syntax**: Validate YAML structure
- **Workflow structure**: Verify jobs and steps are defined
- **Integration**: Test workflow integration with scripts

### ✅ Integration Testing
- **Environment setup**: Test environment preparation
- **Context collection**: Test repository context gathering
- **Evolution simulation**: Test AI evolution simulation
- **Change application**: Test change application process
- **Validation**: Test post-change validation

### ✅ Validation Testing
- **JSON syntax**: Validate JSON file structure
- **Directory structure**: Check essential directories exist
- **File integrity**: Verify critical files are present
- **System health**: Test overall system health

## 📊 Test Framework Comparison

| Feature | Old Framework | New Framework |
|---------|---------------|---------------|
| **Files** | 20+ files | 1 test suite |
| **Lines of Code** | ~50KB | ~15KB |
| **Complexity** | High (modular) | Low (unified) |
| **Maintenance** | Difficult | Easy |
| **Integration** | Complex | Simple |
| **Debugging** | Hard | Easy |

## 🚀 Usage Examples

### Basic Testing
```bash
# Run all tests
./tests/test-suite.sh

# Run specific test category
./tests/test-suite.sh scripts
./tests/test-suite.sh workflows
./tests/test-suite.sh integration
./tests/test-suite.sh validation
```

### Report Generation
```bash
# Text report (default)
./tests/test-suite.sh all text

# JSON report
./tests/test-suite.sh all json

# HTML report
./tests/test-suite.sh all html
```

### Integration with Scripts
```bash
# Test via main test script
./scripts/test.sh all

# Test via core engine
./src/evolution-core.sh validate
```

## 📈 Test Results

### Report Formats

#### Text Report
```
🧪 AI Evolution Engine Test Report
==================================

Date: 2024-01-15T10:30:00Z
Version: 3.0.0

Summary:
- Total Tests: 25
- Passed: 25
- Failed: 0
- Success Rate: 100%

Status: ✅ ALL TESTS PASSED

Test Categories:
- Scripts: 8 passed
- Workflows: 6 passed
- Integration: 6 passed
- Validation: 5 passed
```

#### JSON Report
```json
{
  "metadata": {
    "version": "3.0.0",
    "timestamp": "2024-01-15T10:30:00Z",
    "test_suite": "ai-evolution-engine"
  },
  "summary": {
    "total_tests": 25,
    "passed_tests": 25,
    "failed_tests": 0,
    "success_rate": 100
  },
  "status": "success",
  "categories": {
    "scripts": 8,
    "workflows": 6,
    "integration": 6,
    "validation": 5
  }
}
```

#### HTML Report
Generates a styled HTML report with:
- Header with metadata
- Summary statistics
- Color-coded status indicators
- Professional styling

## 🔧 Configuration

### Environment Variables
- `TEST_VERSION` - Current test version (3.0.0)
- `PROJECT_ROOT` - Repository root directory
- `SCRIPT_DIR` - Test script directory

### Dependencies
- `jq` - JSON processing for validation
- `bash` - Shell environment
- `grep` - Text processing for workflow validation

## 📁 Archive

The old complex testing framework has been moved to `tests/archive/`:
- `lib/` - Original testing library
- `unit/` - Original unit tests
- `integration/` - Original integration tests
- `workflows/` - Original workflow tests
- `seed/` - Original seed tests
- `fixtures/` - Original test data
- `debug-output/` - Original debug files
- `*.sh` - Original test scripts
- `*.md` - Original documentation

These are preserved for reference but are no longer used.

## 🛠️ Development

### Adding New Tests
To add new tests to the test suite:

1. **Add test function**: Define new test function
2. **Add test calls**: Call new tests in appropriate category
3. **Update counters**: Ensure test counters are updated
4. **Test**: Run the test suite to verify

### Example Addition
```bash
# Add new test function
test_new_feature() {
    log_info "Testing new feature..."
    
    run_test "new feature exists" "[[ -f 'new-feature.sh' ]]"
    run_test "new feature executable" "[[ -x 'new-feature.sh' ]]"
    run_test "new feature works" "./new-feature.sh help >/dev/null"
}

# Add to test_all()
test_all() {
    test_scripts
    test_workflows
    test_integration
    test_validation
    test_new_feature  # Add new test category
}
```

## 🔍 Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x tests/test-suite.sh
   ```

2. **Missing Dependencies**
   ```bash
   # Install jq
   sudo apt-get install jq
   ```

3. **Test Failures**
   ```bash
   # Run with verbose output
   ./tests/test-suite.sh all
   
   # Check specific category
   ./tests/test-suite.sh scripts
   ```

### Debug Mode
Enable verbose output by setting environment variables:
```bash
export DEBUG=true
export VERBOSE=true
./tests/test-suite.sh all
```

## 📊 Monitoring

### Test Execution
Monitor test execution in real-time:
- **Info**: Test progress and status
- **Success**: Passed tests
- **Warning**: Non-critical issues
- **Error**: Failed tests

### Test Reports
Reports are automatically generated in `tests/results/`:
- `test-report-YYYYMMDD-HHMMSS.txt` - Text reports
- `test-report-YYYYMMDD-HHMMSS.json` - JSON reports
- `test-report-YYYYMMDD-HHMMSS.html` - HTML reports

### Test Logs
Logs are stored in `tests/logs/` for debugging and analysis.

---

**Note**: This simplified testing framework represents a significant improvement in maintainability and usability while preserving comprehensive testing coverage. 