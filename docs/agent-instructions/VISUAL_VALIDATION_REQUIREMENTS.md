# Visual Validation Requirements (CRITICAL)

**Status:** REQUIRED READING for all visual work  
**Applies To:** Phase 8+ visual polish, asset validation, UI work

---

## The Golden Rule

> **Visual polish success criteria can ONLY be determined from actual rendered game screenshots captured via Papershot or Levelshot.**

**NEVER** assess visual quality from:
- ❌ Asset files alone (`.png`, `.tscn` files)
- ❌ Godot Editor screenshots (shows IDE/chrome)
- ❌ Sprite previews in file explorer
- ❌ Code analysis of scene files

**ALWAYS** assess from:
- ✅ Papershot captures (in-game F12)
- ✅ Levelshot renders (automated scene captures)
- ✅ MCP runtime screenshot commands
- ✅ Actual exported build screenshots

---

## Why This Matters

### The Screenshot Problem (Real Example - 2026-01-28)

Current screenshot inventory shows:
| Filename | Claims to Show | Actually Shows |
|----------|---------------|----------------|
| `scylla_cove.png` | Scylla Cove location | World scene |
| `sacred_grove.png` | Sacred Grove location | World scene (identical) |
| `aiaia_house_interior.png` | House interior | World scene (identical) |
| `world_main_map.png` | World map | World scene (identical) |

**All four "different location" screenshots are the SAME IMAGE.**

Without running the game and capturing proper screenshots, we cannot:
- Verify locations look different
- Assess visual composition
- Judge atmosphere/atmosphere
- Validate style guide compliance in-context

---

## Required Screenshot Types

### For World/Map Visuals (Phase 8)

**Required captures:**
1. **World overview** - Full map showing farming area, landmarks, paths
2. **World detail** - Close-up of player in world with UI visible
3. **Scylla Cove** - Must look different from world (dark, ominous)
4. **Sacred Grove** - Must look different from both (mystical, golden)
5. **House interior** - Indoor scene with furniture
6. **Dialogue active** - UI with dialogue box open
7. **Inventory open** - Inventory panel visible
8. **Minigame** - Any minigame in progress

### For UI Polish (Phase 8+)

**Required captures:**
1. Main menu
2. Dialogue with choices
3. Inventory screen
4. Crafting interface
5. Minigame UIs

### For Export Validation (Phase 9)

**Required captures:**
1. Exported build main menu
2. Exported build gameplay
3. All locations in exported build

---

## Capture Methods

### Method 1: Papershot (In-Game)

```gdscript
# Built into world.tscn - Press F12 while game is running
# Saves to: res://temp/screenshots/
# Configured in: game/features/world/world.tscn Papershot node
```

**Best for:** Manual capture during playtesting

### Method 2: Levelshot Plugin

```gdscript
# Use Levelshot tab in Godot Editor
# Select scenes to capture
# Automated batch capture
```

**Best for:** Capturing multiple scenes efficiently

### Method 3: MCP Runtime Capture

```bash
# Via MCP when game is running
npx -y godot-mcp-cli execute_editor_script --script "get_viewport().get_texture().get_image().save_png('res://temp/screenshots/capture.png')"
```

**Best for:** Automated testing workflows

### Method 4: Script-Based Batch

```gdscript
# Create capture script for all locations
tool
extends EditorScript

func _run():
    var scenes = [
        "res://game/features/world/world.tscn",
        "res://game/features/locations/scylla_cove.tscn",
        "res://game/features/locations/sacred_grove.tscn",
        "res://game/features/locations/aiaia_house.tscn"
    ]
    for scene_path in scenes:
        # Load scene, capture viewport, save
```

**Best for:** CI/CD integration

---

## Validation Checklist

Before claiming visual work is complete:

- [ ] Screenshots exist for ALL required views (see Required Screenshot Types)
- [ ] Screenshots show actual rendered game (not editor)
- [ ] File sizes differ (identical files = bug)
- [ ] Image content matches filename (world.png shows world, not menu)
- [ ] Captured within last work session (not stale/old screenshots)
- [ ] All locations visually distinct from each other

---

## Common Screenshot Bugs

| Bug | Symptom | Fix |
|-----|---------|-----|
| Duplicate images | All screenshots identical | Check scene transitions, verify different scenes loaded |
| Editor capture | Shows Godot IDE | Use --headless or game build, not editor |
| Black screens | Solid black images | Check if game actually rendering, lighting present |
| Wrong location | Filename doesn't match content | Verify scene path, check save logic |

---

## Documentation Requirements

All visual assessment reports MUST include:

```markdown
### Screenshot Evidence
| Requirement | Screenshot File | Status |
|-------------|-----------------|--------|
| World scene | `temp/screenshots/world_2026-01-28.png` | ✅ Captured |
| Scylla Cove | `temp/screenshots/scylla_cove_2026-01-28.png` | ❌ Missing |

### Visual Issues Found (with screenshot proof)
1. **Grass dithering** - See world_2026-01-28.png, area (100, 200)
2. **Flat lighting** - See scylla_cove_2026-01-28.png
```

---

## Visual Development Targets

Study these BEFORE any visual work:

📁 `docs/reference/visual_targets/`
- `harvest_moon_full_map.png` - World scene quality target
- `harvest_moon_crops.jpg` - Farm area quality target  
- `stewdew_valley_building.jpg` - Building detail target
- `README.md` - Full comparison and success criteria

**Why this matters:** We discovered current game looks like "programmer art" vs target "Harvest Moon quality". Don't guess what good looks like - reference the images.

---

## Related Documentation

- `AGENTS.md` - Session rules including visual validation
- `CLAUDE.md` - Project-specific visual requirements
- `docs/reference/concept_art/HERAS_GARDEN_PALETTE.md` - Style guide
- `docs/execution/DEVELOPMENT_ROADMAP.md` - Phase requirements
- `.claude/skills/visual-validation/SKILL.md` - Quick reference skill

---

**Enforcement:** Any visual polish claim without screenshot evidence will be rejected.
