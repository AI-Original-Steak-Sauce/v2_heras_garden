extends GdUnitTestSuite

func test_cutscene_manager_initial_state() -> void:
	assert_that(CutsceneManager.is_playing()).is_false()
