extends SceneTree
## Validates that dialogue choice next_id targets exist.
## Run with: godot --headless --path . --script tests/dialogue_choice_target_test.gd

var failed: int = 0

func _init() -> void:
	call_deferred("_run")

func _fail(message: String) -> void:
	failed += 1
	push_error("[DialogueChoiceTargetTest] " + message)

func _collect_dialogue_paths(root_path: String) -> Array[String]:
	var results: Array[String] = []
	var dir = DirAccess.open(root_path)
	if dir == null:
		return results

	dir.list_dir_begin()
	var name = dir.get_next()
	while name != "":
		if name != "." and name != "..":
			var full_path = root_path + "/" + name
			if dir.current_is_dir():
				results.append_array(_collect_dialogue_paths(full_path))
			elif name.ends_with(".tres") and not name.to_upper().begins_with("TEMPLATE_"):
				results.append(full_path)
		name = dir.get_next()
	dir.list_dir_end()
	return results

func _run() -> void:
	var dialogue_paths = _collect_dialogue_paths("res://game/shared/resources/dialogues")
	if dialogue_paths.is_empty():
		_fail("No dialogue resources found.")

	var dialogue_ids: Dictionary = {}
	for path in dialogue_paths:
		var dialogue = load(path) as DialogueData
		if dialogue:
			dialogue_ids[dialogue.id] = true

	for path in dialogue_paths:
		var dialogue = load(path) as DialogueData
		if dialogue == null:
			_fail("Failed to load: %s" % path)
			continue
		for choice in dialogue.choices:
			var next_id = choice.get("next_id", "")
			if next_id != "" and not dialogue_ids.has(next_id):
				_fail("Missing dialogue target '%s' referenced by '%s'" % [next_id, dialogue.id])

	if failed == 0:
		print("[DialogueChoiceTargetTest] OK")
		quit(0)
	else:
		print("[DialogueChoiceTargetTest] FAIL (%d)" % failed)
		quit(1)
