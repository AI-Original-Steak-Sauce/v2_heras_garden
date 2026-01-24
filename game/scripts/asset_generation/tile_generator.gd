extends Node
## Procedural Tile Generator for Phase 8 Visual Development
## Generates simple pixel art tiles using Godot Image API + FastNoiseLite

signal generation_complete

const TILE_SIZE = 16

func _ready():
	print("Tile Generator initialized")
	# Auto-generate when scene loads
	generate_all_tiles()

## Generate all tiles at once
func generate_all_tiles():
	print("=== Starting procedural tile generation ===")
	var start_time = Time.get_ticks_msec()

	_generate_grass_tile()
	_generate_dirt_tile()
	_generate_stone_tile()
	_generate_water_tile()

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Tile generation complete in %d ms ===" % elapsed)
	generation_complete.emit()

## Generate grass tile with noise texture
func _generate_grass_tile():
	var image = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGB8)
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.3

	for x in TILE_SIZE:
		for y in TILE_SIZE:
			var noise_val = noise.get_noise_2d(x, y)
			# Map noise (-1 to 1) to green colors
			if noise_val > 0.2:
				image.set_pixel(x, y, Color(0.45, 0.65, 0.35))  # Lighter green
			else:
				image.set_pixel(x, y, Color(0.35, 0.55, 0.25))  # Darker green

	# Add some random "grass blades"
	for i in range(8):
		var gx = randi() % TILE_SIZE
		var gy = randi() % TILE_SIZE
		image.set_pixel(gx, gy, Color(0.5, 0.75, 0.4))

	var save_path = "res://game/textures/tiles/grass_procedural.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: grass_procedural.png")
	else:
		print("✗ Failed to save grass tile")

## Generate dirt tile with noise texture
func _generate_dirt_tile():
	var image = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGB8)
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.4

	for x in TILE_SIZE:
		for y in TILE_SIZE:
			var noise_val = noise.get_noise_2d(x, y)
			# Map noise to brown colors
			if noise_val > 0.1:
				image.set_pixel(x, y, Color(0.5, 0.4, 0.3))  # Lighter brown
			else:
				image.set_pixel(x, y, Color(0.4, 0.3, 0.2))  # Darker brown

	# Add small "rocks" or pebbles
	for i in range(5):
		var rx = randi() % TILE_SIZE
		var ry = randi() % TILE_SIZE
		image.set_pixel(rx, ry, Color(0.35, 0.25, 0.15))

	var save_path = "res://game/textures/tiles/dirt_procedural.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: dirt_procedural.png")
	else:
		print("✗ Failed to save dirt tile")

## Generate stone/path tile
func _generate_stone_tile():
	var image = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGB8)
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.5

	for x in TILE_SIZE:
		for y in TILE_SIZE:
			var noise_val = noise.get_noise_2d(x, y)
			# Map noise to gray colors
			var gray_val = remap(noise_val, -1.0, 1.0, 0.4, 0.7)
			image.set_pixel(x, y, Color(gray_val, gray_val, gray_val))

	# Add brick-like pattern
	for x in range(0, TILE_SIZE, 8):
		for y in range(0, TILE_SIZE, 4):
			if (x / 8 + y / 4) % 2 == 0:
				image.set_pixel(x, y, Color(0.3, 0.3, 0.3))

	var save_path = "res://game/textures/tiles/stone_procedural.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: stone_procedural.png")
	else:
		print("✗ Failed to save stone tile")

## Generate water tile with simple wave pattern
func _generate_water_tile():
	var image = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGB8)

	# Base water color
	var base_color = Color(0.3, 0.5, 0.8)
	var light_color = Color(0.4, 0.6, 0.9)

	for x in TILE_SIZE:
		for y in TILE_SIZE:
			# Simple wave pattern using sine
			var wave = sin((x + y) * 0.5) * 0.5 + 0.5
			if wave > 0.5:
				image.set_pixel(x, y, light_color)
			else:
				image.set_pixel(x, y, base_color)

	# Add some "sparkles"
	for i in range(3):
		var sx = randi() % TILE_SIZE
		var sy = randi() % TILE_SIZE
		image.set_pixel(sx, sy, Color(0.8, 0.9, 1.0))

	var save_path = "res://game/textures/tiles/water_procedural.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: water_procedural.png")
	else:
		print("✗ Failed to save water tile")
