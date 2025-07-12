# 🌱 AI Evolution Engine - Simplified Architecture (v3.0.0)

This directory contains the core evolution engine with a simplified, maintainable architecture.

## 📁 Current Structure

### 🌱 `evolution-core.sh` - Core Evolution Engine
**Purpose**: Centralized evolution functionality with essential features

**Features**:
- Environment setup and configuration
- Repository context collection
- AI evolution simulation
- Change application and validation
- Comprehensive logging and error handling

**Usage**:
```bash
# Setup environment
./src/evolution-core.sh setup

# Collect repository context
./src/evolution-core.sh context evolution-output

# Simulate AI evolution
./src/evolution-core.sh simulate -p "Improve error handling" -m conservative

# Apply changes
./src/evolution-core.sh apply evolution-output/evolution-response.json

# Validate changes
./src/evolution-core.sh validate
```

## 🔄 Architecture Simplification

### Before (Complex Modular)
```
src/
├── evolution-engine.sh (935 lines)
└── lib/
    ├── core/ (8 files, ~100KB)
    ├── evolution/ (4 files, ~100KB)
    ├── utils/ (2 files, ~20KB)
    ├── analysis/ (1 file)
    ├── integration/ (1 file)
    ├── workflow/ (1 file)
    └── template/ (1 file)
```

### After (Simplified)
```
src/
├── evolution-core.sh (400 lines)
└── archive/ (old complex structure)
```

**Benefits**:
- **Reduced complexity**: 20+ files → 1 core file
- **Easier maintenance**: Single file to update and debug
- **Clear functionality**: All essential features in one place
- **Better integration**: Works seamlessly with consolidated scripts

## 🎯 Key Features

### ✅ Environment Management
- Automatic directory creation
- Environment variable setup
- Script permission management
- Cross-platform compatibility

### ✅ Context Collection
- Repository structure analysis
- File counting and metrics
- JSON-based context storage
- Extensible data format

### ✅ AI Simulation
- Mock evolution response generation
- Configurable evolution modes
- Structured change definitions
- Comprehensive metadata

### ✅ Change Application
- Safe file modification
- Change tracking and logging
- Error handling and rollback
- Validation integration

### ✅ Validation System
- Script executable checks
- Workflow YAML validation
- Test integration
- Comprehensive error reporting

## 📊 Architecture Comparison

| Feature | Old Architecture | New Architecture |
|---------|------------------|------------------|
| **Files** | 20+ files | 1 core file |
| **Lines of Code** | ~500KB | ~15KB |
| **Complexity** | High (modular) | Low (unified) |
| **Maintenance** | Difficult | Easy |
| **Integration** | Complex | Simple |
| **Debugging** | Hard | Easy |

## 🔧 Integration

### With Scripts
The core engine integrates with the consolidated scripts:
- `scripts/evolve.sh` - Main evolution operations
- `scripts/setup.sh` - Environment setup
- `scripts/test.sh` - Testing framework

### With Workflows
The core engine supports the simplified workflows:
- `.github/workflows/evolve.yml` - Main evolution workflow
- `.github/workflows/test.yml` - Testing workflow

## 🚀 Usage Examples

### Basic Evolution Cycle
```bash
# 1. Setup environment
./src/evolution-core.sh setup

# 2. Collect context
./src/evolution-core.sh context

# 3. Simulate evolution
./src/evolution-core.sh simulate -p "Improve documentation" -m conservative

# 4. Apply changes
./src/evolution-core.sh apply evolution-output/evolution-response.json

# 5. Validate
./src/evolution-core.sh validate
```

### Custom Evolution
```bash
# Custom prompt with experimental mode
./src/evolution-core.sh simulate \
  -p "Add comprehensive error handling to all scripts" \
  -m experimental \
  -o custom-output
```

### Validation Only
```bash
# Run validation without changes
./src/evolution-core.sh validate
```

## 📁 Archive

The old complex architecture has been moved to `src/archive/`:
- `evolution-engine.sh` - Original complex engine
- `lib/` - Original modular library structure

These are preserved for reference but are no longer used.

## 🔧 Configuration

### Environment Variables
- `EVOLUTION_VERSION` - Current version (3.0.0)
- `PROJECT_ROOT` - Repository root directory
- `EVOLUTION_OUTPUT_DIR` - Output directory for evolution files
- `LOG_DIR` - Directory for log files

### Dependencies
- `jq` - JSON processing
- `tree` - Directory structure visualization (optional)
- `bash` - Shell environment

## 📈 Monitoring

### Logging
The core engine provides comprehensive logging:
- **Info**: General operation information
- **Success**: Successful operations
- **Warning**: Non-critical issues
- **Error**: Critical failures

### Output Files
- `evolution-output/repo-context.json` - Repository context
- `evolution-output/evolution-response.json` - AI response
- `evolution-output/structure.json` - File structure (if tree available)

## 🛠️ Development

### Adding Features
To add new features to the core engine:

1. **Add function**: Define new function in the script
2. **Add command**: Add case to main() function
3. **Add help**: Update help text
4. **Test**: Run validation tests

### Example Addition
```bash
# Add new feature
new_feature() {
    log_info "Running new feature..."
    # Implementation here
    log_success "New feature completed"
}

# Add to main()
case "$command" in
    "new-feature")
        new_feature "$@"
        ;;
    # ... existing cases
esac
```

## 🔍 Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x src/evolution-core.sh
   ```

2. **Missing Dependencies**
   ```bash
   # Install jq
   sudo apt-get install jq
   
   # Install tree (optional)
   sudo apt-get install tree
   ```

3. **Invalid JSON**
   ```bash
   # Validate JSON files
   jq empty evolution-output/*.json
   ```

### Debug Mode
Enable verbose output by setting environment variables:
```bash
export DEBUG=true
export VERBOSE=true
./src/evolution-core.sh simulate -p "test"
```

---

**Note**: This simplified architecture represents a significant improvement in maintainability and usability while preserving all essential evolution functionality. 