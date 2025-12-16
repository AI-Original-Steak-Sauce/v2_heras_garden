extends Node2D
## World script - adds scene transition test trigger

@onready var crafting_ui: Control = $CanvasLayer/CraftingMinigame
@onready var dialogue_ui: Control = $CanvasLayer/DialogueBox

func _ready() -> void:
	print("[World] Scene loaded")
	
	# Connect crafting signal
	if crafting_ui:
		crafting_ui.crafting_complete.connect(_on_crafting_complete)
		crafting_ui.visible = false
	
	# Hide dialogue box initially
	if dialogue_ui:
		dialogue_ui.visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Test scene transition with SPACE key
	if event.is_action_pressed("ui_select"):
		print("[World] Triggering scene transition test...")
		SceneManager.change_scene("res://scenes/test_scene_2.tscn")
	
	# Test crafting minigame with ESC key
	if event.is_action_pressed("ui_cancel"):
		print("[World] Starting crafting test...")
		_test_crafting()
	
	# Test dialogue with D key (if not showing UI)
	if event is InputEventKey and event.pressed and event.keycode == KEY_D:
		if dialogue_ui and not dialogue_ui.visible:
			print("[World] Starting dialogue test...")
			dialogue_ui.start_dialogue("test_greeting")

func _test_crafting() -> void:
	if crafting_ui:
		# Simple test pattern: ↑ → ↓ ← then ENTER ENTER
		var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
		var buttons = ["ui_accept", "ui_accept"]
		crafting_ui.start_crafting(pattern, buttons, 2.0)

func _on_crafting_complete(success: bool) -> void:
	if success:
		print("[World] Crafting succeeded!")
	else:
		print("[World] Crafting failed!")
