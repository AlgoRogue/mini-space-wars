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
var _player_start_position: Vector2 = Vector2.ZERO

@onready var gameplay_root: Node2D = $GameplayRoot
@onready var player: Player = $GameplayRoot/Player
@onready var wave_manager: WaveManager = $GameplayRoot/WaveManager
@onready var start_ui: Control = $UI/StartUI
@onready var hud: HUD = $UI/HUD
@onready var result_panel: ResultPanel = $UI/ResultPanel
@onready var start_button: Button = $UI/StartUI/Content/StartButton


func _ready() -> void:
	_player_start_position = player.position

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
	start_button.grab_focus()


func _enter_playing_state() -> void:
	start_ui.visible = false
	hud.visible = true
	result_panel.visible = false
	gameplay_root.visible = true
	gameplay_root.process_mode = Node.PROCESS_MODE_INHERIT
	_update_hud_values()
	game_started.emit()


func _enter_win_state() -> void:
	start_ui.visible = false
	hud.visible = false
	result_panel.visible = true
	result_panel.show_result("You Win")
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


func _enter_game_over_state() -> void:
	start_ui.visible = false
	hud.visible = false
	result_panel.visible = true
	result_panel.show_result("Game Over")
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


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
