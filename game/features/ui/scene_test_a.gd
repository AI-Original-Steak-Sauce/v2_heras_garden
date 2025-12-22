extends Control

@onready var button: Button = $VBoxContainer/NextButton

func _ready() -> void:
	assert(button != null, "NextButton missing")
	SceneManager.current_scene = self
	button.pressed.connect(_on_next_pressed)

func _on_next_pressed() -> void:
	SceneManager.change_scene("res://game/features/ui/scene_test_b.tscn")
