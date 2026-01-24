extends Node
## Procedural Environment Object Generator
## Generates pixel art environment sprites for trees and rocks
## Mediterranean garden theme

signal generation_complete

const TREE_SIZE = 64
const ROCK_LARGE_SIZE = 32
const ROCK_SMALL_SIZE = 16

## Color palettes for Mediterranean environment
const COLORS = {
	"oak_tree": {
		"trunk_dark": Color(0.35, 0.25, 0.15),      # Dark brown
		"trunk_mid": Color(0.50, 0.38, 0.22),       # Medium brown
		"trunk_light": Color(0.65, 0.50, 0.30),     # Light brown
		"leaf_dark": Color(0.25, 0.40, 0.18),       # Dark green
		"leaf_mid": Color(0.35, 0.55, 0.28),        # Mid green
		"leaf_light": Color(0.50, 0.70, 0.40),      # Light green
		"leaf_highlight": Color(0.65, 0.80, 0.55)   # Highlight green
	},
	"olive_tree": {
		"trunk_dark": Color(0.45, 0.38, 0.28),      # Gnarled dark gray-brown
		"trunk_mid": Color(0.60, 0.52, 0.40),       # Medium gray-brown
		"trunk_light": Color(0.75, 0.68, 0.55),     # Light gray-brown
		"leaf_dark": Color(0.40, 0.45, 0.30),       # Dark silvery-green
		"leaf_mid": Color(0.52, 0.58, 0.42),        # Mid silvery-green
		"leaf_light": Color(0.65, 0.72, 0.55),      # Light silvery-green
		"leaf_highlight": Color(0.78, 0.82, 0.68)   # Silvery highlight
	},
	"rock": {
		"dark": Color(0.35, 0.38, 0.42),            # Dark gray
		"mid": Color(0.50, 0.54, 0.58),             # Mid gray
		"light": Color(0.65, 0.70, 0.75),           # Light gray
		"highlight": Color(0.80, 0.85, 0.88)        # Highlight
	}
}

func _ready():
	print("Environment Object Generator initialized")
	generate_all_objects()

## Generate all environment objects
func generate_all_objects():
	print("=== Starting environment object generation ===")
	var start_time = Time.get_ticks_msec()

	# Ensure directory exists
	DirAccess.make_dir_absolute("res://game/textures/environment")

	# Generate trees
	_generate_tree_oak()
	_generate_tree_olive()

	# Generate rocks
	_generate_rock_large()
	_generate_rock_small()

	# Generate interactive objects
	generate_interactive_objects()

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Environment object generation complete in %d ms ===" % elapsed)
	generation_complete.emit()

## Generate oak tree sprite (64x64)
func _generate_tree_oak():
	var image = Image.create(TREE_SIZE, TREE_SIZE, false, Image.FORMAT_RGBA8)
	var colors = COLORS.oak_tree

	for x in TREE_SIZE:
		for y in TREE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			var cx = TREE_SIZE / 2.0
			var cy = TREE_SIZE / 2.0 + 8

			# Trunk (bottom center)
			if y >= 40 and y <= 63:
				var trunk_width = 10
				var tx = x - 32
				var ty = y - 51

				# Organic trunk shape (slightly wider at bottom)
				var width_at_y = trunk_width + int(ty * 0.15)

				if abs(tx) <= width_at_y:
					# Trunk shading
					if abs(tx) <= width_at_y * 0.3:
						pixel_color = colors.trunk_light
					elif abs(tx) <= width_at_y * 0.6:
						pixel_color = colors.trunk_mid
					else:
						pixel_color = colors.trunk_dark

			# Leaf canopy (large, rounded)
			if y >= 4 and y <= 48:
				var dx = x - cx
				var dy = y - 26
				var dist = sqrt(dx * dx + dy * dy)

				# Main canopy (elliptical)
				if dist <= 24:
					# Inner detail - multiple leaf clumps
					var clump_offset = sin(x * 0.3) * cos(y * 0.3) * 4

					if dist <= 8 + clump_offset:
						pixel_color = colors.leaf_highlight
					elif dist <= 14 + clump_offset:
						pixel_color = colors.leaf_light
					elif dist <= 19 + clump_offset:
						pixel_color = colors.leaf_mid
					else:
						pixel_color = colors.leaf_dark

				# Add some leaf detail on edges
				if dist > 20 and dist <= 26:
					var detail_angle = atan2(dy, dx)
					var detail_dist = dist + sin(detail_angle * 8) * 2
					if detail_dist <= 24:
						pixel_color = colors.leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/environment/tree_oak.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: tree_oak.png (64x64)")
	else:
		print("✗ Failed to save tree_oak.png")

## Generate olive tree sprite (64x64)
func _generate_tree_olive():
	var image = Image.create(TREE_SIZE, TREE_SIZE, false, Image.FORMAT_RGBA8)
	var colors = COLORS.olive_tree

	for x in TREE_SIZE:
		for y in TREE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			var cx = TREE_SIZE / 2.0
			var cy = TREE_SIZE / 2.0 + 8

			# Gnarled trunk (more twisted than oak)
			if y >= 38 and y <= 63:
				var tx = x - 32
				var ty = y - 50

				# Twisted trunk shape
				var twist = sin(ty * 0.3) * 3
				var width_at_y = 8 + abs(twist)

				if abs(tx - twist) <= width_at_y:
					# Trunk shading (emphasize gnarled texture)
					var texture_noise = sin(x * 0.8 + y * 0.5) * 0.15

					if abs(tx - twist) <= width_at_y * 0.25:
						pixel_color = colors.trunk_light
					elif abs(tx - twist) <= width_at_y * 0.5:
						pixel_color = colors.trunk_mid
					else:
						pixel_color = colors.trunk_dark

					# Add texture variation
					if texture_noise > 0.1:
						pixel_color = pixel_color.darkened(0.1)

			# Silvery-green leaf canopy (spread out, irregular)
			if y >= 6 and y <= 46:
				var dx = x - cx
				var dy = y - 26

				# Irregular canopy shape (multiple clumps)
				var clumps = [
					{"center": Vector2(0, -4), "radius": 18},
					{"center": Vector2(-10, 2), "radius": 14},
					{"center": Vector2(10, 2), "radius": 14},
					{"center": Vector2(-6, 8), "radius": 12},
					{"center": Vector2(6, 8), "radius": 12}
				]

				var in_canopy = false
				var min_dist = 999.0

				for clump in clumps:
					var cdx = dx - clump.center.x
					var cdy = dy - clump.center.y
					var cdist = sqrt(cdx * cdx + cdy * cdy)

					if cdist <= clump.radius:
						in_canopy = true
						min_dist = min(min_dist, cdist)

				if in_canopy:
					# Silvery-green shading
					if min_dist <= 6:
						pixel_color = colors.leaf_highlight
					elif min_dist <= 10:
						pixel_color = colors.leaf_light
					elif min_dist <= 14:
						pixel_color = colors.leaf_mid
					else:
						pixel_color = colors.leaf_dark

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/environment/tree_olive.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: tree_olive.png (64x64)")
	else:
		print("✗ Failed to save tree_olive.png")

## Generate large rock sprite (32x32)
func _generate_rock_large():
	var image = Image.create(ROCK_LARGE_SIZE, ROCK_LARGE_SIZE, false, Image.FORMAT_RGBA8)
	var colors = COLORS.rock

	for x in ROCK_LARGE_SIZE:
		for y in ROCK_LARGE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			var cx = ROCK_LARGE_SIZE / 2.0
			var cy = ROCK_LARGE_SIZE / 2.0 + 2

			var dx = x - cx
			var dy = y - cy

			# Organic rock shape (irregular polygon)
			var angle = atan2(dy, dx)
			var radius = 12 + sin(angle * 5) * 2 + cos(angle * 3) * 1.5
			var dist = sqrt(dx * dx + dy * dy)

			if dist <= radius:
				# Add surface texture
				var texture_noise = sin(x * 0.6) * cos(y * 0.7) * 0.2

				# Layered shading
				if dist <= 4 + texture_noise:
					pixel_color = colors.highlight
				elif dist <= 7 + texture_noise:
					pixel_color = colors.light
				elif dist <= 9 + texture_noise:
					pixel_color = colors.mid
				else:
					pixel_color = colors.dark

				# Add cracks/texture detail
				var crack_intensity = sin(x * 0.8 + y * 0.4) * 0.1
				if crack_intensity > 0.08:
					pixel_color = pixel_color.darkened(0.15)

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/environment/rock_large.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: rock_large.png (32x32)")
	else:
		print("✗ Failed to save rock_large.png")

## Generate small rock sprite (16x16)
func _generate_rock_small():
	var image = Image.create(ROCK_SMALL_SIZE, ROCK_SMALL_SIZE, false, Image.FORMAT_RGBA8)
	var colors = COLORS.rock

	for x in ROCK_SMALL_SIZE:
		for y in ROCK_SMALL_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			var cx = ROCK_SMALL_SIZE / 2.0
			var cy = ROCK_SMALL_SIZE / 2.0 + 1

			var dx = x - cx
			var dy = y - cy

			# Small organic rock shape
			var angle = atan2(dy, dx)
			var radius = 5 + sin(angle * 4) * 1
			var dist = sqrt(dx * dx + dy * dy)

			if dist <= radius:
				# Simple shading for small rock
				var texture_noise = sin(x * 0.5) * cos(y * 0.5) * 0.15

				if dist <= 2 + texture_noise:
					pixel_color = colors.light
				elif dist <= 3.5 + texture_noise:
					pixel_color = colors.mid
				else:
					pixel_color = colors.dark

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/environment/rock_small.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: rock_small.png (16x16)")
	else:
		print("✗ Failed to save rock_small.png")

## Generate all interactive objects
func generate_interactive_objects():
	# Ensure directory exists
	DirAccess.make_dir_absolute("res://game/textures/environment/interactive")

	_generate_signpost()
	_generate_boat()
	_generate_sundial()
	_generate_mortar()

## Generate signpost (32x48) - Wooden sign with Greek text
func _generate_signpost():
	var img = Image.create(32, 48, false, Image.FORMAT_RGBA8)

	# Clear transparent
	for x in 32:
		for y in 48:
			img.set_pixel(x, y, Color(0, 0, 0, 0))

	# Post (vertical)
	for x in range(13, 19):
		for y in range(20, 48):
			var c = COLORS.oak_tree.trunk_mid
			if x == 13 or x == 18:
				c = COLORS.oak_tree.trunk_dark
			img.set_pixel(x, y, c)

	# Sign board (horizontal)
	for x in range(4, 28):
		for y in range(8, 20):
			var c = COLORS.oak_tree.trunk_mid
			if y == 8 or y == 19:
				c = COLORS.oak_tree.trunk_dark
			elif x == 4 or x == 27:
				c = COLORS.oak_tree.trunk_dark
			img.set_pixel(x, y, c)

	# Wood grain hints
	img.set_pixel(10, 12, COLORS.oak_tree.trunk_light)
	img.set_pixel(11, 13, COLORS.oak_tree.trunk_light)
	img.set_pixel(18, 15, COLORS.oak_tree.trunk_light)
	img.set_pixel(19, 16, COLORS.oak_tree.trunk_light)

	# Greek letters hint (Ω and Δ)
	var greek_dark = COLORS.oak_tree.trunk_dark
	# Omega shape
	img.set_pixel(10, 13, greek_dark)
	img.set_pixel(11, 13, greek_dark)
	img.set_pixel(12, 13, greek_dark)
	img.set_pixel(13, 13, greek_dark)
	img.set_pixel(9, 14, greek_dark)
	img.set_pixel(14, 14, greek_dark)
	img.set_pixel(9, 15, greek_dark)
	img.set_pixel(14, 15, greek_dark)

	# Delta shape
	img.set_pixel(17, 13, greek_dark)
	img.set_pixel(18, 12, greek_dark)
	img.set_pixel(18, 13, greek_dark)
	img.set_pixel(18, 14, greek_dark)
	img.set_pixel(19, 14, greek_dark)

	# Interactive affordance (subtle highlight on board)
	img.set_pixel(15, 10, Color(1, 1, 0.8, 0.6))
	img.set_pixel(16, 10, Color(1, 1, 0.8, 0.6))
	img.set_pixel(15, 11, Color(1, 1, 0.7, 0.4))
	img.set_pixel(16, 11, Color(1, 1, 0.7, 0.4))

	var save_path = "res://game/textures/environment/interactive/signpost.png"
	var error = img.save_png(save_path)
	if error == OK:
		print("✓ Generated: signpost.png (32x48)")
	else:
		print("✗ Failed to save signpost.png")

## Generate boat (64x32) - Small fishing boat
func _generate_boat():
	var img = Image.create(64, 32, false, Image.FORMAT_RGBA8)

	# Clear transparent
	for x in 64:
		for y in 32:
			img.set_pixel(x, y, Color(0, 0, 0, 0))

	# Hull (curved bottom)
	for x in range(8, 56):
		var bottom_y = 24
		var curve = int(4.0 * sin(float(x - 8) / 48.0 * PI))
		bottom_y -= curve

		for y in range(16, bottom_y + 1):
			var c = COLORS.oak_tree.trunk_mid
			if y == 16 or y == bottom_y:
				c = COLORS.oak_tree.trunk_dark
			elif x == 8 or x == 55:
				c = COLORS.oak_tree.trunk_dark
			img.set_pixel(x, y, c)

	# Boat rim (highlight)
	for x in range(8, 56):
		img.set_pixel(x, 16, COLORS.oak_tree.trunk_light)

	# Interior (dark)
	for x in range(10, 54):
		for y in range(17, 21):
			img.set_pixel(x, y, COLORS.oak_tree.trunk_dark)

	# Water hint at bottom
	for x in range(6, 58):
		var wave_y = 25 + int(2.0 * sin(float(x) * 0.3))
		if wave_y < 32:
			img.set_pixel(x, wave_y, Color(0.4, 0.6, 0.85, 0.7))
			if wave_y + 1 < 32:
				img.set_pixel(x, wave_y + 1, Color(0.3, 0.45, 0.65, 0.5))

	# Interactive affordance (glow on rim)
	img.set_pixel(32, 16, Color(1, 1, 0.7, 0.8))
	img.set_pixel(31, 16, Color(1, 1, 0.7, 0.6))
	img.set_pixel(33, 16, Color(1, 1, 0.7, 0.6))

	var save_path = "res://game/textures/environment/interactive/boat.png"
	var error = img.save_png(save_path)
	if error == OK:
		print("✓ Generated: boat.png (64x32)")
	else:
		print("✗ Failed to save boat.png")

## Generate sundial (32x32) - Ancient Greek stone sundial
func _generate_sundial():
	var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)

	# Clear transparent
	for x in 32:
		for y in 32:
			img.set_pixel(x, y, Color(0, 0, 0, 0))

	# Base (circular top-down)
	var cx = 16
	var cy = 20
	var radius = 10

	for y in range(cy - radius, cy + radius + 1):
		for x in range(cx - radius, cx + radius + 1):
			var dist = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy))
			if dist <= radius:
				var c = COLORS.rock.mid
				if dist > radius - 2:
					c = COLORS.rock.dark
				elif dist < 3:
					c = COLORS.rock.light
				img.set_pixel(x, y, c)

	# Gnomon (pointer)
	for x in range(14, 18):
		for y in range(8, 20):
			var c = COLORS.rock.mid
			if x == 14 or x == 17:
				c = COLORS.rock.dark
			img.set_pixel(x, y, c)

	# Gnomon tip highlight
	img.set_pixel(15, 8, COLORS.rock.highlight)
	img.set_pixel(16, 8, COLORS.rock.highlight)

	# Hour markers (dots)
	var hour_positions = [6, 11, 16, 21, 26]
	for hx in hour_positions:
		if hx >= cy - radius and hx <= cy + radius:
			img.set_pixel(hx, cy - 8, COLORS.rock.dark)

	# Interactive affordance (glow on center)
	img.set_pixel(16, 15, Color(1, 1, 0.7, 0.7))
	img.set_pixel(16, 16, Color(1, 1, 0.6, 0.5))
	img.set_pixel(15, 16, Color(1, 1, 0.6, 0.4))

	var save_path = "res://game/textures/environment/interactive/sundial.png"
	var error = img.save_png(save_path)
	if error == OK:
		print("✓ Generated: sundial.png (32x32)")
	else:
		print("✗ Failed to save sundial.png")

## Generate mortar (32x32) - Stone mortar for grinding
func _generate_mortar():
	var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)

	# Clear transparent
	for x in 32:
		for y in 32:
			img.set_pixel(x, y, Color(0, 0, 0, 0))

	# Mortar bowl (seen from above)
	var cx = 16
	var cy = 16
	var outer_radius = 12
	var inner_radius = 7

	for y in range(cy - outer_radius, cy + outer_radius + 1):
		for x in range(cx - outer_radius, cx + outer_radius + 1):
			var dist = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy))
			if dist <= outer_radius:
				var c = COLORS.rock.mid

				# Outer edge
				if dist > outer_radius - 2:
					c = COLORS.rock.dark
				# Inner bowl (darker)
				elif dist < inner_radius:
					var shade = float(dist) / float(inner_radius)
					c = COLORS.rock.dark.lerp(COLORS.rock.mid, shade * 0.5)
				# Rim highlight
				elif dist > outer_radius - 4 and dist < outer_radius - 1:
					c = COLORS.rock.light

				img.set_pixel(x, y, c)

	# Texture/grain in bowl
	img.set_pixel(14, 14, COLORS.rock.dark)
	img.set_pixel(17, 15, COLORS.rock.dark)
	img.set_pixel(15, 18, COLORS.rock.dark)
	img.set_pixel(18, 17, COLORS.rock.dark)

	# Pestle hint (diagonal, behind)
	for i in range(8):
		var px = 6 + i * 2
		var py = 8 + i
		if px < 32 and py < 32:
			img.set_pixel(px, py, COLORS.oak_tree.trunk_mid)
			if i == 0 or i == 7:
				img.set_pixel(px, py, COLORS.oak_tree.trunk_dark)

	# Interactive affordance (glow on rim)
	img.set_pixel(16, 4, Color(1, 1, 0.7, 0.7))
	img.set_pixel(16, 5, Color(1, 1, 0.6, 0.5))
	img.set_pixel(15, 5, Color(1, 1, 0.6, 0.4))

	var save_path = "res://game/textures/environment/interactive/mortar.png"
	var error = img.save_png(save_path)
	if error == OK:
		print("✓ Generated: mortar.png (32x32)")
	else:
		print("✗ Failed to save mortar.png")
