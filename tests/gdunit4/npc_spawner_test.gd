extends GdUnitTestSuite

func test_npc_spawner_hermes_spawn_and_despawn() -> void:
	var spawner = load("res://game/features/npcs/npc_spawner.gd").new()
	var spawn_points = Node2D.new()
	spawn_points.name = "SpawnPoints"
	var hermes_point = Marker2D.new()
	hermes_point.name = "Hermes"
	spawn_points.add_child(hermes_point)
	spawner.add_child(spawn_points)
	get_tree().root.add_child(spawner)
	await get_tree().process_frame

	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_3_complete", false)
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_true()

	GameState.set_flag("quest_3_complete", true)
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_false()

	spawner.queue_free()
