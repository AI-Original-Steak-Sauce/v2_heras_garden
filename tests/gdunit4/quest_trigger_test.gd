extends GdUnitTestSuite

func test_quest_trigger_sets_flag() -> void:
	var trigger = auto_free(QuestTrigger.new())
	trigger.required_flag = "req_flag"
	trigger.set_flag_on_enter = "set_flag"
	GameState.set_flag("req_flag", true)

	var body = auto_free(Node2D.new())
	body.add_to_group("player")

	trigger._on_body_entered(body)
	assert_that(GameState.get_flag("set_flag")).is_true()
