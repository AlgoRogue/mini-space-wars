extends Node2D
class_name Main

signal game_started

enum GameState {
	START,
	PLAYING,
	WIN,
	GAME_OVER,
}

var current_state: GameState = GameState.START

@onready var gameplay_root: Node2D = $GameplayRoot
@onready var player: Player = $GameplayRoot/Player
@onready var wave_manager: WaveManager = $GameplayRoot/WaveManager
@onready var start_ui: Control = $UI/StartUI
@onready var hud: HUD = $UI/HUD
@onready var start_button: Button = $UI/StartUI/Content/StartButton


func _ready() -> void:
	if not start_button.pressed.is_connected(_on_start_button_pressed):
		start_button.pressed.connect(_on_start_button_pressed)

	_connect_hud_signals()
	_update_hud_values()
	set_game_state(GameState.START)


func _unhandled_input(event: InputEvent) -> void:
	if current_state != GameState.START:
		return

	if event.is_action_pressed("fire"):
		get_viewport().set_input_as_handled()
		start_game()


func start_game() -> void:
	set_game_state(GameState.PLAYING)


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
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	start_button.grab_focus()


func _enter_playing_state() -> void:
	start_ui.visible = false
	hud.visible = true
	gameplay_root.visible = true
	gameplay_root.process_mode = Node.PROCESS_MODE_INHERIT
	if wave_manager.current_wave_data == null:
		wave_manager.start_wave(0)
	_update_hud_values()
	game_started.emit()


func _enter_win_state() -> void:
	start_ui.visible = false
	hud.visible = false
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


func _enter_game_over_state() -> void:
	start_ui.visible = false
	hud.visible = false
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


func _connect_hud_signals() -> void:
	if not player.player_damaged.is_connected(hud.set_lives):
		player.player_damaged.connect(hud.set_lives)

	if not wave_manager.wave_started.is_connected(hud.set_wave):
		wave_manager.wave_started.connect(hud.set_wave)


func _update_hud_values() -> void:
	hud.set_lives(player.current_lives)
	hud.set_wave(_get_current_wave_number())


func _get_current_wave_number() -> int:
	if wave_manager.current_wave_data != null:
		return wave_manager.current_wave_data.wave_number

	return 1


func _on_start_button_pressed() -> void:
	if current_state != GameState.START:
		return

	start_game()
