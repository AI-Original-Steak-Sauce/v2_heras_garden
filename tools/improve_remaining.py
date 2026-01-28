#!/usr/bin/env python3
"""
Remaining asset improvements
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

def create_wheat_crop():
    """Create wheat crop (harvested bundle)"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Wheat bundle
    WHEAT = (0xD4, 0xA0, 0x40)
    WHEAT_DARK = (0xB0, 0x80, 0x30)
    
    # Bundle of wheat
    bundle = [
        # Tied center
        (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20),
        (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19),
        # Stalks fanning out
        (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18),
        (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17),
        (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16),
        (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15),
        (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14),
        # Grain heads
        (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13), (21, 13), (22, 13), (23, 13),
        (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12), (21, 12), (22, 12), (23, 12),
        (9, 11), (10, 11), (11, 11), (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11), (19, 11), (20, 11), (21, 11), (22, 11),
        (10, 10), (11, 10), (12, 10), (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10), (19, 10), (20, 10), (21, 10),
        (11, 9), (12, 9), (13, 9), (14, 9), (15, 9), (16, 9), (17, 9), (18, 9), (19, 9), (20, 9),
        (13, 8), (14, 8), (15, 8), (16, 8), (17, 8), (18, 8),
    ]
    
    for x, y in bundle:
        if y <= 12:  # Top highlight
            pixels[x, y] = (0xF0, 0xD8, 0x70, 0xFF)
        elif y >= 18:  # Bottom shadow
            pixels[x, y] = WHEAT_DARK + (0xFF,)
        else:
            pixels[x, y] = WHEAT + (0xFF,)
    
    return add_outline(img)

def create_digging_area():
    """Create sacred earth digging area"""
    img = Image.new('RGBA', (64, 32), TRANSPARENT)
    pixels = img.load()
    
    # Golden earth colors
    EARTH_LIGHT = (0xE8, 0xC8, 0x60)
    EARTH_BASE = (0xD4, 0xA0, 0x40)
    EARTH_DARK = (0xA0, 0x80, 0x30)
    
    # Digging spot (irregular patch)
    for x in range(64):
        for y in range(32):
            # Create irregular shape
            dist_from_center = abs(x - 32) / 32.0 + abs(y - 16) / 16.0
            if dist_from_center < 1.0:
                if dist_from_center < 0.5:
                    pixels[x, y] = EARTH_LIGHT + (0xFF,)
                elif dist_from_center < 0.8:
                    pixels[x, y] = EARTH_BASE + (0xFF,)
                else:
                    pixels[x, y] = EARTH_DARK + (0xFF,)
    
    return img

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating remaining improved assets...")
    
    wheat_crop = create_wheat_crop()
    wheat_crop.save(os.path.join(output_dir, "wheat_crop.png"))
    print("  Saved: wheat_crop.png")
    
    digging = create_digging_area()
    digging.save(os.path.join(output_dir, "sacred_earth_digging_area.png"))
    print("  Saved: sacred_earth_digging_area.png")
    
    print("\nDone! Remaining assets improved.")

if __name__ == "__main__":
    main()
