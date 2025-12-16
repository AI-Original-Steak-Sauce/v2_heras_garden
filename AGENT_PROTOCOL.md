# ANTIGRAVITY AGENT PROTOCOL

**Version:** 1.0
**Status:** ACTIVE
**Purpose:** Prevent context drift, ensure systematic development

---

## 🔄 MANDATORY WORKFLOW (Every Task)

### STEP 1: SEARCH FIRST (Prevent Duplication)
Before writing ANY new script or system:

```bash
# Search for existing implementations
grep -r "class_name" src/
grep -r "extends Node" src/autoloads/
ls src/entities/ src/ui/ src/core/
```

**CHECK:**
- Does this autoload already exist? (GameState, AudioController, SaveController, SceneManager)
- Does this script stub already exist? (player.gd, farm_plot.gd, dialogue_box.gd, main_menu.gd)
- Does this resource type already exist? (CropData, ItemData, DialogueData, NPCData)

**IF FOUND:** Use existing. Fill in TODOs. Do NOT create duplicate.
**IF NOT FOUND:** Proceed to Step 2.

---

### STEP 2: PLAN (Create Audit Trail)

Create `reports/task_plan.md` with:

```markdown
## Task: [Brief description]

### Context Check
- Searched: `grep -r "ClassName" src/`
- Existing tools found: [list paths OR "none"]
- Using existing: [Yes/No + which files]

### Constitution Check
- Uses SCHEMA.md property names: [Yes/No]
- Follows CONSTITUTION.md rules: [Yes/No]
- Matches DEVELOPMENT_ROADMAP.md template: [Yes/No]

### Implementation Plan
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Validation Plan
- [ ] Files created in correct locations
- [ ] Property names match SCHEMA.md
- [ ] Code matches roadmap template
- [ ] No duplicate systems created
```

---

### STEP 3: IMPLEMENT (Follow Template)

- Open DEVELOPMENT_ROADMAP.md to current task section
- Copy code template EXACTLY
- Fill in TODOs with actual implementation
- Use Constants.* instead of magic numbers
- Check SCHEMA.md for exact property names

---

### STEP 4: VALIDATE (Self-Check)

Run validation checklist:

```bash
# 1. File structure check
ls -la [created_file_path]

# 2. Property name validation
grep "property_name" [file] && grep "property_name" SCHEMA.md

# 3. Template match check
diff [your_file] [roadmap_template_section] # Should be similar

# 4. Syntax check
head -50 [your_file]  # Visual inspection
```

**Validation Checklist:**
- [ ] File in correct folder (src/entities/, src/ui/, etc.)
- [ ] Extends correct base class
- [ ] Property names match SCHEMA.md EXACTLY
- [ ] No magic numbers (uses Constants.*)
- [ ] Matches roadmap template structure

**IF ANY FAIL:**
1. Review error
2. Check SCHEMA.md / CONSTITUTION.md / DEVELOPMENT_ROADMAP.md
3. Fix issue
4. Re-validate
5. If stuck after 2 attempts → Document issue and ask senior engineer (Claude)

---

### STEP 5: COMMIT (Document Work)

```bash
git add [files]
git commit -m "type: brief description

- What was implemented
- What was validated
- What tests passed

Tested: [how you validated it works]"

git status  # Verify clean
```

Update `reports/task_plan.md` → Add "✅ COMPLETED" at top

---

## 🛑 HARD RULES (Non-Negotiable)

### Rule 1: Search Before Creating
**NEVER create new autoload/system without:**
```bash
grep -r "class_name SystemName" src/
ls src/autoloads/ | grep -i "system"
```

**WHY:** Prevents duplicate AudioController, duplicate GameState, etc.

### Rule 2: Use Existing Stubs
**IF a script stub exists with TODOs** → Fill in TODOs
**DO NOT:** Create new file with different structure

**Example:**
- ✅ Open `src/entities/player.gd` → Fill TODO markers
- ❌ Create `src/player/character.gd` (ignores existing stub)

### Rule 3: SCHEMA.md is Law
**Property names MUST match SCHEMA.md EXACTLY**

```bash
# Before using property:
grep "property_name" SCHEMA.md  # Get exact name
# Then use EXACT name in code
```

**Example:**
- ✅ `crop_data.growth_stages` (matches SCHEMA.md)
- ❌ `crop_data.sprites` (hallucinated, doesn't exist)

### Rule 4: One Task at a Time
**Implement ONE subsection** → Validate → Commit → Report → Wait for approval

**DO NOT:**
- Implement 1.1.1 AND 1.1.2 together
- Create multiple files in one session
- Skip validation to "save time"

### Rule 5: Template Adherence
**IF DEVELOPMENT_ROADMAP.md has code template** → Use it EXACTLY

**DO NOT:**
- Add features beyond template
- "Improve" or "optimize" unless requested
- Change function signatures
- Skip sections of template

---

## 🔍 COMMON FAILURES & FIXES

### Failure: Created duplicate system
**Prevention:**
```bash
grep -r "class_name AudioManager" src/
# Found? Use it. Not found? Then create.
```

### Failure: Wrong property names
**Prevention:**
```bash
# Always check SCHEMA.md first:
grep -A 10 "class_name CropData" SCHEMA.md
# Then use EXACT property names shown
```

### Failure: Ignored existing stub
**Prevention:**
```bash
ls src/entities/player.gd  # Exists? Fill TODOs, don't create new file
```

### Failure: Skipped validation
**Prevention:** Make validation PART of task (not optional)

---

## 📊 SUCCESS METRICS

**You are successful when:**
- ✅ `reports/task_plan.md` exists for task
- ✅ Context check shows you searched first
- ✅ No duplicate systems created
- ✅ Property names match SCHEMA.md (verified with grep)
- ✅ Code matches roadmap template
- ✅ Validation checklist all checked
- ✅ Git commit has clear message
- ✅ Senior engineer can audit via reports/ folder

---

## 🆘 WHEN TO ASK FOR HELP

**Try to self-fix first (max 2 attempts):**
1. Read error message
2. Check SCHEMA.md / CONSTITUTION.md / DEVELOPMENT_ROADMAP.md
3. Fix and retry

**Ask senior engineer (Claude) when:**
- Error persists after 2 fix attempts
- SCHEMA.md missing property you need
- DEVELOPMENT_ROADMAP.md template unclear
- Conflicting instructions found
- Unsure which existing tool to use

**Format:**
```markdown
## BLOCKED: [Issue]

**What I tried:**
1. [Attempt 1]
2. [Attempt 2]

**Error:** [Exact error message]

**Context:** Task [X.X.X], trying to [action]

**Question:** [Specific question]
```

---

## 📁 ARTIFACT STRUCTURE

```
reports/
├── task_plan.md          # Current task plan
├── validation_log.txt    # Validation results
└── completed/            # Archive of finished plans
    ├── task_1.1.1.md
    ├── task_1.1.2.md
    └── ...
```

**After completing task:** Move `task_plan.md` → `completed/task_X.X.X.md`

---

## 🎯 QUICK REFERENCE

**Before writing code:**
```bash
grep -r "SystemName" src/  # Check exists
cat SCHEMA.md | grep -A 5 "property"  # Get exact names
ls src/entities/  # Check for existing stubs
```

**During implementation:**
- Open DEVELOPMENT_ROADMAP.md
- Find current task section
- Copy template code
- Fill in TODOs only

**After implementation:**
- Run validation checklist
- Create task_plan.md
- Commit with clear message
- Report completion

---

**Remember:** Systematic > Fast. Following this protocol prevents rework.
