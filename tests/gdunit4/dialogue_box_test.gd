extends GdUnitTestSuite

func _first_dialogue_path() -> String:
	var dir = DirAccess.open("res://game/shared/resources/dialogues")
	if dir == null:
		return ""
	dir.list_dir_begin()
	var name = dir.get_next()
	while name != "":
		if name != "." and name != ".." and name.ends_with(".tres"):
			var path = "res://game/shared/resources/dialogues/" + name
			dir.list_dir_end()
			return path
		name = dir.get_next()
	dir.list_dir_end()
	return ""

func test_start_dialogue_sets_visible() -> void:
	var dialogue_path = _first_dialogue_path()
	assert_that(dialogue_path).is_not_empty()
	var dialogue = load(dialogue_path) as DialogueData
	assert_that(dialogue).is_not_null()

	for flag in dialogue.flags_required:
		GameState.set_flag(flag, true)

	var scene = load("res://game/features/ui/dialogue_box.tscn").instantiate()
	get_tree().root.add_child(scene)
	await get_tree().process_frame

	scene.start_dialogue(dialogue.id)
	await get_tree().process_frame
	assert_that(scene.visible).is_true()
	assert_that(scene.current_dialogue).is_not_null()

	scene.queue_free()

func test_end_dialogue_sets_flags() -> void:
	var dialogue = load("res://game/shared/resources/dialogues/epilogue_ending_choice.tres") as DialogueData
	assert_that(dialogue).is_not_null()
	GameState.quest_flags.clear()

	var scene = load("res://game/features/ui/dialogue_box.tscn").instantiate()
	get_tree().root.add_child(scene)
	await get_tree().process_frame

	scene.current_dialogue = dialogue
	scene.visible = true
	scene._end_dialogue()

	assert_that(GameState.get_flag("free_play_unlocked")).is_true()
	assert_that(scene.visible).is_false()

	scene.queue_free()

func test_dialogue_choices_grab_focus() -> void:
	var dialogue = load("res://game/shared/resources/dialogues/circe_intro.tres") as DialogueData
	assert_that(dialogue).is_not_null()

	var scene = load("res://game/features/ui/dialogue_box.tscn").instantiate()
	get_tree().root.add_child(scene)
	await get_tree().process_frame

	scene.current_dialogue = dialogue
	scene.visible = true
	scene._show_choices()
	await get_tree().process_frame

	assert_that(scene.choices_container.get_child_count()).is_greater(0)
	var first_button := scene.choices_container.get_child(0) as Button
	assert_that(first_button).is_not_null()
	assert_that(first_button.has_focus()).is_true()

	scene.queue_free()
