# Cursor Claude Code Permissions Setup

## Problem

The official Claude Code extension in Cursor keeps asking for permission to use Edit/Write tools, even when `.claude/settings.local.json` is configured correctly in the project.

## Root Cause

Cursor does NOT read `.claude/settings.local.json` from project folders. The Claude Code extension in Cursor reads permissions from Cursor's global settings file instead.

## Solution

Add `claudeCode.permissions` directly to Cursor's settings.json:

**File location:** `C:\Users\YOUR_USER\AppData\Roaming\Cursor\User\settings.json`

**Add this configuration:**
```json
"claudeCode.permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
        "Bash",
        "Edit",
        "Write",
        "NotebookEdit",
        "Read",
        "Grep",
        "Glob",
        "WebSearch",
        "WebFetch",
        "Skill"
    ],
    "deny": [
        "Read(./.env)",
        "Read(./.env.*)",
        "Bash(rm -rf:*)",
        "Bash(git push --force:*)"
    ]
}
