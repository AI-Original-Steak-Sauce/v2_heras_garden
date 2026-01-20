# Circe's Garden: Playtesting Roadmap (Streamlined)

## Navigation
Line numbers reflect this file as of 2026-01-17 and may shift after edits.
- Status Summary: line 22
- Done vs Not Done: line 38
- Blockers: line 57
- Next Steps: line 63
- HPV Session Log: line 75

## Purpose
This file tracks what has been validated, what is still pending, and what to do next.
Detailed walkthrough steps live in the references below to avoid duplication.

## References
- docs/execution/DEVELOPMENT_ROADMAP.md
- docs/design/Storyline.md
- docs/playtesting/HPV_GUIDE.md (MCP usage)

---

## Status Summary (2026-01-18)

| Area | Status | Notes |
| --- | --- | --- |
| Quest 0 (arrival + house) | HPV pass (teleports) | Arrival note + Hermes intro confirmed; house exit/return placement still pending. |
| Quests 1-3 | HPV pass (teleports, minigame skips) | Quest 2 choices appeared; choice selection via `ui_accept` did not set `quest_2_active`. Quest 3 choices appear but can be skipped if `ui_accept` is pressed after choices show. |
| Quests 4-8 | HPV pass (teleports, minigame skips) | Quest 6/8 completion dialogues did not appear routed via NPC logic in this run; started manually to confirm beats. Quest 7 trigger did not fire via teleport; `quest_7_active` set manually. |
| Quests 9-10 | HPV pass (teleports, minigame skips) | Quest 9 -> 10 flow validated with runtime eval for Sacred Grove minigame and Quest 10 trigger. |
| Quest 11 + endings | HPV pass (runtime eval for choices) | Final confrontation + both endings completed; input/flow issues required runtime eval. |
| Prologue dialogue advance | Rechecked OK | 2026-01-17: auto-advances on timers; `ui_cancel` skips. |
| Prologue skip input | Implemented | `ui_cancel` skips the prologue cutscene for faster HPV starts. |
| Scylla world spawn | Rechecked via flags | Spawns and is interactable when quest 8-10 flags are set via runtime eval. |
| World staging/spawns | Not checked | NPC spacing, spawn points, and interactable spacing need review. |
| Routing fixes (P1/P2) | Applied + spot-checks | Choice input + boat input updated; quest triggers + cutscene cleanup updated. Full playthrough still needed for confirmation. |
| Full playthrough A/B (no runtime eval) | Blocked at Quest 1 | Hermes dialogue choices did not advance with ui_accept/d-pad during an in-flow run. |

---

## Done vs Not Done

**Done (shortcut coverage)**

## Minigame Note
Minigames are not part of Phase 7 HPV. Mark them as not recently validated and validate separately later.
- Quest wiring through Quest 11 (HPV snapshot 2026-01-11; shortcuts used, minigames skipped).
- Quest 11 final confrontation + epilogue completed via teleports/runtime eval (HPV 2026-01-17).
- Quests 0-8 HPV pass (teleports/runtime eval used for minigame skips, 2026-01-17).
- Quests 9-11 + endings A/B HPV pass (runtime eval used for minigames/choices, 2026-01-17).

**Not Done / Pending HPV**
- Full playthrough A/B without runtime eval (post-routing fixes).
- World staging and spawn placement review.
- House exit return/spawn placement check.
- Optional: no-teleport pass for Quests 0-8 if needed; current validation used teleports/runtime eval.

---

## Blockers
- Hermes dialogue choice selection appeared stuck during an in-flow run (ui_accept/d-pad did not advance).

---

## Next Steps (Ordered)
1. Fix Hermes dialogue choice selection so Quest 1 can advance in-flow.
2. Full playthrough A/B without runtime eval (validate New Game -> Ending A/B).
3. Verify spawn placements and interactable spacing in world and locations.

---

## Recent HPV Coverage (2026-01-11)
The MCP/manual HPV snapshot exercised quest wiring through Quest 11 using shortcuts; minigames were skipped. This indicates Quests 1-10 have wiring coverage, but not a full human-like playthrough.

---

## HPV Session Log (2026-01-17)

**Scope:** Quest 10+ (Phase 7), teleport-assisted, minigames skipped.

**What worked:**
- Teleport + trigger calls opened Quest 10/11 dialogue quickly.
- Reading DialogueBox text confirmed progress without extra input loops.

**What did not work:**
- Prologue/cutscene advance is slow; repeated ui_accept is inefficient.
- World NPC spawn for Scylla did not appear after Quest 8-10 flags.
- Quest 11 did not surface choices or cutscene; quest_11_complete and scylla_petrified stayed false.

**Notes:**
- Quest 10 trigger dialogue appeared and advanced via ui_accept; DialogueBox closed normally.
- Quest 11 dialogue in world and Scylla's Cove advanced, but no choices/cutscene were observed.
- During Quest 11, Scylla resolves to `quest11_inprogress`, which contains no choices or next dialogue; `act3_final_confrontation` is not reached.
- Prologue auto-advanced to world after timed narration; `ui_cancel` skips. Recheck complete.
- Scylla spawns in world when `quest_8_active` is set via runtime eval; verify in-flow later.
- `quest10_complete` now sets `quest_11_active`; verified via runtime eval.
- In-flow Quest 10 -> Quest 11 check: quest10_complete dialogue set `quest_11_active`, boat travel opened Scylla's Cove, and final confrontation choices appeared.
- Quest 11 pre-confrontation dialogue (`quest11_start`) did not appear; flow went straight to `act3_final_confrontation` (Storyline gap to revisit in Phase 8).
- Final confrontation lines include "last potion" and "end your torment," but not the "death potion" beat.

**HPV Update (2026-01-17):**
- Quest 11 now reaches `act3_final_confrontation` when `petrification_potion` is in inventory and `quest_9_active`/`quest_10_active` are set.
- Final confrontation choices appeared; selecting a choice via `ui_accept` did not reliably start the follow-up dialogue, so the choice was triggered via runtime eval.
- Completing `act3_final_confrontation_understand` triggered the petrification cutscene; `quest_11_complete`, `scylla_petrified`, and `game_complete` were set.
- Epilogue trigger fired via teleport to `QuestTriggers/Epilogue`; ending choice needed runtime eval to press the option, then `ending_witch` and `free_play_unlocked` were set.

**HPV Update (2026-01-17, Option 2: Quests 0-8):**
- New Game start: prologue skip via `ui_cancel` worked; arrival dialogue advanced with `ui_accept`.
- Quest 0: Aeetes note dialogue triggered and closed; Hermes intro (`hermes_intro`) played.
- Quest 1: Quest 1 trigger fired; herb ID minigame skipped via `quest_1_complete` flag; `quest1_complete` dialogue played.
- Quest 2: `quest2_start` dialogue played; 3 choices appeared. `ui_accept` on the choice did not set `quest_2_active`, so the flag was set via runtime eval to continue.
- Quest 3: Boat interaction did not change scene via input in this run; `Boat.interact()` was called via runtime eval. `act1_confront_scylla` choices exist but `ui_accept` can skip when pressed after the choices appear; `_show_choices()` + deferred button press was used to select a choice. `quest_3_complete` was set manually after the choice dialogue.
- Quest 4: `quest4_start` played; farming skipped via `quest_4_complete` flag.
- Quest 5: `quest5_start` played; calming draught craft skipped via `quest_5_complete` flag. `quest5_complete` dialogue included the Scylla rejection line.
- Quest 6: `quest6_start` played; reversal elixir craft skipped via `quest_6_complete` flag. `quest6_complete` did not appear routed via Aeetes NPC logic in this run; started manually to confirm the "pharmaka doesn't undo pharmaka" line.
- Quest 7: Quest 7 trigger did not fire via teleport in this run; `quest_7_active` was set and `act2_daedalus_arrives` started manually. `daedalus_intro` was not reachable once `met_daedalus` is set, so it was started manually to confirm the "Ask her what she wants" beat.
- Quest 8: `quest8_start` played; binding ward craft skipped via `quest_8_complete` flag. `quest8_complete` did not appear routed via Daedalus NPC logic in this run; started manually to confirm the "JUST LET ME DIE" line.

**HPV Update (2026-01-17, Option 3: Quests 9-11 + Endings):**
- Setup: Used runtime eval to set `quest_8_active` + `quest_8_complete` to reach Quest 9 quickly (minigames skipped by policy).
- Quest 9: `quest9_start` appeared after `scylla_intro`; boat interaction via input did not travel in this run, so `Boat.interact()` was called via runtime eval. Sacred Grove minigame skipped via flags and `_finish_minigame()`.
- Quest 9 -> 10: `quest9_complete` dialogue appeared; `quest10_start` appeared on next interaction.
- Quest 10: Quest 10 trigger did not fire via teleport in this run; `_on_body_entered` was called manually to start `act3_ultimate_crafting`. Divine blood cutscene did not auto-run in this run; `_play_divine_blood_cutscene()` was called manually. Petrification potion craft minigame skipped via flags and item injection.
- Quest 11: Boat input did not travel in this run; `Boat.interact()` used. Final confrontation choices appeared, but `ui_accept` on a choice did not work; choice was triggered via runtime eval.
- Petrification cutscene: `ScyllaPetrification` started but did not finish in a reasonable time in this run; flags and scene cleanup were set manually to proceed.
- Epilogue: Epilogue trigger did not fire via teleport in this run; trigger was invoked via `_on_body_entered` after resetting `triggered`. Both ending choices were selected via runtime eval; `ending_witch` and `ending_healer` flags set successfully.

**HPV Update (2026-01-17, P2 routing fixes spot-checks):**
- Quest trigger overlap now fires when the required flag is set after teleport (Quest 4 spot-check).
- `act3_ultimate_crafting` now auto-runs the divine blood cutscene; `divine_blood_collected` and item were set without manual cutscene calls.
- `act3_final_confrontation_*` choices now trigger petrification cutscene completion and return to world; `quest_11_complete` and `scylla_petrified` set as expected.
- These checks used runtime eval + input taps rather than a full New Game run.

---

## HPV Session Log (2026-01-18)

**Scope:** New Game -> Quest 1 (in-flow, no runtime eval, minigames skipped by policy).

**What worked:**
- New Game started; prologue skip via `ui_cancel` worked.
- Aeetes note interaction triggered and advanced normally.
- Hermes dialogue opened after moving to the spawn point.

**What did not work:**
- Hermes dialogue choices did not advance via `ui_accept`, `interact`, or d-pad selection attempts.
- Run stopped at Quest 1 because choice selection appeared stuck.
