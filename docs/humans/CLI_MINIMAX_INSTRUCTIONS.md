# CLI Minimax Instructions

## What this does

Typing `minimax` in the Cursor terminal launches Claude Code using the MiniMax model.
Typing `claude` launches Claude Code using the normal Claude models.

## Quick use (copy/paste)

1) Reload your PowerShell profile (if you just opened the terminal, you can skip this):

```powershell
. $PROFILE
```

2) Start Claude Code:

```powershell
claude
```

3) Start MiniMax:

```powershell
minimax
```

## What was set up

- PowerShell profile: `C:\Users\Sam\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
- MiniMax launcher script: `C:\Users\Sam\Documents\GitHub\v2_heras_garden\scripts\start-claude-minimax.ps1`

The `minimax` command runs the launcher script, which:
- sets MiniMax environment variables
- starts the MiniMax auto chat saver
- runs `claude --model minimax:m2.1`

## Troubleshooting

- `minimax` is not recognized:
  - Run `. $PROFILE` or restart the terminal.
  - Open `C:\Users\Sam\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` and confirm the `minimax` function exists.

- Error: MiniMax launcher not found:
  - Check that this file exists:
    `C:\Users\Sam\Documents\GitHub\v2_heras_garden\scripts\start-claude-minimax.ps1`
  - If you moved the repo, update the path in the profile.

- MiniMax says invalid key or cannot authenticate:
  - Open `C:\Users\Sam\Documents\GitHub\v2_heras_garden\scripts\start-claude-minimax.ps1`
  - Update `$env:ANTHROPIC_AUTH_TOKEN` with your current MiniMax key.

- Auto chat saver pops up and you want to stop it:
  - Close the saver PowerShell window or press `Ctrl+C` in that window.

## How to undo

To remove the shortcut, delete the `minimax` function from:
`C:\Users\Sam\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

Then reload:

```powershell
. $PROFILE
```
