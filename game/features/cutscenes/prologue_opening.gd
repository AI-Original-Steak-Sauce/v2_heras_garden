extends CutsceneBase

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.2).timeout
	await show_text("Love can make monsters of us all.", 2.5)
	await show_text("But witchcraft... witchcraft makes them real.", 2.5)
	fade_out(1.0)
	await get_tree().create_timer(1.2).timeout
	GameState.set_flag("prologue_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/world/world.tscn")
