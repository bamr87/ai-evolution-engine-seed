# Workflow Refactoring Documentation

## Overview

The GitHub workflow files have been refactored to reference specific script files instead of containing inline shell code. This improves maintainability, readability, and testability.

## Refactored Structure

### New Script Files

All scripts are located in the `scripts/` directory:

#### Core Evolution Scripts

- **`setup-environment.sh`** - Sets up the necessary environment for evolution workflows
- **`collect-context.sh`** - Collects repository context and metrics for AI evolution
- **`simulate-ai-growth.sh`** - Simulates AI growth and generates evolution response
- **`apply-growth-changes.sh`** - Applies evolutionary changes from AI response
- **`plant-new-seeds.sh`** - Generates and commits new .seed.md for next evolution

#### Daily Evolution Scripts

- **`analyze-repository-health.sh`** - Analyzes repository health and suggests improvements
- **`generate-evolution-prompt.sh`** - Generates targeted evolution prompt based on analysis
- **`trigger-evolution-workflow.sh`** - Triggers the main evolution workflow with generated prompt
- **`update-evolution-metrics.sh`** - Updates daily evolution metrics

#### Testing Scripts

- **`test-evolved-seed.sh`** - Tests the evolved seed functionality

#### Existing Scripts (Enhanced)

- **`generate_seed.sh`** - Generates the next .seed.md content
- **`generate_ai_response.sh`** - Constructs the simulated AI response JSON
- **`create_pr.sh`** - Creates Pull Request for evolution changes

### Refactored Workflows

#### 1. `ai_evolver.yml` - Main Evolution Workflow

**Before**: ~296 lines with complex inline shell scripts  
**After**: Clean, focused workflow that calls specific scripts

```yaml
steps:
  - name: 🛠️ Setup Environment
    run: ./scripts/setup-environment.sh
    
  - name: 🧬 Collect Repository DNA & Metrics
    run: ./scripts/collect-context.sh "${{ inputs.prompt }}" "${{ inputs.growth_mode }}" "/tmp/repo_context.json"
    
  - name: 🧠 Invoke Simulated AI Growth Engine
    run: ./scripts/simulate-ai-growth.sh "${{ inputs.prompt }}" "${{ inputs.growth_mode }}" "/tmp/repo_context.json" "/tmp/evolution_response.json"
    
  - name: 🌾 Apply Growth Changes
    run: ./scripts/apply-growth-changes.sh "/tmp/evolution_response.json"
    
  - name: 🌰 Plant New Seeds
    run: ./scripts/plant-new-seeds.sh "/tmp/evolution_response.json" "${{ inputs.auto_plant_seeds }}"
    
  - name: 🌳 Create Growth Pull Request
    run: ./scripts/create_pr.sh "/tmp/evolution_response.json" "${{ inputs.prompt }}" "${{ inputs.growth_mode }}"
```

#### 2. `daily_evolution.yml` - Daily Maintenance Workflow
**Before**: Complex inline health checks and prompt generation
**After**: Modular script-based approach

```yaml
steps:
  - name: 📊 Analyze Repository Health
    run: ./scripts/analyze-repository-health.sh "$EVOLUTION_TYPE" "$INTENSITY" "$FORCE_RUN"
    
  - name: 🧬 Generate Evolution Prompt
    run: ./scripts/generate-evolution-prompt.sh "$EVOLUTION_TYPE" "$INTENSITY"
    
  - name: 🚀 Trigger Evolution Workflow
    run: ./scripts/trigger-evolution-workflow.sh "$EVOLUTION_TYPE" "conservative"
    
  - name: 📊 Update Daily Evolution Metrics
    run: ./scripts/update-evolution-metrics.sh
```

#### 3. `testing_automation_evolver.yml` - Testing Workflow
**Before**: Mixed dependency installation and testing logic
**After**: Streamlined with dedicated scripts

```yaml
steps:
  - name: Setup environment
    run: ./scripts/setup-environment.sh
    
  - name: Test evolved seed
    run: ./tests/seed/test-evolved-seed.sh ${{ github.event.inputs.growth_mode }}
```

## Benefits of Refactoring

### 1. **Improved Maintainability**
- Each script has a single responsibility
- Changes to logic require editing only the relevant script
- Scripts can be tested independently

### 2. **Better Readability**
- Workflow files are now clear and focused on orchestration
- Complex logic is contained in appropriately named scripts
- Easier to understand the overall flow

### 3. **Enhanced Testability**
- Scripts can be tested locally without running the full workflow
- Individual components can be debugged in isolation
- Error handling is centralized in each script

### 4. **Reusability**
- Scripts can be reused across different workflows
- Common functionality is centralized
- Reduces code duplication

### 5. **Error Handling**
- Each script includes proper error handling with `set -euo pipefail`
- Clear error messages and exit codes
- Graceful failure handling

## Script Usage Examples

### Local Testing
```bash
# Test repository health analysis
./scripts/analyze-repository-health.sh consistency minimal false

# Generate evolution prompt
./scripts/generate-evolution-prompt.sh documentation moderate

# Test environment setup
./scripts/setup-environment.sh
```

### Environment Variables
Scripts utilize environment variables and temporary files for data exchange:
- `/tmp/repo_context.json` - Repository context data
- `/tmp/evolution_response.json` - AI evolution response
- `/tmp/health_check_results.env` - Health check results
- `/tmp/evolution_prompt.txt` - Generated evolution prompt

## Error Handling Patterns

All scripts follow consistent error handling patterns:

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Validate inputs
if [ ! -f "$REQUIRED_FILE" ]; then
    echo "❌ Error: Required file not found: $REQUIRED_FILE"
    exit 1
fi

# Provide clear feedback
echo "✅ Operation completed successfully"
echo "📊 Summary: $DETAILS"
```

## Migration Notes

### Backward Compatibility
- All existing functionality is preserved
- Workflow inputs and outputs remain the same
- No breaking changes to the API

### New Features
- Enhanced error reporting and logging
- Improved script reusability
- Better separation of concerns
- Comprehensive health checks

### Future Enhancements
- Add unit tests for individual scripts
- Implement configuration file support
- Add metrics collection and reporting
- Enhance logging and monitoring capabilities
