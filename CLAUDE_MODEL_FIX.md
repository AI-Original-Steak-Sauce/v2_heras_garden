# Claude Model Configuration Fix

## Problem
Claude Code CLI was defaulting to MiniMax model instead of Claude models.

## Solution Applied

### 1. Updated System Configuration File
**File:** `~/.claude.json` (located at `/root/.claude.json`)

**Change made:** Added default model setting
```json
"model": "claude-sonnet-4-5"
```

This sets **Claude Sonnet 4.5** as the default model for all Claude CLI sessions system-wide.

### 2. Created Project-Level VS Code Settings
**File:** `.vscode/settings.json` (in the project directory)

**Content:**
```json
{
  "claude.model": "claude-sonnet-4-5"
}
```

This ensures the VS Code extension uses Claude Sonnet 4.5 when working in this project.

### 3. Verification
The configuration has been verified and is working correctly:
- ✅ Config file updated
- ✅ Default model set to Sonnet
- ✅ Claude CLI version 2.0.59 detected
- ✅ Model switching via command line confirmed working

## Usage

### Using Default Model (Sonnet)
Simply run:
```bash
claude
```

### Switching Models for a Session
Use the `--model` flag:

```bash
# Use Opus
claude --model opus

# Use Haiku
claude --model haiku

# Use MiniMax M21
claude --model minimax-m21
```

### Using the Helper Script
A convenience script has been created at `./claude_with_model.sh`:

```bash
# Use default (Sonnet)
./claude_with_model.sh

# Use MiniMax
./claude_with_model.sh minimax

# Use Opus
./claude_with_model.sh opus

# Use Haiku
./claude_with_model.sh haiku
```

## Available Models

| Alias | Full Model Name | Description |
|-------|----------------|-------------|
| `sonnet` | `claude-sonnet-4-5` | Claude Sonnet 4.5 (DEFAULT) |
| `opus` | `claude-opus-4-5` | Claude Opus 4.5 |
| `haiku` | `claude-haiku-4` | Claude Haiku 4 |
| `minimax-m21` | `minimax-m21` | MiniMax M21 |

## Configuration File Locations

### System-Wide Configuration
**File:** `~/.claude.json` (Linux/Mac) or `%USERPROFILE%\.claude.json` (Windows)
- This sets the default model for ALL Claude CLI sessions
- Modified to include: `"model": "claude-sonnet-4-5"`

### Project-Level Configuration (VS Code)
**File:** `.vscode/settings.json` (in your project directory)
- This sets the model for the VS Code extension when working in this project
- Created with: `"claude.model": "claude-sonnet-4-5"`

### Configuration Precedence
1. Command-line flags (`--model`) - **Highest priority**
2. Project settings (`.vscode/settings.json`)
3. User settings (`~/.claude.json`) - **Default**

## VS Code Extension

The Claude VS Code extension now has two levels of configuration:
1. **User-level** (`~/.claude.json`) - Applied to all projects
2. **Project-level** (`.vscode/settings.json`) - Applied to this project only

Both are now configured to use Sonnet as the default.

## Scripts Created

1. **verify_claude_config.sh** - Verifies the configuration is correct
2. **claude_with_model.sh** - Helper script to easily switch models

## Test the Fix

Run the verification script:
```bash
./verify_claude_config.sh
```

Expected output:
- ✓ Claude CLI found
- ✓ Config file exists
- Current model: claude-sonnet-4-5

---

**Fix completed:** 2026-01-01
**Configuration file:** `/root/.claude.json`
