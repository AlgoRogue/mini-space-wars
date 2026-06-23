extends Node
class_name Weapon

@export var fire_cooldown: float = 0.25
@export var projectile_scene: PackedScene

var cooldown_remaining: float = 0.0


func _physics_process(delta: float) -> void:
	if cooldown_remaining <= 0.0:
		return

	cooldown_remaining = maxf(cooldown_remaining - delta, 0.0)


func can_fire() -> bool:
	return cooldown_remaining <= 0.0


func start_cooldown() -> void:
	cooldown_remaining = fire_cooldown


func reset_cooldown() -> void:
	cooldown_remaining = 0.0


func handle_fire(is_fire_pressed: bool, spawn_global_position: Vector2, projectile_parent: Node) -> void:
	if not is_fire_pressed or not can_fire():
		return

	_spawn_projectile(spawn_global_position, projectile_parent)
	start_cooldown()


func _spawn_projectile(spawn_global_position: Vector2, projectile_parent: Node) -> void:
	if projectile_scene == null:
		push_warning("Weapon cannot fire because projectile_scene is not assigned.")
		return

	if projectile_parent == null:
		push_warning("Weapon cannot fire because projectile_parent is missing.")
		return

	var projectile: Node2D = projectile_scene.instantiate() as Node2D
	if projectile == null:
		push_warning("Weapon projectile_scene must instantiate a Node2D.")
		return

	projectile_parent.add_child(projectile)
	projectile.global_position = spawn_global_position
