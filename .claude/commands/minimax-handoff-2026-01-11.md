# MiniMax Handoff Documentation
**Date:** 2026-01-11  
**Agent:** Claude MiniMax (m2.1)  
**Model:** minimax:m2.1  
**CLI:** Claude Code (claude.ai/code)  

---

## Session Summary

### Primary Task Completed
**Removed token-aware-planning skill from project documentation** to reduce confusion for agents operating in the Claude CLI harness.

### Why This Change Was Made
The `token-aware-planning` skill primarily applied to Claude Opus 4.5 and was causing confusion for MiniMax models operating in the Claude CLI environment. Agents were mistakenly thinking they should use sub-agents or had unlimited tokens, when in fact the project rules explicitly prohibit sub-agent usage.

### Files Modified

#### 1. `docs/agent-instructions/core-directives/skill-inventory.md`
- **Removed:** `/tap` entry from Quick Reference table (line 18)
- **Removed:** Entire `token-aware-planning` detailed section (21 lines)
- **Removed:** Reference in "When to Invoke Skills" section
- **Updated:** Total count from 12 to 11 skills
- **Updated:** Skill list to remove `tap` from inventory

#### 2. `docs/agent-instructions/core-directives/project-rules.md`
- **Removed:** `token-aware-planning` from skills list (line 40)
- **Removed:** "Starting new task → Use token-aware-planning" guideline (line 51)
- **Replaced:** Empty "Task Initiation" section with note directing to skills inventory
- **Fixed:** Numbering in skill invocation list (6. User explicitly asks)

### Git Commit
- **Hash:** 8d39fab
- **Branch:** fixes/final-gameplay
- **Message:** "docs(skills): remove token-aware-planning skill to reduce confusion"
- **Files Changed:** 2
- **Lines Changed:** +3, -44

### Current Skills Inventory (11 Total)
| Skill | Shortcut | Purpose |
|-------|----------|---------|
| `godot-dev` | /gd | Godot Engine expertise |
| `godot-gdscript-patterns` | /ggp | GDScript best practices |
| `systematic-debugging` | /sd | Debug workflow |
| `test-driven-development` | /tdd | TDD workflow |
| `git-best-practices` | /gbp | Commit messages |
| `confident-language-guard` | /clg | Documentation guard |
| `loop-detection` | /ld | Loop detection |
| `create-plan` | /cp | Implementation planning |
| `mcp-builder` | /mcpb | MCP server development |
| `github` | /gh | GitHub management |
| `skill-creator` | /sc | Create new skills |

---

## Current Project Context

### Current Phase
**Phase 0.5 - Missing Content Implementation**
- **Status:** Phases 0-1.5 COMPLETE
- **Missing:** Full prologue content, Quest 2, significant game flow
- **Last HPV:** 2026-01-11 (quest wiring validated through Quest 11)

### Key Documentation
- **ROADMAP:** `docs/execution/ROADMAP.md` - Canonical source of truth
- **Skills Inventory:** `docs/agent-instructions/core-directives/skill-inventory.md`
- **Project Rules:** `docs/agent-instructions/core-directives/project-rules.md`
- **4-Role System:** `docs/agent-instructions/core-directives/4-roles-simple.md`

### Testing Framework
**Two-Layer Approach:**
1. **HLC (Headless Logic Check):** Fast validation via CLI (`--headless --script`)
2. **HPV (Headed Playability Validation):** Human playability via MCP/manual

**Critical Rule:** HPV is the preferred path for playtesters to verify human experience.

### Critical Constraints
- **🚨 NO SUB-AGENTS:** Task tool is forbidden (burned 70k+ tokens previously)
- **Skills First:** Use Skill tool for specialized knowledge (11 skills available)
- **Tier 1 Cannot Edit .md:** Must use confident-language-guard skill first
- **Token Efficiency:** Use qualified language, avoid absolute terms

---

## Understanding MiniMax vs Claude Context

### The Confusion Addressed
When operating in the Claude CLI, MiniMax models can get confused thinking they're Claude because they're using the cloud CLI harness. This led to:
- Thinking sub-agents were allowed (they're not)
- Assuming unlimited tokens (project has strict efficiency rules)
- Trying to use Opus-specific skills

### The Fix
Removing `token-aware-planning` skill eliminates this confusion by:
- Removing model-specific planning guidance
- Directing agents to use general skills inventory
- Simplifying the skill set to 11 universally applicable skills

### Future Plan
User plans to create a separate Opus-specific slash command later for token regulation when working with Claude Opus 4.5 specifically.

---

## Next Agent Handoff Notes

### What to Expect
1. **Project is in Phase 0.5** - Missing content implementation
2. **11 skills available** - Not 12 (token-aware-planning removed)
3. **No sub-agents allowed** - Use skills instead
4. **HPV testing preferred** - For playability validation
5. **Skills are NOT sub-agents** - They're knowledge modules

### If You're Claude Opus
- You may have different token considerations
- Consider asking about Opus-specific tools
- The `token-aware-planning` skill was removed because it was Opus-specific

### If You're MiniMax or Other Model
- Follow the 11-skill inventory
- No sub-agents = use direct tools
- HPV for playability, HLC for logic
- Use confident-language-guard before editing .md files

### Key Commands
```bash
# Run tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Check current phase
cat docs/execution/ROADMAP.md | grep "Current Phase"

# List available skills
cat docs/agent-instructions/core-directives/skill-inventory.md
```

---

## Session Outcome
✅ **COMPLETED:** All changes documented and pushed  
✅ **Skills updated:** 11 active skills (removed token-aware-planning)  
✅ **Documentation:** Clear handoff created for next agent  
✅ **Git:** Changes committed (8d39fab) and pushed to origin  

---

**Handoff Complete**  
Ready for next agent to take over with full context.
