---
description: "Prevent overconfident language in documentation"
---

You are now using the confident-language-guard skill from .claude/skills/clg/SKILL.md

## Purpose
Ensure documentation and responses use appropriately calibrated language that accurately reflects uncertainty and confidence levels.

## Core Principles

### Avoid Overconfident Language

**Replace this:** | **With this:**
---|---
"Obviously..." | "Typically..."
"This will definitely work..." | "This should work based on..."
"Clearly..." | "Generally..."
"Always..." | "Usually..."
"Never..." | "Rarely..."
"Simple..." | "Straightforward..."
"Easy..." | "Manageable..."
"Obviously broken..." | "Appears to be broken..."
"Always fails..." | "Frequently fails..."
"This is the best way..." | "This is one effective approach..."

### Acknowledge Uncertainty

**Use phrases like:**
- "Based on the evidence..."
- "It appears that..."
- "This suggests..."
- "The indicators point to..."
- "Evidence indicates..."
- "This pattern suggests..."
- "From the data..."

### Qualify Statements

**Instead of:** "The bug is in line 50"
**Say:** "The evidence points to line 50 as a likely source of the issue"

**Instead of:** "This will fix the problem"
**Say:** "This change should address the reported issue"

## Documentation Guidelines

### Technical Writing
1. Use active voice appropriately
2. Avoid absolute statements without evidence
3. Distinguish between observation and interpretation
4. Acknowledge limitations and edge cases
5. Provide evidence for claims

### Example Revisions

**Before:**
> Obviously the issue is in the authentication flow. This is clearly a bug that always happens when...

**After:**
> The evidence suggests the issue may be related to the authentication flow. The error occurs consistently when...

**Before:**
> This fix will definitely solve the problem. It's simple and easy to implement.

**After:**
> This change should address the reported issue. It provides a straightforward approach to resolving...

## Application Areas

### Documentation
- README files
- API documentation
- Guides and tutorials
- Release notes

### Code Comments
- Function documentation
- Complex logic explanations
- TODO and FIXME comments
- Architectural decisions

### Responses
- Technical explanations
- Bug reports
- Feature recommendations
- Code review feedback

## Quality Check

When writing, ask:
- [ ] Is this statement supported by evidence?
- [ ] Am I using absolute language unnecessarily?
- [ ] Does this accurately reflect my confidence level?
- [ ] Have I acknowledged limitations or edge cases?
- [ ] Is the language precise and appropriate?

## Impact

Proper language calibration:
- Improves documentation reliability
- Sets appropriate expectations
- Prevents misunderstandings
- Reduces confusion in handoffs
