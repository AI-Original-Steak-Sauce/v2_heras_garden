"""
Circe's Garden Sprite Generator
Generates pixel art sprites using Pillow + SpriteGenerator library

Usage: python generate_sprites.py [category]
Categories: items, npcs, minigame, environment, all
"""

import sys
import os
import random

# Add the sprite_gen_lib to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'sprite_gen_lib'))

from PIL import Image, ImageDraw
from SpriteGenerator import generate_canvas

# Project paths
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
SPRITES_DIR = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'placeholders')

# Color Palette from PLACEHOLDER_README.md
PALETTE = {
    # Characters
    'circe': (255, 215, 0),           # Gold #FFD700
    'circe_dark': (218, 165, 32),     # Darker gold
    'scylla_before': (221, 160, 221), # Light Purple
    'scylla_after': (139, 0, 139),    # Dark Purple
    'hermes': (135, 206, 235),        # Sky Blue
    'hermes_dark': (70, 130, 180),    # Steel Blue
    'aeetes': (255, 140, 0),          # Dark Orange (regal)
    'aeetes_dark': (184, 100, 0),     # Darker orange
    'daedalus': (139, 119, 101),      # Earthy brown
    'daedalus_dark': (105, 90, 77),   # Darker brown

    # Crops
    'wheat': (255, 215, 0),           # Gold
    'wheat_dark': (218, 165, 32),     # Darker gold
    'moly': (255, 255, 255),          # White
    'moly_dark': (200, 200, 200),     # Light gray
    'moly_accent': (255, 223, 0),     # Golden center
    'nightshade': (147, 112, 219),    # Purple
    'nightshade_dark': (102, 51, 153),# Darker purple
    'nightshade_berry': (75, 0, 130), # Indigo berries

    # Potions
    'calming': (100, 149, 237),       # Cornflower blue
    'calming_dark': (65, 105, 225),   # Royal blue
    'binding': (255, 215, 0),         # Gold
    'binding_dark': (218, 165, 32),   # Darker gold
    'reversal': (50, 205, 50),        # Lime green
    'reversal_dark': (34, 139, 34),   # Forest green
    'petrification': (128, 128, 128), # Gray
    'petrification_dark': (105, 105, 105), # Dim gray

    # Minigame rewards
    'moon_tear': (173, 216, 230),     # Light blue
    'moon_tear_glow': (224, 255, 255),# Light cyan
    'sacred_earth': (139, 90, 43),    # Saddle brown
    'sacred_earth_glow': (255, 215, 0),# Gold specks
    'woven_cloth': (210, 180, 140),   # Tan
    'woven_cloth_dark': (188, 143, 143),# Rosy brown
    'pharmaka': (255, 182, 193),      # Light pink
    'pharmaka_dark': (219, 112, 147), # Pale violet red

    # Environment
    'grass': (76, 175, 80),           # Green
    'grass_dark': (56, 142, 60),      # Darker green
    'dirt': (139, 69, 19),            # Brown
    'outline': (0, 0, 0),             # Black
    'glass': (200, 220, 240),         # Light glass tint
}

# ============================================================================
# MASK TEMPLATES
# 0 = empty, 1 = random body, 2 = always solid
# ============================================================================

# Item masks (will be mirrored horizontally for symmetry)
WHEAT_MASK = [
    [0, 0, 1, 2],
    [0, 0, 1, 2],
    [0, 1, 2, 2],
    [0, 1, 2, 1],
    [0, 1, 2, 1],
    [0, 0, 2, 0],
    [0, 0, 2, 0],
    [0, 0, 2, 0],
]

SEED_MASK = [
    [0, 0, 0, 0],
    [0, 1, 1, 0],
    [0, 1, 2, 1],
    [0, 0, 1, 0],
]

POTION_MASK = [
    [0, 0, 2, 2],
    [0, 0, 2, 2],
    [0, 0, 1, 1],
    [0, 1, 2, 2],
    [0, 2, 2, 2],
    [0, 2, 2, 2],
    [0, 2, 2, 2],
    [0, 1, 2, 2],
]

FLOWER_MASK = [
    [0, 1, 2, 1],
    [1, 2, 2, 2],
    [0, 2, 2, 2],
    [0, 1, 2, 1],
    [0, 0, 2, 0],
    [0, 0, 2, 0],
]

TEAR_MASK = [
    [0, 0, 1, 0],
    [0, 1, 2, 1],
    [0, 2, 2, 2],
    [1, 2, 2, 2],
    [0, 2, 2, 2],
    [0, 1, 2, 1],
    [0, 0, 1, 0],
]

EARTH_MASK = [
    [1, 1, 1, 1],
    [1, 2, 2, 2],
    [2, 2, 2, 2],
    [1, 2, 2, 1],
]

CLOTH_MASK = [
    [0, 1, 1, 1],
    [1, 2, 2, 2],
    [1, 2, 2, 2],
    [1, 2, 2, 1],
    [0, 1, 1, 0],
]

# NPC masks (larger, more detail)
HUMANOID_MASK = [
    [0, 0, 0, 0, 0, 1, 1, 1],  # Head top
    [0, 0, 0, 0, 1, 2, 2, 2],  # Head
    [0, 0, 0, 0, 1, 2, 2, 2],  # Head
    [0, 0, 0, 0, 0, 2, 2, 1],  # Neck
    [0, 0, 0, 1, 2, 2, 2, 2],  # Shoulders
    [0, 0, 1, 2, 2, 2, 2, 1],  # Upper body
    [0, 0, 0, 2, 2, 2, 2, 0],  # Torso
    [0, 0, 0, 1, 2, 2, 1, 0],  # Waist
    [0, 0, 0, 1, 2, 2, 1, 0],  # Hips
    [0, 0, 0, 0, 2, 1, 0, 0],  # Upper legs
    [0, 0, 0, 0, 2, 1, 0, 0],  # Legs
    [0, 0, 0, 0, 2, 1, 0, 0],  # Lower legs
]

# ============================================================================
# SPRITE GENERATION FUNCTIONS
# ============================================================================

def create_simple_sprite(size, draw_func, filename):
    """Create a sprite with custom drawing function"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw_func(img, draw, size)
    output_path = os.path.join(SPRITES_DIR, filename)
    img.save(output_path)
    print(f"Created: {filename}")
    return img

def add_outline(img, outline_color=(0, 0, 0, 255)):
    """Add 1px outline around non-transparent pixels"""
    width, height = img.size
    pixels = img.load()
    outline_pixels = []

    for y in range(height):
        for x in range(width):
            if pixels[x, y][3] > 0:  # Non-transparent pixel
                # Check neighbors
                for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < width and 0 <= ny < height:
                        if pixels[nx, ny][3] == 0:  # Transparent neighbor
                            outline_pixels.append((nx, ny))

    for x, y in outline_pixels:
        pixels[x, y] = outline_color

    return img

def apply_shading(img, light_dir='top_left'):
    """Apply simple shading based on light direction"""
    width, height = img.size
    pixels = img.load()

    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if a > 0:
                # Darken bottom-right pixels
                factor = 1.0
                if light_dir == 'top_left':
                    factor = 1.0 - (x / width * 0.2) - (y / height * 0.2)
                pixels[x, y] = (
                    int(r * factor),
                    int(g * factor),
                    int(b * factor),
                    a
                )
    return img

# ============================================================================
# ITEM SPRITES (32x32)
# ============================================================================

def generate_wheat(img, draw, size):
    """Golden wheat bundle"""
    cx, cy = size // 2, size // 2
    # Stalks
    for offset in [-4, -2, 0, 2, 4]:
        x = cx + offset
        for y in range(8, 26):
            shade = PALETTE['wheat'] if y < 18 else PALETTE['wheat_dark']
            img.putpixel((x, y), shade + (255,))
        # Wheat heads (top)
        for dy in range(-4, 0):
            if random.random() > 0.3:
                img.putpixel((x + random.randint(-1, 1), 8 + dy), PALETTE['wheat'] + (255,))

def generate_wheat_seed(img, draw, size):
    """Small seed pouch"""
    cx, cy = size // 2, size // 2
    # Pouch shape
    draw.ellipse([cx-6, cy-4, cx+6, cy+6], fill=PALETTE['dirt'] + (255,))
    draw.ellipse([cx-5, cy-3, cx+5, cy+4], fill=(160, 82, 45, 255))  # Sienna
    # Seeds visible
    for i in range(3):
        sx = cx - 3 + i * 3
        img.putpixel((sx, cy), PALETTE['wheat'] + (255,))

def generate_moly(img, draw, size):
    """Mythical moly - white flower with golden center"""
    cx, cy = size // 2, size // 2
    # Petals (white)
    for angle in range(5):
        px = cx + int(6 * (angle % 2 * 2 - 1))
        py = cy - 6 + (angle % 3) * 2
        draw.ellipse([px-3, py-3, px+3, py+3], fill=PALETTE['moly'] + (255,))
    # Center (golden)
    draw.ellipse([cx-2, cy-7, cx+2, cy-3], fill=PALETTE['moly_accent'] + (255,))
    # Stem
    for y in range(cy, cy + 10):
        img.putpixel((cx, y), (34, 139, 34, 255))  # Forest green
    # Black root
    for y in range(cy + 10, cy + 14):
        img.putpixel((cx, y), (20, 20, 20, 255))

def generate_moly_seed(img, draw, size):
    """Glowing black seeds"""
    cx, cy = size // 2, size // 2
    draw.ellipse([cx-5, cy-3, cx+5, cy+5], fill=(40, 40, 40, 255))
    # Glow effect
    for i in range(3):
        x = cx - 2 + i * 2
        img.putpixel((x, cy), PALETTE['moly_accent'] + (255,))

def generate_nightshade(img, draw, size):
    """Purple nightshade with berries"""
    cx, cy = size // 2, size // 2
    # Leaves
    draw.polygon([(cx, cy-8), (cx-6, cy), (cx, cy-2), (cx+6, cy)],
                 fill=(34, 100, 34, 255))
    # Purple flowers
    for offset in [-4, 4]:
        draw.ellipse([cx+offset-3, cy-10, cx+offset+3, cy-4],
                     fill=PALETTE['nightshade'] + (255,))
    # Berries
    for i, offset in enumerate([-3, 0, 3]):
        color = PALETTE['nightshade_berry'] if i == 1 else PALETTE['nightshade_dark']
        draw.ellipse([cx+offset-2, cy+2, cx+offset+2, cy+6], fill=color + (255,))
    # Stem
    for y in range(cy+6, cy+12):
        img.putpixel((cx, y), (34, 80, 34, 255))

def generate_nightshade_seed(img, draw, size):
    """Small purple seeds"""
    cx, cy = size // 2, size // 2
    draw.ellipse([cx-5, cy-3, cx+5, cy+5], fill=(60, 40, 60, 255))
    for i in range(3):
        x = cx - 2 + i * 2
        img.putpixel((x, cy), PALETTE['nightshade'] + (255,))

# ============================================================================
# POTION SPRITES (32x32)
# ============================================================================

def generate_potion(img, draw, size, liquid_color, liquid_dark, name):
    """Generic potion bottle"""
    cx, cy = size // 2, size // 2
    # Cork
    draw.rectangle([cx-2, cy-12, cx+2, cy-9], fill=(139, 90, 43, 255))
    # Bottle neck
    draw.rectangle([cx-3, cy-9, cx+3, cy-5], fill=PALETTE['glass'] + (200,))
    # Bottle body
    draw.ellipse([cx-8, cy-5, cx+8, cy+10], fill=PALETTE['glass'] + (180,))
    # Liquid
    draw.ellipse([cx-6, cy-2, cx+6, cy+8], fill=liquid_color + (255,))
    draw.ellipse([cx-4, cy, cx+4, cy+6], fill=liquid_dark + (255,))
    # Highlight
    img.putpixel((cx-4, cy-3), (255, 255, 255, 200))
    img.putpixel((cx-3, cy-4), (255, 255, 255, 150))

def generate_calming_draught(img, draw, size):
    generate_potion(img, draw, size, PALETTE['calming'], PALETTE['calming_dark'], 'calming')

def generate_binding_ward(img, draw, size):
    generate_potion(img, draw, size, PALETTE['binding'], PALETTE['binding_dark'], 'binding')

def generate_reversal_elixir(img, draw, size):
    generate_potion(img, draw, size, PALETTE['reversal'], PALETTE['reversal_dark'], 'reversal')

def generate_petrification(img, draw, size):
    generate_potion(img, draw, size, PALETTE['petrification'], PALETTE['petrification_dark'], 'petrification')

# ============================================================================
# MINIGAME REWARDS (32x32)
# ============================================================================

def generate_moon_tear(img, draw, size):
    """Glowing teardrop"""
    cx, cy = size // 2, size // 2
    # Outer glow
    draw.ellipse([cx-8, cy-6, cx+8, cy+10], fill=PALETTE['moon_tear_glow'] + (100,))
    # Main tear shape
    draw.polygon([(cx, cy-8), (cx-6, cy+2), (cx, cy+8), (cx+6, cy+2)],
                 fill=PALETTE['moon_tear'] + (255,))
    # Inner highlight
    draw.ellipse([cx-3, cy-4, cx+1, cy], fill=PALETTE['moon_tear_glow'] + (200,))

def generate_sacred_earth(img, draw, size):
    """Enchanted soil with golden specks"""
    cx, cy = size // 2, size // 2
    # Earth mound
    draw.ellipse([cx-10, cy-4, cx+10, cy+8], fill=PALETTE['sacred_earth'] + (255,))
    draw.ellipse([cx-8, cy-2, cx+8, cy+6], fill=(160, 100, 60, 255))
    # Golden specks
    for _ in range(8):
        x = cx + random.randint(-7, 7)
        y = cy + random.randint(-2, 5)
        img.putpixel((x, y), PALETTE['sacred_earth_glow'] + (255,))

def generate_woven_cloth(img, draw, size):
    """Rolled cloth with weave texture"""
    cx, cy = size // 2, size // 2
    # Main roll
    draw.ellipse([cx-10, cy-6, cx+10, cy+6], fill=PALETTE['woven_cloth'] + (255,))
    # Weave pattern (horizontal lines)
    for y in range(cy-4, cy+5, 2):
        for x in range(cx-8, cx+8, 2):
            img.putpixel((x, y), PALETTE['woven_cloth_dark'] + (255,))
    # End circle
    draw.ellipse([cx+6, cy-5, cx+12, cy+5], fill=PALETTE['woven_cloth_dark'] + (255,))

def generate_pharmaka_flower(img, draw, size):
    """Magical pink flower"""
    cx, cy = size // 2, size // 2
    # Petals
    for angle, (dx, dy) in enumerate([(-5, -3), (5, -3), (-6, 2), (6, 2), (0, -6)]):
        draw.ellipse([cx+dx-3, cy+dy-3, cx+dx+3, cy+dy+3],
                     fill=PALETTE['pharmaka'] + (255,))
    # Center
    draw.ellipse([cx-2, cy-2, cx+2, cy+2], fill=PALETTE['pharmaka_dark'] + (255,))
    # Stem
    for y in range(cy+4, cy+12):
        img.putpixel((cx, y), (34, 139, 34, 255))

# ============================================================================
# NPC SPRITES (64x64)
# ============================================================================

def generate_npc_sprite(size, base_color, dark_color, accent_color, filename):
    """Generate a humanoid NPC sprite"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2

    # Head
    draw.ellipse([cx-8, cy-28, cx+8, cy-12], fill=base_color + (255,))
    # Body
    draw.rectangle([cx-10, cy-12, cx+10, cy+8], fill=accent_color + (255,))
    # Legs
    draw.rectangle([cx-8, cy+8, cx-2, cy+24], fill=dark_color + (255,))
    draw.rectangle([cx+2, cy+8, cx+8, cy+24], fill=dark_color + (255,))
    # Arms
    draw.rectangle([cx-14, cy-10, cx-10, cy+4], fill=base_color + (255,))
    draw.rectangle([cx+10, cy-10, cx+14, cy+4], fill=base_color + (255,))
    # Face features
    img.putpixel((cx-3, cy-22), (0, 0, 0, 255))  # Left eye
    img.putpixel((cx+3, cy-22), (0, 0, 0, 255))  # Right eye

    output_path = os.path.join(SPRITES_DIR, filename)
    img.save(output_path)
    print(f"Created: {filename}")
    return img

def generate_all_npcs():
    """Generate all NPC sprites"""
    npcs = [
        ('npc_hermes.png', PALETTE['hermes'], PALETTE['hermes_dark'], (255, 255, 255)),
        ('npc_aeetes.png', PALETTE['aeetes'], PALETTE['aeetes_dark'], (128, 0, 128)),
        ('npc_daedalus.png', PALETTE['daedalus'], PALETTE['daedalus_dark'], (139, 90, 43)),
        ('npc_scylla.png', PALETTE['scylla_before'], PALETTE['scylla_after'], (0, 100, 100)),
        ('npc_circe.png', PALETTE['circe'], PALETTE['circe_dark'], (128, 0, 128)),
    ]
    for filename, base, dark, accent in npcs:
        generate_npc_sprite(64, base, dark, accent, filename)

# ============================================================================
# MINIGAME ASSETS
# ============================================================================

def generate_moon_tears_assets():
    """Generate moon tears minigame backgrounds"""
    # Stars background (256x144)
    stars = Image.new('RGBA', (256, 144), (10, 10, 30, 255))
    for _ in range(50):
        x, y = random.randint(0, 255), random.randint(0, 143)
        brightness = random.randint(150, 255)
        stars.putpixel((x, y), (brightness, brightness, brightness, 255))
    stars.save(os.path.join(SPRITES_DIR, 'moon_tears_stars.png'))
    print("Created: moon_tears_stars.png")

    # Moon (96x96)
    moon = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(moon)
    draw.ellipse([8, 8, 88, 88], fill=(240, 240, 210, 255))
    draw.ellipse([12, 12, 84, 84], fill=(250, 250, 230, 255))
    # Craters
    for _ in range(5):
        x, y = random.randint(20, 70), random.randint(20, 70)
        r = random.randint(3, 8)
        draw.ellipse([x-r, y-r, x+r, y+r], fill=(220, 220, 200, 255))
    moon.save(os.path.join(SPRITES_DIR, 'moon_tears_moon.png'))
    print("Created: moon_tears_moon.png")

    # Player marker (40x10)
    marker = Image.new('RGBA', (40, 10), (0, 0, 0, 0))
    draw = ImageDraw.Draw(marker)
    draw.rounded_rectangle([2, 2, 38, 8], radius=3, fill=(200, 220, 255, 255))
    marker.save(os.path.join(SPRITES_DIR, 'moon_tears_player_marker.png'))
    print("Created: moon_tears_player_marker.png")

def generate_sacred_earth_area():
    """Sacred earth digging area (128x128)"""
    img = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    # Dirt area
    draw.ellipse([10, 10, 118, 118], fill=PALETTE['dirt'] + (255,))
    draw.ellipse([20, 20, 108, 108], fill=(120, 60, 20, 255))
    # Texture
    for _ in range(30):
        x, y = random.randint(25, 103), random.randint(25, 103)
        img.putpixel((x, y), (100, 50, 15, 255))
    img.save(os.path.join(SPRITES_DIR, 'sacred_earth_digging_area.png'))
    print("Created: sacred_earth_digging_area.png")

def generate_crafting_mortar():
    """Crafting mortar (96x96)"""
    img = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    # Mortar bowl
    draw.ellipse([18, 30, 78, 80], fill=(100, 100, 100, 255))
    draw.ellipse([24, 36, 72, 70], fill=(70, 70, 70, 255))
    # Pestle
    draw.rectangle([58, 10, 68, 50], fill=(120, 120, 120, 255))
    draw.ellipse([55, 45, 71, 60], fill=(100, 100, 100, 255))
    img.save(os.path.join(SPRITES_DIR, 'crafting_mortar.png'))
    print("Created: crafting_mortar.png")

# ============================================================================
# MAIN
# ============================================================================

def generate_all_items():
    """Generate all item sprites"""
    items = [
        (generate_wheat, 'wheat.png'),
        (generate_wheat_seed, 'wheat_seed.png'),
        (generate_moly, 'moly.png'),
        (generate_moly_seed, 'moly_seed.png'),
        (generate_nightshade, 'nightshade.png'),
        (generate_nightshade_seed, 'nightshade_seed.png'),
    ]
    for func, filename in items:
        create_simple_sprite(32, func, filename)

def generate_all_potions():
    """Generate all potion sprites"""
    potions = [
        (generate_calming_draught, 'calming_draught_potion.png'),
        (generate_binding_ward, 'binding_ward_potion.png'),
        (generate_reversal_elixir, 'reversal_elixir_potion.png'),
        (generate_petrification, 'petrification_potion.png'),
    ]
    for func, filename in potions:
        create_simple_sprite(32, func, filename)

def generate_all_rewards():
    """Generate minigame reward sprites"""
    rewards = [
        (generate_moon_tear, 'moon_tear.png'),
        (generate_sacred_earth, 'sacred_earth.png'),
        (generate_woven_cloth, 'woven_cloth.png'),
        (generate_pharmaka_flower, 'pharmaka_flower.png'),
    ]
    for func, filename in rewards:
        create_simple_sprite(32, func, filename)

def generate_all_minigame_assets():
    """Generate all minigame background assets"""
    generate_moon_tears_assets()
    generate_sacred_earth_area()
    generate_crafting_mortar()

def main():
    category = sys.argv[1] if len(sys.argv) > 1 else 'all'

    print(f"=== Circe's Garden Sprite Generator ===")
    print(f"Output directory: {SPRITES_DIR}")
    print(f"Category: {category}")
    print()

    if category in ('items', 'all'):
        print("--- Generating Items ---")
        generate_all_items()
        print()

    if category in ('potions', 'all'):
        print("--- Generating Potions ---")
        generate_all_potions()
        print()

    if category in ('rewards', 'all'):
        print("--- Generating Rewards ---")
        generate_all_rewards()
        print()

    if category in ('npcs', 'all'):
        print("--- Generating NPCs ---")
        generate_all_npcs()
        print()

    if category in ('minigame', 'all'):
        print("--- Generating Minigame Assets ---")
        generate_all_minigame_assets()
        print()

    print("=== Done! ===")

if __name__ == '__main__':
    main()
