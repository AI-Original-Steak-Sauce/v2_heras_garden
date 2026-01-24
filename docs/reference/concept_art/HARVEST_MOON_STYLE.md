# Harvest Moon SNES Style Reference

## Sprite Specifications

| Attribute | Value |
|-----------|-------|
| Size | 16x24 pixels per frame |
| Proportions | Chibi: large head (1/3), small body (2/3) |
| Directions | 4 frames (down, left, up, right) |
| Animation | 4-frame walk cycle @ ~6-8 FPS |

## Color Palette

```
Skin:    #F8D8A0 (base), #E8C880 (shadow), #FFE8C0 (highlight)
Hair:   #FFA040 (base), #E08030 (shadow), #FFC060 (highlight)
Outlines:#404040 (dark gray - 1px thick)
```

## Pixel Art Techniques

1. **Outlines**: 1px dark gray (#404040) around all shapes
2. **Shading**: Cell shading with 2-3 shades per element
3. **No dithering**: Flat colors, implied texture through shading

## Character Design

### Face
- Dot eyes (1-2 pixels)
- Small mouth (2 pixels wide)
- Simple features (chibi style)

### Body
- Simplified shapes (rectangular torso)
- Short limbs
- No visible fingers/toes

### Hair
- Simple shapes (blocks of pixels)
- 3 shades for depth
- Direction-dependent visibility

## Source Reference

Based on: `docs/reference/concept_art/spritesheet.png`

Generated sprites will be stored in: `game/textures/sprites/`
