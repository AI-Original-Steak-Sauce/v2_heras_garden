# Testing Framework Choice: GdUnit4

**Date:** 2025-01-22
**Plan:** foamy-prancing-pike (Automated Testing Infrastructure)
**Status:** Decision Made

## Framework Comparison Results

### GUT (Godot Unit Test)
- **Pros:**
  - Mature, widely-used framework
  - Good documentation
  - Simple assertion syntax (`assert_eq()`, `assert_true()`)
- **Cons:**
  - Path resolution issues in this project structure
  - `gut.gd` has dependency on `gut_to_move.gd` that fails to resolve
  - Not already enabled in project

### GdUnit4
- **Pros:**
  - Already enabled in project.godot
  - Fluent assertion syntax (`assert_that().is_equal()`)
  - Better C# support (important for future-proofing)
  - Active development
  - Good CI/CD integration support
- **Cons:**
  - Slightly more verbose syntax
  - CLI tool path issues (similar to GUT)

## Decision: **GdUnit4**

### Rationale
1. **Already configured** - GdUnit4 is already enabled in project.godot, reducing setup friction
2. **C# Support** - Better C# support aligns with potential future C# migration
3. **AI Parseability** - Fluent syntax is easily readable and modifiable by AI agents
4. **CI/CD Ready** - Built-in support for headless execution and JUnit XML output

### Test Syntax Examples

```gdscript
extends GdUnitTestSuite

func test_quest_flag_set_and_get():
    GameState.set_flag("test_quest", true)
    assert_that(GameState.get_flag("test_quest")).is_equal(true)

func test_inventory_add_item():
    GameState.add_item("wheat_seed", 5)
    assert_that(GameState.get_item_count("wheat_seed")).is_equal(5)
```

### Running Tests

**In Editor:**
- Use the GdUnit4 panel (bottom panel)
- Click "Run Tests" button

**Headless (CI/CD):**
```bash
godot --headless -s game/addons/gdunit4/addons/gdUnit4/bin/GdUnitCmdTool.gd run
```

### Test File Locations
- Test files: `game/tests/` (organized by feature)
- Test suites must extend `GdUnitTestSuite`
- Test functions must start with `test_`

### Next Steps
- Phase 2: DAP Integration for runtime debugging
- Phase 3: Create comprehensive test suite
- Document test coverage metrics
