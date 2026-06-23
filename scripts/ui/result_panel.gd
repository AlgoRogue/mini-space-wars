extends Control
class_name ResultPanel

signal restart_requested

var _restart_request_emitted: bool = false

@onready var result_label: Label = $Overlay/Panel/MarginContainer/Content/ResultLabel
@onready var new_game_button: Button = $Overlay/Panel/MarginContainer/Content/NewGameButton


func _ready() -> void:
	if not new_game_button.pressed.is_connected(_on_new_game_button_pressed):
		new_game_button.pressed.connect(_on_new_game_button_pressed)


func show_result(result_text: String) -> void:
	_restart_request_emitted = false
	result_label.text = result_text
	new_game_button.disabled = false
	new_game_button.grab_focus()


func _on_new_game_button_pressed() -> void:
	if _restart_request_emitted:
		return

	_restart_request_emitted = true
	new_game_button.disabled = true
	restart_requested.emit()
