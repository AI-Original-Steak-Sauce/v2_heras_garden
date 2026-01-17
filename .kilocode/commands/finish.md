---
description: "Comprehensive wrap-up and handoff protocol"
---

You are performing a complete wrap-up from .roo/commands/finish.md

## Steps to Complete:

### 1. Review Work Session
- Modified files: Check git status or recent changes
- Created files: Identify new files added
- Decisions made: Note any architectural or design decisions

### 2. Update ALL Relevant Documentation
- Update `docs/agent-instructions/README.md` index
- Update workflow docs if workflows changed
- Update `docs/execution/DEVELOPMENT_ROADMAP.md` with progress
- Update cross-references in other docs

### 3. Clean Up Temporary Files
- Remove any `.tmp`, `.bak`, or debug files
- Delete test outputs that shouldn't be committed
- Clean up any work-in-progress files

### 4. Create Handoff Document
Create at: `docs/handoff/YYYY-MM-DD_HH-MM-SS_[topic].md`

Include:
- Work Completed (files modified, files created, key decisions)
- Work Remaining (incomplete tasks, known issues, next steps)
- Documentation Updated
- Testing Performed
- Notes for Next Agent

### 5. Final Summary
Provide concise summary of:
- What was accomplished
- What was documented
- What remains (if anything)
- Next steps for next agent

**Key: NOTHING should be left undocumented.**
