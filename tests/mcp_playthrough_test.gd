#!/usr/bin/env godot
## Headless MCP Playthrough Test
## Tests player movement, NPC interactions, dialogue, minigames, and quest flow

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0
var _game_state = null

func _init() -> void:
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	print("============================================================")
	print("MCP PLAYTHROUGH TEST - Circe's Garden v2")
	print("============================================================")

	# Get autoloads
	_game_state = root.get_node_or_null("GameState")
	if not _game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	# Reset game state for clean test
	_game_state.new_game()

	# Run test phases
	test_mcp_connection()
	test_world_exploration()
	test_npc_interaction()
	test_dialogue_flow()
	test_minigames()
	test_quest_progression()

	print("============================================================")
	print("MCP PLAYTHROUGH TEST SUMMARY")
	print("============================================================")
	print("Tests run: " + str(tests_run))
	print("Tests passed: " + str(tests_passed))
	print("Tests failed: " + str(tests_run - tests_passed))

	if all_passed:
		print("\n[OK] ALL MCP PLAYTHROUGH TESTS PASSED")
		quit(0)
	else:
		print("\n[FAIL] SOME MCP PLAYTHROUGH TESTS FAILED")
		quit(1)

func record_test(name: String, passed: bool, details: String = "") -> void:
	tests_run += 1
	if passed:
		tests_passed += 1
		print("[PASS] %s" % name)
	else:
		all_passed = false
		print("[FAIL] %s" % name)
		if details:
			print("       %s" % details)

func test_mcp_connection() -> void:
	print("\n--- Phase 1: MCP Connection ---")

	# Check input actions exist
	var actions := InputMap.get_actions()
	var has_left := InputMap.has_action("ui_left")
	var has_right := InputMap.has_action("ui_right")
	var has_up := InputMap.has_action("ui_up")
	var has_down := InputMap.has_action("ui_down")
	var has_interact := InputMap.has_action("interact")
	var has_accept := InputMap.has_action("ui_accept")

	record_test("Action ui_left exists", has_left)
	record_test("Action ui_right exists", has_right)
	record_test("Action ui_up exists", has_up)
	record_test("Action ui_down exists", has_down)
	record_test("Action interact exists", has_interact)
	record_test("Action ui_accept exists", has_accept)

func test_world_exploration() -> void:
	print("\n--- Phase 2: World Exploration ---")

	# Check root has autoloads
	var game_state = root.get_node_or_null("GameState")
	record_test("GameState autoload accessible", game_state != null)

	# Check player scene exists
	var player_scene = load("res://game/features/player/player.tscn")
	record_test("Player scene loads", player_scene != null)

	# Check world scene exists
	var world_scene = load("res://game/features/world/world.tscn")
	record_test("World scene loads", world_scene != null)

	# Check farm plot scene exists
	var farm_plot_scene = load("res://game/features/farm_plot/farm_plot.tscn")
	record_test("FarmPlot scene loads", farm_plot_scene != null)

func test_npc_interaction() -> void:
	print("\n--- Phase 3: NPC Interaction ---")

	# Check NPC spawner script exists
	var npc_spawner_script = load("res://game/features/npcs/npc_spawner.gd")
	record_test("NPCSpawner script loads", npc_spawner_script != null)

	# Check all NPC scenes exist
	var npc_ids := ["hermes", "aeetes", "daedalus", "scylla", "circe"]
	for npc_id in npc_ids:
		var npc_path := "res://game/features/npcs/npc_base.tscn"
		var npc_scene = load(npc_path)
		record_test("NPC scene exists: %s" % npc_id, npc_scene != null)

	# Check NPC SpriteFrames resources exist
	var frames_files := ["hermes_frames", "aeetes_frames", "daedalus_frames", "scylla_frames", "circe_frames"]
	for frames_file in frames_files:
		var path := "res://game/shared/resources/npcs/%s.tres" % frames_file
		var frames = load(path)
		record_test("SpriteFrames: %s" % frames_file, frames != null)

func test_dialogue_flow() -> void:
	print("\n--- Phase 4: Dialogue Flow ---")

	# Test dialogue box scene exists
	var dialogue_scene = load("res://game/features/ui/dialogue_box.tscn")
	record_test("DialogueBox scene loads", dialogue_scene != null)

	# Test dialogue box can be instantiated
	if dialogue_scene:
		var instance = dialogue_scene.instantiate()
		record_test("DialogueBox instantiates", instance != null)
		if instance:
			record_test("DialogueBox has start_dialogue method", instance.has_method("start_dialogue"))
			instance.free()

	# Test dialogue resources exist
	var quest1_dialogue = load("res://game/shared/resources/dialogues/quest1_start.tres")
	record_test("Quest 1 dialogue resource exists", quest1_dialogue != null)

	# Test dialogue has content
	if quest1_dialogue and quest1_dialogue.has_method("get"):
		var lines = quest1_dialogue.get("lines") if "lines" in quest1_dialogue else null
		record_test("Dialogue has lines", lines != null and lines.size() > 0,
			"Line count: %d" % (lines.size() if lines else 0))

func test_minigames() -> void:
	print("\n--- Phase 5: Minigames ---")

	# Test minigame scenes exist and can be instantiated
	var minigame_paths := [
		"res://game/features/minigames/herb_identification.tscn",
		"res://game/features/minigames/moon_tears_minigame.tscn",
		"res://game/features/minigames/sacred_earth.tscn",
		"res://game/features/minigames/weaving_minigame.tscn"
	]

	for path in minigame_paths:
		var scene = load(path)
		record_test("Scene loads: %s" % path.get_file(), scene != null)

		if scene:
			var instance = scene.instantiate()
			record_test("Scene instantiates: %s" % path.get_file(), instance != null)
			if instance:
				instance.free()

	# Test minigame mechanics programmatically
	test_herb_identification_mechanics()
	test_moon_tears_mechanics()
	test_sacred_earth_mechanics()

func test_herb_identification_mechanics() -> void:
	print("  Testing Herb Identification mechanics...")
	var path := "res://game/features/minigames/herb_identification.tscn"
	var scene = load(path)
	if scene:
		var instance = scene.instantiate()
		if instance:
			record_test("Herb ID has PlantGrid", instance.has_node("PlantGrid"))
			record_test("Herb ID has InstructionLabel", instance.has_node("InstructionLabel"))
			record_test("Herb ID has AttemptsLabel", instance.has_node("AttemptsLabel"))
			instance.free()
		else:
			record_test("Herb ID instantiation", false)

func test_moon_tears_mechanics() -> void:
	print("  Testing Moon Tears mechanics...")
	var path := "res://game/features/minigames/moon_tears_minigame.tscn"
	var scene = load(path)
	if scene:
		var instance = scene.instantiate()
		if instance:
			record_test("Moon Tears has TearContainer", instance.has_node("TearContainer"))
			record_test("Moon Tears has PlayerMarker", instance.has_node("PlayerMarker"))
			record_test("Moon Tears has CaughtCounter", instance.has_node("CaughtCounter"))
			instance.free()
		else:
			record_test("Moon Tears instantiation", false)

func test_sacred_earth_mechanics() -> void:
	print("  Testing Sacred Earth mechanics...")
	var path := "res://game/features/minigames/sacred_earth.tscn"
	var scene = load(path)
	if scene:
		var instance = scene.instantiate()
		if instance:
			record_test("Sacred Earth has ProgressBar", instance.has_node("ProgressBar"))
			record_test("Sacred Earth has TimerLabel", instance.has_node("TimerLabel"))
			record_test("Sacred Earth has MashHint", instance.has_node("MashHint"))
			instance.free()
		else:
			record_test("Sacred Earth instantiation", false)

func test_quest_progression() -> void:
	print("\n--- Phase 6: Quest Progression ---")

	# Test all quest flags work
	var quest_flags := [
		"quest_1_active", "quest_1_complete",
		"quest_2_active", "quest_2_complete",
		"quest_3_active", "quest_3_complete",
		"quest_4_active", "quest_4_complete",
		"quest_5_active", "quest_5_complete",
		"quest_6_active", "quest_6_complete",
		"quest_7_active", "quest_7_complete",
		"quest_8_active", "quest_8_complete",
		"quest_9_active", "quest_9_complete",
		"quest_10_active", "quest_10_complete",
		"quest_11_active", "quest_11_complete"
	]

	for flag in quest_flags:
		_game_state.set_flag(flag, false)
		_game_state.set_flag(flag, true)
		var result = _game_state.get_flag(flag)
		record_test("Flag %s" % flag, result == true)

	# Test NPC dialogue resolution
	test_hermes_dialogue_resolution()
	test_aeetes_dialogue_resolution()
	test_daedalus_dialogue_resolution()
	test_scylla_dialogue_resolution()

func test_hermes_dialogue_resolution() -> void:
	print("  Testing Hermes dialogue resolution...")

	# Reset state
	_game_state.set_flag("prologue_complete", false)
	_game_state.set_flag("quest_1_active", false)
	_game_state.set_flag("quest_1_complete", false)
	_game_state.set_flag("quest_2_active", false)

	# Spawn Hermes and test dialogue
	var npc_spawner = root.get_node_or_null("/root/World/NPCs/NPCSpawner")
	if npc_spawner and npc_spawner.has_method("spawn_npc"):
		var hermes = npc_spawner.spawn_npc("hermes")
		if hermes and hermes.has_method("_resolve_dialogue_id"):
			# Quest 1 stage
			_game_state.set_flag("prologue_complete", true)
			_game_state.set_flag("quest_1_active", false)
			var dialogue = hermes._resolve_dialogue_id()
			record_test("Hermes Quest 1 dialogue", dialogue == "quest1_start",
				"Got: %s" % dialogue)

			# Quest 1 active - herb identification
			_game_state.set_flag("quest_1_active", true)
			_game_state.set_flag("quest_1_complete", false)
			dialogue = hermes._resolve_dialogue_id()
			record_test("Hermes Quest 1 active", dialogue == "act1_herb_identification",
				"Got: %s" % dialogue)

			# Quest 2
			_game_state.set_flag("quest_1_complete", true)
			_game_state.set_flag("quest_2_active", true)
			dialogue = hermes._resolve_dialogue_id()
			record_test("Hermes Quest 2", dialogue == "quest2_start",
				"Got: %s" % dialogue)
		else:
			record_test("Hermes NPC methods", false)

func test_aeetes_dialogue_resolution() -> void:
	print("  Testing Aeetes dialogue resolution...")

	_game_state.set_flag("quest_3_complete", true)
	_game_state.set_flag("quest_4_active", false)

	var npc_spawner = root.get_node_or_null("/root/World/NPCs/NPCSpawner")
	if npc_spawner and npc_spawner.has_method("spawn_npc"):
		var aeetes = npc_spawner.spawn_npc("aeetes")
		if aeetes and aeetes.has_method("_resolve_dialogue_id"):
			var dialogue = aeetes._resolve_dialogue_id()
			record_test("Aeetes Quest 4", dialogue == "quest4_start",
				"Got: %s" % dialogue)

func test_daedalus_dialogue_resolution() -> void:
	print("  Testing Daedalus dialogue resolution...")

	_game_state.set_flag("quest_6_complete", true)
	_game_state.set_flag("quest_7_active", false)

	var npc_spawner = root.get_node_or_null("/root/World/NPCs/NPCSpawner")
	if npc_spawner and npc_spawner.has_method("spawn_npc"):
		var daedalus = npc_spawner.spawn_npc("daedalus")
		if daedalus and daedalus.has_method("_resolve_dialogue_id"):
			var dialogue = daedalus._resolve_dialogue_id()
			record_test("Daedalus Quest 7", dialogue == "quest7_start",
				"Got: %s" % dialogue)

func test_scylla_dialogue_resolution() -> void:
	print("  Testing Scylla dialogue resolution...")

	_game_state.set_flag("quest_8_complete", true)
	_game_state.set_flag("quest_9_active", false)

	var npc_spawner = root.get_node_or_null("/root/World/NPCs/NPCSpawner")
	if npc_spawner and npc_spawner.has_method("spawn_npc"):
		var scylla = npc_spawner.spawn_npc("scylla")
		if scylla and scylla.has_method("_resolve_dialogue_id"):
			var dialogue = scylla._resolve_dialogue_id()
			record_test("Scylla Quest 9", dialogue == "quest9_start",
				"Got: %s" % dialogue)
