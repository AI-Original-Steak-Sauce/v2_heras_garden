extends StaticBody2D

func interact() -> void:
	# Determine destination based on quest state
	if GameState.get_flag("quest_3_active") or GameState.get_flag("quest_5_active") \
		or GameState.get_flag("quest_6_active") or GameState.get_flag("quest_8_active") \
		or GameState.get_flag("quest_11_active"):
		SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
	elif GameState.get_flag("quest_9_active"):
		SceneManager.change_scene("res://game/features/locations/sacred_grove.tscn")
	else:
		# Show "nowhere to go" message
		print("No destination available")
