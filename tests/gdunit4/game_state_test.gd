extends GdUnitTestSuite

var gs: Node

func before_test() -> void:
	gs = GameState
	gs.new_game()

func test_new_game_defaults() -> void:
	assert_that(gs.current_day).is_equal(1)
	assert_that(gs.current_season).is_equal("spring")
	assert_that(gs.gold).is_equal(100)
	assert_that(gs.get_item_count("wheat_seed")).is_equal(3)
	assert_that(gs.get_flag("prologue_complete")).is_true()

func test_inventory_add_remove() -> void:
	gs.add_item("moly", 2)
	assert_that(gs.get_item_count("moly")).is_equal(2)
	assert_that(gs.has_item("moly", 2)).is_true()
	assert_that(gs.remove_item("moly", 1)).is_true()
	assert_that(gs.get_item_count("moly")).is_equal(1)

func test_seed_to_crop_mapping() -> void:
	assert_that(gs.get_crop_id_from_seed("wheat_seed")).is_equal("wheat")

func test_advance_day_updates_season() -> void:
	gs.current_day = 28
	gs.advance_day()
	assert_that(gs.current_day).is_equal(29)
	assert_that(gs.current_season).is_equal("summer")

func test_plant_and_harvest_cycle() -> void:
	var pos := Vector2i(0, 0)
	gs.plant_crop(pos, "wheat")
	assert_that(gs.farm_plots.has(pos)).is_true()
	gs.farm_plots[pos]["ready_to_harvest"] = true
	gs.harvest_crop(pos)
	assert_that(gs.get_item_count("wheat")).is_greater(0)
