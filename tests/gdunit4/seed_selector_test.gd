extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()

func test_seed_selector_lists_seeds() -> void:
	var selector = load("res://game/features/ui/seed_selector.tscn").instantiate()
	get_tree().root.add_child(selector)
	await get_tree().process_frame

	selector.open()
	await get_tree().process_frame
	assert_that(selector.seed_buttons.size()).is_greater(0)

	var picked := ""
	selector.seed_selected.connect(func(seed_id: String): picked = seed_id)
	selector._on_seed_button_pressed("wheat_seed")
	assert_that(picked).is_not_empty()

	selector.queue_free()
