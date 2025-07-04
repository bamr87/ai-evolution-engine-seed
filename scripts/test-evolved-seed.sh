#!/bin/bash
# scripts/test-evolved-seed.sh
# Tests the evolved seed functionality

set -euo pipefail

GROWTH_MODE="${1:-test-automation}"

echo "🧪 Testing evolved seed functionality..."

# Check if testing automation init script exists
if [ -f "testing_automation_init.sh" ]; then
    echo "📋 Found testing automation init script"
    chmod +x testing_automation_init.sh
    
    # Create a test directory and run the seed
    echo "🏗️  Setting up test environment..."
    mkdir -p test-evolution
    cd test-evolution
    
    echo "🌱 Running seed initialization..."
    if ../testing_automation_init.sh; then
        echo "✅ Seed initialization successful"
    else
        echo "❌ Seed initialization failed"
        exit 1
    fi
    
    # Run the generated tests
    if [ -x "scripts/test.sh" ]; then
        echo "🧪 Running generated tests..."
        if ./scripts/test.sh --verbose; then
            echo "✅ Tests passed"
        else
            echo "❌ Tests failed"
            exit 1
        fi
    else
        echo "⚠️  No test script found, skipping tests"
    fi
    
    # Test the build process
    if [ -x "scripts/build.sh" ]; then
        echo "🏗️  Testing build process..."
        if ./scripts/build.sh --dry-run; then
            echo "✅ Build test successful"
        else
            echo "❌ Build test failed"
            exit 1
        fi
    else
        echo "⚠️  No build script found, skipping build test"
    fi
    
    cd ..
    echo "🧹 Cleaning up test environment..."
    rm -rf test-evolution
    
else
    echo "⚠️  No testing automation init script found"
    echo "🔍 Available scripts:"
    ls -la scripts/ 2>/dev/null || echo "No scripts directory found"
fi

echo "✅ Seed testing completed for growth mode: $GROWTH_MODE"
