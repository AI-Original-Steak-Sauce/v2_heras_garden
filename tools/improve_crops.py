#!/usr/bin/env python3
"""
Crop sprite improvement - adds proper outlines and shading per style guide
"""
from PIL import Image
import os

# Style guide colors
OUTLINE = (0x40, 0x40, 0x40, 0xFF)
TRANSPARENT = (0, 0, 0, 0)

# Moly colors (Magical Herb)
MOLY_STEM = (0x64, 0xA8, 0x38)
MOLY_FLOWER = (0xB8, 0x90, 0xD8)
MOLY_CENTER = (0x90, 0x68, 0xB0)

# Nightshade colors (Toxic Plant)
NIGHT_STEM = (0x58, 0x78, 0x28)
NIGHT_BERRY = (0x90, 0x48, 0xB0)
NIGHT_LEAF = (0x38, 0x50, 0x18)

# Wheat colors
WHEAT_STALK = (0xC4, 0xA0, 0x40)
WHEAT_GRAIN = (0xD4, 0xA0, 0x40)
WHEAT_HIGHLIGHT = (0xF0, 0xD8, 0x70)

def add_outline(img):
    """Add 1px #404040 outline to all non-transparent pixels"""
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

def create_moly():
    """Create production-quality moly sprite"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Stem
    stem = [(15, 20), (15, 19), (15, 18), (15, 17), (15, 16), (15, 15),
            (16, 20), (16, 19), (16, 18), (16, 17), (16, 16), (16, 15),
            (15, 14), (16, 14)]
    
    # Leaves
    leaves = [(13, 17), (14, 17), (17, 17), (18, 17),
              (12, 16), (13, 16), (14, 16), (17, 16), (18, 16), (19, 16),
              (14, 15), (17, 15),
              (13, 14), (14, 14), (17, 14), (18, 14)]
    
    # Flower (star-shaped)
    flower = [(15, 10), (16, 10),
              (14, 11), (15, 11), (16, 11), (17, 11),
              (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12),
              (14, 13), (15, 13), (16, 13), (17, 13),
              (15, 14), (16, 14)]
    
    # Draw stem and leaves
    for x, y in stem:
        pixels[x, y] = MOLY_STEM + (0xFF,)
    for x, y in leaves:
        pixels[x, y] = MOLY_STEM + (0xFF,)
    
    # Draw flower with center
    for x, y in flower:
        if (x, y) in [(15, 12), (16, 12)]:
            pixels[x, y] = MOLY_CENTER + (0xFF,)  # Center
        else:
            pixels[x, y] = MOLY_FLOWER + (0xFF,)  # Petals
    
    return add_outline(img)

def create_nightshade():
    """Create production-quality nightshade sprite"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Stem
    stem = [(15, 20), (15, 19), (15, 18), (15, 17),
            (16, 20), (16, 19), (16, 18), (16, 17)]
    
    # Dark leaves
    leaves = [(13, 18), (14, 18), (17, 18), (18, 18),
              (12, 17), (13, 17), (14, 17), (17, 17), (18, 17), (19, 17),
              (13, 16), (14, 16), (17, 16), (18, 16)]
    
    # Berries (clusters)
    berries = [(14, 14), (17, 14),
               (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13),
               (14, 12), (15, 12), (16, 12), (17, 12),
               (15, 11), (16, 11)]
    
    # Draw stem and leaves
    for x, y in stem:
        pixels[x, y] = NIGHT_STEM + (0xFF,)
    for x, y in leaves:
        pixels[x, y] = NIGHT_LEAF + (0xFF,)
    
    # Draw berries
    for x, y in berries:
        pixels[x, y] = NIGHT_BERRY + (0xFF,)
    
    return add_outline(img)

def create_wheat():
    """Create production-quality wheat sprite"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Stalks
    stalks = [(14, 20), (14, 19), (14, 18), (14, 17), (14, 16), (14, 15),
              (17, 20), (17, 19), (17, 18), (17, 17), (17, 16), (17, 15),
              (15, 18), (15, 17), (15, 16),
              (16, 18), (16, 17), (16, 16)]
    
    # Grain heads
    grains = [(13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12),
              (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13),
              (14, 11), (15, 11), (16, 11), (17, 11),
              (14, 10), (15, 10), (16, 10), (17, 10),
              (14, 14), (17, 14),
              (13, 11), (18, 11)]
    
    # Draw stalks
    for x, y in stalks:
        pixels[x, y] = WHEAT_STALK + (0xFF,)
    
    # Draw grains with highlight
    for x, y in grains:
        if y <= 11:
            pixels[x, y] = WHEAT_HIGHLIGHT + (0xFF,)
        else:
            pixels[x, y] = WHEAT_GRAIN + (0xFF,)
    
    return add_outline(img)

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating production-quality crops...")
    
    moly = create_moly()
    moly.save(os.path.join(output_dir, "moly.png"))
    print(f"  Saved: moly.png")
    
    nightshade = create_nightshade()
    nightshade.save(os.path.join(output_dir, "nightshade.png"))
    print(f"  Saved: nightshade.png")
    
    wheat = create_wheat()
    wheat.save(os.path.join(output_dir, "wheat.png"))
    print(f"  Saved: wheat.png")
    
    print("\nDone! Crops improved with outlines and proper styling.")

if __name__ == "__main__":
    main()
