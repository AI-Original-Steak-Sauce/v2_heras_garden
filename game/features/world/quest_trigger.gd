extends Area2D
class_name QuestTrigger

signal quest_activated(quest_id: String, position: Vector2)

@export var required_flag: String = ""
@export var set_flag_on_enter: String = ""
@export var trigger_dialogue: String = ""
@export var one_shot: bool = true

var triggered: bool = false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered and one_shot:
		return
	if not body.is_in_group("player"):
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
