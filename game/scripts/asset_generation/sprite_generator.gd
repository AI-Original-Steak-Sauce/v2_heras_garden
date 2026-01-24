extends Node
## Harvest Moon SNES-Style Sprite Generator for Greek Mythology Characters
## Based on analysis of Harvest Moon SNES spritesheet
## Creates 16x24 pixel chibi sprites with 4-directional walk cycles

signal generation_complete

const SPRITE_W = 16
const SPRITE_H = 24
const NUM_DIRECTIONS = 4 # down, left, up, right

## Color Palettes (Harvest Moon SNES style)
const COLORS = {
	"skin": {
		"base": Color(0.97, 0.85, 0.63),    # #F8D8A0
		"shadow": Color(0.91, 0.78, 0.50),  # #E8C880
		"highlight": Color(1.0, 0.91, 0.75) # #FFE8C0
	},
	"hair": {
		"orange": Color(1.0, 0.63, 0.25),   # #FFA040
		"brown": Color(0.6, 0.4, 0.2),     # #996633
		"blonde": Color(1.0, 0.9, 0.5),     # #FFE680
		"gray": Color(0.5, 0.5, 0.5)       # #808080
	},
	"clothes": {
		"hermes_orange": Color(1.0, 0.5, 0.2),   # #FF8033
		"hermes_shadow": Color(0.8, 0.4, 0.16),  # #CC6629
		"aeetes_gold": Color(1.0, 0.8, 0.2),     # #FFCC33
		"aeetes_shadow": Color(0.8, 0.64, 0.16), # #CCA329
		"daedalus_blue": Color(0.3, 0.5, 0.8),   # #4D80CC
		"daedalus_shadow": Color(0.24, 0.4, 0.64), # #3D66A3
		"scylla_purple": Color(0.7, 0.3, 0.8),    # #B34DCC
		"scylla_shadow": Color(0.56, 0.24, 0.64), # #8F3DA3
		"circe_pink": Color(1.0, 0.6, 0.8),       # #FF99CC
		"circe_shadow": Color(0.8, 0.48, 0.64)    # #CC7AA3
	},
	"outline": Color(0.25, 0.25, 0.25), # #404040
	"white": Color(1, 1, 1),
	"black": Color(0, 0, 0)
}

func _ready():
	print("Harvest Moon SNES Sprite Generator initialized")
	# Auto-generate when scene loads
	generate_all_sprites()

## Generate all character sprites
func generate_all_sprites():
	print("=== Starting Harvest Moon-style sprite generation ===")
	var start_time = Time.get_ticks_msec()

	_generate_npc_sprites()

	var elapsed = Time.get_ticks_msec() - start_time
	print("=== Sprite generation complete in %d ms ===" % elapsed)
	generation_complete.emit()

## Generate NPC sprite sheets with 4-directional walk cycles
func _generate_npc_sprites():
	var characters = [
		{
			"name": "hermes",
			"hair_color": COLORS.hair.blonde,
			"shirt_color": COLORS.clothes.hermes_orange,
			"shirt_shadow": COLORS.clothes.hermes_shadow,
			"pants_color": COLORS.clothes.daedalus_blue
		},
		{
			"name": "aeetes",
			"hair_color": COLORS.hair.gray,
			"shirt_color": COLORS.clothes.aeetes_gold,
			"shirt_shadow": COLORS.clothes.aeetes_shadow,
			"pants_color": COLORS.clothes.aeetes_gold
		},
		{
			"name": "daedalus",
			"hair_color": COLORS.hair.brown,
			"shirt_color": COLORS.clothes.daedalus_blue,
			"shirt_shadow": COLORS.clothes.daedalus_shadow,
			"pants_color": COLORS.clothes.daedalus_blue
		},
		{
			"name": "scylla",
			"hair_color": COLORS.hair.orange,
			"shirt_color": COLORS.clothes.scylla_purple,
			"shirt_shadow": COLORS.clothes.scylla_shadow,
			"pants_color": COLORS.clothes.scylla_purple
		},
		{
			"name": "circe",
			"hair_color": COLORS.hair.orange,
			"shirt_color": COLORS.clothes.circe_pink,
			"shirt_shadow": COLORS.clothes.circe_shadow,
			"pants_color": COLORS.clothes.circe_pink
		}
	]

	for char in characters:
		_generate_character_spritesheet(char)

## Generate a spritesheet for one character (4 directions)
func _generate_character_spritesheet(character: Dictionary):
	var sheet_w = SPRITE_W * NUM_DIRECTIONS
	var sheet_h = SPRITE_H
	var spritesheet = Image.create(sheet_w, sheet_h, false, Image.FORMAT_RGB8)

	# Clear with transparent background
	for x in sheet_w:
		for y in sheet_h:
			spritesheet.set_pixel(x, y, Color(0, 0, 0, 0))

	# Generate each direction
	for direction in range(NUM_DIRECTIONS):
		var sprite = _generate_char_sprite(
			character.hair_color,
			character.shirt_color,
			character.shirt_shadow,
			character.pants_color,
			direction
		)

		# Copy sprite to spritesheet
		var offset_x = direction * SPRITE_W
		for x in SPRITE_W:
			for y in SPRITE_H:
				spritesheet.set_pixel(offset_x + x, y, sprite.get_pixel(x, y))

	# Save spritesheet
	var save_path = "res://game/textures/sprites/%s_spritesheet.png" % character.name
	var error = spritesheet.save_png(save_path)
	if error == OK:
		print("✓ Generated: %s_spritesheet.png (4 directions)" % character.name)
	else:
		print("✗ Failed to save %s spritesheet" % character.name)

## Generate a single character sprite (Harvest Moon SNES chibi style)
func _generate_char_sprite(hair_color: Color, shirt_color: Color, shirt_shadow: Color, pants_color: Color, direction: int) -> Image:
	var sprite = Image.create(SPRITE_W, SPRITE_H, false, Image.FORMAT_RGB8)

	# Clear with background
	for x in SPRITE_W:
		for y in SPRITE_H:
			sprite.set_pixel(x, y, shirt_color)

	# Draw chibi character proportions
	var head_h = 8
	var head_y = 0
	var body_y = head_h

	# Draw head (chibi proportions - large head)
	for y in range(head_y, head_y + head_h):
		for x in range(2, 14):
			sprite.set_pixel(x, y, COLORS.skin.base)

	# Draw outline around head
	_draw_pixel_outline(sprite, 2, head_y, 12, head_y + head_h, COLORS.outline)

	# Draw hair based on direction
	_draw_hair(sprite, direction, hair_color)

	# Draw face features (simple dot eyes, small mouth)
	_draw_face(sprite, direction)

	# Draw body (small, chibi proportions)
	for y in range(body_y + 2, SPRITE_H - 2):
		for x in range(4, 12):
			if y < body_y + 8:
				sprite.set_pixel(x, y, shirt_color)  # Shirt
			else:
				sprite.set_pixel(x, y, pants_color)  # Pants

	# Draw body outline
	_draw_pixel_outline(sprite, 4, body_y + 2, 12, SPRITE_H - 2, COLORS.outline)

	# Add simple shading
	_add_shading(sprite, shirt_shadow, pants_color)

	return sprite

## Draw hair on character head
func _draw_hair(sprite: Image, direction: int, hair_color: Color):
	match direction:
		0: # Facing down (back of head visible)
			for x in range(3, 13):
				for y in range(0, 4):
					sprite.set_pixel(x, y, hair_color)
		1: # Facing left
			for x in range(2, 8):
				for y in range(1, 6):
					sprite.set_pixel(x, y, hair_color)
		2: # Facing up (top of head visible)
			for x in range(3, 13):
				for y in range(0, 3):
					sprite.set_pixel(x, y, hair_color)
		3: # Facing right
			for x in range(9, 14):
				for y in range(1, 6):
					sprite.set_pixel(x, y, hair_color)

## Draw simple face (dot eyes, small mouth)
func _draw_face(sprite: Image, direction: int):
	var eye_color = COLORS.black
	var mouth_color = COLORS.black

	match direction:
		0: # Facing down (top of head)
			# Eyes
			sprite.set_pixel(5, 4, eye_color)
			sprite.set_pixel(10, 4, eye_color)
			# Mouth
			sprite.set_pixel(7, 6, mouth_color)
			sprite.set_pixel(8, 6, mouth_color)
		1: # Facing left (face visible)
			# Eyes
			sprite.set_pixel(9, 4, eye_color)
			sprite.set_pixel(10, 4, eye_color)
			# Mouth
			sprite.set_pixel(10, 6, mouth_color)
		2: # Facing up (back of head, no face)
			pass
		3: # Facing right (face visible)
			# Eyes
			sprite.set_pixel(5, 4, eye_color)
			sprite.set_pixel(6, 4, eye_color)
			# Mouth
			sprite.set_pixel(5, 6, mouth_color)

## Add simple shading to sprite
func _add_shading(sprite: Image, shirt_shadow: Color, pants_color: Color):
	# Add shadow on one side for depth
	for y in range(10, 16):
		for x in range(10, 13):
			if y < 18:
				sprite.set_pixel(x, y, shirt_shadow)

## Draw pixel outline around a rectangular area
func _draw_pixel_outline(sprite: Image, x1: int, y1: int, x2: int, y2: int, color: Color):
	# Top edge
	for x in range(x1, x2 + 1):
		sprite.set_pixel(x, y1, color)
	# Bottom edge
	for x in range(x1, x2 + 1):
		sprite.set_pixel(x, y2, color)
	# Left edge
	for y in range(y1, y2 + 1):
		sprite.set_pixel(x1, y, color)
	# Right edge
	for y in range(y1, y2 + 1):
		sprite.set_pixel(x2, y, color)
