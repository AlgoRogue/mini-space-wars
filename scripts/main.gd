extends Node2D
class_name Main

signal game_started

enum GameState {
	START,
	PLAYING,
	WIN,
	GAME_OVER,
}

const MUSIC_TARGET_VOLUME_DB: float = -12.0
const MUSIC_SILENT_VOLUME_DB: float = -60.0
const MUSIC_FADE_DURATION: float = 0.6

var current_state: GameState = GameState.START
var _player_start_position: Vector2 = Vector2.ZERO
var _music_tween: Tween

@onready var gameplay_root: Node2D = $GameplayRoot
@onready var player: Player = $GameplayRoot/Player
@onready var wave_manager: WaveManager = $GameplayRoot/WaveManager
@onready var start_ui: Control = $UI/StartUI
@onready var hud: HUD = $UI/HUD
@onready var result_panel: ResultPanel = $UI/ResultPanel
@onready var start_button: Button = $UI/StartUI/Content/StartButton
@onready var title_music_player: AudioStreamPlayer = $Audio/TitleMusicPlayer
@onready var gameplay_music_player: AudioStreamPlayer = $Audio/GameplayMusicPlayer


func _ready() -> void:
	_player_start_position = player.position
	_configure_music_player(title_music_player)
	_configure_music_player(gameplay_music_player)

	if not start_button.pressed.is_connected(_on_start_button_pressed):
		start_button.pressed.connect(_on_start_button_pressed)

	_connect_hud_signals()
	_connect_result_signals()
	_update_hud_values()
	set_game_state(GameState.START)


func _unhandled_input(event: InputEvent) -> void:
	if current_state != GameState.START:
		return

	if event.is_action_pressed("fire"):
		get_viewport().set_input_as_handled()
		start_game()


func start_game() -> void:
	reset_game()


func reset_game() -> void:
	_clear_active_enemies()
	_clear_projectiles_and_effects()
	player.reset_for_new_game(_player_start_position)
	wave_manager.reset_progress()
	set_game_state(GameState.PLAYING)
	_update_hud_values()
	wave_manager.start_wave(0)


func set_game_state(next_state: GameState) -> void:
	current_state = next_state

	match current_state:
		GameState.START:
			_enter_start_state()
		GameState.PLAYING:
			_enter_playing_state()
		GameState.WIN:
			_enter_win_state()
		GameState.GAME_OVER:
			_enter_game_over_state()


func _enter_start_state() -> void:
	start_ui.visible = true
	hud.visible = false
	result_panel.visible = false
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	_transition_music(title_music_player, gameplay_music_player)
	start_button.grab_focus()


func _enter_playing_state() -> void:
	start_ui.visible = false
	hud.visible = true
	result_panel.visible = false
	gameplay_root.visible = true
	gameplay_root.process_mode = Node.PROCESS_MODE_INHERIT
	_transition_music(gameplay_music_player, title_music_player)
	_update_hud_values()
	game_started.emit()


func _enter_win_state() -> void:
	start_ui.visible = false
	hud.visible = false
	result_panel.visible = true
	result_panel.show_result("You Win")
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	_fade_out_music(gameplay_music_player)
	_stop_music_player(title_music_player)


func _enter_game_over_state() -> void:
	start_ui.visible = false
	hud.visible = false
	result_panel.visible = true
	result_panel.show_result("Game Over")
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	_fade_out_music(gameplay_music_player)
	_stop_music_player(title_music_player)


func _connect_hud_signals() -> void:
	if not player.player_damaged.is_connected(hud.set_lives):
		player.player_damaged.connect(hud.set_lives)

	if not wave_manager.wave_started.is_connected(hud.set_wave):
		wave_manager.wave_started.connect(hud.set_wave)


func _connect_result_signals() -> void:
	if not player.player_dead.is_connected(_on_player_dead):
		player.player_dead.connect(_on_player_dead)

	if not wave_manager.all_waves_cleared.is_connected(_on_all_waves_cleared):
		wave_manager.all_waves_cleared.connect(_on_all_waves_cleared)

	if not wave_manager.enemy_escaped.is_connected(_on_enemy_escaped):
		wave_manager.enemy_escaped.connect(_on_enemy_escaped)

	if not result_panel.restart_requested.is_connected(reset_game):
		result_panel.restart_requested.connect(reset_game)


func _update_hud_values() -> void:
	hud.set_lives(player.current_lives)
	hud.set_wave(_get_current_wave_number())


func _get_current_wave_number() -> int:
	if wave_manager.current_wave_data != null:
		return wave_manager.current_wave_data.wave_number

	return 1


func _clear_active_enemies() -> void:
	wave_manager.clear_active_enemies()


func _clear_projectiles_and_effects() -> void:
	_clear_projectiles_and_effects_from_node(gameplay_root)


func _clear_projectiles_and_effects_from_node(parent: Node) -> void:
	for child: Node in parent.get_children():
		_clear_projectiles_and_effects_from_node(child)

		if _is_reset_cleanup_node(child):
			parent.remove_child(child)
			child.queue_free()


func _is_reset_cleanup_node(node: Node) -> bool:
	return (
		node is PlayerProjectile
		or node is EnemyProjectile
		or node is EnemyDestructionEffect
		or node.is_in_group(&"transient_gameplay_audio")
	)


func _configure_music_player(music_player: AudioStreamPlayer) -> void:
	if music_player.stream != null:
		music_player.stream.set("loop", true)
	music_player.volume_db = MUSIC_SILENT_VOLUME_DB


func _transition_music(active_player: AudioStreamPlayer, inactive_player: AudioStreamPlayer) -> void:
	_stop_music_tween()
	_music_tween = create_tween()
	_music_tween.set_parallel(true)

	_ensure_music_playing(active_player)
	_music_tween.tween_property(active_player, "volume_db", MUSIC_TARGET_VOLUME_DB, MUSIC_FADE_DURATION)

	if inactive_player.playing:
		_music_tween.tween_property(inactive_player, "volume_db", MUSIC_SILENT_VOLUME_DB, MUSIC_FADE_DURATION)
		_music_tween.tween_callback(inactive_player.stop).set_delay(MUSIC_FADE_DURATION)


func _fade_out_music(music_player: AudioStreamPlayer) -> void:
	if not music_player.playing:
		return

	_stop_music_tween()
	_music_tween = create_tween()
	_music_tween.tween_property(music_player, "volume_db", MUSIC_SILENT_VOLUME_DB, MUSIC_FADE_DURATION)
	_music_tween.tween_callback(music_player.stop)


func _ensure_music_playing(music_player: AudioStreamPlayer) -> void:
	if music_player.playing:
		return

	music_player.volume_db = MUSIC_SILENT_VOLUME_DB
	music_player.play()


func _stop_music_player(music_player: AudioStreamPlayer) -> void:
	music_player.stop()
	music_player.volume_db = MUSIC_SILENT_VOLUME_DB


func _stop_music_tween() -> void:
	if _music_tween != null and _music_tween.is_valid():
		_music_tween.kill()


func _on_start_button_pressed() -> void:
	if current_state != GameState.START:
		return

	start_game()


func _on_player_dead() -> void:
	if current_state != GameState.PLAYING:
		return

	set_game_state(GameState.GAME_OVER)


func _on_all_waves_cleared() -> void:
	if current_state != GameState.PLAYING:
		return

	set_game_state(GameState.WIN)


func _on_enemy_escaped() -> void:
	if current_state != GameState.PLAYING:
		return

	set_game_state(GameState.GAME_OVER)
