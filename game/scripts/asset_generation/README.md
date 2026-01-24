# Procedural Asset Generator

## Mini-Agent Evaluation (For Reference)

**Status:** Evaluated but NOT recommended for this use case

**What is Mini-Agent?**
- Standalone agent framework using MiniMax M2.1 model
- 15 built-in professional skills (PDF, design, testing, development)
- Persistent memory via Session Note Tool
- MCP tool integration built-in

**When to Use:**
- ✅ Autonomous task execution (long-running tasks)
- ✅ File system + shell operations
- ✅ Automated testing runs
- ❌ Visual asset creation (overkill for this purpose)

**Verdict:** Skip for visual asset work. MiniMax MCP + Cursor's Task tool is sufficient.

**Installation (if needed later):**
```bash
uv tool install git+https://github.com/MiniMax-AI/Mini-Agent.git
```

---

## How to Use

### Method 1: Run in Godot Editor (Recommended)

**Generate Tiles:**
1. Open Godot 4.5.1
2. Open `game/scripts/asset_generation/tile_generator_runner.tscn`
3. Press F6 to run the scene
4. Tiles generated in `game/textures/tiles/`

**Generate Sprites:**
1. Open Godot 4.5.1
2. Open `game/scripts/asset_generation/sprite_generator_runner.tscn`
3. Press F6 to run the scene
4. Spritesheets generated in `game/textures/sprites/`

### Method 2: Run from Command Line (Headless)
```bash
# Tiles
.\Godot*.exe --headless --script game/scripts/asset_generation/tile_generator.gd

# Sprites
.\Godot*.exe --headless --script game/scripts/asset_generation/sprite_generator.gd
```

---

## Generated Tiles

| Tile | Size | Description |
|------|------|-------------|
| `grass_procedural.png` | 16x16 | Green grass with Perlin noise texture |
| `dirt_procedural.png` | 16x16 | Brown dirt with small pebbles |
| `stone_procedural.png` | 16x16 | Gray stone path with brick pattern |
| `water_procedural.png` | 16x16 | Blue water with wave pattern |

---

## Generated Sprites (Harvest Moon SNES Style)

Based on Harvest Moon SNES spritesheet analysis:

| Character | Size | Frames | Style |
|-----------|------|--------|-------|
| `hermes_spritesheet.png` | 16x24 | 4 directions (down, left, up, right) | Blonde hair, orange shirt |
| `aeetes_spritesheet.png` | 16x24 | 4 directions | Gray hair, gold shirt |
| `daedalus_spritesheet.png` | 16x24 | 4 directions | Brown hair, blue shirt |
| `scylla_spritesheet.png` | 16x24 | 4 directions | Orange hair, purple shirt |
| `circe_spritesheet.png` | 16x24 | 4 directions | Orange hair, pink shirt |

**Style Characteristics:**
- Chibi proportions (large head, small body)
- Dark gray outlines (#404040)
- Cell shading with 2-3 shades per color
- SNES color palette (limited, saturated colors)

---

## Customization

### Tile Generator
Edit `tile_generator.gd` to adjust:
- `TILE_SIZE` - Default: 16 pixels
- Noise parameters (frequency, seed)
- Colors in each tile generation function

### Sprite Generator
Edit `sprite_generator.gd` to adjust:
- Color palettes ( COLORS dictionary)
- Character proportions
- Hair/clothing colors for each NPC

---

## Using Generated Assets

### TileSet Configuration

**Location:** `game/shared/resources/tiles/procedural_tiles.tres`

**Tile Sources (4 total):**
- Source 0: Grass (source_id=0) - Walkable with collision
- Source 1: Dirt (source_id=1) - Walkable with collision
- Source 2: Stone (source_id=2) - Walkable with collision
- Source 3: Water (source_id=3) - No collision (swim/impassable)

**How to Paint Tiles:**
1. Open `game/features/world/world.tscn` in Godot Editor
2. Select the `Ground` TileMapLayer node
3. In the bottom panel, select the TileSet tab
4. Choose a tile from the 4 available sources
5. Paint on the tilemap

**Note:** The world scene has been updated to use the new 16x16 procedural TileSet.

### Spritesheet Usage

**Location:** `game/textures/sprites/*.png`

Each spritesheet contains 4 frames arranged horizontally:
- Frame 0: Facing down
- Frame 1: Facing left
- Frame 2: Facing up
- Frame 3: Facing right

**To use in AnimatedSprite2D:**
1. Create AnimatedSprite2D node
2. Create SpriteFrames resource
3. Add animation "walk"
4. Add 4 frames from spritesheet (use hflip/flip for opposite direction if needed)
5. Set FPS to 6-8 for walk cycle

---

## Phase 1 Status

✅ **COMPLETED:**
- NPC spacing fixed (64px → 160px apart)
- Tile generator created (4 procedural tiles: grass, dirt, stone, water)
- Sprite generator created (5 Harvest Moon SNES-style spritesheets)
- TileSet resource configured with collision shapes
- World scene updated to use new TileSet

**Next Steps (Phase 1+):**
- Test tiles in-game by running the project (F5)
- Paint additional tile variety using the TileMap editor
- Use MiniMax MCP `understand_image` for screenshot validation
