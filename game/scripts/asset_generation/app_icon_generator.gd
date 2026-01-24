extends SceneTree

## App Icon Generator
## Procedurally generates 512x512 pixel art app icon for Circe's Garden
## Theme: Hermes winged sandals with Greek island background

const ICON_SIZE := 512
const BASE_SIZE := 64  # Draw at lower res for sharp pixel edges, then scale up

func _init() -> void:
	print("App Icon Generator started")
	generate_app_icon()
	quit()

func generate_app_icon() -> void:
	print("\n=== Generating App Icon ===")

	# Create base image at lower resolution for sharp pixel edges
	var base_image := Image.create(BASE_SIZE, BASE_SIZE, false, Image.FORMAT_RGBA8)
	base_image.fill(Color(0, 0, 0, 0))

	# Draw the icon elements
	draw_greek_island_background(base_image)
	draw_winged_sandal(base_image)
	draw_decorative_elements(base_image)
	add_vignette_effect(base_image)

	# Scale up to 512x512 with nearest-neighbor filtering for sharp pixels
	var final_image := base_image.duplicate()
	final_image.resize(ICON_SIZE, ICON_SIZE, Image.INTERPOLATE_NEAREST)

	# Save the icon
	save_image(final_image, "res://game/icon.png")
	print("\n=== App icon generated: game/icon.png ===")

## Draw Mediterranean Greek island background
func draw_greek_island_background(image: Image) -> void:
	var center: int = BASE_SIZE / 2

	# Sky gradient (Mediterranean blue)
	for y in range(BASE_SIZE):
		var gradient: float = float(y) / float(BASE_SIZE)
		var sky_color: Color = Color(0.3, 0.6, 0.9).lerp(Color(0.6, 0.8, 1.0), gradient)
		for x in range(BASE_SIZE):
			image.set_pixel(x, y, sky_color)

	# Sea/water at bottom
	for y in range(BASE_SIZE / 2 + 10, BASE_SIZE):
		var wave_offset: float = sin(y * 0.3) * 2.0
		var sea_color: Color = Color(0.1, 0.4, 0.7)
		for x in range(BASE_SIZE):
			var depth: float = float(y - (BASE_SIZE / 2 + 10)) / float(BASE_SIZE / 2 - 10)
			var final_color: Color = sea_color.lerp(Color(0.05, 0.3, 0.5), depth)
			image.set_pixel(x, y, final_color)

	# Greek island silhouette (simplified white buildings)
	var island_y: int = BASE_SIZE / 2 + 5
	# Main landmass
	for y in range(island_y, BASE_SIZE):
		for x in range(BASE_SIZE):
			var dist_from_center: float = abs(float(x - center))
			var island_edge: float = 20.0 + sin(float(x) * 0.1) * 3.0
			if dist_from_center < island_edge:
				image.set_pixel(x, y, Color(0.95, 0.93, 0.88))

	# Small white building (Greek church style)
	var building_x: int = center - 5
	var building_y: int = island_y - 8
	for y in range(building_y, building_y + 12):
		for x in range(building_x - 6, building_x + 6):
			image.set_pixel(x, y, Color(0.98, 0.96, 0.92))

	# Dome
	for y in range(building_y - 5, building_y):
		for x in range(building_x - 4, building_x + 4):
			var dist: float = sqrt(float((x - building_x) * (x - building_x) + (y - (building_y - 3)) * (y - (building_y - 3))))
			if dist < 4.0:
				image.set_pixel(x, y, Color(0.98, 0.96, 0.92))

## Draw winged sandal (Hermes symbol) as the central icon
func draw_winged_sandal(image: Image) -> void:
	var center_x: int = BASE_SIZE / 2
	var center_y: int = BASE_SIZE / 2 - 2

	var leather_color: Color = Color(0.7, 0.5, 0.3)
	var leather_dark: Color = Color(0.5, 0.35, 0.2)
	var leather_light: Color = Color(0.85, 0.65, 0.45)
	var wing_color: Color = Color(0.95, 0.93, 0.88)
	var wing_shadow: Color = Color(0.8, 0.78, 0.73)

	# Sandal sole (base)
	for y in range(-8, 4):
		for x in range(-12, 12):
			var sole_width: float = 10.0 - abs(float(y)) * 0.8
			if abs(float(x)) < sole_width:
				var px: int = center_x + x
				var py: int = center_y + y
				if is_inside(px, py):
					image.set_pixel(px, py, leather_dark)

	# Sandal upper (leather straps)
	for y in range(-12, -4):
		for x in range(-6, 6):
			var strap_width: float = 4.0 - abs(float(y + 8)) * 0.3
			if abs(float(x)) < strap_width:
				var px: int = center_x + x
				var py: int = center_y + y
				if is_inside(px, py):
					image.set_pixel(px, py, leather_color)

	# Ankle strap
	for y in range(-10, -6):
		for x in range(-8, 8):
			if abs(x) < 6 or (y < -8 and abs(x) < 7):
				var px: int = center_x + x
				var py: int = center_y + y
				if is_inside(px, py):
					image.set_pixel(px, py, leather_color)

	# Heel cup
	for y in range(-8, 2):
		for x in range(8, 12):
			var px: int = center_x + x
			var py: int = center_y + y
			if is_inside(px, py):
				image.set_pixel(px, py, leather_color)

	# Left wing (larger, behind sandal)
	var wing_left_center: Vector2 = Vector2(center_x - 10, center_y - 6)
	draw_wing(image, wing_left_center, 12, wing_color, wing_shadow, true)

	# Right wing (slightly smaller, in front)
	var wing_right_center: Vector2 = Vector2(center_x + 8, center_y - 7)
	draw_wing(image, wing_right_center, 10, wing_color, wing_shadow, false)

	# Add highlights
	for y in range(-10, -5):
		for x in range(-4, 4):
			if abs(x) < 2:
				var px: int = center_x + x
				var py: int = center_y + y
				if is_inside(px, py):
					var existing: Color = image.get_pixel(px, py)
					if existing == leather_color:
						image.set_pixel(px, py, leather_light)

## Draw a single wing
func draw_wing(image: Image, wing_center: Vector2, wing_size: int, base_color: Color, shadow_color: Color, is_left: bool) -> void:
	var direction: int = 1 if is_left else -1

	# Wing feathers (layered from back to front)
	for layer in range(3):
		var feather_length: int = wing_size - layer * 2
		var feather_y: int = wing_center.y - layer * 3

		for i in range(5):
			var feather_offset: int = (i - 2) * 3
			var feather_x: int = wing_center.x + feather_offset * direction
			var feather_y_pos: float = feather_y + abs(float(feather_offset)) * 0.5

			# Draw feather
			for y in range(-2, 3):
				for x in range(-3, 4):
					var feather_width: float = float(3 - layer) - abs(float(x)) * 0.5
					var px: int = feather_x + x * direction
					var py: int = int(feather_y_pos + y)
					if is_inside(px, py):
						var dist_from_center: float = abs(float(x)) / 3.0
						var feather_color: Color = base_color.lerp(shadow_color, dist_from_center + float(layer) * 0.2)
						image.set_pixel(px, py, feather_color)

	# Wing outline for definition
	for i in range(4):
		var outline_x: int = wing_center.x + (i - 1) * 4 * direction
		var outline_y: int = wing_center.y - i * 2
		for y in range(-1, 2):
			var px: int = outline_x
			var py: int = outline_y + y
			if is_inside(px, py):
				var existing: Color = image.get_pixel(px, py)
				if existing.a > 0:
					image.set_pixel(px, py, existing.lerp(shadow_color, 0.3))

## Add decorative elements (sparkles, magic effects)
func draw_decorative_elements(image: Image) -> void:
	var center: int = BASE_SIZE / 2
	var sparkle_color: Color = Color(1.0, 0.95, 0.7)

	# Magic sparkles around the sandals
	var sparkle_positions: Array[Vector2] = [
		Vector2(center, center - 18),
		Vector2(center - 8, center - 16),
		Vector2(center + 10, center - 10)
	]

	for sparkle_pos in sparkle_positions:
		draw_star(image, sparkle_pos, 3, sparkle_color)

	# Subtle golden glow around center
	var glow_radius: int = 25
	for y in range(-glow_radius, glow_radius + 1):
		for x in range(-glow_radius, glow_radius + 1):
			var dist: float = sqrt(float(x * x + y * y))
			if dist < float(glow_radius) and dist > 15.0:
				var alpha_val: float = (1.0 - (dist - 15.0) / 10.0) * 0.15
				var px: int = center + x
				var py: int = center - 2 + y
				if is_inside(px, py):
					var existing: Color = image.get_pixel(px, py)
					if existing.a > 0:
						var glow_color: Color = Color(1.0, 0.9, 0.6, alpha_val)
						image.set_pixel(px, py, existing.lerp(glow_color, alpha_val))

## Draw a small star/sparkle
func draw_star(image: Image, pos: Vector2, size: int, color: Color) -> void:
	for y in range(-size, size + 1):
		for x in range(-size, size + 1):
			var px: int = int(pos.x + x)
			var py: int = int(pos.y + y)
			if is_inside(px, py):
				var is_star: bool = (abs(x) == abs(y)) or (x == 0) or (y == 0)
				if is_star:
					image.set_pixel(px, py, color)

## Add vignette effect for depth
func add_vignette_effect(image: Image) -> void:
	var strength: float = 0.3
	for y in range(BASE_SIZE):
		for x in range(BASE_SIZE):
			var dist_x: float = abs(float(x - BASE_SIZE / 2)) / float(BASE_SIZE / 2)
			var dist_y: float = abs(float(y - BASE_SIZE / 2)) / float(BASE_SIZE / 2)
			var dist: float = maxf(dist_x, dist_y)
			var vignette: float = dist * dist * strength

			var existing: Color = image.get_pixel(x, y)
			var vignetted: Color = Color(
				existing.r * (1.0 - vignette),
				existing.g * (1.0 - vignette),
				existing.b * (1.0 - vignette),
				existing.a
			)
			image.set_pixel(x, y, vignetted)

func is_inside(x: int, y: int) -> bool:
	return x >= 0 and x < BASE_SIZE and y >= 0 and y < BASE_SIZE

func save_image(image: Image, path: String) -> void:
	var dir: String = path.get_base_dir()
	DirAccess.make_dir_absolute(dir)
	image.save_png(path)
