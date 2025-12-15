# HERA'S GARDEN V2 - PROJECT STRUCTURE

**Purpose:** Define the canonical folder organization and file placement rules.

---

## FOLDER TREE

```
v2_heras_garden/
│
├── project.godot                  # Godot project config (AUTOLOADS REGISTERED HERE)
├── icon.svg                       # Godot project icon
├── .gitignore                     # Git ignore rules
│
├── CONSTITUTION.md                # ⚠️  Immutable technical rules
├── SCHEMA.md                      # ⚠️  Data structure definitions
├── PROJECT_STRUCTURE.md           # This file
├── DEVELOPMENT_WORKFLOW.md        # Guide for agentic coders
├── PROJECT_STATUS.md              # Current phase and completion status
├── README.md                      # Project overview
│
├── src/                           # ALL GDSCRIPT CODE GOES HERE
│   ├── autoloads/                 # Singleton scripts only
│   │   ├── game_state.gd          # Central state management
│   │   ├── audio_controller.gd    # Sound/music controller
│   │   └── save_controller.gd     # Save/load system
│   │
│   ├── resources/                 # Resource class definitions (.gd)
│   │   ├── crop_data.gd           # CropData class
│   │   ├── item_data.gd           # ItemData class
│   │   ├── dialogue_data.gd       # DialogueData class
│   │   └── npc_data.gd            # NPCData class
│   │
│   ├── entities/                  # Game object scripts
│   │   ├── player.gd              # Player controller
│   │   ├── farm_plot.gd           # Individual farm plot
│   │   ├── npc.gd                 # NPC base behavior
│   │   └── interactable.gd        # Base interactable class
│   │
│   └── ui/                        # UI scripts
│       ├── inventory_ui.gd        # Inventory panel
│       ├── dialogue_box.gd        # Dialogue display
│       └── main_menu.gd           # Main menu
│
├── scenes/                        # ALL .TSCN FILES GO HERE
│   ├── ui/
│   │   ├── main_menu.tscn
│   │   ├── hud.tscn
│   │   ├── inventory_panel.tscn
│   │   └── dialogue_box.tscn
│   │
│   ├── entities/
│   │   ├── player.tscn
│   │   ├── farm_plot.tscn
│   │   └── npc.tscn
│   │
│   └── world.tscn                 # Main game world
│
├── resources/                     # ALL .TRES DATA FILES GO HERE
│   ├── crops/                     # CropData resources
│   │   ├── wheat.tres
│   │   ├── tomato.tres
│   │   └── carrot.tres
│   │
│   ├── items/                     # ItemData resources
│   │   ├── wheat_seed.tres
│   │   ├── wheat.tres
│   │   ├── watering_can.tres
│   │   └── hoe.tres
│   │
│   ├── dialogues/                 # DialogueData resources
│   │   ├── medusa_intro.tres
│   │   ├── medusa_daily.tres
│   │   └── hera_monologue.tres
│   │
│   └── npcs/                      # NPCData resources
│       ├── medusa.tres
│       └── demeter.tres
│
├── assets/                        # RAW ASSET FILES (sprites, audio, fonts)
│   ├── sprites/
│   │   ├── characters/
│   │   │   ├── hera_spritesheet.png
│   │   │   └── medusa_spritesheet.png
│   │   ├── crops/
│   │   │   ├── wheat_stages.png
│   │   │   └── tomato_stages.png
│   │   ├── tiles/
│   │   │   ├── grass_tileset.png
│   │   │   └── farm_tileset.png
│   │   └── ui/
│   │       ├── inventory_slot.png
│   │       └── dialogue_box.png
│   │
│   ├── audio/
│   │   ├── music/
│   │   │   ├── main_theme.ogg
│   │   │   └── night_theme.ogg
│   │   └── sfx/
│   │       ├── plant_seed.wav
│   │       ├── harvest.wav
│   │       └── footstep.wav
│   │
│   └── fonts/
│       └── main_font.ttf
│
├── _docs/                         # DOCUMENTATION (markdown)
│   ├── STORYLINE.md               # Complete narrative script
│   ├── HARDWARE.md                # Target device specs (Retroid Pocket)
│   ├── POSTMORTEM_V1.md           # Lessons learned from V1
│   └── API_REFERENCE.md           # Code API documentation
│
└── tests/                         # TEST SCRIPTS
    ├── run_tests.gd               # Main test runner
    ├── test_autoloads.gd          # Autoload existence tests
    ├── test_resources.gd          # Resource loading tests
    └── test_game_state.gd         # GameState logic tests
```

---

## FILE PLACEMENT RULES

### Rule 1: Scripts vs Scenes vs Data

| Type | Extension | Location | Example |
|------|-----------|----------|---------|
| Script | .gd | `src/` | `src/entities/player.gd` |
| Scene | .tscn | `scenes/` | `scenes/entities/player.tscn` |
| Data | .tres | `resources/` | `resources/crops/wheat.tres` |
| Asset | .png/.wav/.ttf | `assets/` | `assets/sprites/tiles/grass.png` |

### Rule 2: Script Attachment

**Scene files (.tscn) DO NOT contain embedded scripts.**

Every scene references its script via path:

```
[node name="Player" type="CharacterBody2D"]
script = ExtResource("res://src/entities/player.gd")
```

### Rule 3: Resource Loading

All .tres files load their class definition:

```
[gd_resource type="CropData" load_steps=5 format=3]
[ext_resource type="Script" path="res://src/resources/crop_data.gd"]
```

### Rule 4: Autoload Paths

Autoloads reference `src/autoloads/*.gd`:

```ini
[autoload]
GameState="*res://src/autoloads/game_state.gd"
```

---

## NAMING CONVENTIONS

### Files

| Type | Convention | Example |
|------|------------|---------|
| Scripts | `snake_case.gd` | `game_state.gd` |
| Scenes | `snake_case.tscn` | `farm_plot.tscn` |
| Resources | `snake_case.tres` | `wheat.tres` |
| Assets | `descriptive_name.png` | `hera_spritesheet.png` |

### Classes

```gdscript
class_name CropData  # PascalCase
```

### Variables

```gdscript
var current_day: int = 1          # snake_case
const TILE_SIZE: int = 32         # SCREAMING_SNAKE_CASE
```

### Functions

```gdscript
func add_item(item_id: String) -> void:  # snake_case
```

### Signals

```gdscript
signal inventory_changed(item_id: String)  # snake_case
```

### Node Names

```
Player              # PascalCase
Sprite              # PascalCase
CollisionShape2D    # Match Godot type names
```

---

## IMPORT PATTERNS

### Loading Resources

```gdscript
# Preload (compile-time)
const WHEAT_DATA: CropData = preload("res://resources/crops/wheat.tres")

# Load (runtime)
var crop: CropData = load("res://resources/crops/wheat.tres")

# Via GameState registry
var crop: CropData = GameState.get_crop_data("wheat")
```

### Instancing Scenes

```gdscript
# Preload scene
const FARM_PLOT_SCENE = preload("res://scenes/entities/farm_plot.tscn")

# Instance at runtime
var plot = FARM_PLOT_SCENE.instantiate()
add_child(plot)
```

### Accessing Autoloads

```gdscript
# Direct access (autoloads are global)
GameState.add_item("wheat", 1)
AudioController.play_sfx("harvest")
SaveController.save_game()
```

---

## PHASE-BASED FILE CREATION

### Phase 0: Foundation
**Goal:** Set up structure, no runtime code yet.

**Files to Create:**
```
✅ CONSTITUTION.md
✅ SCHEMA.md
✅ PROJECT_STRUCTURE.md
✅ DEVELOPMENT_WORKFLOW.md
✅ PROJECT_STATUS.md
✅ project.godot (with autoloads registered)
✅ src/autoloads/*.gd (all three)
✅ src/resources/*.gd (class definitions only)
✅ .gitignore
```

### Phase 1: Core Loop
**Goal:** Player can plant and harvest one crop.

**Files to Create:**
```
□ src/entities/player.gd
□ scenes/entities/player.tscn
□ src/entities/farm_plot.gd
□ scenes/entities/farm_plot.tscn
□ scenes/world.tscn (with TileMapLayer)
□ resources/crops/wheat.tres
□ resources/items/wheat_seed.tres
□ resources/items/wheat.tres
□ assets/sprites/crops/wheat_stages.png (placeholder)
□ assets/sprites/tiles/grass_tileset.png (placeholder)
```

### Phase 2: Persistence
**Goal:** Save and load game state.

**Files to Enhance:**
```
□ src/autoloads/save_controller.gd (implement save/load)
□ tests/test_save_load.gd
```

### Phase 3: Content Expansion
**Goal:** Multiple crops, NPCs, dialogue.

**Files to Create:**
```
□ resources/crops/tomato.tres
□ resources/crops/carrot.tres
□ src/entities/npc.gd
□ scenes/entities/npc.tscn
□ resources/npcs/medusa.tres
□ resources/dialogues/medusa_intro.tres
□ src/ui/dialogue_box.gd
□ scenes/ui/dialogue_box.tscn
```

### Phase 4: Polish
**Goal:** UI, audio, balance.

**Files to Create:**
```
□ src/ui/inventory_ui.gd
□ scenes/ui/inventory_panel.tscn
□ scenes/ui/hud.tscn
□ assets/audio/sfx/*.wav
□ assets/audio/music/*.ogg
```

---

## GITIGNORE RULES

```gitignore
# Godot 4+ generated files
.godot/

# Exported builds
build/
export/

# OS generated
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log
```

---

## QUICK CHECKLIST: BEFORE CREATING ANY FILE

```
□ What type is it? (script/scene/data/asset)
□ What folder does it belong in?
□ Does it follow naming conventions?
□ Is it needed for the CURRENT phase?
□ Are its dependencies already created?
```

---

**End of PROJECT_STRUCTURE.md**
