extends GdUnitTestSuite

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
