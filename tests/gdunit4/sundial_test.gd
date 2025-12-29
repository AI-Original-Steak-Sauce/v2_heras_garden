extends GdUnitTestSuite

func test_sundial_advances_day() -> void:
	GameState.current_day = 1
	var sundial = auto_free(load("res://game/features/world/sundial.gd").new())
	sundial.interact()
	assert_that(GameState.current_day).is_equal(2)
