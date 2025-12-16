# ANTIGRAVITY AI - AUDIT & OPERATIONAL GUIDELINES

**Created:** December 16, 2025
**Purpose:** Provide explicit guardrails, tool documentation, and workflow boundaries
**Status:** Phase 0 Complete → Phase 1 Ready to Start

---

## 🔍 PROJECT AUDIT - CURRENT STATE

### ✅ What Has Been Completed (Phase 0)

**Documentation Foundation:**
- ✅ CONSTITUTION.md - Immutable technical rules
- ✅ SCHEMA.md - Data structure definitions (exact property names)
- ✅ DEVELOPMENT_ROADMAP.md - Step-by-step Phase 1 implementation guide
- ✅ PROJECT_SUMMARY.md - Quick reference
- ✅ PROJECT_STATUS.md - Current progress tracker
- ✅ PLAYTESTER_GUIDE.md - Testing instructions for MCP validation
- ✅ Storyline.md - Complete narrative (CIRCE'S GARDEN)
- ✅ PHASE_2_ROADMAP.md - Quest-by-quest story implementation plan
- ✅ ASSET_CHECKLIST.md - Complete asset inventory

**Godot Project Structure:**
- ✅ project.godot - Autoloads pre-registered (GameState, AudioController, SaveController)
- ✅ src/autoloads/game_state.gd - Central state management
- ✅ src/autoloads/audio_controller.gd - Audio system
- ✅ src/autoloads/save_controller.gd - Save/load system
- ✅ src/resources/crop_data.gd - CropData resource class
- ✅ src/resources/item_data.gd - ItemData resource class
- ✅ src/resources/dialogue_data.gd - DialogueData resource class
- ✅ src/resources/npc_data.gd - NPCData resource class
- ✅ resources/crops/TEMPLATE_crop.tres - Example crop data file
- ✅ scenes/ui/main_menu.tscn - Placeholder menu scene
- ✅ scenes/entities/player.tscn - Placeholder player scene (NO SCRIPT YET)
- ✅ scenes/entities/farm_plot.tscn - Placeholder farm plot scene (NO SCRIPT YET)
- ✅ scenes/world.tscn - Placeholder world scene
- ✅ TEST_SCRIPT.gd - Automated Phase 0 validation script

**Git Status:**
- ✅ All Phase 0 work committed and pushed
- ✅ Branch: claude/access-data-bnkZr
- ✅ Working tree: CLEAN

### ❌ What Has NOT Been Implemented Yet

**Phase 1 Tasks (ALL PENDING):**
- ❌ Player movement script (src/entities/player.gd) - **DOES NOT EXIST**
- ❌ Farm plot script (src/entities/farm_plot.gd) - **DOES NOT EXIST**
- ❌ Interaction system - **NOT IMPLEMENTED**
- ❌ Scene transition system - **NOT IMPLEMENTED**
- ❌ Farming state machine - **NOT IMPLEMENTED**
- ❌ Crafting system - **NOT IMPLEMENTED**
- ❌ Dialogue system - **NOT IMPLEMENTED**

**Critical Finding:**
- The placeholder scenes exist but contain **NO FUNCTIONAL SCRIPTS**
- Player scene has NO movement code attached
- Farm plot scene has NO interaction code attached
- This is INTENTIONAL - Phase 1 implementation starts now

### 📊 Project Readiness Assessment

| Category | Status | Notes |
|----------|--------|-------|
| Documentation | ✅ Excellent | Comprehensive roadmap with code templates |
| Structure | ✅ Complete | All folders and autoloads set up |
| Implementation | ⚪ Not Started | Phase 1 tasks are 0% complete |
| Testing Tools | ✅ Available | Godot MCP server ready for use |
| Clarity | ✅ High | Step-by-step instructions provided |

**Verdict:** Project is in PERFECT state to begin Phase 1 implementation.

---

## 🛠️ NEW TOOLS AVAILABLE

### Godot MCP Server

**Configuration:** `.mcp-config.json`
```json
{
  "mcpServers": {
    "godot": {
      "command": "npx",
      "args": ["-y", "godot-mcp-cli"],
      "env": {
        "GODOT_PROJECT_PATH": "C:/Users/Sam/Documents/GitHub/v2_heras_garden",
        "GODOT_EXECUTABLE": "godot"
      },
      "description": "MCP server for Godot Engine integration"
    }
  }
}
```

**Capabilities:**
1. **Open Godot Project**
   - Can launch Godot editor with this project
   - Verify project loads without errors

2. **Run Scenes**
   - Test individual scenes (F6 in Godot)
   - Run full project (F5 in Godot)
   - View console output for errors

3. **Inspect Project**
   - Check scene structure
   - Verify autoload registration
   - View node hierarchies

4. **Validation Testing**
   - Run TEST_SCRIPT.gd to validate Phase 0
   - Check for compilation errors
   - Verify resource classes load correctly

**Usage Guidelines:**
- ✅ DO: Use MCP to test each feature IMMEDIATELY after implementation
- ✅ DO: Run scenes in isolation before integrating
- ✅ DO: Check console for errors after every test
- ❌ DON'T: Assume code works without testing
- ❌ DON'T: Test multiple features at once (isolate problems)

### Testing Strategy with MCP

**After Each Implementation Step:**

1. **Write Code** (follow DEVELOPMENT_ROADMAP.md templates)
2. **Save Files** (commit to git)
3. **Use MCP to Open Godot**
4. **Run Scene** (F6 for current scene, F5 for project)
5. **Check Console** (look for errors, warnings, print statements)
6. **Verify Behavior** (does it match expected outcome?)
7. **Fix Issues** (if any errors found)
8. **Commit** (once working correctly)
9. **Move to Next Step**

**Test Isolation Example:**
```
Task: Implement player movement

Step 1: Write src/entities/player.gd (movement code only)
Step 2: Attach script to scenes/entities/player.tscn
Step 3: MCP: Open Godot
Step 4: MCP: Open scenes/world.tscn
Step 5: MCP: Run scene (F6)
Step 6: MCP: Check console output
Step 7: Test: Press WASD keys, verify player moves
Step 8: If working → Commit with message
Step 9: Move to next task (interaction system)
```

---

## ⚠️ OVERZEALOUS BEHAVIOR PATTERNS (CRITICAL)

### 🚨 Pattern 1: Doing Too Much at Once

**Symptom:** Implementing multiple systems in one go
**Example:**
- ❌ Writing player.gd + farm_plot.gd + dialogue_system.gd in one session
- ❌ Creating all Phase 1 features before testing any

**Why This Fails:**
- When bugs occur, you can't isolate which system caused them
- Testing becomes impossible (too many variables)
- One error cascades into multiple broken features

**Correct Approach:**
- ✅ Implement ONE subsection at a time (e.g., 1.1.1 only)
- ✅ Test that ONE feature in isolation
- ✅ Commit only when that ONE feature works
- ✅ Then move to next subsection

### 🚨 Pattern 2: Skipping Testing

**Symptom:** Writing code without running it
**Example:**
- ❌ "I've written player.gd, farm_plot.gd, and crafting_game.gd. Here's the code!"
- ❌ Not using MCP to verify code actually runs

**Why This Fails:**
- Syntax errors not caught
- Logic errors not caught
- Integration issues not caught
- Delivers broken code to next phase

**Correct Approach:**
- ✅ After EVERY script, use MCP to test it
- ✅ Run the scene and verify expected behavior
- ✅ Check console for errors
- ✅ Fix issues before moving on

### 🚨 Pattern 3: Implementing Beyond Scope

**Symptom:** Adding features not in the roadmap
**Example:**
- ❌ "I added a mini-map system" (not in Phase 1)
- ❌ "I created an achievement system" (not requested)
- ❌ "I optimized the rendering pipeline" (premature optimization)

**Why This Fails:**
- Wastes time on non-essential features
- Increases complexity unnecessarily
- May break existing systems
- Deviates from project plan

**Correct Approach:**
- ✅ Only implement what DEVELOPMENT_ROADMAP.md specifies
- ✅ If you think something is missing, ASK the user first
- ✅ Stay within the boundaries of current phase/subsection
- ✅ Trust the roadmap (it's comprehensive)

### 🚨 Pattern 4: Hallucinating Property Names

**Symptom:** Guessing property names instead of checking SCHEMA.md
**Example:**
- ❌ `crop_data.sprites` (wrong - should be `growth_stages`)
- ❌ `GameState.player_inventory` (wrong - should be `inventory`)
- ❌ `item.item_id` (wrong - should be `id`)

**Why This Fails:**
- Code won't work (property doesn't exist)
- Runtime errors
- Breaks integration with other systems

**Correct Approach:**
- ✅ ALWAYS check SCHEMA.md for exact property names
- ✅ Copy-paste property names from SCHEMA.md
- ✅ When in doubt, read the actual .gd file
- ✅ Never guess - verify

### 🚨 Pattern 5: Ignoring CONSTITUTION.md Rules

**Symptom:** Not following immutable technical rules
**Example:**
- ❌ Using hardcoded `position = Vector2(16, 16)` (should use TILE_SIZE)
- ❌ Referencing autoload before verifying it's registered
- ❌ Creating .tres files before resource class exists

**Why This Fails:**
- Violates project standards
- Causes runtime crashes
- Makes codebase inconsistent
- Repeats V1 failures

**Correct Approach:**
- ✅ Read CONSTITUTION.md before coding
- ✅ Follow every rule strictly
- ✅ Check project.godot for autoload registration
- ✅ Use constants instead of magic numbers

---

## 🔒 STRICT WORKFLOW GUARDRAILS

### Mandatory Workflow (DO NOT DEVIATE)

```
1. Read the current subsection in DEVELOPMENT_ROADMAP.md
2. Verify dependencies are met
3. Implement ONLY that subsection (use provided code template)
4. Test with MCP (run scene, check console)
5. Fix any errors found
6. Commit with provided message template
7. Update PROJECT_STATUS.md (mark subsection complete)
8. Return to step 1 for next subsection
```

**Hard Rules:**
- ❌ **NEVER** implement multiple subsections in one go
- ❌ **NEVER** skip testing after implementation
- ❌ **NEVER** commit untested code
- ❌ **NEVER** move to next subsection with failing tests
- ❌ **NEVER** add features not in the roadmap
- ❌ **NEVER** guess property names (check SCHEMA.md)
- ❌ **NEVER** refactor existing working code unless explicitly requested

### Acceptable Work Increments

**✅ ONE Subsection Per Session:**
```
Session 1: Implement 1.1.1 (Player scene creation)
Test → Commit → Stop

Session 2: Implement 1.1.2 (Player movement script)
Test → Commit → Stop

Session 3: Implement 1.1.3 (Interaction system)
Test → Commit → Stop
```

**❌ NOT Acceptable:**
```
Session 1: Implement 1.1.1, 1.1.2, 1.1.3, 1.2.1 all at once
No testing → Broken code → Cascading errors
```

### Size Limits Per Work Unit

| Work Type | Maximum Scope | Example |
|-----------|---------------|---------|
| Scripts | 1 file | player.gd OR farm_plot.gd (not both) |
| Scenes | 1 scene modification | player.tscn script attachment |
| Features | 1 subsection | 1.1.1 only (not 1.1.x all together) |
| Testing | 1 feature validation | Test player movement (not all movement + farming) |
| Commits | 1 subsection completion | feat: implement player movement |

**Rationale:**
- Small increments = easy to test
- Easy to test = easy to debug
- Easy to debug = less wasted time
- Less wasted time = faster overall progress

---

## 📋 PHASE 1 EXECUTION PLAN

### Current Position
- **Phase:** 0 → 1 Transition
- **Next Task:** 1.1.1 - Player Scene Creation
- **Blocker:** None
- **Ready to Start:** YES

### Recommended First Steps (STRICT ORDER)

#### Step 1: Validate Phase 0 ✅
**Goal:** Confirm foundation is solid before building on it

**Actions:**
1. Use MCP to open Godot project
2. Run TEST_SCRIPT.gd (godot --headless --script TEST_SCRIPT.gd)
3. Verify all 7 tests pass:
   - Autoloads exist
   - Resource classes compile
   - Scenes load without errors
4. Check console for any warnings/errors
5. If all pass → Proceed to Step 2
6. If any fail → Report to user immediately

**Expected Outcome:** All tests pass, no errors

**DON'T:**
- ❌ Skip validation (assume everything works)
- ❌ Start Phase 1 with failing Phase 0 tests

---

#### Step 2: Implement Task 1.1.1 - Player Scene Creation
**Goal:** Prepare player.tscn for movement script

**Read First:**
- DEVELOPMENT_ROADMAP.md lines 95-112 (Task 1.1.1 section)
- CONSTITUTION.md section 7 (Node Path Validation)

**Actions:**
1. Open scenes/entities/player.tscn in Godot editor (MCP)
2. Verify current structure:
   - Root: CharacterBody2D ✓
   - Child: Sprite2D (name: "Sprite") ✓
   - Child: CollisionShape2D (name: "Collision") - **CHECK if shape is set**
   - Child: Camera2D (name: "Camera") ✓
3. If CollisionShape2D has no shape:
   - Add CapsuleShape2D
   - Set radius: 14
   - Set height: 28
4. Verify Camera2D settings:
   - Enabled: true
   - Zoom: (2.0, 2.0)
5. Save scene
6. Test: Use MCP to open scene, verify no errors

**Expected Outcome:**
- Scene structure matches specification
- No errors in console when opening scene
- All nodes named correctly

**Commit Message:**
```
chore: verify and configure player scene structure

- Confirmed CharacterBody2D root node
- Verified Sprite2D, CollisionShape2D, Camera2D children
- Set CapsuleShape2D (radius: 14, height: 28)
- Configured Camera2D zoom (2.0, 2.0)

Tested: Scene loads without errors in Godot editor
```

**DON'T:**
- ❌ Add movement script yet (that's Task 1.1.2)
- ❌ Add interaction zone (that's Task 1.1.3)
- ❌ Modify world.tscn (that's Task 1.2.1)
- ❌ Create any new files

---

#### Step 3: Implement Task 1.1.2 - Player Movement Script
**Goal:** Create functional player movement

**Read First:**
- DEVELOPMENT_ROADMAP.md lines 113-158 (Task 1.1.2 section)
- CONSTITUTION.md section 1 (TILE_SIZE constant - not needed for movement but good to know)
- SCHEMA.md - Player doesn't have a resource class, but check GameState properties if needed

**Actions:**
1. Create file: src/entities/player.gd
2. Copy code template from DEVELOPMENT_ROADMAP.md lines 123-138 EXACTLY
3. Save file
4. Open scenes/entities/player.tscn in Godot (MCP)
5. Attach script: player.gd to root CharacterBody2D node
6. Save scene
7. Open scenes/world.tscn (MCP)
8. Run scene (F6) - player instance should be there
9. Test movement:
   - Press W/A/S/D or arrow keys
   - Verify player moves at consistent speed
   - Verify sprite flips when moving left (flip_h = true)
   - Verify sprite faces right when moving right (flip_h = false)
10. Check console for errors
11. If working → Commit
12. If errors → Debug and fix before committing

**Expected Outcome:**
- Player moves smoothly in 8 directions
- Speed: 100px/sec (per SPEED constant)
- Sprite flips correctly based on direction
- No console errors

**Commit Message:** (Use template from DEVELOPMENT_ROADMAP.md lines 147-157)

**DON'T:**
- ❌ Add interaction code yet (that's 1.1.3)
- ❌ Add animation system (not in Phase 1 minimal scope)
- ❌ Add player sprites (using placeholder for now)
- ❌ Modify movement speed without documenting why
- ❌ Add diagonal movement normalization (not in template - don't over-engineer)

---

#### Step 4: Implement Task 1.1.3 - Interaction System
**Goal:** Enable player to interact with world objects

**Read First:**
- DEVELOPMENT_ROADMAP.md lines 161-206 (Task 1.1.3 section)
- CONSTITUTION.md section 7 (Node Path Validation)

**Actions:**
1. Open scenes/entities/player.tscn (MCP)
2. Add Area2D as child of root (name: "InteractionZone")
3. Add CollisionShape2D to InteractionZone (CircleShape2D, radius: 32)
4. Save scene
5. Open src/entities/player.gd
6. Add interaction code from DEVELOPMENT_ROADMAP.md lines 170-187
   - Add signal at top
   - Add @onready var for interaction_zone
   - Add _unhandled_input() function
   - Add _try_interact() function
7. Save script
8. Configure input action in project.godot:
   - Open Project Settings → Input Map (MCP)
   - Add action: "interact"
   - Bind to E key
9. Create test interactable:
   - Create simple Node2D with Area2D in world.tscn
   - Attach test script with interact() method that prints message
10. Test:
    - Run scenes/world.tscn
    - Walk near test object
    - Press E key
    - Verify message prints in console
11. If working → Commit
12. Remove test interactable (keep player interaction system)

**Expected Outcome:**
- InteractionZone added to player
- E key triggers interaction
- Signal emits when interacting
- Console shows debug message from test object

**Commit Message:** (Use template from DEVELOPMENT_ROADMAP.md lines 195-205)

**DON'T:**
- ❌ Implement farm plot interaction logic (that's 1.3.2)
- ❌ Add UI feedback for interactions (not in scope yet)
- ❌ Create inventory system (not in Phase 1.1)
- ❌ Add multiple interaction zones

---

#### Step 5: Stop and Report Progress
**Goal:** Update status and get user feedback

**Actions:**
1. Update PROJECT_STATUS.md:
   - Mark 1.1.1, 1.1.2, 1.1.3 as complete
   - Update progress percentage
2. Commit PROJECT_STATUS.md update
3. Push all commits to branch
4. Report to user:
   - "Player System (1.1) complete"
   - List what was implemented
   - List what tests passed
   - Ask: "Ready to proceed to 1.2 (World & Scene Management)?"

**DON'T:**
- ❌ Automatically continue to Task 1.2 without checking in
- ❌ Implement multiple sections without stopping
- ❌ Assume user wants you to complete all of Phase 1 in one session

---

## 🎯 TESTING CHECKLIST (USE AFTER EACH IMPLEMENTATION)

### Before Committing ANY Code:

- [ ] **Code compiles** (no GDScript syntax errors)
- [ ] **Scene loads** (opens in Godot editor without errors)
- [ ] **Script attaches** (no "script not found" warnings)
- [ ] **Console clean** (no errors/warnings when running)
- [ ] **Feature works** (tested expected behavior manually)
- [ ] **Follows CONSTITUTION.md** (used constants, checked SCHEMA.md, etc.)
- [ ] **Matches roadmap** (didn't add extra features)
- [ ] **Isolated test passed** (tested this feature alone)

### If ANY Checkbox Fails:
1. **STOP** - Do not commit
2. **DEBUG** - Fix the issue
3. **RETEST** - Verify fix works
4. **THEN** commit

---

## 📝 COMMIT MESSAGE STANDARDS

### Format (from CONSTITUTION.md):
```
<type>: <summary>

<details>

<testing notes>
```

**Types:**
- `feat:` - New feature (movement system, farming, etc.)
- `fix:` - Bug fix
- `chore:` - Configuration, setup (scene verification, etc.)
- `docs:` - Documentation only
- `test:` - Test-related changes
- `refactor:` - Code restructuring (avoid unless requested)

**Example (Good):**
```
feat: implement player movement system

- Add CharacterBody2D with 8-directional movement
- Implement input handling (WASD/arrows)
- Add sprite flipping based on direction
- Camera follows player with 2x zoom
- Movement speed: 100px/sec (SPEED constant)

Tested: Player moves smoothly in all directions
Verified: No console errors, sprite flips correctly
```

**Example (Bad):**
```
feat: add stuff

- did some things
```

**DON'T:**
- ❌ Use vague commit messages
- ❌ Commit untested code
- ❌ Combine multiple features in one commit
- ❌ Forget to document what was tested

---

## 🚦 GO / NO-GO CRITERIA

### ✅ You Are CLEAR to Proceed When:
- Phase 0 validation passes (TEST_SCRIPT.gd shows all green)
- Current subsection is complete and tested
- All tests pass (no console errors)
- Code committed with proper message
- PROJECT_STATUS.md updated
- You have capacity for exactly ONE more subsection

### 🛑 You Must STOP When:
- Any test fails (console errors, unexpected behavior)
- You've completed a full section (e.g., all of 1.1)
- You're unsure about implementation approach
- SCHEMA.md doesn't have a property you need
- Code doesn't match DEVELOPMENT_ROADMAP.md template
- You've been working for extended time (check-in point)

### ❓ You Must ASK USER When:
- Roadmap is unclear or ambiguous
- You need to deviate from provided template
- Tests fail and you can't fix after 2 attempts
- You think a feature is missing from roadmap
- You encounter a blocker not documented
- You've completed a major milestone (full section)

---

## 📖 REQUIRED READING ORDER (BEFORE STARTING)

**Priority 1 (Read NOW):**
1. ✅ This file (ANTIGRAVITY_FEEDBACK.md) - You're reading it
2. CONSTITUTION.md - Immutable technical rules
3. SCHEMA.md - Data structure definitions

**Priority 2 (Read BEFORE implementing):**
4. DEVELOPMENT_ROADMAP.md (Task 1.1.1 section only)
5. PROJECT_STATUS.md (verify Phase 0 complete)

**Priority 3 (Reference as needed):**
6. PLAYTESTER_GUIDE.md (if running validation tests)
7. PROJECT_SUMMARY.md (quick reference for context)

**Priority 4 (Not immediately needed):**
8. Storyline.md (narrative context - read when implementing Phase 2)
9. PHASE_2_ROADMAP.md (not needed until Phase 1 complete)
10. ASSET_CHECKLIST.md (for asset creation, not code)

---

## 🎓 SUMMARY - KEY TAKEAWAYS

### Golden Rules:
1. **ONE task at a time** - No multi-tasking, no parallelization
2. **TEST immediately** - After every implementation, before commit
3. **FOLLOW the roadmap** - Code templates provided, use them exactly
4. **CHECK SCHEMA.md** - Never guess property names
5. **USE MCP tools** - Test in actual Godot engine, not assumptions
6. **STOP at checkpoints** - Report progress, don't auto-continue
7. **COMMIT granularly** - One feature = one commit

### Anti-Patterns to Avoid:
- ❌ Implementing too much at once
- ❌ Skipping testing
- ❌ Adding features beyond scope
- ❌ Hallucinating property names
- ❌ Ignoring CONSTITUTION.md rules
- ❌ Continuing without user check-in

### You Are Successful When:
- Code works exactly as specified
- Tests pass in isolation
- Console shows no errors
- Commits are clean and documented
- You stay within subsection boundaries
- User can continue from your work seamlessly

---

## 🚀 READY TO START?

**Next Immediate Action:**
1. Use MCP to open Godot project
2. Run TEST_SCRIPT.gd to validate Phase 0
3. Report results
4. If all pass → Begin Task 1.1.1 (Player Scene Creation)
5. If any fail → Report errors to user immediately

**Remember:**
- Small steps = big success
- Test before commit
- One task at a time
- Trust the roadmap
- Ask when uncertain

**Good luck, Antigravity AI. Stay focused, stay incremental, and follow the guardrails.**

---

**End of ANTIGRAVITY_FEEDBACK.md**
