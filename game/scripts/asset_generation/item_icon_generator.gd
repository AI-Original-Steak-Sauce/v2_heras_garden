extends SceneTree

## Item Icon Generator
## Procedurally generates 32x32 pixel art icons for quest items

const ICON_SIZE := 32

func _init() -> void:
	print("Item Icon Generator started")
	generate_all_icons()
	quit()

func generate_all_icons() -> void:
	print("\n=== Generating Quest Item Icons ===")
	generate_pharmaka_flower()
	generate_moon_tear()
	generate_sacred_earth()
	generate_woven_cloth()
	print("\n=== All icons generated ===")

## Generate Pharmaka Flower Icon
## Purple/white magical flower with glow effect
func generate_pharmaka_flower() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var petal_color := Color(0.6, 0.3, 0.9, 1.0)
	var center_color := Color(1.0, 1.0, 1.0, 1.0)

	# Draw petals
	for i in range(5):
		var angle := (PI * 2 * i) / 5.0 - PI / 2
		var petal_center := center + Vector2(cos(angle), sin(angle)) * 6
		for y in range(-4, 5):
			for x in range(-3, 4):
				var px := int(petal_center.x + x)
				var py := int(petal_center.y + y)
				if is_inside_icon(px, py):
					var dist_val: float = sqrt(x * x + (y * 0.7) * (y * 0.7))
					if dist_val < 3.0:
						var alpha_val: float = 1.0 - (dist_val / 3.0) * 0.3
						image.set_pixel(px, py, Color(petal_color.r, petal_color.g, petal_color.b, alpha_val))

	# Draw flower center
	for y in range(-4, 5):
		for x in range(-4, 5):
			var dist_val: float = sqrt(x * x + y * y)
			if dist_val < 3.5:
				var glow: float = 1.0 - (dist_val / 3.5)
				var px := int(center.x + x)
				var py := int(center.y + y)
				if is_inside_icon(px, py):
					var existing := image.get_pixel(px, py)
					if existing.a > 0:
						image.set_pixel(px, py, existing.lerp(center_color, glow * 0.7))
					else:
						image.set_pixel(px, py, Color(1, 1, 1, glow * 0.8))

	# Add outer glow
	for y in range(-10, 11):
		for x in range(-10, 11):
			var dist_val: float = sqrt(x * x + y * y)
			if dist_val > 6 and dist_val < 10:
				var px := int(center.x + x)
				var py := int(center.y + y)
				if is_inside_icon(px, py):
					var alpha_val: float = (1.0 - (dist_val - 6) / 4.0) * 0.15
					image.set_pixel(px, py, Color(0.8, 0.6, 1.0, alpha_val))

	save_image(image, "res://game/textures/items/quest/pharmaka_flower.png")
	print("✓ Generated pharmaka_flower.png")

## Generate Moon Tear Icon
## Teardrop shape, pearlescent blue/white shimmer
func generate_moon_tear() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var base_color := Color(0.6, 0.8, 1.0, 1.0)
	var shimmer_color := Color(1.0, 1.0, 1.0, 0.8)

	# Draw teardrop
	for y in range(-8, 10):
		for x in range(-7, 8):
			var ny: float = float(y) / 8.0
			var width_val: float = 6.0 * (1.0 - ny * 0.5) if ny < 0 else 4.0 * (1.0 - abs(ny) * 0.8)
			if abs(x) < width_val:
				var px := int(center.x + x)
				var py := int(center.y + y)
				if is_inside_icon(px, py):
					var dist_val: float = abs(x) / width_val
					var alpha_val: float = 1.0 - dist_val * 0.3
					var shimmer: float = 0.0
					if y < 2 and x > -3 and x < 2:
						shimmer = (2.0 - y) / 4.0
					var final_color := base_color
					if shimmer > 0:
						final_color = base_color.lerp(shimmer_color, shimmer)
					image.set_pixel(px, py, Color(final_color.r, final_color.g, final_color.b, alpha_val))

	# Add highlight
	for y in range(-5, -1):
		for x in range(-4, 0):
			var dist_val: float = sqrt((x + 2) * (x + 2) + (y + 3) * (y + 3))
			if dist_val < 2.5:
				var px := int(center.x + x)
				var py := int(center.y + y)
				if is_inside_icon(px, py):
					var existing := image.get_pixel(px, py)
					if existing.a > 0:
						image.set_pixel(px, py, existing.lerp(Color(1, 1, 1, 1.0), 0.6))

	save_image(image, "res://game/textures/items/quest/moon_tear.png")
	print("✓ Generated moon_tear.png")

## Generate Sacred Earth Icon
## Small pile of dirt with glowing gold particles
func generate_sacred_earth() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var base_color := Color(0.4, 0.3, 0.2, 1.0)
	var gold_color := Color(1.0, 0.85, 0.3, 1.0)

	# Draw earth mound
	for y in range(-5, 8):
		for x in range(-9, 10):
			var mound_height: float = 5.0 - abs(y) * 0.5
			var edge_noise: float = sin(x * 0.5) * 1.5 + cos(y * 0.5) * 1.0
			if abs(x) < mound_height + edge_noise and y > -5:
				var px := int(16 + x)
				var py := int(18 + y)
				if is_inside_icon(px, py):
					var noise: float = (randf() - 0.5) * 0.15
					var earth_color := base_color + Color(noise, noise, noise, 0)
					image.set_pixel(px, py, earth_color)

	# Add gold specs
	var gold_spots := [
		Vector2(16, 14), Vector2(12, 16), Vector2(20, 15),
		Vector2(14, 18), Vector2(18, 17), Vector2(16, 20),
		Vector2(10, 17), Vector2(22, 18)
	]

	for spot in gold_spots:
		for y in range(-2, 3):
			for x in range(-2, 3):
				var dist_val: float = sqrt(x * x + y * y)
				if dist_val < 2.0:
					var px := int(spot.x + x)
					var py := int(spot.y + y)
					if is_inside_icon(px, py):
						var glow: float = 1.0 - (dist_val / 2.0)
						var existing := image.get_pixel(px, py)
						if existing.a > 0:
							image.set_pixel(px, py, existing.lerp(gold_color, glow * 0.8))
						else:
							image.set_pixel(px, py, Color(gold_color.r, gold_color.g, gold_color.b, glow * 0.6))

	save_image(image, "res://game/textures/items/quest/sacred_earth.png")
	print("✓ Generated sacred_earth.png")

## Generate Woven Cloth Icon
## Fabric texture with Greek key pattern hint
func generate_woven_cloth() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var cloth_color := Color(0.85, 0.75, 0.55, 1.0)
	var pattern_color := Color(0.6, 0.5, 0.35, 1.0)
	var border_color := Color(0.4, 0.35, 0.25, 1.0)
	var cloth_rect := Rect2(6, 8, 20, 16)

	# Main cloth body
	for y in range(cloth_rect.position.y, cloth_rect.end.y):
		for x in range(cloth_rect.position.x, cloth_rect.end.x):
			var px := x
			var py := y
			var texture_noise: float = (randf() - 0.5) * 0.08
			var fold: float = (x - cloth_rect.position.x) / float(cloth_rect.size.x) * 0.1
			var final_color := cloth_color + Color(texture_noise - fold, texture_noise - fold, texture_noise - fold, 0)
			image.set_pixel(px, py, final_color)

	# Draw border
	for y in range(cloth_rect.position.y, cloth_rect.end.y):
		for x in range(cloth_rect.position.x, cloth_rect.end.x):
			var on_border: bool = (x == cloth_rect.position.x or x == cloth_rect.end.x - 1 or
							  y == cloth_rect.position.y or y == cloth_rect.end.y - 1)
			if on_border:
				image.set_pixel(x, y, border_color)

	# Greek pattern
	var pattern_y: int = cloth_rect.position.y + 3
	for i in range(4):
		var pattern_x: int = cloth_rect.position.x + 4 + i * 4
		for py in range(-1, 2):
			for px in range(-1, 2):
				if abs(px) == 1 or abs(py) == 1:
					var final_x: int = pattern_x + px
					var final_y: int = pattern_y + py
					if final_x < cloth_rect.end.x - 2:
						image.set_pixel(final_x, final_y, pattern_color)

	# Weave texture
	for y in range(cloth_rect.position.y + 1, cloth_rect.end.y - 1):
		for x in range(cloth_rect.position.x + 2, cloth_rect.end.x - 2):
			if x % 4 == 0:
				image.set_pixel(x, y, pattern_color)
			if y % 4 == 0:
				image.set_pixel(x, y, pattern_color)

	save_image(image, "res://game/textures/items/quest/woven_cloth.png")
	print("✓ Generated woven_cloth.png")

func is_inside_icon(x: int, y: int) -> bool:
	return x >= 0 and x < ICON_SIZE and y >= 0 and y < ICON_SIZE

func save_image(image: Image, path: String) -> void:
	var dir := path.get_base_dir()
	DirAccess.make_dir_absolute(dir)
	image.save_png(path)
