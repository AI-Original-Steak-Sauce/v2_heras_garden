extends GdUnitTestSuite

## Tests for GameState quest flag system using GdUnit4 framework
## These tests verify basic quest flag functionality for regression prevention

func before_test():
	# Reset GameState before each test for isolation
	GameState.quest_flags.clear()

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
