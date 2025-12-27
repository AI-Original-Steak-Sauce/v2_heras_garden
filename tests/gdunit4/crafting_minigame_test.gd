extends GdUnitTestSuite

func test_crafting_minigame_basic_success() -> void:
	var minigame = load("res://game/features/ui/crafting_minigame.tscn").instantiate()
	get_tree().root.add_child(minigame)
	await get_tree().process_frame

	var pattern: Array[String] = ["ui_up"]
	var buttons: Array[String] = ["ui_accept"]
	minigame.start_crafting(pattern, buttons, 2.0)
	assert_that(minigame.is_grinding_phase).is_true()

	var grind_event = InputEventAction.new()
	grind_event.action = "ui_up"
	grind_event.pressed = true
	grind_event.strength = 1.0
	minigame._handle_grinding_input(grind_event)
	assert_that(minigame.is_grinding_phase).is_false()

	var success := false
	minigame.crafting_complete.connect(func(result: bool): success = result)

	var button_event = InputEventAction.new()
	button_event.action = "ui_accept"
	button_event.pressed = true
	button_event.strength = 1.0
	minigame._handle_button_input(button_event)

	assert_that(minigame.current_button_index).is_equal(1)
	minigame._complete_crafting(true)
	assert_that(success).is_true()
	minigame.queue_free()
