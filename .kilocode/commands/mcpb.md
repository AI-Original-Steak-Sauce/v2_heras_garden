---
description: "MCP (Model Context Protocol) server development"
---

You are now using the mcp-builder skill from .claude/skills/mcpb/SKILL.md

## MCP Server Types

### 1. Local (Stdio) Server
```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["/path/to/server/build/index.js"],
      "env": {
        "API_KEY": "your-api-key"
      }
    }
  }
}
```

### 2. Remote (SSE) Server
```json
{
  "mcpServers": {
    "server-name": {
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer your-api-key"
      }
    }
  }
}
```

## Server Configuration Options

- **disabled:** Temporarily disable the server
- **timeout:** Maximum time in seconds (default: 60)
- **alwaysAllow:** Tools that don't require user confirmation
- **disabledTools:** Tools to exclude from the system prompt

## Creating a Local MCP Server

### 1. Bootstrap Project
```bash
cd C:\Users\Sam\AppData\Roaming\Kilo-Code\MCP
npx @modelcontextprotocol/create-server server-name
cd server-name
npm install
```

### 2. Server Structure
```
server-name/
├── package.json
├── tsconfig.json
└── src/
    └── index.ts      # Main server implementation
```

### 3. Implement Server
```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "server-name",
  version: "0.1.0"
});

server.tool(
  "tool-name",
  {
    param1: z.string().describe("Parameter description"),
  },
  async ({ param1 }) => {
    // Tool implementation
    return {
      content: [
        {
          type: "text",
          text: "Result",
        },
      ],
    };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
```

### 4. Build and Configure
```bash
npm run build
```

Add to Kilo Code MCP settings:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["/path/to/server/build/index.js"],
      "env": {},
      "disabled": false,
      "alwaysAllow": [],
      "disabledTools": []
    }
  }
}
```

## Best Practices

- Use tools over resources when possible (more flexible)
- Handle errors gracefully
- Use proper TypeScript types
- Document all tools and parameters
- Follow MCP best practices in reference files
