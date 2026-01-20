extends GdUnitTestSuite

func before_test() -> void:
	SaveController.delete_save()

func after_test() -> void:
	SaveController.delete_save()

func test_main_menu_continue_disabled_without_save() -> void:
	var menu = load("res://game/features/ui/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	assert_that(menu.continue_button.disabled).is_true()
	menu.queue_free()

func test_main_menu_continue_enabled_with_save() -> void:
	GameState.new_game()
	SaveController.save_game()
	var menu = load("res://game/features/ui/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	assert_that(menu.continue_button.disabled).is_false()
	menu.queue_free()
