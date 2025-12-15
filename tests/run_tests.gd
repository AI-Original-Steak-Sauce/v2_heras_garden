extends SceneTree
## Automated test runner for Hera's Garden v2
## Run with: godot --headless --script tests/run_tests.gd

var passed: int = 0
var failed: int = 0

func _init() -> void:
	print("=" * 60)
	print("HERA'S GARDEN V2 - TEST SUITE")
	print("=" * 60)
	print("")

	# Run all tests
	_run_test("Test 1: Autoloads Registered", _test_autoloads)
	_run_test("Test 2: Resource Classes Compile", _test_resource_classes)
	_run_test("Test 3: TILE_SIZE Constant Defined", _test_tile_size)
	_run_test("Test 4: GameState Initialization", _test_game_state_init)

	# Print summary
	print("")
	print("=" * 60)
	print("TEST SUMMARY")
	print("=" * 60)
	print("Passed: %d" % passed)
	print("Failed: %d" % failed)
	print("Total:  %d" % (passed + failed))
	print("")

	if failed == 0:
		print("✅ ALL TESTS PASSED")
		quit(0)
	else:
		print("❌ SOME TESTS FAILED")
		quit(1)

func _run_test(test_name: String, test_callable: Callable) -> void:
	print("[RUNNING] %s" % test_name)
	var result = test_callable.call()
	if result:
		passed += 1
		print("[✅ PASS] %s" % test_name)
	else:
		failed += 1
		print("[❌ FAIL] %s" % test_name)
	print("")

# ============================================
# TEST: Autoloads Registered
# ============================================

func _test_autoloads() -> bool:
	var required_autoloads = ["GameState", "AudioController", "SaveController"]
	var all_exist = true

	for autoload_name in required_autoloads:
		if has_node("/root/" + autoload_name):
			print("  ✓ %s found" % autoload_name)
		else:
			print("  ✗ %s NOT FOUND" % autoload_name)
			all_exist = false

	return all_exist

# ============================================
# TEST: Resource Classes Compile
# ============================================

func _test_resource_classes() -> bool:
	var classes_to_check = ["CropData", "ItemData", "DialogueData", "NPCData"]
	var all_exist = true

	for class_name in classes_to_check:
		if ClassDB.class_exists(class_name):
			print("  ✓ %s class exists" % class_name)
		else:
			print("  ✗ %s class NOT FOUND" % class_name)
			all_exist = false

	return all_exist

# ============================================
# TEST: TILE_SIZE Constant
# ============================================

func _test_tile_size() -> bool:
	var game_state = get_node_or_null("/root/GameState")
	if not game_state:
		print("  ✗ GameState not found")
		return false

	if game_state.has_method("get") or "TILE_SIZE" in game_state:
		var tile_size = game_state.TILE_SIZE
		if tile_size == 32:
			print("  ✓ TILE_SIZE = %d (correct)" % tile_size)
			return true
		else:
			print("  ✗ TILE_SIZE = %d (expected 32)" % tile_size)
			return false
	else:
		print("  ✗ TILE_SIZE constant not defined")
		return false

# ============================================
# TEST: GameState Initialization
# ============================================

func _test_game_state_init() -> bool:
	var game_state = get_node_or_null("/root/GameState")
	if not game_state:
		print("  ✗ GameState not found")
		return false

	var checks_passed = true

	# Check initial values
	if game_state.current_day == 1:
		print("  ✓ current_day initialized to 1")
	else:
		print("  ✗ current_day = %d (expected 1)" % game_state.current_day)
		checks_passed = false

	if game_state.gold == 100:
		print("  ✓ gold initialized to 100")
	else:
		print("  ✗ gold = %d (expected 100)" % game_state.gold)
		checks_passed = false

	if game_state.inventory is Dictionary:
		print("  ✓ inventory is Dictionary")
	else:
		print("  ✗ inventory is not Dictionary")
		checks_passed = false

	if game_state.quest_flags is Dictionary:
		print("  ✓ quest_flags is Dictionary")
	else:
		print("  ✗ quest_flags is not Dictionary")
		checks_passed = false

	# Test inventory methods
	game_state.add_item("test_item", 5)
	if game_state.get_item_count("test_item") == 5:
		print("  ✓ add_item() works")
	else:
		print("  ✗ add_item() failed")
		checks_passed = false

	if game_state.has_item("test_item", 3):
		print("  ✓ has_item() works")
	else:
		print("  ✗ has_item() failed")
		checks_passed = false

	if game_state.remove_item("test_item", 2):
		print("  ✓ remove_item() works")
	else:
		print("  ✗ remove_item() failed")
		checks_passed = false

	if game_state.get_item_count("test_item") == 3:
		print("  ✓ item count correct after removal")
	else:
		print("  ✗ item count incorrect (got %d, expected 3)" % game_state.get_item_count("test_item"))
		checks_passed = false

	return checks_passed
