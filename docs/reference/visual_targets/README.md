# Visual Development Targets

**Purpose:** Clear visual reference for what the game should look like

**Reference Standard:** Harvest Moon SNES / Stardew Valley quality

**Location:** `docs/reference/visual_targets/`

---

## World Scene Target

### Reference: Harvest Moon Full Map
![Harvest Moon Full Map](harvest_moon_full_map.png)

**What Makes This Work:**
- **Grass:** Textured but NOT noisy - warm yellow-green with natural variation
- **Paths:** Organic dirt paths that blend naturally (soft edges)
- **Buildings:** Detailed architecture (windows, doors, roofs, decorations)
- **Vegetation:** Dense, purposeful placement - trees frame areas, bushes cluster
- **Color:** Warm, inviting palette with rich earth tones
- **Density:** Full, lived-in world with lots to look at

**Our Current Game Problems:**
- ❌ Grass has obvious **dithering/checkerboard pattern** (style guide violation!)
- ❌ Paths are gray rectangles with **hard, unnatural edges**
- ❌ Buildings are simple geometric boxes - no architectural detail
- ❌ Vegetation sparse and scattered randomly - doesn't frame anything
- ❌ Flat, uniform "computer green" - no warmth or depth

---

## Farm/Crop Area Target

### Reference: Harvest Moon Crops
![Harvest Moon Crops](harvest_moon_crops.jpg)

**What Makes This Work:**
- Tilled soil has texture and variation (not flat stripes)
- Crops clearly distinguishable at each growth stage
- Natural farm layout with connecting paths
- Environmental details integrated (rocks, fences)

---

## Building/Structure Target

### Reference: Stardew Valley Building
![Stardew Valley Building](stardew_valley_building.jpg)

**What Makes This Work:**
- Detailed architecture (windows, doors, roof details, clock, sign)
- Vegetation integrated with building (vines, bushes around base)
- Warm, inviting color palette
- Purposeful environmental framing (path leads to door)

---

## Style Guide Compliance Checklist

**CRITICAL RULES from HERAS_GARDEN_PALETTE.md:**

| Rule | Target | Current Problem |
|------|--------|-----------------|
| **No dithering** | Flat colors with variation | ❌ Grass uses checkerboard pattern |
| **Warm palette** | Earth tones | ❌ Computer green, flat |
| **Soft edges** | Natural blending | ❌ Hard rectangular path edges |
| **Building detail** | Windows, doors, decorations | ❌ Plain boxes |
| **Purposeful vegetation** | Frames areas, creates zones | ❌ Randomly scattered |
| **Visual density** | Lived-in, full | ❌ Empty, sterile |

---

## Success Criteria for Phase 8 Visual Polish

### P0 - CRITICAL (Must Fix Before Release)
1. **Fix grass dithering** - Replace with flat colors per palette
2. **Soften path edges** - Blend naturally into grass
3. **Warm color shift** - Move from computer green to earth tones

### P1 - IMPORTANT (Should Have)
4. **Building detail pass** - Add windows, doors, roof details
5. **Vegetation redesign** - Purposeful placement that frames areas
6. **Density increase** - Add environmental details

### P2 - POLISH (Nice to Have)
7. Atmospheric overlays per location
8. Ambient particle effects
9. UI theming to match aesthetic

---

## Quick Comparison

| Aspect | Target (Harvest Moon) | Current State |
|--------|----------------------|---------------|
| **Grass** | Warm, varied, natural | ❌ Dithered, flat, computer green |
| **Paths** | Organic, soft edges | ❌ Gray rectangles, hard edges |
| **Buildings** | Detailed architecture | ❌ Plain boxes |
| **Trees** | Frame areas, create zones | ❌ Randomly scattered |
| **Color** | Rich earth tones | ❌ Flat, cold |
| **Feel** | Lived-in, cozy | ❌ Empty, test-map |

**Bottom Line:** Current game looks like programmer art. Need significant work to reach Harvest Moon quality.

---

**Last Updated:** 2026-01-28  
**Reference Images:** Copied from `docs/reference/concept_art/`
