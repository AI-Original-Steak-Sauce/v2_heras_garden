extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()
	_cleanup_scene_manager()
	SceneManager._fade_duration = 0.01

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

func _wait_frames(count: int) -> void:
	for _i in range(count):
		await get_tree().process_frame

func test_return_trigger_from_scylla_cove_returns_world() -> void:
	var scene = load("res://game/features/locations/scylla_cove.tscn").instantiate()
	get_tree().root.add_child(scene)
	SceneManager.current_scene = scene

	var player = load("res://game/features/player/player.tscn").instantiate()
	scene.add_child(player)

	var trigger = scene.get_node("ReturnTrigger")
	trigger._on_body_entered(player)
	await _wait_frames(5)

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("World")

func test_return_trigger_from_sacred_grove_returns_world() -> void:
	var scene = load("res://game/features/locations/sacred_grove.tscn").instantiate()
	get_tree().root.add_child(scene)
	SceneManager.current_scene = scene

	var player = load("res://game/features/player/player.tscn").instantiate()
	scene.add_child(player)

	var trigger = scene.get_node("ReturnTrigger")
	trigger._on_body_entered(player)
	await _wait_frames(5)

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("World")

func test_prologue_cutscene_sets_flag_and_moves_to_world() -> void:
	GameState.quest_flags.clear()
	Engine.time_scale = 20.0

	await CutsceneManager.play_cutscene("res://game/features/cutscenes/prologue_opening.tscn")
	await _wait_frames(5)

	assert_that(GameState.get_flag("prologue_complete")).is_true()
	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("World")
	Engine.time_scale = 1.0

func test_scylla_cutscene_sets_flags_and_moves_to_cove() -> void:
	GameState.quest_flags.clear()
	Engine.time_scale = 20.0

	await CutsceneManager.play_cutscene("res://game/features/cutscenes/scylla_transformation.tscn")
	await _wait_frames(5)

	assert_that(GameState.get_flag("transformed_scylla")).is_true()
	assert_that(GameState.get_flag("quest_3_complete")).is_true()
	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("ScyllaCove")
	Engine.time_scale = 1.0
