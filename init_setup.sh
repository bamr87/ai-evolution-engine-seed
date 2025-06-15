#!/bin/bash

#############################################################################
# 🌱 AI Evolution Engine - Seed Germination Script 🌱
# Version: 0.1.0-seed
# Purpose: Plant the seeds of self-evolving software
#############################################################################

set -euo pipefail

# Colors for visual growth
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Seed configuration
SEED_VERSION="0.1.0-seed"
REPO_NAME="${REPO_NAME:-ai-evolution-engine}"
GROWTH_STAGE="${GROWTH_STAGE:-germination}"

# Display seed banner
show_seed_banner() {
    echo -e "${GREEN}"
    cat << "EOF"
    🌱 ════════════════════════════════════════════ 🌱
           AI EVOLUTION ENGINE SEED PLANTER         
         "From tiny seeds, mighty code grows"       
    🌱 ════════════════════════════════════════════ 🌱
EOF
    echo -e "${NC}"
}

# Plant the seed
plant_seed() {
    echo -e "${GREEN}🌱 Planting AI Evolution Seed v${SEED_VERSION}...${NC}"
    
    # Create fertile soil (directory structure)
    echo -e "${CYAN}Preparing soil...${NC}"
    mkdir -p {.github/workflows,prompts,src,tests,docs}
    
    # Check for growth requirements
    echo -e "${CYAN}Checking growth conditions...${NC}"
    command -v git >/dev/null 2>&1 || { echo "Git required for growth"; exit 1; }
    command -v curl >/dev/null 2>&1 || { echo "Curl required for nutrients"; exit 1; }
    
    # Initialize growth environment
    if [ ! -d .git ]; then
        git init
        echo -e "${GREEN}✓ Growth environment initialized${NC}"
    fi
    
    # Create evolution configuration
    cat > .evolution.yml << 'EOF'
# 🌱 Evolution Configuration
version: 1.0
growth:
  stage: germination
  strategy: adaptive
  auto_evolve: true
  
ai:
  provider: ${AI_PROVIDER:-openai}
  model: ${AI_MODEL:-gpt-4}
  temperature: 0.7
  
evolution:
  max_tokens_per_growth: 100000
  require_tests: true
  preserve_core: true
  
sustainability:
  track_growth: true
  optimize_resources: true
  share_seeds: true
EOF

    # Create growth tracker
    cat > evolution-metrics.json << 'EOF'
{
  "seed_version": "0.1.0",
  "planted_at": "2025-06-15T20:34:48Z",
  "growth_cycles": 0,
  "adaptations": [],
  "next_evolution": null
}
EOF

    # Create first prompt example
    cat > prompts/first_growth.md << 'EOF'
# 🌱 First Growth Prompt

Help this seed grow into a simple web API that:
- Tracks plant growth in a garden
- Allows users to log watering and care activities
- Provides growth insights and recommendations
- Includes tests and documentation

Remember: sustainable, adaptable, accelerated growth!
EOF

    # Git initial commit
    git add -A
    git commit -m "🌱 Seed planted: AI Evolution Engine v${SEED_VERSION}" || true
    
    echo -e "${GREEN}"
    echo "════════════════════════════════════════════════"
    echo "    🌱 SEED SUCCESSFULLY PLANTED! 🌱"
    echo "════════════════════════════════════════════════"
    echo -e "${NC}"
    echo
    echo "Next steps to grow your code:"
    echo "1. Set your AI provider key: export AI_API_KEY='your-key'"
    echo "2. Create the workflow file: .github/workflows/ai_evolver.yml"
    echo "3. Run your first evolution: gh workflow run ai_evolver.yml"
    echo
    echo -e "${GREEN}Happy growing! 🌱${NC}"
}

# Main execution
main() {
    show_seed_banner
    plant_seed
}

# Run the seed planter
main "$@"