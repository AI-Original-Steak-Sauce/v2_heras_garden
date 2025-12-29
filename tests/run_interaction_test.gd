extends SceneTree
## Headless interaction validation for player -> farm plot.

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failed := false
	var game_state = root.get_node_or_null("GameState")
	if game_state == null:
		print("[FAIL] GameState autoload missing")
		quit(1)
		return
	game_state.new_game()
	game_state.set_flag("prologue_complete", false)

	var world_scene = load("res://game/features/world/world.tscn")
	if world_scene == null:
		print("[FAIL] world scene load")
		quit(1)
		return

	var world = world_scene.instantiate()
	root.add_child(world)
	await process_frame

	var player = world.get_node_or_null("Player")
	var plot = world.get_node_or_null("FarmPlots/FarmPlotA")
	if player == null or plot == null:
		print("[FAIL] missing Player or FarmPlotA")
		world.queue_free()
		quit(1)
		return

	player.global_position = plot.global_position + Vector2(-32, 0)
	await physics_frame
	await process_frame

	player._try_interact()
	await process_frame

	if plot.current_state != plot.State.TILLED:
		print("[FAIL] farm plot not tilled via interact")
		failed = true
	else:
		print("[PASS] farm plot tilled via interact")

	world.queue_free()
	if failed:
		quit(1)
	else:
		quit(0)
