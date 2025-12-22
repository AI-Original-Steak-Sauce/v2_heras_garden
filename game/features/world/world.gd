extends Node2D

@onready var inventory_panel: Control = $UI/InventoryPanel

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	inventory_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):
		if inventory_panel.visible:
			inventory_panel.close()
		else:
			inventory_panel.open()
