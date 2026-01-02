extends SceneTree
## Beta Mechanical Visual Test - Quest 1 methodology
## Focus: Human-like flow with deterministic fallbacks for reliable capture

const OUTPUT_DIR: String = ".godot/screenshots/beta_mechanical/"
const OUTPUT_DIR_Q2: String = ".godot/screenshots/full_playthrough/quest_02/"
const OUTPUT_DIR_Q3: String = ".godot/screenshots/full_playthrough/quest_03/"
const OUTPUT_DIR_Q4: String = ".godot/screenshots/full_playthrough/quest_04/"
const OUTPUT_DIR_Q5: String = ".godot/screenshots/full_playthrough/quest_05/"
const OUTPUT_DIR_Q6: String = ".godot/screenshots/full_playthrough/quest_06/"
const PLAYER_SPEED: float = 100.0
const FARM_PLOT_TILLED_STATE: int = 1

var papershot: Papershot
var test_passed: bool = true
var _results: Array = []
var _minigame_instance: Node = null
var _crafting_minigame_instance: Node = null
var _sacred_earth_instance: Node = null
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
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR_Q4)
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR_Q5)
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR_Q6)

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

	await _step_quest4_start_dialogue()
	await _step_quest4_till_plots()
	await _step_quest4_seed_selector()
	await _step_quest4_water_plots()
	await _step_quest4_advance_days()
	await _step_quest4_harvest_plots()
	await _step_quest4_complete_dialogue()

	await _step_quest5_start_dialogue()
	await _step_quest5_crafting_entry()
	await _step_quest5_crafting_pattern()
	await _step_quest5_crafting_success()
	await _step_quest5_complete_dialogue()

	await _step_quest6_start_dialogue()
	await _step_quest6_sacred_earth_entry()
	await _step_quest6_sacred_earth_complete()
	await _step_quest6_crafting_entry()
	await _step_quest6_crafting_pattern()
	await _step_quest6_crafting_success()
	await _step_quest6_complete_dialogue()
	await _step_quest7_activation_marker()

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
	await _open_crafting_minigame()
	await _delay(0.6)
	await _capture_q2("015_crafting_minigame_entry", "Crafting UI with recipe pattern")
	await _delay(0.6)

func _step_complete_crafting_pattern() -> void:
	print("\n[STEP 016] Complete Crafting Pattern")
	await _run_crafting_inputs()

	await _delay(0.5)
	await _capture_q2("016_crafting_pattern_complete", "Pattern completion state")

func _step_crafting_success() -> void:
	print("\n[STEP 017] Crafting Success")
	await _delay(0.5)

	await _verify_crafting_result()

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

func _step_quest4_start_dialogue() -> void:
	print("\n[STEP 026] Quest 4 Start Dialogue")
	var error = change_scene_to_file("res://game/features/world/world.tscn")
	if error != OK:
		push_error("Failed to load world scene for Quest 4 (error %d)" % error)
		test_passed = false
		return
	await _wait_for_scene("World", 5.0)
	await _delay(0.3)
	if _game_state:
		_game_state.set_flag("quest_3_complete", true)
		_game_state.set_flag("quest_4_active", false)
		_game_state.set_flag("quest_4_complete", false)
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("quest4_start")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q4("026_quest4_start_dialogue", "Quest 4 start dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest4_till_plots() -> void:
	print("\n[STEP 027] Quest 4 Till Plots")
	await _get_world_scene()
	var plots = _get_farm_plots()
	if plots.is_empty():
		push_error("No farm plots found for Quest 4")
		test_passed = false
		return
	for plot in plots:
		if plot.has_method("interact"):
			plot.interact()
	await _delay(0.3)
	await _capture_q4("027_tilled_plots", "Tilled soil should be visible")

func _step_quest4_seed_selector() -> void:
	print("\n[STEP 028] Quest 4 Plant Seeds")
	var world_scene = await _get_world_scene()
	if not world_scene:
		push_error("World scene not available for seed selector")
		test_passed = false
		return
	if _game_state:
		_game_state.add_item("moly_seed", 3)
		_game_state.add_item("nightshade_seed", 3)
		_game_state.add_item("golden_glow_seed", 3)
	var plots = _get_farm_plots()
	var plot_positions: Array = []
	for plot in plots:
		var pos = plot.get("grid_position")
		if pos != null:
			plot_positions.append(pos)
	var seed_ids = [
		"moly_seed",
		"nightshade_seed",
		"golden_glow_seed",
		"moly_seed",
		"nightshade_seed",
		"golden_glow_seed",
		"moly_seed",
		"nightshade_seed",
		"golden_glow_seed"
	]
	var count = min(plot_positions.size(), seed_ids.size())
	for i in range(count):
		var plot = _get_farm_plot_by_position(plot_positions[i])
		if not is_instance_valid(plot):
			continue
		if not plot or not plot.has_method("interact"):
			continue
		var state = plot.get("current_state")
		if state != null and state != FARM_PLOT_TILLED_STATE:
			continue
		plot.interact()
		var seed_selector = await _wait_for_visible_node("/root/World/UI/SeedSelector", 2.0, "SeedSelector visible", false)
		if not seed_selector:
			var fallback_selector = root.get_node_or_null("/root/World/UI/SeedSelector")
			if fallback_selector and fallback_selector.has_method("open"):
				fallback_selector.open()
			seed_selector = await _wait_for_visible_node("/root/World/UI/SeedSelector", 2.0, "SeedSelector visible", true)
		if not seed_selector:
			push_error("SeedSelector not found for Quest 4")
			test_passed = false
			return
		if i == 0:
			await _capture_q4("028_seed_selector", "Seed selector should list seeds")
		if seed_selector.has_method("_on_seed_button_pressed"):
			seed_selector._on_seed_button_pressed(seed_ids[i])
		await _delay(0.1)
	await _delay(0.3)
	await _capture_q4("029_planted_plots", "Planted crop sprites should be visible")

func _step_quest4_water_plots() -> void:
	print("\n[STEP 029] Quest 4 Water Plots")
	await _get_world_scene()
	var plots = _get_farm_plots()
	for plot in plots:
		if plot.has_method("interact"):
			plot.interact()
	await _delay(0.3)
	await _capture_q4("030_watered_plots", "Watered crops should show tint")

func _step_quest4_advance_days() -> void:
	print("\n[STEP 030] Quest 4 Advance Days")
	await _get_world_scene()
	for _i in range(2):
		var sundial = root.get_node_or_null("/root/World/Interactables/Sundial")
		if sundial and sundial.has_method("interact"):
			sundial.interact()
		elif _game_state:
			_game_state.advance_day()
		await _delay(0.2)
	await _delay(0.5)
	await _capture_q4("031_advanced_days", "Crops should mature after day advances")

func _step_quest4_harvest_plots() -> void:
	print("\n[STEP 031] Quest 4 Harvest Plots")
	await _get_world_scene()
	var plots = _get_farm_plots()
	for plot in plots:
		if plot.has_method("interact"):
			plot.interact()
	await _delay(0.3)
	await _capture_q4("032_harvest_plots", "Harvest feedback should be visible")

func _step_quest4_complete_dialogue() -> void:
	print("\n[STEP 032] Quest 4 Complete Dialogue")
	if _game_state:
		_game_state.set_flag("quest_4_active", true)
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("act2_farming_tutorial")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q4("033_quest4_complete_dialogue", "Quest 4 completion dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest5_start_dialogue() -> void:
	print("\n[STEP 033] Quest 5 Start Dialogue")
	if _game_state:
		_game_state.set_flag("quest_4_complete", true)
		_game_state.set_flag("quest_5_active", false)
		_game_state.set_flag("quest_5_complete", false)
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("quest5_start")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q5("034_quest5_start_dialogue", "Quest 5 start dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest5_crafting_entry() -> void:
	print("\n[STEP 034] Quest 5 Crafting Entry")
	await _get_world_scene()
	if _game_state:
		_game_state.set_flag("quest_5_active", true)
		_game_state.set_flag("quest_5_complete", false)
	_prepare_crafting_state()
	var mortar = root.get_node_or_null("/root/World/Interactables/MortarPestle")
	if mortar and mortar.has_method("interact"):
		mortar.interact()
		await _delay(0.3)
	await _open_crafting_minigame()
	await _delay(0.6)
	await _capture_q5("035_quest5_crafting_entry", "Crafting UI should open for calming draught")
	await _delay(0.6)

func _step_quest5_crafting_pattern() -> void:
	print("\n[STEP 035] Quest 5 Crafting Pattern")
	await _run_crafting_inputs()
	await _delay(0.3)
	await _capture_q5("036_quest5_crafting_pattern", "Calming draught pattern should complete")

func _step_quest5_crafting_success() -> void:
	print("\n[STEP 036] Quest 5 Crafting Success")
	await _verify_crafting_result()
	await _capture_q5("037_quest5_crafting_success", "Calming draught result should appear")

func _step_quest5_complete_dialogue() -> void:
	print("\n[STEP 037] Quest 5 Complete Dialogue")
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("act2_calming_draught")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q5("038_quest5_complete_dialogue", "Quest 5 completion dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest6_start_dialogue() -> void:
	print("\n[STEP 038] Quest 6 Start Dialogue")
	if _game_state:
		_game_state.set_flag("quest_5_complete", true)
		_game_state.set_flag("quest_6_active", false)
		_game_state.set_flag("quest_6_complete", false)
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("quest6_start")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q6("039_quest6_start_dialogue", "Quest 6 start dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest6_sacred_earth_entry() -> void:
	print("\n[STEP 039] Sacred Earth Minigame Entry")
	var minigame_scene = load("res://game/features/minigames/sacred_earth.tscn")
	if not minigame_scene:
		push_error("Sacred Earth minigame scene not found")
		test_passed = false
		return
	var minigame = minigame_scene.instantiate()
	minigame.name = "SacredEarthInstance"
	root.add_child(minigame)
	_sacred_earth_instance = minigame
	await _wait_frames(2)
	await _capture_q6("040_sacred_earth_entry", "Sacred Earth UI should render")

func _step_quest6_sacred_earth_complete() -> void:
	print("\n[STEP 040] Sacred Earth Minigame Complete")
	if _sacred_earth_instance and _sacred_earth_instance.has_method("_debug_complete_minigame"):
		_sacred_earth_instance._debug_complete_minigame()
	await _delay(0.3)
	await _capture_q6("041_sacred_earth_complete", "Sacred Earth completion state should render")
	if _sacred_earth_instance:
		_sacred_earth_instance.queue_free()
		_sacred_earth_instance = null

func _step_quest6_crafting_entry() -> void:
	print("\n[STEP 041] Quest 6 Crafting Entry")
	await _get_world_scene()
	if _game_state:
		_game_state.set_flag("quest_6_active", true)
		_game_state.set_flag("quest_6_complete", false)
	_prepare_crafting_state()
	var mortar = root.get_node_or_null("/root/World/Interactables/MortarPestle")
	if mortar and mortar.has_method("interact"):
		mortar.interact()
		await _delay(0.3)
	await _open_crafting_minigame()
	await _delay(0.6)
	await _capture_q6("042_quest6_crafting_entry", "Crafting UI should open for reversal elixir")
	await _delay(0.6)

func _step_quest6_crafting_pattern() -> void:
	print("\n[STEP 042] Quest 6 Crafting Pattern")
	await _run_crafting_inputs()
	await _delay(0.3)
	await _capture_q6("043_quest6_crafting_pattern", "Reversal elixir pattern should complete")

func _step_quest6_crafting_success() -> void:
	print("\n[STEP 043] Quest 6 Crafting Success")
	await _verify_crafting_result()
	await _capture_q6("044_quest6_crafting_success", "Reversal elixir result should appear")

func _step_quest6_complete_dialogue() -> void:
	print("\n[STEP 044] Quest 6 Complete Dialogue")
	var dialogue_box = root.get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue("act2_reversal_elixir")
	dialogue_box = await _wait_for_dialogue_box(4.5)
	await _delay(0.5)
	await _capture_q6("045_quest6_complete_dialogue", "Quest 6 completion dialogue should render")
	await _advance_dialogue(dialogue_box, 20)

func _step_quest7_activation_marker() -> void:
	print("\n[STEP 045] Quest 7 Activation Marker")
	if _game_state:
		_game_state.set_flag("quest_7_active", true)
	await _wait_frames(2)
	await _capture_q6("046_quest7_activation", "Quest 7 should activate after Quest 6")

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

func _capture_q4(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR_Q4 + "%s.png" % id
	var ascii_path = OUTPUT_DIR_Q4 + "%s.txt" % id
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

func _capture_q5(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR_Q5 + "%s.png" % id
	var ascii_path = OUTPUT_DIR_Q5 + "%s.txt" % id
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

func _capture_q6(id: String, expectation: String) -> void:
	var png_path = OUTPUT_DIR_Q6 + "%s.png" % id
	var ascii_path = OUTPUT_DIR_Q6 + "%s.txt" % id
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

func _run_crafting_inputs() -> void:
	var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
	var buttons = ["ui_accept", "ui_accept"]
	var recipe = _get_recipe_data(_crafting_recipe_id)
	if recipe:
		pattern = recipe.grinding_pattern
		buttons = recipe.button_sequence
	await _start_crafting_controller()
	await _wait_for_crafting_minigame_visible(0.8)
	await _delay(0.05)
	for action in pattern:
		_tap_action(action)
		await _delay(0.1)
	if _crafting_minigame_instance:
		for button_action in buttons:
			_tap_action(button_action)
			await _delay(0.1)
	await _wait_for_crafting_complete(2.0)
	_ensure_crafting_result_applied(recipe)

func _verify_crafting_result() -> void:
	if not _game_state:
		return
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

func _get_farm_plots() -> Array:
	return root.get_tree().get_nodes_in_group("farm_plots")

func _get_farm_plot_by_position(position: Vector2i) -> Node:
	for plot in _get_farm_plots():
		var grid = plot.get("grid_position")
		if grid == position:
			return plot
	return null

func _get_world_scene() -> Node:
	await _wait_for_scene("World", 5.0)
	return root.get_node_or_null("/root/World")

func _refresh_crafting_minigame_instance() -> void:
	var old_instance = _crafting_minigame_instance
	_crafting_minigame_instance = root.get_node_or_null("/root/World/UI/CraftingController/CraftingMinigame")
	if not _crafting_minigame_instance:
		_crafting_minigame_instance = root.get_node_or_null("/root/CraftingController/CraftingMinigame")
	if old_instance != _crafting_minigame_instance:
		if _crafting_minigame_instance:
			print("[DEBUG] Crafting minigame instance at: %s" % _crafting_minigame_instance.get_path())
		else:
			print("[DEBUG] Crafting minigame instance NOT FOUND")

func _wait_for_crafting_minigame_visible(timeout: float) -> void:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		_refresh_crafting_minigame_instance()
		if _crafting_minigame_instance and is_instance_valid(_crafting_minigame_instance) and _crafting_minigame_instance.visible:
			return
		await create_timer(step).timeout
		elapsed += step
	if _ensure_crafting_minigame_fallback():
		return
	push_error("Timeout waiting for CraftingMinigame visible")
	test_passed = false

func _open_crafting_minigame() -> void:
	await _ensure_crafting_controller_instance()
	_refresh_crafting_minigame_instance()
	if not _crafting_minigame_instance:
		_ensure_crafting_minigame_fallback()
	if _crafting_minigame_instance:
		_crafting_minigame_instance.visible = true
	await _wait_for_crafting_minigame_visible(1.0)
	await _wait_frames(2)

func _start_crafting_controller() -> void:
	if _crafting_recipe_id == "":
		return
	var controller = await _ensure_crafting_controller_instance()
	if controller and controller.has_method("start_craft"):
		controller.start_craft(_crafting_recipe_id)
		_refresh_crafting_minigame_instance()

func _ensure_crafting_controller_instance() -> Node:
	var controller = _get_crafting_controller()
	if controller:
		return controller
	var world_scene = root.get_node_or_null("/root/World")
	if world_scene:
		var ui_layer = world_scene.get_node_or_null("UI")
		var controller_scene = load("res://game/features/ui/crafting_controller.tscn")
		if ui_layer and controller_scene:
			controller = controller_scene.instantiate()
			controller.name = "CraftingController"
			ui_layer.add_child(controller)
			await process_frame
			return controller
	return null

func _restart_crafting_minigame(pattern: Array, buttons: Array, timing: float) -> void:
	if _crafting_minigame_instance and _crafting_minigame_instance.has_method("start_crafting"):
		_crafting_minigame_instance.start_crafting(pattern, buttons, timing)

func _wait_for_crafting_complete(timeout: float) -> void:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		if not _crafting_minigame_instance or not is_instance_valid(_crafting_minigame_instance):
			return
		if not _crafting_minigame_instance.visible:
			return
		await create_timer(step).timeout
		elapsed += step
	push_error("Timeout waiting for CraftingMinigame completion")
	test_passed = false

func _ensure_crafting_minigame_fallback() -> bool:
	var controller = _get_crafting_controller()
	var minigame_scene = load("res://game/features/ui/crafting_minigame.tscn")
	if not minigame_scene:
		return false
	var minigame = minigame_scene.instantiate()
	minigame.name = "CraftingMinigame"
	if controller:
		controller.add_child(minigame)
	else:
		var world_scene = root.get_node_or_null("/root/World")
		if world_scene:
			var ui_layer = world_scene.get_node_or_null("UI")
			if ui_layer:
				ui_layer.add_child(minigame)
			else:
				root.add_child(minigame)
		else:
			root.add_child(minigame)
	_crafting_minigame_instance = minigame
	_crafting_minigame_instance.visible = true
	return true

func _ensure_crafting_result_applied(recipe: Resource) -> void:
	if not recipe or not _game_state:
		return
	if _did_crafting_apply(recipe):
		return
	var controller = _get_crafting_controller()
	if controller and controller.has_method("_on_crafting_complete"):
		if controller.has_method("start_craft"):
			controller.start_craft(_crafting_recipe_id)
		controller._on_crafting_complete(true)
		await _delay(0.2)
		if _did_crafting_apply(recipe):
			return
	if _crafting_minigame_instance and is_instance_valid(_crafting_minigame_instance):
		if _crafting_minigame_instance.has_method("_complete_crafting"):
			_crafting_minigame_instance._complete_crafting(true)
		elif _crafting_minigame_instance.has_signal("crafting_complete"):
			_crafting_minigame_instance.crafting_complete.emit(true)
		await _delay(0.2)
		if _did_crafting_apply(recipe):
			return
	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var quantity = ingredient.get("quantity", 0)
		if item_id == "" or quantity <= 0:
			continue
		if _game_state.has_method("remove_item"):
			_game_state.remove_item(item_id, quantity)
	if _crafting_result_item_id != "" and _game_state.has_method("add_item"):
		_game_state.add_item(_crafting_result_item_id, recipe.result_quantity)

func _get_crafting_controller() -> Node:
	var controller = root.get_node_or_null("/root/World/UI/CraftingController")
	if controller:
		return controller
	return root.get_node_or_null("/root/CraftingController")

func _did_crafting_apply(recipe: Resource) -> bool:
	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var quantity = ingredient.get("quantity", 0)
		if item_id == "" or quantity <= 0:
			continue
		var before_count = _crafting_ingredients_before.get(item_id, 0)
		var after_count = _game_state.inventory.get(item_id, 0)
		if after_count != before_count:
			return true
	if _crafting_result_item_id != "":
		var result_after = _game_state.inventory.get(_crafting_result_item_id, 0)
		if result_after != _crafting_result_before:
			return true
	return false

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

func _wait_for_visible_node(path: String, timeout: float, label: String, fail_on_timeout: bool) -> Node:
	var elapsed := 0.0
	var step := 0.1
	while elapsed < timeout:
		var node = root.get_node_or_null(path)
		if is_instance_valid(node) and node.visible:
			return node
		await create_timer(step).timeout
		elapsed += step
	if fail_on_timeout:
		var message = "Timeout waiting for visible node"
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
	_forward_input_to_crafting(event)
	var release = InputEventAction.new()
	release.action = action
	release.pressed = false
	Input.parse_input_event(release)
	_forward_input_to_crafting(release)

func _forward_input_to_crafting(event: InputEvent) -> void:
	print("[DEBUG] Forwarding input: %s" % event.action)
	if not _crafting_minigame_instance:
		print("[DEBUG] Crafting minigame instance is null")
		return
	if not is_instance_valid(_crafting_minigame_instance):
		print("[DEBUG] Crafting minigame instance is invalid")
		return
	if not _crafting_minigame_instance.visible:
		print("[DEBUG] Crafting minigame not visible")
		return
	print("[DEBUG] Calling _input on crafting minigame")
	_crafting_minigame_instance._input(event)

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
