extends GdUnitTestSuite

func test_sacred_earth_success_path() -> void:
	var game = load("res://game/features/minigames/sacred_earth.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	var success := false
	game.minigame_complete.connect(func(result: bool, _items: Array): success = result)

	game._win()
	assert_that(success).is_true()
	game.queue_free()
