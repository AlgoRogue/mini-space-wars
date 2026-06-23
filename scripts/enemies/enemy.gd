extends Area2D
class_name Enemy

@export var vertical_speed: float = 90.0
@export var horizontal_oscillation_amount: float = 24.0
@export var horizontal_oscillation_speed: float = 2.0

var _base_x_position: float = 0.0
var _elapsed_time: float = 0.0


func _ready() -> void:
	_base_x_position = position.x


func _physics_process(delta: float) -> void:
	_elapsed_time += delta
	position.y += vertical_speed * delta
	position.x = _base_x_position + sin(_elapsed_time * horizontal_oscillation_speed) * horizontal_oscillation_amount
