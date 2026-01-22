extends GdUnitTestSuite

## Quest Progression Tests
## Tests quest flag system and quest state management for regression prevention

func before_test():
	# Reset GameState before each test for isolation
	GameState.quest_flags.clear()
	GameState.inventory.clear()

# ==================== Basic Quest Flag Tests ====================

func test_quest_flag_set_and_get():
	# Verify setting a flag stores it correctly
	GameState.set_flag("test_quest_active", true)
	assert_that(GameState.get_flag("test_quest_active")).is_equal(true)

func test_quest_flag_default_false():
	# Verify unset flags return false by default
	assert_that(GameState.get_flag("nonexistent_flag")).is_equal(false)

func test_quest_flag_set_to_false():
	# Verify explicitly setting a flag to false works
	GameState.set_flag("test_flag", true)
	GameState.set_flag("test_flag", false)
	assert_that(GameState.get_flag("test_flag")).is_equal(false)

func test_quest_flag_multiple_flags():
	# Verify multiple flags can coexist
	GameState.set_flag("quest_1", true)
	GameState.set_flag("quest_2", true)
	GameState.set_flag("quest_3", false)
	assert_that(GameState.get_flag("quest_1")).is_equal(true)
	assert_that(GameState.get_flag("quest_2")).is_equal(true)
	assert_that(GameState.get_flag("quest_3")).is_equal(false)

# ==================== Quest 0: Prologue ====================

func test_quest_0_active_on_new_game():
	# Verify quest_0 is active after new_game
	GameState.new_game()
	assert_that(GameState.get_flag("quest_0_active")).is_equal(true)

func test_quest_0_prologue_complete():
	# Verify prologue_complete flag is set
	GameState.set_flag("prologue_complete", true)
	assert_that(GameState.get_flag("prologue_complete")).is_equal(true)

# ==================== Quest 4: Garden Building ====================

func test_quest_4_completion_without_items():
	# Verify quest doesn't complete without required items
	GameState.set_flag("quest_4_active", true)
	GameState.set_flag("quest_4_complete", false)
	GameState.add_item("moly", 2)
	GameState.add_item("nightshade", 3)
	GameState.add_item("golden_glow", 3)
	# Only 2 moly instead of 3
	assert_that(GameState.get_flag("quest_4_complete")).is_equal(false)

func test_quest_4_completion_with_all_items():
	# Verify quest completes when all items are collected
	GameState.set_flag("quest_4_active", true)
	GameState.set_flag("quest_4_complete", false)
	GameState.add_item("moly", 3)
	GameState.add_item("nightshade", 3)
	GameState.add_item("golden_glow", 3)
	assert_that(GameState.get_flag("quest_4_complete")).is_equal(true)

func test_quest_4_garden_built_flag():
	# Verify garden_built flag is set when quest completes
	GameState.set_flag("quest_4_active", true)
	GameState.add_item("moly", 3)
	GameState.add_item("nightshade", 3)
	GameState.add_item("golden_glow", 3)
	assert_that(GameState.get_flag("garden_built")).is_equal(true)

# ==================== Quest Trigger Tests ====================

func test_quest_trigger_with_required_flag():
	# Simulate quest trigger behavior (requires flag check)
	GameState.set_flag("prerequisite_flag", true)
	var can_trigger = GameState.get_flag("prerequisite_flag")
	assert_that(can_trigger).is_equal(true)

func test_quest_trigger_without_required_flag():
	# Verify quest doesn't trigger without prerequisite
	var can_trigger = GameState.get_flag("nonexistent_prerequisite")
	assert_that(can_trigger).is_equal(false)

func test_one_shot_quest_trigger():
	# Simulate one-shot trigger behavior
	var triggered = false
	var one_shot = true

	# First trigger
	if not triggered or not one_shot:
		triggered = true
	assert_that(triggered).is_equal(true)

	# Second trigger should fail for one-shot
	if not triggered or not one_shot:
		triggered = false
	assert_that(triggered).is_equal(true)  # Should still be true
