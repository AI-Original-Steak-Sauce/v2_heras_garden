#!/usr/bin/env python3
"""
UI element improvement - quest marker, talk indicator with better visibility
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

def create_quest_marker():
    """Create an improved quest marker (golden exclamation)"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Gold colors
    GOLD = (0xF0, 0xD8, 0x40)
    GOLD_DARK = (0xD4, 0xA0, 0x40)
    
    # Exclamation mark with thicker lines
    # Top bar
    for y in range(4, 18):
        for x in range(12, 20):
            pixels[x, y] = GOLD + (0xFF,)
    
    # Dot
    for y in range(20, 26):
        for x in range(12, 20):
            pixels[x, y] = GOLD + (0xFF,)
    
    # Add some shading
    for y in range(4, 18):
        pixels[12, y] = GOLD_DARK + (0xFF,)
        pixels[13, y] = GOLD_DARK + (0xFF,)
    
    for y in range(20, 26):
        pixels[12, y] = GOLD_DARK + (0xFF,)
        pixels[13, y] = GOLD_DARK + (0xFF,)
    
    return add_outline(img)

def create_talk_indicator():
    """Create an improved talk indicator (speech bubble)"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # White bubble with blue outline
    WHITE = (0xF0, 0xF0, 0xF0)
    WHITE_DARK = (0xD0, 0xD0, 0xD0)
    
    # Bubble body (rounded rectangle)
    bubble = [
        # Top rounded
        (8, 6), (9, 6), (10, 6), (11, 6), (12, 6), (13, 6), (14, 6), (15, 6), (16, 6), (17, 6), (18, 6), (19, 6), (20, 6), (21, 6), (22, 6), (23, 6),
        (6, 7), (7, 7), (8, 7), (9, 7), (10, 7), (11, 7), (12, 7), (13, 7), (14, 7), (15, 7), (16, 7), (17, 7), (18, 7), (19, 7), (20, 7), (21, 7), (22, 7), (23, 7), (24, 7), (25, 7),
        (5, 8), (6, 8), (7, 8), (8, 8), (9, 8), (10, 8), (11, 8), (12, 8), (13, 8), (14, 8), (15, 8), (16, 8), (17, 8), (18, 8), (19, 8), (20, 8), (21, 8), (22, 8), (23, 8), (24, 8), (25, 8), (26, 8),
        # Middle full
        (4, 9), (5, 9), (6, 9), (7, 9), (8, 9), (9, 9), (10, 9), (11, 9), (12, 9), (13, 9), (14, 9), (15, 9), (16, 9), (17, 9), (18, 9), (19, 9), (20, 9), (21, 9), (22, 9), (23, 9), (24, 9), (25, 9), (26, 9), (27, 9),
        (4, 10), (5, 10), (6, 10), (7, 10), (8, 10), (9, 10), (10, 10), (11, 10), (12, 10), (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10), (19, 10), (20, 10), (21, 10), (22, 10), (23, 10), (24, 10), (25, 10), (26, 10), (27, 10),
        (4, 11), (5, 11), (6, 11), (7, 11), (8, 11), (9, 11), (10, 11), (11, 11), (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11), (19, 11), (20, 11), (21, 11), (22, 11), (23, 11), (24, 11), (25, 11), (26, 11), (27, 11),
        (4, 12), (5, 12), (6, 12), (7, 12), (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12), (21, 12), (22, 12), (23, 12), (24, 12), (25, 12), (26, 12), (27, 12),
        (4, 13), (5, 13), (6, 13), (7, 13), (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13), (21, 13), (22, 13), (23, 13), (24, 13), (25, 13), (26, 13), (27, 13),
        (4, 14), (5, 14), (6, 14), (7, 14), (8, 14), (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14), (23, 14), (24, 14), (25, 14), (26, 14), (27, 14),
        (4, 15), (5, 15), (6, 15), (7, 15), (8, 15), (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15), (23, 15), (24, 15), (25, 15), (26, 15), (27, 15),
        (4, 16), (5, 16), (6, 16), (7, 16), (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16), (24, 16), (25, 16), (26, 16), (27, 16),
        # Bottom rounded with tail
        (5, 17), (6, 17), (7, 17), (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17), (24, 17), (25, 17), (26, 17),
        (6, 18), (7, 18), (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18), (24, 18), (25, 18),
        (8, 19), (9, 19), (10, 19), (11, 19), (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19), (20, 19), (21, 19), (22, 19),
        # Tail pointing down
        (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20),
        (14, 21), (15, 21), (16, 21), (17, 21),
        (15, 22), (16, 22),
        (15, 23), (16, 23),
    ]
    
    for x, y in bubble:
        if y >= 17:  # Bottom shadow
            pixels[x, y] = WHITE_DARK + (0xFF,)
        else:
            pixels[x, y] = WHITE + (0xFF,)
    
    # Three dots inside
    dots = [(10, 11), (11, 11), (14, 11), (15, 11), (18, 11), (19, 11),
            (10, 12), (11, 12), (14, 12), (15, 12), (18, 12), (19, 12)]
    for x, y in dots:
        pixels[x, y] = (0x60, 0x60, 0x60, 0xFF)
    
    return add_outline(img)

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating improved UI elements...")
    
    quest = create_quest_marker()
    quest.save(os.path.join(output_dir, "quest_marker.png"))
    print("  Saved: quest_marker.png")
    
    talk = create_talk_indicator()
    talk.save(os.path.join(output_dir, "npc_talk_indicator.png"))
    print("  Saved: npc_talk_indicator.png")
    
    print("\nDone! UI elements improved.")

if __name__ == "__main__":
    main()
