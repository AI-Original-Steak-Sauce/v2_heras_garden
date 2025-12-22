extends Control

signal item_selected(item_id: String)
signal closed

@onready var item_grid: GridContainer = $ItemGrid
@onready var details_panel: Panel = $DetailsPanel
@onready var gold_label: Label = $GoldDisplay/GoldAmount

const COLUMNS: int = 4
const MAX_SLOTS: int = 24

var selected_index: int = 0
var slot_nodes: Array[Control] = []

func _ready() -> void:
	assert(item_grid != null, "ItemGrid missing")
	assert(details_panel != null, "DetailsPanel missing")
	assert(gold_label != null, "GoldAmount missing")
	_create_slots()
	GameState.inventory_changed.connect(_refresh_inventory)
	GameState.gold_changed.connect(_update_gold)
	_refresh_inventory("", 0)
	_update_gold(GameState.gold)

func _create_slots() -> void:
	var slot_scene = preload("res://game/features/ui/item_slot.tscn")
	for i in range(MAX_SLOTS):
		var slot = slot_scene.instantiate()
		slot.name = "Slot_%d" % i
		item_grid.add_child(slot)
		slot_nodes.append(slot)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_close()
		return

	var moved := false
	if event.is_action_pressed("ui_right"):
		selected_index = (selected_index + 1) % MAX_SLOTS
		moved = true
	elif event.is_action_pressed("ui_left"):
		selected_index = (selected_index - 1 + MAX_SLOTS) % MAX_SLOTS
		moved = true
	elif event.is_action_pressed("ui_down"):
		selected_index = (selected_index + COLUMNS) % MAX_SLOTS
		moved = true
	elif event.is_action_pressed("ui_up"):
		selected_index = (selected_index - COLUMNS + MAX_SLOTS) % MAX_SLOTS
		moved = true

	if moved:
		_update_selection()
		if AudioController.has_sfx("ui_move"):
			AudioController.play_sfx("ui_move")

	if event.is_action_pressed("ui_accept"):
		_select_current()

func _refresh_inventory(_item_id: String, _qty: int) -> void:
	for slot in slot_nodes:
		slot.clear()

	var items = GameState.inventory.keys()
	for i in range(min(items.size(), MAX_SLOTS)):
		var id = items[i]
		var quantity = GameState.inventory[id]
		slot_nodes[i].set_item(id, quantity)

	_update_selection()

func _update_selection() -> void:
	for i in range(slot_nodes.size()):
		slot_nodes[i].set_selected(i == selected_index)
	_update_details()

func _update_details() -> void:
	var slot = slot_nodes[selected_index]
	if slot.has_item():
		details_panel.visible = true
		var item_path = "res://game/shared/resources/items/%s.tres" % slot.item_id
		var item_data = load(item_path)
		if item_data:
			$DetailsPanel/ItemName.text = item_data.display_name
			$DetailsPanel/ItemDescription.text = item_data.description
			$DetailsPanel/ItemIcon.texture = item_data.icon
		else:
			push_error("Missing item resource: %s" % item_path)
	else:
		details_panel.visible = false

func _update_gold(amount: int) -> void:
	gold_label.text = str(amount)

func _select_current() -> void:
	var slot = slot_nodes[selected_index]
	if slot.has_item():
		item_selected.emit(slot.item_id)

func _close() -> void:
	UIHelpers.close_panel(self)
	closed.emit()

func open() -> void:
	UIHelpers.open_panel(self)
	selected_index = 0
	_refresh_inventory("", 0)

func close() -> void:
	_close()
