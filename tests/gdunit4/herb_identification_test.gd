extends GdUnitTestSuite

func test_herb_identification_success_path() -> void:
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

	var success := false
	game.minigame_complete.connect(func(result: bool, _items: Array): success = result)
	game._select_current()

	assert_that(success).is_true()
	game.queue_free()
