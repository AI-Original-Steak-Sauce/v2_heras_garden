---
description: "Detect and prevent infinite loops"
---

You are now using the loop-detection skill from .claude/skills/ld/SKILL.md

## Core Principle
**AFTER 3 ATTEMPTS AT SAME GOAL → STOP AND DOCUMENT**

## When to Use

Use for ANY situation where progress has stalled:
- Test fails → fix attempt → test fails → different fix → test fails (loop!)
- Same file edited 3+ times in one session without success
- Same goal attempted with varying approaches that don't work
- Feeling "stuck" or uncertain what to try next
- About to say "let me try one more approach"

## The Iron Law Enforcement

### Detection: Recognize the Loop

**Triggers (any of these):**
1. Same action attempted 3+ times
2. Same test failing after multiple different fixes
3. Same goal attempted with varying approaches (intent matters, not method)
4. Same file edited 3+ times without achieving goal
5. Feeling stuck or uncertain

**Track by INTENT, not exact action:**
- Goal: "Make boat_travel_test.gd pass"
- Attempt 1: Fix autoload registration
- Attempt 2: Change autoload order
- Attempt 3: Verify project settings
- **This is a loop** even though methods differ - same goal, no progress

### Response: STOP and Document

**IMMEDIATELY when loop detected:**
1. **STOP** all work on this goal
2. **DO NOT** try "one more fix"
3. **DO NOT** create workaround documentation
4. **DO** create loop report

### Create Loop Report

**Location:** `.claude/learnings/loops/YYYY-MM-DD-description.md`

**Must include:**
- What goal was being attempted
- All approaches tried (list all 3+)
- Why agent is blocked
- Reproduction steps (exact commands)
- Whether systematic-debugging was followed
- Related files with file:line references
- Escalation plan

### Escalate

**Escalation path:** Ask User directly

**Method:**
- Explain what you tried (all 3+ attempts)
- Show the error/blocker clearly
- Ask user for guidance or permission to try different approach

## Red Flags - STOP and Use This Skill

If you catch yourself thinking:
- "Let me try one more approach"
- "Maybe if I adjust..."
- "This should work" (after 2+ failed attempts)
- Same file open for editing 3rd time
- Same test failing after multiple fixes
- **"One more fix attempt" (when already tried 2+)**

**ALL of these mean: STOP. You're in a loop. Use this skill.**

## Quick Reference

| Situation | Action |
|-----------|--------|
| **3+ attempts at same goal** | STOP → Create loop report → Escalate |
| **Same test failing repeatedly** | STOP → Invoke /sd → If already did, create loop report |
| **Feeling stuck** | STOP → Check if 3+ attempts made → If yes, loop detected |
| **About to try "one more fix"** | STOP → Count attempts → If ≥3, create loop report |
