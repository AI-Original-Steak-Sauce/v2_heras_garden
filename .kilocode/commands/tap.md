---
description: "Token-aware planning for optimal resource allocation"
---

You are now using the token-aware-planning skill from .claude/skills/tap/SKILL.md

## Model-Task Matching

### 4-Role System for v2_heras_garden

#### 1. Play Tester
**Model:** Codex/Claude Vision
**Use for:** Visual validation, HPV, screenshots, UI checks
**Cost:** Cheapest for visual tasks
**Token efficiency:** High for visual tasks

#### 2. General Engineer
**Model:** MiniMax/Sonnet
**Use for:** Writing code, fixing bugs, creating tests, implementing features
**Cost:** Balanced
**Token efficiency:** Good for most implementation work

#### 3. Admin
**Model:** MiniMax/Sonnet
**Use for:** Organizing docs, maintaining file structure, updating READMEs
**Cost:** Balanced
**Token efficiency:** Prevents documentation debt

#### 4. Senior Reviewer
**Model:** Claude Opus ⚠️
**Use for:** Code review, architectural feedback, complex debugging
**Cost:** Most expensive
**Token efficiency:** Severely limit token use

## Task Classification

### Low Complexity (Use MiniMax/Sonnet)
- Simple bug fixes
- Documentation updates
- Small refactoring
- Routine testing

### Medium Complexity (Use Sonnet)
- Feature implementation
- Moderate refactoring
- Integration work
- Test-driven development

### High Complexity (Use Opus)
- Architectural decisions
- Complex debugging
- Security reviews
- Performance optimization

### Visual Tasks (Use Codex)
- UI/UX validation
- Screenshot testing
- HPV playthroughs
- Visual bug reports

## Cost Optimization Strategies
1. Use appropriate model for task complexity
2. Break complex tasks into smaller steps
3. Cache context when possible
4. Limit Opus usage to reviews only
