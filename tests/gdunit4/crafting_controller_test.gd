extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()

func test_crafting_controller_success_path() -> void:
	var controller = load("res://game/features/ui/crafting_controller.tscn").instantiate()
	get_tree().root.add_child(controller)
	await get_tree().process_frame

	var recipe = controller._get_recipe("moly_grind")
	assert_that(recipe).is_not_null()

	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var qty = ingredient.get("quantity", 0)
		if item_id != "" and qty > 0:
			GameState.add_item(item_id, qty)

	controller.start_craft(recipe.id)
	await get_tree().process_frame
	assert_that(controller.current_recipe).is_not_null()
	assert_that(controller.crafting_minigame.visible).is_true()

	controller._on_crafting_complete(true)
	assert_that(GameState.get_item_count(recipe.result_item_id)).is_greater(0)

	controller.queue_free()

func test_crafting_controller_missing_ingredients_does_not_start() -> void:
	var controller = load("res://game/features/ui/crafting_controller.tscn").instantiate()
	get_tree().root.add_child(controller)
	await get_tree().process_frame

	var recipe = controller._get_recipe("moly_grind")
	assert_that(recipe).is_not_null()

	controller.start_craft(recipe.id)
	await get_tree().process_frame
	assert_that(controller.crafting_minigame.visible).is_false()

	controller.queue_free()
