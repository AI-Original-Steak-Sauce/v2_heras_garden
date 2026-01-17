---
description: "Create detailed implementation plans"
---

You are now using the create-plan skill from .claude/skills/cp/create-plan.md

## Planning Process

### Phase 1: Research
**Critical:** Thoroughly investigate the codebase before planning.

Use direct tools:
- Glob: Find files matching patterns
- Grep: Search for code patterns
- Read: Read files completely

### Phase 2: Present Understanding
Before any design work, present findings:
1. Codebase analysis with file:line references
2. Current patterns and conventions
3. Integration points and dependencies
4. Clarifying questions

### Phase 3: Research User Corrections
**Critical:** Do not accept user corrections at face value.

When user provides corrections:
1. Verify claims through code investigation
2. Cross-reference with discovered patterns
3. Resolve conflicts

### Phase 4: Design Options
Present design approaches with trade-offs:

**Option A:** Description, Pros, Cons, Fits pattern
**Option B:** Description, Pros, Cons, Fits pattern

**Recommendation:** Preferred option with rationale

### Phase 5: Phase Structure Review
Present proposed phases before detailed planning:

```
Proposed Implementation Phases:

Phase 1: [Name] - [Brief description]
Phase 2: [Name] - [Brief description]
Phase 3: [Name] - [Brief description]

Does this structure make sense?
```

### Phase 6: Write the Plan
write_to_file implementation plan to `docs/plans/YYYY-MM-DD-description.md`

Include:
- Overview (2-3 sentence summary)
- Context (background, motivation)
- Design Decision (chosen approach)
- Implementation Phases (detailed tasks)
- Dependencies
- Risks and Mitigations

## Critical Guidelines
- Be thorough - read entire files
- Be interactive - get buy-in at each step
- Be skeptical - research claims before accepting
- No unresolved questions in plans
