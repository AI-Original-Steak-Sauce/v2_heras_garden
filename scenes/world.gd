extends Node2D
## World script - adds scene transition test trigger

func _ready() -> void:
	print("[World] Scene loaded")

func _unhandled_input(event: InputEvent) -> void:
	# Test scene transition with SPACE key
	if event.is_action_pressed("ui_select"):
		print("[World] Triggering scene transition test...")
		SceneManager.change_scene("res://scenes/test_scene_2.tscn")
