extends Control

const SETTINGS_PATH: String = "user://settings.json"

@onready var master_slider: HSlider = $OptionsList/MasterVolume/HSlider
@onready var music_slider: HSlider = $OptionsList/MusicVolume/HSlider
@onready var sfx_slider: HSlider = $OptionsList/SFXVolume/HSlider

var options: Array[HSlider] = []
var selected_index: int = 0

func _ready() -> void:
	options = [master_slider, music_slider, sfx_slider]
	_load_settings()
	_update_selection()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_cancel()
		return

	if event.is_action_pressed("ui_down"):
		selected_index = (selected_index + 1) % options.size()
		_update_selection()
		AudioController.play_sfx("ui_move")
	elif event.is_action_pressed("ui_up"):
		selected_index = (selected_index - 1 + options.size()) % options.size()
		_update_selection()
		AudioController.play_sfx("ui_move")
	elif event.is_action_pressed("ui_left"):
		options[selected_index].value -= 10
		_apply_volume()
	elif event.is_action_pressed("ui_right"):
		options[selected_index].value += 10
		_apply_volume()
	elif event.is_action_pressed("ui_accept"):
		_save_settings()
		AudioController.play_sfx("ui_confirm")
		visible = false

func _update_selection() -> void:
	for i in range(options.size()):
		var slider = options[i]
		slider.modulate = Color.YELLOW if i == selected_index else Color.WHITE

func _apply_volume() -> void:
	AudioController.set_master_volume(master_slider.value / 100.0)
	AudioController.set_music_volume(music_slider.value / 100.0)
	AudioController.set_sfx_volume(sfx_slider.value / 100.0)

func _save_settings() -> void:
	var settings = {
		"master_volume": master_slider.value,
		"music_volume": music_slider.value,
		"sfx_volume": sfx_slider.value
	}
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings))

func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var settings = JSON.parse_string(file.get_as_text())
	if settings:
		master_slider.value = settings.get("master_volume", 100)
		music_slider.value = settings.get("music_volume", 100)
		sfx_slider.value = settings.get("sfx_volume", 100)
		_apply_volume()

func _cancel() -> void:
	_load_settings()
	visible = false

func open() -> void:
	visible = true
	selected_index = 0
	_update_selection()
