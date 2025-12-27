extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()

func test_farm_plot_till_plant_harvest() -> void:
	var plot = load("res://game/features/farm_plot/farm_plot.tscn").instantiate()
	get_tree().root.add_child(plot)
	await get_tree().process_frame

	plot.grid_position = Vector2i(0, 0)
	plot.till()
	assert_that(plot.current_state).is_equal(plot.State.TILLED)

	plot.plant("wheat_seed")
	assert_that(GameState.farm_plots.has(plot.grid_position)).is_true()

	GameState.farm_plots[plot.grid_position]["ready_to_harvest"] = true
	plot.sync_from_game_state()
	plot.harvest()

	assert_that(GameState.get_item_count("wheat")).is_greater(0)
	plot.queue_free()
