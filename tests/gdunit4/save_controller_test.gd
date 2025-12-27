extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()
	SaveController.delete_save()

func after_test() -> void:
	SaveController.delete_save()

func test_save_and_load_round_trip() -> void:
	GameState.add_item("moly", 2)
	GameState.gold = 123
	GameState.set_flag("test_flag", true)

	assert_that(SaveController.save_game()).is_true()

	GameState.gold = 0
	GameState.inventory.clear()
	GameState.quest_flags.clear()

	assert_that(SaveController.load_game()).is_true()
	assert_that(GameState.gold).is_equal(123)
	assert_that(GameState.has_item("moly", 2)).is_true()
	assert_that(GameState.get_flag("test_flag")).is_true()
