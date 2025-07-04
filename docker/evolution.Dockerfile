# AI Evolution Engine Container
# Provides a complete environment for running evolution cycles
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    tree \
    bash \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN type -p curl >/dev/null || apt-get install curl -y \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y

# Create non-root user for better security
RUN useradd -m -s /bin/bash evolution && \
    usermod -aG sudo evolution

# Set working directory
WORKDIR /workspace

# Configure git safe directory (for container execution)
RUN git config --global --add safe.directory /workspace

# Set default user
USER evolution

# Default command
CMD ["/bin/bash"]

# Labels for image metadata
LABEL org.opencontainers.image.title="AI Evolution Engine"
LABEL org.opencontainers.image.description="Container environment for AI-driven repository evolution"
LABEL org.opencontainers.image.version="0.3.0"
LABEL org.opencontainers.image.vendor="AI Evolution Engine"
