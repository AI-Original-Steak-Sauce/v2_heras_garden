extends Node
## Procedural Crop Sprite Generator
## Generates 32x32 pixel art crop sprites for Nightshade and Wheat

signal generation_complete

const SPRITE_SIZE = 32

func _ready():
	print("Crop Generator initialized")
	# Auto-generate when scene loads
	generate_all_crops()

## Generate all crop assets
func generate_all_crops():
	print("=== Starting crop sprite generation ===")
	var start_time = Time.get_ticks_msec()

	# Ensure directory exists
	DirAccess.make_dir_absolute("res://game/textures/items/crops")

	# Generate Moly crops
	_generate_moly_seed()
	_generate_moly_stage1()
	_generate_moly_stage2()
	_generate_moly_stage3()

	# Generate Nightshade crops
	_generate_nightshade_seed()
	_generate_nightshade_stage1()
	_generate_nightshade_stage2()
	_generate_nightshade_stage3()

	# Generate Wheat crops
	_generate_wheat_seed()
	_generate_wheat_stage1()
	_generate_wheat_stage2()
	_generate_wheat_stage3()

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Crop generation complete in %d ms ===" % elapsed)
	generation_complete.emit()

## ==================== MOLY CROPS ====================

func _generate_moly_seed():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Moly colors - white/purple theme
	var seed_dark = Color(0.35, 0.25, 0.40)      # Dark purple seed
	var seed_medium = Color(0.50, 0.40, 0.55)    # Medium purple
	var seed_light = Color(0.70, 0.60, 0.75)     # Light purple tint
	var hint_white = Color(0.95, 0.95, 1.0)      # White flower hint

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			var cx = SPRITE_SIZE / 2.0
			var cy = SPRITE_SIZE / 2.0

			# Small seed in center
			var dx = x - cx
			var dy = y - cy
			var dist = sqrt(dx * dx + dy * dy)

			if dist <= 3.5:
				# Seed body
				if dist <= 2.5:
					pixel_color = seed_medium
				else:
					pixel_color = seed_light

				# Small highlight
				if abs(dx) <= 1 and abs(dy) <= 1 and y <= cy:
					pixel_color = hint_white

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/moly_seed.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: moly_seed.png")
	else:
		print("✗ Failed to save moly_seed.png")

func _generate_moly_stage1():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Moly colors
	var stem_green = Color(0.45, 0.55, 0.35)      # Green stem
	var leaf_light = Color(0.60, 0.70, 0.50)      # Light green leaves
	var leaf_mid = Color(0.45, 0.55, 0.35)        # Mid green
	var leaf_dark = Color(0.30, 0.40, 0.25)       # Dark green shadow
	var soil_dark = Color(0.35, 0.28, 0.22)       # Soil

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			var cx = SPRITE_SIZE / 2.0
			var cy = SPRITE_SIZE / 2.0 + 4

			# Small soil mound at bottom
			if y >= 26:
				var dx = x - cx
				if abs(dx) <= 8:
					var mound_height = 3 - (abs(dx) * 0.3)
					if y >= (32 - mound_height):
						pixel_color = soil_dark

			# Small stem
			if x >= 15 and x <= 17 and y >= 20 and y <= 26:
				pixel_color = stem_green

			# Two small leaves at top
			if y >= 14 and y <= 20:
				# Left leaf
				if x >= 10 and x <= 15:
					var lx = x - 12.5
					var ly = y - 17.0
					if (lx * lx) / 6.25 + (ly * ly) / 6.25 <= 1.0:
						if y <= 17:
							pixel_color = leaf_light
						elif y >= 18:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

				# Right leaf
				elif x >= 17 and x <= 22:
					var lx = x - 19.5
					var ly = y - 17.0
					if (lx * lx) / 6.25 + (ly * ly) / 6.25 <= 1.0:
						if y <= 17:
							pixel_color = leaf_light
						elif y >= 18:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/moly_stage1.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: moly_stage1.png")
	else:
		print("✗ Failed to save moly_stage1.png")

func _generate_moly_stage2():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Moly colors
	var stem_green = Color(0.45, 0.55, 0.35)
	var leaf_light = Color(0.60, 0.70, 0.50)
	var leaf_mid = Color(0.45, 0.55, 0.35)
	var leaf_dark = Color(0.30, 0.40, 0.25)
	var purple_tint = Color(0.55, 0.45, 0.60)     # Purple tint on stems
	var soil_dark = Color(0.35, 0.28, 0.22)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			var cx = SPRITE_SIZE / 2.0

			# Soil mound
			if y >= 28:
				var dx = x - cx
				if abs(dx) <= 10:
					var mound_height = 4 - (abs(dx) * 0.3)
					if y >= (32 - mound_height):
						pixel_color = soil_dark

			# Main stem
			if x >= 15 and x <= 17 and y >= 12 and y <= 28:
				if y <= 14:
					pixel_color = leaf_light
				elif y >= 26:
					pixel_color = leaf_dark
				else:
					pixel_color = stem_green

			# Lower leaves (4 leaves)
			if y >= 18 and y <= 24:
				# Left leaf
				if x >= 8 and x <= 14:
					var lx = x - 11.0
					var ly = y - 21.0
					if (lx * lx) / 9.0 + (ly * ly) / 6.25 <= 1.0:
						if y <= 20:
							pixel_color = leaf_light
						elif y >= 22:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

				# Right leaf
				elif x >= 18 and x <= 24:
					var lx = x - 21.0
					var ly = y - 21.0
					if (lx * lx) / 9.0 + (ly * ly) / 6.25 <= 1.0:
						if y <= 20:
							pixel_color = leaf_light
						elif y >= 22:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

			# Upper leaves (smaller, 2 leaves)
			if y >= 10 and y <= 16:
				# Left upper leaf
				if x >= 11 and x <= 15:
					var lx = x - 13.0
					var ly = y - 13.0
					if (lx * lx) / 4.0 + (ly * ly) / 4.0 <= 1.0:
						pixel_color = leaf_light

				# Right upper leaf
				elif x >= 17 and x <= 21:
					var lx = x - 19.0
					var ly = y - 13.0
					if (lx * lx) / 4.0 + (ly * ly) / 4.0 <= 1.0:
						pixel_color = leaf_light

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/moly_stage2.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: moly_stage2.png")
	else:
		print("✗ Failed to save moly_stage2.png")

func _generate_moly_stage3():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Moly colors
	var stem_green = Color(0.45, 0.55, 0.35)
	var leaf_light = Color(0.60, 0.70, 0.50)
	var leaf_mid = Color(0.45, 0.55, 0.35)
	var leaf_dark = Color(0.30, 0.40, 0.25)
	var purple_stem = Color(0.55, 0.45, 0.60)
	var flower_white = Color(0.98, 0.98, 1.0)     # White petals
	var flower_cream = Color(0.95, 0.90, 0.85)    # Cream center
	var flower_yellow = Color(0.95, 0.85, 0.40)   # Yellow center
	var soil_dark = Color(0.35, 0.28, 0.22)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			var cx = SPRITE_SIZE / 2.0

			# Soil mound
			if y >= 28:
				var dx = x - cx
				if abs(dx) <= 10:
					var mound_height = 4 - (abs(dx) * 0.3)
					if y >= (32 - mound_height):
						pixel_color = soil_dark

			# Main stem with purple tint
			if x >= 15 and x <= 17 and y >= 8 and y <= 28:
				if y <= 10:
					pixel_color = purple_stem
				elif y >= 26:
					pixel_color = leaf_dark
				else:
					pixel_color = stem_green

			# Multiple leaves (6 leaves total)
			if y >= 16 and y <= 24:
				# Left lower leaf
				if x >= 7 and x <= 14:
					var lx = x - 10.5
					var ly = y - 20.0
					if (lx * lx) / 12.25 + (ly * ly) / 9.0 <= 1.0:
						if y <= 19:
							pixel_color = leaf_light
						elif y >= 21:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

				# Right lower leaf
				elif x >= 18 and x <= 25:
					var lx = x - 21.5
					var ly = y - 20.0
					if (lx * lx) / 12.25 + (ly * ly) / 9.0 <= 1.0:
						if y <= 19:
							pixel_color = leaf_light
						elif y >= 21:
							pixel_color = leaf_dark
						else:
							pixel_color = leaf_mid

			# Middle leaves
			if y >= 12 and y <= 18:
				# Left middle leaf
				if x >= 9 and x <= 14:
					var lx = x - 11.5
					var ly = y - 15.0
					if (lx * lx) / 6.25 + (ly * ly) / 6.25 <= 1.0:
						pixel_color = leaf_light

				# Right middle leaf
				elif x >= 18 and x <= 23:
					var lx = x - 20.5
					var ly = y - 15.0
					if (lx * lx) / 6.25 + (ly * ly) / 6.25 <= 1.0:
						pixel_color = leaf_light

			# Flower head at top (white petals, yellow center)
			if y >= 2 and y <= 10:
				var dx = x - 16.0
				var dy = y - 6.0
				var dist = sqrt(dx * dx + dy * dy)

				# Outer white petals
				if dist <= 4.5:
					# Petal shape (slightly elongated)
					var angle = atan2(dy, dx)
					var petal_factor = 1.0 + 0.3 * cos(4 * angle)
					if dist <= 4.0 * petal_factor:
						pixel_color = flower_white

				# Inner cream ring
				if dist <= 2.5:
					pixel_color = flower_cream

				# Center yellow
				if dist <= 1.5:
					pixel_color = flower_yellow

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/moly_stage3.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: moly_stage3.png")
	else:
		print("✗ Failed to save moly_stage3.png")

## ==================== NIGHTSHADE CROPS ====================

func _generate_nightshade_seed():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Nightshade seed colors - dark with purple tint
	var seed_dark = Color(0.15, 0.08, 0.20)      # Dark purple-black
	var seed_mid = Color(0.25, 0.15, 0.35)       # Mid purple
	var seed_light = Color(0.35, 0.20, 0.45)     # Light purple highlight

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			# Small oval seed in center
			var cx = 16
			var cy = 16
			var dx = x - cx
			var dy = y - cy

			# Oval shape
			if (dx * dx) / 36 + (dy * dy) / 25 <= 1.0:
				# Inner highlight
				if (dx * dx) / 25 + (dy * dy) / 16 <= 1.0:
					pixel_color = seed_light
				# Mid layer
				elif (dx * dx) / 30 + (dy * dy) / 21 <= 1.0:
					pixel_color = seed_mid
				# Outer edge
				else:
					pixel_color = seed_dark

			image.set_pixel(x, y, pixel_color)

	# Center the seed better
	var final_image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)
	final_image.blend_rect(image, Rect2(0, 0, SPRITE_SIZE, SPRITE_SIZE), Vector2(0, 0))

	var save_path = "res://game/textures/items/crops/nightshade_seed.png"
	var error = final_image.save_png(save_path)
	if error == OK:
		print("✓ Generated: nightshade_seed.png")
	else:
		print("✗ Failed to save nightshade_seed.png")

func _generate_nightshade_stage1():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Sprout colors - dark purple leaves with green hint
	var leaf_dark = Color(0.18, 0.12, 0.28)      # Dark purple-green
	var leaf_mid = Color(0.28, 0.22, 0.40)       # Mid purple
	var leaf_light = Color(0.38, 0.32, 0.50)     # Light purple
	var stem_color = Color(0.25, 0.20, 0.15)     # Dark stem

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Small stem from bottom
			if y >= 20 and y <= 31 and x >= 15 and x <= 17:
				pixel_color = stem_color

			# Two small leaves at top
			# Left leaf
			if y >= 12 and y <= 20:
				var lx = x - 12
				var ly = y - 16
				if lx >= -3 and lx <= 2 and ly >= -2 and ly <= 2:
					if lx >= -2 and lx <= 1 and ly >= -1 and ly <= 1:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

			# Right leaf
			if y >= 12 and y <= 20:
				var rx = x - 20
				var ry = y - 16
				if rx >= -2 and rx <= 3 and ry >= -2 and ry <= 2:
					if rx >= -1 and rx <= 2 and ry >= -1 and ry <= 1:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/nightshade_stage1.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: nightshade_stage1.png")
	else:
		print("✗ Failed to save nightshade_stage1.png")

func _generate_nightshade_stage2():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Growing plant colors
	var leaf_dark = Color(0.15, 0.10, 0.25)
	var leaf_mid = Color(0.25, 0.18, 0.38)
	var leaf_light = Color(0.35, 0.28, 0.50)
	var toxic_green = Color(0.45, 0.55, 0.25)    # Toxic green accent
	var stem_color = Color(0.22, 0.18, 0.12)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Stem
			if y >= 16 and y <= 31 and x >= 15 and x <= 17:
				pixel_color = stem_color

			# Lower leaves (larger)
			if y >= 14 and y <= 24:
				# Left lower leaf
				var lx = x - 8
				var ly = y - 19
				if lx >= -5 and lx <= 3 and ly >= -3 and ly <= 3:
					var dist = sqrt(lx * lx + ly * ly)
					if dist <= 2.5:
						pixel_color = toxic_green
					elif dist <= 4.0:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

				# Right lower leaf
				var rx = x - 24
				var ry = y - 19
				if rx >= -3 and rx <= 5 and ry >= -3 and ry <= 3:
					var dist = sqrt(rx * rx + ry * ry)
					if dist <= 2.5:
						pixel_color = toxic_green
					elif dist <= 4.0:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

			# Upper leaves (smaller)
			if y >= 8 and y <= 16:
				# Left upper leaf
				var ulx = x - 11
				var uly = y - 12
				if ulx >= -3 and ulx <= 2 and uly >= -2 and uly <= 2:
					if ulx >= -2 and ulx <= 1 and uly >= -1 and uly <= 1:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

				# Right upper leaf
				var urx = x - 21
				var ury = y - 12
				if urx >= -2 and urx <= 3 and ury >= -2 and ury <= 2:
					if urx >= -1 and urx <= 2 and ury >= -1 and ury <= 1:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/nightshade_stage2.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: nightshade_stage2.png")
	else:
		print("✗ Failed to save nightshade_stage2.png")

func _generate_nightshade_stage3():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Full grown plant with poisonous berries
	var leaf_dark = Color(0.12, 0.08, 0.22)
	var leaf_mid = Color(0.22, 0.16, 0.35)
	var leaf_light = Color(0.32, 0.26, 0.48)
	var berry_dark = Color(0.15, 0.05, 0.25)     # Dark purple berries
	var berry_mid = Color(0.35, 0.15, 0.45)      # Mid purple berries
	var berry_light = Color(0.55, 0.35, 0.60)    # Light berry highlight
	var stem_color = Color(0.20, 0.16, 0.10)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Main stem
			if y >= 12 and y <= 31 and x >= 15 and x <= 17:
				pixel_color = stem_color

			# Large foliage base
			if y >= 16 and y <= 28:
				var dx = x - 16
				var dy = y - 22
				var dist = sqrt(dx * dx + dy * dy)
				if dist <= 7.0:
					if dist <= 4.0:
						pixel_color = leaf_light
					else:
						pixel_color = leaf_mid

			# Berry cluster at top center
			if y >= 4 and y <= 12 and x >= 10 and x <= 22:
				# Individual berries
				var berry_centers = [
					Vector2(14, 7), Vector2(18, 7),
					Vector2(12, 9), Vector2(16, 9), Vector2(20, 9),
					Vector2(14, 11), Vector2(18, 11)
				]

				for berry in berry_centers:
					var bx = x - berry.x
					var by = y - berry.y
					var bdist = sqrt(bx * bx + by * by)
					if bdist <= 2.0:
						if bdist <= 0.8:
							pixel_color = berry_light
						elif bdist <= 1.5:
							pixel_color = berry_mid
						else:
							pixel_color = berry_dark

			# Upper leaves framing berries
			if y >= 10 and y <= 18:
				# Left tip
				if x >= 6 and x <= 12:
					var lx = x - 9
					var ly = y - 14
					if abs(lx) + abs(ly) <= 4:
						pixel_color = leaf_mid
				# Right tip
				if x >= 20 and x <= 26:
					var rx = x - 23
					var ry = y - 14
					if abs(rx) + abs(ry) <= 4:
						pixel_color = leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/nightshade_stage3.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: nightshade_stage3.png")
	else:
		print("✗ Failed to save nightshade_stage3.png")

## ==================== WHEAT CROPS ====================

func _generate_wheat_seed():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Wheat seed colors - golden grain
	var seed_dark = Color(0.55, 0.40, 0.15)      # Dark golden brown
	var seed_mid = Color(0.75, 0.58, 0.22)       # Mid golden
	var seed_light = Color(0.92, 0.78, 0.35)     # Light gold highlight

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Small oval grain in center
			var cx = 16
			var cy = 16
			var dx = x - cx
			var dy = y - cy

			# Oval shape for grain
			if (dx * dx) / 25 + (dy * dy) / 16 <= 1.0:
				# Inner highlight
				if (dx * dx) / 16 + (dy * dy) / 10 <= 1.0:
					pixel_color = seed_light
				# Mid layer
				elif (dx * dx) / 20 + (dy * dy) / 13 <= 1.0:
					pixel_color = seed_mid
				# Outer edge
				else:
					pixel_color = seed_dark

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/wheat_seed.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: wheat_seed.png")
	else:
		print("✗ Failed to save wheat_seed.png")

func _generate_wheat_stage1():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Sprout colors - green with golden hint
	var leaf_dark = Color(0.35, 0.45, 0.18)      # Dark green
	var leaf_mid = Color(0.50, 0.60, 0.28)       # Mid green
	var leaf_light = Color(0.65, 0.75, 0.35)     # Light green
	var stem_color = Color(0.40, 0.35, 0.20)     # Greenish stem

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Small stem from bottom
			if y >= 20 and y <= 31 and x >= 15 and x <= 17:
				pixel_color = stem_color

			# Two grass-like blades at top
			# Left blade
			if y >= 10 and y <= 22:
				if x >= 11 and x <= 15:
					var progress = float(y - 10) / 12.0
					var width = int(3 - progress * 1.5)
					var center_x = 13 - int(progress * 2)
					if abs(x - center_x) <= width:
						if width >= 2:
							pixel_color = leaf_light
						else:
							pixel_color = leaf_mid

			# Right blade
			if y >= 10 and y <= 22:
				if x >= 17 and x <= 21:
					var progress = float(y - 10) / 12.0
					var width = int(3 - progress * 1.5)
					var center_x = 19 + int(progress * 2)
					if abs(x - center_x) <= width:
						if width >= 2:
							pixel_color = leaf_light
						else:
							pixel_color = leaf_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/wheat_stage1.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: wheat_stage1.png")
	else:
		print("✗ Failed to save wheat_stage1.png")

func _generate_wheat_stage2():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Growing stalk colors
	var stalk_dark = Color(0.40, 0.48, 0.20)
	var stalk_mid = Color(0.55, 0.65, 0.30)
	var stalk_light = Color(0.70, 0.78, 0.40)
	var leaf_color = Color(0.50, 0.60, 0.28)
	var stem_color = Color(0.45, 0.52, 0.22)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Main stalk (vertical)
			if x >= 15 and x <= 17:
				if y >= 10 and y <= 31:
					pixel_color = stem_color

			# Lower leaf (left)
			if y >= 20 and y <= 28 and x >= 8 and x <= 16:
				var ly = y - 24
				var lx = x - 12
				if abs(ly) <= 3 + abs(lx) * 0.3:
					if abs(lx) <= 1:
						pixel_color = stalk_light
					else:
						pixel_color = leaf_color

			# Upper leaf (right)
			if y >= 14 and y <= 22 and x >= 16 and x <= 24:
				var ly = y - 18
				var lx = x - 20
				if abs(ly) <= 3 + abs(lx) * 0.3:
					if abs(lx) <= 1:
						pixel_color = stalk_light
					else:
						pixel_color = leaf_color

			# Top of stalk with beginning of wheat head
			if y >= 6 and y <= 12 and x >= 14 and x <= 18:
				pixel_color = stalk_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/wheat_stage2.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: wheat_stage2.png")
	else:
		print("✗ Failed to save wheat_stage2.png")

func _generate_wheat_stage3():
	var image = Image.create(SPRITE_SIZE, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Full wheat head colors - golden yellow
	var gold_dark = Color(0.70, 0.52, 0.18)      # Dark gold
	var gold_mid = Color(0.88, 0.72, 0.30)       # Mid gold
	var gold_light = Color(0.98, 0.88, 0.50)     # Light gold highlight
	var stem_color = Color(0.45, 0.52, 0.22)     # Greenish stem

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Stem (lower part still green)
			if x >= 15 and x <= 17:
				if y >= 14 and y <= 31:
					pixel_color = stem_color

			# Wheat head (oval shape at top)
			if y >= 4 and y <= 16 and x >= 10 and x <= 22:
				var cx = 16
				var cy = 10
				var dx = x - cx
				var dy = y - cy

				# Oval shape for wheat head
				if (dx * dx) / 36 + (dy * dy) / 36 <= 1.0:
					# Grain texture - alternating pattern
					var grain_pattern = sin(x * 1.5) * cos(y * 1.5)
					var dist = sqrt(dx * dx + dy * dy)

					if dist <= 2.0:
						pixel_color = gold_light
					elif dist <= 4.0:
						if grain_pattern > 0:
							pixel_color = gold_light
						else:
							pixel_color = gold_mid
					elif dist <= 5.5:
						if grain_pattern > 0.3:
							pixel_color = gold_mid
						else:
							pixel_color = gold_dark
					else:
						pixel_color = gold_dark

				# Awns (bristles) at top of wheat head
				if y >= 2 and y <= 6 and x >= 11 and x <= 21:
					var awn_x = (x - 11) / 2.0
					if int(awn_x) % 2 == 0:
						pixel_color = gold_mid

			image.set_pixel(x, y, pixel_color)

	var save_path = "res://game/textures/items/crops/wheat_stage3.png"
	var error = image.save_png(save_path)
	if error == OK:
		print("✓ Generated: wheat_stage3.png")
	else:
		print("✗ Failed to save wheat_stage3.png")
