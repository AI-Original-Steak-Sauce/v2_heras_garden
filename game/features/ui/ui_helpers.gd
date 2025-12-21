class_name UIHelpers
extends Node

static func _get_base_y(panel: Control) -> float:
	if not panel.has_meta("ui_helpers_base_y"):
		panel.set_meta("ui_helpers_base_y", panel.position.y)
	return float(panel.get_meta("ui_helpers_base_y"))

static func open_panel(panel: Control) -> void:
	var base_y = _get_base_y(panel)
	panel.visible = true
	panel.modulate.a = 0.0
	var start_y = base_y + 50
	panel.position.y = start_y

	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	tween.tween_property(panel, "position:y", base_y, 0.2).set_ease(Tween.EASE_OUT)

	AudioController.play_sfx("ui_open")

static func close_panel(panel: Control) -> void:
	var base_y = _get_base_y(panel)
	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 0.0, 0.15)
	tween.tween_property(panel, "position:y", base_y + 30, 0.15)
	tween.chain().tween_callback(func(): panel.visible = false)

	AudioController.play_sfx("ui_close")

static func setup_button_focus(button: Button) -> void:
	button.focus_entered.connect(func():
		var tween = button.create_tween()
		tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)
		AudioController.play_sfx("ui_move")
	)
	button.focus_exited.connect(func():
		var tween = button.create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.1)
	)
