extends Area2D
class_name Player

signal player_damaged(remaining_lives: int)
signal player_dead

const DAMAGE_BLINK_DURATION: float = 0.24
const DAMAGE_BLINK_INTERVAL: float = 0.06
const INVULNERABILITY_FLASH_INTERVAL: float = 0.12
const DAMAGE_BLINK_COLOR: Color = Color(1.0, 0.25, 0.25, 1.0)
const INVULNERABILITY_FLASH_COLOR: Color = Color(0.45, 0.9, 1.0, 0.62)

@export var max_speed: float = 320.0
@export var acceleration: float = 1800.0
@export var deceleration: float = 2200.0
@export var starting_lives: int = 3
@export var invulnerability_duration: float = 1.5

var velocity: Vector2 = Vector2.ZERO
var current_lives: int = 0
var _invulnerability_remaining: float = 0.0
var _damage_blink_remaining: float = 0.0
var _is_dead: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon: Weapon = $Weapon
@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint
@onready var damage_sound_player: AudioStreamPlayer = get_node_or_null("DamageSoundPlayer") as AudioStreamPlayer


func _ready() -> void:
	current_lives = starting_lives


func reset_for_new_game(start_position: Vector2) -> void:
	position = start_position
	velocity = Vector2.ZERO
	current_lives = starting_lives
	_invulnerability_remaining = 0.0
	_damage_blink_remaining = 0.0
	_is_dead = false
	_reset_visual_feedback()
	_stop_damage_sound()
	weapon.reset_cooldown()


func _physics_process(delta: float) -> void:
	_update_invulnerability(delta)
	_update_damage_blink(delta)
	var input_direction: Vector2 = _get_input_direction()
	_update_velocity(input_direction, delta)
	position += velocity * delta
	_clamp_to_viewport()
	_handle_fire_input()
	_update_visual_feedback()


func apply_damage(amount: int = 1) -> bool:
	if amount <= 0 or is_invulnerable() or current_lives <= 0:
		return false

	current_lives = maxi(current_lives - amount, 0)
	_invulnerability_remaining = invulnerability_duration
	_damage_blink_remaining = DAMAGE_BLINK_DURATION
	_play_damage_sound()
	player_damaged.emit(current_lives)

	if current_lives == 0 and not _is_dead:
		_is_dead = true
		player_dead.emit()

	return true


func is_invulnerable() -> bool:
	return _invulnerability_remaining > 0.0


func _update_invulnerability(delta: float) -> void:
	if _invulnerability_remaining <= 0.0:
		return

	_invulnerability_remaining = maxf(_invulnerability_remaining - delta, 0.0)


func _update_damage_blink(delta: float) -> void:
	if _damage_blink_remaining <= 0.0:
		return

	_damage_blink_remaining = maxf(_damage_blink_remaining - delta, 0.0)


func _update_visual_feedback() -> void:
	sprite.visible = true

	if _damage_blink_remaining > 0.0:
		_apply_damage_blink_visual()
		return

	if is_invulnerable():
		_apply_invulnerability_visual()
		return

	_reset_visual_feedback()


func _apply_damage_blink_visual() -> void:
	var elapsed_blink: float = DAMAGE_BLINK_DURATION - _damage_blink_remaining
	var flash_step: int = int(elapsed_blink / DAMAGE_BLINK_INTERVAL)
	if flash_step % 2 == 0:
		sprite.modulate = DAMAGE_BLINK_COLOR
		return

	sprite.modulate = Color.WHITE


func _apply_invulnerability_visual() -> void:
	var elapsed_invulnerability: float = invulnerability_duration - _invulnerability_remaining
	var flash_step: int = int(elapsed_invulnerability / INVULNERABILITY_FLASH_INTERVAL)
	if flash_step % 2 == 0:
		sprite.modulate = INVULNERABILITY_FLASH_COLOR
		return

	sprite.modulate = Color.WHITE


func _reset_visual_feedback() -> void:
	sprite.visible = true
	sprite.modulate = Color.WHITE


func _play_damage_sound() -> void:
	if damage_sound_player == null or damage_sound_player.stream == null:
		return

	damage_sound_player.play()


func _stop_damage_sound() -> void:
	if damage_sound_player == null:
		return

	damage_sound_player.stop()


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


func _handle_fire_input() -> void:
	weapon.handle_fire(
		Input.is_action_pressed("fire"),
		projectile_spawn_point.global_position,
		_get_projectile_parent()
	)


func _get_projectile_parent() -> Node:
	var parent_node: Node = get_parent()
	if parent_node != null:
		return parent_node

	return get_tree().root
