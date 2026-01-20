extends GdUnitTestSuite

func test_interaction_prompt_toggles_near_interactable() -> void:
	GameState.new_game()
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var player = world.get_node("Player")
	var prompt = player.get_node("InteractionPrompt")
	var plot = world.get_node("FarmPlots/FarmPlotA")
	assert_that(prompt.visible).is_false()

	player.global_position = plot.global_position
	await get_tree().physics_frame
	await get_tree().process_frame
	player._update_interaction_prompt()
	assert_that(prompt.visible).is_true()

	player.global_position = plot.global_position + Vector2(512, 512)
	await get_tree().physics_frame
	await get_tree().process_frame
	player._update_interaction_prompt()
	assert_that(prompt.visible).is_false()

	world.queue_free()
