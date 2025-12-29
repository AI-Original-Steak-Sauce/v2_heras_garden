extends GdUnitTestSuite

var last_success: bool = false

func _on_minigame_complete(result: bool, _items: Array) -> void:
	last_success = result

func test_herb_identification_success_path() -> void:
	last_success = false
	var game = load("res://game/features/minigames/herb_identification.tscn").instantiate()
	get_tree().root.add_child(game)
	await get_tree().process_frame

	var rounds: Array[int] = []
	rounds.append(1)
	var correct: Array[int] = []
	correct.append(1)
	game.plants_per_round = rounds
	game.correct_per_round = correct
	game.max_wrong = 1
	game._setup_round(0)

	if game.plant_slots.is_empty():
		assert_that(game.plant_slots.size()).is_greater(0)
		game.queue_free()
		return

	game.plant_slots[0].set_meta("is_correct", true)
	game.selected_index = 0

	game.minigame_complete.connect(_on_minigame_complete)
	game._select_current()

	assert_that(last_success).is_true()
	game.queue_free()

func test_herb_identification_input_selects_correct() -> void:
	last_success = false
	GameState.new_game()
	GameState.set_flag("herb_minigame_tutorial_done", true)
	var runner = scene_runner("res://game/features/minigames/herb_identification.tscn")
	var game = runner.scene()
	await runner.await_input_processed()

	var rounds: Array[int] = []
	rounds.append(1)
	var correct: Array[int] = []
	correct.append(1)
	game.plants_per_round = rounds
	game.correct_per_round = correct
	game.max_wrong = 1
	game._setup_round(0)

	if game.plant_slots.is_empty():
		assert_that(game.plant_slots.size()).is_greater(0)
		return

	game.plant_slots[0].set_meta("is_correct", true)
	game.selected_index = 0
	game.minigame_complete.connect(_on_minigame_complete)

	runner.simulate_action_pressed("ui_accept")
	await runner.await_input_processed()

	assert_that(last_success).is_true()
