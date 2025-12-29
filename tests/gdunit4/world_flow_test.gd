extends GdUnitTestSuite

func test_world_loads_core_nodes() -> void:
	GameState.new_game()
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	assert_that(world.get_node_or_null("Player")).is_not_null()
	assert_that(world.get_node_or_null("FarmPlots/FarmPlotA")).is_not_null()
	assert_that(world.get_node_or_null("UI/InventoryPanel")).is_not_null()
	assert_that(world.get_node_or_null("NPCs/NPCSpawner")).is_not_null()

	world.queue_free()

func test_world_player_moves_right() -> void:
	GameState.new_game()
	var runner = scene_runner("res://game/features/world/world.tscn")
	await runner.await_idle_frame()

	var player = runner.scene().get_node("Player")
	var start_pos = player.global_position

	runner.simulate_action_pressed("ui_right")
	await runner.await_idle_frame()
	await runner.await_idle_frame()
	runner.simulate_action_released("ui_right")

	var end_pos = player.global_position
	assert_that(end_pos.x).is_greater(start_pos.x)
	runner.free()

func test_world_inventory_panel_open_close() -> void:
	GameState.new_game()
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var panel = world.get_node("UI/InventoryPanel")
	panel.open()
	await get_tree().process_frame
	assert_that(panel.visible).is_true()

	panel.close()
	await get_tree().create_timer(0.2).timeout
	assert_that(panel.visible).is_false()

	world.queue_free()
