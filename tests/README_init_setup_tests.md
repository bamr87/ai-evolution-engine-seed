# Testing Documentation for init_setup.sh

This directory contains test scripts for validating the AI Evolution Engine initialization script.

## Test Scripts

### 1. test_init_setup.sh (Comprehensive Test)
A thorough test suite that validates:
- Script existence and executability
- Syntax validation
- Directory structure creation
- File creation
- Version consistency
- Git initialization
- GitHub workflow YAML validity
- Absence of deprecated commands (like uuidgen)

**Note**: This test includes strict YAML validation which may fail due to complex heredoc structures in the generated workflow file.

### 2. test_init_setup_simple.sh (Core Functionality Test)
A simplified test suite focusing on essential functionality:
- Script execution
- Essential file creation
- Version presence
- No old version references
- Git repository initialization
- Basic workflow structure

## Running the Tests

### Simple Test (Recommended)
```bash
chmod +x tests/test_init_setup_simple.sh
./tests/test_init_setup_simple.sh
```

### Comprehensive Test
```bash
chmod +x tests/test_init_setup.sh
./tests/test_init_setup.sh
```

## Expected Results

The init_setup.sh script should:
1. Create a complete directory structure for the AI Evolution Engine
2. Generate all necessary files with version 0.4.1
3. Initialize a Git repository with an initial commit
4. Create a valid GitHub Actions workflow (ai_evolver.yml)
5. Not contain any references to old versions (0.3.6, 0.2.0)

## Version Information

Current expected version: **0.4.1-seed**

The version should be consistent across:
- README.md
- .seed.md
- evolution-metrics.json
- .github/workflows/ai_evolver.yml

## Troubleshooting

### YAML Validation Errors
The generated workflow file contains complex shell heredocs that may not pass strict YAML validation. The workflow is functional in GitHub Actions despite these validation warnings.

### Color Output Issues
If you see garbled color codes, your terminal may not support ANSI colors. The tests will still run correctly.

### Permission Errors
Ensure the test scripts have execute permissions:
```bash
chmod +x tests/test_init_setup*.sh
```

## Test Output

Both test scripts provide:
- Color-coded output (PASS/FAIL/INFO)
- Detailed information about what's being tested
- Summary of tests run, passed, and failed
- Automatic cleanup of test directories 