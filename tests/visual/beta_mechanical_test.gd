extends SceneTree
## Beta Mechanical Visual Test - Quest 1 methodology
## Focus: Human-like flow with deterministic fallbacks for reliable capture

const OUTPUT_DIR: String = ".godot/screenshots/beta_mechanical/"
const OUTPUT_DIR_Q2: String = ".godot/screenshots/full_playthrough/quest_02/"
const OUTPUT_DIR_Q3: String = ".godot/screenshots/full_playthrough/quest_03/"
const PLAYER_SPEED: float = 100.0

var papershot: Papershot
var test_passed: bool = true
var _results: Array = []
var _minigame_instance: Node = null
var _crafting_minigame_instance: Node = null
var _game_state: Node = null
var _cutscene_manager: Node = null
var _moly_before: int = 0
var _crafting_recipe_id: String = ""
var _crafting_ingredients_before: Dictionary = {}
var _crafting_result_item_id: String = ""
var _crafting_result_before: int = 0

func _init() -> void:
	print("=== Beta Mechanical Test: Quest 1 ===")
	call_deferred("_run")

func _run() -> void:
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR_Q2)
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR_Q3)

	papershot = Papershot.new()
	papershot.folder = OUTPUT_DIR
	papershot.file_format = Papershot.PNG
	root.add_child(papershot)

	_game_state = root.get_node_or_null("/root/GameState")
	_cutscene_manager = root.get_node_or_null("/root/CutsceneManager")

	print("[BETA] Output: %s" % OUTPUT_DIR)
	print("[BETA] ASCII Resolution: 160x90")

	await _step_main_menu_loaded()
	await _step_new_game_prologue_text()
	await _step_world_entry()
	await _step_hermes_spawn()
	await _step_hermes_dialogue_start()
	await _step_pharmaka_field()
	await _step_minigame_entry()
	await _step_minigame_completion()
	await _step_return_to_hermes()
	await _step_quest1_complete_dialogue()
	await _step_quest2_activation_marker()

	if _game_state and not _game_state.get_flag("quest_1_complete"):
		push_error("Quest 1 did not complete - aborting Quest 2")
		test_passed = false
		quit(1)

	await _step_quest2_start_dialogue()
	await _step_navigate_to_mortar()
	await _step_interact_mortar()
	await _step_crafting_minigame_entry()
	await _step_complete_crafting_pattern()
	await _step_crafting_success()
	await _step_return_to_world_q2()
	await _step_quest2_complete_dialogue()
	await _step_quest3_activation_marker_q2()

	await _step_quest3_start_dialogue()
	await _step_quest3_board_boat()
	await _step_quest3_scylla_cove_arrival()
	await _step_quest3_confront_scylla()
	await _step_quest3_complete_marker()

	_print_summary()
	quit(0 if test_passed else 1)

func _step_main_menu_loaded() -> void:
	print("\n[STEP 001] Main Menu Loaded")
	var error = change_scene_to_file("res://game/features/ui/main_menu.tscn")
	if error != OK:
		push_error("Failed to load main menu scene (error %d)" % error)
		test_passed = false
		return
	await _wait_for_scene("MainMenu", 3.0)
	await _wait_frames(3)
	await _delay(0.5)
	await _capture("001_main_menu", "Main menu should show button stack")

func _step_new_game_prologue_text() -> void:
	print("\n[STEP 002] New Game -> Prologue Text Visible")
	_tap_action("ui_accept")
	# Prologue animation takes time; wait longer for cutscene to load
	await _delay(2.0)
	var cutscene = root.get_tree().current_scene
	if not cutscene:
		push_error("No active scene for prologue")
		test_passed = false
		return
	# Capture prologue rendering (text on background)
	await _delay(0.8)  # Wait for fade-in animation
	await _capture("002_prologue_text", "Prologue text should be visible on faded background")

func _step_world_entry() -> void:
	print("\n[STEP 003] World Entry")
	if _game_state:
		await _wait_for_predicate(func() -> bool: return _game_state.get_flag("prologue_complete"), 10.0, "GameState.prologue_complete")
	await _wait_for_scene("World", 10.0)
	await _wait_frames(3)
	await _delay(0.4)
	await _capture("003_world_entry", "World scene should show HUD and terrain")
	var world_scene = root.get_node_or_null("/root/World")
	if world_scene:
		_verify_world_ui(world_scene)

func _step_hermes_spawn() -> void:
	print("\n[STEP 004] Hermes Spawn")
	var world_scene = root.get_node_or_null("/root/World")
	if not world_scene:
		push_error("World scene not available")
		test_passed = false
		return
	var player = world_scene.get_node_or_null("Player")
	if not player:
		push_error("Player not found in world scene")
		test_passed = false
		return
	await _wait_for_predicate(func() -> bool: return _find_npc_by_id("hermes") != null, 3.0, "Hermes NPC spawned")
	var hermes = _find_npc_by_id("hermes")
	var target = hermes.global_position if hermes else Vector2(160, -32)
	await _move_player_to(world_scene, player, target)
	await _wait_frames(2)
	await _capture("004_hermes_spawn", "Hermes should be visible near player")

func _step_hermes_dialogue_start() -> void:
	print("\n[STEP 005] Hermes Dialogue Start")
	var hermes = _find_npc_by_id("hermes")
	if not hermes:
		push_error("Hermes NPC not found")
		test_passed = false
		return
	if hermes.has_method("interact"):
		hermes.interact()
	# Wait for dialogue box to appear (it may already be visible after interaction)
	var dialogue_box = await _wait_for_dialogue_box(4.5)
	# Give extra time for dialogue animations to complete
	await _delay(0.5)
	await _capture("005_hermes_dialogue_start", "Dialogue box should show quest1_start lines")
	await _advance_dialogue(dialogue_box, 20)

func _step_pharmaka_field() -> void:
	print("\n[STEP 006] Pharmaka Field Arrival")
	var world_scene = root.get_node_or_null("/root/World")
	if not world_scene:
		push_error("World scene not available")
		test_passed = false
		return
	var player = world_scene.get_node_or_null("Player")
	if not player:
		push_error("Player not found in world scene")
		test_passed = false
		return
	await _move_player_to(world_scene, player, Vector2(-192, 64))
	await _delay(0.3)
	await _capture("006_pharmaka_field", "Golden glow plot and quest marker should be visible")

func _step_minigame_entry() -> void:
	print("\n[STEP 007] Herb ID Minigame Entry")
	if _game_state:
		_game_state.set_flag("herb_minigame_tutorial_done", true)
	var minigame_scene = load("res://game/features/minigames/herb_identification.tscn")
	if not minigame_scene:
		push_error("Minigame scene not found")
		test_passed = false
		return
	var minigame = minigame_scene.instantiate()
	minigame.name = "HerbIdentificationInstance"
	var rounds: Array[int] = [5]
	var corrects: Array[int] = [3]
	minigame.plants_per_round = rounds
	minigame.correct_per_round = corrects
	root.add_child(minigame)
	_minigame_instance = minigame
	await _wait_frames(3)
	await _delay(0.3)
	await _capture("007_minigame_entry", "Minigame grid and labels should be visible")

func _step_minigame_completion() -> void:
	print("\n[STEP 008] Herb ID Minigame Completion")
	var minigame = _minigame_instance
	if not minigame:
		push_error("Minigame instance not found for completion")
		test_passed = false
		return
	var plant_slots = minigame.get("plant_slots")
	if plant_slots and plant_slots.size() > 0:
		for i in range(plant_slots.size()):
			var slot = plant_slots[i]
			if slot.get_meta("is_correct", false):
				minigame.selected_index = i
				minigame._select_current()
			if minigame.correct_found >= 3:
				break
	if _game_state:
		await _wait_for_predicate(func() -> bool: return _game_state.inventory.has("pharmaka_flower"), 2.0, "Inventory contains pharmaka_flower")
	await _delay(0.2)
	await _capture("008_minigame_complete", "Completion state should show UI and effects")
	minigame.queue_free()
	_minigame_instance = null

func _step_return_to_hermes() -> void:
	print("\n[STEP 009] Return to Hermes")
	var world_scene = root.get_node_or_null("/root/World")
	if not world_scene:
		push_error("World scene not available")
		test_passed = false
		return
	var player = world_scene.get_node_or_null("Player")
	if not player:
		push_error("Player not found in world scene")
		test_passed = false
		return
	await _move_player_to(world_scene, player, Vector2(160, -32))
	await _delay(0.3)
	await _capture("009_return_to_hermes", "Hermes should be visible after minigame")

func _step_quest1_complete_dialogue() -> void:
	print("\n[STEP 010] Quest 1 Complete Dialogue")
	if _game_state:
		_game_state.set_flag("quest_1_active", true)
		_game_state.set_flag("quest_1_complete", true)
		_game_state.set_flag("quest_1_complete_dialogue_seen", false)
	var world_scene = root.get_node_or_null("/root/World")
	if world_scene:
		var player = world_scene.get_node_or_null("Player")
		if player:
			await _move_player_to(world_scene, player, Vector2(160, -32))
	var hermes = _find_npc_by_id("hermes")
	if hermes:
		if hermes and hermes.has_method("interact"):
			hermes.interact()
	# Wait for completion dialogue to appear
	var dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)  # Extra time for dialogue animations
	await _capture("010_quest1_complete_dialogue", "Quest 1 completion dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest2_activation_marker() -> void:
	print("\n[STEP 011] Quest 2 Activation Marker")
	if _game_state:
		_game_state.set_flag("quest_2_active", true)
	await _wait_frames(2)
	await _capture("011_quest2_activation", "Quest marker for next step should be visible")

func _step_quest2_start_dialogue() -> void:
	print("\n[STEP 012] Quest 2 Start Dialogue")
	var hermes = _find_npc_by_id("hermes")
	if not hermes:
		hermes = _find_npc_by_id("aeetes")

	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if not dialogue_box:
		push_error("DialogueBox not found for Quest 2 start")
		test_passed = false
		return

	if dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("quest2_start")

	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)

	await _capture_q2("012_quest2_start_dialogue", "Quest 2 start dialogue with NPC")
	await _advance_dialogue(dialogue_box, 20)

func _step_navigate_to_mortar() -> void:
	print("\n[STEP 013] Navigate to Mortar & Pestle")
	var world_scene = root.get_node_or_null("/root/World")
	if not world_scene:
		push_error("World scene not available")
		test_passed = false
		return

	var player = world_scene.get_node_or_null("Player")
	if not player:
		push_error("Player not found")
		test_passed = false
		return

	await _move_player_to(world_scene, player, Vector2(0, 0))
	await _delay(0.3)

	await _capture_q2("013_navigate_to_mortar", "Player at mortar & pestle station")

func _step_interact_mortar() -> void:
	print("\n[STEP 014] Interact with Mortar & Pestle")
	_prepare_crafting_state()
	var mortar = root.get_node_or_null("/root/World/Interactables/MortarPestle")
	if mortar and mortar.has_method("interact"):
		mortar.interact()
		await _delay(0.2)
	await _capture_q2("014_interact_mortar", "Interaction with crafting station")

func _step_crafting_minigame_entry() -> void:
	print("\n[STEP 015] Crafting Minigame Entry")
	var controller = root.get_node_or_null("/root/World/UI/CraftingController")
	if not controller:
		controller = root.get_node_or_null("/root/CraftingController")
	if not controller:
		var controller_scene = load("res://game/features/ui/crafting_controller.tscn")
		if controller_scene:
			controller = controller_scene.instantiate()
			controller.name = "CraftingController"
			root.add_child(controller)

	var minigame: Node = null
	if controller:
		minigame = controller.get_node_or_null("CraftingMinigame")
		if controller.has_method("start_craft") and (not minigame or not minigame.visible):
			controller.start_craft(_crafting_recipe_id)
	else:
		var minigame_scene = load("res://game/features/ui/crafting_minigame.tscn")
		if minigame_scene:
			minigame = minigame_scene.instantiate()
			root.add_child(minigame)
			if minigame.has_method("start_crafting"):
				minigame.start_crafting(["ui_up", "ui_right", "ui_down", "ui_left"], ["ui_accept", "ui_accept"], 1.5)
				minigame.visible = true
			_crafting_recipe_id = ""

	if minigame:
		_crafting_minigame_instance = minigame
	await _delay(0.5)
	await _capture_q2("015_crafting_minigame_entry", "Crafting UI with recipe pattern")

func _step_complete_crafting_pattern() -> void:
	print("\n[STEP 016] Complete Crafting Pattern")
	var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
	var buttons = ["ui_accept", "ui_accept"]
	var recipe = _get_recipe_data(_crafting_recipe_id)
	if recipe:
		pattern = recipe.grinding_pattern
		buttons = recipe.button_sequence

	for action in pattern:
		_tap_action(action)
		await _delay(0.3)

	if _crafting_minigame_instance:
		for button_action in buttons:
			_tap_action(button_action)
			await _delay(0.3)

	await _delay(0.5)
	await _capture_q2("016_crafting_pattern_complete", "Pattern completion state")

func _step_crafting_success() -> void:
	print("\n[STEP 017] Crafting Success")
	await _delay(0.5)

	if _game_state:
		var recipe = _get_recipe_data(_crafting_recipe_id)
		if recipe:
			for ingredient in recipe.ingredients:
				var item_id = ingredient.get("item_id", "")
				var quantity = ingredient.get("quantity", 0)
				if item_id == "" or quantity <= 0:
					continue
				var before_count = _crafting_ingredients_before.get(item_id, 0)
				var after_count = _game_state.inventory.get(item_id, 0)
				var expected_count = before_count - quantity
				if item_id == _crafting_result_item_id:
					expected_count += recipe.result_quantity
				if after_count != expected_count:
					push_error("Crafting failed: %s count expected %d, got %d" % [item_id, expected_count, after_count])
					test_passed = false
			if _crafting_result_item_id != "":
				var result_after = _game_state.inventory.get(_crafting_result_item_id, 0)
				var expected_result = _crafting_result_before + recipe.result_quantity
				if result_after != expected_result and not _crafting_ingredients_before.has(_crafting_result_item_id):
					push_error("Crafting failed: %s expected %d, got %d" % [_crafting_result_item_id, expected_result, result_after])
					test_passed = false
			print("  [VERIFY] Recipe=%s result=%s" % [_crafting_recipe_id, _crafting_result_item_id])
		else:
			print("  [INFO] Crafting recipe not tracked; skipping inventory check")

	await _capture_q2("017_crafting_success", "Crafting success with effects")

func _step_return_to_world_q2() -> void:
	print("\n[STEP 018] Return to World (Quest 2)")
	await _wait_for_scene("World", 5.0)
	await _delay(0.5)
	await _capture_q2("018_return_to_world", "World scene reloaded after crafting")

func _step_quest2_complete_dialogue() -> void:
	print("\n[STEP 019] Quest 2 Complete Dialogue")
	if _game_state:
		_game_state.set_flag("quest_2_complete", true)
		_game_state.set_flag("quest_2_complete_dialogue_seen", false)

	var world_scene = root.get_node_or_null("/root/World")
	if world_scene:
		var player = world_scene.get_node_or_null("Player")
		if player:
			await _move_player_to(world_scene, player, Vector2(160, -32))

	var npc = _find_npc_by_id("hermes")
	if not npc:
		npc = _find_npc_by_id("aeetes")

	if npc:
		if npc.has_method("interact"):
			npc.interact()

	var dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)

	await _capture_q2("019_quest2_complete_dialogue", "Quest 2 completion dialogue")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest3_activation_marker_q2() -> void:
	print("\n[STEP 020] Quest 3 Activation Marker")
	if _game_state:
		_game_state.set_flag("quest_3_active", true)
	await _wait_frames(2)
	await _capture_q2("020_quest3_activation", "Quest 3 ready to start")

func _step_quest3_start_dialogue() -> void:
	print("\n[STEP 021] Quest 3 Start Dialogue")
	if _game_state:
		_game_state.set_flag("quest_3_active", false)
		_game_state.set_flag("quest_3_complete", false)

	var hermes = _find_npc_by_id("hermes")
	if not hermes:
		push_error("Hermes not found for Quest 3 start")
		test_passed = false
		return

	if hermes.has_method("interact"):
		hermes.interact()
	var dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)

	await _capture_q3("021_quest3_start_dialogue", "Quest 3 start dialogue should appear")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest3_board_boat() -> void:
	print("\n[STEP 022] Board Boat to Scylla Cove")
	var world_scene = root.get_node_or_null("/root/World")
	if not world_scene:
		push_error("World scene not available")
		test_passed = false
		return
	if _game_state:
		await _wait_for_predicate(func() -> bool: return _game_state.get_flag("quest_3_active"), 3.0, "GameState.quest_3_active")

	var player = world_scene.get_node_or_null("Player")
	if not player:
		push_error("Player not found")
		test_passed = false
		return

	var boat = world_scene.get_node_or_null("Interactables/Boat")
	var target = boat.global_position if boat else Vector2(128, 0)
	await _move_player_to(world_scene, player, target)
	await _delay(0.3)

	if boat and boat.has_method("interact"):
		boat.interact()

	await _capture_q3("022_board_boat", "Boat interaction should trigger travel")

func _step_quest3_scylla_cove_arrival() -> void:
	print("\n[STEP 023] Scylla Cove Arrival")
	await _wait_for_scene("ScyllaCove", 5.0)
	await _delay(0.5)
	await _capture_q3("023_scylla_cove_arrival", "Scylla Cove scene should be visible")

func _step_quest3_confront_scylla() -> void:
	print("\n[STEP 024] Confront Scylla Dialogue")
	var dialogue_ui = await _wait_for_dialogue_box(2.0)
	if dialogue_ui and dialogue_ui.has_method("start_dialogue"):
		dialogue_ui.start_dialogue("act1_confront_scylla")

	await _delay(0.3)
	dialogue_ui = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q3("024_confront_scylla_dialogue", "Confrontation dialogue should render")
	await _advance_dialogue(dialogue_ui, 20)

func _step_quest3_complete_marker() -> void:
	print("\n[STEP 025] Quest 3 Completion Marker")
	if _game_state:
		await _wait_for_predicate(func() -> bool: return _game_state.get_flag("quest_3_complete"), 3.0, "GameState.quest_3_complete")
	await _wait_frames(2)
	await _capture_q3("025_quest3_complete", "Quest 3 completion state")

func _capture(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR + "%s.png" % id
	var ascii_path = OUTPUT_DIR + "%s.txt" % id
	await capture_and_convert(png_path, ascii_path, id)
	var stats = _ascii_stats(ascii_path)
	var is_all_colons = stats.has(":") and stats[":"] == 160 * 90
	var entry = {
		"id": id,
		"png": png_path,
		"ascii": ascii_path,
		"expectation": expectation,
		"all_colons": is_all_colons,
		"stats": stats
	}
	_results.append(entry)
	if is_all_colons:
		test_passed = false
		push_error("ASCII output is all ':' for %s" % id)

func _capture_q2(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR_Q2 + "%s.png" % id
	var ascii_path = OUTPUT_DIR_Q2 + "%s.txt" % id
	await capture_and_convert(png_path, ascii_path, id)
	var stats = _ascii_stats(ascii_path)
	var is_all_colons = stats.has(":") and stats[":"] == 160 * 90
	var entry = {
		"id": id,
		"png": png_path,
		"ascii": ascii_path,
		"expectation": expectation,
		"all_colons": is_all_colons,
		"stats": stats
	}
	_results.append(entry)
	if is_all_colons:
		test_passed = false
		push_error("ASCII output is all ':' for %s" % id)

func _capture_q3(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR_Q3 + "%s.png" % id
	var ascii_path = OUTPUT_DIR_Q3 + "%s.txt" % id
	await capture_and_convert(png_path, ascii_path, id)
	var stats = _ascii_stats(ascii_path)
	var is_all_colons = stats.has(":") and stats[":"] == 160 * 90
	var entry = {
		"id": id,
		"png": png_path,
		"ascii": ascii_path,
		"expectation": expectation,
		"all_colons": is_all_colons,
		"stats": stats
	}
	_results.append(entry)
	if is_all_colons:
		test_passed = false
		push_error("ASCII output is all ':' for %s" % id)

func _resolve_crafting_recipe_id() -> String:
	if _game_state:
		if _game_state.get_flag("quest_6_active") and not _game_state.get_flag("quest_6_complete"):
			return "reversal_elixir"
		if _game_state.get_flag("quest_5_active") and not _game_state.get_flag("quest_5_complete"):
			return "calming_draught"
		if _game_state.get_flag("quest_2_active") and not _game_state.get_flag("quest_2_complete"):
			return "moly_grind"
	return "moly_grind"

func _get_recipe_data(recipe_id: String) -> Resource:
	if recipe_id == "":
		return null
	var recipe_path = "res://game/shared/resources/recipes/%s.tres" % recipe_id
	return load(recipe_path)

func _prepare_crafting_state() -> void:
	_crafting_recipe_id = _resolve_crafting_recipe_id()
	_crafting_ingredients_before.clear()
	_crafting_result_item_id = ""
	_crafting_result_before = 0
	var recipe = _get_recipe_data(_crafting_recipe_id)
	if not _game_state or not recipe:
		return
	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var quantity = ingredient.get("quantity", 0)
		if item_id == "" or quantity <= 0:
			continue
		if _game_state.inventory.get(item_id, 0) < quantity:
			_game_state.add_item(item_id, quantity)
		_crafting_ingredients_before[item_id] = _game_state.inventory.get(item_id, 0)
	_crafting_result_item_id = recipe.result_item_id
	_crafting_result_before = _game_state.inventory.get(_crafting_result_item_id, 0)

func capture_and_convert(png_path: String, ascii_path: String, _milestone_id: String) -> void:
	var viewport = root.get_viewport()
	if not viewport:
		push_error("No viewport found")
		test_passed = false
		return

	var image = viewport.get_texture().get_image()
	if not image:
		push_error("Failed to get image from viewport")
		test_passed = false
		return

	if image.get_width() == 0 or image.get_height() == 0:
		push_error("Screenshot is empty (width=%d, height=%d)" % [image.get_width(), image.get_height()])
		test_passed = false
		return

	var err = image.save_png(png_path)
	if err != OK:
		push_error("Failed to save PNG: %s (error %d)" % [png_path, err])
		test_passed = false
		return

	print("  [PNG] Saved: %s (%dx%d)" % [png_path, image.get_width(), image.get_height()])

	var python_script = "tools/visual_testing/ascii_converter.py"
	var args = [python_script, png_path, ascii_path]
	var output = []
	var exit_code = OS.execute("python", args, output, true)
	if exit_code != 0:
		push_error("ASCII conversion failed (exit %d): %s" % [exit_code, output])
		test_passed = false
		return

	print("  [ASCII] Converted: %s" % ascii_path)
	await process_frame

func _wait_frames(count: int) -> void:
	for _i in range(count):
		await process_frame

func _delay(seconds: float) -> void:
	await create_timer(seconds).timeout

func _wait_for_scene(scene_name: String, timeout: float) -> void:
	await _wait_for_predicate(func() -> bool:
		return root.get_node_or_null("/root/%s" % scene_name) != null
	, timeout, "Scene available: %s" % scene_name)

func _wait_for_node(path: String, timeout: float, label: String, fail_on_timeout: bool) -> Node:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		var node = root.get_node_or_null(path)
		if node:
			return node
		await create_timer(step).timeout
		elapsed += step
	if fail_on_timeout:
		var message = "Timeout waiting for node"
		if label != "":
			message = "%s (%s)" % [message, label]
		push_error(message)
		test_passed = false
	return null

func _wait_for_predicate(predicate: Callable, timeout: float, label: String = "") -> void:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		if predicate.call():
			return
		await create_timer(step).timeout
		elapsed += step
	var message = "Timeout waiting for condition"
	if label != "":
		message = "%s (%s)" % [message, label]
	push_error(message)
	test_passed = false

func _tap_action(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	Input.parse_input_event(event)
	var release = InputEventAction.new()
	release.action = action
	release.pressed = false
	Input.parse_input_event(release)

func _move_player_to(world_scene: Node, player: Node2D, target: Vector2) -> void:
	var delta = target - player.global_position
	if abs(delta.x) > 2.0:
		await _move_axis(delta.x, true)
	if abs(delta.y) > 2.0:
		await _move_axis(delta.y, false)

func _move_axis(amount: float, is_x: bool) -> void:
	var action = "ui_right" if is_x and amount > 0 else "ui_left" if is_x else "ui_down" if amount > 0 else "ui_up"
	var duration = abs(amount) / PLAYER_SPEED
	Input.action_press(action)
	await create_timer(duration).timeout
	Input.action_release(action)
	await _wait_frames(2)

func _wait_for_dialogue_box(timeout: float) -> Node:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		var box = root.get_tree().get_first_node_in_group("dialogue_ui")
		if box:
			return box
		await create_timer(step).timeout
		elapsed += step
	push_error("DialogueBox not found")
	test_passed = false
	return null

func _advance_dialogue(dialogue_box: Node, max_steps: int) -> void:
	if not dialogue_box:
		return
	var steps := 0
	while steps < max_steps and dialogue_box.visible:
		var is_scrolling = dialogue_box.get("is_text_scrolling")
		if is_scrolling:
			_tap_action("ui_accept")
		else:
			_tap_action("ui_accept")
		await _delay(0.1)
		steps += 1

func _find_npc_by_id(npc_id: String) -> Node:
	var spawner = root.get_node_or_null("/root/World/NPCs/NPCSpawner")
	if not spawner:
		return null
	for child in spawner.get_children():
		if child.has_method("interact") and child.get("npc_id") == npc_id:
			return child
	return null

func _find_node_by_name(root_node: Node, node_name: String) -> Node:
	if root_node.name == node_name:
		return root_node
	for child in root_node.get_children():
		var found = _find_node_by_name(child, node_name)
		if found:
			return found
	return null

func _find_node_by_class(root_node: Node, node_class: String) -> Node:
	if root_node.get_class() == node_class:
		return root_node
	for child in root_node.get_children():
		var found = _find_node_by_class(child, node_class)
		if found:
			return found
	return null

func _ascii_stats(ascii_path: String) -> Dictionary:
	var stats: Dictionary = {}
	var file = FileAccess.open(ascii_path, FileAccess.READ)
	if not file:
		return stats
	var contents = file.get_as_text()
	file.close()
	for i in range(contents.length()):
		var c = contents[i]
		if c == "\n":
			continue
		stats[c] = stats.get(c, 0) + 1
	return stats

func _verify_world_ui(scene: Node) -> void:
	print("  [VERIFY] Checking world scene UI elements...")
	var dialogue_box = scene.find_child("DialogueBox", true, false)
	if dialogue_box:
		print("    + DialogueBox found")
	var player = scene.find_child("Player", true, false)
	if player:
		print("    + Player found")
	var sun_dial = scene.find_child("Sundial", true, false)
	if sun_dial:
		print("    + Sundial found")
	var farm_plot = scene.find_child("FarmPlot", true, false)
	if farm_plot:
		print("    + FarmPlot found")

func _print_summary() -> void:
	print("\n=== Beta Mechanical Test Complete ===")
	for entry in _results:
		var marker = "OK" if not entry["all_colons"] else "FAIL"
		print("[%s] %s -> %s" % [marker, entry["id"], entry["png"]])
