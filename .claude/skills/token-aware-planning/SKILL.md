---
name: token-aware-planning
description: Match Claude model to task type for optimal token efficiency. Before starting new tasks, detect current model (Opus/Sonnet) and guide appropriate work division - Opus excels at strategic planning, architecture, and clarification (token-efficient); Sonnet excels at execution, code writing, and large edits (heavy lifting). Triggers when starting new implementation tasks. NOT for ChatGPT Codex.
---

# Token-Aware Planning: Model-Appropriate Task Routing

Match the Claude model to the appropriate type of work for optimal token efficiency and effectiveness.

## Core Insight: Right Model for Right Work

- **Opus 4.5**: Strategic planning, architecture design, requirement clarification through Q&A
  - Token-efficient activities (mostly reasoning and conversation, minimal file operations)
  - Best at high-level thinking and design decisions
  - Expensive for execution (thinking tokens + extensive context)

- **Sonnet 4.5**: Code execution, file editing, implementing plans
  - Heavy lifting: copying files, making large edits, writing many lines of code
  - Cost-effective for execution work
  - Less optimal for complex strategic planning

## When to Use

**Trigger when**:
1. User requests a NEW implementation task (not continuing existing work)
2. Task requires implementation, architecture decisions, or significant work
3. Working with Claude (any environment) - NOT ChatGPT Codex

**Do NOT trigger when**:
- Using ChatGPT Codex
- Continuing an already planned and in-progress task
- Task is trivial (single small edit, simple question)

## Workflow

### 1. Detect Current Model and Task Phase

Identify:
- Current model: `claude-opus-4-5-*` or `claude-sonnet-4-5-*`
- Task phase: Planning (no clear plan exists) vs Execution (plan exists or is straightforward)
- Task complexity: Simple vs Complex

### 2. Assess Model-Task Fit

**Opus doing execution work** → Suggest Sonnet would be more cost-effective
**Sonnet starting complex task without plan** → Suggest Opus for planning first
**Model matches task phase** → Proceed with appropriate approach

### 3. Present Model-Appropriate Options

Based on current model and task:

#### If on Opus (Planning-Optimized)

Offer to:
1. **High-level strategic planning** (token-efficient)
   - Create architectural plan
   - Identify key decisions and trade-offs
   - Design approach through Q&A with user
   - Clarify requirements and constraints
   - Output: Clear plan for Sonnet to execute

2. **Quick plan + switch to Sonnet** (balanced)
   - Create basic plan
   - User switches to Sonnet for execution

3. **Execute immediately** (token-expensive but thorough)
   - Opus does both planning AND execution
   - Most expensive option
   - Best when: task needs continuous strategic thinking throughout

#### If on Sonnet (Execution-Optimized)

Offer to:
1. **Switch to Opus for planning first** (recommended for complex tasks)
   - Opus creates strategic plan through Q&A
   - Return to Sonnet for execution
   - Most cost-effective for complex work

2. **Quick plan then execute** (moderate)
   - Sonnet creates basic plan
   - Proceeds with execution
   - Good for moderately complex tasks

3. **Execute immediately** (simple tasks only)
   - Skip planning, implement directly
   - Best when: task is straightforward with clear requirements

## Example Workflows

### Example 1: Complex Feature on Opus

**User** (on Opus 4.5): "Add user authentication system to the app"

**Response**:
```
Currently using: claude-opus-4-5-20251101
This is a complex implementation task. Opus excels at strategic planning and design.

I can approach this three ways:

**Option A - Strategic Planning on Opus, Execution on Sonnet** (RECOMMENDED)
- I'll create a high-level architecture plan through Q&A with you
- Design: auth flow, token management, security patterns, database schema
- Clarify requirements: OAuth vs JWT? Session vs token-based?
- Output: Comprehensive plan for Sonnet to execute
- Token cost: LOW (mostly conversation, minimal file reading)
- Then you switch to Sonnet to implement the plan

**Option B - Quick Plan + Switch to Sonnet**
- I'll create a basic authentication plan
- You switch to Sonnet for implementation
- Token cost: VERY LOW

**Option C - Full Implementation on Opus**
- Opus does both planning and execution
- Token cost: VERY HIGH (10%+ of weekly budget possible)
- Use only if you want Opus's strategic thinking throughout execution

Which approach would you prefer?
```

### Example 2: Complex Feature on Sonnet

**User** (on Sonnet 4.5): "Add user authentication system to the app"

**Response**:
```
Currently using: claude-sonnet-4-5-20250929
This is a complex implementation task that would benefit from strategic planning.

I can approach this three ways:

**Option A - Switch to Opus for Planning First** (RECOMMENDED)
- Opus excels at architecture and strategic planning
- Creates comprehensive plan through Q&A (token-efficient on Opus)
- Then return to Sonnet for implementation (my strength)
- Total token cost: MODERATE (planning on Opus is cheap)
- Best division of labor between models

**Option B - I Create Plan Then Execute**
- I'll create a basic plan, then implement
- Sonnet can handle planning, just not as optimally as Opus
- Token cost: MODERATE
- Good if you want to stay on one model

**Option C - Execute Immediately**
- I'll implement authentication directly
- Token cost: MODERATE-HIGH (may need exploration and iterations)
- Risky for complex features without planning

Which approach would you prefer?
```

### Example 3: Simple Task on Opus

**User** (on Opus 4.5): "Fix the typo in README.md line 42"

**Response**:
```
Currently using: claude-opus-4-5-20251101

This is a simple task. For straightforward edits like this, Sonnet would be more cost-effective (fraction of Opus cost).

However, since you're already on Opus and this is quick, I can handle it immediately if you'd like, or you can switch to Sonnet.

Prefer to:
- Execute now on Opus (quick but uses premium model)
- Switch to Sonnet (more cost-effective)
```

### Example 4: Execution Phase on Opus

**User** (on Opus, has existing plan): "Implement the authentication system we planned"

**Response**:
```
Currently using: claude-opus-4-5-20251101

I notice we're in the execution phase (implementing an existing plan). Sonnet would be significantly more cost-effective for execution - Opus's strategic thinking advantage doesn't apply when following a plan.

Recommend switching to Sonnet for:
- Writing code
- Making large file edits
- Following the established plan

Sonnet costs a fraction of Opus tokens for execution work.

Would you like to switch to Sonnet, or proceed on Opus?
```

## Model-Task Matrix

| Task Type | Opus | Sonnet |
|-----------|------|--------|
| Strategic planning | ✅ EXCELLENT (token-efficient) | ⚠️ OK (not optimal) |
| Architecture design | ✅ EXCELLENT (token-efficient) | ⚠️ OK (not optimal) |
| Requirement clarification | ✅ EXCELLENT (token-efficient) | ✅ GOOD |
| Code implementation | ❌ EXPENSIVE (thinking tokens) | ✅ EXCELLENT (cost-effective) |
| Large file edits | ❌ EXPENSIVE | ✅ EXCELLENT |
| Following existing plan | ❌ EXPENSIVE (unnecessary) | ✅ EXCELLENT |
| Simple quick fixes | ⚠️ OK (if already on Opus) | ✅ BETTER (more cost-effective) |

## Token Cost Awareness

### Opus 4.5 Token Costs

High token usage from:
1. **Thinking tokens**: Extended internal reasoning (not visible to user)
2. **Execution work**: Reading many files, making many edits
3. **Can burn 10% of weekly budget in minutes** on intensive implementation tasks

Token-efficient Opus activities:
1. **Strategic conversation**: Q&A, clarification, design discussion
2. **Planning documents**: Creating plans (writing, not reading extensively)
3. **Architecture decisions**: Reasoning about trade-offs (minimal file operations)

### Sonnet 4.5 Token Costs

Moderate token usage:
1. No thinking tokens (or minimal if thinking enabled)
2. Cost-effective for file operations and code writing
3. Can handle extensive implementation work within reasonable token budget

## Notes

- This skill applies to **Claude only** (not ChatGPT Codex)
- Opus + Sonnet collaboration is most cost-effective for complex work
- Simple tasks: Just use Sonnet
- Complex tasks: Opus plans, Sonnet executes
- User can always override and proceed on current model if preferred
- Token estimates are approximate; actual costs depend on task scope
