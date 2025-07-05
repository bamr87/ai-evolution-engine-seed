#!/bin/bash

#############################################################################
# 🌱 AI Evolution Engine - Seed Germination Script 🌱
# Version: 0.3.6-seed
# Purpose: Plant the seeds of self-evolving software, v0.3.6 with organized documentation structure
#############################################################################

set -euo pipefail

# Colors for visual growth
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SEED_VERSION="0.3.6-seed"
REPO_NAME="${REPO_NAME:-ai-evolution-engine}"

# Display seed banner
show_seed_banner() {
    echo -e "${GREEN}"
    cat << "EOF"
    🌱 ════════════════════════════════════════════ 🌱
           AI EVOLUTION ENGINE - SEED PLANTER v0.3.6
         "Organized documentation structure implementation"
         "Clean docs/ hierarchy following best practices"
    🌱 ════════════════════════════════════════════ 🌱
EOF
    echo -e "${NC}"
}

# Create essential directories
create_directories() {
    echo -e "${CYAN}Creating fertile soil (directories)...${NC}"
    mkdir -p .github/workflows prompts src tests docs/guides docs/architecture docs/evolution docs/workflows docs/seeds
    echo -e "${GREEN}✓ Directories created: .github/workflows, prompts, src, tests, docs/[guides|architecture|evolution|workflows|seeds]${NC}"
}

# Check for growth requirements
check_requirements() {
    echo -e "${CYAN}Checking growth conditions...${NC}"
    command -v git >/dev/null 2>&1 || { echo -e "${YELLOW}Git is required for growth. Please install Git.${NC}"; exit 1; }
    command -v gh >/dev/null 2>&1 || { echo -e "${YELLOW}GitHub CLI (gh) is recommended for workflow interaction. Please install gh.${NC}"; }
    echo -e "${GREEN}✓ Growth conditions met${NC}"
}

# Initialize Git repository
initialize_git() {
    if [ -d .git ]; then
        echo -e "${YELLOW}Git repository already initialized.${NC}"
    else
        echo -e "${CYAN}Initializing Git repository...${NC}"
        git init
        echo -e "${GREEN}✓ Git repository initialized${NC}"
    fi
}

# Create .gitignore
create_gitignore() {
    echo -e "${CYAN}Creating .gitignore...${NC}"
    cat > .gitignore << 'EOF'
# General ignores
.DS_Store
*.log
*.tmp
*.swp

# Python
*.pyc
__pycache__/
*.env
venv/
env/

# Node.js
node_modules/
npm-debug.log
yarn-error.log

# Build artifacts
build/
dist/

# IDE specific
.vscode/
.idea/
*.iml
EOF
    echo -e "${GREEN}✓ .gitignore created${NC}"
}

# Create .gptignore (for AI context)
create_gptignore() {
    echo -e "${CYAN}Creating .gptignore...${NC}"
    cat > .gptignore << 'EOF'
# Exclude version control
.git/

# Exclude sensitive environment files
*.env
*.secret

# Exclude large dependency directories
node_modules/
venv/
env/

# Build outputs
build/
dist/

# Temporary files
*.tmp
*.swp
*.bak
EOF
    echo -e "${GREEN}✓ .gptignore created${NC}"
}

# Create README.md
create_readme() {
    echo -e "${CYAN}Planting README.md (v0.3.6)...${NC}"
    # Using a heredoc for the README content. Ensure no unintended expansions.
    # The content is taken from the user's context for README.md v0.3.6
    cat > README.md << 'EOF'
# 🌱 AI Evolution Engine: The Self-Growing Repository 🌱

```
╔═══════════════════════════════════════════════════════════════╗
║                   AI EVOLUTION ENGINE                         ║
║         Where Seeds Grow Into Intelligent Software            ║
║                      v0.3.6-seed                              ║
╚═══════════════════════════════════════════════════════════════╝
```

[![Version](https://img.shields.io/badge/version-0.2.0--seed-blue.svg)](https://github.com/bamr87/ai-evolution-engine)
[![Evolution Status](https://img.shields.io/badge/status-sapling-green.svg)]()
[![Growth Potential](https://img.shields.io/badge/potential-expanding-purple.svg)]()

> 🌱 **This seed is alive. Plant it, nurture it with prompts, and watch AI guide its growth.**

This repository is a living experiment in AI-driven software evolution. It's designed to adapt, learn, and improve itself with each "growth cycle," guided by your prompts and an AI engine.

## 🌿 Core Philosophy: Digital Symbiosis

We believe in software that grows organically, much like a plant from a seed. This involves:
- **Sustainability**: Each evolution builds upon stable foundations.
- **Adaptability**: The system learns and refines its growth patterns.
- **Acceleration**: AI handles boilerplate and complex transformations, letting humans focus on vision.

## 🧬 Seed Anatomy (v0.3.6)

1.  **`README.md` (This file)**: A dynamic chronicle of the repository's evolution. The section below is updated by the AI.
    <!-- AI-EVOLUTION-MARKER:START -->
    **Evolutionary State:**
    - Generation: 0
    - Adaptations Logged: 0
    - Last Growth Spurt: Never
    <!-- AI-EVOLUTION-MARKER:END -->
2.  **`init_setup.sh`**: The germination script. It now sets up a complete v0.3.6 environment, including this README, the AI workflow, and initial configurations.
3.  **`.github/workflows/ai_evolver.yml`**: The heart of the growth engine. In v0.3.6, it simulates AI-driven changes more deeply, including README updates and dynamic generation of the next seed.
4.  **`.seed.md`**: The blueprint for the *next* generation. The v0.3.6 workflow generates a `.seed.md` that outlines the path towards v0.3.6, based on the current cycle's "learnings."
5.  **`evolution-metrics.json`**: Tracks the quantitative aspects of growth.
6.  **`.gptignore`**: A new file to help guide the AI's focus by excluding irrelevant files from its context.

## 🚀 Quick Germination & Growth

```bash
# 1. Plant the v0.3.6 seed (if you haven't already)
# Ensure you're in an empty directory for a new project
# curl -fsSL https://raw.githubusercontent.com/bamr87/ai-evolution-engine/main/init_setup.sh -o init_setup.sh # Get latest
# For this specific v0.3.6, ensure you're using the v0.3.6 version of this script.
bash init_setup.sh

# 2. Set your AI API Key (if using a real AI in the future)
# export AI_API_KEY="your_actual_ai_key_here"

# 3. Initiate a growth cycle via GitHub Actions
gh workflow run ai_evolver.yml -f prompt="Evolve the project to include a basic REST API for tracking plant growth." -f growth_mode="adaptive"
```
*(Requires GitHub CLI `gh` to be installed and authenticated)*

## 🌳 The Growth Cycle Explained

```mermaid
graph TD
    A[🌱 Seed v0.3.6] --> B[💡 User Prompt (e.g., 'Add feature X')]
    B --> C[🤖 ai_evolver.yml Workflow Triggered]
    C --> D[🧬 Context Collection (incl. .gptignore)]
    D --> E[🧠 Simulated AI Processing]
    E --> F[📝 Changes Proposed (Code, README, Metrics)]
    F --> G[BRANCH{New Git Branch}]
    G -- Apply Changes --> H[💻 Codebase Evolves]
    H --> I[📊 Metrics Updated]
    I --> J[📄 README Updated (see markers)]
    J --> K[🌰 New .seed.md Generated (for v0.3.6)]
    K --> L[✅ PR Created for Review]
    L -- Merge --> A_NEXT[🌱 Evolved Seed (ready for next cycle)]
```

## 🧪 Seed Vitality Metrics (Aspirational for v0.3.6)

- **Germination Success**: Aiming for >98% clean setup.
- **Simulated Adaptation Rate**: 100% (as it's currently simulated).
- **Documentation Cohesion**: README and code evolve together.

## 🌍 Join the Digital Arboretum

This is more than just a template; it's a call to explore a new way of building software. By planting this seed, you're participating in an experiment to create self-evolving, intelligent applications.

---

*🌱 Generated by AI Evolution Engine Seed v0.3.6*
*"The code that grows itself, knows itself."*
EOF
    echo -e "${GREEN}✓ README.md created${NC}"
}

# Create .evolution.yml configuration
create_evolution_config() {
    echo -e "${CYAN}Creating .evolution.yml configuration...${NC}"
    cat > .evolution.yml << 'EOF'
# 🌱 Evolution Configuration
version: 1.0
growth:
  stage: sapling # Updated from germination
  strategy: adaptive
  auto_evolve: true # Corresponds to auto_plant_seeds in workflow?

ai:
  provider: ${AI_PROVIDER:-openai} # Placeholder, actual AI call not in v0.3.6 workflow
  model: ${AI_MODEL:-gpt-4-turbo}
  temperature: 0.6

evolution:
  max_context_files: 50
  max_context_line_per_file: 1000
  require_tests_for_features: true # Aspirational
  preserve_core_logic: true

sustainability:
  track_growth_metrics: true
  optimize_for_maintainability: true
  share_seed_improvements: true # Via the .seed.md mechanism
EOF
    echo -e "${GREEN}✓ .evolution.yml created${NC}"
}

# Create evolution-metrics.json
create_evolution_metrics() {
    echo -e "${CYAN}Creating evolution-metrics.json...${NC}"
    cat > evolution-metrics.json << EOF
{
  "seed_version": "${SEED_VERSION}",
  "planted_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "growth_cycles": 0,
  "current_generation": 0,
  "adaptations_logged": 0,
  "last_growth_spurt": "Never",
  "last_prompt": null,
  "evolution_history": []
}
EOF
    echo -e "${GREEN}✓ evolution-metrics.json created${NC}"
}

# Create initial .seed.md (describing this v0.3.6 seed)
create_initial_seed_md() {
    echo -e "${CYAN}Creating initial .seed.md (v0.3.6 descriptor)...${NC}"
    cat > .seed.md << 'EOF'
# 🌱 AI Evolution Engine - Seed v0.3.6 🌱

This is the bootstrap seed file for the AI Evolution Engine, version 0.2.0.
It describes the capabilities and structure of this specific seed generation.

## 🧬 Core Components of Seed v0.3.6

- **`README.md`**: Now features dynamic markers (`<!-- AI-EVOLUTION-MARKER:START -->` and `<!-- AI-EVOLUTION-MARKER:END -->`) for AI-driven updates on evolution status.
- **`init_setup.sh`**: A more robust germination script that initializes the full v0.3.6 environment, including this `.seed.md`, the primary `README.md`, the AI workflow, `.gitignore`, `.gptignore`, and essential configuration files.
- **`.github/workflows/ai_evolver.yml`**: An enhanced GitHub Actions workflow.
    - Simulates AI-driven evolution more deeply.
    - (Simulated) AI generates complete new versions of `README.md` and `evolution-metrics.json`.
    - Utilizes `.gptignore` for more focused context collection.
    - Dynamically generates a *new* `.seed.md` file after each growth cycle, outlining the next evolutionary step (e.g., towards v0.3.6).
- **`evolution-metrics.json`**: Tracks key metrics about the repository's growth and evolution.
- **`.gptignore`**: Allows fine-tuning of files included in the AI's context, improving focus and efficiency.
- **`.evolution.yml`**: Configuration for the evolution process.

## 🚀 How to Use This Seed

1.  **Plant**: Run `bash init_setup.sh` in a new project directory. This will lay down all the v0.3.6 files.
2.  **Nurture**: Trigger the `ai_evolver.yml` workflow with a prompt:
    ```bash
    gh workflow run ai_evolver.yml -f prompt="Your evolutionary goal here"
    ```
3.  **Observe**: A new branch will be created with changes (simulated by the AI). `README.md` and `evolution-metrics.json` will be updated. A new `.seed.md` pointing towards the next evolution (v0.3.6) will be generated.
4.  **Iterate**: Merge the changes and repeat the process.

## 🌱 What's Next? (The Role of the *Generated* `.seed.md`)

After a growth cycle using `ai_evolver.yml`, a *new* `.seed.md` file will be created. That file will contain:
- A summary of the "learnings" or changes from that cycle.
- A blueprint for the *next* potential version (e.g., v0.3.6).
- Suggestions for features and improvements for the core evolution engine itself.

This current file (`.seed.md` created by `init_setup.sh`) serves as the stable description of the v0.3.6 seed. The one generated by the workflow is the forward-looking, evolving seed.

---
*🌱 AI Evolution Engine - Seed v0.3.6: Ready for Growth!*
EOF
    echo -e "${GREEN}✓ Initial .seed.md (v0.3.6) created${NC}"
}

# Create ai_evolver.yml GitHub Workflow
create_ai_evolver_workflow() {
    echo -e "${CYAN}Creating .github/workflows/ai_evolver.yml (v0.3.6)...${NC}"
    # Content is from user context for ai_evolver.yml v0.3.6
    cat > .github/workflows/ai_evolver.yml << 'EOF'
name: 🌱 AI Evolution Growth Engine (v0.3.6)

on:
  workflow_dispatch:
    inputs:
      prompt:
        description: 'Growth instructions for the AI (e.g., "Implement user authentication")'
        required: true
        type: string
      growth_mode:
        description: 'Growth strategy (conservative, adaptive, experimental)'
        required: false
        default: 'adaptive'
        type: choice
        options:
          - conservative
          - adaptive
          - experimental
      auto_plant_seeds: # This now refers to auto-committing the new .seed.md
        description: 'Automatically commit the newly generated .seed.md for next evolution?'
        required: false
        default: true
        type: boolean

permissions:
  contents: write
  pull-requests: write
  issues: write # If AI needs to create issues for complex tasks

jobs:
  evolve:
    name: 🌿 Growth Cycle v0.3.6
    runs-on: ubuntu-latest
    
    steps:
      - name: 🌱 Prepare Growth Environment
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Need full history for some context, potentially
          
      - name: 🧬 Collect Repository DNA & Metrics
        id: collect_context
        run: |
          echo "🧬 Analyzing repository genome and current metrics..."
          CONTEXT_FILE="/tmp/repo_context.json"
          
          # Initialize context with metadata and metrics
          METRICS_CONTENT=$(cat evolution-metrics.json || echo '{}')
          jq -n \
            --argjson metrics "$METRICS_CONTENT" \
            --arg prompt "${{ inputs.prompt }}" \
            --arg growth_mode "${{ inputs.growth_mode }}" \
            '{
              "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
              "user_prompt": $prompt,
              "growth_mode": $growth_mode,
              "current_metrics": $metrics,
              "repository_structure": $(tree -J -L 3 -I ".git|node_modules|venv|dist|build" || echo "[]"),
              "files": {}
            }' > "$CONTEXT_FILE"

          # Add file contents (respecting .gptignore if present, else common ignores)
          IGNORE_PATTERNS='\.git|\.DS_Store|node_modules|venv|env|dist|build|\*.pyc|__pycache__|\*.log|\*.tmp|\*.swp'
          if [ -f .gptignore ]; then
            GPTIGNORE_PATTERNS=$(cat .gptignore | grep -v '^#' | grep -v '^[[:space:]]*$' | sed 's|/$|/.*|' | paste -sd '|')
            if [ -n "$GPTIGNORE_PATTERNS" ]; then
              IGNORE_PATTERNS="$IGNORE_PATTERNS|$GPTIGNORE_PATTERNS"
            fi
          fi
          
          find . -type f | grep -Ev "$IGNORE_PATTERNS" | head -n $(jq -r '.evolution.max_context_files // 50' .evolution.yml 2>/dev/null || echo 50) | \
          while IFS= read -r file; do
            echo "Adding $file to context..."
            # Ensure file path is a valid JSON string key
            file_key=$(echo "$file" | sed 's|^\./||')
            jq --arg path "$file_key" \
               --arg content "$(cat "$file" | head -n $(jq -r '.evolution.max_context_line_per_file // 1000' .evolution.yml 2>/dev/null || echo 1000))" \
              '.files[$path] = $content' "$CONTEXT_FILE" > "${CONTEXT_FILE}.tmp" && mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"
          done
          echo "Context collected in $CONTEXT_FILE"
          cat $CONTEXT_FILE # For debugging
          
      - name: 🧠 Invoke Simulated AI Growth Engine
        id: ai_growth_simulation
        run: |
          echo "🧠 Simulating AI growth cycle based on prompt: ${{ inputs.prompt }}"
          CONTEXT_FILE="/tmp/repo_context.json"
          RESPONSE_FILE="/tmp/evolution_response.json"
          
          CURRENT_METRICS_JSON=$(jq -r '.current_metrics' "$CONTEXT_FILE")
          CURRENT_CYCLE=$(echo "$CURRENT_METRICS_JSON" | jq -r '.growth_cycles // 0')
          CURRENT_GENERATION=$(echo "$CURRENT_METRICS_JSON" | jq -r '.current_generation // 0')
          NEW_CYCLE=$((CURRENT_CYCLE + 1))
          NEW_GENERATION=$((CURRENT_GENERATION + 1)) # Simple increment for simulation

          # Simulate updating evolution-metrics.json
          NEW_METRICS_CONTENT=$(echo "$CURRENT_METRICS_JSON" | jq \
            --arg new_cycle "$NEW_CYCLE" \
            --arg new_gen "$NEW_GENERATION" \
            --arg last_prompt "${{ inputs.prompt }}" \
            --arg last_growth "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
            '.growth_cycles = ($new_cycle | tonumber) |
             .current_generation = ($new_gen | tonumber) |
             .adaptations_logged += 1 |
             .last_growth_spurt = $last_growth |
             .last_prompt = $last_prompt |
             .evolution_history += [{"cycle": ($new_cycle | tonumber), "prompt": $last_prompt, "timestamp": $last_growth}]')
          
          # Simulate updating README.md
          # This will replace the content between the markers
          README_MARKER_START="<!-- AI-EVOLUTION-MARKER:START -->"
          README_MARKER_END="<!-- AI-EVOLUTION-MARKER:END -->"
          NEW_README_DYNAMIC_CONTENT="**Evolutionary State:**\n- Generation: $NEW_GENERATION\n- Adaptations Logged: $(echo "$NEW_METRICS_CONTENT" | jq .adaptations_logged)\n- Last Growth Spurt: $(echo "$NEW_METRICS_CONTENT" | jq .last_growth_spurt)\n- Last Prompt: ${{ inputs.prompt }}"
          
          # Read existing README, replace marker section (crude sed for multiline)
          # A more robust solution would use a proper templating engine or smarter AI replacement
          # For this simulation, we'll generate the whole README content
          CURRENT_README_CONTENT=$(cat README.md)
          # This is a simplified way to replace a block. A real AI might regenerate more.
          # Escaping for sed is tricky with arbitrary content.
          # So, for simplicity, the AI will provide the *full new README content*.
          # Let's build the new README content by replacing the dynamic block.
          # This is still complex for pure shell. Let's assume the AI generates the full new README.
          # For simulation, we'll just prepare the text that *would* go into the full README.
          # The actual replacement will be done by creating a new README.md file.

          # Construct the new README content (simplified)
          # This is a placeholder for a more sophisticated README update.
          # In a real scenario, the AI would craft this. Here, we just update the marker section.
          # For the simulation, we'll provide the *entire* new README content.
          # This is a bit of a cheat for the simulation, but easier to implement.
          # A real AI would be smarter.
          # The 'changes' array will carry this full content.
          # This part assumes the AI can reconstruct the README with the new stats.
          # For this simulation, we'll crudely replace the block.
          # This is still tricky. The AI response will just provide the NEW full README.

          # Let's make the AI generate the *entire* content for README.md and evolution-metrics.json
          # This simplifies the "Apply Growth Changes" step.
          
          # For README.md: Read existing, then try to replace the section.
          # This is a complex task for shell scripting if new_content has many special chars.
          # Alternative: AI generates full new README.
          # Let's stick to the "AI generates full file content" for changed files.

          # Generate new README.md content (Simulated AI creates this)
          # For now, we'll just focus on the metrics part and assume the rest is handled.
          # The AI would ideally get the README template and fill it.
          # For simulation, let's create a "new" README content string here.
          # This is a simplified example. A real AI would be much more sophisticated.
          # We will replace the content between markers in the existing README.
          # This is still hard. Let's assume the AI generates the full README content.
          # This is a placeholder for the AI's README generation.
          # It should take the existing README structure and update the dynamic part.
          
          # Read the original README content
          ORIGINAL_README_CONTENT=$(cat README.md)
          # Prepare the new dynamic content block
          DYNAMIC_BLOCK_CONTENT="    **Evolutionary State:**\n    - Generation: $NEW_GENERATION\n    - Adaptations Logged: $(echo "$NEW_METRICS_CONTENT" | jq -r .adaptations_logged)\n    - Last Growth Spurt: $(echo "$NEW_METRICS_CONTENT" | jq -r .last_growth_spurt)\n    - Last Prompt: ${{ inputs.prompt }}"
          # Use awk to replace content between markers. Relies on markers being on their own lines.
          # This is still fragile. If AI provides full content, it's more robust.
          # Let's go with: AI provides the *full* new README.md content.
          # For simulation, we'll just generate a new README string based on the old one + new stats.
          # This is too complex to do robustly in bash for the simulation.
          # The "evolution_response.json" will contain the *full text* for modified files.
          
          # Placeholder for full new README content generation by AI
          # This is where a real LLM would be prompted with the old README and new stats.
          # For simulation, we'll just indicate it changed.
          # For a better simulation, one could use sed to replace the block, but it's tricky.
          # For now, the "change" will be to evolution-metrics.json and a new .seed.md.
          # README update will be a simplified "touch" or small modification.
          # Let's make the AI output the *new content for the dynamic block only*.
          # And the apply step will use sed. This is more realistic for an AI.

          # Simulated AI generates new content for the dynamic block in README.md
          README_DYNAMIC_CONTENT_FOR_AI_RESPONSE="    **Evolutionary State:**\\n    - Generation: $NEW_GENERATION\\n    - Adaptations Logged: $(echo "$NEW_METRICS_CONTENT" | jq -r .adaptations_logged)\\n    - Last Growth Spurt: $(echo "$NEW_METRICS_CONTENT" | jq -r .last_growth_spurt)\\n    - Last Prompt: ${{ inputs.prompt }}"


          # Content for the next .seed.md
          NEXT_SEED_CONTENT=$(cat <<EOF_NEXT_SEED
# 🌱 AI Evolution Engine - Evolved Seed (Candidate for v0.3.6) 🌱

This seed was generated after growth cycle **#$NEW_CYCLE**.
**Prompt for this cycle:** "${{ inputs.prompt }}"
**Growth Mode:** ${{ inputs.growth_mode }}

## 🌿 Evolutionary Leap Summary

This cycle (simulated) focused on:
- Incrementing growth cycle to $NEW_CYCLE and generation to $NEW_GENERATION.
- Updating \`evolution-metrics.json\` with the latest statistics.
- Modifying \`README.md\` to reflect these new metrics within the \`AI-EVOLUTION-MARKER\` block.

## 🧬 Proposed Enhancements for v0.3.6 (Next Evolution)

Based on the current trajectory, the next evolutionary step (v0.3.6) should focus on:

1.  **True AI Integration (Conceptual):**
    *   Abstract the AI call: Create a script/interface (e.g., \`src/ai_interface.sh\`) that this workflow calls. Initially, it can use this simulation logic, but can be swapped for a real LLM call.
    *   Define a clear API for the AI: What inputs it needs, what outputs (JSON structure) it must provide.
2.  **Smarter Context Collection:**
    *   Prioritize files based on recent changes or importance tags.
    *   Allow dynamic adjustment of \`max_context_files\` and \`max_context_line_per_file\` based on prompt complexity.
3.  **Advanced README Updates:**
    *   Instead of just metrics, allow AI to add sections to README for new features (still using markers).
4.  **Modular Growth Actions:**
    *   Define specific "growth action types" in the AI response (e.g., \`create_file\`, \`modify_function\`, \`add_test\`, \`update_docs\`) beyond simple file replacement.

## 🚀 Planting this Evolved Seed

To continue evolution towards v0.3.6:
1.  Review and merge the Pull Request from this growth cycle.
2.  This \`.seed.md\` file now contains the refined blueprint.
3.  The next run of \`ai_evolver.yml\` will use the evolved codebase as its starting point.

---
*🌱 Generated by AI Evolution Engine v0.3.6 Workflow*
*"From sapling to forest, one cycle at a time."*
EOF_NEXT_SEED
)

          # Construct the AI response JSON
          # The AI will provide instructions to modify README using sed for the dynamic block
          # and full content for evolution-metrics.json
          cat > "$RESPONSE_FILE" <<EOF_RESPONSE
{
  "growth_id": "$(uuidgen)",
  "new_branch": "growth/$(date +%Y%m%d-%H%M%S)-${{ inputs.growth_mode }}-$NEW_CYCLE",
  "changes": [
    {
      "path": "evolution-metrics.json",
      "action": "replace_content",
      "content": $(echo "$NEW_METRICS_CONTENT" | jq -Rsa)
    },
    {
      "path": "README.md",
      "action": "update_readme_block",
      "marker_start": "$README_MARKER_START",
      "marker_end": "$README_MARKER_END",
      "new_block_content": $(echo "$README_DYNAMIC_CONTENT_FOR_AI_RESPONSE" | jq -Rsa)
    }
    // Add other simulated file changes here if needed
    // e.g., { "path": "src/new_module.py", "action": "create", "content": "# New AI Module\nprint('Hello from AI')" }
  ],
  "commit_message": "🌿 Growth Cycle #$NEW_CYCLE: ${{ inputs.prompt }}",
  "next_seed_content": $(echo "$NEXT_SEED_CONTENT" | jq -Rsa)
}
EOF_RESPONSE
          echo "AI simulation response generated: $RESPONSE_FILE"
          cat $RESPONSE_FILE # For debugging

      - name: 🌾 Apply Growth Changes
        run: |
          echo "🌾 Applying evolutionary changes..."
          RESPONSE_FILE="/tmp/evolution_response.json"
          BRANCH_NAME=$(jq -r .new_branch "$RESPONSE_FILE")
          
          echo "Creating and switching to new branch: $BRANCH_NAME"
          git checkout -b "$BRANCH_NAME"
          
          # Apply file changes from AI response
          jq -c '.changes[]' "$RESPONSE_FILE" | while read -r change_json; do
            path=$(echo "$change_json" | jq -r '.path')
            action=$(echo "$change_json" | jq -r '.action')
            
            mkdir -p "$(dirname "$path")"
            echo "Processing change for $path (Action: $action)"

            if [ "$action" == "replace_content" ]; then
              content=$(echo "$change_json" | jq -r '.content')
              echo -e "$content" > "$path"
              echo "✓ Content replaced for $path"
            elif [ "$action" == "create" ]; then
              content=$(echo "$change_json" | jq -r '.content')
              echo -e "$content" > "$path"
              echo "✓ File created: $path"
            elif [ "$action" == "update_readme_block" ]; then
              # More robust way to handle multiline content for sed
              # The new_block_content is already escaped (\\n) from jq -Rsa
              # marker_start=$(echo "$change_json" | jq -r '.marker_start') # Not needed if fixed
              # marker_end=$(echo "$change_json" | jq -r '.marker_end') # Not needed if fixed
              new_block_content_escaped_for_sed=$(echo "$change_json" | jq -r '.new_block_content')
              
              # Use awk for safer multiline replacement between markers
              awk -v start="<!-- AI-EVOLUTION-MARKER:START -->" \
                  -v end="<!-- AI-EVOLUTION-MARKER:END -->" \
                  -v new_content="$new_block_content_escaped_for_sed" '
              BEGIN { p = 1 }
              $0 == start { print; print new_content; p = 0; next }
              $0 == end { p = 1 }
              p { print }
              ' "$path" > "${path}.tmp" && mv "${path}.tmp" "$path"
              echo "✓ README.md block updated for $path"
            else
              echo "Unknown action: $action for $path"
            fi
          done
          
          # Commit growth (evolution-metrics.json is updated via replace_content)
          git add -A
          COMMIT_MSG=$(jq -r .commit_message "$RESPONSE_FILE")
          git commit -m "$COMMIT_MSG" || echo "No changes to commit, or commit failed."
          git push origin "$BRANCH_NAME"
          
      - name: 🌰 Plant New Seeds (Generate .seed.md for next evolution)
        if: ${{ inputs.auto_plant_seeds == true }}
        run: |
          echo "🌰 Generating next generation .seed.md..."
          RESPONSE_FILE="/tmp/evolution_response.json"
          NEXT_SEED_CONTENT=$(jq -r .next_seed_content "$RESPONSE_FILE")
          
          echo -e "$NEXT_SEED_CONTENT" > .seed.md
          echo "✓ New .seed.md generated for the next evolutionary cycle."
          
          git add .seed.md
          git commit -m "🌰 Planted new seed for next evolution (post cycle $(jq -r '.changes[] | select(.path=="evolution-metrics.json") | .content' "$RESPONSE_FILE" | jq -r .growth_cycles))" || echo "No changes to .seed.md or commit failed."
          git push origin "$BRANCH_NAME" || true # Allow if branch already up-to-date
          
      - name: 🌳 Create Growth Pull Request
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          RESPONSE_FILE="/tmp/evolution_response.json"
          BRANCH_NAME=$(jq -r .new_branch "$RESPONSE_FILE")
          COMMIT_MSG=$(jq -r .commit_message "$RESPONSE_FILE")
          NEXT_SEED_PREVIEW=$(jq -r .next_seed_content "$RESPONSE_FILE" | head -n 20) # Preview of next seed
          
          PR_BODY=$(cat <<EOF_PR_BODY
## 🌱 AI-Driven Growth Cycle Completed

**Growth Mode:** ${{ inputs.growth_mode }}
**Original Prompt:** "${{ inputs.prompt }}"

### 🌿 Summary of Changes in this Cycle:
This cycle focused on evolving the codebase based on the prompt. Key changes include:
- Updates to \`evolution-metrics.json\`.
- Modifications to \`README.md\` dynamic block.
- Other changes as per the AI's plan (see commit details).

### 🌰 Next Generation Seed (.seed.md) Highlights:
The following \`.seed.md\` has been generated to guide the next evolution:
\`\`\`markdown
${NEXT_SEED_PREVIEW}
... (see .seed.md in branch for full content)
\`\`\`

---
*Generated by AI Evolution Engine v0.3.6 Workflow 🌱*
*Commit: ${COMMIT_MSG}*
EOF_PR_BODY
)
          
          gh pr create \
            --title "$COMMIT_MSG" \
            --body "$PR_BODY" \
            --base main \
            --head "$BRANCH_NAME"
EOF
    echo -e "${GREEN}✓ .github/workflows/ai_evolver.yml created${NC}"
}

# Create initial prompt example
create_first_growth_prompt() {
    echo -e "${CYAN}Creating prompts/first_growth.md...${NC}"
    cat > prompts/first_growth.md << 'EOF'
# 🌱 First Growth Prompt (v0.3.6 Seed)

Your mission, should you choose to accept it, is to guide the evolution of this nascent AI-driven repository.

**Initial Goal:** Evolve this project to include a simple "Idea Incubator" feature.

**Specifics:**
1.  **Core Logic (`src/idea_incubator.py` or similar):**
    *   A Python class or set of functions to manage a list of ideas.
    *   Each idea should have a description (string) and a status (e.g., "pending", "active", "completed", "archived").
    *   Ability to add a new idea.
    *   Ability to list all ideas.
    *   Ability to update an idea's status.
2.  **Basic CLI Interaction (Optional, if easy for AI):**
    *   A simple way to interact with the Idea Incubator from the command line (e.g., `python main.py add "My new idea"`).
3.  **Tests (`tests/test_idea_incubator.py`):**
    *   Basic unit tests for adding, listing, and updating ideas.
4.  **Documentation:**
    *   Update `README.md` with a new section describing the "Idea Incubator" feature. The AI should try to use a new marker block for this if it's advanced enough, or just add a section.
    *   Brief comments in the code.

**Growth Principles to Emphasize:**
- **Modularity**: Keep the idea incubator logic separate.
- **Testability**: Ensure new code is testable.
- **Clarity**: Code should be clear and well-commented where necessary.

Remember, the AI is currently simulated in `ai_evolver.yml`. Its actions will be based on the simulation logic in that workflow. The changes it makes (like creating files and updating README/metrics) are defined there.
This prompt will guide the *simulated* AI's output.
EOF
    echo -e "${GREEN}✓ prompts/first_growth.md created${NC}"
}


# Main execution
main() {
    show_seed_banner
    
    create_directories
    check_requirements
    initialize_git
    
    create_gitignore
    create_gptignore
    create_readme # Creates v0.3.6 README
    create_evolution_config
    create_evolution_metrics # Creates v0.3.6 metrics
    create_initial_seed_md # Creates v0.3.6 .seed.md
    create_ai_evolver_workflow # Creates v0.3.6 workflow
    create_first_growth_prompt

    # Initial commit
    echo -e "${CYAN}Performing initial Git commit...${NC}"
    git add -A
    git commit -m "🌱 Planted AI Evolution Engine Seed v${SEED_VERSION}" || echo -e "${YELLOW}No changes to commit or initial commit already exists.${NC}"
    
    echo -e "${GREEN}"
    echo "════════════════════════════════════════════════"
    echo "    🌱 SEED V0.2.0 SUCCESSFULLY PLANTED! 🌱"
    echo "════════════════════════════════════════════════"
    echo -e "${NC}"
    echo "This v0.3.6 seed has laid a more comprehensive foundation."
    echo "Key improvements include:"
    echo "- A README.md with AI-updatable markers."
    echo "- An enhanced 'ai_evolver.yml' workflow with better simulation."
    echo "- An initial '.seed.md' that describes this v0.3.6 seed."
    echo "- '.gitignore' and '.gptignore' for better project and AI context management."
    echo
    echo "Next steps to grow your code:"
    echo "1. If you haven't, commit these initial files:"
    echo "   git add -A"
    echo "   git commit -m \"🌱 Planted AI Evolution Engine Seed v${SEED_VERSION}\""
    echo "   (This script attempts an initial commit, but verify)"
    echo "2. Push to your GitHub repository (e.g., on 'main' branch)."
    echo "3. (Optional) Set your AI provider key if you plan to integrate a real AI later:"
    echo "   export AI_API_KEY='your-key'"
    echo "4. Trigger the evolution workflow via GitHub Actions UI or GitHub CLI:"
    echo "   gh workflow run ai_evolver.yml -f prompt=\"Your evolutionary goal, e.g., Implement a simple task manager\""
    echo
    echo -e "${GREEN}Happy growing! 🌱${NC}"
}

# Run the seed planter
main "$@"