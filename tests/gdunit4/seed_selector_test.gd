extends GdUnitTestSuite

var last_seed: String = ""

func _on_seed_selected(seed_id: String) -> void:
	last_seed = seed_id

func before_test() -> void:
	GameState.new_game()
	GameState.add_item("wheat_seed", 1)

func test_seed_selector_lists_seeds() -> void:
	last_seed = ""
	var selector = load("res://game/features/ui/seed_selector.tscn").instantiate()
	get_tree().root.add_child(selector)
	await get_tree().process_frame

	selector.open()
	await get_tree().process_frame
	assert_that(selector.seed_buttons.size()).is_greater(0)

	selector.seed_selected.connect(_on_seed_selected)
	selector._on_seed_button_pressed("wheat_seed")
	assert_that(last_seed).is_not_empty()

	selector.queue_free()
