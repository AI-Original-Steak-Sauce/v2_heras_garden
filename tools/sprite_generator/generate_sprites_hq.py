"""
Circe's Garden - HIGH QUALITY Sprite Generator
Stardew Valley-style pixel art with proper shading, hue shifting, and detail

Key techniques:
- 5-6 color ramps with hue shifting (shadows -> cool, highlights -> warm)
- 1px outlines with anti-aliased corners
- Texture details and surface variation
- Pixel-perfect manual placement
- Chunky, readable proportions
"""

import os
from PIL import Image

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
SPRITES_DIR = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'placeholders')
TILES_DIR = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'tiles')

# ============================================================================
# COLOR RAMPS - Stardew Valley style with hue shifting
# Each ramp: [outline, deep_shadow, shadow, base, light, highlight]
# Shadows shift cool (toward blue), highlights shift warm (toward yellow)
# ============================================================================

RAMPS = {
    # Wheat/Gold - warm yellow-orange
    'wheat': [
        (71, 45, 20),      # Outline - dark brown
        (139, 90, 43),     # Deep shadow - brown
        (184, 134, 46),    # Shadow - dark gold
        (234, 182, 66),    # Base - gold
        (255, 214, 112),   # Light - bright gold
        (255, 239, 186),   # Highlight - pale yellow
    ],

    # Moly - white flower with golden center, black root
    'moly_white': [
        (100, 100, 110),   # Outline - blue-gray
        (170, 170, 180),   # Deep shadow - light blue-gray
        (200, 200, 210),   # Shadow - pale blue
        (235, 235, 240),   # Base - near white
        (250, 250, 255),   # Light - white
        (255, 255, 255),   # Highlight - pure white
    ],
    'moly_gold': [
        (120, 80, 20),     # Outline
        (180, 130, 40),    # Deep shadow
        (220, 170, 60),    # Shadow
        (255, 210, 90),    # Base
        (255, 235, 140),   # Light
        (255, 250, 200),   # Highlight
    ],
    'moly_root': [
        (10, 8, 12),       # Outline - near black
        (25, 20, 30),      # Deep shadow - dark purple-black
        (40, 35, 50),      # Shadow
        (55, 50, 65),      # Base - dark purple
        (75, 70, 85),      # Light
        (95, 90, 105),     # Highlight
    ],

    # Nightshade - purple with dark berries
    'nightshade': [
        (45, 20, 60),      # Outline - deep purple
        (75, 35, 95),      # Deep shadow
        (105, 55, 130),    # Shadow
        (140, 80, 170),    # Base - medium purple
        (175, 115, 200),   # Light
        (210, 160, 230),   # Highlight - lavender
    ],
    'nightshade_berry': [
        (25, 10, 35),      # Outline
        (45, 20, 60),      # Deep shadow
        (65, 30, 85),      # Shadow
        (90, 45, 115),     # Base - dark purple
        (115, 65, 140),    # Light
        (145, 95, 170),    # Highlight
    ],

    # Green leaves/stems
    'leaf': [
        (20, 50, 25),      # Outline - dark green
        (35, 80, 40),      # Deep shadow
        (55, 115, 60),     # Shadow
        (80, 150, 85),     # Base - medium green
        (115, 180, 110),   # Light
        (160, 210, 150),   # Highlight - yellow-green
    ],
    'stem': [
        (25, 55, 30),      # Outline
        (40, 85, 45),      # Deep shadow
        (60, 110, 65),     # Shadow
        (85, 140, 90),     # Base
        (110, 165, 115),   # Light
        (145, 195, 150),   # Highlight
    ],

    # Potions - Glass bottle
    'glass': [
        (60, 80, 100),     # Outline - blue-gray
        (100, 130, 160),   # Deep shadow
        (140, 170, 195),   # Shadow
        (180, 205, 225),   # Base - light blue
        (210, 230, 245),   # Light
        (240, 248, 255),   # Highlight - near white
    ],
    'cork': [
        (65, 40, 25),      # Outline - dark brown
        (100, 65, 40),     # Deep shadow
        (135, 95, 60),     # Shadow
        (170, 130, 90),    # Base - tan
        (200, 165, 125),   # Light
        (230, 200, 165),   # Highlight
    ],

    # Calming potion - blue liquid
    'potion_blue': [
        (30, 50, 100),     # Outline - deep blue
        (50, 80, 150),     # Deep shadow
        (70, 110, 190),    # Shadow
        (100, 150, 220),   # Base - sky blue
        (140, 185, 240),   # Light
        (190, 220, 255),   # Highlight
    ],

    # Binding ward - golden liquid
    'potion_gold': [
        (100, 70, 20),     # Outline
        (150, 110, 40),    # Deep shadow
        (200, 150, 60),    # Shadow
        (240, 190, 80),    # Base
        (255, 220, 120),   # Light
        (255, 245, 180),   # Highlight
    ],

    # Reversal elixir - green liquid
    'potion_green': [
        (20, 70, 40),      # Outline
        (40, 110, 60),     # Deep shadow
        (60, 150, 80),     # Shadow
        (90, 190, 110),    # Base
        (130, 220, 150),   # Light
        (180, 245, 200),   # Highlight
    ],

    # Petrification - gray liquid
    'potion_gray': [
        (50, 50, 55),      # Outline
        (80, 80, 88),      # Deep shadow
        (110, 110, 120),   # Shadow
        (145, 145, 155),   # Base
        (180, 180, 190),   # Light
        (215, 215, 225),   # Highlight
    ],

    # Moon tear - ethereal blue glow
    'moon_tear': [
        (60, 90, 130),     # Outline - deep blue
        (100, 140, 180),   # Deep shadow
        (140, 180, 215),   # Shadow
        (180, 210, 240),   # Base - pale blue
        (210, 235, 255),   # Light
        (240, 250, 255),   # Highlight - near white glow
    ],

    # Sacred earth - rich brown with gold
    'earth': [
        (50, 30, 15),      # Outline - dark brown
        (85, 55, 30),      # Deep shadow
        (120, 80, 45),     # Shadow
        (160, 110, 65),    # Base - warm brown
        (195, 145, 95),    # Light
        (225, 185, 135),   # Highlight
    ],

    # Woven cloth - beige/linen
    'cloth': [
        (100, 80, 60),     # Outline - brown
        (145, 120, 95),    # Deep shadow
        (180, 155, 125),   # Shadow
        (210, 190, 160),   # Base - tan
        (235, 215, 190),   # Light
        (250, 240, 220),   # Highlight - cream
    ],

    # Pharmaka flower - magical pink
    'pharmaka': [
        (120, 50, 80),     # Outline - deep pink
        (170, 80, 120),    # Deep shadow
        (210, 120, 160),   # Shadow
        (240, 160, 195),   # Base - pink
        (255, 200, 220),   # Light
        (255, 235, 245),   # Highlight - pale pink
    ],

    # Grass tile - lush Mediterranean green
    'grass': [
        (25, 55, 30),      # Outline - dark green
        (40, 80, 45),      # Deep shadow
        (60, 110, 65),     # Shadow
        (85, 145, 90),     # Base - medium green
        (115, 175, 115),   # Light - bright green
        (150, 200, 145),   # Highlight - yellow-green
    ],

    # NPC skin tones
    'skin': [
        (120, 80, 60),     # Outline
        (160, 110, 85),    # Deep shadow
        (195, 145, 115),   # Shadow
        (230, 185, 155),   # Base
        (250, 215, 190),   # Light
        (255, 240, 225),   # Highlight
    ],

    # Hermes - sky blue robes
    'hermes_robe': [
        (40, 80, 110),     # Outline
        (70, 120, 160),    # Deep shadow
        (100, 160, 200),   # Shadow
        (140, 195, 230),   # Base - sky blue
        (180, 220, 250),   # Light
        (220, 240, 255),   # Highlight
    ],

    # Aeetes - regal purple/gold
    'aeetes_robe': [
        (60, 30, 80),      # Outline
        (95, 50, 120),     # Deep shadow
        (130, 75, 160),    # Shadow
        (170, 105, 195),   # Base - royal purple
        (205, 145, 225),   # Light
        (235, 190, 250),   # Highlight
    ],

    # Daedalus - earthy brown
    'daedalus_robe': [
        (55, 40, 30),      # Outline
        (90, 70, 50),      # Deep shadow
        (125, 100, 75),    # Shadow
        (165, 135, 105),   # Base - brown
        (200, 170, 140),   # Light
        (230, 205, 180),   # Highlight
    ],

    # Scylla - sea monster teal
    'scylla_skin': [
        (20, 60, 70),      # Outline
        (40, 95, 110),     # Deep shadow
        (65, 130, 150),    # Shadow
        (95, 170, 190),    # Base - teal
        (135, 200, 215),   # Light
        (180, 225, 235),   # Highlight
    ],

    # Circe - purple/gold magical
    'circe_robe': [
        (70, 40, 90),      # Outline
        (105, 65, 130),    # Deep shadow
        (140, 95, 170),    # Shadow
        (180, 130, 200),   # Base - purple
        (210, 170, 225),   # Light
        (235, 210, 245),   # Highlight
    ],
}

def c(ramp_name, shade_index):
    """Get color from ramp. shade_index: 0=outline, 1=deep_shadow, 2=shadow, 3=base, 4=light, 5=highlight"""
    return RAMPS[ramp_name][shade_index] + (255,)

def save_sprite(img, filename):
    """Save sprite to placeholders folder"""
    path = os.path.join(SPRITES_DIR, filename)
    img.save(path)
    print(f"Created: {filename}")

# ============================================================================
# ITEM SPRITES - 32x32, Stardew Valley quality
# ============================================================================

def create_wheat():
    """Golden wheat bundle - 3 stalks with detailed heads"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Wheat head left (x=8-12)
    # Outline
    for y in range(4, 12):
        p((8, y), c('wheat', 0))
        p((12, y), c('wheat', 0))
    p((9, 3), c('wheat', 0))
    p((10, 3), c('wheat', 0))
    p((11, 3), c('wheat', 0))
    p((9, 12), c('wheat', 0))
    p((10, 12), c('wheat', 0))
    p((11, 12), c('wheat', 0))

    # Fill
    for y in range(4, 12):
        p((9, y), c('wheat', 2 if y > 8 else 3))
        p((10, y), c('wheat', 3 if y > 6 else 4))
        p((11, y), c('wheat', 3 if y > 8 else 4))
    # Highlight
    p((10, 5), c('wheat', 5))
    p((10, 6), c('wheat', 4))

    # Wheat head center (x=14-18)
    for y in range(2, 11):
        p((14, y), c('wheat', 0))
        p((18, y), c('wheat', 0))
    p((15, 1), c('wheat', 0))
    p((16, 1), c('wheat', 0))
    p((17, 1), c('wheat', 0))
    p((15, 11), c('wheat', 0))
    p((16, 11), c('wheat', 0))
    p((17, 11), c('wheat', 0))

    for y in range(2, 11):
        p((15, y), c('wheat', 2 if y > 7 else 3))
        p((16, y), c('wheat', 3 if y > 5 else 4))
        p((17, y), c('wheat', 3 if y > 7 else 4))
    p((16, 3), c('wheat', 5))
    p((16, 4), c('wheat', 5))
    p((16, 5), c('wheat', 4))

    # Wheat head right (x=20-24)
    for y in range(5, 13):
        p((20, y), c('wheat', 0))
        p((24, y), c('wheat', 0))
    p((21, 4), c('wheat', 0))
    p((22, 4), c('wheat', 0))
    p((23, 4), c('wheat', 0))
    p((21, 13), c('wheat', 0))
    p((22, 13), c('wheat', 0))
    p((23, 13), c('wheat', 0))

    for y in range(5, 13):
        p((21, y), c('wheat', 2 if y > 9 else 3))
        p((22, y), c('wheat', 3 if y > 7 else 4))
        p((23, y), c('wheat', 3 if y > 9 else 4))
    p((22, 6), c('wheat', 5))
    p((22, 7), c('wheat', 4))

    # Stalks
    stalk_outline = (45, 70, 35, 255)
    stalk_base = (75, 110, 55, 255)
    stalk_light = (100, 140, 75, 255)

    # Left stalk
    for y in range(12, 28):
        p((10, y), stalk_outline)
        p((11, y), stalk_base if y > 20 else stalk_light)

    # Center stalk
    for y in range(11, 28):
        p((15, y), stalk_outline)
        p((16, y), stalk_base if y > 18 else stalk_light)
        p((17, y), stalk_outline if y > 24 else stalk_base)

    # Right stalk
    for y in range(13, 28):
        p((22, y), stalk_outline)
        p((23, y), stalk_base if y > 22 else stalk_light)

    # Bundle tie
    tie_color = (139, 90, 43, 255)
    for x in range(9, 25):
        p((x, 24), tie_color)
        p((x, 25), tie_color)

    save_sprite(img, 'wheat.png')

def create_wheat_seed():
    """Seed pouch with visible seeds"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Pouch outline
    pouch = [
        (65, 40, 25, 255),   # Outline
        (110, 75, 50, 255),  # Shadow
        (150, 110, 75, 255), # Base
        (185, 145, 110, 255),# Light
    ]

    # Draw pouch shape
    for x in range(10, 22):
        p((x, 10), pouch[0])
        p((x, 24), pouch[0])
    for y in range(11, 24):
        p((9, y), pouch[0])
        p((22, y), pouch[0])

    # Fill pouch
    for y in range(11, 24):
        for x in range(10, 22):
            shade = 2 if x > 16 or y > 18 else 3 if x > 13 else 2
            p((x, y), pouch[shade])

    # Top highlight
    for x in range(12, 18):
        p((x, 12), pouch[3])
        p((x, 13), pouch[3])

    # Visible seeds at top
    for sx, sy in [(12, 14), (15, 13), (18, 14), (14, 16), (17, 15)]:
        p((sx, sy), c('wheat', 3))
        p((sx+1, sy), c('wheat', 4))

    # Pouch tie string
    p((14, 9), pouch[0])
    p((15, 8), pouch[0])
    p((16, 8), pouch[0])
    p((17, 9), pouch[0])

    save_sprite(img, 'wheat_seed.png')

def create_moly():
    """Mythical moly - white flower, golden center, black root"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Petals - 5 white petals arranged around center
    petal_positions = [
        (16, 4),   # Top
        (10, 8),   # Top-left
        (22, 8),   # Top-right
        (12, 14),  # Bottom-left
        (20, 14),  # Bottom-right
    ]

    for px, py in petal_positions:
        # Each petal is 5x6 oval
        for dy in range(-2, 4):
            for dx in range(-2, 3):
                dist = abs(dx) + abs(dy) * 0.7
                if dist < 2.5:
                    shade = 5 if dist < 1 else 4 if dist < 1.8 else 3
                    p((px + dx, py + dy), c('moly_white', shade))
        # Outline
        p((px - 2, py), c('moly_white', 0))
        p((px + 2, py), c('moly_white', 0))
        p((px, py - 2), c('moly_white', 0))
        p((px, py + 3), c('moly_white', 0))

    # Golden center
    for dy in range(-2, 3):
        for dx in range(-2, 3):
            if abs(dx) + abs(dy) < 3:
                shade = 5 if abs(dx) + abs(dy) < 1 else 4 if abs(dx) + abs(dy) < 2 else 3
                p((16 + dx, 10 + dy), c('moly_gold', shade))

    # Green stem
    for y in range(16, 24):
        shade = 2 if y > 20 else 3
        p((15, y), c('stem', 0))
        p((16, y), c('stem', shade))
        p((17, y), c('stem', shade + 1))

    # Black root - the mythical part
    for y in range(24, 30):
        shade = 1 if y > 27 else 2 if y > 25 else 3
        p((14, y), c('moly_root', 0))
        p((15, y), c('moly_root', shade))
        p((16, y), c('moly_root', shade))
        p((17, y), c('moly_root', shade + 1))
        p((18, y), c('moly_root', 0))
    # Root tendrils
    p((13, 27), c('moly_root', 2))
    p((12, 28), c('moly_root', 1))
    p((19, 27), c('moly_root', 2))
    p((20, 28), c('moly_root', 1))

    save_sprite(img, 'moly.png')

def create_moly_seed():
    """Dark seeds with golden glow"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Small pile of black seeds with golden shimmer
    seed_positions = [
        (14, 18), (17, 17), (20, 19),
        (15, 21), (18, 20), (13, 20),
        (16, 19),
    ]

    for sx, sy in seed_positions:
        # Each seed is small oval
        p((sx, sy), c('moly_root', 0))
        p((sx+1, sy), c('moly_root', 2))
        p((sx, sy+1), c('moly_root', 1))
        p((sx+1, sy+1), c('moly_root', 0))
        # Golden highlight
        p((sx+1, sy), c('moly_gold', 4))

    save_sprite(img, 'moly_seed.png')

def create_nightshade():
    """Purple nightshade with dark berries"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Leaves
    leaf_positions = [(10, 14), (22, 14), (16, 18)]
    for lx, ly in leaf_positions:
        for dy in range(-2, 4):
            for dx in range(-3, 4):
                if abs(dx) * 0.8 + abs(dy) < 3.5:
                    shade = 4 if dy < 0 else 3 if abs(dx) < 2 else 2
                    p((lx + dx, ly + dy), c('leaf', shade))

    # Flowers - purple bell shapes
    flower_positions = [(12, 6), (20, 6), (16, 4)]
    for fx, fy in flower_positions:
        # Bell shape
        for dy in range(0, 5):
            width = 2 + dy // 2
            for dx in range(-width, width + 1):
                shade = 4 if dy < 2 else 3 if abs(dx) < width else 2
                p((fx + dx, fy + dy), c('nightshade', shade))
        # Outline
        p((fx, fy - 1), c('nightshade', 0))
        for dx in range(-3, 4):
            p((fx + dx, fy + 5), c('nightshade', 0))

    # Dark berries
    berry_positions = [(11, 22), (16, 21), (21, 22)]
    for bx, by in berry_positions:
        for dy in range(-2, 3):
            for dx in range(-2, 3):
                if dx*dx + dy*dy < 6:
                    shade = 5 if dx < 0 and dy < 0 else 4 if dx + dy < 1 else 3
                    p((bx + dx, by + dy), c('nightshade_berry', shade))
        # Highlight
        p((bx - 1, by - 1), c('nightshade_berry', 5))

    # Stem
    for y in range(10, 26):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))

    save_sprite(img, 'nightshade.png')

def create_nightshade_seed():
    """Small purple seeds"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    seed_positions = [
        (13, 17), (16, 16), (19, 18),
        (14, 20), (17, 19), (20, 20),
    ]

    for sx, sy in seed_positions:
        p((sx, sy), c('nightshade_berry', 0))
        p((sx+1, sy), c('nightshade_berry', 3))
        p((sx, sy+1), c('nightshade_berry', 2))
        p((sx+1, sy+1), c('nightshade_berry', 0))
        # Tiny highlight
        p((sx+1, sy), c('nightshade_berry', 4))

    save_sprite(img, 'nightshade_seed.png')

def create_potion(filename, liquid_ramp):
    """Generic high-quality potion bottle"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Cork
    for y in range(4, 8):
        for x in range(14, 19):
            shade = 4 if y < 6 and x > 14 and x < 18 else 3 if y < 7 else 2
            p((x, y), c('cork', shade))
    # Cork outline
    for x in range(14, 19):
        p((x, 3), c('cork', 0))
        p((x, 8), c('cork', 0))
    p((13, 4), c('cork', 0))
    p((13, 7), c('cork', 0))
    p((19, 4), c('cork', 0))
    p((19, 7), c('cork', 0))

    # Bottle neck
    for y in range(8, 12):
        for x in range(13, 20):
            if 14 <= x <= 18:
                shade = 4 if x < 17 else 3
                p((x, y), c('glass', shade))
    for y in range(8, 12):
        p((13, y), c('glass', 0))
        p((19, y), c('glass', 0))

    # Bottle body
    for y in range(12, 26):
        for x in range(8, 25):
            # Bottle shape - wider in middle
            mid_y = 19
            width = 7 - abs(y - mid_y) // 3
            if abs(x - 16) <= width:
                # Glass on edges, liquid in center
                if abs(x - 16) >= width - 1:
                    shade = 4 if x < 16 else 2
                    p((x, y), c('glass', shade))
                else:
                    # Liquid
                    shade = 4 if x < 15 and y < 20 else 3 if x < 17 else 2
                    p((x, y), c(liquid_ramp, shade))

    # Glass outline
    for y in range(12, 26):
        mid_y = 19
        width = 7 - abs(y - mid_y) // 3
        p((16 - width - 1, y), c('glass', 0))
        p((16 + width + 1, y), c('glass', 0))
    for x in range(10, 23):
        p((x, 25), c('glass', 0))

    # Glass highlight
    for y in range(14, 22):
        p((10, y), c('glass', 5))

    # Liquid highlight
    p((12, 15), c(liquid_ramp, 5))
    p((12, 16), c(liquid_ramp, 5))
    p((13, 14), c(liquid_ramp, 5))

    save_sprite(img, filename)

def create_moon_tear():
    """Ethereal glowing teardrop"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Outer glow (very faint)
    for dy in range(-10, 14):
        for dx in range(-8, 9):
            # Teardrop shape
            if dy < 0:
                threshold = 5 - abs(dy) // 2
            else:
                threshold = 7 - dy // 3
            if abs(dx) <= threshold:
                dist = abs(dx) + abs(dy) * 0.5
                if dist < 12:
                    alpha = max(0, 80 - int(dist * 8))
                    p((16 + dx, 14 + dy), (200, 230, 255, alpha))

    # Main tear body
    for dy in range(-6, 10):
        for dx in range(-5, 6):
            # Teardrop formula
            if dy < 0:
                threshold = 3 - abs(dy) // 3
            else:
                threshold = 5 - dy // 2
            if abs(dx) <= threshold:
                dist = (abs(dx) + abs(dy) * 0.4)
                shade = 5 if dist < 2 else 4 if dist < 4 else 3 if dist < 6 else 2
                p((16 + dx, 14 + dy), c('moon_tear', shade))

    # Bright highlight core
    p((14, 10), c('moon_tear', 5))
    p((15, 10), c('moon_tear', 5))
    p((14, 11), c('moon_tear', 5))
    p((15, 11), c('moon_tear', 5))
    p((15, 12), c('moon_tear', 5))

    save_sprite(img, 'moon_tear.png')

def create_sacred_earth():
    """Rich enchanted soil with golden sparkles"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Earth mound shape
    for y in range(12, 26):
        for x in range(6, 27):
            # Mound curve
            height = 26 - y
            width = 10 - height // 2
            if abs(x - 16) <= width:
                dist_from_top = y - 12
                dist_from_center = abs(x - 16)
                shade = 4 if dist_from_top < 4 and dist_from_center < 5 else 3 if dist_from_top < 8 else 2
                p((x, y), c('earth', shade))

    # Outline
    for x in range(8, 25):
        p((x, 25), c('earth', 0))
    for y in range(14, 25):
        width = 10 - (26 - y) // 2
        p((16 - width, y), c('earth', 0))
        p((16 + width, y), c('earth', 0))

    # Top highlight
    for x in range(12, 21):
        p((x, 14), c('earth', 5))

    # Golden sparkles
    sparkle_positions = [(10, 18), (14, 15), (18, 17), (22, 20), (12, 22), (20, 23)]
    for sx, sy in sparkle_positions:
        p((sx, sy), c('moly_gold', 5))
        p((sx+1, sy), c('moly_gold', 4))

    save_sprite(img, 'sacred_earth.png')

def create_woven_cloth():
    """Rolled cloth with visible weave pattern"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Main roll
    for y in range(10, 22):
        for x in range(6, 24):
            dist_from_center = abs(y - 16)
            if dist_from_center < 6:
                shade = 4 if dist_from_center < 2 else 3 if dist_from_center < 4 else 2
                # Weave pattern
                if (x + y) % 3 == 0:
                    shade = max(1, shade - 1)
                p((x, y), c('cloth', shade))

    # Outline
    for x in range(6, 24):
        p((x, 10), c('cloth', 0))
        p((x, 22), c('cloth', 0))
    for y in range(11, 22):
        p((5, y), c('cloth', 0))
        p((24, y), c('cloth', 0))

    # End spiral (right side)
    for dy in range(-4, 5):
        for dx in range(-2, 3):
            if abs(dy) + abs(dx) < 5:
                shade = 3 if dx < 0 else 2
                p((25 + dx, 16 + dy), c('cloth', shade))

    # Highlight stripe
    for x in range(8, 22):
        p((x, 13), c('cloth', 5))

    save_sprite(img, 'woven_cloth.png')

def create_pharmaka():
    """Magical pink flower"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # 5 petals around center
    petal_offsets = [
        (0, -6),   # Top
        (-5, -2),  # Top-left
        (5, -2),   # Top-right
        (-4, 4),   # Bottom-left
        (4, 4),    # Bottom-right
    ]

    for ox, oy in petal_offsets:
        cx, cy = 16 + ox, 12 + oy
        for dy in range(-3, 4):
            for dx in range(-3, 4):
                if dx*dx + dy*dy < 12:
                    dist = (dx*dx + dy*dy) ** 0.5
                    shade = 5 if dist < 1.5 else 4 if dist < 2.5 else 3
                    p((cx + dx, cy + dy), c('pharmaka', shade))

    # Center (darker pink)
    for dy in range(-2, 3):
        for dx in range(-2, 3):
            if abs(dx) + abs(dy) < 3:
                p((16 + dx, 12 + dy), c('pharmaka', 1 if abs(dx) + abs(dy) > 1 else 2))

    # Stem
    for y in range(16, 28):
        shade = 3 if y < 22 else 2
        p((15, y), c('stem', 0))
        p((16, y), c('stem', shade))
        p((17, y), c('stem', shade - 1))

    # Small leaves
    for ly in [20, 24]:
        for dx in range(-3, 0):
            p((15 + dx, ly), c('leaf', 3))
            p((15 + dx, ly + 1), c('leaf', 2))

    save_sprite(img, 'pharmaka_flower.png')

# ============================================================================
# NPC SPRITES - 64x64
# ============================================================================

def create_npc(filename, skin_ramp, robe_ramp, hair_color, accessory_func=None):
    """Create detailed NPC sprite"""
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    p = img.putpixel

    # Head (oval)
    for dy in range(-8, 9):
        for dx in range(-6, 7):
            if dx*dx/36 + dy*dy/64 < 1:
                shade = 4 if dx < 0 and dy < 0 else 3 if dx < 2 else 2
                p((32 + dx, 18 + dy), c(skin_ramp, shade))

    # Head outline
    for dy in range(-8, 9):
        for dx in range(-6, 7):
            if dx*dx/36 + dy*dy/64 < 1:
                if dx*dx/36 + dy*dy/64 > 0.7:
                    p((32 + dx, 18 + dy), c(skin_ramp, 0))

    # Eyes
    p((29, 17), (40, 40, 50, 255))
    p((35, 17), (40, 40, 50, 255))
    p((30, 17), (255, 255, 255, 255))
    p((36, 17), (255, 255, 255, 255))

    # Hair
    for dy in range(-10, -4):
        for dx in range(-7, 8):
            if abs(dx) < 7 - abs(dy + 7):
                p((32 + dx, 18 + dy), hair_color)

    # Body/Robe
    for y in range(26, 52):
        width = 10 + (y - 26) // 4
        for x in range(32 - width, 32 + width + 1):
            dist_from_center = abs(x - 32)
            shade = 4 if dist_from_center < width // 2 else 3 if dist_from_center < width - 2 else 2
            p((x, y), c(robe_ramp, shade))

    # Body outline
    for y in range(26, 52):
        width = 10 + (y - 26) // 4
        p((32 - width - 1, y), c(robe_ramp, 0))
        p((32 + width + 1, y), c(robe_ramp, 0))
    for x in range(18, 47):
        p((x, 52), c(robe_ramp, 0))

    # Arms
    for y in range(28, 45):
        # Left arm
        p((20, y), c(skin_ramp, 0))
        p((21, y), c(skin_ramp, 3))
        p((22, y), c(skin_ramp, 4))
        # Right arm
        p((44, y), c(skin_ramp, 0))
        p((43, y), c(skin_ramp, 2))
        p((42, y), c(skin_ramp, 3))

    # Feet
    for x in range(24, 30):
        p((x, 53), c(robe_ramp, 1))
        p((x, 54), c(robe_ramp, 0))
    for x in range(35, 41):
        p((x, 53), c(robe_ramp, 1))
        p((x, 54), c(robe_ramp, 0))

    # Accessory (optional)
    if accessory_func:
        accessory_func(img, p)

    save_sprite(img, filename)

def hermes_accessory(img, p):
    """Winged sandals and caduceus"""
    # Wings on head (messenger cap)
    wing_color = (255, 255, 255, 255)
    for y in range(8, 14):
        p((23, y), wing_color)
        p((24, y), wing_color)
        p((40, y), wing_color)
        p((41, y), wing_color)

    # Caduceus staff (held in hand)
    staff = (139, 90, 43, 255)
    for y in range(28, 55):
        p((45, y), staff)
    # Snake detail
    for y in range(32, 40, 2):
        p((46, y), (100, 150, 100, 255))
        p((44, y+1), (100, 150, 100, 255))

def aeetes_accessory(img, p):
    """Crown and fire staff"""
    # Golden crown
    crown = (255, 215, 0, 255)
    for x in range(27, 38):
        p((x, 8), crown)
        if x % 3 == 0:
            p((x, 7), crown)
            p((x, 6), crown)

    # Staff with fire
    staff = (100, 60, 30, 255)
    for y in range(28, 55):
        p((46, y), staff)
    # Fire
    fire = [(255, 100, 0, 255), (255, 200, 0, 255), (255, 255, 100, 255)]
    for y in range(24, 30):
        p((46, y), fire[(y - 24) % 3])
        p((45, y + 1), fire[(y - 24) % 3])
        p((47, y + 1), fire[(y - 24) % 3])

def daedalus_accessory(img, p):
    """Tools and wings motif on apron"""
    # Leather apron (over robe)
    apron = (139, 90, 43, 255)
    for y in range(30, 50):
        for x in range(26, 39):
            if y > 32:
                p((x, y), apron)

    # Tool in hand
    for y in range(35, 50):
        p((44, y), (150, 150, 150, 255))

def scylla_accessory(img, p):
    """Tentacles and sea elements"""
    # Tentacles at bottom
    tentacle = (40, 100, 110, 255)
    for i, x in enumerate([20, 25, 30, 35, 40, 45]):
        for y in range(50, 58):
            wave = (y + i) % 3
            p((x + wave, y), tentacle)

def circe_accessory(img, p):
    """Magic wand with glow"""
    # Wand
    wand = (100, 60, 100, 255)
    for y in range(30, 48):
        p((45, y), wand)

    # Magical glow at tip
    glow = (200, 150, 255, 200)
    for dy in range(-3, 4):
        for dx in range(-3, 4):
            if abs(dx) + abs(dy) < 4:
                p((45 + dx, 28 + dy), glow)
    p((45, 28), (255, 200, 255, 255))

# ============================================================================
# MINIGAME ASSETS
# ============================================================================

def create_moon_tears_assets():
    """Create moon tears minigame backgrounds"""
    # Starry sky (256x144)
    stars = Image.new('RGBA', (256, 144), (8, 12, 24, 255))
    p = stars.putpixel

    import random
    random.seed(42)  # Consistent stars

    # Background gradient (darker at top)
    for y in range(144):
        for x in range(256):
            base = stars.getpixel((x, y))
            brightness = int(y / 144 * 15)
            stars.putpixel((x, y), (base[0] + brightness, base[1] + brightness, base[2] + brightness, 255))

    # Stars with varying brightness
    for _ in range(80):
        x, y = random.randint(0, 255), random.randint(0, 143)
        brightness = random.randint(150, 255)
        size = random.choice([1, 1, 1, 2])
        for dy in range(size):
            for dx in range(size):
                if x + dx < 256 and y + dy < 144:
                    p((x + dx, y + dy), (brightness, brightness, brightness - 20, 255))

    save_sprite(stars, 'moon_tears_stars.png')

    # Moon (96x96)
    moon = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    p = moon.putpixel

    for dy in range(-40, 41):
        for dx in range(-40, 41):
            dist = (dx*dx + dy*dy) ** 0.5
            if dist < 38:
                # Moon surface
                shade = 255 - int(dist * 1.5)
                # Add some crater variation
                crater_mod = ((dx * 7 + dy * 11) % 20) - 10
                shade = max(200, min(255, shade + crater_mod))
                p((48 + dx, 48 + dy), (shade, shade, shade - 15, 255))

    # Soft glow around edge
    for dy in range(-44, 45):
        for dx in range(-44, 45):
            dist = (dx*dx + dy*dy) ** 0.5
            if 38 <= dist < 44:
                alpha = int((44 - dist) / 6 * 100)
                p((48 + dx, 48 + dy), (255, 255, 240, alpha))

    save_sprite(moon, 'moon_tears_moon.png')

    # Player marker (40x10)
    marker = Image.new('RGBA', (40, 10), (0, 0, 0, 0))
    p = marker.putpixel

    for y in range(2, 8):
        for x in range(4, 36):
            dist_from_edge = min(x - 4, 35 - x, y - 2, 7 - y)
            if dist_from_edge >= 0:
                shade = 255 if dist_from_edge > 2 else 220 if dist_from_edge > 1 else 180
                p((x, y), (shade, shade + 10, 255, 255))

    # Outline
    for x in range(4, 36):
        p((x, 1), (100, 150, 200, 255))
        p((x, 8), (100, 150, 200, 255))
    for y in range(2, 8):
        p((3, y), (100, 150, 200, 255))
        p((36, y), (100, 150, 200, 255))

    save_sprite(marker, 'moon_tears_player_marker.png')

def create_sacred_earth_digging():
    """Digging area for sacred earth minigame (128x128)"""
    img = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
    p = img.putpixel

    import random
    random.seed(123)

    # Rich soil circle
    for dy in range(-55, 56):
        for dx in range(-55, 56):
            dist = (dx*dx + dy*dy) ** 0.5
            if dist < 52:
                # Base earth color with variation
                base_shade = 3 if dist < 30 else 2 if dist < 45 else 1
                # Add texture
                variation = random.randint(-1, 1)
                shade = max(0, min(5, base_shade + variation))
                color = RAMPS['earth'][shade]
                p((64 + dx, 64 + dy), color + (255,))

    # Outline
    for dy in range(-55, 56):
        for dx in range(-55, 56):
            dist = (dx*dx + dy*dy) ** 0.5
            if 50 <= dist < 54:
                p((64 + dx, 64 + dy), c('earth', 0))

    # Golden rune marks
    rune_positions = [(40, 50), (88, 50), (64, 90), (45, 80), (83, 80)]
    for rx, ry in rune_positions:
        for dy in range(-3, 4):
            for dx in range(-1, 2):
                if random.random() > 0.3:
                    p((rx + dx, ry + dy), c('moly_gold', 4))

    save_sprite(img, 'sacred_earth_digging_area.png')

def create_crafting_mortar():
    """Stone mortar and pestle (96x96)"""
    img = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    p = img.putpixel

    # Stone gray ramp
    stone = [
        (50, 50, 55),      # Outline
        (80, 80, 88),      # Deep shadow
        (110, 110, 120),   # Shadow
        (145, 145, 155),   # Base
        (175, 175, 185),   # Light
        (200, 200, 210),   # Highlight
    ]

    # Mortar bowl (wide at top, narrow at bottom)
    for y in range(35, 80):
        progress = (y - 35) / 45
        top_width = 35
        bottom_width = 25
        width = int(top_width - (top_width - bottom_width) * progress)

        for dx in range(-width, width + 1):
            dist_from_center = abs(dx)
            shade_idx = 4 if dist_from_center < width * 0.3 else 3 if dist_from_center < width * 0.7 else 2
            p((48 + dx, y), stone[shade_idx] + (255,))

    # Inner bowl darkness
    for y in range(38, 60):
        width = 25 - (y - 38) // 2
        for dx in range(-width, width + 1):
            p((48 + dx, y), stone[1] + (255,))

    # Bowl rim highlight
    for dx in range(-33, 34):
        if abs(dx) < 30:
            p((48 + dx, 36), stone[5] + (255,))
            p((48 + dx, 37), stone[4] + (255,))

    # Pestle (diagonal)
    for i in range(40):
        x = 60 + i // 3
        y = 25 + i
        for t in range(-4, 5):
            shade = 4 if t < 0 else 3 if t < 3 else 2
            p((x + t, y), stone[shade] + (255,))

    # Pestle handle end
    for dy in range(-5, 6):
        for dx in range(-5, 6):
            if dx*dx + dy*dy < 25:
                shade = 4 if dx < 0 else 3
                p((72 + dx, 20 + dy), stone[shade] + (255,))

    save_sprite(img, 'crafting_mortar.png')

# ============================================================================
# ENVIRONMENT SPRITES
# ============================================================================

def create_grass_tile():
    """32x32 seamless tileable grass with dithering for texture"""
    import random
    random.seed(777)  # Consistent for reproducibility

    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # Base fill with 3-shade variation for texture
    for y in range(32):
        for x in range(32):
            # Dithering pattern for seamless texture
            # Use checkerboard with noise for natural look
            base_shade = 3  # Medium green base

            # Add subtle variation
            pattern = (x + y) % 4
            if pattern == 0:
                shade = 2  # Shadow
            elif pattern == 1 or pattern == 2:
                shade = 3  # Base
            else:
                shade = 4  # Light

            # Add random grass blade highlights
            if random.random() > 0.85:
                shade = 4  # Occasional bright blade
            if random.random() > 0.92:
                shade = 5  # Rare highlight

            p((x, y), c('grass', shade))

    # Add small grass tufts for detail
    tuft_positions = [
        (4, 6), (12, 3), (20, 8), (28, 5),
        (8, 16), (18, 14), (26, 18),
        (3, 24), (14, 26), (22, 22), (30, 28)
    ]
    for tx, ty in tuft_positions:
        # Small 3-pixel tall tuft
        for dy in range(-2, 1):
            tx_mod = tx % 32
            ty_mod = (ty + dy) % 32
            shade = 4 if dy < 0 else 3
            p((tx_mod, ty_mod), c('grass', shade))

    # Save to tiles directory
    path = os.path.join(TILES_DIR, 'placeholder_grass.png')
    img.save(path)
    print("Created: placeholder_grass.png (tiles)")

def create_crop_stages():
    """Create 4 growth stages for each crop type"""

    # Wheat stages
    create_wheat_stages()
    # Moly stages
    create_moly_stages()
    # Nightshade stages
    create_nightshade_stages()

def create_wheat_stages():
    """Wheat: seed -> sprout -> growing -> harvestable"""

    # Stage 1: Just planted (seed mound)
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    # Small dirt mound
    for y in range(24, 28):
        for x in range(12, 20):
            if abs(x - 16) < 5 - (y - 24):
                p((x, y), c('earth', 3))
    for x in range(13, 19):
        p((x, 28), c('earth', 0))
    save_sprite(img, 'wheat_stage_1.png')

    # Stage 2: Small sprout
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    # Tiny green sprout
    for y in range(20, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Two small leaves
    p((14, 22), c('leaf', 3))
    p((18, 22), c('leaf', 3))
    save_sprite(img, 'wheat_stage_2.png')

    # Stage 3: Growing stalk
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    # Taller stalk with forming head
    for y in range(12, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Small wheat head forming
    for y in range(8, 14):
        p((15, y), c('wheat', 2))
        p((16, y), c('wheat', 3))
        p((17, y), c('wheat', 2))
    # Outline
    p((15, 7), c('wheat', 0))
    p((16, 7), c('wheat', 0))
    p((17, 7), c('wheat', 0))
    save_sprite(img, 'wheat_stage_3.png')

    # Stage 4: Mature (golden)
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    # Full wheat stalk with golden head
    for y in range(14, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Full wheat head
    for y in range(4, 15):
        for x in range(13, 20):
            if 14 <= x <= 18:
                shade = 4 if y < 8 else 3 if y < 12 else 2
                p((x, y), c('wheat', shade))
    # Outline
    for y in range(4, 15):
        p((13, y), c('wheat', 0))
        p((19, y), c('wheat', 0))
    for x in range(14, 19):
        p((x, 3), c('wheat', 0))
        p((x, 15), c('wheat', 0))
    # Highlight
    p((16, 6), c('wheat', 5))
    p((16, 7), c('wheat', 5))
    save_sprite(img, 'wheat_stage_4.png')

def create_moly_stages():
    """Moly: seed -> sprout -> budding -> blooming white flower"""

    # Stage 1: Dark seed mound
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(24, 28):
        for x in range(12, 20):
            if abs(x - 16) < 5 - (y - 24):
                p((x, y), c('moly_root', 3))
    save_sprite(img, 'moly_stage_1.png')

    # Stage 2: Dark sprout
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(18, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Dark leaves hint at the black root nature
    p((14, 20), c('moly_root', 3))
    p((18, 20), c('moly_root', 3))
    save_sprite(img, 'moly_stage_2.png')

    # Stage 3: Bud forming
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(12, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Closed bud (white)
    for dy in range(-3, 2):
        for dx in range(-2, 3):
            if abs(dx) + abs(dy) < 3:
                p((16 + dx, 10 + dy), c('moly_white', 3))
    save_sprite(img, 'moly_stage_3.png')

    # Stage 4: Full bloom (white petals, gold center, black root visible)
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    # Stem
    for y in range(14, 24):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Black root showing
    for y in range(24, 30):
        p((15, y), c('moly_root', 0))
        p((16, y), c('moly_root', 2))
        p((17, y), c('moly_root', 1))
    # White petals
    petal_pos = [(16, 5), (12, 9), (20, 9), (14, 14), (18, 14)]
    for px, py in petal_pos:
        for dy in range(-2, 3):
            for dx in range(-2, 3):
                if abs(dx) + abs(dy) < 3:
                    p((px + dx, py + dy), c('moly_white', 4))
    # Gold center
    for dy in range(-1, 2):
        for dx in range(-1, 2):
            p((16 + dx, 10 + dy), c('moly_gold', 4))
    save_sprite(img, 'moly_stage_4.png')

def create_nightshade_stages():
    """Nightshade: seed -> sprout -> flowering -> berries"""

    # Stage 1: Purple-tinged seed mound
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(24, 28):
        for x in range(12, 20):
            if abs(x - 16) < 5 - (y - 24):
                p((x, y), c('nightshade_berry', 2))
    save_sprite(img, 'nightshade_stage_1.png')

    # Stage 2: Dark green sprout
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(18, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 2))
        p((17, y), c('stem', 1))
    # Small dark leaves
    p((13, 20), c('leaf', 2))
    p((14, 20), c('leaf', 3))
    p((18, 20), c('leaf', 3))
    p((19, 20), c('leaf', 2))
    save_sprite(img, 'nightshade_stage_2.png')

    # Stage 3: Flowering (purple bells)
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(14, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Purple flowers
    flower_pos = [(12, 10), (20, 10), (16, 8)]
    for fx, fy in flower_pos:
        for dy in range(0, 4):
            width = 1 + dy // 2
            for dx in range(-width, width + 1):
                p((fx + dx, fy + dy), c('nightshade', 3 + (1 if dy < 2 else 0)))
    # Leaves
    for lx, ly in [(10, 16), (22, 16)]:
        for dx in range(-2, 3):
            for dy in range(-1, 2):
                if abs(dx) + abs(dy) < 3:
                    p((lx + dx, ly + dy), c('leaf', 3))
    save_sprite(img, 'nightshade_stage_3.png')

    # Stage 4: With dark berries
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel
    for y in range(14, 28):
        p((15, y), c('stem', 0))
        p((16, y), c('stem', 3))
        p((17, y), c('stem', 2))
    # Leaves
    for lx, ly in [(10, 16), (22, 16), (16, 20)]:
        for dx in range(-3, 4):
            for dy in range(-2, 3):
                if abs(dx) * 0.7 + abs(dy) < 3:
                    p((lx + dx, ly + dy), c('leaf', 3 if dy < 1 else 2))
    # Dark purple berries
    berry_pos = [(11, 22), (16, 20), (21, 22)]
    for bx, by in berry_pos:
        for dy in range(-2, 2):
            for dx in range(-2, 2):
                if dx*dx + dy*dy < 4:
                    shade = 4 if dx < 0 and dy < 0 else 3
                    p((bx + dx, by + dy), c('nightshade_berry', shade))
        p((bx - 1, by - 1), c('nightshade_berry', 5))  # Highlight
    save_sprite(img, 'nightshade_stage_4.png')

def create_app_icon():
    """512x512 app icon - Circe silhouette with moon and herbs"""
    img = Image.new('RGBA', (512, 512), (0, 0, 0, 0))

    # Background gradient (deep purple to dark blue)
    for y in range(512):
        for x in range(512):
            # Radial gradient from center
            dx = x - 256
            dy = y - 256
            dist = (dx*dx + dy*dy) ** 0.5

            # Purple to dark blue gradient
            t = min(1.0, dist / 300)
            r = int(45 * (1 - t) + 15 * t)
            g = int(25 * (1 - t) + 15 * t)
            b = int(70 * (1 - t) + 40 * t)
            img.putpixel((x, y), (r, g, b, 255))

    # Moon in upper right (large, detailed)
    moon_cx, moon_cy, moon_r = 380, 130, 80
    for dy in range(-moon_r - 10, moon_r + 11):
        for dx in range(-moon_r - 10, moon_r + 11):
            dist = (dx*dx + dy*dy) ** 0.5
            if dist < moon_r:
                # Moon surface
                shade = int(240 - dist * 0.5)
                # Crater variation
                crater = ((dx * 7 + dy * 11) % 30) - 15
                shade = max(200, min(255, shade + crater))
                img.putpixel((moon_cx + dx, moon_cy + dy), (shade, shade, shade - 10, 255))
            elif dist < moon_r + 8:
                # Soft glow
                alpha = int((moon_r + 8 - dist) / 8 * 120)
                img.putpixel((moon_cx + dx, moon_cy + dy), (255, 255, 230, alpha))

    # Circe silhouette (center-left, facing right)
    circe_x, circe_y = 200, 350

    # Head
    for dy in range(-50, 51):
        for dx in range(-40, 41):
            if dx*dx/1600 + dy*dy/2500 < 1:
                img.putpixel((circe_x + dx, circe_y - 150 + dy), (30, 20, 40, 255))

    # Hair flowing
    for dy in range(-60, 20):
        for dx in range(-60, -30):
            wave = int(15 * ((dy + 60) / 80) ** 0.5)
            if dx + wave > -55 and dx + wave < -25:
                img.putpixel((circe_x + dx + wave, circe_y - 130 + dy), (30, 20, 40, 255))

    # Body/robe
    for y in range(circe_y - 100, circe_y + 150):
        progress = (y - (circe_y - 100)) / 250
        width = int(50 + progress * 60)
        for dx in range(-width, width + 1):
            img.putpixel((circe_x + dx, y), (30, 20, 40, 255))

    # Arm raised with wand
    for i in range(120):
        x = circe_x + 60 + i // 2
        y = circe_y - 50 - i // 3
        for t in range(-8, 9):
            if x + t < 512 and y > 0:
                img.putpixel((x + t, y), (30, 20, 40, 255))

    # Wand
    wand_x, wand_y = circe_x + 120, circe_y - 90
    for i in range(60):
        x = wand_x + i // 3
        y = wand_y - i
        for t in range(-3, 4):
            if 0 <= x + t < 512 and 0 <= y < 512:
                img.putpixel((x + t, y), (100, 60, 40, 255))

    # Magical glow at wand tip
    glow_x, glow_y = wand_x + 20, wand_y - 60
    for dy in range(-30, 31):
        for dx in range(-30, 31):
            dist = (dx*dx + dy*dy) ** 0.5
            if dist < 25:
                alpha = int((25 - dist) / 25 * 200)
                old = img.getpixel((glow_x + dx, glow_y + dy))
                new_r = min(255, old[0] + int(180 * alpha / 255))
                new_g = min(255, old[1] + int(140 * alpha / 255))
                new_b = min(255, old[2] + int(220 * alpha / 255))
                img.putpixel((glow_x + dx, glow_y + dy), (new_r, new_g, new_b, 255))

    # Herbs at bottom
    for herb_x in [80, 150, 380, 450]:
        for y in range(460, 512):
            height = 512 - y
            for dx in range(-15, 16):
                wave = int(5 * (height / 52) * (1 if dx % 2 == 0 else -1))
                if abs(dx + wave) < 12 - height // 8:
                    # Green with gold highlights
                    shade = 80 + (height * 2)
                    if dx == 0 and height > 20:
                        img.putpixel((herb_x + dx, y), (200, 180, 80, 255))  # Gold tip
                    else:
                        img.putpixel((herb_x + dx, y), (40, shade, 50, 255))

    # Title area glow at bottom
    for y in range(480, 512):
        for x in range(512):
            old = img.getpixel((x, y))
            fade = (y - 480) / 32
            new_r = int(old[0] * (1 - fade * 0.3))
            new_g = int(old[1] * (1 - fade * 0.3))
            new_b = int(old[2] * (1 - fade * 0.3))
            img.putpixel((x, y), (new_r, new_g, new_b, 255))

    save_sprite(img, 'app_icon_placeholder.png')

# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=== Circe's Garden HIGH QUALITY Sprite Generator ===")
    print(f"Output: {SPRITES_DIR}")
    print()

    print("--- Creating Items ---")
    create_wheat()
    create_wheat_seed()
    create_moly()
    create_moly_seed()
    create_nightshade()
    create_nightshade_seed()
    print()

    print("--- Creating Potions ---")
    create_potion('calming_draught_potion.png', 'potion_blue')
    create_potion('binding_ward_potion.png', 'potion_gold')
    create_potion('reversal_elixir_potion.png', 'potion_green')
    create_potion('petrification_potion.png', 'potion_gray')
    print()

    print("--- Creating Rewards ---")
    create_moon_tear()
    create_sacred_earth()
    create_woven_cloth()
    create_pharmaka()
    print()

    print("--- Creating NPCs ---")
    create_npc('npc_hermes.png', 'skin', 'hermes_robe', (180, 140, 100, 255), hermes_accessory)
    create_npc('npc_aeetes.png', 'skin', 'aeetes_robe', (60, 40, 30, 255), aeetes_accessory)
    create_npc('npc_daedalus.png', 'skin', 'daedalus_robe', (180, 180, 190, 255), daedalus_accessory)
    create_npc('npc_scylla.png', 'scylla_skin', 'scylla_skin', (30, 80, 90, 255), scylla_accessory)
    create_npc('npc_circe.png', 'skin', 'circe_robe', (80, 50, 30, 255), circe_accessory)
    print()

    print("--- Creating Minigame Assets ---")
    create_moon_tears_assets()
    create_sacred_earth_digging()
    create_crafting_mortar()
    print()

    print("--- Creating Environment ---")
    create_grass_tile()
    create_crop_stages()
    print()

    print("--- Creating App Icon ---")
    create_app_icon()
    print()

    print("=== HIGH QUALITY Generation Complete! ===")

if __name__ == '__main__':
    main()
