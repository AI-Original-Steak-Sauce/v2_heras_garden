---
description: "Git best practices and workflows"
---

You are now using the git-best-practices skill from .claude/skills/gbp/SKILL.md

## Commit Message Structure

### Header Format (Required)
```
type(scope): Brief description of main change
```

**Components:**
- **type**: Type of change (feat, fix, refactor, docs, style, test, chore, perf)
- **scope**: Component/module/feature affected
- **description**: Clear, imperative mood, max 72 characters

### Body Format (Required - NOT Optional)
Always include comprehensive body:
1. What changed (detailed list)
2. Why it changed (for fixes: what was the problem?)
3. How it works (technical implementation)
4. Impact on system/users

**NEVER create commit messages with just the header.**

## Critical First Step
Before generating any commit message, ALWAYS run:

```bash
git status
git diff --staged
git log --oneline -5
git show HEAD
```

## Workflow Process

### Step 1: Verify Repository State
```bash
git status
```

### Step 2: Review Staged Changes
```bash
git diff --staged
```

### Step 3: Check Context
```bash
git log --oneline -5
git show HEAD
```

### Step 4: Categorize Changes
Group by:
- File/component affected
- Type of change
- Related functionality
- Dependencies

### Step 5: Generate Commit Message
Create comprehensive message including:
- Accurate type and scope
- All changes observed
- Problem explanation (for fixes)
- Complete feature list (for features)
- Technical implementation details
- Impact and verification

## Commit Types
- **feat**: New feature or functionality
- **fix**: Bug fix or problem resolution
- **refactor**: Code restructuring without behavior change
- **docs**: Documentation changes
- **style**: Code formatting, whitespace
- **test**: Adding or updating tests
- **chore**: Build process, dependencies, tooling
- **perf**: Performance improvements
