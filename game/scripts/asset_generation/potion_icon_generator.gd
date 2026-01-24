extends SceneTree

## Potion Icon Generator
## Procedurally generates 32x32 pixel art icons for potions and quest items

const ICON_SIZE := 32

func _init() -> void:
	print("Potion Icon Generator started")
	generate_all_icons()
	quit()

func generate_all_icons() -> void:
	print("\n=== Generating Potion Icons ===")
	generate_pharmaka_potion()
	generate_health_potion()
	generate_stamina_potion()
	generate_quest_scroll()
	print("\n=== All potion icons generated ===")

## Generate Pharmaka Potion Icon
## Purple potion bottle with magical glow
func generate_pharmaka_potion() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var bottle_dark := Color(0.35, 0.20, 0.45)
	var bottle_mid := Color(0.55, 0.35, 0.65)
	var bottle_light := Color(0.75, 0.55, 0.85)
	var liquid_deep := Color(0.45, 0.25, 0.60)
	var liquid_surface := Color(0.65, 0.40, 0.80)
	var glow_inner := Color(0.85, 0.75, 1.0)
	var glow_outer := Color(0.65, 0.45, 0.85)
	var cork_brown := Color(0.45, 0.30, 0.20)

	for x in range(-12, 13):
		for y in range(-12, 13):
			var px := int(center.x + x)
			var py := int(center.y + y)
			if not is_inside_icon(px, py):
				continue

			var d := sqrt(float(x * x + y * y))
			var pixel_color := Color(0, 0, 0, 0)

			if d <= 12.0:
				var glow_a := 1.0 - (d / 12.0)
				if d <= 8.0:
					pixel_color = Color(glow_inner.r, glow_inner.g, glow_inner.b, glow_a * 0.3)
				else:
					pixel_color = Color(glow_outer.r, glow_outer.g, glow_outer.b, glow_a * 0.2)

			var bottle_left := -6
			var bottle_right := 6
			var bottle_top := -6
			var bottle_bottom := 9

			if x >= bottle_left and x <= bottle_right and y >= bottle_top and y <= bottle_bottom:
				if y >= bottle_top and y <= bottle_top + 3:
					pixel_color = cork_brown
				elif y >= 1:
					if y >= 1 and y <= 2:
						pixel_color = liquid_surface
					else:
						var shimmer := sin(float(x) * 0.8 + float(y) * 0.5) * 0.5 + 0.5
						if shimmer > 0.7:
							pixel_color = liquid_surface
						else:
							pixel_color = liquid_deep
						if x >= bottle_left and x <= bottle_left + 2:
							var reflect_a := 1.0 - (float(y - 1) / 8.0)
							pixel_color = pixel_color.lerp(bottle_light, reflect_a * 0.4)
				else:
					if x >= bottle_left + 1 and x <= bottle_right - 1:
						pixel_color = bottle_mid
					if x >= bottle_left + 1 and x <= bottle_left + 2 and y >= bottle_top + 4 and y <= bottle_bottom - 4:
						pixel_color = bottle_light
				if x == bottle_left or x == bottle_right or y == bottle_bottom:
					if x == bottle_left or x == bottle_right:
						if y >= bottle_top + 2:
							pixel_color = bottle_dark
					else:
						pixel_color = bottle_dark

			image.set_pixel(px, py, pixel_color)

	save_image(image, "res://game/textures/items/potions/pharmaka_potion.png")
	print("Generated pharmaka_potion.png")

## Generate Health Potion Icon
## Red potion bottle with heart symbol hint
func generate_health_potion() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var bottle_dark := Color(0.55, 0.15, 0.15)
	var bottle_mid := Color(0.75, 0.25, 0.25)
	var bottle_light := Color(0.95, 0.55, 0.55)
	var liquid_deep := Color(0.80, 0.20, 0.30)
	var liquid_surface := Color(0.95, 0.35, 0.45)
	var heart_color := Color(1.0, 0.85, 0.85)
	var cork_brown := Color(0.45, 0.30, 0.20)

	for x in range(-12, 13):
		for y in range(-12, 13):
			var px := int(center.x + x)
			var py := int(center.y + y)
			if not is_inside_icon(px, py):
				continue

			var pixel_color := Color(0, 0, 0, 0)
			var bottle_left := -6
			var bottle_right := 6
			var bottle_top := -6
			var bottle_bottom := 9

			if x >= bottle_left and x <= bottle_right and y >= bottle_top and y <= bottle_bottom:
				if y >= bottle_top and y <= bottle_top + 3:
					pixel_color = cork_brown
				elif y >= 1:
					if y >= 1 and y <= 2:
						pixel_color = liquid_surface
					else:
						var shimmer := sin(float(x) * 0.8 + float(y) * 0.5) * 0.5 + 0.5
						if shimmer > 0.7:
							pixel_color = liquid_surface
						else:
							pixel_color = liquid_deep
						var hx: float = float(x)
						var hy: float = float(y - 5)
						var hd1: float = sqrt((hx + 1.5) * (hx + 1.5) + (hy + 1) * (hy + 1))
						var hd2: float = sqrt((hx - 1.5) * (hx - 1.5) + (hy + 1) * (hy + 1))
						var in_heart: bool = hd1 <= 1.8 or hd2 <= 1.8 or (hy >= 0 and abs(hx) <= 3.5 and hy <= 3)
						if in_heart:
							pixel_color = pixel_color.lerp(heart_color, 0.7)
						if x >= bottle_left and x <= bottle_left + 2:
							var reflect_a := 1.0 - (float(y - 1) / 8.0)
							pixel_color = pixel_color.lerp(bottle_light, reflect_a * 0.4)
				else:
					if x >= bottle_left + 1 and x <= bottle_right - 1:
						pixel_color = bottle_mid
					if x >= bottle_left + 1 and x <= bottle_left + 2 and y >= bottle_top + 4 and y <= bottle_bottom - 4:
						pixel_color = bottle_light
				if x == bottle_left or x == bottle_right or y == bottle_bottom:
					if x == bottle_left or x == bottle_right:
						if y >= bottle_top + 2:
							pixel_color = bottle_dark
					else:
						pixel_color = bottle_dark

			image.set_pixel(px, py, pixel_color)

	save_image(image, "res://game/textures/items/potions/health_potion.png")
	print("Generated health_potion.png")

## Generate Stamina Potion Icon
## Green potion bottle with energy bolt hint
func generate_stamina_potion() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var bottle_dark := Color(0.20, 0.45, 0.20)
	var bottle_mid := Color(0.35, 0.65, 0.35)
	var bottle_light := Color(0.60, 0.85, 0.60)
	var liquid_deep := Color(0.25, 0.60, 0.30)
	var liquid_surface := Color(0.45, 0.80, 0.50)
	var bolt_color := Color(0.95, 1.0, 0.85)
	var cork_brown := Color(0.45, 0.30, 0.20)

	for x in range(-12, 13):
		for y in range(-12, 13):
			var px := int(center.x + x)
			var py := int(center.y + y)
			if not is_inside_icon(px, py):
				continue

			var pixel_color := Color(0, 0, 0, 0)
			var bottle_left := -6
			var bottle_right := 6
			var bottle_top := -6
			var bottle_bottom := 9

			if x >= bottle_left and x <= bottle_right and y >= bottle_top and y <= bottle_bottom:
				if y >= bottle_top and y <= bottle_top + 3:
					pixel_color = cork_brown
				elif y >= 1:
					if y >= 1 and y <= 2:
						pixel_color = liquid_surface
					else:
						var shimmer := sin(float(x) * 0.8 + float(y) * 0.5) * 0.5 + 0.5
						if shimmer > 0.7:
							pixel_color = liquid_surface
						else:
							pixel_color = liquid_deep
						var bx: float = float(x)
						var by: float = float(y - 5)
						var in_bolt: bool = false
						if by >= -3 and by <= 4:
							var bolt_w: float = 1.5
							if by >= -3 and by <= 0:
								var target_x: float = -2.0 + by
								if abs(bx - target_x) <= bolt_w:
									in_bolt = true
							elif by >= 1 and by <= 4:
								var target_x: float = 2.0 - (by - 1.0)
								if abs(bx - target_x) <= bolt_w:
									in_bolt = true
						if in_bolt:
							pixel_color = pixel_color.lerp(bolt_color, 0.7)
						if x >= bottle_left and x <= bottle_left + 2:
							var reflect_a := 1.0 - (float(y - 1) / 8.0)
							pixel_color = pixel_color.lerp(bottle_light, reflect_a * 0.4)
				else:
					if x >= bottle_left + 1 and x <= bottle_right - 1:
						pixel_color = bottle_mid
					if x >= bottle_left + 1 and x <= bottle_left + 2 and y >= bottle_top + 4 and y <= bottle_bottom - 4:
						pixel_color = bottle_light
				if x == bottle_left or x == bottle_right or y == bottle_bottom:
					if x == bottle_left or x == bottle_right:
						if y >= bottle_top + 2:
							pixel_color = bottle_dark
					else:
						pixel_color = bottle_dark

			image.set_pixel(px, py, pixel_color)

	save_image(image, "res://game/textures/items/potions/stamina_potion.png")
	print("Generated stamina_potion.png")

## Generate Quest Scroll Icon
## Rolled parchment with wax seal
func generate_quest_scroll() -> void:
	var image := Image.create(ICON_SIZE, ICON_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	var center := Vector2(16, 16)
	var parchment_dark := Color(0.75, 0.65, 0.45)
	var parchment_mid := Color(0.90, 0.80, 0.60)
	var parchment_light := Color(1.0, 0.95, 0.80)
	var scroll_roller := Color(0.55, 0.40, 0.25)
	var seal_red := Color(0.75, 0.20, 0.20)
	var seal_red_dark := Color(0.55, 0.12, 0.12)
	var seal_red_light := Color(0.90, 0.40, 0.40)
	var text_color := Color(0.35, 0.25, 0.15)

	for x in range(-16, 16):
		for y in range(-16, 16):
			var px := int(center.x + x)
			var py := int(center.y + y)
			if not is_inside_icon(px, py):
				continue

			var pixel_color := Color(0, 0, 0, 0)
			var scroll_left := -10
			var scroll_right := 10
			var scroll_top := -6
			var scroll_bottom := 6

			if x >= scroll_left and x <= scroll_right and y >= scroll_top and y <= scroll_bottom:
				if x >= scroll_left and x <= scroll_left + 3:
					var dy := float(y)
					if abs(dy) <= 4:
						var d := sqrt(dy * dy)
						if d <= 3.5:
							if d <= 2.0:
								pixel_color = parchment_light
							else:
								pixel_color = scroll_roller
				elif x >= scroll_right - 3 and x <= scroll_right:
					var dy := float(y)
					if abs(dy) <= 4:
						var d := sqrt(dy * dy)
						if d <= 3.5:
							if d <= 2.0:
								pixel_color = parchment_light
							else:
								pixel_color = scroll_roller
				else:
					if y >= scroll_top + 1 and y <= scroll_bottom - 1:
						pixel_color = parchment_mid
						if y == scroll_top + 3 or y == scroll_top + 5 or y == scroll_top + 7:
							if x >= scroll_left + 4 and x <= scroll_right - 4:
								if x < scroll_left + 8 or x > scroll_right - 8:
									pixel_color = text_color
						if y >= scroll_top + 1 and y <= scroll_top + 2:
							pixel_color = parchment_light
					if y == scroll_bottom - 1:
						pixel_color = parchment_dark

			var seal_d := sqrt(float(x * x + y * y))
			if seal_d <= 3.5:
				if seal_d <= 3.0:
					if seal_d <= 1.5:
						pixel_color = seal_red_light
					else:
						pixel_color = seal_red
				else:
					pixel_color = seal_red_dark

			image.set_pixel(px, py, pixel_color)

	save_image(image, "res://game/textures/items/quest/quest_scroll.png")
	print("Generated quest_scroll.png")

func is_inside_icon(x: int, y: int) -> bool:
	return x >= 0 and x < ICON_SIZE and y >= 0 and y < ICON_SIZE

func save_image(image: Image, path: String) -> void:
	var dir := path.get_base_dir()
	DirAccess.make_dir_absolute(dir)
	image.save_png(path)
