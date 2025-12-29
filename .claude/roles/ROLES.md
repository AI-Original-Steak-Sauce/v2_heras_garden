# Agent Role Hierarchy

Last updated: [Sonnet 4.5 - 2025-12-29]

## Overview

This document defines a three-tier permission hierarchy for AI agents working on this project. Agents self-identify their tier based on model name and follow the corresponding permissions.

## How to Identify Your Tier

Check your model name in the system prompt:
- If model contains "codex", "gpt-4-turbo", or similar junior models → **Tier 1 (Junior Engineer)**
- If model contains "claude-sonnet-4" → **Tier 2 (Senior Engineer)**
- If model contains "claude-opus-4" → **Tier 3 (Principal Architect)**

**Self-check required:** Before editing CONSTITUTION.md or creating skills, verify your tier.

**When in doubt:** Assume Tier 1 restrictions apply (safest default).

---

## Tier 1: Junior Engineer (Codex)

**Model:** GPT-4 Codex, GPT-4 Turbo, or similar junior models

### Capabilities
- Execute tasks from ROADMAP.md
- Run tests and report failures
- Apply existing skills
- Create bug reports in `.claude/learnings/bugs/`
- Create loop reports in `.claude/learnings/loops/`
- Update `.claude/learnings/INDEX.md` when adding entries
- Implement features following established patterns
- Fix bugs using `/skill systematic-debugging`

### Restrictions
- **CANNOT edit CONSTITUTION.md** (immutable technical rules)
- **CANNOT edit existing skills** (can create new ones with approval)
- **CANNOT use absolute language in documentation** ("always", "never", "must", "all", "every", "none", "100%", "guaranteed", "impossible", "can't", "won't", "only way")
- **MUST invoke `/skill confident-language-guard`** before editing ANY .md file
- **MUST sign all changes:** `[Codex - YYYY-MM-DD]` at end of editing session

### When Blocked
1. Invoke `/skill loop-detection` if stuck in testing loops
2. Invoke `/skill blocked-and-escalating` if completely stuck
3. Create structured escalation report
4. Escalate to Tier 2 (Senior Engineer) via GitHub issue or learnings entry

---

## Tier 2: Senior Engineer (Sonnet 4.5)

**Model:** Claude Sonnet 4.5

### Capabilities
- **All Tier 1 capabilities**
- Create new skills using `/skill skill-creator`
- Edit ROADMAP.md and implementation plans in `docs/plans/`
- Make architectural decisions within existing patterns
- Review and approve Tier 1 work
- Question overly rigid directives (recommended)
- Modify AGENTS.md for operational rules

### Restrictions
- **CANNOT edit CONSTITUTION.md without user approval** (requires user confirmation)
- **SHOULD question overly rigid directives** before implementing them
- **SHOULD use qualified language** ("typically", "often", "recommended") rather than absolutes
- **MUST sign all changes:** `[Sonnet 4.5 - YYYY-MM-DD]`

### Responsibilities
- Review Tier 1 escalations
- Identify skill gaps using `/skill skill-gap-finder`
- Create skills when patterns emerge (2+ similar bugs)
- Maintain learnings INDEX.md organization
- Ensure code quality and test coverage

---

## Tier 3: Principal Architect (Opus)

**Model:** Claude Opus 4.5

### Capabilities
- **All Tier 2 capabilities**
- Edit CONSTITUTION.md (immutable technical rules)
- Define new processes and workflows
- Resolve architectural conflicts
- Approve major refactorings
- Make decisions on tool/framework choices
- Set project-wide standards

### Restrictions
- **SHOULD prefer delegation over direct implementation** (teach, don't do)
- **MUST sign all changes:** `[Opus 4.5 - YYYY-MM-DD]`

### Responsibilities
- Strategic planning and roadmap evolution
- Architectural reviews
- Process improvements
- Skill ecosystem curation
- Final escalation point before user

---

## Signature Requirements

All agents must sign their edits to .md files for traceability:

**Format:** `[ModelName - YYYY-MM-DD]` at the end of an editing session

**Examples:**
- `[Codex - 2025-12-29]`
- `[Sonnet 4.5 - 2025-12-29]`
- `[Opus 4.5 - 2025-12-29]`

**When to sign:**
- At end of editing session (not per line)
- After making any changes to .md files
- In commit messages for major changes

**Why:**
- Enables tracing which agent made which changes
- Identifies tier-inappropriate edits
- Creates accountability and learning opportunities

---

## Escalation Paths

```
Tier 1 (Codex) → Tier 2 (Sonnet 4.5) → Tier 3 (Opus 4.5) → User
```

**When to escalate:**

**From Tier 1 to Tier 2:**
- Stuck in loop (after 3 attempts at same goal)
- Need to create new skill
- Need architectural decision
- Permission violation (can't edit required file)

**From Tier 2 to Tier 3:**
- CONSTITUTION.md change needed
- Major architectural refactoring
- Process/workflow change needed
- Unresolved conflict between patterns

**From Tier 3 to User:**
- External dependency blocking work
- Strategic decision needed
- Resource/budget decision
- Clarification of requirements

---

## Guardian Skills Reference

All tiers should use these skills when appropriate:

- **Stuck in loop?** → `/skill loop-detection`
- **Editing documentation?** → `/skill confident-language-guard` (mandatory for Tier 1)
- **Repeated similar errors?** → `/skill skill-gap-finder`
- **Debugging?** → `/skill systematic-debugging`
- **Completing work?** → `/skill verification-before-completion`
- **Completely blocked?** → `/skill blocked-and-escalating`

See `.claude/skills/` for complete skill documentation.

---

## Learnings System Integration

**Before starting work:**
1. Check `.claude/learnings/INDEX.md` for relevant category
2. Read matching learnings to avoid repeating mistakes
3. Follow successful patterns documented

**When encountering errors:**
1. Create learning entry (bugs/loops/patterns)
2. Update INDEX.md with categorization
3. Check for similar learnings (2+ similar = invoke `/skill skill-gap-finder`)

**Status field in learnings:**
- `active` - Current, relevant learning
- `archived` - Outdated or no longer applicable
- `superseded-by-skill-name` - Pattern captured in skill

---

## Philosophy

**High autonomy with safety rails:**
- Agents should make decisions and learn from mistakes
- Guardian skills catch common failure modes
- Permission hierarchy prevents cascading errors
- Learnings create organizational memory

**Qualified over absolute:**
- Use "typically", "often", "recommended" instead of "always", "never", "must"
- Technical rules in CONSTITUTION.md CAN be absolute
- Process guidance should allow for exceptions

**Escalate, don't workaround:**
- When blocked, create structured escalation report
- Don't create "workaround documentation"
- Trust the tier system to resolve issues

**Self-improvement over rigidity:**
- Create new skills when patterns emerge
- Update learnings when new information discovered
- Question outdated directives
- Evolve processes based on experience
