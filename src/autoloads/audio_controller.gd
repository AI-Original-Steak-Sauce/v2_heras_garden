extends Node
## AudioController - Sound effects and music management

# Audio buses
const MASTER_BUS = "Master"
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

# Music player
var _music_player: AudioStreamPlayer
var _current_track: String = ""

# SFX players (pooled)
var _sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE: int = 8

# Preloaded sounds (to be populated in Phase 4)
var _sfx_library: Dictionary = {}
var _music_library: Dictionary = {}

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	_setup_music_player()
	_setup_sfx_pool()
	print("[AudioController] Initialized")

func _setup_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = MUSIC_BUS
	add_child(_music_player)

func _setup_sfx_pool() -> void:
	for i in range(SFX_POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.name = "SFXPlayer%d" % i
		player.bus = SFX_BUS
		add_child(player)
		_sfx_players.append(player)

# ============================================
# MUSIC CONTROL
# ============================================

func play_music(track_name: String, loop: bool = true) -> void:
	if _current_track == track_name and _music_player.playing:
		return  # Already playing this track

	if _music_library.has(track_name):
		_music_player.stream = _music_library[track_name]
		_music_player.stream.loop = loop
		_music_player.play()
		_current_track = track_name
		print("[AudioController] Playing music: %s" % track_name)
	else:
		print("[AudioController] Music not found: %s" % track_name)

func stop_music() -> void:
	_music_player.stop()
	_current_track = ""
	print("[AudioController] Music stopped")

func fade_out_music(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(_music_player, "volume_db", -80, duration)
	tween.tween_callback(stop_music)

# ============================================
# SFX CONTROL
# ============================================

func play_sfx(sfx_name: String, volume_db: float = 0.0) -> void:
	if not _sfx_library.has(sfx_name):
		print("[AudioController] SFX not found: %s" % sfx_name)
		return

	var player = _get_available_sfx_player()
	if player:
		player.stream = _sfx_library[sfx_name]
		player.volume_db = volume_db
		player.play()
		print("[AudioController] Playing SFX: %s" % sfx_name)

func _get_available_sfx_player() -> AudioStreamPlayer:
	# Find first non-playing player
	for player in _sfx_players:
		if not player.playing:
			return player
	# If all busy, return first one (interrupt it)
	return _sfx_players[0]

# ============================================
# VOLUME CONTROL
# ============================================

func set_master_volume(volume: float) -> void:
	# volume: 0.0 to 1.0
	var db = linear_to_db(volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS), db)

func set_music_volume(volume: float) -> void:
	var db = linear_to_db(volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS), db)

func set_sfx_volume(volume: float) -> void:
	var db = linear_to_db(volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), db)

# ============================================
# LIBRARY MANAGEMENT
# ============================================

func register_sfx(sfx_name: String, stream: AudioStream) -> void:
	_sfx_library[sfx_name] = stream
	print("[AudioController] Registered SFX: %s" % sfx_name)

func register_music(track_name: String, stream: AudioStream) -> void:
	_music_library[track_name] = stream
	print("[AudioController] Registered music: %s" % track_name)
