# 🗃️ AI Evolution Engine - Scripts

This directory contains the core scripts for the AI Evolution Engine.

## 📁 Current Scripts

### 🌱 `evolve.sh`
- **Purpose:** Main entry point for all evolution operations (context collection, simulation, application, validation)
- **Usage:**
  ```bash
  ./scripts/evolve.sh help
  ./scripts/evolve.sh context
  ./scripts/evolve.sh simulate -p "Prompt" -m mode
  ./scripts/evolve.sh apply response.json
  ./scripts/evolve.sh validate
  ```

### ⚙️ `setup.sh`
- **Purpose:** Environment setup and preparation for evolution/testing
- **Usage:**
  ```bash
  ./scripts/setup.sh help
  ./scripts/setup.sh --no-deps --no-prereqs
  ```

### 🧪 `test.sh`
- **Purpose:** Unified test runner for the evolution engine
- **Usage:**
  ```bash
  ./scripts/test.sh help
  ./scripts/test.sh all
  ./scripts/test.sh scripts
  ./scripts/test.sh workflows
  ./scripts/test.sh integration
  ./scripts/test.sh validation
  ```

## 🗄️ Archived Scripts
All other scripts from the previous architecture have been moved to `scripts/archive/` for reference. These include:
- Context collection, workflow helpers, version management, notification, legacy modular scripts, and more.

**Note:**
- The new system is designed to work with only the three main scripts above.
- If you need to reference or restore old functionality, see `scripts/archive/`.

---

**This minimal script set improves maintainability, clarity, and ease of use for all evolution and testing operations.**