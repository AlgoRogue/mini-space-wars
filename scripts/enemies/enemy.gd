extends Area2D
class_name Enemy

signal enemy_destroyed
signal enemy_escaped

const ESCAPE_CLEANUP_MARGIN: float = 32.0

@export var vertical_speed: float = 90.0
@export var horizontal_oscillation_amount: float = 24.0
@export var horizontal_oscillation_speed: float = 2.0
@export var destruction_effect_scene: PackedScene = preload("res://scenes/enemies/EnemyDestructionEffect.tscn")

var _base_x_position: float = 0.0
var _elapsed_time: float = 0.0
var _is_destroyed: bool = false


func _ready() -> void:
	_base_x_position = position.x
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if _is_destroyed:
		return

	_elapsed_time += delta
	position.y += vertical_speed * delta
	position.x = _base_x_position + sin(_elapsed_time * horizontal_oscillation_speed) * horizontal_oscillation_amount

	if _has_escaped_visible_area():
		escape()


func destroy() -> void:
	if _is_destroyed:
		return

	_is_destroyed = true
	_spawn_destruction_effect()
	enemy_destroyed.emit()
	queue_free()


func escape() -> void:
	if _is_destroyed:
		return

	_is_destroyed = true
	enemy_escaped.emit()
	queue_free()


func _has_escaped_visible_area() -> bool:
	var viewport_rect: Rect2 = get_viewport_rect()
	return global_position.y > viewport_rect.end.y + ESCAPE_CLEANUP_MARGIN


func _on_area_entered(area: Area2D) -> void:
	var player: Player = area as Player
	if player == null:
		return

	player.apply_damage()
	destroy()


func _spawn_destruction_effect() -> void:
	if destruction_effect_scene == null:
		return

	var effect_parent: Node = get_parent()
	if effect_parent == null:
		return

	var effect: EnemyDestructionEffect = destruction_effect_scene.instantiate() as EnemyDestructionEffect
	if effect == null:
		return

	effect_parent.add_child(effect)
	effect.global_position = global_position
