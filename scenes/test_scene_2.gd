extends Node2D
## Test Scene 2 script - triggers return to World

func _ready() -> void:
	print("[TestScene2] Scene loaded")

func _unhandled_input(event: InputEvent) -> void:
	# Return to world with SPACE key
	if event.is_action_pressed("ui_select"):
		print("[TestScene2] Returning to World...")
		SceneManager.change_scene("res://scenes/world.tscn")
