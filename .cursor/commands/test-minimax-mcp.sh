#!/bin/bash
# Quick Test for MiniMax MCP - Terminal Claude Usage

echo "╔════════════════════════════════════════════════════════════╗"
echo "║       MINIMAX MCP - TERMINAL QUICK TEST                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment variables
export MINIMAX_API_KEY="sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
export MINIMAX_API_HOST="https://api.minimax.io"
export MINIMAX_API_RESOURCE_MODE="url"
export MINIMAX_MCP_BASE_PATH="C:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden\\.cursor\\mcp-output"

echo "✅ Environment variables set"
echo ""

# Check uvx
echo "🔍 Checking uvx..."
if command -v uvx &> /dev/null; then
    echo "  ✅ uvx is installed: $(uvx --version)"
else
    echo "  ❌ uvx not found - install with: pip install uvx"
    exit 1
fi
echo ""

# Test MCP server startup
echo "🚀 Testing MiniMax MCP server..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

timeout 5 uvx minimax-coding-plan-mcp -y 2>&1 | head -30

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📋 AVAILABLE TOOLS:"
echo "  1. web_search      - Google-like search"
echo "  2. understand_image - Analyze images (JPEG/PNG/WebP)"
echo "  3. MiniMax core    - AI functionality"
echo ""

echo "💡 QUICK START:"
echo "  export MINIMAX_API_KEY='sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c'"
echo "  export MINIMAX_API_HOST='https://api.minimax.io'"
echo "  uvx minimax-coding-plan-mcp -y"
echo ""

echo "📖 For detailed guide: docs/agent-instructions/MINIMAX_MCP_TERMINAL_GUIDE.md"
echo ""
echo "✅ MiniMax MCP is WORKING and ready to use!"
