.PHONY: all help setup setup-latest clean build build-latest check check-latest upload upload-latest test run-local docker-build docker-run docker-stop docker-logs test-deps test-compatibility release-build release-all release-publish update-requirements

# Default Python command
PYTHON ?= python
# Package management tool (uv preferred if available)
HAS_UV := $(shell command -v uv 2> /dev/null)
ifdef HAS_UV
    PKG_MANAGER = uv
    PIP_INSTALL = uv pip install
    SYNC = uv sync
else
    PKG_MANAGER = pip
    PIP_INSTALL = pip install
    SYNC = pip install -r
endif

# Docker settings
DOCKER_IMAGE ?= mcp_tavily
DOCKER_CONTAINER ?= mcp_tavily_container
HOST_PORT ?= 8000
CONTAINER_PORT ?= 8000

# Default target
all: clean setup build check

# Set up the development environment
setup:
	@echo "Setting up development environment..."
	@if [ ! -d ".venv" ]; then \
		$(PYTHON) -m venv .venv; \
		. .venv/bin/activate; \
	fi
	@. .venv/bin/activate && $(PIP_INSTALL) --upgrade pip
	@. .venv/bin/activate && $(PIP_INSTALL) setuptools==67.8.0 wheel build twine
ifdef HAS_UV
	@. .venv/bin/activate && $(SYNC) --dev
else
	@. .venv/bin/activate && $(SYNC) requirements-dev.txt
	@. .venv/bin/activate && $(SYNC) requirements.txt
endif
	@. .venv/bin/activate && $(PIP_INSTALL) -e .
	@echo "Setup complete!"

# Set up development environment with latest dependencies
setup-latest:
	@echo "Setting up development environment with latest dependencies..."
	@if [ ! -d ".venv" ]; then \
		$(PYTHON) -m venv .venv; \
		. .venv/bin/activate; \
	fi
	@. .venv/bin/activate && $(PIP_INSTALL) --upgrade pip
	@. .venv/bin/activate && $(PIP_INSTALL) setuptools==67.8.0 wheel build twine
	@. .venv/bin/activate && $(PIP_INSTALL) -r requirements-dev.txt -U
	@. .venv/bin/activate && $(PIP_INSTALL) -e .
	@echo "Setup with latest dependencies complete!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf dist/ build/ src/*.egg-info/
	@find . -type d -name __pycache__ -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
	@echo "Clean complete!"

# Build the package (ensure virtualenv is set up)
build: setup clean
	@echo "Building package..."
	@. .venv/bin/activate && $(PIP_INSTALL) build
	@. .venv/bin/activate && $(PYTHON) -m build
	@echo "Build complete!"

# Build with latest dependencies
build-latest: setup-latest clean
	@echo "Building package with latest dependencies..."
	@. .venv/bin/activate && $(PIP_INSTALL) build
	@. .venv/bin/activate && $(PYTHON) -m build
	@echo "Build with latest dependencies complete!"

# Check the distribution with twine
check: build
	@echo "Checking distribution with twine..."
	@. .venv/bin/activate && $(PIP_INSTALL) twine
	@. .venv/bin/activate && twine check dist/*
	@echo "Check complete!"

# Check the distribution with twine (with latest dependencies)
check-latest: build-latest
	@echo "Checking distribution with twine (latest deps)..."
	@. .venv/bin/activate && $(PIP_INSTALL) twine
	@. .venv/bin/activate && twine check dist/*
	@echo "Check complete!"

# Upload to PyPI
upload: check
	@echo "Uploading to PyPI..."
	@. .venv/bin/activate && twine upload dist/*
	@echo "Upload complete!"

# Upload to PyPI (assumes package already built and checked)
upload-latest:
	@echo "Uploading to PyPI (using existing dist files)..."
	@if [ ! -d "dist" ] || [ -z "$$(ls -A dist/ 2>/dev/null)" ]; then \
		echo "Error: No distribution files found in dist/. Run 'make release-all' first."; \
		exit 1; \
	fi
	@. .venv/bin/activate && $(PIP_INSTALL) twine
	@. .venv/bin/activate && twine upload dist/*
	@echo "Upload complete!"

# Run tests (ensure virtualenv is set up)
test: setup
	@echo "Running tests..."
	@./tests/run_tests.sh
	@echo "Tests complete!"

# Test with updated dependencies
test-deps: setup
	@echo "Testing with latest dependencies..."
	@. .venv/bin/activate && uv pip install -r requirements-dev.txt -U
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term
	@echo "Dependency compatibility test complete!"

# Full compatibility test - update deps and run all tests
test-compatibility: setup
	@echo "Running full compatibility test with latest dependencies..."
	@. .venv/bin/activate && uv pip install -r requirements-dev.txt -U
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term --verbose
	@echo "Full compatibility test complete!"

# Build for release with latest dependencies and full testing
release-build: clean setup-latest
	@echo "Preparing release build with latest dependencies..."
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term
	@echo "All tests passed! Building package..."
	@. .venv/bin/activate && $(PIP_INSTALL) build
	@. .venv/bin/activate && $(PYTHON) -m build
	@echo "Release build complete!"

# Complete release workflow: test, build, and check with latest dependencies
release-all: clean setup-latest
	@echo "Running complete release workflow with latest dependencies..."
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term
	@echo "All tests passed! Building package..."
	@. .venv/bin/activate && $(PIP_INSTALL) build twine
	@. .venv/bin/activate && $(PYTHON) -m build
	@echo "Checking distribution with twine..."
	@. .venv/bin/activate && twine check dist/*
	@echo "Release workflow complete! Ready to upload with 'make upload-latest'"

# Complete release workflow including upload
release-publish: clean setup-latest
	@echo "Running complete release and publish workflow..."
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term
	@echo "All tests passed! Building package..."
	@. .venv/bin/activate && $(PIP_INSTALL) build twine
	@. .venv/bin/activate && $(PYTHON) -m build
	@echo "Checking distribution with twine..."
	@. .venv/bin/activate && twine check dist/*
	@echo "Uploading to PyPI..."
	@. .venv/bin/activate && twine upload dist/*
	@echo "Release published successfully!"

# Update requirements files with latest compatible versions
update-requirements: setup-latest
	@echo "Updating requirements files with latest compatible versions..."
	@. .venv/bin/activate && python -W ignore -m pytest tests --cov=src/mcp_server_tavily --cov-report=term
	@echo "Tests passed with latest versions! Updating requirements files..."
	@. .venv/bin/activate && pip freeze | grep -E "(mcp|pydantic|python-dotenv|tavily)" > requirements-new.txt
	@. .venv/bin/activate && pip freeze | grep -E "(pytest|build|twine|wheel|setuptools)" > requirements-dev-new.txt
	@echo "New requirements saved to requirements-new.txt and requirements-dev-new.txt"
	@echo "Review and replace the original files if satisfied with the versions."

help:
	@echo "Available targets:"
	@echo "  setup   - Set up development environment"
	@echo "  clean   - Clean build artifacts"
	@echo "  build   - Build the package"
	@echo "  check   - Check the distribution with twine"
	@echo "  upload  - Upload to PyPI (requires PyPI credentials)"
	@echo "  test    - Run tests"
	@echo "  test-deps - Test with latest dependency updates"
	@echo "  test-compatibility - Full compatibility test with updated dependencies"
	@echo "  setup-latest - Set up development environment with latest dependencies"
	@echo "  build-latest - Build package with latest dependencies"
	@echo "  release-build - Build for release with latest deps and full testing"
	@echo "  release-all - Complete release workflow (test, build, check) with latest deps"
	@echo "  release-publish - Complete release and publish workflow (includes upload)"
	@echo "  upload-latest - Upload existing dist files without rebuilding/downgrading"
	@echo "  update-requirements - Update requirements files with latest compatible versions"
	@echo "  all     - Run clean, setup, build, and check (default)"
	@echo "  run-local    - Run the MCP Tavily server locally (in .venv)"
	@echo "  docker-build - Build Docker image ($(DOCKER_IMAGE))"
	@echo "  docker-run   - Run Docker container ($(DOCKER_CONTAINER)) (detached, ports $(HOST_PORT):$(CONTAINER_PORT))"
	@echo "  docker-stop  - Stop and remove Docker container"
	@echo "  docker-logs  - Follow Docker container logs"
run-local:
	@echo "Running MCP Tavily server locally..."
	@. .venv/bin/activate && python -m mcp_server_tavily
docker-build:
	@echo "Building Docker image '$(DOCKER_IMAGE)'..."
	@docker build -t $(DOCKER_IMAGE) .
docker-run:
	@echo "Running Docker container '$(DOCKER_CONTAINER)' (detached)..."
	@docker run -d --name $(DOCKER_CONTAINER) -e TAVILY_API_KEY=$$TAVILY_API_KEY -p $(HOST_PORT):$(CONTAINER_PORT) $(DOCKER_IMAGE)
docker-stop:
	@echo "Stopping and removing Docker container '$(DOCKER_CONTAINER)'..."
	@docker stop $(DOCKER_CONTAINER) || true
	@docker rm $(DOCKER_CONTAINER) || true
docker-logs:
	@echo "Following logs for Docker container '$(DOCKER_CONTAINER)'..."
	@docker logs -f $(DOCKER_CONTAINER)