extends SceneTree
## Headless input map validation for Retroid button bindings.

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failed := false

	if not _has_joypad_button("interact", 0):
		print("[FAIL] interact missing Joypad Button 0 (A)")
		failed = true
	else:
		print("[PASS] interact Joypad Button 0 (A)")

	if not _has_joypad_button("ui_inventory", 4):
		print("[FAIL] ui_inventory missing Joypad Button 4 (Select)")
		failed = true
	else:
		print("[PASS] ui_inventory Joypad Button 4 (Select)")

	if failed:
		quit(1)
	else:
		quit(0)

func _has_joypad_button(action: String, button_index: int) -> bool:
	if not InputMap.has_action(action):
		return false
	var events := InputMap.action_get_events(action)
	for event in events:
		if event is InputEventJoypadButton and event.button_index == button_index:
			return true
	return false
