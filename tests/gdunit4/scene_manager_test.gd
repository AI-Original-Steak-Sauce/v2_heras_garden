extends GdUnitTestSuite

func test_scene_manager_invalid_path_keeps_current() -> void:
	var dummy = Node.new()
	dummy.name = "DummyScene"
	get_tree().root.add_child(dummy)
	SceneManager.current_scene = dummy

	await SceneManager.change_scene("res://does_not_exist.tscn")
	assert_that(SceneManager.current_scene).is_equal(dummy)

	dummy.queue_free()

func test_scene_manager_changes_scene() -> void:
	await SceneManager.change_scene("res://game/features/ui/main_menu.tscn")
	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("MainMenu")
