## Runtime Limits
- Run only one Godot instance at a time when possible to avoid slowing the host machine.

## Testing Workflow

These patterns tend to reduce iteration time during verification.

### Headless Checks (Fast)

Running these before and after changes can catch regressions early:

```powershell
# Unit tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Smoke scene wiring
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30

# Scene load validation
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd
```

### Runtime Verification

When headless checks pass but you need to verify gameplay:
- `get_runtime_scene_structure` helps locate nodes after scene transitions
- `evaluate_runtime_expression` can assert state or call gameplay hooks directly
- Consider using node groups (e.g., `get_tree().get_nodes_in_group("player")`) when available - this can reduce path hunting

### Timing-Sensitive Tests

For minigames or features with timing windows:
- Input simulation can be flaky even when the sequence is correct
- Consider calling completion handlers directly via `evaluate_runtime_expression` to validate reward/consumption logic
- This doesn't replace real input testing but can reduce automation churn
