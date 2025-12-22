# Phase 4 Completion Plan: Core Wiring & 30-Minute Streamlined Game

**Status:** Ready for execution
**Estimated Time:** 18-20 hours over 4-5 days
**Goal:** Complete Phase 4 with working prototype demonstrating farm→craft→quest loop in 30-minute playthrough

---

## Executive Summary

### Current Issues Identified

**Missing Roadmap Step:** Farm plots were added to world.tscn manually but this wasn't documented as an explicit setup step in the roadmap. This is why the junior engineer missed it.

**Critical Blockers Preventing Playability:**
1. No starter seeds (inventory empty, can't plant)
2. Farm plot TILLED interaction has `pass` (no seed selection UI)
3. DialogueBox doesn't trigger minigames or crafting
4. All crop growth_stages textures are null (invisible crops)
5. 13/16 dialogue files are 5-line stubs (no context)

**What's Already Working:**
- Farm plot state machine (EMPTY → TILLED → PLANTED → GROWING → HARVESTABLE)
- All 4 minigames implemented (Herb ID, Moon Tears, Sacred Earth, Weaving)
- Crafting controller with 5 recipes
- GameState flag system
- NPC spawner with flag gating

### User Requirements

- **Priority 1:** Finish core wiring (unblock farm, dialogue→minigame, dialogue→crafting)
- **Priority 2:** Streamline to 30 minutes (3-5 quests instead of 11)
- **Priority 3:** Structure for extensibility (easy to add full content back later)
- **Act Structure:** 3-Act (Prologue → Transformation → Resolution)
- **Gameplay Loops:** Plant→Grow→Harvest (1-2 crops), Crafting (1-2 recipes), Minigames (2-3)

---

## Part 1: Core Wiring (Priority 1) - 10-12 Hours

### 1.1 Starter Seeds & New Game Initialization (1 hour)

**Problem:** GameState initializes with empty inventory; player can't plant anything.

**File:** [game/autoload/game_state.gd](game/autoload/game_state.gd)

**Implementation:**

Add `new_game()` method after line 34 (`_load_registries()`):

```gdscript
func new_game() -> void:
    """Initialize fresh game state with starter resources"""
    # Reset state
    current_day = 1
    current_season = "spring"
    gold = 100
    inventory.clear()
    quest_flags.clear()
    farm_plots.clear()

    # Give starter seeds (3 wheat seeds for demo)
    add_item("wheat_seed", 3)

    # Set prologue complete flag (skip intro for faster testing)
    set_flag("prologue_complete", true)

    print("[GameState] New game initialized")
```

**File:** [game/features/ui/main_menu.gd](game/features/ui/main_menu.gd)

Update `_on_new_game_pressed()` method (around line 20-30):

```gdscript
func _on_new_game_pressed() -> void:
    GameState.new_game()  # Initialize fresh state
    SceneManager.change_scene("res://game/features/world/world.tscn")
```

**Testing:**
- Start new game
- Open inventory → verify 3x wheat_seed present
- Verify gold = 100
- Verify prologue_complete flag is true

---

### 1.2 Farm Plot Seed Selection UI (3 hours)

**Problem:** Tilling a plot transitions to TILLED state, but interacting again does nothing (has `pass` statement).

#### Step 2.1: Create Seed Selector Scene (45 min)

**New File:** [game/features/ui/seed_selector.tscn](game/features/ui/seed_selector.tscn)

**Scene Structure:**
```
Control (SeedSelector)
├─ Panel
│  ├─ Label (text: "Select Seed")
│  ├─ GridContainer (columns: 3, name: "SeedGrid")
│  └─ Button (text: "Cancel", name: "CancelButton")
```

**New File:** [game/features/ui/seed_selector.gd](game/features/ui/seed_selector.gd)

```gdscript
extends Control

signal seed_selected(seed_id: String)
signal cancelled

@onready var seed_grid: GridContainer = $Panel/SeedGrid
@onready var cancel_button: Button = $Panel/CancelButton

var seed_buttons: Array[Button] = []

func _ready() -> void:
    assert(seed_grid != null, "SeedGrid missing")
    assert(cancel_button != null, "CancelButton missing")
    cancel_button.pressed.connect(_on_cancel)
    visible = false

func open() -> void:
    """Populate grid with seed items from inventory"""
    # Clear existing buttons
    for button in seed_buttons:
        button.queue_free()
    seed_buttons.clear()

    # Find all seed items (items ending with "_seed")
    var seed_items: Array[String] = []
    for item_id in GameState.inventory.keys():
        if item_id.ends_with("_seed"):
            seed_items.append(item_id)

    if seed_items.is_empty():
        push_error("No seeds in inventory!")
        cancelled.emit()
        return

    # Create button for each seed
    for seed_id in seed_items:
        var button = Button.new()
        var item_data = GameState.get_item_data(seed_id)
        if item_data:
            button.text = "%s (%d)" % [item_data.display_name, GameState.get_item_count(seed_id)]
        else:
            button.text = seed_id

        button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
        seed_grid.add_child(button)
        seed_buttons.append(button)

    if seed_buttons.size() > 0:
        seed_buttons[0].grab_focus()

    UIHelpers.open_panel(self)

func close() -> void:
    UIHelpers.close_panel(self)

func _on_seed_button_pressed(seed_id: String) -> void:
    seed_selected.emit(seed_id)
    close()

func _on_cancel() -> void:
    cancelled.emit()
    close()

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return

    if event.is_action_pressed("ui_cancel"):
        _on_cancel()
```

#### Step 2.2: Wire Farm Plot to Seed Selector (1 hour)

**File:** [game/features/farm_plot/farm_plot.gd](game/features/farm_plot/farm_plot.gd)

Replace line 99 `pass` with:

```gdscript
_request_seed_selection()
```

Add methods at end of file (after line 145):

```gdscript
func _request_seed_selection() -> void:
    """Signal to UI to show seed selector"""
    var ui = get_tree().root.get_node_or_null("World/UI/SeedSelector")
    if not ui:
        push_error("SeedSelector not found in scene tree")
        return

    # Connect signals if not already connected
    if not ui.seed_selected.is_connected(_on_seed_selected):
        ui.seed_selected.connect(_on_seed_selected)
    if not ui.cancelled.is_connected(_on_seed_selection_cancelled):
        ui.cancelled.connect(_on_seed_selection_cancelled)

    ui.open()

func _on_seed_selected(seed_id: String) -> void:
    """Called when player selects seed from UI"""
    if not GameState.remove_item(seed_id, 1):
        push_error("Failed to remove seed: %s" % seed_id)
        return

    plant(seed_id)

func _on_seed_selection_cancelled() -> void:
    # User cancelled - do nothing
    pass
```

#### Step 2.3: Add Seed Selector to World Scene (30 min)

**File:** [game/features/world/world.tscn](game/features/world/world.tscn)

Add to UI layer (after existing InventoryPanel):

```
[node name="SeedSelector" parent="UI" instance=ExtResource("XX_seed_selector")]
visible = false
```

Add import at top:

```
[ext_resource type="PackedScene" path="res://game/features/ui/seed_selector.tscn" id="XX_seed_selector"]
```

**Testing:**
1. Start new game (3 wheat seeds in inventory)
2. Walk to farm plot
3. Press E on EMPTY → should till
4. Press E on TILLED → seed selector popup appears
5. Select wheat_seed → consumes 1 seed, plants wheat
6. Verify inventory: 2 wheat seeds remaining
7. Repeat until all seeds planted

---

### 1.3 Dialogue → Minigame Bridge (2.5 hours)

**Problem:** DialogueBox doesn't have mechanism to launch minigames or crafting after dialogue ends.

#### Step 3.1: Extend DialogueData Resource (30 min)

**File:** [src/resources/dialogue_data.gd](src/resources/dialogue_data.gd)

Add after line 24:

```gdscript
@export var minigame_scene: String = ""  ## Path to minigame scene to launch after dialogue
@export var recipe_id: String = ""       ## Recipe ID to trigger crafting after dialogue
```

Update class comment (lines 5-17) to document new fields:

```gdscript
## Triggers (processed after dialogue ends):
## - minigame_scene: Path to minigame scene to launch (e.g., "res://game/features/minigames/herb_identification.tscn")
## - recipe_id: Recipe to start in crafting controller (e.g., "calming_draught")
```

#### Step 3.2: Wire DialogueBox to Launch Minigames (1 hour)

**File:** [game/features/ui/dialogue_box.gd](game/features/ui/dialogue_box.gd)

Replace `_end_dialogue()` method (lines 123-131):

```gdscript
func _end_dialogue() -> void:
    # Set flags if specified
    for flag in current_dialogue.flags_to_set:
        GameState.set_flag(flag, true)

    var dialogue_id = current_dialogue.id

    # Check for minigame trigger
    if current_dialogue.minigame_scene != "":
        _launch_minigame(current_dialogue.minigame_scene)

    # Check for recipe trigger
    if current_dialogue.recipe_id != "":
        _launch_crafting(current_dialogue.recipe_id)

    dialogue_ended.emit(dialogue_id)
    visible = false
    current_dialogue = null

func _launch_minigame(scene_path: String) -> void:
    """Load and show minigame scene"""
    if not ResourceLoader.exists(scene_path):
        push_error("Minigame scene not found: %s" % scene_path)
        return

    var minigame_scene = load(scene_path)
    if not minigame_scene:
        push_error("Failed to load minigame: %s" % scene_path)
        return

    var world = get_tree().root.get_node_or_null("World")
    if not world:
        push_error("World node not found")
        return

    var minigame = minigame_scene.instantiate()
    world.add_child(minigame)

    if minigame.has_signal("minigame_complete"):
        minigame.minigame_complete.connect(_on_minigame_complete.bind(minigame))

    print("[DialogueBox] Launched minigame: %s" % scene_path)

func _launch_crafting(recipe_id: String) -> void:
    """Start crafting controller with recipe"""
    var crafting = get_tree().root.get_node_or_null("World/UI/CraftingController")
    if not crafting:
        push_error("CraftingController not found")
        return

    crafting.start_craft(recipe_id)
    print("[DialogueBox] Launched crafting: %s" % recipe_id)

func _on_minigame_complete(success: bool, items: Array, minigame: Node) -> void:
    """Handle minigame completion"""
    if success:
        for item_data in items:
            if item_data.has("item_id") and item_data.has("quantity"):
                GameState.add_item(item_data["item_id"], item_data["quantity"])

    minigame.queue_free()
    print("[DialogueBox] Minigame complete: %s" % success)
```

#### Step 3.3: Add CraftingController to World Scene (30 min)

**File:** [game/features/world/world.tscn](game/features/world/world.tscn)

Add to UI layer (after SeedSelector):

```
[node name="CraftingController" parent="UI" instance=ExtResource("XX_crafting")]
visible = false
```

Add import:

```
[ext_resource type="PackedScene" path="res://game/features/ui/crafting_controller.tscn" id="XX_crafting"]
```

**Testing:**
1. Update [game/shared/resources/dialogues/act1_herb_identification.tres](game/shared/resources/dialogues/act1_herb_identification.tres) to add:
   - `minigame_scene = "res://game/features/minigames/herb_identification.tscn"`
2. Trigger quest 1 dialogue
3. Complete dialogue → herb identification minigame launches
4. Complete minigame → pharmaka_flower added to inventory
5. Verify flag quest_1_complete is set

---

### 1.4 Crop Texture Placeholders (1.5 hours)

**Problem:** All crop growth_stages arrays contain null values, making crops invisible while growing.

#### Step 4.1: Create Placeholder Sprites (1 hour)

**Manual Task:** Create 4 simple 16x16 PNG files (colored squares):
- `wheat_stage_0.png` - light green (#90EE90)
- `wheat_stage_1.png` - medium green (#32CD32)
- `wheat_stage_2.png` - yellow-green (#9ACD32)
- `wheat_stage_3.png` - golden yellow (#FFD700)

Place in: `assets/sprites/placeholders/crops/`

**Alternative (faster):** Use modulate tinting instead of creating sprites. In [game/features/farm_plot/farm_plot.gd](game/features/farm_plot/farm_plot.gd) `_update_crop_sprite()` method (around line 111-116), add:

```gdscript
func _update_crop_sprite() -> void:
    var crop_data = GameState.get_crop_data(crop_id)
    if not crop_data:
        crop_sprite.visible = false
        return

    # Use modulate for growth stages if textures are null
    if current_growth_stage < crop_data.growth_stages.size():
        var texture = crop_data.growth_stages[current_growth_stage]
        if texture:
            crop_sprite.texture = texture
            crop_sprite.modulate = Color.WHITE
        else:
            # Fallback: use placeholder with color modulation
            crop_sprite.texture = load("res://assets/sprites/placeholders/placeholder_crop.png")
            # Tint from green → yellow as it grows
            var progress = float(current_growth_stage) / float(crop_data.growth_stages.size())
            crop_sprite.modulate = Color(
                0.5 + (progress * 0.5),  # Red increases
                1.0,                      # Green constant
                0.3 - (progress * 0.2)    # Blue decreases
            )

        crop_sprite.visible = true
```

#### Step 4.2: Update Crop Resources (30 min)

**Only if creating actual sprites (not using modulate approach):**

**Files:**
- [game/shared/resources/crops/wheat.tres](game/shared/resources/crops/wheat.tres)
- [game/shared/resources/crops/nightshade.tres](game/shared/resources/crops/nightshade.tres)
- [game/shared/resources/crops/moly.tres](game/shared/resources/crops/moly.tres)

Update wheat.tres as example:

```
growth_stages = Array[Texture2D]([
    ExtResource("wheat_stage_0"),
    ExtResource("wheat_stage_1"),
    ExtResource("wheat_stage_2"),
    ExtResource("wheat_stage_3")
])
```

Add ext_resource imports at top:

```
[ext_resource type="Texture2D" path="res://assets/sprites/placeholders/crops/wheat_stage_0.png" id="wheat_stage_0"]
[ext_resource type="Texture2D" path="res://assets/sprites/placeholders/crops/wheat_stage_1.png" id="wheat_stage_1"]
[ext_resource type="Texture2D" path="res://assets/sprites/placeholders/crops/wheat_stage_2.png" id="wheat_stage_2"]
[ext_resource type="Texture2D" path="res://assets/sprites/placeholders/crops/wheat_stage_3.png" id="wheat_stage_3"]
```

**Testing:**
1. Plant wheat seed
2. Advance day (use sundial)
3. Verify crop sprite appears and changes color/texture
4. Advance to day 3 (wheat days_to_mature = 2)
5. Crop should show stage 3 (harvestable, golden yellow)
6. Harvest → wheat added to inventory

---

### 1.5 Minigame Reward Wiring Verification (2 hours)

**Problem:** Minigames may not emit rewards correctly.

#### Verify Each Minigame Emits Correct Rewards

**File:** [game/features/minigames/herb_identification.gd](game/features/minigames/herb_identification.gd)

Find completion logic (around line 70-90) and ensure:

```gdscript
func _complete_minigame(success: bool) -> void:
    var rewards: Array = []
    if success:
        rewards.append({"item_id": "pharmaka_flower", "quantity": 1})

    minigame_complete.emit(success, rewards)
```

**File:** [game/features/minigames/moon_tears_minigame.gd](game/features/minigames/moon_tears_minigame.gd)

```gdscript
# On success:
rewards.append({"item_id": "moon_tear", "quantity": 1})
```

**File:** [game/features/minigames/sacred_earth.gd](game/features/minigames/sacred_earth.gd)

```gdscript
# On success:
rewards.append({"item_id": "sacred_earth", "quantity": 1})
```

**File:** [game/features/minigames/weaving_minigame.gd](game/features/minigames/weaving_minigame.gd)

```gdscript
# On success:
rewards.append({"item_id": "woven_cloth", "quantity": 1})
```

**Testing:**
1. Trigger each minigame via dialogue (after implementing dialogue→minigame bridge)
2. Complete successfully
3. Verify reward item added to inventory
4. Check inventory panel shows correct count

---

## Part 2: Streamlined Content Path (Priority 2) - 4-6 Hours

### Quest Structure: 30-Minute Playthrough

**3-Act Structure:**

**Act 1: Prologue (5 minutes)**
- Quest 0: Prologue opening (auto-plays) → aiaia_arrival
- Skip directly to Quest 1

**Act 2: Learning & Transformation (15 minutes)**
- Quest 1: Herb Identification (minigame) → collect pharmaka
- Quest 2: Farming Tutorial → plant wheat, advance day, harvest
- Quest 3: Calming Draught (crafting) → brew potion using pharmaka + moly

**Act 3: Confrontation & Resolution (10 minutes)**
- Quest 4: Confront Scylla (dialogue choice: kill or spare)
- Epilogue: Ending reflection (2 variations)

### Dialogue Expansion Plan

| Dialogue File | Current | Target | Purpose | Time |
|--------------|---------|--------|---------|------|
| prologue_opening.tres | 59 lines | 59 | Keep as-is | 0 min |
| aiaia_arrival.tres | 48 lines | 48 | Keep as-is | 0 min |
| act1_herb_identification.tres | 5 lines | 15-20 | Tutorial + minigame trigger | 30 min |
| act2_farming_tutorial.tres | 5 lines | 15-20 | Farm loop tutorial | 30 min |
| act2_calming_draught.tres | 5 lines | 15-20 | Crafting tutorial | 30 min |
| act1_confront_scylla.tres | 5 lines | 30-40 | Climax + choice | 60 min |
| epilogue_ending_choice.tres | 5 lines | 20-30 | Resolution (2 endings) | 45 min |

**KEEP AS STUBS (5 lines, for future expansion):**
- act1_extract_sap.tres
- act2_reversal_elixir.tres
- act2_daedalus_arrives.tres
- act2_binding_ward.tres
- act3_sacred_earth.tres
- act3_moon_tears.tres
- act3_ultimate_crafting.tres
- act3_final_confrontation.tres

### Dialogue Content Writing (3-4 hours)

#### [act1_herb_identification.tres](game/shared/resources/dialogues/act1_herb_identification.tres) (30 min)

```gdscript
id = "act1_herb_identification"
lines = [
    {"speaker": "Circe", "text": "The pharmaka grows here. I can feel its power."},
    {"speaker": "Circe", "text": "But false herbs grow alongside it. They mock the true plant."},
    {"speaker": "Circe", "text": "If I pick wrong, the ritual will fail."},
    {"speaker": "Circe", "text": "The true pharmaka glows faintly gold in moonlight."},
    {"speaker": "Circe", "text": "The false ones are duller, ashen."},
    {"speaker": "Circe", "text": "I must be careful. Precise."},
    {"speaker": "Circe", "text": "Mother taught me this, long ago."},
    {"speaker": "Circe", "text": "Before she stopped looking at me."},
    {"speaker": "Circe", "text": "Focus, Circe. Find the true herb."}
]
flags_to_set = ["quest_1_complete"]
minigame_scene = "res://game/features/minigames/herb_identification.tscn"
```

#### [act2_farming_tutorial.tres](game/shared/resources/dialogues/act2_farming_tutorial.tres) (30 min)

```gdscript
id = "act2_farming_tutorial"
lines = [
    {"speaker": "Circe", "text": "The pharmaka was strong, but I'll need more ingredients."},
    {"speaker": "Circe", "text": "Moly. Sacred herbs. Rare earth from the grove."},
    {"speaker": "Circe", "text": "But first, I must survive. I need food."},
    {"speaker": "Circe", "text": "This island is mine now. I should tend it."},
    {"speaker": "Circe", "text": "Till the soil with your hands. Press the seeds into earth."},
    {"speaker": "Circe", "text": "Water them. Watch them grow."},
    {"speaker": "Circe", "text": "Use the sundial to advance the day."},
    {"speaker": "Circe", "text": "Wheat grows quickly. Two days to harvest."},
    {"speaker": "Circe", "text": "When the stalks turn gold, you may reap."},
    {"speaker": "Circe", "text": "This is my island. I will master it."}
]
flags_to_set = ["quest_2_complete", "garden_built"]
```

#### [act2_calming_draught.tres](game/shared/resources/dialogues/act2_calming_draught.tres) (30 min)

```gdscript
id = "act2_calming_draught"
lines = [
    {"speaker": "Circe", "text": "The first potion. A test of my skill."},
    {"speaker": "Circe", "text": "Moly petals, ground fine. Pharmaka essence, distilled."},
    {"speaker": "Circe", "text": "A calming draught. Mother called it 'gentle mercy.'"},
    {"speaker": "Circe", "text": "But I will not be merciful to Scylla."},
    {"speaker": "Circe", "text": "This is just practice. Preparation."},
    {"speaker": "Circe", "text": "Grind the herbs in the mortar. Follow the rhythm."},
    {"speaker": "Circe", "text": "Then the binding sequence. Precise gestures."},
    {"speaker": "Circe", "text": "If I fail, the mixture burns. Try again."},
    {"speaker": "Circe", "text": "But I will not fail. I cannot."},
    {"speaker": "Circe", "text": "This is my art. And I am its master."}
]
flags_to_set = ["quest_3_complete"]
recipe_id = "calming_draught"
```

#### [act1_confront_scylla.tres](game/shared/resources/dialogues/act1_confront_scylla.tres) (60 min)

```gdscript
id = "act1_confront_scylla"
lines = [
    {"speaker": "Circe", "text": "The potion is ready."},
    {"speaker": "Circe", "text": "I return to the shore where she bathes."},
    {"speaker": "Circe", "text": "Beautiful Scylla. Vain Scylla."},
    {"speaker": "Scylla", "text": "Who disturbs my waters?"},
    {"speaker": "Circe", "text": "Just a traveler. A goddess in exile."},
    {"speaker": "Scylla", "text": "Exile? How the mighty fall."},
    {"speaker": "Circe", "text": "You mock me. You, who stole what was mine."},
    {"speaker": "Scylla", "text": "I stole nothing. He chose me. Freely."},
    {"speaker": "Circe", "text": "You are a thief. And thieves must be punished."},
    {"speaker": "Scylla", "text": "You dare threaten me? A minor goddess?"},
    {"speaker": "Circe", "text": "I am more than you know."},
    {"speaker": "Circe", "text": "I pour the potion into the water."},
    {"speaker": "Circe", "text": "It spreads. Coils around her legs."},
    {"speaker": "Scylla", "text": "What... what is this? What have you done?!"},
    {"speaker": "Circe", "text": "I have made you what you truly are."},
    {"speaker": "Scylla", "text": "No! NO! My legs... they burn!"},
    {"speaker": "Circe", "text": "Six serpent heads sprout from her waist."},
    {"speaker": "Circe", "text": "She screams. The water churns red."},
    {"speaker": "Circe", "text": "And I..."},
    {"speaker": "Circe", "text": "I feel nothing."}
]
choices = [
    {"text": "Kill her. End this.", "next_id": "epilogue_kill_ending"},
    {"text": "Leave her to suffer.", "next_id": "epilogue_exile_ending"}
]
flags_to_set = ["quest_4_complete", "scylla_transformed"]
```

#### Create Two Epilogue Endings (45 min total)

**[game/shared/resources/dialogues/epilogue_kill_ending.tres](game/shared/resources/dialogues/epilogue_kill_ending.tres)** (new file):

```gdscript
id = "epilogue_kill_ending"
lines = [
    {"speaker": "Circe", "text": "I raise my hand."},
    {"speaker": "Circe", "text": "One more word, and she is ash."},
    {"speaker": "Scylla", "text": "Please... mercy..."},
    {"speaker": "Circe", "text": "Mercy? You showed me none."},
    {"speaker": "Circe", "text": "I speak the word. Lightning cracks."},
    {"speaker": "Circe", "text": "Scylla is gone."},
    {"speaker": "Circe", "text": "The shore is silent."},
    {"speaker": "Circe", "text": "And I am alone."},
    {"speaker": "Circe", "text": "Father was right. I am an embarrassment."},
    {"speaker": "Circe", "text": "But I am also powerful."},
    {"speaker": "Circe", "text": "And I will never be hurt again."},
    {"speaker": "Circe", "text": "[END]"}
]
flags_to_set = ["game_complete", "scylla_killed"]
```

**[game/shared/resources/dialogues/epilogue_exile_ending.tres](game/shared/resources/dialogues/epilogue_exile_ending.tres)** (new file):

```gdscript
id = "epilogue_exile_ending"
lines = [
    {"speaker": "Circe", "text": "I turn away."},
    {"speaker": "Circe", "text": "Let her suffer. Let her remember."},
    {"speaker": "Scylla", "text": "Wait! Please! Change me back!"},
    {"speaker": "Circe", "text": "I do not answer."},
    {"speaker": "Circe", "text": "Her screams fade as I walk inland."},
    {"speaker": "Circe", "text": "This island is mine now."},
    {"speaker": "Circe", "text": "And I will never leave."},
    {"speaker": "Circe", "text": "Father can keep his court. His judgment."},
    {"speaker": "Circe", "text": "I have found something better."},
    {"speaker": "Circe", "text": "Power. Solitude. Freedom."},
    {"speaker": "Circe", "text": "[END]"}
]
flags_to_set = ["game_complete", "scylla_exiled"]
```

---

## Part 3: Extensibility Design (Priority 3) - 2 Hours

### How to Add Full Content Back Later

**Design Principle:** The streamlined version uses quests 1-4, leaving quests 5-11 as stubs. All systems are designed to accept new content without code changes.

### 3.1 Quest Flag Naming Convention

**Current streamlined path:**
- prologue_complete
- quest_1_complete (herb identification)
- quest_2_complete (farming tutorial)
- quest_3_complete (calming draught)
- quest_4_complete (confront scylla)
- game_complete

**Full 11-quest naming (reserved for future):**
```
quest_1_complete  # Herb ID (EXISTS)
quest_2_complete  # Farming (EXISTS)
quest_3_complete  # Calming Draught (EXISTS)
quest_4_complete  # Confront Scylla (EXISTS)
quest_5_complete  # Extract Sap (STUB)
quest_6_complete  # Reversal Elixir (STUB)
quest_7_complete  # Daedalus Arrives (STUB)
quest_8_complete  # Binding Ward (STUB)
quest_9_complete  # Sacred Earth (STUB)
quest_10_complete # Moon Tears (STUB)
quest_11_complete # Ultimate Crafting (STUB)
```

### 3.2 Adding Content Back: Step-by-Step

#### To Add Quest 5 (Extract Sap) Later:

1. **Expand Dialogue Stub:**
   - Open [game/shared/resources/dialogues/act1_extract_sap.tres](game/shared/resources/dialogues/act1_extract_sap.tres)
   - Expand from 5 lines to 15-30 lines
   - Add `minigame_scene` or `recipe_id` if needed
   - Set `flags_to_set = ["quest_5_complete"]`

2. **Add Quest Trigger to World:**
   - Open [game/features/world/world.tscn](game/features/world/world.tscn)
   - Add new Area2D under QuestTriggers:
     ```
     [node name="Quest5_ExtractSap" type="Area2D" parent="QuestTriggers"]
     position = Vector2(96, 64)
     script = ExtResource("6_quest_trigger")
     required_flag = "quest_4_complete"
     set_flag_on_enter = "quest_5_active"
     trigger_dialogue = "act1_extract_sap"
     ```

3. **Update Final Epilogue Trigger:**
   - Change epilogue trigger's `required_flag` from `quest_4_complete` to `quest_5_complete`

4. **No Code Changes Needed:**
   - DialogueBox already supports minigame/crafting triggers
   - GameState flag system is data-driven
   - NPC spawner already has unused spawn points

#### To Add New Crops:

1. Create new CropData resource: `game/shared/resources/crops/NEW_CROP.tres`
2. Add to [game/autoload/game_state.gd](game/autoload/game_state.gd) `_load_registries()` crop_paths array
3. Create corresponding ItemData for seed and harvest item
4. Add textures to growth_stages array

#### To Add New Recipes:

1. Create RecipeData resource: `game/shared/resources/recipes/NEW_RECIPE.tres`
2. Add to [game/features/ui/crafting_controller.gd](game/features/ui/crafting_controller.gd) recipe_paths array
3. Reference recipe_id in dialogue trigger

### 3.3 Documentation

Create **[docs/design/EXTENSIBILITY.md](docs/design/EXTENSIBILITY.md)** (new file) documenting:
- Quest flag naming conventions
- How to expand dialogue stubs
- How to add new quest triggers
- How to add crops/recipes/NPCs
- Quest dependency chart

---

## Part 4: Missing Roadmap Step Documentation - 15 Minutes

### Document Farm Plot World Setup

**File:** [docs/execution/ROADMAP.md](docs/execution/ROADMAP.md)

**Insert after Section 1.3.2 (Farm Plot Script)** around line 750:

```markdown
#### 1.3.3 - Farm Plot World Placement
Add farm plot instances to world scene

**Task:**
1. Open game/features/world/world.tscn in Godot editor
2. Create Node2D container: "FarmPlots" as child of World root
3. Instance farm_plot.tscn three times as children of FarmPlots:
   - FarmPlotA: position (0, 64), grid_position (0, 2)
   - FarmPlotB: position (32, 64), grid_position (1, 2)
   - FarmPlotC: position (64, 64), grid_position (2, 2)
4. Save scene

**Verification:**
1. Run world scene
2. Walk to farm plot positions
3. Press E to till
4. Verify all three plots respond to interaction

**Critical:** Farm plots must be placed in world scene for farming system to work. Grid positions should be unique and match world coordinates.
```

**Also update Phase 4 checklist** in [docs/execution/PHASE_4_PROTOTYPE.md](docs/execution/PHASE_4_PROTOTYPE.md) to add:

Under section 4.0 (Critical Blocker Fixes), add:

```markdown
### 4.0.8 - Farm Plot World Placement (Setup Step)

**Problem:** Farm plots exist in game/features/farm_plot/farm_plot.tscn but not instantiated in world scene.

**Fix:**
- Add FarmPlots container to world.tscn
- Instance 3 farm plots at spawn positions
- Set unique grid_position for each plot

**Why This Was Missed:** This is a scene setup step, not a code implementation task. Roadmap didn't explicitly call out world scene configuration.
```

---

## Implementation Schedule

### Day 1: Core Wiring Foundation (4 hours)
1. ✅ Starter seeds (1.1) - **NO DEPENDENCIES**
2. ✅ Seed selector UI (1.2) - **DEPENDS: 1.1**
3. ✅ Testing checkpoint

### Day 2: Content Bridges (4 hours)
1. ✅ Dialogue → Minigame (1.3) - **NO DEPENDENCIES**
2. ✅ Crop textures (1.4) - **NO DEPENDENCIES**
3. ✅ Minigame rewards verification (1.5) - **DEPENDS: 1.3**
4. ✅ Testing checkpoint

### Day 3: Content Writing (4 hours)
1. ✅ Expand herb_identification dialogue
2. ✅ Expand farming_tutorial dialogue
3. ✅ Expand calming_draught dialogue
4. ✅ Test full quest 1-3 flow

### Day 4: Climax & Ending (4 hours)
1. ✅ Expand confront_scylla dialogue
2. ✅ Create epilogue dialogues (kill/spare endings)
3. ✅ Full playthrough test (target: 30 min)

### Day 5: Polish & Documentation (2-4 hours)
1. ✅ Balance playtime (adjust dialogue lengths if needed)
2. ✅ Document extensibility architecture
3. ✅ Update roadmap with farm plot step
4. ✅ Final QA pass

---

## Testing Checkpoints

### ✅ Checkpoint A: Farm Loop Complete
- New game → 3 wheat seeds in inventory
- Till plot → seed selector appears
- Plant → wheat grows over 2 days
- Harvest → wheat added to inventory

### ✅ Checkpoint B: Dialogue Triggers Work
- Quest 1 dialogue → herb minigame launches
- Complete minigame → pharmaka in inventory
- Quest flag quest_1_complete set

### ✅ Checkpoint C: Full Streamlined Path (30 minutes)
- Prologue (auto)
- Quest 1: Herb ID minigame
- Quest 2: Farm wheat
- Quest 3: Craft calming draught
- Quest 4: Confront Scylla (choice)
- Epilogue (2 endings)

### ✅ Checkpoint D: Extensibility Verified
- Stub dialogues intact (quests 5-11)
- Quest flags numbered 1-11
- NPC spawner has unused spawn points
- Recipe/crop systems accept new resources without code changes

---

## Critical Files Summary

### Files to Modify:
1. [game/autoload/game_state.gd](game/autoload/game_state.gd) - Add new_game() method
2. [game/features/ui/main_menu.gd](game/features/ui/main_menu.gd) - Call new_game() on button press
3. [game/features/farm_plot/farm_plot.gd](game/features/farm_plot/farm_plot.gd) - Wire TILLED state to seed selector
4. [game/features/ui/dialogue_box.gd](game/features/ui/dialogue_box.gd) - Add minigame/crafting triggers
5. [src/resources/dialogue_data.gd](src/resources/dialogue_data.gd) - Add minigame_scene and recipe_id fields
6. [game/features/world/world.tscn](game/features/world/world.tscn) - Add SeedSelector and CraftingController to UI
7. [docs/execution/ROADMAP.md](docs/execution/ROADMAP.md) - Add farm plot setup step
8. [docs/execution/PHASE_4_PROTOTYPE.md](docs/execution/PHASE_4_PROTOTYPE.md) - Document missing setup step

### Files to Create:
1. [game/features/ui/seed_selector.tscn](game/features/ui/seed_selector.tscn) - Seed selection popup
2. [game/features/ui/seed_selector.gd](game/features/ui/seed_selector.gd) - Seed selection logic
3. [game/shared/resources/dialogues/epilogue_kill_ending.tres](game/shared/resources/dialogues/epilogue_kill_ending.tres) - Kill ending
4. [game/shared/resources/dialogues/epilogue_exile_ending.tres](game/shared/resources/dialogues/epilogue_exile_ending.tres) - Spare ending
5. [docs/design/EXTENSIBILITY.md](docs/design/EXTENSIBILITY.md) - Extensibility documentation

### Files to Expand (Dialogue):
1. [game/shared/resources/dialogues/act1_herb_identification.tres](game/shared/resources/dialogues/act1_herb_identification.tres) - 5→15 lines
2. [game/shared/resources/dialogues/act2_farming_tutorial.tres](game/shared/resources/dialogues/act2_farming_tutorial.tres) - 5→15 lines
3. [game/shared/resources/dialogues/act2_calming_draught.tres](game/shared/resources/dialogues/act2_calming_draught.tres) - 5→15 lines
4. [game/shared/resources/dialogues/act1_confront_scylla.tres](game/shared/resources/dialogues/act1_confront_scylla.tres) - 5→30 lines

---

## Effort Estimates Summary

| Task | Time | Complexity |
|------|------|------------|
| 1.1 Starter Seeds | 1h | Low |
| 1.2 Seed Selector UI | 3h | Medium |
| 1.3 Dialogue→Minigame | 2.5h | Medium |
| 1.4 Crop Textures | 1.5h | Low |
| 1.5 Minigame Rewards | 2h | Low |
| 2.0 Dialogue Writing (5 files) | 3-4h | Medium |
| 3.0 Extensibility Docs | 2h | Low |
| 4.0 Roadmap Update | 15min | Low |
| Testing & QA | 3h | Low |
| **TOTAL** | **18-20h** | **Medium** |

---

## Risk Mitigation

### Risk 1: Seed Selector Path Finding
**Issue:** farm_plot.gd needs to find UI/SeedSelector in scene tree

**Mitigation:** Use robust node path with fallback:
```gdscript
var ui = get_tree().root.get_node_or_null("World/UI/SeedSelector")
if not ui:
    ui = get_tree().root.find_child("SeedSelector", true, false)
```

### Risk 2: Minigame Scene Loading
**Issue:** Load() may fail if scene path wrong

**Mitigation:** Validate paths:
```gdscript
if not ResourceLoader.exists(scene_path):
    push_error("Minigame scene not found: %s" % scene_path)
    return
```

### Risk 3: Dialogue Too Long/Short
**Issue:** 30-minute target may be missed

**Mitigation:**
- Playtest after each dialogue expansion
- Keep prologue skippable (already flagged)
- Adjust line counts in confront_scylla (30-50 lines flexible)

---

## Success Criteria

Phase 4 is complete when:
- ✅ All 5 core wiring blockers resolved
- ✅ Farm loop works end-to-end (till → plant → grow → harvest)
- ✅ Dialogue triggers minigames and crafting
- ✅ Crops visible while growing (textures or modulate)
- ✅ 5 dialogue files expanded (herb ID, farming, crafting, confront, epilogue)
- ✅ Streamlined 30-minute playthrough functional
- ✅ Stub dialogues preserved for future expansion
- ✅ Documentation updated with missing setup step
- ✅ Extensibility architecture documented

---

## Answer to User's Question

**"Was the farm plot placement step in the roadmap?"**

**Answer:** No, it wasn't explicitly documented. The roadmap had:
- Section 1.3.1: Create FarmPlot scene and script
- Section 1.3.2: Write farm_plot.gd logic

But it **didn't have** a section for:
- Section 1.3.3: **Instance farm plots in world.tscn** (the missing step)

This is a **scene setup step** (using the Godot editor) rather than a code implementation task, which is why it fell through the cracks. The roadmap focused on writing code but didn't explicitly call out world scene configuration.

**Fix:** Part 4 of this plan adds documentation for this setup step to prevent future confusion.
