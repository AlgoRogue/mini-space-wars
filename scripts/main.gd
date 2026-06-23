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
@onready var start_ui: Control = $UI/StartUI
@onready var start_button: Button = $UI/StartUI/Content/StartButton


func _ready() -> void:
	if not start_button.pressed.is_connected(_on_start_button_pressed):
		start_button.pressed.connect(_on_start_button_pressed)

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
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	start_button.grab_focus()


func _enter_playing_state() -> void:
	start_ui.visible = false
	gameplay_root.visible = true
	gameplay_root.process_mode = Node.PROCESS_MODE_INHERIT
	game_started.emit()


func _enter_win_state() -> void:
	start_ui.visible = false
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


func _enter_game_over_state() -> void:
	start_ui.visible = false
	gameplay_root.visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED


func _on_start_button_pressed() -> void:
	if current_state != GameState.START:
		return

	start_game()
