extends GdUnitTestSuite

func test_player_moves_with_input() -> void:
	var player = load("res://game/features/player/player.tscn").instantiate()
	get_tree().root.add_child(player)
	await get_tree().process_frame

	Input.action_press("ui_right")
	player._physics_process(0.016)
	Input.action_release("ui_right")

	assert_that(player.velocity.x).is_greater(0)
	player.queue_free()
