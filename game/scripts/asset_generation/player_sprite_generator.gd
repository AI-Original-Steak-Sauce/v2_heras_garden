extends Node
## Procedural Player Sprite Generator for Phase 8 Visual Development
## Generates a 32x32 pixel art player sprite (young farmer character)

signal generation_complete

const SPRITE_SIZE = 32

func _ready():
	print("Player Sprite Generator initialized")
	# Auto-generate when scene loads
	generate_player_sprite()

## Generate player sprite with 4 directional frames
func generate_player_sprite():
	print("=== Starting player sprite generation ===")
	var start_time = Time.get_ticks_msec()

	# Create spritesheet with 4 frames horizontally (4 x 32 = 128 width)
	var spritesheet = Image.create(SPRITE_SIZE * 4, SPRITE_SIZE, false, Image.FORMAT_RGBA8)

	# Generate each frame
	_generate_frame_front(spritesheet, 0)           # Frame 0: facing down (front)
	_generate_frame_left(spritesheet, SPRITE_SIZE)  # Frame 1: facing left
	_generate_frame_right(spritesheet, SPRITE_SIZE * 2)  # Frame 2: facing right
	_generate_frame_back(spritesheet, SPRITE_SIZE * 3)   # Frame 3: facing up (back)

	# Save the spritesheet
	var save_path = "res://game/textures/sprites/player.png"
	# Ensure directory exists
	DirAccess.make_dir_absolute("res://game/textures/sprites")

	var error = spritesheet.save_png(save_path)
	if error == OK:
		print("✓ Generated: player.png (4 directional frames, 32x32 each)")
	else:
		print("✗ Failed to save player sprite")

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Player sprite generation complete in %d ms ===" % elapsed)
	generation_complete.emit()

## Generate front-facing frame (down direction)
func _generate_frame_front(image: Image, offset_x: int):
	# Define colors for young farmer character
	var skin_color = Color(0.87, 0.72, 0.53)      # Mediterranean skin tone
	var hair_color = Color(0.25, 0.18, 0.12)      # Dark brown hair
	var tunic_color = Color(0.65, 0.50, 0.35)     # Earthy brown/tan tunic
	var tunic_shadow = Color(0.50, 0.38, 0.25)    # Darker for depth
	var tunic_light = Color(0.75, 0.60, 0.45)     # Highlight
	var pants_color = Color(0.70, 0.65, 0.55)     # Light tan pants
	var shoe_color = Color(0.35, 0.25, 0.18)      # Brown shoes

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)  # Transparent by default

			# Head area (top section)
			if y >= 4 and y <= 11:
				if x >= 11 and x <= 20:
					# Hair on top and sides
					if y <= 6 or (y >= 7 and (x == 11 or x == 20)):
						pixel_color = hair_color
					# Face
					elif x >= 12 and x <= 19:
						pixel_color = skin_color
						# Eyes
						if y == 8 and (x == 14 or x == 17):
							pixel_color = Color(0.15, 0.10, 0.08)
						# Simple smile
						if y == 10 and x >= 14 and x <= 17:
							pixel_color = Color(0.5, 0.35, 0.25)

			# Neck
			elif y == 12 and x >= 13 and x <= 18:
				pixel_color = skin_color

			# Torso / Tunic
			elif y >= 13 and y <= 21:
				if x >= 10 and x <= 21:
					# Main tunic body
					if x >= 11 and x <= 20:
						# Add subtle shading
						if x <= 14:
							pixel_color = tunic_shadow
						elif x >= 17:
							pixel_color = tunic_light
						else:
							pixel_color = tunic_color
					# Tunic outline
					else:
						pixel_color = tunic_shadow

			# Arms
			elif y >= 14 and y <= 20:
				# Left arm
				if x >= 7 and x <= 9:
					pixel_color = tunic_color
				# Right arm
				elif x >= 22 and x <= 24:
					pixel_color = tunic_color

			# Pants / Legs
			elif y >= 22 and y <= 28:
				if x >= 11 and x <= 15:  # Left leg
					pixel_color = pants_color
				elif x >= 16 and x <= 20:  # Right leg
					pixel_color = pants_color

			# Shoes / Feet
			elif y >= 29 and y <= 31:
				if x >= 11 and x <= 15:  # Left shoe
					pixel_color = shoe_color
				elif x >= 16 and x <= 20:  # Right shoe
					pixel_color = shoe_color

			image.set_pixel(x + offset_x, y, pixel_color)

## Generate left-facing frame
func _generate_frame_left(image: Image, offset_x: int):
	var skin_color = Color(0.87, 0.72, 0.53)
	var hair_color = Color(0.25, 0.18, 0.12)
	var tunic_color = Color(0.65, 0.50, 0.35)
	var tunic_shadow = Color(0.50, 0.38, 0.25)
	var pants_color = Color(0.70, 0.65, 0.55)
	var shoe_color = Color(0.35, 0.25, 0.18)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Head (profile view facing left)
			if y >= 4 and y <= 11:
				if x >= 8 and x <= 18:
					# Hair
					if y <= 6 or x <= 9:
						pixel_color = hair_color
					# Face profile
					elif x >= 10 and x <= 17:
						pixel_color = skin_color
						# Eye
						if y == 8 and x == 12:
							pixel_color = Color(0.15, 0.10, 0.08)
						# Nose suggestion
						if y == 9 and x == 10:
							pixel_color = Color(0.80, 0.65, 0.45)

			# Neck
			elif y == 12 and x >= 11 and x <= 15:
				pixel_color = skin_color

			# Torso (left side visible)
			elif y >= 13 and y <= 21:
				if x >= 9 and x <= 19:
					if x >= 10 and x <= 18:
						pixel_color = tunic_color
					else:
						pixel_color = tunic_shadow

			# Arm (slightly forward)
			elif y >= 14 and y <= 20:
				if x >= 5 and x <= 8:
					pixel_color = tunic_color

			# Legs
			elif y >= 22 and y <= 28:
				if x >= 10 and x <= 14:
					pixel_color = pants_color
				elif x >= 15 and x <= 19:
					pixel_color = pants_color

			# Shoes
			elif y >= 29 and y <= 31:
				if x >= 10 and x <= 14:
					pixel_color = shoe_color
				elif x >= 15 and x <= 19:
					pixel_color = shoe_color

			image.set_pixel(x + offset_x, y, pixel_color)

## Generate right-facing frame
func _generate_frame_right(image: Image, offset_x: int):
	var skin_color = Color(0.87, 0.72, 0.53)
	var hair_color = Color(0.25, 0.18, 0.12)
	var tunic_color = Color(0.65, 0.50, 0.35)
	var tunic_shadow = Color(0.50, 0.38, 0.25)
	var tunic_light = Color(0.75, 0.60, 0.45)
	var pants_color = Color(0.70, 0.65, 0.55)
	var shoe_color = Color(0.35, 0.25, 0.18)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Head (profile view facing right)
			if y >= 4 and y <= 11:
				if x >= 13 and x <= 23:
					# Hair
					if y <= 6 or x >= 22:
						pixel_color = hair_color
					# Face profile
					elif x >= 14 and x <= 21:
						pixel_color = skin_color
						# Eye
						if y == 8 and x == 19:
							pixel_color = Color(0.15, 0.10, 0.08)
						# Nose suggestion
						if y == 9 and x == 21:
							pixel_color = Color(0.80, 0.65, 0.45)

			# Neck
			elif y == 12 and x >= 16 and x <= 20:
				pixel_color = skin_color

			# Torso (right side visible)
			elif y >= 13 and y <= 21:
				if x >= 12 and x <= 22:
					if x >= 13 and x <= 21:
						if x >= 18:
							pixel_color = tunic_light
						else:
							pixel_color = tunic_color
					else:
						pixel_color = tunic_shadow

			# Arm (slightly forward)
			elif y >= 14 and y <= 20:
				if x >= 23 and x <= 26:
					pixel_color = tunic_color

			# Legs
			elif y >= 22 and y <= 28:
				if x >= 12 and x <= 16:
					pixel_color = pants_color
				elif x >= 17 and x <= 21:
					pixel_color = pants_color

			# Shoes
			elif y >= 29 and y <= 31:
				if x >= 12 and x <= 16:
					pixel_color = shoe_color
				elif x >= 17 and x <= 21:
					pixel_color = shoe_color

			image.set_pixel(x + offset_x, y, pixel_color)

## Generate back-facing frame (up direction)
func _generate_frame_back(image: Image, offset_x: int):
	var skin_color = Color(0.87, 0.72, 0.53)
	var hair_color = Color(0.25, 0.18, 0.12)
	var hair_shadow = Color(0.18, 0.12, 0.08)
	var tunic_color = Color(0.65, 0.50, 0.35)
	var tunic_shadow = Color(0.50, 0.38, 0.25)
	var tunic_light = Color(0.75, 0.60, 0.45)
	var pants_color = Color(0.70, 0.65, 0.55)
	var shoe_color = Color(0.35, 0.25, 0.18)

	for x in SPRITE_SIZE:
		for y in SPRITE_SIZE:
			var pixel_color = Color(0, 0, 0, 0)

			# Head from behind (mostly hair)
			if y >= 4 and y <= 11:
				if x >= 11 and x <= 20:
					# Hair (back of head)
					if x >= 12 and x <= 19:
						# Add depth shading
						if x <= 14 or x >= 17:
							pixel_color = hair_shadow
						else:
							pixel_color = hair_color
					# Hair outline
					else:
						pixel_color = hair_shadow

			# Neck (mostly covered)
			elif y == 12 and x >= 13 and x <= 18:
				pixel_color = tunic_color

			# Back of tunic
			elif y >= 13 and y <= 21:
				if x >= 10 and x <= 21:
					if x >= 11 and x <= 20:
						# Simple seam line down center
						if x == 15 or x == 16:
							pixel_color = tunic_shadow
						else:
							pixel_color = tunic_color
					else:
						pixel_color = tunic_shadow

			# Arms from behind
			elif y >= 14 and y <= 20:
				if x >= 7 and x <= 9:
					pixel_color = tunic_color
				elif x >= 22 and x <= 24:
					pixel_color = tunic_color

			# Pants / Legs
			elif y >= 22 and y <= 28:
				if x >= 11 and x <= 15:
					pixel_color = pants_color
				elif x >= 16 and x <= 20:
					pixel_color = pants_color

			# Shoes / Feet
			elif y >= 29 and y <= 31:
				if x >= 11 and x <= 15:
					pixel_color = shoe_color
				elif x >= 16 and x <= 20:
					pixel_color = shoe_color

			image.set_pixel(x + offset_x, y, pixel_color)
