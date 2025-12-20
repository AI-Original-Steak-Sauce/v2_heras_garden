extends Control

signal minigame_complete(success: bool, items: Array)

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer_label: Label = $TimerLabel

var progress: float = 0.0
var time_remaining: float = 10.0
const PROGRESS_PER_PRESS: float = 0.03
const DECAY_RATE: float = 0.01

func _process(delta: float) -> void:
	time_remaining -= delta
	progress = max(0.0, progress - DECAY_RATE * delta)
	progress_bar.value = progress * 100.0
	timer_label.text = "Time: %.1f" % max(time_remaining, 0.0)

	if progress >= 1.0:
		minigame_complete.emit(true, ["sacred_earth", "sacred_earth", "sacred_earth"])
		set_process(false)
	elif time_remaining <= 0.0:
		minigame_complete.emit(false, [])
		set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		progress += PROGRESS_PER_PRESS
