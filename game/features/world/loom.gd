extends StaticBody2D

## Loom - Weaving Station for Quest 7
## Opens the weaving minigame when player interacts

func interact() -> void:
	# Only allow weaving during Quest 7
	if not GameState.get_flag("quest_7_active"):
		print("[Loom] Cannot use loom - Quest 7 not active")
		return

	print("[Loom] Player interacting - opening weaving minigame")
	SceneManager.change_scene("res://game/features/minigames/weaving_minigame.tscn")
