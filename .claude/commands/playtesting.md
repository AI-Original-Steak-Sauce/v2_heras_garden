---
description: Lean HPV playtesting onboarding (Codex extension slash command)
argument-hint: [optional_focus]
allowed-tools: [Read, Grep, Glob]
model: haiku
---

# Playtesting Onboarding (Lean)

## Quick Orientation (about 30 seconds)
- HPV = headed playability validation using MCP (`mcp__godot__*`).
- Teleport-assisted setup is usually ok; do full walks only when requested.
- Minigames are typically skipped unless explicitly asked.

## Key Files (start here)
- `game/autoload/game_state.gd` (flags + inventory)
- `game/features/npcs/npc_base.gd` (dialogue routing)
- `game/features/world/world.tscn` (quest triggers)
- `docs/playtesting/PLAYTESTING_ROADMAP.md` (log + status)

## Top Pitfalls (common fixes)
1. Trigger does not fire after teleport: check `monitoring` and overlaps.
2. `ui_accept` consumed by dialogue: check `DialogueBox.visible` before interacting.
3. Cutscene never completes: rely on `cutscene_finished` signals, not only awaits.
4. Boat interaction: requires dialogue closed; `ui_accept` should map to interact.
5. Choice selection: needs focused button; call `_show_choices()` if flaky.

## Logging (keep it short)
- What you tested, shortcuts used, and where runtime eval was needed.
- What worked vs blocked, with repro steps if possible.

If `$ARGUMENTS` is provided, focus on that quest range/system.
