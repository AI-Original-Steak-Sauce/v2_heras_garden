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

func test_player_interacts_with_farm_plot_area() -> void:
	GameState.new_game()
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var player = world.get_node("Player")
	var plot = world.get_node("FarmPlots/FarmPlotA")
	player.global_position = plot.global_position
	await get_tree().physics_frame
	await get_tree().process_frame

	player._try_interact()
	assert_that(plot.current_state).is_equal(plot.State.TILLED)

	world.queue_free()
