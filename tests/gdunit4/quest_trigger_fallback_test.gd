extends GdUnitTestSuite

func test_quest_trigger_fallback_scope() -> void:
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var quest1 = world.get_node("QuestTriggers/Quest1")
	var quest2 = world.get_node("QuestTriggers/Quest2")
	var quest3 = world.get_node("QuestTriggers/Quest3")
	var quest4 = world.get_node("QuestTriggers/Quest4")
	var quest5 = world.get_node("QuestTriggers/Quest5")
	var quest6 = world.get_node("QuestTriggers/Quest6")
	var quest7 = world.get_node("QuestTriggers/Quest7")
	var quest8 = world.get_node("QuestTriggers/Quest8")
	var quest9 = world.get_node("QuestTriggers/Quest9")
	var quest10 = world.get_node("QuestTriggers/Quest10")
	var quest11 = world.get_node("QuestTriggers/Quest11")
	var epilogue = world.get_node("QuestTriggers/Epilogue")

	assert_that(quest1.monitoring).is_true()
	assert_that(quest2.monitoring).is_true()
	assert_that(quest3.monitoring).is_false()
	assert_that(quest4.monitoring).is_false()
	assert_that(quest5.monitoring).is_false()
	assert_that(quest6.monitoring).is_false()
	assert_that(quest7.monitoring).is_false()
	assert_that(quest8.monitoring).is_false()
	assert_that(quest9.monitoring).is_false()
	assert_that(quest10.monitoring).is_false()
	assert_that(quest11.monitoring).is_false()
	assert_that(epilogue.monitoring).is_false()

	world.queue_free()
