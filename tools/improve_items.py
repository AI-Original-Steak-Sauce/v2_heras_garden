#!/usr/bin/env python3
"""
Item icon improvement - potions and materials with proper outlines and shading
"""
from PIL import Image
import os

OUTLINE = (0x40, 0x40, 0x40, 0xFF)
TRANSPARENT = (0, 0, 0, 0)

def add_outline(img):
    """Add 1px #404040 outline"""
    width, height = img.size
    pixels = img.load()
    
    opaque = set()
    for y in range(height):
        for x in range(width):
            if pixels[x, y][3] > 0:
                opaque.add((x, y))
    
    outline_pixels = set()
    for x, y in opaque:
        for dx in [-1, 0, 1]:
            for dy in [-1, 0, 1]:
                if dx == 0 and dy == 0:
                    continue
                nx, ny = x + dx, y + dy
                if 0 <= nx < width and 0 <= ny < height:
                    if (nx, ny) not in opaque:
                        outline_pixels.add((nx, ny))
    
    for x, y in outline_pixels:
        pixels[x, y] = OUTLINE
    
    return img

def create_potion(color_base, color_highlight, color_shadow, name):
    """Create a potion bottle with given colors"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Bottle shape (round bottom, narrow neck)
    bottle = [
        # Row 8-9 (bottom round)
        (10, 20), (11, 20), (12, 20), (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20), (19, 20), (20, 20), (21, 20),
        (9, 19), (10, 19), (11, 19), (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19), (20, 19), (21, 19), (22, 19),
        # Row 10-14 (body)
        (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18),
        (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17),
        (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16),
        (8, 15), (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15), (23, 15),
        (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14),
        # Row 15-16 (neck)
        (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13),
        (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12),
        # Cork
        (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11),
        (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10),
    ]
    
    # Cork color
    CORK = (0xA0, 0x84, 0x6C)
    
    for x, y in bottle:
        if y <= 11:  # Cork area
            pixels[x, y] = CORK + (0xFF,)
        elif y >= 17:  # Bottom highlight
            pixels[x, y] = color_highlight + (0xFF,)
        elif x <= 10 or x >= 21:  # Sides shadow
            pixels[x, y] = color_shadow + (0xFF,)
        else:
            pixels[x, y] = color_base + (0xFF,)
    
    # Add shine/highlight
    shine = [(10, 16), (11, 16), (10, 15), (11, 15)]
    for x, y in shine:
        pixels[x, y] = (0xFF, 0xFF, 0xFF, 0xC0)  # Semi-transparent white
    
    return add_outline(img)

def create_moon_tear():
    """Create moon tear item"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Teardrop shape
    tear = [
        (15, 8), (16, 8),
        (14, 9), (15, 9), (16, 9), (17, 9),
        (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10),
        (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11),
        (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12),
        (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13),
        (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14),
        (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15),
        (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16),
        (14, 17), (15, 17), (16, 17), (17, 17),
        (14, 18), (15, 18), (16, 18), (17, 18),
        (15, 19), (16, 19),
        (15, 20), (16, 20),
    ]
    
    # Pale blue colors
    TEAR_BASE = (0x88, 0xD0, 0xE0)
    TEAR_HIGHLIGHT = (0xC0, 0xE8, 0xF0)
    TEAR_SHADOW = (0x50, 0x98, 0xC8)
    
    for x, y in tear:
        if x >= 15 and y <= 12:
            pixels[x, y] = TEAR_HIGHLIGHT + (0xFF,)
        elif x <= 13 or y >= 18:
            pixels[x, y] = TEAR_SHADOW + (0xFF,)
        else:
            pixels[x, y] = TEAR_BASE + (0xFF,)
    
    return add_outline(img)

def create_sacred_earth():
    """Create sacred earth item"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Clump of earth with glow
    earth = [
        (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18),
        (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17),
        (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16),
        (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15),
        (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14),
        (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13),
    ]
    
    # Golden earth colors
    EARTH_BASE = (0xD4, 0xA0, 0x40)
    EARTH_HIGHLIGHT = (0xF0, 0xD8, 0x70)
    EARTH_SHADOW = (0xA0, 0x80, 0x30)
    
    for x, y in earth:
        if y <= 14:
            pixels[x, y] = EARTH_HIGHLIGHT + (0xFF,)
        elif y >= 17:
            pixels[x, y] = EARTH_SHADOW + (0xFF,)
        else:
            pixels[x, y] = EARTH_BASE + (0xFF,)
    
    return add_outline(img)

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating production-quality items...")
    
    # Calming Draught (Blue)
    calming = create_potion(
        (0x50, 0x98, 0xC8),  # Base blue
        (0x88, 0xD0, 0xE0),  # Highlight
        (0x38, 0x70, 0xA0),  # Shadow
        "calming"
    )
    calming.save(os.path.join(output_dir, "calming_draught_potion.png"))
    print("  Saved: calming_draught_potion.png")
    
    # Binding Ward (Gold)
    binding = create_potion(
        (0xD4, 0xA0, 0x40),  # Base gold
        (0xF0, 0xD8, 0x70),  # Highlight
        (0xA0, 0x80, 0x30),  # Shadow
        "binding"
    )
    binding.save(os.path.join(output_dir, "binding_ward_potion.png"))
    print("  Saved: binding_ward_potion.png")
    
    # Reversal Elixir (Green)
    reversal = create_potion(
        (0x64, 0xA8, 0x38),  # Base green
        (0x88, 0xCC, 0x50),  # Highlight
        (0x4C, 0x78, 0x28),  # Shadow
        "reversal"
    )
    reversal.save(os.path.join(output_dir, "reversal_elixir_potion.png"))
    print("  Saved: reversal_elixir_potion.png")
    
    # Petrification (Gray)
    petrification = create_potion(
        (0x88, 0x88, 0x88),  # Base gray
        (0xA8, 0xA8, 0xA8),  # Highlight
        (0x60, 0x60, 0x60),  # Shadow
        "petrification"
    )
    petrification.save(os.path.join(output_dir, "petrification_potion.png"))
    print("  Saved: petrification_potion.png")
    
    # Moon Tear
    moon_tear = create_moon_tear()
    moon_tear.save(os.path.join(output_dir, "moon_tear.png"))
    print("  Saved: moon_tear.png")
    
    # Sacred Earth
    sacred_earth = create_sacred_earth()
    sacred_earth.save(os.path.join(output_dir, "sacred_earth.png"))
    print("  Saved: sacred_earth.png")
    
    print("\nDone! Item icons improved with outlines and shading.")

if __name__ == "__main__":
    main()
