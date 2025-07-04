#!/bin/bash
# scripts/setup-environment.sh
# Sets up the necessary environment for evolution workflows

set -euo pipefail

echo "🌱 Setting up evolution environment..."

# Install dependencies
echo "📦 Installing dependencies..."
npm install -g jq
sudo apt-get update
sudo apt-get install -y ruby-full tree

# Validate required files exist
echo "🔍 Validating required files..."
if [ ! -f "evolution-metrics.json" ]; then
    echo "⚠️  evolution-metrics.json not found, creating default..."
    cat > evolution-metrics.json << 'EOF'
{
  "seed_version": "0.2.0-seed",
  "growth_cycles": 0,
  "current_generation": 0,
  "adaptations_logged": 0,
  "last_growth_spurt": "Never",
  "last_prompt": null,
  "evolution_history": []
}
EOF
fi

# Ensure scripts are executable
echo "🔧 Setting script permissions..."
chmod +x scripts/*.sh

echo "✅ Environment setup complete"
