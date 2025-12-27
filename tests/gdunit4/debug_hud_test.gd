extends GdUnitTestSuite

func test_debug_hud_toggle() -> void:
	var hud = load("res://game/features/ui/debug_hud.tscn").instantiate()
	get_tree().root.add_child(hud)
	await get_tree().process_frame

	var initial = hud.is_visible
	hud.toggle_visibility()
	assert_that(hud.is_visible).is_not_equal(initial)
	
	hud.queue_free()
