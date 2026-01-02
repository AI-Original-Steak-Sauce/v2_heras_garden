# Implementation Plan: Beta Mechanical Visual Testing (Quest 1-6 Extension)

## Overview
- Maintain the beta mechanical playthrough test at `tests/visual/beta_mechanical_test.gd` using the PNG->ASCII harness, with Quest 1-3 treated as the baseline.
- Use a CLI-first, test-and-fix loop so gameplay aligns with `docs/mechanical_walkthrough.md`, while keeping output consistent for PNG and ASCII analysis.
- Extend the harness to cover Quest 4-6 checkpoints, with step-level captures, expected mechanics, and fix guidance.

## Context
| Source | Why it matters |
| --- | --- |
| tests/visual/beta_mechanical_test.gd | Current Quest 1-3 harness and capture pipeline. |
| docs/mechanical_walkthrough.md | Expected Quest 4-6 flow, mechanics, and dialogue order. |
| game/features/world/world.gd | World wiring for farm plots, quest markers, and crafting station. |
| game/features/farm_plot/farm_plot.gd | Till/plant/water/harvest transitions for Quest 4. |
| game/autoload/game_state.gd | Crop growth timing and inventory updates. |
| game/features/ui/seed_selector.gd | Seed UI behavior and inventory-driven choices. |
| game/features/ui/crafting_controller.gd | Recipe-driven crafting UI for Quest 5-6. |
| game/features/minigames/sacred_earth.gd | Sacred Earth minigame logic and debug completion helper. |
| game/shared/resources/recipes/calming_draught.tres | Quest 5 crafting inputs and outputs. |
| game/shared/resources/recipes/reversal_elixir.tres | Quest 6 crafting inputs and outputs. |
| game/shared/resources/dialogues/quest4_start.tres | Quest 4 activation dialogue. |
| game/shared/resources/dialogues/act2_farming_tutorial.tres | Quest 4 completion dialogue. |
| game/shared/resources/dialogues/quest5_start.tres | Quest 5 activation dialogue. |
| game/shared/resources/dialogues/act2_calming_draught.tres | Quest 5 completion dialogue. |
| game/shared/resources/dialogues/quest6_start.tres | Quest 6 activation dialogue. |
| game/shared/resources/dialogues/act2_reversal_elixir.tres | Quest 6 completion dialogue. |

## Design Decisions
### Option A: Linear SceneTree harness (recommended)
- Extend the current SceneTree flow with Quest 4-6 steps appended after Quest 3.
- Pros: follows the existing pattern and reuse of `capture_and_convert`.
- Cons: the file grows, so step-level logging should stay explicit.

### Option B: Modular per-quest scripts
- Split each quest into its own script and orchestrate from a runner.
- Pros: smaller files for each quest, reusable for partial runs.
- Cons: higher setup cost and extra plumbing before Quest 4-6 are stable.

Recommendation: continue with Option A until Quest 6 is stable and the harness no longer needs frequent edits.

## Proposed Implementation Phases
### Phase 1: Confirm Quest 1-3 baseline (already validated)
Objective: keep the validated Quest 1-3 flow intact and avoid regressions.
Tasks:
- Run the CLI test and confirm Quest 1-3 captures still render correctly.
- Keep `.godot/screenshots/beta_mechanical/` as the baseline reference.
Success Criteria: Quest 1-3 outputs remain comparable and the harness exits with code 0.

### Phase 2: Autonomous CLI test-and-fix loop
Objective: use a repeatable, hands-free process for long runs.
Tasks:
- Run the CLI script and tee output into a log file for later review.
- Inspect captures and logs for mismatches with the mechanical walkthrough.
- Apply fixes in game code or the harness, then re-run the CLI test to validate.
- Commit changes in regular chunks (for example: after a stable quest cluster).
Success Criteria: each fix is verified by a rerun and captured evidence is retained.

### Phase 3: Extend the harness for Quest 4-6
Objective: implement Quest 4-6 checkpoints and validate mechanics, visuals, and flags.
Tasks:
- Append Quest 4-6 steps in `tests/visual/beta_mechanical_test.gd`.
- Capture PNG+ASCII in `.godot/screenshots/full_playthrough/quest_04/`, `quest_05/`, and `quest_06/`.
- Verify inventory and quest flags after each quest completes.
Success Criteria: Quest 4-6 steps run to completion and outputs show distinct visual states.

### Phase 4: Document methodology and blockers
Objective: keep a running record for future quest extensions and speed up debugging.
Tasks:
- Update `.godot/screenshots/full_playthrough/TESTING_METHODOLOGY.md` with findings.
- Record blockers and friction points for review by senior engineers.
Success Criteria: the methodology doc includes the latest blockers and fixes.

## Quest 4-6 Expected Behavior and Checkpoints
### Quest 4: Build a Garden
Expected mechanics:
- Quest 4 starts after `quest_3_complete` via `quest4_start` dialogue.
- Player tills farm plots, plants seeds, waters, advances days twice, and harvests.
Expected visuals:
- Tilled soil appears, seed selector UI shows seed buttons, watered crops tint blue.
- Mature crops show growth sprites, harvest plays a pulse and inventory increments.
Suggested checkpoints:
- Quest 4 start dialogue visible (Aeetes).
- Tilled plots visible in farm grid.
- Seed selector panel open with at least one seed button.
- Planted crop sprites visible.
- Watered tint visible.
- After two day advances, harvestable crops visible.
- Harvest animation and inventory count changes.
Fix guidance if broken:
- Seed selector not opening: check `game/features/world/world.gd` seed selector wiring and `game/features/ui/seed_selector.gd`.
- Crops not growing: verify `game/autoload/game_state.gd` `_update_all_crops` logic.
- Harvest not adding items: verify `farm_plot.gd:harvest` and `game_state.gd:harvest_crop`.

### Quest 5: Calming Draught
Expected mechanics:
- Quest 5 starts after `quest_4_complete` via `quest5_start` dialogue.
- Crafting uses `calming_draught` recipe: consumes moly + pharmaka_flower, produces calming_draught_potion.
- Quest 5 completion via `act2_calming_draught` dialogue sets `quest_5_complete`.
Expected visuals:
- Crafting UI shows the grinding pattern and timing indicator.
- Inventory reflects the new potion item after success.
Suggested checkpoints:
- Quest 5 start dialogue visible (Aeetes).
- Crafting UI open and pattern input accepted.
- Inventory shows `calming_draught_potion` and reduced ingredients.
- Quest 5 completion dialogue visible.
Fix guidance if broken:
- Crafting UI not opening: check `game/features/world/world.gd` mortar wiring and `CraftingController`.
- Inventory not updating: verify `game/features/ui/crafting_controller.gd:_on_crafting_complete`.
- Dialogue not advancing: check `npc_base.gd` routing and dialogue flags.

### Quest 6: Reversal Elixir
Expected mechanics:
- Quest 6 starts after `quest_5_complete` via `quest6_start` dialogue.
- Sacred Earth minigame grants `sacred_earth` items; reversal elixir craft consumes moly, nightshade, moon_tear.
- Quest 6 completion via `act2_reversal_elixir` dialogue sets `quest_6_complete`.
Expected visuals:
- Sacred Earth minigame UI with progress bar and timer.
- Crafting UI shows reversal elixir pattern and button sequence.
Suggested checkpoints:
- Quest 6 start dialogue visible (Aeetes).
- Sacred Earth minigame visible and completes with reward items.
- Crafting UI open and pattern input accepted.
- Inventory shows `reversal_elixir_potion` and reduced ingredients.
- Quest 6 completion dialogue visible.
Fix guidance if broken:
- Minigame inaccessible: consider instantiating `game/features/minigames/sacred_earth.tscn` in the harness.
- Moon tear count missing: verify item registry and test inventory setup.
- Reversal elixir crafting fails: verify recipe data in `reversal_elixir.tres` and controller wiring.

## Autonomous CLI Workflow (Recommended)
1. Run the beta mechanical test via CLI, tee output to a log file.
2. Review log output, PNG, and ASCII files for mismatches.
3. Apply fixes in game code or harness as needed.
4. Re-run the CLI test to confirm fixes.
5. Commit changes in regular chunks to reduce lost work risk.

## Current Friction Points / Blockers
- Quest 2 dialogue routing is skipped in `npc_base.gd`, so the harness uses `DialogueBox.start_dialogue("quest2_start")`.
- Crafting station wiring required additional world-level plumbing; this is now in `game/features/world/world.gd`, but it may need updates for future quests.
- `transformation_sap` is not in the item registry, so Quest 2 inventory checks use a substitute recipe.
- VS Code Godot Tools debugging cannot be driven from this environment; CLI logs are the primary automation path.
- Crafting entry captures for Quest 5/6 sometimes show the dark world view without visible minigame UI; PNGs and ASCII (all spaces) suggest the UI is not rendered at capture time.
- Crafting minigame nodes can become invalid or not visible mid-input; logs show `_crafting_minigame_instance` dropping after the first input even when crafting still completes.
- CLI runs can exit with resource leak warnings, which currently return a non-zero exit code.

## Success Criteria
### Automated Verification
- [ ] The CLI run exits with code 0 after Quest 1-6 steps.
- [ ] Quest 4-6 steps generate PNG+ASCII pairs in their respective output folders.
- [ ] Crafting checks reflect recipe-driven inventory changes.

### Manual Verification
- [ ] Farming captures show tilled, planted, watered, and harvestable visuals.
- [ ] Potion crafting captures show the UI and step transitions.
- [ ] Methodology notes capture fixes and blockers for Quest 4-6.

## Next Steps
1. Add Quest 4-6 steps to `tests/visual/beta_mechanical_test.gd`.
2. Run CLI test and verify new output folders.
3. Apply fixes and re-run until Quest 4-6 checkpoints are stable.
4. Update methodology and blockers notes.

Edit Signoff: [Codex - 2026-01-02]
