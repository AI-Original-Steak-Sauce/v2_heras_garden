extends Control

var item_id: String = ""
var quantity: int = 0

@onready var icon: TextureRect = $Icon
@onready var qty_label: Label = $QuantityLabel
@onready var highlight: ColorRect = $Highlight

func set_item(id: String, qty: int) -> void:
	item_id = id
	quantity = qty

	var item_data = _load_item_data(id)
	if item_data:
		icon.texture = item_data.icon
		icon.visible = true
		qty_label.text = str(qty) if qty > 1 else ""
		qty_label.visible = qty > 1
	else:
		clear()

func clear() -> void:
	item_id = ""
	quantity = 0
	icon.texture = null
	icon.visible = false
	qty_label.visible = false

func set_selected(selected: bool) -> void:
	highlight.visible = selected

func has_item() -> bool:
	return item_id != ""

func _load_item_data(id: String) -> ItemData:
	var path = "res://game/shared/resources/items/%s.tres" % id
	if ResourceLoader.exists(path):
		return load(path)
	return null
