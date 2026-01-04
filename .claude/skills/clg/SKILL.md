---
name: confident-language-guard
description: Use before editing any .md file to prevent overconfident absolute language. Mandatory for Tier 1 agents. Use when (1) about to edit .md files, (2) documenting processes, (3) writing guidance. Prevents outdated rigid directives that become constraints.
---

# Confident Language Guard

## Overview

Overconfident documentation becomes rigid constraints that prevent self-correction. Statements like "always do X" or "never do Y" create problems when contexts change.

**Core principle:** State changes in qualified language FIRST, before drafting.

## The Iron Law

```
BEFORE EDITING ANY .MD FILE → STATE CHANGES IN QUALIFIED LANGUAGE FIRST
(Prevents wasting tokens drafting, prevents rigid directives)
```

If you haven't stated your intent in qualified terms, you cannot draft the edit.

## When to Use

**MANDATORY for Tier 1 agents** before ANY .md file edit.

**Recommended for all tiers** when:
- About to edit .md files (AGENTS.md, ROADMAP.md, plans, learnings, etc.)
- Documenting processes or workflows
- Writing guidance for other agents
- Adding notes or instructions to documentation
- Updating learnings entries

**Use this ESPECIALLY when:**
- About to use "always", "never", "must", "all", etc.
- Writing process rules
- Frustrated and wanting to prevent future issues
- Based on one example/experience
- Tier 1 agent editing documentation

**Exception:**
- CONSTITUTION.md may use absolute language (technical rules CAN be absolute)
- Example: "TILE_SIZE = 32 pixels" is absolute because it's a technical constant

## Forbidden Patterns

**For Tier 1 (Codex) - CANNOT use these in .md files:**
- "always", "never", "must", "all", "every", "none"
- "100%", "guaranteed", "impossible"
- "can't", "won't", "only way"
- "has to", "needs to", "required to" (unless describing actual permissions)

**For All Tiers - AVOID in process documentation:**
- Absolute statements based on single experiences
- Process rules that don't allow exceptions
- "One true way" guidance
- Statements that will become outdated

## The Pre-Writing Checkpoint

```
BEFORE drafting any .md edit:

1. STATE (in chat, not in file):
   - What you're changing
   - Why you're changing it
   - Use qualified language

2. SCAN your statement for forbidden patterns
   - Tier 1: Replace absolutes
   - All tiers: Question rigid directives

3. GET implicit approval
   - Tier 1: Check if needs escalation to Tier 2+
   - All tiers: Pause to consider if too rigid

4. ONLY THEN draft and write
   - Use qualified language in the actual file
   - Keep flexibility for future changes

5. SIGN at end of editing session
   - Format: [ModelName - YYYY-MM-DD]
```

## Qualified Language Examples

**Instead of absolutes, use:**
- "typically", "often", "usually"
- "recommended", "suggested", "preferred"
- "generally", "commonly"
- "should" (not "must"), "can" (not "has to")
- "in most cases", "as a rule of thumb"

**Good vs. Bad:**

| Bad (Absolute) | Good (Qualified) |
|----------------|------------------|
| "Always run tests before commits" | "Recommended: Run tests before commits" |
| "Never edit this file" | "Tier 1 cannot edit this file" (permission, not advice) |
| "Must follow this process" | "Typically follow this process" |
| "This is the only way" | "This approach works well" |
| "100% required" | "Strongly recommended" |
| "Every time you see X, do Y" | "When you see X, consider doing Y" |
| "Can't do X without Y" | "X requires Y in most cases" OR "X typically needs Y" |

**Permission statements vs. advice:**
- ✓ "Tier 1 cannot edit CONSTITUTION.md" (permission, absolute is correct)
- ✗ "Never edit CONSTITUTION.md" (advice, too absolute)
- ✓ "Tests should pass before committing" (advice, allows exceptions)
- ✗ "Tests must pass before committing" (too rigid, what about WIP commits?)

## Red Flags - STOP and Use This Skill

If you catch yourself:
- Already drafted edit before stating intent (too late!)
- Using absolute terms in ROADMAP.md or AGENTS.md
- Saying "This always works" or "Never do X"
- Writing process rule based on one experience
- Editing learnings with absolute language
- About to write documentation without using this skill (Tier 1)
- Frustrated and wanting to "prevent this forever"

**ALL of these mean: STOP. Use this skill. State intent in qualified language first.**

## Examples

### Example 1: Process Documentation (BAD)

**Agent about to write:**
> "Always use --quit-after when launching Godot. Never run without it."

**Red flag:** "Always", "Never"

**Action:** ✗ TOO ABSOLUTE. Rewrite.

**Better:**
> "Recommended: Use --quit-after when launching Godot for tests to prevent hanging processes."

**Why:** Allows for exceptions (manual testing, debugging), stays relevant when contexts change.

### Example 2: Learnings Entry (BAD)

**Agent about to write:**
> "All resource files must have schema validation. Every .tres file needs this check."

**Red flag:** "All", "must", "Every", "needs"

**Action:** ✗ TOO ABSOLUTE for learnings. Rewrite.

**Better:**
> "Resource files typically benefit from schema validation. This check helped catch mismatches in NPC .tres files."

**Why:** Describes what worked without mandating it universally.

### Example 3: ROADMAP Update (GOOD)

**Agent states intent:**
> "I'm updating ROADMAP.md to note that resource validation is recommended before loading. This helps catch schema mismatches."

**Scans for forbidden patterns:** None present ("recommended" is qualified)

**Drafts and writes:**
> "Recommended: Validate resource schemas before loading to catch mismatches early."

**Signs:** `[Sonnet 4.5 - 2025-12-29]`

**Action:** ✓ CORRECT. Qualified language, stated intent first, signed.

### Example 4: Tier 1 Escalation (GOOD)

**Tier 1 agent (Codex) wants to write:**
> "All agents must check learnings INDEX before starting work."

**Red flag:** "All", "must" (forbidden for Tier 1)

**Action:**
1. Recognize forbidden patterns
2. Rewrite with qualified language OR
3. Escalate to Tier 2+ if feels strongly about it

**Options:**
- Qualified: "Recommended: Check learnings INDEX before starting work"
- Escalate: "I think agents should check INDEX before work. Escalating to Tier 2 for documentation update."

**Action taken:** Either is ✓ CORRECT.

### Example 5: CONSTITUTION.md Exception (GOOD)

**Agent writing to CONSTITUTION.md:**
> "TILE_SIZE = 32 pixels (immutable)
> Autoload registration must happen before use (technical requirement)
> Property names must match SCHEMA.md exactly (prevents load failures)"

**Contains "must":** Yes, but in CONSTITUTION.md (exception applies)

**Action:** ✓ CORRECT. Technical rules can be absolute.

**Why:** These are technical constraints, not process advice.

## Tier-Specific Requirements

### Tier 1 (Codex) - MANDATORY

**Before editing ANY .md file:**
1. Invoke this skill (mandatory)
2. State intent in chat with qualified language
3. Scan for all forbidden patterns (see list above)
4. If forbidden patterns found → rewrite OR escalate
5. Get implicit approval before drafting
6. Write with qualified language
7. Sign: `[Codex - YYYY-MM-DD]`

**If unsure:** Escalate edit to Tier 2.

### Tier 2 (Sonnet 4.5) - RECOMMENDED

**Before editing .md files:**
1. Consider using this skill (recommended, not mandatory)
2. Question overly rigid directives
3. Use qualified language for process guidance
4. Use absolute language only for technical constraints
5. Sign: `[Sonnet 4.5 - YYYY-MM-DD]`

**Responsibility:** Review Tier 1 edits for rigid language.

### Tier 3 (Opus 4.5) - RECOMMENDED

**Before editing .md files:**
1. Consider using this skill for process documentation
2. Can use absolute language when appropriate
3. Prefer qualified language for adaptability
4. Sign: `[Opus 4.5 - YYYY-MM-DD]`

**Responsibility:** Set standards for documentation tone.

## Integration with Other Skills

**This skill prevents the problem that:**
- loop-detection addresses (rigid process → agents can't adapt)
- skill-gap-finder identifies (outdated directives → repeated issues)
- systematic-debugging solves (prescriptive fixes → miss root causes)

**This skill protects:**
- Learnings entries from becoming rigid rules
- AGENTS.md from becoming outdated constraints
- ROADMAP.md from being too prescriptive
- New skills from being too narrow

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "This always works" | In your one example. Use "typically works". |
| "Just this once" | Forbidden patterns are never OK. |
| "It's faster to skip" | Creates tech debt. Take 30 seconds. |
| "I'm Tier 2, not mandatory for me" | Still creates rigid directives. |
| "This is a real requirement" | Then put it in CONSTITUTION.md. |
| "I'm documenting what worked" | Describe, don't prescribe. |

## Quick Reference

| Situation | Action |
|-----------|--------|
| **Tier 1 editing .md** | MANDATORY - Use this skill |
| **Any tier writing process doc** | RECOMMENDED - Use this skill |
| **See "always"/"never" in draft** | STOP - Rewrite with qualified language |
| **Editing CONSTITUTION.md** | Exception - Absolutes OK for technical rules |
| **Frustrated, want to "prevent forever"** | STOP - That's rigid thinking. Use qualified language. |

## Success Criteria

**You've successfully used this skill when:**
- ✓ Stated intent BEFORE drafting
- ✓ Used qualified language ("typically", "recommended")
- ✓ No forbidden patterns in final text (or in CONSTITUTION.md only)
- ✓ Signed edit: [ModelName - YYYY-MM-DD]
- ✓ Documentation allows for future flexibility
- ✓ Tier 1 agents either used qualified language OR escalated

## The Bottom Line

**State intent in qualified language BEFORE drafting.**

Use "typically" not "always". Use "recommended" not "must". Use "often" not "every time".

Leave room for exceptions. Leave room for evolution.

This is non-negotiable for Tier 1.
