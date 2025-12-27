extends GdUnitTestSuite

func test_scene_manager_invalid_path_keeps_current() -> void:
	var dummy = Node.new()
	dummy.name = "DummyScene"
	get_tree().root.add_child(dummy)
	SceneManager.current_scene = dummy

	await SceneManager.change_scene("res://does_not_exist.tscn")
	assert_that(SceneManager.current_scene).is_equal(dummy)

	dummy.queue_free()
