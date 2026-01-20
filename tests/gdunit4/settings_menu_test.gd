extends GdUnitTestSuite

func before_test() -> void:
	_cleanup_settings()

func after_test() -> void:
	_cleanup_settings()

func _cleanup_settings() -> void:
	var settings_path = "user://settings.json"
	if FileAccess.file_exists(settings_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(settings_path))

func test_settings_menu_open() -> void:
	var menu = load("res://game/features/ui/settings_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.open()
	await get_tree().process_frame
	assert_that(menu.visible).is_true()
	menu.queue_free()

func test_settings_menu_cancel_restores_saved_values() -> void:
	var menu = load("res://game/features/ui/settings_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.master_slider.value = 80
	menu.music_slider.value = 70
	menu.sfx_slider.value = 60
	menu._save_settings()

	menu.master_slider.value = 10
	menu.music_slider.value = 20
	menu.sfx_slider.value = 30

	menu.open()
	await get_tree().process_frame
	menu._cancel()
	await get_tree().create_timer(0.2).timeout

	assert_that(menu.master_slider.value).is_equal(80.0)
	assert_that(menu.music_slider.value).is_equal(70.0)
	assert_that(menu.sfx_slider.value).is_equal(60.0)
	assert_that(menu.visible).is_false()
	menu.queue_free()

func test_settings_menu_accept_saves_values() -> void:
	var menu = load("res://game/features/ui/settings_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.open()
	await get_tree().process_frame
	menu.master_slider.value = 90
	menu.music_slider.value = 60
	menu.sfx_slider.value = 40

	var event = InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	event.strength = 1.0
	menu._unhandled_input(event)
	await get_tree().create_timer(0.2).timeout

	var settings_path = "user://settings.json"
	assert_that(FileAccess.file_exists(settings_path)).is_true()

	var file = FileAccess.open(settings_path, FileAccess.READ)
	var settings = JSON.parse_string(file.get_as_text())
	file.close()

	assert_that(settings.get("master_volume", 0)).is_equal(90.0)
	assert_that(settings.get("music_volume", 0)).is_equal(60.0)
	assert_that(settings.get("sfx_volume", 0)).is_equal(40.0)
	assert_that(menu.visible).is_false()
	menu.queue_free()
