---
description: Ralph autonomous coding loop with MiniMax subagent delegation for scalable asset generation
argument-hint: <task_description> [--mode hitl|autonomous] [--max <n>] [--hitl-interval <n>]
allowed-tools: [Read, Grep, Glob, Edit, Write, Bash, TodoWrite, Task, Skill]
model: sonnet
---

# Ralph - Autonomous Coding with MiniMax Subagent Delegation

**Task:** `$ARGUMENTS`

Ralph is an autonomous coding loop designed for:
- Generating multiple similar assets (tiles, sprites, dialogues)
- Scalable content creation (10+ variations)
- Tasks with clear completion criteria

## How Ralph Works

Ralph extends `/longplan` with automatic MiniMax subagent orchestration:

1. **Decompose** task into independent chunks
2. **Spawn** MiniMax subagents for each chunk
3. **Validate** results (tests, lint, build)
4. **Detect** completion via semantic analysis
5. **Update** progress file
6. **Loop** until complete or max iterations

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--mode` | `hitl` | `hitl`: Request review every N iterations<br>`autonomous`: Run without interruption |
| `--max` | `10` | Maximum iterations before stopping |
| `--hitl-interval` | `3` | Request human review every N iterations (hitl mode only) |

## When to Use Ralph

**✅ Use Ralph for:**
- Generating 10+ similar assets (tiles, sprites, dialogues)
- Batch content creation with clear acceptance criteria
- Tasks that can be split into independent parallel chunks

**❌ Use /longplan for:**
- Feature implementation (complex, multi-file)
- Bug fixes (require debugging)
- Architectural decisions (require human judgment)

## Quick Start

```
/ralph "Generate 10 procedural tile variations for Phase 8. Tiles: 3 grass, 3 dirt, 2 stone, 2 water. All 16x16 pixels, seamless tiling. Save to game/textures/tiles/" --mode autonomous --max 10
```

## Ralph vs /longplan

| Feature | /longplan | Ralph |
|---------|-----------|-------|
| Subagent delegation | Manual | Automatic (MiniMax) |
| Progress tracking | TodoWrite only | Progress file + TodoWrite |
| Completion detection | Manual | Automatic (MiniMax analysis) |
| Rate limiting | None | 100 calls/hour |
| Session persistence | None | Progress file |

## Examples

### Autonomous Tile Generation
```bash
/ralph "Generate 10 procedural tile variations. Tiles: 3 grass, 3 dirt, 2 stone, 2 water. All 16x16 pixels. Save to game/textures/tiles/" --mode autonomous --max 10
```

### HITL Dialogue Writing
```bash
/ralph "Write 40 dialogue lines for Hermes NPC. Include: first meet, idle chat, quest1_start, quest1_complete. Follow Storyline.md tone." --mode hitl --max 10 --hitl-interval 2
```

### Resume Interrupted Session
```bash
/ralph "Resume from temp/ralph-20260124-143052.json"
```

---

**Signature:** `[GLM-4.7 - 2026-01-24]`
