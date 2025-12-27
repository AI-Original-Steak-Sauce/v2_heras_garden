extends GdUnitTestSuite

func test_settings_menu_open() -> void:
	var menu = load("res://game/features/ui/settings_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.open()
	await get_tree().process_frame
	assert_that(menu.visible).is_true()
	menu.queue_free()
