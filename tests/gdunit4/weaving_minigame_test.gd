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

func test_weaving_minigame_input_sequence() -> void:
	last_success = false
	GameState.new_game()
	var runner = scene_runner("res://game/features/minigames/weaving_minigame.tscn")
	var game = runner.scene()
	await runner.await_input_processed()

	game.current_pattern = PackedStringArray(["ui_left", "ui_right"])
	game.progress_index = 0
	game.mistakes = 0
	game.minigame_complete.connect(_on_minigame_complete)
	game._update_ui()

	runner.simulate_action_pressed("ui_left")
	await runner.await_input_processed()

	runner.simulate_action_pressed("ui_right")
	await runner.await_input_processed()

	assert_that(last_success).is_true()
