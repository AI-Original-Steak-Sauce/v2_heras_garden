extends Control

signal minigame_complete(success: bool, items: Array)

@export var plants_per_round: Array[int] = [20, 25, 30]
@export var correct_per_round: Array[int] = [3, 3, 3]
@export var max_wrong: int = 5

@onready var plant_grid: GridContainer = $PlantGrid
@onready var instruction_label: Label = $InstructionLabel
@onready var attempts_label: Label = $AttemptsLabel
@onready var round_label: Label = $RoundLabel

var current_round: int = 0
var correct_found: int = 0
var wrong_count: int = 0
var selected_index: int = 0
var plant_slots: Array[Control] = []

func _ready() -> void:
	_setup_round(0)

func _setup_round(round_num: int) -> void:
	current_round = round_num
	correct_found = 0
	wrong_count = 0
	selected_index = 0
	# Generate plants - correct ones have subtle glow/different stamen color
	_generate_plants(plants_per_round[round_num], correct_per_round[round_num])
	_update_labels()
	_update_selection()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_select_current()
	# D-pad navigation
	elif event.is_action_pressed("ui_right"):
		_move_selection(1)
	elif event.is_action_pressed("ui_left"):
		_move_selection(-1)
	elif event.is_action_pressed("ui_down"):
		_move_selection(5)  # Move down row
	elif event.is_action_pressed("ui_up"):
		_move_selection(-5)

func _select_current() -> void:
	if plant_slots.is_empty():
		return
	var plant = plant_slots[selected_index]
	if plant.get_meta("is_correct", false):
		correct_found += 1
		plant.modulate = Color(0.2, 1.0, 0.2, 1.0)
		if correct_found >= correct_per_round[current_round]:
			_advance_round()
	else:
		wrong_count += 1
		plant.modulate = Color(1.0, 0.2, 0.2, 1.0)
		if wrong_count >= max_wrong:
			minigame_complete.emit(false, [])
	_update_labels()

func _advance_round() -> void:
	current_round += 1
	if current_round >= plants_per_round.size():
		# All rounds complete
		var items = ["pharmaka_flower", "pharmaka_flower", "pharmaka_flower"]
		minigame_complete.emit(true, items)
	else:
		_setup_round(current_round)

func _generate_plants(total_plants: int, correct_plants: int) -> void:
	for child in plant_grid.get_children():
		child.queue_free()
	plant_slots.clear()

	var correct_indices: Array[int] = []
	while correct_indices.size() < correct_plants:
		var idx = randi_range(0, total_plants - 1)
		if not correct_indices.has(idx):
			correct_indices.append(idx)

	for i in range(total_plants):
		var slot := ColorRect.new()
		slot.custom_minimum_size = Vector2(24, 24)
		slot.modulate = Color(0.6, 0.6, 0.6, 1.0)
		var is_correct = correct_indices.has(i)
		if is_correct:
			slot.modulate = Color(0.7, 0.7, 0.3, 1.0)
		slot.set_meta("is_correct", is_correct)
		plant_grid.add_child(slot)
		plant_slots.append(slot)

func _move_selection(delta: int) -> void:
	if plant_slots.is_empty():
		return
	selected_index = clamp(selected_index + delta, 0, plant_slots.size() - 1)
	_update_selection()

func _update_selection() -> void:
	for i in range(plant_slots.size()):
		var slot = plant_slots[i]
		if i == selected_index:
			slot.scale = Vector2(1.1, 1.1)
		else:
			slot.scale = Vector2.ONE

func _update_labels() -> void:
	round_label.text = "Round %d/%d" % [current_round + 1, plants_per_round.size()]
	attempts_label.text = "Wrong: %d/%d" % [wrong_count, max_wrong]
	instruction_label.text = "Find the glowing plants"
