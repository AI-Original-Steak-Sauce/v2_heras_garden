---
description: General development workflow - auto-runs safe commands
---

<!-- 
  ANTIGRAVITY AGENTS ONLY
  This workflow is read by AI agents running in Antigravity.
  It has NO effect on VS Code, Godot, or any other tooling.
-->

// turbo-all

## Development Mode

When this workflow is active, the agent will auto-run all commands without requiring approval.

This is useful for:
- Running tests
- Opening editors
- Building the project
- Reading files and logs
- Starting dev servers

The agent should still use good judgment and NOT auto-run destructive commands like:
- Deleting files permanently
- Force pushing to git
- Installing system-level packages
