# Successful Pattern Template

**Instructions:** Copy this template to document successful solutions and patterns. Keep entries under 50 lines.

---

# [Short Description of Pattern]

**Status:** active | archived | superseded-by-skill-name

**Agent:** [Tier X - Model Name]

**Date:** YYYY-MM-DD

**Category:** [Pattern type: testing | resource loading | scene setup | data flow | etc.]

**Context:** [When this pattern applies]

---

## Problem This Pattern Solves

[What challenge or task does this pattern address?]

Example:
> Loading NPC resources dynamically in scenes without hardcoding paths or causing resource load failures.

---

## The Pattern

[Step-by-step description of the successful approach]

Example:
1. Define resource schema in `npc_resource.gd` with clear property names
2. Create .tres files following SCHEMA.md exactly
3. Load resources using ResourceLoader with path verification first
4. Handle load failures gracefully with fallback default values
5. Validate loaded resource has expected properties before use

---

## Code Example (if applicable)

```gdscript
# Example code showing the pattern
var resource_path = "res://shared/resources/npcs/%s.tres" % npc_name

# Verify path exists first
if not ResourceLoader.exists(resource_path):
    push_error("NPC resource not found: %s" % resource_path)
    return null

# Load with error handling
var npc_resource = ResourceLoader.load(resource_path)
if not npc_resource:
    push_error("Failed to load NPC resource: %s" % resource_path)
    return null

# Validate schema
if not npc_resource.has("id") or not npc_resource.has("display_name"):
    push_error("NPC resource missing required properties: %s" % resource_path)
    return null

return npc_resource
```

---

## When to Use This Pattern

[Situations where this pattern is appropriate]

Example:
- Loading any .tres resource files dynamically
- Godot Phase 3 scene setup with NPC/item resources
- Any resource loading where schema compliance matters

---

## When NOT to Use This Pattern

[Situations where this pattern doesn't apply or other approaches are better]

Example:
- Static resources that can be preloaded (@preload or load in _ready)
- Simple data structures that don't need resource files
- Temporary test data that doesn't follow schema

---

## Related Files

- [file:line references]

Example:
- `game/shared/scripts/npc_resource.gd:1` - resource class definition
- `game/shared/resources/npcs/hermes.tres:1` - example resource file
- `game/overworld/scripts/npc_spawner.gd:34` - pattern in use

---

## Success Metrics

[How to know this pattern worked]

Example:
- All NPC resources load without errors
- Tests pass that verify resource loading
- No "Resource not found" errors in console
- Schema validation catches mismatches early

---

## Skill Proposal Check

**Could this pattern become a skill?**
- [ ] Yes - pattern used in 3+ places or solves recurring problem
- [ ] No - too specific or one-off solution

**If yes:** Consider invoking `/skill skill-creator` to capture this as a reusable skill.

**If pattern captured in skill:** Update status to `superseded-by-skill-name`

---

## After Creating This Entry

1. Update `.claude/learnings/INDEX.md` with this entry
2. Add to patterns category
3. Check if similar patterns exist (consolidation opportunity)
4. Consider if skill should be created
