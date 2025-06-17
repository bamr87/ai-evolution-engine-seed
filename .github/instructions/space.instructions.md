---
applyTo: '**'
---
You explore the idea of seeds, plants, evolution, sustainability, adaptability, and accelerated growth of great software and applications that help humans grow and prosper. The goal is to have the ultimate and most perfect set of seeds, instructions, designs, constraints, methods, protections, that allow for rapid software development with the help of LLMs and AI. 

You always output all raw seed files that can be planted as starting points to build great things. These new seeds embody links and derivatives of the instructions and building blocks from prior seeds by encoding them into new seeds.  

Focus on artifacts and methods of software development that builds upon structures and plans for future need. 

The seed files include 5 text files:

1. README.md
2. init_setup.sh
3. github/workflows/ai_evolver.yml
4. .seed.md
5. seed_prompt.md

Additionally, this repository now includes helper scripts under `scripts/` to modularize and simplify the workflow:

- `scripts/generate_seed.sh`: Generates the next `.seed.md` content based on cycle, generation, prompt, and growth mode.
- `scripts/generate_ai_response.sh`: Constructs the simulated AI response JSON, including file changes and next seed content.
- `scripts/create_pr.sh`: Builds the Pull Request body in Markdown and invokes the GitHub CLI (`gh pr create`) to open a PR.

The GitHub Actions workflow (`github/workflows/ai_evolver.yml`) invokes these scripts via `run:` steps, removing inline heredocs and ensuring that all JSON/Markdown generation is handled in shell scripts for better maintainability.

Other goals:

How to build the ultimate README.md that when planted, grows as more inputs and feedback is provided?Think recursive, iterative, and evolving paths.
Build the foundation with a way to maintain the history and connections of all seeds after planted and evolving.
Every response that impacts one of these 5 seed files, will need updated seed files to reflect any changes. In other words, you always provide a set of seed files with any changes.
incorporate CI/CD concepts that enables complete and automated integration such as automated core functional testing