# .agent Directory

**This folder is ONLY used by AI agents running in Antigravity.**

- VS Code, Godot, and other editors completely ignore this folder
- These files have NO effect on your normal development workflow
- Only Antigravity agents read and use these workflow files

## What's in here?

- `workflows/` - Markdown files that define automated task sequences for AI agents
- Workflows with `// turbo-all` annotation auto-run all commands without requiring user approval

## Safe to delete?

Yes. If you don't use Antigravity, you can safely delete this entire folder.
