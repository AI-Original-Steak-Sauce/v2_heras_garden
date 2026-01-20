---
description: "Test-Driven Development methodology"
---

You are now using the test-driven-development skill from .claude/skills/tdd/SKILL.md

## Core Principle
**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST**

## Red-Green-Refactor Cycle

### RED - Write Failing Test
Write one minimal test showing what should happen.

**Requirements:**
- One behavior per test
- Clear, descriptive name
- Test real code (no mocks unless unavoidable)

### Verify RED - Watch It Fail
**MANDATORY. Never skip.**

Run the test and confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature is missing

### GREEN - Minimal Code
Write the simplest code to pass the test.

**Don't:**
- Add extra features
- Refactor other code
- "Improve" beyond the test

### Verify GREEN - Watch It Pass
**MANDATORY.**

Run the test and confirm:
- Test passes
- Other tests still pass
- No errors or warnings

### REFACTOR - Clean Up
After green only:
- Remove duplication
- Improve names
- Extract helpers
- Keep tests green

## When to Use
- New features
- Bug fixes
- Refactoring
- Behavior changes

## Common Rationalizations to Avoid
- "Too simple to test"
- "I'll test after"
- "Deleting code is wasteful"
- "TDD will slow me down"

## Verification Checklist
- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] All tests pass
- [ ] No errors or warnings
