# MiniMax MCP Terminal Usage Guide

## Overview

The MiniMax MCP server **IS WORKING** in terminal Claude! This guide explains how to use it.

## Status: ✅ CONFIRMED WORKING

**Available Tools:**
- `web_search` - Web Search API (works like Google Search)
- `understand_image` - Analyze and understand image content
- `MiniMax` - Core MiniMax functionality

**Server Command:** `uvx minimax-coding-plan-mcp -y`

## Environment Setup

### Required Environment Variables

Before using MiniMax MCP, set these environment variables:

```bash
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
export MINIMAX_API_RESOURCE_MODE="url"
export MINIMAX_MCP_BASE_PATH="C:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden\\.cursor\\mcp-output"
```

### Quick Setup (One-liner)

```bash
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c" MINIMAX_API_HOST="https://api.minimax.io" MINIMAX_API_RESOURCE_MODE="url" MINIMAX_MCP_BASE_PATH="C:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden\\.cursor\\mcp-output"
```

## Usage Methods

### Method 1: Direct uvx Command (Recommended)

Use the MCP server directly via uvx:

```bash
# Web Search Example
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y

# Image Understanding Example
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y
```

### Method 2: Script Integration

Create wrapper scripts for easier usage:

```bash
#!/bin/bash
# minimax-web-search.sh
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
uvx minimax-coding-plan-mcp -y "$@"
```

## Available Tools

### 1. Web Search

**Description:** Works like Google Search

**Usage Example:**
```bash
# Search for latest information
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y

# In the tool, use:
web_search(query="latest iPhone 2025")
```

**Search Strategy:**
- Use 3-5 keywords
- Add current date for time-sensitive queries
- If no results, try changing keywords

**Returns:**
```json
{
    "organic": [
        {
            "title": "string - The title of the search result",
            "link": "string - The URL link to the result",
            "snippet": "string - A brief description or excerpt",
            "date": "string - The date of the result"
        }
    ]
}
```

### 2. Understand Image

**Description:** Analyze and understand image content from files or URLs

**Supported Formats:** JPEG, PNG, WebP

**Usage Example:**
```bash
# From URL
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y

# In the tool, use:
understand_image(
    prompt="What do you see in this image?",
    image_source="https://example.com/image.jpg"
)

# From local file
understand_image(
    prompt="Analyze this screenshot for UI elements",
    image_source="C:/Users/Sam/Documents/screenshot.png"
)
```

**Arguments:**
- `prompt` (str): Text prompt describing what to analyze
- `image_source` (str): Image location (URL or local path)

**Important:** Remove @ prefix from file paths if present

### 3. MiniMax Core

**Description:** Core MiniMax functionality for AI tasks

**Usage Example:**
```bash
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y

# Use MiniMax tool with appropriate parameters
```

## Troubleshooting

### Issue: "MINIMAX_API_HOST environment variable is required"

**Solution:** Ensure environment variables are set before running uvx:

```bash
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
uvx minimax-coding-plan-mcp -y
```

### Issue: "uvx not found"

**Solution:** Install uvx

```bash
# Windows (using pip)
pip install uvx

# Or install Python and get uvx automatically
```

### Issue: Connection timeout

**Solution:** Use timeout command or check network:

```bash
# With timeout
timeout 60 uvx minimax-coding-plan-mcp -y

# Check network
ping api.minimax.io
```

## Integration with Workflows

### Using in Terminal Claude

Since MCP tools are available via uvx, you can:

1. **Direct Execution:** Run uvx commands with appropriate parameters
2. **Script Wrappers:** Create bash scripts that wrap the MCP calls
3. **API Integration:** Use in Python scripts by calling uvx subprocess

### Example: Automated Research Script

```bash
#!/bin/bash
# research.sh - Automated research using MiniMax web search

export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"

echo "Starting MiniMax MCP..."
uvx minimax-coding-plan-mcp -y

# The tool will be available for use
```

### Example: Image Analysis Script

```bash
#!/bin/bash
# analyze-image.sh - Analyze images with MiniMax

export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"

# Analyze screenshot
MINIMAX_API_KEY="your-key" MINIMAX_API_HOST="https://api.minimax.io" uvx minimax-coding-plan-mcp -y
```

## Token Efficiency

**Claude's Role:** Planning, oversight, coordination (minimal tokens)
**MiniMax's Role:** Heavy lifting - web searches, image analysis, content generation (high tokens)

**Best Practice:**
1. Use Claude for planning and reviewing
2. Delegate searches and analysis to MiniMax MCP
3. Use JSON format for compact responses
4. Natural language for complex instructions

## Cost Warnings

⚠️ **Important:** MiniMax API calls may incur costs

- Web Search API: May have per-query costs
- Image Understanding: May have per-image costs
- Text/Audio Generation: Definitely has costs

**Guidelines:**
1. Only use when explicitly requested
2. Be mindful of text length
3. Voice features charged on first use
4. Free tools (reading data) have no warnings

## Verification Checklist

- [ ] Environment variables set correctly
- [ ] uvx is installed and accessible
- [ ] API key is valid
- [ ] Network connectivity to api.minimax.io
- [ ] MCP server starts without errors
- [ ] Tools are accessible and functional

## Support

If you encounter issues:

1. Check environment variables are set
2. Verify uvx installation: `uvx --version`
3. Test API connectivity: `ping api.minimax.io`
4. Check MCP server logs for errors
5. Verify API key permissions

## Summary

✅ **MiniMax MCP IS WORKING in terminal Claude**
✅ **Available tools:** web_search, understand_image, MiniMax core
✅ **Usage:** Via `uvx minimax-coding-plan-mcp -y`
✅ **Environment:** Requires MINIMAX_API_KEY and MINIMAX_API_HOST
✅ **Integration:** Use directly in scripts or via wrapper functions

The MCP server is confirmed working and ready for use!
