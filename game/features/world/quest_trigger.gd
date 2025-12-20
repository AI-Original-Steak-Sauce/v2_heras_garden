extends Area2D
class_name QuestTrigger

@export var required_flag: String = ""
@export var set_flag_on_enter: String = ""
@export var trigger_dialogue: String = ""
@export var one_shot: bool = true

var triggered: bool = false

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

	if trigger_dialogue != "":
		# Start dialogue
		pass
