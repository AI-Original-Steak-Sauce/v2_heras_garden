extends Control

signal minigame_complete(success: bool, items: Array)

@onready var player_marker: ColorRect = $PlayerMarker
@onready var tears_container: Node2D = $Tears
@onready var instruction_label: Label = $InstructionLabel

var tears_caught: int = 0
var player_x: float = 0.5  # 0-1 screen position
const MOVE_SPEED: float = 0.02
const TEAR_SPEED: float = 120.0
const SPAWN_INTERVAL: float = 1.2

var _spawn_timer: float = 0.0
var _active_tears: Array[ColorRect] = []

func _ready() -> void:
	instruction_label.text = "Catch 3 moon tears"

func _process(delta: float) -> void:
	# Move player marker
	if Input.is_action_pressed("ui_left"):
		player_x = max(0.1, player_x - MOVE_SPEED)
	if Input.is_action_pressed("ui_right"):
		player_x = min(0.9, player_x + MOVE_SPEED)
	player_marker.position.x = size.x * player_x

	# Spawn tears
	_spawn_timer += delta
	if _spawn_timer >= SPAWN_INTERVAL:
		_spawn_timer = 0.0
		_spawn_tear()

	# Update tears
	for tear in _active_tears.duplicate():
		tear.position.y += TEAR_SPEED * delta
		if tear.position.y >= player_marker.position.y:
			_on_tear_reached_player(tear)
		elif tear.position.y > size.y + 20:
			tear.queue_free()
			_active_tears.erase(tear)

func _spawn_tear() -> void:
	var tear := ColorRect.new()
	tear.color = Color(0.6, 0.8, 1.0, 1.0)
	tear.custom_minimum_size = Vector2(10, 10)
	tear.position = Vector2(randf_range(size.x * 0.1, size.x * 0.9), -10)
	tears_container.add_child(tear)
	_active_tears.append(tear)

func _on_tear_reached_player(tear: ColorRect) -> void:
	var x_diff = abs(tear.position.x - player_marker.position.x)
	if Input.is_action_just_pressed("ui_accept") and x_diff <= 24:
		tears_caught += 1
		tear.queue_free()
		_active_tears.erase(tear)
		if tears_caught >= 3:
			minigame_complete.emit(true, ["moon_tear", "moon_tear", "moon_tear"])
	elif tear.position.y > player_marker.position.y + 20:
		tear.queue_free()
		_active_tears.erase(tear)
