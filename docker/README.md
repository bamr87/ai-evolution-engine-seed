<!--
@file docker/README.md
@description Docker containerization documentation for AI Evolution Engine
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-04
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #cross-platform-support: Docker containerization for universal compatibility
  - #ci-cd-enhancement: Container-based CI/CD workflows

@relatedEvolutions
  - v1.0.0: Complete Docker integration with cross-platform support
  - v0.3.6: Initial containerization implementation

@dependencies
  - Docker Engine: >=20.10 for container runtime
  - Docker Compose: >=2.0 for orchestration
  - GitHub CLI: for authentication and workflow integration

@changelog
  - 2025-07-12: Added comprehensive file header and enhanced documentation structure - AEE
  - 2025-07-04: Complete Docker integration with authentication and volume mounting - AEE
  - 2025-07-01: Initial containerization implementation - AEE

@usage Complete Docker setup and usage guide for containerized development
@notes Provides cross-platform compatibility and isolated execution environment
-->

# AI Evolution Engine - Docker Environment

This directory contains Docker configuration for running the AI Evolution Engine in a containerized environment, providing cross-platform compatibility and isolated execution.

## Overview

The containerized environment offers several advantages:

- **Cross-platform compatibility** - Works on macOS, Linux, and Windows
- **Isolated execution** - No interference with local system packages
- **Consistent environment** - Same execution environment for all users
- **Easy setup** - No need to install dependencies manually
- **CI/CD ready** - Perfect for automated workflows

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+ (or docker-compose 1.29+)

### Basic Usage

1. **Build the container:**

   ```bash
   docker-compose build evolution-engine
   ```

2. **Run an evolution cycle:**

   ```bash
   docker-compose run evolution-engine ./scripts/local-evolution.sh -p "Improve error handling"
   ```

3. **Interactive shell:**

   ```bash
   docker-compose run evolution-engine /bin/bash
   ```

## Container Configuration

### Dockerfile: evolution.Dockerfile

Based on Ubuntu 22.04 with the following components:

- **System tools**: curl, git, jq, tree, bash
- **GitHub CLI**: Latest version for PR management
- **Non-root user**: evolution user for security
- **Safe directories**: Pre-configured for git operations

### Docker Compose: docker-compose.yml

Services:

- **evolution-engine**: Main container with evolution tools
- **redis**: Optional caching service (with --profile with-cache)

Volume mounts:

- Repository code: ..:/workspace
- Git config: ~/.gitconfig:/home/evolution/.gitconfig:ro
- GitHub CLI config: ~/.config/gh:/home/evolution/.config/gh:ro

## Environment Variables

The container supports the following environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| USE_CONTAINER | Container mode flag | true |
| CI_ENVIRONMENT | CI environment flag | false |
| GH_TOKEN | GitHub token for authentication | - |
| PAT_TOKEN | Personal access token (fallback) | - |
| AI_API_KEY | AI service API key | - |

## Authentication

### GitHub CLI Authentication

#### Option 1: Token-based (Recommended for CI)

```bash
export GH_TOKEN="your_github_token_here"
docker-compose run evolution-engine ./scripts/local-evolution.sh -p "your prompt"
```

#### Option 2: Mount existing auth

The compose file automatically mounts your local GitHub CLI config:

```bash
# First authenticate locally
gh auth login

# Then run container (auth is automatically available)
docker-compose run evolution-engine ./scripts/local-evolution.sh -p "your prompt"
```

#### Option 3: Authenticate inside container

```bash
docker-compose run evolution-engine /bin/bash
# Inside container:
gh auth login
```

## Usage Examples

### Development Workflow

1. **Standard evolution cycle:**

   ```bash
   docker-compose run evolution-engine ./scripts/local-evolution.sh \
     -p "Refactor authentication system" \
     -m adaptive
   ```

2. **Experimental changes with dry-run:**

   ```bash
   docker-compose run evolution-engine ./scripts/local-evolution.sh \
     -p "Add new AI integration" \
     -m experimental \
     -d
   ```

3. **Conservative evolution with verbose output:**

   ```bash
   docker-compose run evolution-engine ./scripts/local-evolution.sh \
     -p "Update documentation" \
     -m conservative \
     -v
   ```

### CI/CD Integration

For GitHub Actions (alternative to direct container usage):

```yaml
- name: Run Evolution in Container
  run: |
    docker-compose run --rm evolution-engine ./scripts/local-evolution.sh \
      -p "${{ inputs.prompt }}" \
      -m "${{ inputs.growth_mode }}"
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### With Caching Service

To use Redis caching for future features:

```bash
docker-compose --profile with-cache up -d
docker-compose run evolution-engine ./scripts/local-evolution.sh -p "your prompt"
```

## Troubleshooting

### Common Issues

**Permission Denied Errors:**

```bash
# Fix script permissions
docker-compose run evolution-engine chmod +x scripts/*.sh
```

**GitHub Authentication Failures:**

```bash
# Check token in environment
docker-compose run evolution-engine env | grep GH_TOKEN

# Test authentication
docker-compose run evolution-engine gh auth status
```

**Git Config Issues:**

```bash
# Set git config inside container
docker-compose run evolution-engine bash -c "
  git config --global user.name 'Your Name'
  git config --global user.email 'your@email.com'
"
```

### Debug Mode

Run with verbose output and interactive shell:

```bash
docker-compose run evolution-engine /bin/bash
# Inside container, run commands step by step:
./scripts/setup-environment.sh
./scripts/check-prereqs.sh adaptive false
# ... etc
```

## Container Maintenance

### Updating the Container

1. **Rebuild with latest packages:**

   ```bash
   docker-compose build --no-cache evolution-engine
   ```

2. **Clean up old containers:**

   ```bash
   docker-compose down
   docker system prune -f
   ```

3. **Update base image:**

   ```bash
   docker pull ubuntu:22.04
   docker-compose build evolution-engine
   ```

### Performance Optimization

For faster rebuilds, the Dockerfile uses:

- Multi-stage builds (when applicable)
- Minimal package installations
- Efficient layer caching

## Integration with Local Development

The container setup complements local development:

1. **Local development**: Use ./scripts/local-evolution.sh directly
2. **Container testing**: Use docker-compose run for isolated testing
3. **CI/CD**: Use GitHub Actions workflow for automated cycles

## Security Considerations

- **Non-root execution**: Container runs as evolution user
- **Read-only mounts**: Config files mounted as read-only
- **Token security**: Tokens passed via environment variables
- **Network isolation**: Uses dedicated Docker network

## Future Enhancements

Planned container features:

- [ ] **Multi-arch support**: ARM64 and AMD64 builds for broader compatibility
- [ ] **Caching layers**: Redis integration for evolution state and performance optimization
- [ ] **Plugin system**: Extensible container with custom tools and integrations
- [ ] **Monitoring**: Health checks and metrics collection for container performance
- [ ] **Auto-scaling**: Dynamic resource allocation based on workload
- [ ] **GPU Support**: CUDA-enabled containers for AI workload acceleration
- [ ] **Development Tools**: Integrated development environment with debugging support
- [ ] **Backup Integration**: Automated backup and restore capabilities

## Integration with Evolution Engine

The Docker environment seamlessly integrates with:
- [Local Development Scripts](../scripts/README.md) - Native and containerized execution
- [GitHub Actions Workflows](../.github/workflows/README.md) - CI/CD container support
- [Testing Framework](../tests/README.md) - Isolated testing environments
- [Core Library System](../src/lib/README.md) - Modular architecture compatibility

## Troubleshooting Guide

### Common Container Issues

**Build Failures:**
- Check Docker daemon is running: `docker info`
- Clear build cache: `docker builder prune`
- Update base images: `docker pull ubuntu:22.04`

**Permission Issues:**
- Check file ownership: `ls -la`
- Fix permissions: `chmod +x scripts/*.sh`
- Verify user mapping: `docker-compose run evolution-engine id`

**Network Problems:**
- Check connectivity: `docker network ls`
- Reset network: `docker network prune`
- Verify DNS: `docker run --rm evolution-engine nslookup github.com`

### Performance Optimization

**Resource Allocation:**
```yaml
# docker-compose.yml
services:
  evolution-engine:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

**Volume Performance:**
```yaml
# Use cached mounts for better performance
volumes:
  - ..:/workspace:cached
```

## Related Documentation

- [Main Repository README](../README.md) - Project overview and setup instructions
- [Cross-Platform Setup Guide](../docs/evolution/CROSS_PLATFORM_UPDATE.md) - Comprehensive platform compatibility
- [Local Development Guide](../docs/guides/local-development.md) - Development workflow documentation
- [CI/CD Integration Guide](../docs/workflows/ci-cd-integration.md) - Container-based automation
