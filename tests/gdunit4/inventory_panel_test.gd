extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()
	GameState.add_item("wheat", 2)

func test_inventory_open_and_details() -> void:
	var panel = load("res://game/features/ui/inventory_panel.tscn").instantiate()
	get_tree().root.add_child(panel)
	await get_tree().process_frame

	panel.open()
	await get_tree().process_frame
	assert_that(panel.visible).is_true()

	# Details panel should be visible when an item is selected.
	assert_that(panel.details_panel.visible).is_true()

	panel.queue_free()
