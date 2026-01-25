extends Node

signal cutscene_finished(scene_path: String)

var current_cutscene: Node = null

func play_cutscene(scene_path: String) -> void:
	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Cutscene not found: %s" % scene_path)
		return
	var scene = scene_resource.instantiate()
	get_tree().root.add_child(scene)
	current_cutscene = scene

	await scene.cutscene_finished
	if is_instance_valid(scene):
		scene.queue_free()
	if current_cutscene == scene:
		current_cutscene = null
	cutscene_finished.emit(scene_path)

func is_playing() -> bool:
	return current_cutscene != null
