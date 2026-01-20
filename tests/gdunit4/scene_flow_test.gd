extends GdUnitTestSuite

func before_test() -> void:
	_cleanup_scene_manager()
	SceneManager._fade_duration = 0.0

func after_test() -> void:
	_cleanup_scene_manager()

func _cleanup_scene_manager() -> void:
	if SceneManager.current_scene:
		SceneManager.current_scene.queue_free()
		SceneManager.current_scene = null
	if SceneManager._fade_layer:
		SceneManager._fade_layer.queue_free()
		SceneManager._fade_layer = null
		SceneManager._fade_rect = null

func test_main_menu_new_game_changes_to_world() -> void:
	var menu = load("res://game/features/ui/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.new_game_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("World")

func test_main_menu_weaving_changes_to_minigame() -> void:
	var menu = load("res://game/features/ui/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	await get_tree().process_frame

	menu.weaving_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("WeavingMinigame")
