# 🚨 Troubleshooting Guide

This guide helps you resolve common issues with the AI Evolution Engine.

## 🔍 Quick Diagnostics

Run the diagnostic test to identify issues:

```bash
./scripts/test.sh validation
```

This will check:
- Essential files exist
- Scripts are executable
- Dependencies are available
- Git repository status

## ❌ Common Issues

### Script Permission Errors

**Problem**: `Permission denied` when running scripts

**Solution**:
```bash
chmod +x scripts/*.sh
```

**Prevention**: Run setup script to set permissions automatically:
```bash
./scripts/setup.sh
```

### Missing Dependencies

**Problem**: `command not found` for jq, curl, or git

**Solution**:

**macOS**:
```bash
brew install jq curl git
```

**Ubuntu/Debian**:
```bash
sudo apt-get update
sudo apt-get install jq curl git
```

**CentOS/RHEL**:
```bash
sudo yum install jq curl git
```

**Windows**: Download from official websites:
- [jq](https://stedolan.github.io/jq/download/)
- [curl](https://curl.se/windows/)
- [git](https://git-scm.com/download/win)

### Git Configuration Issues

**Problem**: Git user not configured

**Solution**:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Problem**: Not in a git repository

**Solution**:
```bash
git init
git add .
git commit -m "Initial commit"
```

### JSON Processing Errors

**Problem**: `jq` command fails or produces unexpected output

**Solution**:
```bash
# Test jq installation
echo '{"test": "value"}' | jq -r '.test'

# Should output: value
```

**If jq is not working**:
```bash
# Reinstall jq
# macOS
brew reinstall jq

# Ubuntu/Debian
sudo apt-get install --reinstall jq

# CentOS/RHEL
sudo yum reinstall jq
```

### Bash Version Issues

**Problem**: Scripts fail with syntax errors

**Check bash version**:
```bash
bash --version
```

**Solution**: Ensure bash 4.0 or higher:
```bash
# macOS
brew install bash

# Ubuntu/Debian
sudo apt-get install bash

# CentOS/RHEL
sudo yum install bash
```

## 🔧 Evolution-Specific Issues

### Context Collection Fails

**Problem**: `./scripts/evolve.sh context` fails

**Diagnosis**:
```bash
# Check if output directory exists
ls -la evolution-output/

# Check script permissions
ls -la scripts/evolve.sh
```

**Solution**:
```bash
# Create output directory
mkdir -p evolution-output

# Fix permissions
chmod +x scripts/evolve.sh

# Run with verbose output
./scripts/evolve.sh context -v
```

### Evolution Simulation Fails

**Problem**: `./scripts/evolve.sh simulate` fails

**Diagnosis**:
```bash
# Check if context file exists
ls -la evolution-output/repo-context.json

# Check JSON syntax
jq . evolution-output/repo-context.json
```

**Solution**:
```bash
# Regenerate context
./scripts/evolve.sh context

# Run simulation with custom prompt
./scripts/evolve.sh simulate -p "Test evolution" -v
```

### Test Failures

**Problem**: `./scripts/test.sh` reports failures

**Diagnosis**:
```bash
# Run specific test types
./scripts/test.sh scripts
./scripts/test.sh validation
./scripts/test.sh unit
```

**Common test failures and solutions**:

**Script syntax errors**:
```bash
# Check syntax
bash -n scripts/evolve.sh

# Fix common issues
dos2unix scripts/*.sh  # If files have Windows line endings
```

**Missing files**:
```bash
# Check essential files
ls -la README.md scripts/evolve.sh .gitignore

# Create missing files if needed
touch README.md .gitignore
```

**Permission issues**:
```bash
# Fix all script permissions
find scripts/ -name "*.sh" -exec chmod +x {} \;
find src/ -name "*.sh" -exec chmod +x {} \;
```

## 🌐 GitHub Actions Issues

### Workflow Failures

**Problem**: GitHub Actions workflows fail

**Check workflow files**:
```bash
# Validate YAML syntax
yamllint .github/workflows/*.yml

# Check workflow structure
grep -n "name:" .github/workflows/*.yml
```

**Common workflow issues**:

**Missing dependencies in CI**:
```yaml
# In .github/workflows/ai_evolver.yml
- name: Install dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y jq curl git tree
```

**Permission issues**:
```yaml
# Add permissions
permissions:
  contents: write
  pull-requests: write
  issues: write
```

**Timeout issues**:
```yaml
# Add timeout
timeout-minutes: 10
```

### Authentication Issues

**Problem**: GitHub CLI authentication fails

**Solution**:
```bash
# Login to GitHub CLI
gh auth login

# Check authentication status
gh auth status
```

**For CI/CD**:
```yaml
# Use GITHUB_TOKEN
- name: Authenticate
  run: |
    echo "${{ secrets.GITHUB_TOKEN }}" | gh auth login --with-token
```

## 📊 Performance Issues

### Slow Evolution Cycles

**Problem**: Evolution takes too long

**Optimization**:
```bash
# Use minimal intensity
./scripts/evolve.sh evolve -i minimal

# Enable dry-run for testing
./scripts/evolve.sh evolve -d

# Limit context collection
./scripts/evolve.sh context -o ./limited-context
```

### Memory Issues

**Problem**: Scripts consume too much memory

**Solution**:
```bash
# Monitor memory usage
top -p $$

# Use smaller data sets
./scripts/evolve.sh context --limit 1000
```

## 🔍 Debugging

### Enable Verbose Output

```bash
# Enable verbose logging
./scripts/evolve.sh evolve -v

# Enable debug mode
set -x
./scripts/evolve.sh evolve
set +x
```

### Check Logs

```bash
# View recent logs
ls -la logs/

# Check specific log file
tail -f logs/evolution-$(date +%Y%m%d).log
```

### Test Individual Components

```bash
# Test context collection
./scripts/evolve.sh context -v

# Test simulation
./scripts/evolve.sh simulate -p "Test" -v

# Test validation
./scripts/evolve.sh validate -v
```

## 🆘 Getting Help

### Self-Diagnosis

1. **Run diagnostics**:
   ```bash
   ./scripts/test.sh validation
   ```

2. **Check system info**:
   ```bash
   bash --version
   git --version
   jq --version
   ```

3. **Verify setup**:
   ```bash
   ./scripts/setup.sh --dry-run
   ```

### Reporting Issues

When reporting issues, include:

1. **System information**:
   ```bash
   uname -a
   bash --version
   ```

2. **Error messages**: Copy the exact error output

3. **Steps to reproduce**: List the exact commands run

4. **Expected vs actual behavior**: What you expected vs what happened

### Community Support

- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: Check this guide and other docs
- **Examples**: Look at example files for reference

## 🔄 Recovery Procedures

### Reset to Working State

```bash
# Reset git repository
git reset --hard HEAD
git clean -fd

# Re-run setup
./scripts/setup.sh

# Re-run tests
./scripts/test.sh
```

### Backup and Restore

```bash
# Create backup
tar -czf backup-$(date +%Y%m%d).tar.gz .

# Restore from backup
tar -xzf backup-YYYYMMDD.tar.gz
```

### Clean Slate

```bash
# Remove generated files
rm -rf evolution-output/
rm -rf logs/
rm -rf tests/results/

# Recreate directories
mkdir -p evolution-output logs tests/results
```

---

**Remember**: The AI Evolution Engine is designed to be self-healing. Most issues can be resolved by running the setup and test scripts again. 