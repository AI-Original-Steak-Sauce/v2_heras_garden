# Bug Report Template

**Instructions:** Copy this template to create a new bug report. Keep entries under 50 lines.

---

# [Short Description of Bug]

**Status:** active | archived | superseded-by-skill-name

**Agent:** [Tier X - Model Name]

**Date:** YYYY-MM-DD

**Category:** [Error category: test failure | resource load | build error | runtime error | etc.]

**File Type:** [.gd | .tres | .tscn | .md | etc.]

**Phase:** [Phase 1 | Phase 2 | Phase 3 | Phase 4 | Testing | etc.]

---

## What Happened

[Clear description of the bug/error that occurred]

Example:
> Attempted to load NPC resource file, but got "Resource file not found" error even though file exists at the specified path.

---

## Error Message (if applicable)

```
[Paste exact error message here]
```

---

## Reproduction Steps

1. [Exact command or action taken]
2. [Next step]
3. [Result/error]

Example:
1. Run `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
2. Test attempts to load `res://shared/resources/npcs/hermes.tres`
3. Error: "Cannot load resource at path: res://shared/resources/npcs/hermes.tres"

---

## Root Cause (if known)

[What investigation revealed - can be "unknown" if still investigating]

Example:
> Resource file schema changed but existing .tres files not updated. Property `npc_id` renamed to `id` in schema.

---

## Related Files

- [file:line references]

Example:
- `game/shared/resources/npcs/hermes.tres:1` - resource file
- `game/shared/scripts/npc_resource.gd:15` - resource class definition
- `tests/run_tests.gd:45` - test that failed

---

## Fix Attempted or Proposed

[What was tried or what should be done]

Example:
> Updated all .tres files to use new `id` property instead of `npc_id`. Verified with schema check.

---

## Similarity Check

**Check `.claude/learnings/INDEX.md` for similar bugs:**
- Same file type? [yes/no - list similar entries]
- Same error category? [yes/no - list similar entries]
- Same phase? [yes/no - list similar entries]

**If 2+ similar bugs exist:** Invoke `/skill skill-gap-finder` to check if skill should be created.

---

## After Creating This Entry

1. Update `.claude/learnings/INDEX.md` with this entry
2. Add to appropriate category
3. Check for similar bugs (2+ = skill gap)
