extends GdUnitTestSuite

var last_success: bool = false

func _on_minigame_complete(result: bool, _items: Array) -> void:
	last_success = result

func test_moon_tears_success_path() -> void:
	var game = load("res://game/features/minigames/moon_tears_minigame.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	game.tears_needed = 1
	var tear = load("res://game/features/minigames/moon_tear_single.tscn").instantiate()
	game.tear_container.add_child(tear)
	game.active_tears.append(tear)
	game._catch_tear(tear)
	assert_that(game.tears_caught).is_equal(1)
	assert_that(game.tears_caught >= game.tears_needed).is_true()
	game.queue_free()

func test_moon_tears_input_catches() -> void:
	last_success = false
	GameState.new_game()
	var game = load("res://game/features/minigames/moon_tears_minigame.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	game.tears_needed = 1
	game.minigame_complete.connect(_on_minigame_complete)
	game.size = Vector2(1024, 600)
	game.player_marker.size = Vector2(320, 20)
	game.player_marker.position = Vector2(512, 550)

	var tear = load("res://game/features/minigames/moon_tear_single.tscn").instantiate()
	game.tear_container.add_child(tear)
	game.active_tears.append(tear)
	tear.global_position = game.player_marker.global_position + (game.player_marker.size / 2)

	Input.action_press("ui_accept")
	game._process(0.016)
	Input.action_release("ui_accept")
	await get_tree().process_frame

	assert_that(last_success).is_true()
	game.queue_free()
