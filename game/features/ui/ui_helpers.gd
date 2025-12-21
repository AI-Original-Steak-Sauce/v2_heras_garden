extends Node

static func open_panel(panel: Control) -> void:
	panel.visible = true
	panel.modulate.a = 0.0
	var start_y = panel.position.y + 50
	panel.position.y = start_y

	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	tween.tween_property(panel, "position:y", start_y - 50, 0.2).set_ease(Tween.EASE_OUT)

	AudioController.play_sfx("ui_open")

static func close_panel(panel: Control) -> void:
	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 0.0, 0.15)
	tween.tween_property(panel, "position:y", panel.position.y + 30, 0.15)
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
