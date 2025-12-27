extends GdUnitTestSuite

var last_success: bool = false

func _on_minigame_complete(result: bool, _items: Array) -> void:
	last_success = result

func test_sacred_earth_success_path() -> void:
	last_success = false
	var game = load("res://game/features/minigames/sacred_earth.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	game.minigame_complete.connect(_on_minigame_complete)

	game._win()
	assert_that(last_success).is_true()
	game.queue_free()
