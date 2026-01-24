extends Node
## Quick runner to generate interactive objects only

func _ready():
	var gen = preload("res://game/scripts/asset_generation/env_object_generator.gd").new()
	add_child(gen)
	gen.generate_interactive_objects()
	print("Interactive object generation complete!")
