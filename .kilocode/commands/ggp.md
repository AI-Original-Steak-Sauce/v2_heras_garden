---
description: "GDScript best practices and patterns"
---

You are now using the godot-gdscript-patterns skill from .claude/skills/ggp/SKILL.md

## GDScript Conventions

### Naming Conventions
- **Variables:** snake_case (e.g., `player_health`, `current_velocity`)
- **Functions:** snake_case (e.g., `calculate_damage()`, `update_position()`)
- **Classes/Nodes:** PascalCase (e.g., `PlayerCharacter`, `InventoryManager`)
- **Constants:** UPPER_SNAKE_CASE (e.g., `MAX_HEALTH`, `GRAVITY_VALUE`)

### Code Organization

#### File Structure
```gdscript
# 1. extends statements
extends Node2D

# 2. class_name (if needed)
class_name Player

# 3. signals
signal health_changed(new_value)

# 4. enums
enum State { IDLE, MOVING, JUMPING, FALLING }

# 5. constants
const MAX_HEALTH := 100
const MOVE_SPEED := 300.0

# 6. exported variables
@export var starting_health: int = 100
@export var move_speed: float = 300.0

# 7. public variables
var current_health: int

# 8. private variables
var _is_moving: bool = false
var _velocity: Vector2 = Vector2.ZERO

# 9. onready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# 10. lifecycle methods
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    pass

# 11. public methods
func take_damage(amount: int) -> void:
    pass

# 12. private methods
func _update_velocity() -> void:
    pass
```

## Performance Optimizations

### Variable Caching
```gdscript
# Bad: Accessing node every frame
func _process(delta: float) -> void:
    $Sprite2D.position.x += 100 * delta

# Good: Cache the node
@onready var sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
    sprite.position.x += 100 * delta
```

### Type Annotations
```gdscript
# Prefer explicit types
var health: int = 100
var speed: float = 300.0
var target: Node2D = null
```

### Signal Connections
```gdscript
# Use callable syntax (Godot 4.x)
button.pressed.connect(_on_button_pressed)

# Avoid legacy syntax
button.connect("pressed", self, "_on_button_pressed")
```

## Error Handling

```gdscript
func load_resource(path: String) -> Resource:
    var resource = load(path)
    if resource == null:
        push_error("Failed to load resource: " + path)
        return null
    return resource
```

## Common Patterns

### State Machine
```gdscript
enum State { IDLE, MOVING, JUMPING, FALLING }
var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
    match current_state:
        State.IDLE:
            handle_idle()
        State.MOVING:
            handle_moving()
        # ... etc
```

### Singleton/Autoload Usage
```gdscript
var game_manager = get_node("/root/GameManager")
game_manager.add_score(100)
```

### Group Management
```gdscript
# Add to group
add_to_group("enemies")

# Get all nodes in group
var enemies = get_tree().get_nodes_in_group("enemies")
```
