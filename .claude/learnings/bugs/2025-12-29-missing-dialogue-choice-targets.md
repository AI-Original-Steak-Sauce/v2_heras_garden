# Missing Dialogue Choice Targets

**Status:** archived

**Agent:** Tier 1 - Codex

**Date:** 2025-12-29

**Category:** resource load

**File Type:** .tres

**Phase:** Phase 3

---

## What Happened

Dialogue choices in `circe_intro` referenced `next_id` targets that did not exist as DialogueData resources.

---

## Error Message (if applicable)

```
ERROR: [DialogueChoiceTargetTest] Missing dialogue target 'circe_accept_farming' referenced by 'circe_intro'
ERROR: [DialogueChoiceTargetTest] Missing dialogue target 'circe_explain_pharmaka' referenced by 'circe_intro'
```

---

## Reproduction Steps

1. Run `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/dialogue_choice_target_test.gd`
2. Test checks choice `next_id` targets
3. Error logged for missing dialogue IDs

---

## Root Cause (if known)

Missing DialogueData .tres resources for the `next_id` references.

---

## Related Files

- `game/shared/resources/dialogues/circe_intro.tres:29` - choice `next_id` references
- `tests/dialogue_choice_target_test.gd:47` - validation test

---

## Fix Attempted or Proposed

Added `circe_accept_farming.tres` and `circe_explain_pharmaka.tres` resources.

---

## Similarity Check

**Check `.claude/learnings/INDEX.md` for similar bugs:**
- Same file type? no
- Same error category? no
- Same phase? no

---

Signoff: [Codex - 2025-12-29]
