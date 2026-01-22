extends GutTest

## Tests for GameState quest flag system using GUT framework
## These tests verify basic quest flag functionality for regression prevention

func before_each():
	# Reset GameState before each test for isolation
	GameState.quest_flags.clear()

func test_quest_flag_set_and_get():
	# Verify setting a flag stores it correctly
	GameState.set_flag("test_quest_active", true)
	assert_true(GameState.get_flag("test_quest_active"), "Flag should be true after set to true")

func test_quest_flag_default_false():
	# Verify unset flags return false by default
	assert_false(GameState.get_flag("nonexistent_flag"), "Unset flag should return false")

func test_quest_flag_set_to_false():
	# Verify explicitly setting a flag to false works
	GameState.set_flag("test_flag", true)
	GameState.set_flag("test_flag", false)
	assert_false(GameState.get_flag("test_flag"), "Flag should be false after set to false")

func test_quest_flag_multiple_flags():
	# Verify multiple flags can coexist
	GameState.set_flag("quest_1", true)
	GameState.set_flag("quest_2", true)
	GameState.set_flag("quest_3", false)
	assert_true(GameState.get_flag("quest_1"), "quest_1 should be true")
	assert_true(GameState.get_flag("quest_2"), "quest_2 should be true")
	assert_false(GameState.get_flag("quest_3"), "quest_3 should be false")
