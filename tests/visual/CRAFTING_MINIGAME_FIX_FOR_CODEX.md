# Crafting Minigame: Fix for Beta Mechanical Test
**For: Codex (Jr Engineer)**
**Date:** 2026-01-01
**Issue:** Quest 5 & 6 crafting minigames not accepting inputs, progress stays at 0%

---

## Analysis Summary

I found the issue! Your beta test **IS** calling `start_crafting()`, but **twice**, and the second call is causing problems.

---

## Status Update (2026-01-01)

**What seems to work now (latest run: `.godot/screenshots/full_playthrough/latest_run.log`):**
- Quest 5 crafting completes; inventory updates and `Crafted: Calming Draught` appears in logs.
- Quest 6 crafting completes; inventory updates and `Crafted: Reversal Elixir` appears in logs.
- Minigame instance is typically found at `/root/World/UI/CraftingController/CraftingMinigame` during entry.

**What still looks off:**
- Entry captures for Quest 5/6 often show the dark world view without the minigame UI.
  - Example PNG: `.godot/screenshots/full_playthrough/quest_05/035_quest5_crafting_entry.png`
  - ASCII for the same step is currently all spaces (dark screen), suggesting the UI is not visible at capture time.
- Debug logs show the minigame instance becoming null or not visible after the first input in some runs.

**Recent test timing adjustments:**
- Added pauses before and after crafting entry captures to keep the UI visible longer.
- Shortened the delay between `start_craft` and the first inputs to reduce timing-window failures.
- `_open_crafting_minigame()` now waits for visibility and a couple of frames before returning.

**Perceived blockers / next investigations:**
- UI is likely hidden or not rendered in the entry capture window; extra frame delays may help, but it might also be a draw-order or visibility issue.
- The minigame node sometimes goes invalid mid-pattern, which makes input forwarding unreliable.
- Consider capturing immediately after `controller.start_craft()` with a few `process_frame` waits, then beginning inputs in the next step.

---

## The Real Problem

### What's Happening Now

**Your current flow in `_run_crafting_inputs()` (line 910-928):**
```gdscript
func _run_crafting_inputs() -> void:
    await _wait_for_crafting_minigame_visible(2.0)  # Step 1: Wait for UI
    _restart_crafting_minigame(pattern, buttons, timing)  # Step 2: BUG - Calls start_crafting() AGAIN!
    await _delay(0.8)  # Step 3: Wait 0.8 seconds
    for action in pattern:  # Step 4: Send inputs
        _tap_action(action)
        await _delay(0.3)
```

**The sequence:**
1. `_step_quest5_crafting_entry()` calls `_open_crafting_minigame()`
2. `_open_crafting_minigame()` calls `_start_crafting_controller()`
3. `_start_crafting_controller()` calls `controller.start_craft("calming_draught")` ✓
4. `controller.start_craft()` calls `minigame.start_crafting(pattern, buttons, 2.0)` ✓
5. UI becomes visible
6. `_step_quest5_crafting_pattern()` calls `_run_crafting_inputs()`
7. `_run_crafting_inputs()` calls `_restart_crafting_minigame()` which calls `start_crafting()` AGAIN! ❌
8. Sends inputs 0.8 seconds later

**The Issue:** You're calling `start_crafting()` **twice** with a 0.8-second gap, which might be resetting the minigame state or causing timing issues.

---

## Primary Fix: Remove the Duplicate Call

**Change `_run_crafting_inputs()` (line 918):**

**Remove this line:**
```gdscript
_restart_crafting_minigame(pattern, buttons, recipe.timing_window if recipe else 1.5)
```

**Why:** The minigame is already started by `_start_crafting_controller()`. Calling `start_crafting()` again is redundant and may be causing issues.

**Your updated `_run_crafting_inputs()` should be:**
```gdscript
func _run_crafting_inputs() -> void:
    var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
    var buttons = ["ui_accept", "ui_accept"]
    var recipe = _get_recipe_data(_crafting_recipe_id)
    if recipe:
        pattern = recipe.grinding_pattern
        buttons = recipe.button_sequence

    await _wait_for_crafting_minigame_visible(2.0)
    # REMOVED: _restart_crafting_minigame() - don't call start_crafting() twice!

    await _delay(0.8)
    for action in pattern:
        _tap_action(action)
        await _delay(0.3)
    if _crafting_minigame_instance:
        for button_action in buttons:
            _tap_action(button_action)
            await _delay(0.3)
    await _wait_for_crafting_complete(2.0)
    _ensure_crafting_result_applied(recipe)
```

---

## Secondary Issues to Check

### Issue #1: Input Not Reaching Minigame

**Your `_forward_input_to_crafting()` (line 1225-1232):**
```gdscript
func _forward_input_to_crafting(event: InputEvent) -> void:
    if not _crafting_minigame_instance:
        return
    if not is_instance_valid(_crafting_minigame_instance):
        return
    if not _crafting_minigame_instance.visible:
        return
    _crafting_minigame_instance._input(event)  # Direct call
```

**Problem:** This only forwards if `_crafting_minigame_instance` is found and valid.

**Add debug output to verify:**
```gdscript
func _forward_input_to_crafting(event: InputEvent) -> void:
    print("[DEBUG] Forwarding input: %s" % event.action)
    if not _crafting_minigame_instance:
        print("[DEBUG] _crafting_minigame_instance is null")
        return
    if not is_instance_valid(_crafting_minigame_instance):
        print("[DEBUG] _crafting_minigame_instance is not valid")
        return
    if not _crafting_minigame_instance.visible:
        print("[DEBUG] _crafting_minigame_instance not visible")
        return
    print("[DEBUG] Calling _input() on minigame")
    _crafting_minigame_instance._input(event)
```

This will tell you if inputs are actually reaching the minigame.

### Issue #2: Wrong Node Path

**Your `_refresh_crafting_minigame_instance()` (line 972-975):**
```gdscript
func _refresh_crafting_minigame_instance() -> void:
    _crafting_minigame_instance = root.get_node_or_null("/root/World/UI/CraftingController/CraftingMinigame")
    if not _crafting_minigame_instance:
        _crafting_minigame_instance = root.get_node_or_null("/root/CraftingController/CraftingMinigame")
```

**Problem:** If the path is wrong, `_crafting_minigame_instance` will be null, and inputs won't be forwarded.

**Add debug output:**
```gdscript
func _refresh_crafting_minigame_instance() -> void:
    var old_instance = _crafting_minigame_instance
    _crafting_minigame_instance = root.get_node_or_null("/root/World/UI/CraftingController/CraftingMinigame")
    if not _crafting_minigame_instance:
        _crafting_minigame_instance = root.get_node_or_null("/root/CraftingController/CraftingMinigame")

    if old_instance != _crafting_minigame_instance:
        if _crafting_minigame_instance:
            print("[DEBUG] Found minigame instance at: %s" % _crafting_minigame_instance.get_path())
        else:
            print("[DEBUG] Minigame instance NOT FOUND")
```

### Issue #3: Timing Window Too Strict

**The minigame has a timing check (crafting_minigame.gd line 50-52):**
```gdscript
if current_time - last_input_time > timing_window:
    _fail_crafting()
    return
```

**With your 0.3-second delays between inputs:**
- Input 1: `last_input_time = 0.0`, input at 0.3, delta = 0.3 < 2.0 ✓
- Input 2: `last_input_time = 0.3`, input at 0.6, delta = 0.3 < 2.0 ✓
- Input 3: `last_input_time = 0.6`, input at 0.9, delta = 0.3 < 2.0 ✓
- Input 4: `last_input_time = 0.9`, input at 1.2, delta = 0.3 < 2.0 ✓

**This should be fine**, but if the timing is slightly off or there's lag, it could fail.

**Try reducing delays to 0.1 seconds:**
```gdscript
for action in pattern:
    _tap_action(action)
    await _delay(0.1)  # Reduced from 0.3
```

---

## Testing Procedure

### Step 1: Add Debug Output

Add the debug outputs shown above to:
- `_forward_input_to_crafting()`
- `_refresh_crafting_minigame_instance()`

### Step 2: Remove Duplicate Call

Edit `_run_crafting_inputs()` and remove the `_restart_crafting_minigame()` call.

### Step 3: Run Test

```bash
.\Godot*.exe --headless --script tests/visual/beta_mechanical_test.gd
```

### Step 4: Check Output

Look for:
```
[DEBUG] Found minigame instance at: /root/World/UI/CraftingController/CraftingMinigame
[DEBUG] Forwarding input: ui_up
[DEBUG] Forwarding input: ui_right
[DEBUG] Forwarding input: ui_down
[DEBUG] Forwarding input: ui_left
```

If you see these, inputs are reaching the minigame. If not, the path is wrong.

---

## If the Fix Doesn't Work

### Secondary Fix #1: Shorter Delays

**Change delays from 0.3 to 0.1:**
```gdscript
for action in pattern:
    _tap_action(action)
    await _delay(0.1)  # Was 0.3
```

### Secondary Fix #2: Use Signal-Based Completion

**Instead of polling, wait for the signal:**

```gdscript
func _run_crafting_inputs() -> void:
    var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
    var buttons = ["ui_accept", "ui_accept"]
    var recipe = _get_recipe_data(_crafting_recipe_id)
    if recipe:
        pattern = recipe.grinding_pattern
        buttons = recipe.button_sequence

    await _wait_for_crafting_minigame_visible(2.0)

    # Set up signal listener
    var crafting_completed = false
    var on_crafting_complete = func(success: bool):
        crafting_completed = true
        print("[DEBUG] Crafting complete: %s" % success)

    if _crafting_minigame_instance:
        _crafting_minigame_instance.crafting_complete.connect(on_crafting_complete)

    # Send inputs
    for action in pattern:
        _tap_action(action)
        await _delay(0.1)

    if _crafting_minigame_instance:
        for button_action in buttons:
            _tap_action(button_action)
            await _delay(0.1)

    # Wait for completion
    var timeout = 5.0
    var elapsed = 0.0
    while not crafting_completed and elapsed < timeout:
        await get_tree().process_frame
        elapsed += get_process_delta_time()

    if crafting_completed:
        print("[OK] Crafting completed successfully")
    else:
        print("[FAIL] Crafting timed out")
```

---

## Quick Test to Isolate the Issue

Add this simple test to verify the minigame works:

```gdscript
func test_crafting_minigame_direct() -> void:
    print("\n=== Direct Minigame Test ===\n")

    # Load and instantiate minigame
    var scene = load("res://game/features/ui/crafting_minigame.tscn")
    var minigame = scene.instantiate()
    root.add_child(minigame)
    await get_tree().process_frame

    # Start crafting with simple pattern
    var pattern = ["ui_up", "ui_right"]
    var buttons = ["ui_accept"]
    minigame.start_crafting(pattern, buttons, 2.0)
    minigame.visible = true
    await get_tree().process_frame

    print("Minigame started, visible=%s" % minigame.visible)
    print("Pattern index: %d" % minigame.current_pattern_index)

    # Send first input
    var event = InputEventAction.new()
    event.action = "ui_up"
    event.pressed = true
    minigame._input(event)
    await get_tree().process_frame

    print("After ui_up: pattern index=%d" % minigame.current_pattern_index)

    # Send second input
    event.action = "ui_right"
    minigame._input(event)
    await get_tree().process_frame

    print("After ui_right: pattern index=%d" % minigame.current_pattern_index)

    # Send button input
    event.action = "ui_accept"
    minigame._input(event)
    await get_tree().process_frame

    print("After ui_accept: pattern index=%d, button index=%d" % [minigame.current_pattern_index, minigame.current_button_index])

    minigame.queue_free()
```

**Run this test alone to verify the minigame accepts inputs.**

---

## Summary

**Primary Fix:** Remove the `_restart_crafting_minigame()` call in `_run_crafting_inputs()` (line 918)

**Why:** You're calling `start_crafting()` twice, which may be resetting the minigame state

**Secondary Checks:**
1. Add debug output to verify inputs are reaching the minigame
2. Verify the node path is correct
3. Try shorter delays (0.1s instead of 0.3s)

**Most Likely Cause:** The duplicate call to `start_crafting()` with a timing gap is confusing the minigame state machine.

---

**Try the primary fix first, then add debug output if it doesn't work.**
