# MiniMax MCP Status - Terminal Claude

## ✅ CONFIRMED: MiniMax MCP IS WORKING

**Date:** 2026-01-19
**Status:** Operational and accessible in terminal Claude

## Quick Reference

### Available Tools

1. **web_search** - Web Search API (Google-like search)
2. **understand_image** - Analyze and understand image content
3. **MiniMax** - Core MiniMax AI functionality

### Server Command

```bash
uvx minimax-coding-plan-mcp -y
```

### Environment Variables Required

```bash
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
export MINIMAX_API_RESOURCE_MODE="url"
export MINIMAX_MCP_BASE_PATH="C:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden\\.cursor\\mcp-output"
```

## Troubleshooting for Claude Terminal

### Issue: "MINIMAX_API_HOST environment variable is required"

**Solution:** Set environment variables BEFORE running uvx:

```bash
# Set all required variables
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"

# Then run the MCP server
uvx minimax-coding-plan-mcp -y
```

### Issue: "uvx not found"

**Solution:** Install uvx

```bash
pip install uvx
```

### Issue: MCP tools not showing up

**Solution:**
1. Check environment variables are set: `echo $MINIMAX_API_KEY`
2. Verify uvx works: `uvx --version`
3. Test server startup: `timeout 10 uvx minimax-coding-plan-mcp -y`

## Usage Patterns

### Pattern 1: Direct Command Execution

```bash
# Set environment
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"

# Run MCP server
uvx minimax-coding-plan-mcp -y

# Tools are now available for use
```

### Pattern 2: Script Wrapper

Create `minimax.sh`:

```bash
#!/bin/bash
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
uvx minimax-coding-plan-mcp -y "$@"
```

### Pattern 3: Integration in Claude Workflows

Since MCP tools are available via uvx, Claude can:

1. **Plan with Claude** (minimal tokens)
2. **Execute with MiniMax** (heavy lifting via uvx)
3. **Review with Claude** (oversight)

Example:

```bash
# Claude plans the task
# Terminal executes:
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
uvx minimax-coding-plan-mcp -y

# Use web_search tool for research
# Use understand_image for visual analysis
# Claude reviews results
```

## Tool Details

### web_search

**Purpose:** Web search (Google-like)
**Usage:**
```bash
# In MCP tool context
web_search(query="latest iPhone 2025")
```

**Search Strategy:**
- Use 3-5 keywords
- Add date for time-sensitive queries
- Try different keywords if no results

**Returns:**
```json
{
    "organic": [
        {
            "title": "string - The title",
            "link": "string - The URL",
            "snippet": "string - Description",
            "date": "string - Date"
        }
    ]
}
```

### understand_image

**Purpose:** Analyze images
**Supported:** JPEG, PNG, WebP
**Usage:**
```bash
# From URL
understand_image(
    prompt="What do you see?",
    image_source="https://example.com/image.jpg"
)

# From local file
understand_image(
    prompt="Analyze this screenshot",
    image_source="C:/Users/Sam/Documents/image.png"
)
```

**Note:** Remove @ prefix from file paths

### MiniMax Core

**Purpose:** Core AI functionality
**Usage:** Available via MCP tool interface
**Details:** Check server output for specific parameters

## Cost Awareness

⚠️ **API calls may incur costs:**

- Web Search: Per-query costs
- Image Understanding: Per-image costs
- Audio/Text Generation: Definitely charged

**Guidelines:**
1. Only use when explicitly requested
2. Be mindful of text length
3. Voice features charged on first use

## Verification Steps

Run this to verify everything works:

```bash
# 1. Check environment
echo $MINIMAX_API_KEY | head -c 20
echo "..."

# 2. Check uvx
uvx --version

# 3. Test server
timeout 10 uvx minimax-coding-plan-mcp -y 2>&1 | head -30
```

Expected output:
- API key loads (20+ chars)
- uvx version displayed
- Server starts without "environment variable required" error

## Files Created

1. `docs/agent-instructions/MINIMAX_MCP_TERMINAL_GUIDE.md` - Comprehensive guide
2. `.cursor/commands/test-minimax-mcp.sh` - Quick test script
3. `.cursor/MINIMAX_MCP_STATUS.md` - This status file

## Next Steps

1. **For Claude Terminal:** Use the environment setup commands above
2. **For Cursor IDE:** Use the existing slash commands (/minimax-*)
3. **For Documentation:** Reference the guide in docs/

## Summary

✅ **MiniMax MCP is WORKING**
✅ **Accessible via `uvx minimax-coding-plan-mcp -y`**
✅ **Three tools available:** web_search, understand_image, MiniMax
✅ **Requires:** MINIMAX_API_KEY and MINIMAX_API_HOST
✅ **Tested:** Confirmed operational
✅ **Documented:** Full guides created

**The MCP server is confirmed working and ready for terminal Claude usage!**
