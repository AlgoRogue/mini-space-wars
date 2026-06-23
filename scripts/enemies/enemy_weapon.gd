extends Node2D
class_name EnemyWeapon

@export var fire_interval: float = 1.5
@export var projectile_scene: PackedScene

var _time_until_fire: float = 0.0

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint


func _ready() -> void:
	_time_until_fire = fire_interval


func _physics_process(delta: float) -> void:
	_time_until_fire -= delta
	if _time_until_fire > 0.0:
		return

	_fire_projectile()
	_time_until_fire = fire_interval


func _fire_projectile() -> void:
	if projectile_scene == null:
		return

	var projectile: Node2D = projectile_scene.instantiate() as Node2D
	if projectile == null:
		return

	_get_projectile_parent().add_child(projectile)
	projectile.global_position = projectile_spawn_point.global_position


func _get_projectile_parent() -> Node:
	var enemy_node: Node = get_parent()
	if enemy_node != null and enemy_node.get_parent() != null:
		return enemy_node.get_parent()

	return get_tree().root
