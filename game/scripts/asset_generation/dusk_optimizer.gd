extends Node
## Dusk Visibility Optimizer for Game Assets
## Improves visibility of sprites in low-light conditions
## Adds subtle outlines, contrast enhancements, and warm highlights

signal optimization_complete

## Optimization colors
const OUTLINE_DARK_SPRITE = Color(0.3, 0.3, 0.4)      # Subtle blue-grey outline
const OUTLINE_PURPLE_SPRITE = Color(0.5, 0.4, 0.6)    # Purple tinted outline
const HIGHLIGHT_WARM = Color(1.0, 0.8, 0.4)           # Gold/orange highlight
const SHADOW_BOOST = 1.15                             # 15% brightness boost for shadows

func _ready():
	print("Dusk Optimizer initialized")
	optimize_all_assets()

## Optimize all critical assets for dusk visibility
func optimize_all_assets():
	print("=== Starting Dusk Optimization ===")
	var start_time = Time.get_ticks_msec()

	# Backup originals
	_backup_assets()

	# Optimize crop sprites (dark nightshade plants)
	_optimize_nightshade_sprites()

	# Optimize environment rocks
	_optimize_rock_sprites()

	# Optimize dark NPC sprites
	_optimize_npc_sprites()

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Dusk optimization complete in %d ms ===" % elapsed)
	optimization_complete.emit()

## Backup original assets before modification
func _backup_assets():
	print("Creating backups of original assets...")
	var backup_dir = "res://game/textures/_backup/"
	DirAccess.make_dir_absolute(backup_dir)

	var assets_to_backup = [
		"res://game/textures/items/crops/nightshade_stage1.png",
		"res://game/textures/items/crops/nightshade_stage2.png",
		"res://game/textures/items/crops/nightshade_stage3.png",
		"res://game/textures/environment/rock_large.png",
		"res://game/textures/environment/rock_small.png",
		"res://game/textures/sprites/aeetes_spritesheet.png",
		"res://game/textures/sprites/scylla_spritesheet.png",
		"res://game/textures/sprites/circe_spritesheet.png"
	]

	for asset_path in assets_to_backup:
		var original = Image.new()
		if original.load(asset_path) == OK:
			var filename = asset_path.get_file()
			var backup_path = backup_dir + filename
			# Only backup if doesn't exist
			if not FileAccess.file_exists(backup_path):
				original.save_png(backup_path)
				print("  Backed up: %s" % filename)
		else:
			print("  Warning: Could not load %s" % asset_path)

## Optimize nightshade crop sprites (dark plants)
func _optimize_nightshade_sprites():
	print("Optimizing nightshade sprites...")

	var stages = ["stage1", "stage2", "stage3"]
	for stage in stages:
		var path = "res://game/textures/items/crops/nightshade_%s.png" % stage
		var img = Image.new()

		if img.load(path) == OK:
			# Add purple outline for magical plant feel
			_add_outline_to_sprite(img, OUTLINE_PURPLE_SPRITE, 1)

			# Boost shadow brightness
			_boost_shadow_brightness(img, SHADOW_BOOST)

			# Add warm highlights on top/center
			_add_edge_highlights(img, HIGHLIGHT_WARM, Vector2(0, -1)) # Highlight from top

			# Save optimized version
			var error = img.save_png(path)
			if error == OK:
				print("  Optimized: nightshade_%s.png" % stage)
			else:
				print("  Failed to save: nightshade_%s.png" % stage)
		else:
			print("  Could not load: %s" % path)

## Optimize rock sprites (add edge highlights)
func _optimize_rock_sprites():
	print("Optimizing rock sprites...")

	var rocks = ["rock_large.png", "rock_small.png"]
	for rock in rocks:
		var path = "res://game/textures/environment/" + rock
		var img = Image.new()

		if img.load(path) == OK:
			# Add lighter edge highlights for definition
			_add_edge_highlights(img, Color(0.7, 0.7, 0.75), Vector2(0, -1))

			# Subtle outline for contrast
			_add_outline_to_sprite(img, Color(0.4, 0.4, 0.45), 1)

			# Save optimized version
			var error = img.save_png(path)
			if error == OK:
				print("  Optimized: %s" % rock)
			else:
				print("  Failed to save: %s" % rock)
		else:
			print("  Could not load: %s" % path)

## Optimize dark NPC sprites (add rim lighting effect)
func _optimize_npc_sprites():
	print("Optimizing NPC sprites...")

	var npcs = [
		{"file": "aeetes_spritesheet.png", "outline": Color(0.5, 0.45, 0.3)},
		{"file": "scylla_spritesheet.png", "outline": Color(0.55, 0.4, 0.55)},
		{"file": "circe_spritesheet.png", "outline": Color(0.6, 0.45, 0.5)}
	]

	for npc in npcs:
		var path = "res://game/textures/sprites/" + npc.file
		var img = Image.new()

		if img.load(path) == OK:
			# Add subtle rim lighting (outline effect)
			_add_rim_lighting(img, npc.outline)

			# Save optimized version
			var error = img.save_png(path)
			if error == OK:
				print("  Optimized: %s" % npc.file)
			else:
				print("  Failed to save: %s" % npc.file)
		else:
			print("  Could not load: %s" % path)

## Add 1-pixel outline to sprite (for non-transparent pixels)
func _add_outline_to_sprite(img: Image, outline_color: Color, thickness: int):
	var width = img.get_width()
	var height = img.get_height()

	# Create a copy to read from while writing to original
	var original = img.duplicate()

	# Convert to RGBA if needed
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	if original.get_format() != Image.FORMAT_RGBA8:
		original.convert(Image.FORMAT_RGBA8)

	for y in range(height):
		for x in range(width):
			var pixel = original.get_pixel(x, y)

			# If pixel is transparent, check neighbors for outline
			if pixel.a < 0.5:
				# Check surrounding pixels within thickness
				for dy in range(-thickness, thickness + 1):
					for dx in range(-thickness, thickness + 1):
						if dx == 0 and dy == 0:
							continue

						var nx = x + dx
						var ny = y + dy

						# Bounds check
						if nx >= 0 and nx < width and ny >= 0 and ny < height:
							var neighbor = original.get_pixel(nx, ny)
							# If neighbor is opaque and we haven't set outline yet
							if neighbor.a >= 0.5:
								var current = img.get_pixel(x, y)
								if current.a < 0.5:
									img.set_pixel(x, y, outline_color)
									break

## Boost brightness of shadow pixels
func _boost_shadow_brightness(img: Image, boost: float):
	var width = img.get_width()
	var height = img.get_height()

	for y in range(height):
		for x in range(width):
			var pixel = img.get_pixel(x, y)
			if pixel.a >= 0.5:
				# Boost brightness for dark pixels
				var luminance = (pixel.r + pixel.g + pixel.b) / 3.0
				if luminance < 0.4:
					pixel.r = min(1.0, pixel.r * boost)
					pixel.g = min(1.0, pixel.g * boost)
					pixel.b = min(1.0, pixel.b * boost)
					img.set_pixel(x, y, pixel)

## Add edge highlights based on light direction
func _add_edge_highlights(img: Image, highlight_color: Color, light_dir: Vector2):
	var width = img.get_width()
	var height = img.get_height()
	var original = img.duplicate()

	# Ensure RGBA format
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	if original.get_format() != Image.FORMAT_RGBA8:
		original.convert(Image.FORMAT_RGBA8)

	for y in range(height):
		for x in range(width):
			var pixel = original.get_pixel(x, y)

			# Only highlight opaque pixels
			if pixel.a >= 0.5:
				# Check neighbor in opposite direction of light (edge facing light)
				var check_x = x - int(light_dir.x)
				var check_y = y - int(light_dir.y)

				if check_x >= 0 and check_x < width and check_y >= 0 and check_y < height:
					var neighbor = original.get_pixel(check_x, check_y)
					# If neighbor is transparent, we're on an edge
					if neighbor.a < 0.5:
						# Blend highlight with original color
						var blended = pixel.lerp(highlight_color, 0.3)
						img.set_pixel(x, y, blended)

## Add rim lighting effect to sprites (subtle outline on edges)
func _add_rim_lighting(img: Image, rim_color: Color):
	var width = img.get_width()
	var height = img.get_height()
	var original = img.duplicate()

	# Ensure RGBA format
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	if original.get_format() != Image.FORMAT_RGBA8:
		original.convert(Image.FORMAT_RGBA8)

	for y in range(height):
		for x in range(width):
			var pixel = original.get_pixel(x, y)

			# Check if this is an edge pixel
			if pixel.a >= 0.5:
				var is_edge = false

				# Check all neighbors
				for dy in range(-1, 2):
					for dx in range(-1, 2):
						if dx == 0 and dy == 0:
							continue

						var nx = x + dx
						var ny = y + dy

						if nx < 0 or nx >= width or ny < 0 or ny >= height:
							is_edge = true
							break

						var neighbor = original.get_pixel(nx, ny)
						if neighbor.a < 0.5:
							is_edge = true
							break

				# Apply subtle rim lighting to edges
				if is_edge:
					var rimmed = pixel.lerp(rim_color, 0.15) # Very subtle
					img.set_pixel(x, y, rimmed)
