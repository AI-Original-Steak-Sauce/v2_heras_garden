extends GdUnitTestSuite

func test_weaving_minigame_success_path() -> void:
	var game = load("res://game/features/minigames/weaving_minigame.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	game.current_pattern = ["ui_left"]
	game.progress_index = 0
	game.mistakes = 0

	var success := false
	game.minigame_complete.connect(func(result: bool, _items: Array): success = result)
	game._handle_input("ui_left")

	assert_that(success).is_true()
	game.queue_free()
