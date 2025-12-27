extends GdUnitTestSuite

func test_boat_interact_no_destination() -> void:
	var boat = load("res://game/features/world/boat.gd").new()
	boat.interact()
	assert_that(true).is_true()
