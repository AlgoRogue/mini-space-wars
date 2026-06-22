extends Area2D
class_name Player

@export var max_speed: float = 320.0
@export var acceleration: float = 1800.0
@export var deceleration: float = 2200.0

var velocity: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = _get_input_direction()
	_update_velocity(input_direction, delta)
	position += velocity * delta
	_clamp_to_viewport()


func _get_input_direction() -> Vector2:
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if direction.length() > 1.0:
		return direction.normalized()

	return direction


func _update_velocity(input_direction: Vector2, delta: float) -> void:
	if input_direction != Vector2.ZERO:
		var target_velocity: Vector2 = input_direction * max_speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
		return

	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)


func _clamp_to_viewport() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
	var sprite_half_size: Vector2 = _get_sprite_half_size()
	var minimum_position: Vector2 = viewport_rect.position + sprite_half_size
	var maximum_position: Vector2 = viewport_rect.position + viewport_rect.size - sprite_half_size

	position = Vector2(
		_clamp_axis(position.x, minimum_position.x, maximum_position.x),
		_clamp_axis(position.y, minimum_position.y, maximum_position.y)
	)


func _get_sprite_half_size() -> Vector2:
	if sprite == null or sprite.texture == null:
		return Vector2.ZERO

	return sprite.get_rect().size * sprite.scale.abs() * 0.5


func _clamp_axis(value: float, minimum_value: float, maximum_value: float) -> float:
	if minimum_value > maximum_value:
		return (minimum_value + maximum_value) * 0.5

	return clampf(value, minimum_value, maximum_value)
