---
description: "Clarify task requirements and context before proceeding"
---

You are following the clarify protocol from .roo/commands/clarify.md

## Before Proceeding:

### 1. Understand the Task
- What exactly needs to be done?
- What files will be affected?
- What are the success criteria?
- Are there constraints (time, tech, scope)?

### 2. Review Existing Context
**Read Key Files:**
- `docs/execution/DEVELOPMENT_ROADMAP.md` - Current phase and priorities
- `docs/agent-instructions/README.md` - Agent instructions index
- Any relevant implementation guides
- Related code/files you'll modify

**Use search_files to find:**
- References to the feature/system you're working on
- Similar implementations to follow as pattern
- Documentation that needs updating

### 3. Identify Documentation Touchpoints
Before starting, identify ALL places that will need updates:
- If modifying code: Update relevant `.gd` files, update tests
- If modifying docs: Update index files and workflow docs
- If creating new feature: Document in phase guide, update ROADMAP.md

### 4. Ask Clarifying Questions (if needed)
Use ask_followup_question to ask about:
- Priority between competing tasks
- Existing patterns to follow
- Documentation requirements
- Scope boundaries

### 5. Verify Understanding
Before proceeding, confirm:
- [ ] I know what files I'll modify
- [ ] I know what docs need updating
- [ ] I understand the existing patterns
- [ ] I have clear success criteria
- [ ] I know where to document changes
