########################################################
### Deprecation notice

I built this MCP server back in early March of 2025 when the MCP protocol was brand new and there were no consistent ways to do search in chatbots, predating other implementations. 

Since then, the good folks at Tavily have released their official [Tavily MCP server](/faq/faq#how-does-tavily-ensure-the-accuracy-of-its-information) which is well-maintained and in sync with their latest capabilities. Therefore, I'm now deprecating this server in favor of theirs.

########################################################


# Tavily MCP Server

A Model Context Protocol server that provides AI-powered web search capabilities using Tavily's search API. This server enables LLMs to perform sophisticated web searches, get direct answers to questions, and search recent news articles with AI-extracted relevant content.

## Features

### Available Tools

- `tavily_web_search` - Performs comprehensive web searches with AI-powered content extraction.

  - `query` (string, required): Search query
  - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
  - `search_depth` (string, optional): Either "basic" or "advanced" search depth (default: "basic")
  - `include_domains` (list or string, optional): List of domains to specifically include in results
  - `exclude_domains` (list or string, optional): List of domains to exclude from results

- `tavily_answer_search` - Performs web searches and generates direct answers with supporting evidence.

  - `query` (string, required): Search query
  - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
  - `search_depth` (string, optional): Either "basic" or "advanced" search depth (default: "advanced")
  - `include_domains` (list or string, optional): List of domains to specifically include in results
  - `exclude_domains` (list or string, optional): List of domains to exclude from results

- `tavily_news_search` - Searches recent news articles with publication dates.
  - `query` (string, required): Search query
  - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
  - `days` (integer, optional): Number of days back to search (default: 3)
  - `include_domains` (list or string, optional): List of domains to specifically include in results
  - `exclude_domains` (list or string, optional): List of domains to exclude from results

### Prompts

The server also provides prompt templates for each search type:

- **tavily_web_search** - Search the web using Tavily's AI-powered search engine
- **tavily_answer_search** - Search the web and get an AI-generated answer with supporting evidence
- **tavily_news_search** - Search recent news articles with Tavily's news search

## Prerequisites

- Python 3.11 or later
- A Tavily API key (obtain from [Tavily's website](https://tavily.com))
- `uv` Python package manager (recommended)

## Installation

### Option 1: Using pip or uv

```bash
# With pip
pip install mcp-tavily

# Or with uv (recommended)
uv add mcp-tavily
```

You should see output similar to:

```
Resolved packages: mcp-tavily, mcp, pydantic, python-dotenv, tavily-python [...]
Successfully installed mcp-tavily-0.1.4 mcp-1.0.0 [...]
```

### Option 2: From source

```bash
# Clone the repository
git clone https://github.com/RamXX/mcp-tavily.git
cd mcp-tavily

# Create a virtual environment (optional but recommended)
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies and build
uv sync  # Or: pip install -r requirements.txt
uv build  # Or: pip install -e .

# To install with test dependencies:
uv sync --dev  # Or: pip install -r requirements-dev.txt
```

During installation, you should see the package being built and installed with its dependencies.

### Usage with VS Code

For quick installation, use one of the one-click install buttons below:

[![Install with UV in VS Code](https://img.shields.io/badge/VS_Code-UV-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=tavily&inputs=%5B%7B%22type%22%3A%22promptString%22%2C%22id%22%3A%22apiKey%22%2C%22description%22%3A%22Tavily%20API%20Key%22%2C%22password%22%3Atrue%7D%5D&config=%7B%22command%22%3A%22uvx%22%2C%22args%22%3A%5B%22mcp-tavily%22%5D%2C%22env%22%3A%7B%22TAVILY_API_KEY%22%3A%22%24%7Binput%3AapiKey%7D%22%7D%7D) [![Install with UV in VS Code Insiders](https://img.shields.io/badge/VS_Code_Insiders-UV-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=tavily&inputs=%5B%7B%22type%22%3A%22promptString%22%2C%22id%22%3A%22apiKey%22%2C%22description%22%3A%22Tavily%20API%20Key%22%2C%22password%22%3Atrue%7D%5D&config=%7B%22command%22%3A%22uvx%22%2C%22args%22%3A%5B%22mcp-tavily%22%5D%2C%22env%22%3A%7B%22TAVILY_API_KEY%22%3A%22%24%7Binput%3AapiKey%7D%22%7D%7D&quality=insiders)

For manual installation, add the following JSON block to your User Settings (JSON) file in VS Code. You can do this by pressing `Ctrl + Shift + P` and typing `Preferences: Open User Settings (JSON)`.

Optionally, you can add it to a file called `.vscode/mcp.json` in your workspace. This will allow you to share the configuration with others.

> Note that the `mcp` key is not needed in the `.vscode/mcp.json` file.

```json
{
  "mcp": {
    "inputs": [
      {
        "type": "promptString",
        "id": "apiKey",
        "description": "Tavily API Key",
        "password": true
      }
    ],
    "servers": {
      "tavily": {
        "command": "uvx",
        "args": ["mcp-tavily"],
        "env": {
          "TAVILY_API_KEY": "${input:apiKey}"
        }
      }
    }
  }
}
```

## Configuration

### API Key Setup

The server requires a Tavily API key, which can be provided in three ways:

1. Through a `.env` file in your project directory:

   ```
   TAVILY_API_KEY=your_api_key_here
   ```

2. As an environment variable:

   ```bash
   export TAVILY_API_KEY=your_api_key_here
   ```

3. As a command-line argument:
   ```bash
   python -m mcp_server_tavily --api-key=your_api_key_here
   ```

### Configure for Claude.app

Add to your Claude settings:

```json
"mcpServers": {
  "tavily": {
    "command": "python",
    "args": ["-m", "mcp_server_tavily"]
  },
  "env": {
    "TAVILY_API_KEY": "your_api_key_here"
  }
}
```

If you encounter issues, you may need to specify the full path to your Python interpreter. Run `which python` to find the exact path.

## Usage Examples

For a regular web search:

```
Tell me about Anthropic's newly released MCP protocol
```

To generate a report with domain filtering:

```
Tell me about redwood trees. Please use MLA format in markdown syntax and include the URLs in the citations. Exclude Wikipedia sources.
```

To use answer search mode for direct answers:

```
I want a concrete answer backed by current web sources: What is the average lifespan of redwood trees?
```

For news search:

```
Give me the top 10 AI-related news in the last 5 days
```

## Testing

The project includes a comprehensive test suite with automated dependency compatibility testing.

### Running Tests

1. Install test dependencies:

   ```bash
   source .venv/bin/activate  # If using a virtual environment
   uv sync --dev  # Or: pip install -r requirements-dev.txt
   ```

2. Run the standard test suite:
   ```bash
   ./tests/run_tests.sh
   # Or using Make
   make test
   ```

### Dependency Compatibility Testing

To ensure the project works with the latest dependency versions, use these commands:

```bash
# Test with latest dependencies using Make
make test-deps

# Full compatibility test with verbose output
make test-compatibility

# Or use the standalone script
./scripts/test-compatibility.sh
```

These commands will:
- Update all dependencies to their latest versions
- Run the full test suite with coverage
- Report any compatibility issues
- Show version changes for transparency

### Automated Testing

The project includes automated dependency compatibility testing through GitHub Actions:

- **Weekly Testing**: Runs every Monday at 8 AM UTC
- **Multi-Python Support**: Tests against Python 3.11, 3.12, and 3.13
- **Issue Creation**: Automatically creates GitHub issues when tests fail
- **Manual Trigger**: Can be triggered manually from the GitHub Actions tab

### Understanding Test Results

**When tests pass**: Your project is compatible with the latest dependency versions. You can safely update your requirements files.

**When tests fail**: Review the test output to identify breaking changes, update your code to handle API changes, update tests if needed, or consider pinning problematic dependency versions.

### Test Output Example

You should see output similar to:

```
======================================================= test session starts ========================================================
platform darwin -- Python 3.13.3, pytest-8.3.5, pluggy-1.5.0
rootdir: /Users/ramirosalas/workspace/mcp-tavily
configfile: pyproject.toml
plugins: cov-6.0.0, asyncio-0.25.3, anyio-4.8.0, mock-3.14.0
asyncio: mode=Mode.STRICT, asyncio_default_fixture_loop_scope=function
collected 50 items                                                                                                                 

tests/test_docker.py ..                                                                                                      [  4%]
tests/test_integration.py .....                                                                                              [ 14%]
tests/test_models.py .................                                                                                       [ 48%]
tests/test_server_api.py .....................                                                                               [ 90%]
tests/test_utils.py .....                                                                                                    [100%]

---------- coverage: platform darwin, python 3.13.3-final-0 ----------
Name                                Stmts   Miss  Cover
-------------------------------------------------------
src/mcp_server_tavily/__init__.py      16      2    88%
src/mcp_server_tavily/__main__.py       2      2     0%
src/mcp_server_tavily/server.py       149     16    89%
-------------------------------------------------------
TOTAL                                 167     20    88%
```

The test suite includes tests for data models, utility functions, integration testing, error handling, and parameter validation. It focuses on verifying that all API capabilities work correctly, including handling of domain filters and various input formats.

## Release Management

The project includes tools for building and releasing with the latest dependency versions:

### Building with Latest Dependencies

```bash
# Build package with latest dependency versions
make build-latest

# Complete release workflow: test, build, and check with latest deps
make release-all

# Prepare a release with version management
./scripts/prepare-release.sh [new_version]
```

### Release Workflow

**Recommended approach for releases with latest dependencies:**

1. **Complete release preparation**: `make release-all`
2. **Upload without downgrades**: `make upload-latest`

**Alternative step-by-step approach:**

1. **Test with latest dependencies**: `make test-compatibility`
2. **Build for release**: `make release-build`
3. **Upload without rebuilding**: `make upload-latest`

**One-command release and publish:**
```bash
make release-publish
```

**Important**: Use `make upload-latest` instead of `make upload` to prevent dependency downgrades during the upload process. The `upload-latest` command uses existing distribution files without reinstalling dependencies.

The release commands ensure your package is built and tested with the most recent compatible dependency versions, preventing the downgrades that can occur with traditional build chains.

## Docker

Build the Docker image:

```bash
make docker-build
```

Alternatively, build directly with Docker:

```bash
docker build -t mcp_tavily .
```

Run a detached Docker container (default name `mcp_tavily_container`, port 8000 → 8000):

```bash
make docker-run
```

Or manually:

```bash
docker run -d --name mcp_tavily_container \
  -e TAVILY_API_KEY=your_api_key_here \
  -p 8000:8000 mcp_tavily
```

Stop and remove the container:

```bash
make docker-stop
```

Follow container logs:

```bash
make docker-logs
```

You can override defaults by setting environment variables:
  - DOCKER_IMAGE: image name (default `mcp_tavily`)
  - DOCKER_CONTAINER: container name (default `mcp_tavily_container`)
  - HOST_PORT: host port to bind (default `8000`)
  - CONTAINER_PORT: container port (default `8000`)

## Debugging

You can use the MCP inspector to debug the server:

```bash
# Using npx
npx @modelcontextprotocol/inspector python -m mcp_server_tavily

# For development
cd path/to/mcp-tavily
npx @modelcontextprotocol/inspector python -m mcp_server_tavily
```

## Contributing

We welcome contributions to improve mcp-tavily! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests to ensure they pass
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

For examples of other MCP servers and implementation patterns, see:
https://github.com/modelcontextprotocol/servers

## License

mcp-tavily is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
