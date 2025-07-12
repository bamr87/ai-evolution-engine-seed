# 🚀 Getting Started with AI Evolution Engine

Welcome to the AI Evolution Engine! This guide will help you get up and running quickly.

## 📋 Prerequisites

Before you begin, ensure you have:

- **Bash** (version 4.0 or higher)
- **Git** (for version control)
- **jq** (for JSON processing)
- **curl** (for HTTP requests)

## 🔧 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/ai-evolution-engine-seed.git
cd ai-evolution-engine-seed
```

### 2. Run Setup

The setup script will install dependencies and configure your environment:

```bash
./scripts/setup.sh
```

This will:
- Install required dependencies (jq, curl, git)
- Configure git settings
- Set up script permissions
- Create necessary directories
- Validate the setup

### 3. Verify Installation

Run the test suite to ensure everything is working:

```bash
./scripts/test.sh
```

You should see all tests passing with a 100% success rate.

## 🎯 Basic Usage

### Your First Evolution

Run a basic evolution cycle:

```bash
./scripts/evolve.sh evolve
```

This will:
1. Collect repository context
2. Simulate AI evolution
3. Apply changes (if not in dry-run mode)
4. Validate the results

### Evolution Types

Choose the type of evolution you want:

```bash
# Consistency improvements
./scripts/evolve.sh evolve -t consistency

# Error fixing
./scripts/evolve.sh evolve -t error_fixing

# Documentation improvements
./scripts/evolve.sh evolve -t documentation

# Custom evolution
./scripts/evolve.sh evolve -t custom -p "Add user authentication"
```

### Growth Modes

Control the intensity of changes:

```bash
# Conservative (safe, minimal changes)
./scripts/evolve.sh evolve -m conservative

# Adaptive (balanced improvements)
./scripts/evolve.sh evolve -m adaptive

# Experimental (advanced features)
./scripts/evolve.sh evolve -m experimental
```

## 🔍 Exploring the System

### Context Collection

See what the AI learns about your repository:

```bash
./scripts/evolve.sh context
```

This creates a JSON file with repository information, file structure, and configuration.

### Simulation Mode

Test evolution changes without applying them:

```bash
./scripts/evolve.sh simulate -p "Improve error handling" -d
```

The `-d` flag enables dry-run mode, showing what would be changed without actually making changes.

### Validation

Check your repository state:

```bash
./scripts/evolve.sh validate
```

This validates essential files, script permissions, and git status.

## 🧪 Testing

### Run All Tests

```bash
./scripts/test.sh
```

### Test Specific Components

```bash
# Test scripts only
./scripts/test.sh scripts

# Test workflows only
./scripts/test.sh workflows

# Test validation functions
./scripts/test.sh validation
```

### Generate Reports

```bash
# JSON report
./scripts/test.sh -f json all

# HTML report
./scripts/test.sh -f html all
```

## 📊 Understanding Evolution

### Evolution Cycle

Each evolution cycle follows this pattern:

1. **Context Collection**: Gather repository information
2. **AI Analysis**: Process context and generate evolution plan
3. **Change Application**: Apply improvements to the codebase
4. **Validation**: Verify changes and maintain quality
5. **Metrics Update**: Track evolution progress

### Evolution Types Explained

- **Consistency**: Fixes formatting, naming, and structural issues
- **Error Fixing**: Addresses bugs and improves robustness
- **Documentation**: Updates and improves documentation quality
- **Code Quality**: Enhances maintainability and readability
- **Security Updates**: Applies security improvements
- **Custom**: Uses your specific prompt for targeted improvements

### Growth Modes Explained

- **Conservative**: Safe, minimal changes that preserve functionality
- **Adaptive**: Balanced improvements with moderate risk
- **Experimental**: Advanced features with higher risk/reward

## 🔧 Configuration

### Environment Variables

You can customize behavior with environment variables:

```bash
# Set evolution type
export EVOLUTION_TYPE="consistency"

# Set growth mode
export GROWTH_MODE="conservative"

# Enable verbose output
export VERBOSE="true"

# Enable dry-run mode
export DRY_RUN="true"
```

### Output Directory

Customize where results are saved:

```bash
./scripts/evolve.sh evolve -o ./my-evolution-output
```

## 🚨 Troubleshooting

### Common Issues

**Script not executable:**
```bash
chmod +x scripts/evolve.sh scripts/setup.sh scripts/test.sh
```

**Missing dependencies:**
```bash
# On macOS
brew install jq curl git

# On Ubuntu/Debian
sudo apt-get install jq curl git

# On CentOS/RHEL
sudo yum install jq curl git
```

**Git not configured:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Getting Help

- **Script help**: `./scripts/evolve.sh --help`
- **Test help**: `./scripts/test.sh --help`
- **Setup help**: `./scripts/setup.sh --help`

## 📈 Next Steps

Now that you're set up, explore:

1. **[Evolution Process](evolution.md)** - Learn how the AI evolution system works
2. **[Advanced Usage](advanced-evolution.md)** - Complex evolution scenarios
3. **[Troubleshooting](troubleshooting.md)** - Common issues and solutions
4. **[API Reference](../api/scripts.md)** - Complete script documentation

## 🤝 Contributing

Ready to contribute? See the [Contributing Guide](contributing.md) for guidelines and best practices.

---

**Happy evolving! 🌱** 