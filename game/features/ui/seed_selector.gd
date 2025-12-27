extends Control

signal seed_selected(seed_id: String)
signal cancelled

@onready var seed_grid: GridContainer = $Panel/SeedGrid
@onready var cancel_button: Button = $Panel/CancelButton

var seed_buttons: Array[Button] = []

func _ready() -> void:
	assert(seed_grid != null, "SeedGrid missing")
	assert(cancel_button != null, "CancelButton missing")
	cancel_button.pressed.connect(_on_cancel)
	visible = false

func open() -> void:
	# Populate grid with seed items from inventory
	for button in seed_buttons:
		button.queue_free()
	seed_buttons.clear()

	var seed_items: Array[String] = []
	for item_id in GameState.inventory.keys():
		if item_id.ends_with("_seed"):
			seed_items.append(item_id)

	if seed_items.is_empty():
		push_error("No seeds in inventory!")
		cancelled.emit()
		return

	for seed_id in seed_items:
		var button = Button.new()
		var item_data = GameState.get_item_data(seed_id)
		if item_data:
			button.text = "%s (%d)" % [item_data.display_name, GameState.get_item_count(seed_id)]
		else:
			button.text = seed_id

		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		seed_grid.add_child(button)
		seed_buttons.append(button)

	if seed_buttons.size() > 0:
		seed_buttons[0].grab_focus()

	UIHelpers.open_panel(self)

func close() -> void:
	UIHelpers.close_panel(self)

func _on_seed_button_pressed(seed_id: String) -> void:
	seed_selected.emit(seed_id)
	close()

func _on_cancel() -> void:
	cancelled.emit()
	close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_on_cancel()
