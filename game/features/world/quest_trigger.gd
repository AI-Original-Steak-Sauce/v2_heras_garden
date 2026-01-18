extends Area2D
class_name QuestTrigger

signal quest_activated(quest_id: String, position: Vector2)

@export var required_flag: String = ""
@export var set_flag_on_enter: String = ""
@export var trigger_dialogue: String = ""
@export var one_shot: bool = true

var triggered: bool = false
var _player_inside: bool = false

func _ready() -> void:
	monitoring = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if triggered and one_shot:
		return
	if _player_inside:
		_try_trigger()
		return
	if _has_player_overlap():
		_player_inside = true
		_try_trigger()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_inside = true
	_try_trigger()

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_player_inside = false

func _try_trigger() -> void:
	if triggered and one_shot:
		return
	if required_flag != "" and not GameState.get_flag(required_flag):
		return

	triggered = true

	if set_flag_on_enter != "":
		GameState.set_flag(set_flag_on_enter, true)
		quest_activated.emit(set_flag_on_enter, global_position)

	if trigger_dialogue != "":
		var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_box and dialogue_box.has_method("start_dialogue"):
			dialogue_box.start_dialogue(trigger_dialogue)

func _has_player_overlap() -> bool:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false
