---
name: blocked-and-escalating
description: Use when completely blocked and cannot proceed. Triggers on (1) max loop iterations reached, (2) 3+ failed fixes with no progress, (3) permission denied for required action, (4) environmental issue preventing work. Creates structured escalation report and stops work to prevent wasted effort.
---

# Blocked and Escalating

## Overview

Continuing work when blocked wastes time. Structured escalation gets help efficiently.

**Core principle:** When blocked → STOP, document, escalate. Don't create workarounds.

## The Iron Law

```
WHEN BLOCKED → STOP + DOCUMENT + ESCALATE
```

If you're blocked, you cannot make progress. Stop immediately.

## When to Use

Use when completely unable to proceed:
- `/skill loop-detection` triggered (3+ attempts failed)
- `/skill systematic-debugging` Phase 4.5 reached (3+ fixes failed, architecture questioned)
- Permission denied for required action (Tier 1 can't edit CONSTITUTION.md)
- Environmental issue blocks work (disk full, service down, tool unavailable)
- Missing information/requirements (don't know what user wants)
- External dependency blocking (waiting for API, third-party service)

**Triggers from other skills:**
- loop-detection → detected loop → invoke this skill
- systematic-debugging → 3+ fixes failed → invoke this skill
- confident-language-guard → Tier 1 needs restricted edit → escalate

## The Process

### Step 1: Recognize Blockage

**You're blocked when:**
- Can't achieve goal after 3+ attempts
- Don't have permission for required action
- Environment prevents work (not code issue)
- Missing critical information
- External dependency unavailable
- Following process leads nowhere

**You're NOT blocked when:**
- Haven't tried root cause investigation yet
- Haven't followed systematic-debugging
- Haven't checked learnings INDEX
- Haven't asked clarifying questions
- Just need to think differently

### Step 2: STOP Work

**Immediately:**
- STOP all attempts on this goal
- Do NOT try "one more approach"
- Do NOT create workaround documentation
- Do NOT modify process files to "fix" this

**Why:**
- Continuing wastes time
- Creates technical debt
- Masks real problem
- Prevents proper escalation

### Step 3: Create Escalation Report

**Location:** `.claude/learnings/bugs/YYYY-MM-DD-blocked-description.md`

**Required sections:**

**Goal:** What were you trying to accomplish?
```
Example: Get boat_travel_test.gd to pass
```

**Blockage:** Why are you stuck? (Be specific)
```
Example: After 3 different autoload fixes, test still fails with "Autoload not found".
Root cause investigation shows autoload IS registered correctly. Possible test runner configuration issue beyond my ability to diagnose.
```

**Attempts:** What was tried? (file:line references)
```
Example:
1. Added autoload to project.godot:45 → no change
2. Reordered autoloads in project.godot:45-48 → no change
3. Verified autoload path → path correct, still fails
```

**Reproduction:** Exact commands to reproduce
```
Example:
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
Test: boat_travel_test.gd
Error: "ERROR: Autoload 'BoatManager' not found"
```

**Escalation Level:**
- Tier 1 → Tier 2 (Sonnet)
- Tier 2 → Tier 3 (Opus)
- Tier 3 → User

**Next Steps:** What should higher tier do?
```
Example: Review test runner configuration. May need architectural decision on testing approach.
```

### Step 4: Update INDEX

1. Open `.claude/learnings/INDEX.md`
2. Add entry under appropriate category
3. Mark as escalation/blocked issue
4. Include escalation level

### Step 5: Escalate

**Methods (in order of preference):**

1. **GitHub Issue** (if tier system uses issues):
   - Use `.github/ISSUE_TEMPLATE/handoff.md`
   - Link to escalation report
   - Assign to appropriate tier

2. **Direct mention** (if in conversation):
   - "@Tier-2" or "@Tier-3" or "@User"
   - Link to escalation report
   - Summarize blockage

3. **Wait for next session** (if async):
   - Escalation report will be found by next agent
   - Move to different task

### Step 6: Move On

**After escalating:**
- Move to different task in ROADMAP.md
- OR wait for guidance if no other tasks
- Do NOT return to blocked task without new information

**Track blocked items:**
- Blocked tasks stay in TODO with blocked status
- Don't mark as complete
- Don't try to finish partially

## Forbidden Actions

**Never do these when blocked:**

❌ Create workaround documentation
- "Add note to always do X to avoid Y"
- "Update process to prevent this"
- This recreates the original problem!

❌ Continue trying more fixes
- "One more approach might work"
- You're in a loop, stop

❌ Modify .md files with new rules
- "Always check X before Y"
- Use `/skill confident-language-guard` if you must edit

❌ Claim work is complete when blocked
- Don't mark as done
- Don't hide blockage

❌ Make up a solution
- Don't guess
- Don't assume

## Required Actions

**Always do these when blocked:**

✓ Create escalation report (all sections)
✓ Update INDEX.md
✓ Stop work on this task
✓ Escalate to appropriate tier
✓ Move to different task OR wait

## Escalation Paths

```
Tier 1 (Codex)
↓ Stuck on implementation
Tier 2 (Sonnet 4.5)
↓ Needs architectural decision
Tier 3 (Opus 4.5)
↓ Needs user input
User
```

**Tier 1 → Tier 2:**
- Implementation blocked
- Permission needed
- Skill creation needed
- Technical decision needed

**Tier 2 → Tier 3:**
- Architectural change needed
- CONSTITUTION.md edit needed
- Process change needed
- Major refactoring decision

**Tier 3 → User:**
- Requirements unclear
- Strategic decision needed
- External dependency
- Resource/budget decision

## Examples

### Example 1: Loop Detection Escalation (CORRECT)

**Trigger:** `/skill loop-detection` detected loop

**Action:**
1. loop-detection already created report ✓
2. Invoke `/skill blocked-and-escalating`
3. Create escalation report referencing loop report
4. Update INDEX
5. Escalate: Tier 1 → Tier 2
6. Stop work on this task
7. Move to next ROADMAP item

**Result:** ✓ CORRECT. Structured escalation, work stopped, moved on.

### Example 2: Permission Denied (CORRECT)

**Situation:** Tier 1 needs to edit CONSTITUTION.md

**Action:**
1. Recognize: CANNOT edit (permission restriction)
2. STOP: Don't try to edit anyway
3. Create escalation report:
   - Goal: Update TILE_SIZE constant
   - Blockage: Tier 1 cannot edit CONSTITUTION.md
   - Escalation: Tier 1 → Tier 3 (Opus owns CONSTITUTION)
4. Update INDEX
5. Escalate to Tier 3
6. Move to different task

**Result:** ✓ CORRECT. Respected permissions, escalated appropriately.

### Example 3: Workaround Documentation (WRONG)

**Situation:** Stuck on test failure after 3 attempts

**Wrong action:**
1. Create note in AGENTS.md: "Always verify autoload order before running tests"
2. Mark task as complete
3. Move on

**Why wrong:**
- Created rigid directive (confident-language-guard violation)
- Didn't escalate actual problem
- Masked blockage
- Technical debt created

**Correct action:**
1. Invoke `/skill blocked-and-escalating`
2. Create escalation report
3. Escalate without creating workaround docs

**Result:** ✗ WRONG approach avoided by using skill correctly.

## Integration

**This skill is invoked by:**
- loop-detection (when loop detected)
- systematic-debugging (when 3+ fixes failed)
- confident-language-guard (when Tier 1 needs escalation)

**This skill invokes:**
- None (terminal escalation, doesn't invoke other skills)

**This skill updates:**
- `.claude/learnings/bugs/` (escalation reports)
- `.claude/learnings/INDEX.md` (tracking)

## Quick Reference

| Blockage Type | Escalation Target |
|---------------|-------------------|
| **Implementation stuck** | Tier 1 → Tier 2 |
| **Permission denied** | → Tier owning that permission |
| **Architecture decision** | Tier 2 → Tier 3 |
| **CONSTITUTION change** | → Tier 3 |
| **User requirements unclear** | → User |
| **Environmental issue** | → User (can't fix environment) |

## Success Criteria

✓ Recognized blockage accurately
✓ Stopped work immediately
✓ Created complete escalation report
✓ Updated INDEX.md
✓ Escalated to appropriate tier
✓ Moved to different task
✓ Did NOT create workaround docs

## The Bottom Line

**Blocked → STOP + DOCUMENT + ESCALATE**

Don't create workarounds. Don't keep trying. Don't hide it.

Stop. Document. Escalate. Move on.

This is non-negotiable.
