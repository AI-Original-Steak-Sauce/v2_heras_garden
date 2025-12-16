# Task Plan Template

## Task: [Task Number and Description]

**Date:** [YYYY-MM-DD]
**Status:** IN PROGRESS

---

### 1. Context Check (Search First)

**Search commands run:**
```bash
grep -r "ClassName" src/
ls src/[relevant_folder]/
```

**Existing tools found:**
- [ ] None found → Proceed with creation
- [ ] Found at: [path] → Will use existing

**Decision:**
- [ ] Creating new (nothing exists)
- [ ] Using existing (fill TODOs in: [path])

---

### 2. Constitution Compliance

**Checks:**
- [ ] Read SCHEMA.md for property names
- [ ] Read CONSTITUTION.md for relevant rules
- [ ] Read DEVELOPMENT_ROADMAP.md template for this task
- [ ] Checked Constants.gd for values

**Using:**
- Property names from SCHEMA.md: [list properties]
- Constants: [list constants used]
- Existing autoloads: [list if applicable]

---

### 3. Implementation Plan

**Steps:**
1. [Specific action]
2. [Specific action]
3. [Specific action]

**Files to create/modify:**
- [ ] [path/to/file.gd]
- [ ] [path/to/scene.tscn]

---

### 4. Validation Checklist

**Pre-commit checks:**
- [ ] File in correct location (src/entities/, src/ui/, etc.)
- [ ] Extends correct base class
- [ ] Property names match SCHEMA.md (verified with grep)
- [ ] No magic numbers (using Constants.*)
- [ ] Matches roadmap template
- [ ] No duplicate systems created

**Commands run:**
```bash
ls -la [file_path]
grep "[property]" [file] && grep "[property]" SCHEMA.md
head -30 [file]
```

---

### 5. Results

**Files created:**
- [path] - [description]

**Files modified:**
- [path] - [what changed]

**Validation results:**
- [ ] All checks passed
- [ ] Issues found: [describe]

**Commit hash:** [git hash after commit]

---

### 6. Completion

**Status:** ✅ COMPLETED / ⚠️ BLOCKED / 🔄 IN PROGRESS

**If blocked:**
- Attempted fixes: [list]
- Current error: [message]
- Question for senior engineer: [question]

**Next task:** [X.X.X - Description]
