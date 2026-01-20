# Remaining Game Work Before Android Build

**Document Created:** 2025-12-30
**Purpose:** Track what needs to be done before the game is ready for Android export

---

## Game Loop Completion

### Quest System

| Quest | Status | Notes |
|-------|--------|-------|
| Quest 1: Herb Identification | ✅ Complete | Minigame works |
| Quest 2: Farm Tutorial | ✅ Complete | Planting/growing |
| Quest 3: Crafting Ritual | ✅ Complete | Calming draught |
| Quest 4: Moon Tears | ✅ Complete | Minigame |
| Quest 5: Sacred Earth | ✅ Complete | Minigame |
| Quest 6: Binding Ward | ✅ Complete | Requires moon tear + sacred earth |
| Quest 7: Weaving | ✅ Complete | Minigame |
| Quest 8: Reversal Elixir | ✅ Complete | Weaving + ingredients |
| Quest 9: Petrification Potion | ✅ Complete | Final potion |
| Quest 10: Scylla Confrontation | ✅ Complete | Transformation |
| Quest 11: Epilogue | ✅ Complete | Final dialogue |

### Story & Dialogue

| Element | Status | Notes |
|---------|--------|-------|
| Prologue | ✅ Complete | Opening cutscene |
| Act 1 | ✅ Complete | Hermes + farming |
| Act 2 | ✅ Complete | Aeetes + Daedalus |
| Act 3 | ✅ Complete | Scylla + transformation |
| Epilogue | ✅ Complete | Ending choice |
| **All 19 dialogues** | ✅ Complete | Referenced in ROADMAP |

---

## Art Assets Needed

### Required Before Release

| Category | Items | Priority |
|----------|-------|----------|
| Player sprite (Circe) | 1 (64x64, animated) | HIGH |
| Player animations | idle, walk, interact | HIGH |
| UI icons | Inventory slots, buttons | MEDIUM |
| Main menu background | Full screen | MEDIUM |
| Dialogue portraits | All 5 NPCs + player | MEDIUM |
| Minigame backgrounds | Herb ID, Moon Tears, Sacred Earth, Weaving | MEDIUM |
| Sound effects | Harvest, plant, UI, minigame feedback | MEDIUM |
| Background music | Menu, world, locations | LOW |

### Current Placeholders

| Asset | Status | Replace With |
|-------|--------|--------------|
| 37 HQ sprites | ✅ Generated | Production art |
| NPC sprites | ⚠️ Standardized | Final character art |
| Grass tile | ✅ Seamless | Production tile |
| Crop stages | ✅ Generated | Production crops |

---

## Polish Items

### High Priority

- [ ] **Player movement feel** - Test on device, adjust speed/friction
- [ ] **D-pad sensitivity** - Ensure precise control on Retroid
- [ ] **Minigame timing** - Verify fair difficulty on physical buttons
- [ ] **UI touch blocking** - Ensure touch input disabled for D-pad only

### Medium Priority

- [ ] **Audio balance** - Music vs SFX levels
- [ ] **Visual feedback** - Harvest particles, success effects
- [ ] **Loading screens** - Add if scene transitions are slow
- [ ] **Save/load feedback** - Visual indicator when saving

### Low Priority

- [ ] **Credits screen** - Add to main menu
- [ ] **About screen** - Version info, special thanks
- [ ] **Options menu** - Volume control, brightness
- [ ] **Controller remapping** - If button mapping needs adjustment

---

## Technical Debt

### Known Issues (Non-Blocking)

| Issue | Severity | Notes |
|-------|----------|-------|
| Invalid UID warning (#4) | ✅ FIXED | `uid://player_scene_001` now used |
| Crop growth visual | ✅ FIXED | Added animations for till, plant, water, harvest |
| Particle effects | ✅ ADDRESSED | Added tween-based visual feedback (no external dependency) |

---

## Testing Requirements

### Before Android Build

- [ ] **Full playthrough test** (30+ minutes on device)
- [ ] **D-pad only validation** - No touch required anywhere
- [ ] **Frame rate check** - Target 60fps, minimum 30fps
- [ ] **Battery drain test** - 1 hour session
- [ ] **Soft-lock verification** - All minigames re-attemptable
- [ ] **Save/load across sessions** - Verify persistence

### Device-Specific Testing

| Test | Retroid Pocket Classic |
|------|------------------------|
| D-pad navigation | Must work in all menus |
| A/B button mapping | Interact, confirm, cancel |
| Start/Select | Inventory, pause |
| Battery indicator | Normal drain |
| Heat test | 30+ minute session |
| Screen scaling | Proper aspect ratio |

---

## Content Gaps

### Missing Features (Not Currently Implemented)

| Feature | Complexity | Notes |
|---------|------------|-------|
| Shop system | MEDIUM | Buy/sell crops, seeds |
| Multiple save slots | LOW | Currently single slot |
| Achievements | LOW | Could add post-launch |
| Controller settings UI | LOW | Button remapping |
| Quest journal | MEDIUM | Track active quests |
| Mini-map | LOW | World navigation aid |

### Narrative Gaps

| Element | Status |
|---------|--------|
| Circe's transformation dialogue | ✅ Complete |
| Multiple endings | ⚠️ Single ending (choice affects flavor text) |
| Hidden secrets | ❌ None currently |
| Optional dialogue | ⚠️ Limited branching |

---

## Export Readiness Checklist

Before attempting Android build:

- [ ] All 123 automated tests pass
- [ ] Full playthrough completes without errors
- [ ] Player sprite animated and integrated
- [ ] All UI touch input blocked/disabled
- [ ] D-pad tested on target hardware
- [ ] Minigame timing balanced for physical buttons
- [ ] Audio implemented (placeholder or final)
- [ ] Version number set in `project.godot`
- [ ] Package name finalized
- [ ] Export templates downloaded

---

## Estimated Effort

| Category | Estimated Time |
|----------|---------------|
| Player sprite + animations | 2-4 hours |
| UI polish | 1-2 hours |
| Audio implementation | 1-2 hours |
| Device testing + tuning | 2-4 hours |
| Bug fixes from testing | Variable |

**Total:** ~6-12 hours of focused work

---

## Next Actions

1. **Prioritize** - What matters most for the gift recipient?
2. **Player sprite** - Circe needs to look good
3. **Audio** - Feedback sounds make gameplay feel better
4. **Device test** - Validate D-pad controls on Retroid

---

*Last Updated: 2025-12-30*
