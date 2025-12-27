extends GdUnitTestSuite

var last_success: bool = false

func _on_minigame_complete(result: bool, _items: Array) -> void:
	last_success = result

func test_weaving_minigame_success_path() -> void:
	last_success = false
	var game = load("res://game/features/minigames/weaving_minigame.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	game.current_pattern = ["ui_left"]
	game.progress_index = 0
	game.mistakes = 0

	game.minigame_complete.connect(_on_minigame_complete)
	game._handle_input("ui_left")

	assert_that(last_success).is_true()
	game.queue_free()
