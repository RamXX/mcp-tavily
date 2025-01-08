# Use Python 3.10 slim bullseye (more stable than bookworm)
FROM python:3.10-slim-bullseye

# Set working directory
WORKDIR /app

# Install system dependencies
RUN set -ex; \
    # Save architecture details
    dpkgArch="$(dpkg --print-architecture)"; \
    # Update apt and install dependencies
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        dirmngr \
        apt-transport-https \
        ca-certificates \
        build-essential && \
    # Update GPG keys
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 0E98404D386FA1D9 ; \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Update certificates
    update-ca-certificates

# Copy project files
COPY pyproject.toml uv.lock ./
COPY src/ ./src/

# Install project dependencies
RUN pip install --no-cache-dir .

# Set the entrypoint
ENTRYPOINT ["mcp-tavily"]

# Set default command (can be overridden)
CMD []
