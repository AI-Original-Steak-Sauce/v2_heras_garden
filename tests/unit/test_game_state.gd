extends GutTest
## Unit tests for GameState autoload
## Tests inventory, gold, flags, and day management

# ============================================
# SETUP / TEARDOWN
# ============================================

func before_each() -> void:
	# Reset GameState before each test
	GameState.inventory.clear()
	GameState.quest_flags.clear()
	GameState.farm_plots.clear()
	GameState.gold = 100
	GameState.current_day = 1
	GameState.current_season = "spring"

# ============================================
# INVENTORY TESTS
# ============================================

func test_add_item_creates_entry() -> void:
	GameState.add_item("wheat", 5)
	assert_eq(GameState.get_item_count("wheat"), 5, "Should have 5 wheat")

func test_add_item_stacks() -> void:
	GameState.add_item("wheat", 3)
	GameState.add_item("wheat", 2)
	assert_eq(GameState.get_item_count("wheat"), 5, "Should stack to 5 wheat")

func test_remove_item_subtracts() -> void:
	GameState.add_item("wheat", 5)
	var result = GameState.remove_item("wheat", 2)
	assert_true(result, "Should return true on success")
	assert_eq(GameState.get_item_count("wheat"), 3, "Should have 3 wheat left")

func test_remove_item_fails_insufficient() -> void:
	GameState.add_item("wheat", 2)
	var result = GameState.remove_item("wheat", 5)
	assert_false(result, "Should return false when insufficient")
	assert_eq(GameState.get_item_count("wheat"), 2, "Should still have 2 wheat")

func test_remove_item_erases_zero() -> void:
	GameState.add_item("wheat", 3)
	GameState.remove_item("wheat", 3)
	assert_eq(GameState.get_item_count("wheat"), 0, "Should have 0 wheat")
	assert_false(GameState.inventory.has("wheat"), "Entry should be erased")

func test_has_item_true() -> void:
	GameState.add_item("wheat", 5)
	assert_true(GameState.has_item("wheat", 3), "Should have at least 3")

func test_has_item_false() -> void:
	GameState.add_item("wheat", 2)
	assert_false(GameState.has_item("wheat", 5), "Should not have 5")

func test_has_item_nonexistent() -> void:
	assert_false(GameState.has_item("unicorn"), "Should not have nonexistent item")

# ============================================
# GOLD TESTS
# ============================================

func test_add_gold() -> void:
	GameState.add_gold(50)
	assert_eq(GameState.gold, 150, "Should have 150 gold")

func test_remove_gold_success() -> void:
	var result = GameState.remove_gold(50)
	assert_true(result, "Should return true")
	assert_eq(GameState.gold, 50, "Should have 50 gold")

func test_remove_gold_insufficient() -> void:
	var result = GameState.remove_gold(200)
	assert_false(result, "Should return false when insufficient")
	assert_eq(GameState.gold, 100, "Gold should be unchanged")

# ============================================
# FLAG TESTS
# ============================================

func test_set_flag_default_true() -> void:
	GameState.set_flag("met_medusa")
	assert_true(GameState.get_flag("met_medusa"), "Flag should be true")

func test_set_flag_explicit_false() -> void:
	GameState.set_flag("met_medusa", true)
	GameState.set_flag("met_medusa", false)
	assert_false(GameState.get_flag("met_medusa"), "Flag should be false")

func test_get_flag_default() -> void:
	assert_false(GameState.get_flag("nonexistent_flag"), "Should default to false")

# ============================================
# DAY/SEASON TESTS
# ============================================

func test_advance_day() -> void:
	GameState.advance_day()
	assert_eq(GameState.current_day, 2, "Should be day 2")

func test_advance_day_multiple() -> void:
	for i in range(5):
		GameState.advance_day()
	assert_eq(GameState.current_day, 6, "Should be day 6")

func test_season_spring() -> void:
	assert_eq(GameState.current_season, "spring", "Should start in spring")

func test_season_changes_to_summer() -> void:
	for i in range(28):
		GameState.advance_day()
	assert_eq(GameState.current_season, "summer", "Should be summer after 28 days")

# ============================================
# SIGNAL TESTS
# ============================================

func test_inventory_signal_emitted() -> void:
	watch_signals(GameState)
	GameState.add_item("wheat", 1)
	assert_signal_emitted_with_parameters(GameState, "inventory_changed", ["wheat", 1])

func test_gold_signal_emitted() -> void:
	watch_signals(GameState)
	GameState.add_gold(25)
	assert_signal_emitted_with_parameters(GameState, "gold_changed", [125])

func test_flag_signal_emitted() -> void:
	watch_signals(GameState)
	GameState.set_flag("test_flag", true)
	assert_signal_emitted_with_parameters(GameState, "flag_changed", ["test_flag", true])

func test_day_signal_emitted() -> void:
	watch_signals(GameState)
	GameState.advance_day()
	assert_signal_emitted_with_parameters(GameState, "day_advanced", [2])
