# Tavily MCP Server
[![smithery badge](https://smithery.ai/badge/mcp-tavily)](https://smithery.ai/server/mcp-tavily)

A Model Context Protocol server that provides AI-powered web search capabilities using Tavily's search API. This server enables LLMs to perform sophisticated web searches, get direct answers to questions, and search recent news articles with AI-extracted relevant content.

### Available Tools

- `tavily_web_search` - Performs comprehensive web searches with AI-powered content extraction.
    - `query` (string, required): Search query
    - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
    - `search_depth` (string, optional): Either "basic" or "advanced" search depth (default: "basic")

- `tavily_answer_search` - Performs web searches and generates direct answers with supporting evidence.
    - `query` (string, required): Search query
    - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
    - `search_depth` (string, optional): Either "basic" or "advanced" search depth (default: "advanced")

- `tavily_news_search` - Searches recent news articles with publication dates.
    - `query` (string, required): Search query
    - `max_results` (integer, optional): Maximum number of results to return (default: 5, max: 20)
    - `days` (integer, optional): Number of days back to search (default: 3)

### Prompts

- **tavily_web_search**
  - Search the web using Tavily's AI-powered search engine
  - Arguments:
    - `query` (string, required): Search query

- **tavily_answer_search**
  - Search the web and get an AI-generated answer with supporting evidence
  - Arguments:
    - `query` (string, required): Search query

- **tavily_news_search**
  - Search recent news articles with Tavily's news search
  - Arguments:
    - `query` (string, required): Search query
    - `days` (integer, optional): Number of days back to search

## Installation

### Installing via Smithery

To install Tavily for Claude Desktop automatically via [Smithery](https://smithery.ai/server/mcp-tavily):

```bash
npx -y @smithery/cli install mcp-tavily --client claude
```

### Use `pip`

Simply run:

```bash
pip install mcp-tavily
```

or if you have `uv` installed:

```bash
uv pip install mcp-tavily
```

### Build the Server
Clone this repository and build and install the program with your default Python interpreter (recommended).

```bash
git clone https://github.com/RamXX/mcp-tavily.git
cd mcp-tavily
uv build
uv pip install .
```

After installation, you can run it as a script using:

```
python -m mcp_server_tavily
```

## Configuration

### API Key

The server requires a Tavily API key to function. You can obtain one from [Tavily's website](https://tavily.com). The API key can be provided in two ways:

1. As an environment variable:
```bash
export TAVILY_API_KEY=your_api_key_here
```

2. As a command-line argument:
```bash
python -m mcp_server_tavily --api-key=your_api_key_here
```

### Configure for Claude.app

Add to your Claude settings:

<details>
<summary>Using pip installation</summary>

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
</details>

If you see any issue, you may want to use the full path for the Python interpreter you are using. You can do a `which python` to find out the exact path if needed.

Remember to set the TAVILY_API_KEY environment variable or provide it via the --api-key argument.

## Examples

For a regular search:

```
Tell me about Anthropic's newly released MCP protocol
```

To generate a report with explicit exclusions:

```
Tell me about redwood trees. Please use MLA format in markdown syntax and include the URLs in the citations. Exclude Wikipedia sources.
```

To force Claude to use the answer mode function call, be explicit in your ask:

```
I want a concrete answer backed by current web sources: What is the average lifespan of redwood trees?
```

For news, use:

```
Give me the top 10 AI-related news in the last 5 days
```

## Debugging

You can use the MCP inspector to debug the server. For uvx installations:

```
npx @modelcontextprotocol/inspector uvx mcp-server-tavily
```

Or if you've installed the package in a specific directory or are developing on it:

```
cd path/to/servers/src/tavily
npx @modelcontextprotocol/inspector python -m mcp_server_tavily
```

## Contributing

We encourage contributions to help expand and improve mcp-server-tavily. Whether you want to add new search capabilities, enhance existing functionality, or improve documentation, your input is valuable.

For examples of other MCP servers and implementation patterns, see:
https://github.com/modelcontextprotocol/servers

Pull requests are welcome! Feel free to contribute new ideas, bug fixes, or enhancements to make mcp-server-tavily even more powerful and useful.

## License

mcp-server-tavily is licensed under the MIT License. This means you are free to use, modify, and distribute the software, subject to the terms and conditions of the MIT License. For more details, please see the LICENSE file in the project repository.
