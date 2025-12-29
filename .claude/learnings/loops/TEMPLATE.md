# Loop Detection Report Template

**Instructions:** Copy this template when `/skill loop-detection` is triggered. Keep entries under 50 lines.

---

# [Short Description of Loop]

**Status:** active | archived | superseded-by-skill-name

**Agent:** [Tier X - Model Name]

**Date:** YYYY-MM-DD

**Category:** [Loop type: test failure loop | fix attempt loop | build retry loop | etc.]

**Trigger:** [What invoked loop-detection: 3+ attempts | same goal with different approaches | etc.]

---

## Goal Being Attempted

[What was the agent trying to accomplish?]

Example:
> Get GdUnit4 tests to pass for boat_travel_test.gd

---

## Approaches Tried (list all 3+)

1. **Attempt 1:** [What was tried]
   - Result: [What happened]

2. **Attempt 2:** [What was tried]
   - Result: [What happened]

3. **Attempt 3:** [What was tried]
   - Result: [What happened]

4. **Attempt 4+:** [Additional attempts if any]
   - Result: [What happened]

Example:
1. **Attempt 1:** Added missing autoload registration
   - Result: Test still failed with "Autoload not found" error

2. **Attempt 2:** Changed autoload registration order
   - Result: Same error, no improvement

3. **Attempt 3:** Verified autoload path in project settings
   - Result: Still failing, same error

---

## Why Agent is Blocked

[Clear statement of what is preventing progress]

Example:
> Unable to determine why autoload is not being recognized by test runner. Error message is not providing enough information. May be fundamental issue with test setup or Godot test runner.

---

## Root Cause Investigation Attempted?

**Did agent follow `/skill systematic-debugging`?**
- [ ] Yes - completed Phase 1: Root Cause Investigation
- [ ] No - skipped to random fixes

**If yes, what did investigation reveal?**
[Summary of findings]

**If no, why not?**
[Reason for skipping systematic debugging]

---

## Related Files

- [file:line references showing what was edited]

Example:
- `game/project.godot:45` - autoload registration (edited 3 times)
- `tests/gdunit4/boat_travel_test.gd:1` - test file
- `game/shared/scripts/boat_manager.gd:1` - autoload script

---

## Escalation

**Escalation level:** [Tier 1 → Tier 2 | Tier 2 → Tier 3 | Tier 3 → User]

**Escalation method:** [GitHub issue | learnings entry | direct user ask]

**Action taken:** [What agent did after detecting loop]

Example:
> Created this loop report, stopped work on boat_travel_test.gd, escalating to Tier 2 for architectural review. Possible test runner configuration issue.

---

## Similarity Check

**Check `.claude/learnings/INDEX.md` for similar loops:**
- Similar goal? [yes/no - list similar entries]
- Similar error pattern? [yes/no - list similar entries]
- Similar phase of work? [yes/no - list similar entries]

**If similar loop exists:** Check if existing skill addresses this, or if new skill needed.

---

## FORBIDDEN Actions

- ✗ Creating workaround documentation instead of escalating
- ✗ Continuing to try "one more fix" after loop detected
- ✗ Editing .md files to add new process rules (that's what caused the original problem!)

## REQUIRED Actions

- ✓ Create this loop report
- ✓ Update `.claude/learnings/INDEX.md`
- ✓ Stop work on blocked task
- ✓ Escalate with structured report
- ✓ Move to next task OR wait for intervention

---

## After Creating This Entry

1. Update `.claude/learnings/INDEX.md` with this entry
2. Add to loops category
3. Escalate per instructions above
4. Stop work on this task
