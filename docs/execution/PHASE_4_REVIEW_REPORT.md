# Phase 4 Readiness Review Report

Date: 2025-12-21
Author: Jr Eng Codex
Audience: Sr Engineer
Source of truth: docs/execution/ROADMAP.md

## Executive Summary
- Phase status alignment completed: CONTEXT.md and README.md now match ROADMAP (Phase 4 Prototype ready to start).
- Phase 4 can start, but there are blocking documentation gaps, schema mismatches in scenes, and missing audio/content placeholders that should be addressed early in Phase 4.

## Key Findings (Priority Order)

### 1) Missing or inconsistent governance docs (High)
- docs/execution/PROJECT_STATUS.md: **RESOLVED** (Created).
- docs/design/CONSTITUTION.md: **RESOLVED** (Created).
- docs/execution/PHASE_4_FINAL.md: missing (replaced by PHASE_4_PROTOTYPE.md and PHASE_5_POLISH.md).
- Phase status drift prior to alignment: CONTEXT.md and README.md did not match ROADMAP.

Impact:
- Onboarding and enforcement of guardrails is inconsistent; agents cannot comply with missing rules and status docs.

### 2) Schema mismatches in required scene structures (High)
Per docs/design/SCHEMA.md required nodes are not fully aligned:
- game/features/player/player.tscn uses `CollisionShape2D` and `Camera2D` instead of `Collision` and `Camera`.
- game/features/farm_plot/farm_plot.tscn uses `SoilSprite` instead of `TilledSprite`.
- game/features/world/world.tscn is missing the `FarmArea` TileMapLayer.

Impact:
- Any code or future tests keyed to schema paths will break; risk of runtime null references.

### 3) Phase 4 content gaps vs ROADMAP and Storyline (High)
- Dialogue resources are a small subset vs Storyline requirements; game/shared/resources/dialogues lacks full content coverage.
- Audio integration is empty: assets/audio/music and assets/audio/sfx contain only .gitkeep.
- MCP runtime check logged missing SFX: `ui_move` (plus Phase 3 list already noted in ROADMAP: ui_open, ui_close, catch_chime, urgency_tick, failure_sad).

Impact:
- Phase 4 goals (content + balance + audio + playtesting) cannot be met without content and placeholder audio.

### 4) Scene wiring and documentation gaps (Medium)
- game/features/minigames/moon_tear_single.tscn has no script; this is likely intentional but must be listed in ROADMAP Current Phase Status per PROJECT_STRUCTURE.md.
- NPC instance scenes (scylla.tscn, hermes.tscn, daedalus.tscn, aeetes.tscn) use npc_base.tscn and do not attach scripts directly; also should be noted in ROADMAP Current Phase Status if intentional.

Impact:
- Violates documented structure rules; makes it unclear if scenes are intentionally scriptless or incomplete.

### 5) Unused dialogue resource (Low)
- game/shared/resources/dialogues/act3_ultimate_crafting.tres is not referenced by quest triggers or code.

Impact:
- Possible dead content or missing quest trigger wiring.

### 6) Minor hygiene (Low)
- game/autoload/save_controller.gd comment references non-existent src/core/constants.gd (constants live in game/autoload/constants.gd).
- game/autoload/game_state.gd hardcodes starting gold 100 instead of using Constants.STARTING_GOLD.
- CI only runs guard-project-godot.yml; no automated tests in CI (tests run manually were 5/5).

## Review Checks Performed
- Headless tests: PASS 5/5 via Godot headless.
- MCP runtime smoke check: Project launched to main menu; only missing SFX warning observed.

## Recommended Phase 4 Actions (Sequenced)
1) Restore or create missing governance docs (PROJECT_STATUS.md, CONSTITUTION.md) or update agent guidance to point to the correct canonical docs.
2) Fix schema mismatches in player/farm_plot/world scenes to align with SCHEMA.md.
3) Add placeholder audio assets and map SFX calls to avoid runtime warnings.
4) Expand dialogue resources per Storyline and wire quest/dialogue flow for full coverage.
5) Update ROADMAP Current Phase Status to list intentionally scriptless scenes.
6) Wire or remove act3_ultimate_crafting.tres based on narrative plan.
7) Add CI job to run tests/run_tests.gd (optional but recommended).

## Files Touched During Review
- docs/execution/ROADMAP.md (phase status alignment)
- CONTEXT.md (phase status alignment)
- README.md (phase status alignment)
- RUNTIME_STATUS.md (local snapshot update)

## Open Questions for Sr Engineer
- Should docs/design/CONSTITUTION.md be restored from archive, or is CONTEXT.md now the canonical replacement?
- Is Phase 4 intended to be prototype-only (per PHASE_4_PROTOTYPE.md) or content-final (per older outlines)?

End of report.
