# DAP Integration Documentation

**Date:** 2025-01-22
**Status:** Server Built, Ready for MCP Configuration

## What Was Built

- **Repository:** [TransitionMatrix/godot-dap-mcp-server](https://github.com/TransitionMatrix/godot-dap-mcp-server)
- **Location:** `godot-dap-mcp-server/godot-dap-mcp-server.exe`
- **Go Version:** 1.25.6

## Available DAP Tools

The godot-dap-mcp-server provides the following MCP tools:

| Tool | Purpose |
|------|---------|
| `godot_ping` | Health check |
| `godot_connect` | Connect to Godot debugger |
| `godot_disconnect` | Disconnect from debugger |
| `godot_continue` | Resume execution |
| `godot_step_over` | Step over current line |
| `godot_step_into` | | Step into function |
| `godot_set_breakpoint` | Set breakpoint at file:line |
| `godot_clear_breakpoint` | Remove breakpoint |
| `godot_get_threads` | Get thread information |
| `godot_get_stack_trace` | Get call stack |
| `godot_get_scopes` | Get variable scopes |
| `godot_get_variables` | Inspect variables |
| `godot_evaluate` | Evaluate expression |
| `godot_launch_main_scene` | Launch main scene |
| `godot_launch_scene` | Launch specific scene |
| `godot_launch_current_scene` | Launch current scene |
| `godot_attach` | Attach to running instance |
| `godot_pause` | Pause execution |
| `godot_set_variable` | Modify variable value |

## Configuration

To use with Claude Desktop, add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "godot-dap": {
      "command": "path/to/godot-dap-mcp-server.exe",
      "args": []
    }
  }
}
```

## Usage Example

```bash
# Start the DAP server
./godot-dap-mcp-server/godot-dap-mcp-server.exe

# In another terminal, start Godot with debugging
./Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe --path . --editor

# Use MCP tools to:
# 1. Connect: godot_connect
# 2. Set breakpoint: godot_set_breakpoint (file, line)
# 3. Launch: godot_launch_main_scene
# 4. Inspect: godot_get_variables
```

## Notes

- DAP server runs on stdin/stdout (MCP protocol)
- Requires Godot to be running in debug mode
- Breakpoints can be set on GDScript files
- Variable inspection works for locals, parameters, and class members
- Full call stack tracing available
