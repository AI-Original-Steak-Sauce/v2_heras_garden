---
name: skill-gap-finder
description: Use when encountering repeated errors or bugs. Triggers on (1) error similar to previous bugs, (2) completing 2+ tasks with same workaround, (3) creating multiple learnings in same category. Identifies when to create new skills vs. document one-offs. Prevents skill explosion while capturing valuable patterns.
---

# Skill Gap Finder

## Overview

Repeated similar errors indicate a skill gap. Creating skills for every error causes skill explosion. This skill finds the balance.

**Core principle:** After 2 similar bugs → check for skill gap; create skills for patterns, not one-offs.

## The Iron Law

```
AFTER 2 SIMILAR BUGS → CHECK FOR SKILL GAP
Similarity = File type + Error category + Phase (2+ must match)
Max skill invocation depth = 2
```

If you haven't checked for similar bugs, you cannot propose a new skill.

## When to Use

Use when encountering errors or repeated workarounds:
- Just created a bug report in `.claude/learnings/bugs/`
- Completed 2+ tasks using the same workaround
- Created multiple learnings in same category
- Seeing similar error messages repeatedly
- Applying same fix pattern in different places
- About to document "always do X to avoid Y"

**Use this ESPECIALLY when:**
- Just documented a bug and wondering if it's a pattern
- Fixed similar issue before
- Creating second/third learning in same category
- Tempted to add process rule to prevent recurrence
- Pattern seems reusable across codebase

**Don't skip when:**
- "Just one bug" (might be second similar one)
- Seems too specific (let criteria decide)
- Unsure if pattern exists (that's what this skill determines)

## Similarity Criteria

**A bug is "similar" when 2+ of these match:**

1. **Same file type**
   - .gd scripts
   - .tres resources
   - .tscn scenes
   - .md documentation
   - etc.

2. **Same error category**
   - Test failure
   - Resource load failure
   - Build/compilation error
   - Runtime error
   - Schema mismatch
   - Autoload timing
   - Scene wiring
   - etc.

3. **Same phase of work**
   - Phase 1: Core systems
   - Phase 2: Data integrity
   - Phase 3: Scene setup
   - Phase 4: Gameplay
   - Testing
   - Documentation
   - etc.

**Example matching:**
```
Bug A: .tres resource load failure in Phase 2 data
Bug B: .tres resource load failure in Phase 3 scenes
Match: File type (.tres) + Error category (resource load) = SIMILAR ✓
```

**Example NOT matching:**
```
Bug A: .gd runtime error in Phase 3
Bug B: .tres resource load in Phase 2
Match: None (different file type, different error, different phase) = NOT SIMILAR ✗
```

## The Process

You MUST complete each step when this skill is invoked.

### Step 1: Check Learnings INDEX

**After encountering an error:**

1. Open `.claude/learnings/INDEX.md`
2. Scan categories relevant to your error
3. Look for similar bugs using similarity criteria above
4. Count matches: How many bugs match 2+ criteria?

**Result:**
- 0-1 similar bugs → Continue to Step 5 (no skill gap yet)
- 2+ similar bugs → Continue to Step 2 (potential skill gap!)

### Step 2: Verify Similarity

**For each potentially similar bug:**

1. Read the full learning entry
2. Check root cause (if known)
3. Verify it's truly similar, not coincidentally matching criteria

**Questions to ask:**
- Is the root cause the same or related?
- Would the same skill help both situations?
- Are they genuinely part of a pattern?

**If root causes differ:**
- Even with matching criteria, different root causes = NOT similar
- Document both separately, no skill gap

**Example:**
```
Bug A: .tres load fails - root cause: schema mismatch
Bug B: .tres load fails - root cause: file path typo
Criteria match: YES
Root causes related: NO (one is schema, one is path)
Similar for skill purposes: NO ✗
```

### Step 3: Check Invocation Depth

**Before proposing skill:**

Count current skill invocation depth:
- This skill invoked from main conversation: depth = 1
- This skill invoked from loop-detection: depth = 2
- This skill invoked from another skill: depth = 2

**Depth limits:**
- Depth ≤ 2: Can invoke skill-creator (Step 4)
- Depth > 2: Log proposal and escalate (Step 6)

**Why:** Prevents circular skill invocations (loop-detection → skill-gap-finder → skill-creator → another-skill → ...)

### Step 4: Propose New Skill

**If 2+ similar bugs AND depth ≤ 2:**

1. Invoke `/skill skill-creator` with context:
   - What pattern the skill should address
   - Link to source learnings (file:line references)
   - Examples of when to use the skill
   - Counter-examples (when NOT to use)

2. Skill should:
   - Address the root cause pattern
   - Include Iron Law or gate function
   - Have clear triggering criteria
   - Link back to learnings that inspired it

3. Document in new skill's SKILL.md:
   ```markdown
   ## Origin

   This skill was created from learnings:
   - `.claude/learnings/bugs/2025-12-29-resource-load-failure.md`
   - `.claude/learnings/bugs/2025-12-28-scene-resource-null.md`
   - `.claude/learnings/bugs/2025-12-27-autoload-timing.md`
   ```

### Step 5: Document One-Off

**If 0-1 similar bugs OR similarity not verified:**

This is a one-off, not a pattern:

1. Create learning entry in `.claude/learnings/bugs/`
2. Update INDEX.md with proper categorization
3. Do NOT create a skill
4. Move on to next task

**One-offs are valuable:** They inform future work without creating skill bloat.

### Step 6: Log Proposal (Depth Limit Reached)

**If 2+ similar bugs BUT depth > 2:**

Can't invoke skill-creator due to depth limit:

1. Create proposal in `.claude/learnings/patterns/YYYY-MM-DD-proposed-skill-name.md`
2. Include:
   - What pattern needs a skill
   - Why skill is needed (link to similar bugs)
   - Proposed skill name and description
   - When this skill should be created (manually later, or by higher tier)
3. Update INDEX.md with proposal entry
4. Escalate to user or higher tier

**Why log instead of create:**
- Prevents infinite skill invocation chains
- Allows human review of skill proposals
- Maintains system stability

### Step 7: Update Learnings

**After creating skill OR logging proposal:**

1. Update source learning entries:
   - Change status from `active` to `superseded-by-skill-name`
   - OR add note: "Pattern logged as proposal in patterns/..."

2. Update INDEX.md:
   - Move superseded learnings to "Archived/Superseded" section
   - Add new skill to "Skills Created from Learnings" section

3. Archive old learning files:
   - Keep for reference but mark as superseded
   - Prevents same pattern from triggering skill-gap-finder again

## Counter-Examples: When NOT to Create Skill

Do NOT propose a skill for:

1. **One-off environmental issues**
   - Disk space full
   - Network timeout
   - Temporary service outage
   - Local machine configuration

2. **User-specific preferences**
   - Code formatting style
   - Personal workflow choices
   - Team-specific conventions
   - Non-technical decisions

3. **External tool bugs**
   - Godot engine bug
   - Compiler bug
   - Third-party library issue
   - Tool limitations

4. **Already covered by existing skill**
   - Check `.claude/skills/` directory
   - If existing skill addresses this, no new skill needed
   - Consider updating existing skill instead

5. **Too specific / No generalization**
   - Only applies to one file
   - Unique to current project state
   - Won't recur in different context
   - Can't articulate general pattern

**Example counter-examples:**
```
❌ "Disk was full, deleted temp files" → Environmental, not pattern
❌ "Used snake_case per team style" → Preference, not error pattern
❌ "Godot 4.5.1 crash on large scenes" → External tool bug
❌ "File foo.gd had syntax error on line 42" → Too specific
```

## Red Flags - Consider Alternatives

If you catch yourself:
- Proposing skill after first occurrence
- Creating skill for environmental issue
- Making skill for user preference
- Duplicating existing skill functionality
- Can't articulate when skill should be used
- Skill would only apply to one file/situation
- Pattern based on unverified similarity

**ALL of these mean: STOP. Review counter-examples. Likely NOT a skill gap.**

## Examples

### Example 1: Resource Loading Pattern (SKILL GAP)

**Situation:**
```
Bug A (Dec 27): .tres autoload timing - used before registration
Bug B (Dec 28): .tres scene resource - null after load
Bug C (Dec 29): .tres resource load - schema mismatch

Similarity check:
- File type: All .tres ✓
- Error category: All resource loading ✓
- Phase: Mixed (Phase 2, Phase 3, testing)
- Root causes: All related to resource loading validation

Match: 2+ criteria (file type + error category) ✓
Similar: YES
```

**Action:**
1. Verify 2+ similar bugs ✓
2. Check depth: 1 (invoked from main) ✓
3. Invoke skill-creator to create "resource-loading-safety" skill
4. Skill includes: schema validation, path verification, null checks
5. Link back to all 3 bug learnings
6. Update INDEX, mark bugs as superseded

**Result:** ✓ SKILL CREATED. Pattern captured, prevents future issues.

### Example 2: Network Timeout (NOT A SKILL GAP)

**Situation:**
```
Bug A: API call timed out - network slow
Bug B: Resource download failed - network interrupted

Similarity check:
- File type: Different (.gd vs external)
- Error category: Both network-related ✓
- Phase: Different
- Root causes: External network issues (not code problem)

Match: 1 criteria only
Counter-example match: Environmental issue ✓
```

**Action:**
1. Check similarity: Only 1 criterion matches
2. Check counter-examples: Environmental issue
3. Do NOT propose skill
4. Document as one-offs in learnings
5. Move on

**Result:** ✓ CORRECT. No skill needed for environmental issues.

### Example 3: Test Syntax Errors (NOT A SKILL GAP)

**Situation:**
```
Bug A: test_boat.gd line 15 - missing colon
Bug B: test_npc.gd line 23 - wrong indentation
Bug C: test_item.gd line 8 - typo in variable name

Similarity check:
- File type: All .gd ✓
- Error category: All syntax errors ✓
- Phase: All testing ✓
- Root causes: Different syntax mistakes (not pattern)

Match: 3 criteria ✓
But: Different root causes, too specific, already covered by linter
```

**Action:**
1. Criteria match but no generalizable pattern
2. Counter-example: Too specific, different root causes
3. Already covered: Linter catches syntax errors
4. Do NOT propose skill
5. Document as one-offs

**Result:** ✓ CORRECT. Syntax errors don't need new skill (linter exists).

### Example 4: Depth Limit Reached (LOG PROPOSAL)

**Situation:**
```
Invocation chain:
1. loop-detection invoked (depth = 1)
2. loop-detection invokes skill-gap-finder (depth = 2)
3. skill-gap-finder finds pattern, wants to create skill

Current depth: 2
Can invoke skill-creator? depth + 1 = 3 > 2 ✗
```

**Action:**
1. Verify skill gap exists ✓
2. Check depth: 2, would become 3 if invoked skill-creator ✗
3. Cannot invoke skill-creator (depth limit)
4. Create proposal in `.claude/learnings/patterns/2025-12-29-proposed-loop-prevention.md`
5. Include all details for manual skill creation
6. Update INDEX with proposal
7. Escalate to user/Tier 3

**Result:** ✓ CORRECT. Depth limit prevents cascade, proposal logged.

## Integration with Other Skills

**This skill integrates with:**

**loop-detection:**
- After loop detected → check if pattern exists
- If 2+ similar loops → skill gap (skill to prevent loops)
- Creates skills that prevent specific loop types

**blocked-and-escalating:**
- If skill gap but can't create (depth limit) → escalate
- Escalation includes skill proposal

**systematic-debugging:**
- Proper debugging prevents many bugs
- But if 2+ similar bugs despite debugging → skill gap
- Skill might address architectural issue

**skill-creator:**
- This skill invokes skill-creator when gap found
- Provides context and examples for new skill
- Links back to learnings

**verification-before-completion:**
- Both prevent repeating mistakes
- skill-gap-finder creates systemic prevention (skills)
- verification ensures process followed

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Just create a skill to be safe" | Skill explosion. Use criteria. |
| "Might be useful someday" | Create skills for actual patterns. |
| "Only one similar bug but feels important" | Wait for 2+. One bug might be coincidence. |
| "I'll make it general purpose" | Specific patterns → specific skills. |
| "This will prevent issues" | Only if it's a real pattern. |
| "Environmental but keeps happening" | Fix environment, don't create skill. |

## Quick Reference

| Situation | Action |
|-----------|--------|
| **First bug in category** | Document in learnings, no skill yet |
| **Second similar bug** | Invoke this skill, check criteria |
| **2+ criteria match + verified** | Create skill (if depth ≤ 2) |
| **Environmental issue** | Document only, no skill |
| **Already covered by skill** | No new skill, maybe update existing |
| **Depth > 2** | Log proposal, escalate |

## Success Criteria

**You've successfully used this skill when:**
- ✓ Checked INDEX for similar bugs
- ✓ Applied similarity criteria (2+ must match)
- ✓ Verified root causes are related
- ✓ Checked counter-examples
- ✓ Respected depth limits
- ✓ Created skill for real patterns (not one-offs)
- ✓ OR correctly identified one-off (no skill needed)
- ✓ Updated INDEX appropriately
- ✓ Linked learnings to created skill

## The Bottom Line

**2+ similar bugs → check for skill gap.**

Use similarity criteria. Verify root causes. Check counter-examples. Respect depth limits.

Create skills for patterns, not one-offs.

This is non-negotiable.
