---
description: "Create new skills to extend agent capabilities"
---

You are now using the skill-creator skill from .claude/skills/sc/SKILL.md

## Skill Structure

### Required Files
1. **SKILL.md** - Main skill definition
2. **Reference files** - Supporting documentation (optional)

### SKILL.md Format
```yaml
---
name: skill-name
description: "Brief description of what the skill does"
allowed-tools: [Tool1, Tool2, ...]
---

# Skill Name

## Overview
[Description of what the skill does]

## When to Use
- Use case 1
- Use case 2
- Use case 3

## Core Principles
**Core Principle:** [Key principle]

## Implementation
[Detailed implementation guide]

## Examples
### Example 1
[Code example]

### Example 2
[Code example]
```

## Skill Creation Process

### Phase 1: Define Skill Requirements
1. Identify the gap in existing skills
2. Define the skill's purpose and scope
3. Identify required tools and permissions
4. Document the skill's methodology

### Phase 2: Create Skill Structure
1. Create directory: `.claude/skills/<skill-code>/`
2. Create `SKILL.md` with frontmatter
3. Add supporting documentation if needed
4. Test skill activation

### Phase 3: Test and Refine
1. Activate skill via slash command
2. Verify it loads correctly
3. Test with actual tasks
4. Refine based on feedback

## Skill Naming Convention

### Short Codes (Preferred)
- Use 2-4 character codes
- Descriptive of the skill
- Easy to remember
- Examples: `gd`, `tdd`, `sd`, `cp`, `gbp`

### Full Names (Fallback)
- kebab-case
- Descriptive
- Examples: `git-best-practices`, `systematic-debugging`

## Integration Points

### With Slash Commands
Create command file: `.kilocode/commands/<skill-code>.md`

```yaml
---
description: "Skill description"
---

You are now using the [skill-name] skill from .claude/skills/<skill-code>/SKILL.md

[Skill implementation]
```

### With Permissions
Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "Skill(skill-code)",
      "Skill(skill-code:*)"
    ]
  }
}
```

## Quality Checklist

- [ ] Clear, focused purpose
- [ ] Comprehensive documentation
- [ ] Appropriate tool access
- [ ] Well-defined methodology
- [ ] Tested activation
- [ ] Consistent naming
