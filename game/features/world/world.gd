extends Node2D

@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var seed_selector: Control = $UI/SeedSelector
@onready var farm_plots: Node2D = $FarmPlots
@onready var quest_markers: Node2D = $QuestMarkers
@onready var boat_marker: Node2D = $QuestMarkers/BoatMarker
@onready var loom_marker: Node2D = $QuestMarkers/LoomMarker

var _active_plot: Node = null
var _quest_marker_refs: Dictionary = {}

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	assert(seed_selector != null, "SeedSelector missing")
	assert(farm_plots != null, "FarmPlots missing")
	assert(quest_markers != null, "QuestMarkers missing")
	assert(boat_marker != null, "BoatMarker missing")
	assert(loom_marker != null, "LoomMarker missing")

	# Cache quest marker references
	for i in range(1, 12):
		var marker = quest_markers.get_node_or_null("Quest%dMarker" % i)
		if marker:
			_quest_marker_refs["quest_%d_active" % i] = marker

	inventory_panel.visible = false
	seed_selector.seed_selected.connect(_on_seed_selected)
	seed_selector.cancelled.connect(_on_seed_cancelled)
	_connect_farm_plots()
	if not GameState.flag_changed.is_connected(_on_flag_changed):
		GameState.flag_changed.connect(_on_flag_changed)
	_update_quest_markers()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):
		if inventory_panel.visible:
			inventory_panel.close()
		else:
			inventory_panel.open()

func _connect_farm_plots() -> void:
	for plot in farm_plots.get_children():
		if plot.has_signal("seed_requested"):
			plot.seed_requested.connect(_on_seed_requested)

func _on_seed_requested(plot: Node) -> void:
	_active_plot = plot
	seed_selector.open()

func _on_seed_selected(seed_id: String) -> void:
	if _active_plot and _active_plot.has_method("plant"):
		_active_plot.plant(seed_id)
		GameState.remove_item(seed_id, 1)
	_active_plot = null

func _on_seed_cancelled() -> void:
	_active_plot = null

func _on_flag_changed(_flag: String, _value: bool) -> void:
	_update_quest_markers()

func _update_quest_markers() -> void:
	# Update all quest markers based on active state
	for flag_name: String in _quest_marker_refs:
		var marker = _quest_marker_refs[flag_name]
		var quest_num = flag_name.replace("quest_", "").replace("_active", "").to_int()
		var complete_flag = "quest_%d_complete" % quest_num
		marker.visible = GameState.get_flag(flag_name) and not GameState.get_flag(complete_flag)

	# Boat marker shows for travel quests
	boat_marker.visible = GameState.get_flag("quest_3_active") \
		or GameState.get_flag("quest_5_active") \
		or GameState.get_flag("quest_6_active") \
		or GameState.get_flag("quest_8_active") \
		or GameState.get_flag("quest_9_active") \
		or GameState.get_flag("quest_11_active")

	# Loom marker shows for weaving quest (Quest 7)
	loom_marker.visible = GameState.get_flag("quest_7_active") and not GameState.get_flag("quest_8_complete")
