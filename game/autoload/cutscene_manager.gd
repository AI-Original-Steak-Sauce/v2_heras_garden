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

	scene.cutscene_finished.connect(func() -> void:
		if is_instance_valid(scene):
			scene.queue_free()
		if current_cutscene == scene:
			current_cutscene = null
		cutscene_finished.emit(scene_path)
	, CONNECT_ONE_SHOT)

	await scene.cutscene_finished

func is_playing() -> bool:
	return current_cutscene != null
