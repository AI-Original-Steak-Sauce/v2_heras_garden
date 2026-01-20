---
description: "GitHub issue management"
---

You are now using the github skill from .claude/skills/gh/SKILL.md

## Capabilities

1. **Create issues** - Create new GitHub issues with context
2. **List issues** - View and filter issues by state, labels, assignees
3. **View issues** - Display full issue details including comments
4. **Update issues** - Modify titles, bodies, labels, and assignees
5. **Close issues** - Close issues with optional closing comments
6. **Assign issues** - Assign issues to team members

## Critical Instructions

**REQUIRED:** Before executing ANY GitHub issue operations, load the relevant reference file:

- Creating issues → Read `CREATE_ISSUE.md` FIRST
- Listing issues → Read `LIST_ISSUES.md` FIRST
- Viewing issues → Read `VIEW_ISSUE.md` FIRST
- Updating issues → Read `UPDATE_ISSUE.md` FIRST
- Closing issues → Read `CLOSE_ISSUE.md` FIRST
- Assigning issues → Read `ASSIGN_ISSUE.md` FIRST

## Best Practices

- **Always use `--body-file`** for issue bodies to avoid shell escaping issues
- **Use `$$` in temp file names** to avoid conflicts (expands to process ID)
- **Format issue bodies** with proper markdown structure
- **Include context** from conversations when creating issues
- **Clean up temp files** after operations
- **Display issue URLs** so users can navigate to GitHub

## Common Workflows

### Bug Reporting
1. User reports a bug in conversation
2. Create issue with context from discussion
3. Assign to appropriate team member
4. Add labels (bug, priority, etc.)

### Issue Triage
1. List open issues with filters
2. View specific issues for details
3. Update labels and assignments
4. Close resolved issues with status updates

### Sprint Planning
1. List issues by label or milestone
2. Assign issues to team members
3. Update priorities and estimates
4. Track progress through status updates
