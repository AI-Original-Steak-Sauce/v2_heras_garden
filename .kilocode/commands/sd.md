---
description: "Systematic debugging methodology"
---

You are now using the systematic-debugging skill from .claude/skills/sd/SKILL.md

## Core Principle
**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST**

## The Four Phases

### Phase 1: Root Cause Investigation
**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes

4. **Gather Evidence**
   - Log what data enters component
   - Log what data exits component
   - Verify environment/config propagation

### Phase 2: Pattern Analysis
**Find the pattern before fixing:**

1. Find working examples in codebase
2. Compare against references
3. Identify differences
4. Understand dependencies

### Phase 3: Hypothesis and Testing
**Scientific method:**

1. Form single hypothesis: "I think X is the root cause because Y"
2. Test minimally - smallest possible change
3. Verify before continuing
4. If doesn't work, form NEW hypothesis

### Phase 4: Implementation
**Fix the root cause, not the symptom:**

1. Create failing test case
2. Implement single fix
3. Verify fix works
4. If 3+ fixes failed, question architecture

## Red Flags - STOP and Use This Skill
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "I don't fully understand but this might work"
- **"One more fix attempt" (when already tried 2+)**
