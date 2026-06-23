extends Node2D
class_name WaveManager

const MAX_SPAWN_ATTEMPTS := 12

@export var enemy_scene: PackedScene = preload("res://scenes/enemies/Enemy.tscn")
@export var wave_1_data: WaveData = preload("res://resources/waves/wave_1.tres")
@export var wave_2_data: WaveData = preload("res://resources/waves/wave_2.tres")
@export var wave_3_data: WaveData = preload("res://resources/waves/wave_3.tres")
@export var minimum_spawn_distance: float = 72.0

var current_wave_data: WaveData

var _random_number_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var _spawned_enemies: Array[Enemy] = []
var _spawned_positions: Array[Vector2] = []


func _ready() -> void:
	_random_number_generator.randomize()


func start_wave(wave_index: int) -> bool:
	var wave_data: WaveData = _get_wave_data(wave_index)
	if wave_data == null:
		return false

	current_wave_data = wave_data
	_clear_spawned_enemies()

	for enemy_index: int in range(wave_data.enemy_count):
		_spawn_enemy(wave_data)

	return true


func _get_wave_data(wave_index: int) -> WaveData:
	match wave_index:
		0:
			return wave_1_data
		1:
			return wave_2_data
		2:
			return wave_3_data
		_:
			return null


func _spawn_enemy(wave_data: WaveData) -> void:
	if enemy_scene == null:
		return

	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	if enemy == null:
		return

	enemy.position = _get_spawn_position(wave_data.spawn_area_limits)
	_configure_enemy_weapon(enemy, wave_data.enemy_fire_interval)
	add_child(enemy)
	_spawned_enemies.append(enemy)
	_spawned_positions.append(enemy.position)


func _configure_enemy_weapon(enemy: Enemy, fire_interval: float) -> void:
	var enemy_weapon: EnemyWeapon = enemy.get_node_or_null("EnemyWeapon") as EnemyWeapon
	if enemy_weapon == null:
		return

	enemy_weapon.fire_interval = fire_interval


func _get_spawn_position(spawn_area_limits: Rect2) -> Vector2:
	var best_position: Vector2 = _get_random_position(spawn_area_limits)
	var best_distance: float = _get_closest_spawn_distance(best_position)

	for attempt_index: int in range(MAX_SPAWN_ATTEMPTS):
		var candidate_position: Vector2 = _get_random_position(spawn_area_limits)
		var candidate_distance: float = _get_closest_spawn_distance(candidate_position)

		if candidate_distance >= minimum_spawn_distance:
			return candidate_position

		if candidate_distance > best_distance:
			best_position = candidate_position
			best_distance = candidate_distance

	return best_position


func _get_random_position(spawn_area_limits: Rect2) -> Vector2:
	return Vector2(
		_random_number_generator.randf_range(spawn_area_limits.position.x, spawn_area_limits.end.x),
		_random_number_generator.randf_range(spawn_area_limits.position.y, spawn_area_limits.end.y)
	)


func _get_closest_spawn_distance(spawn_position: Vector2) -> float:
	if _spawned_positions.is_empty():
		return INF

	var closest_distance: float = INF
	for existing_position: Vector2 in _spawned_positions:
		var distance: float = spawn_position.distance_to(existing_position)
		if distance < closest_distance:
			closest_distance = distance

	return closest_distance


func _clear_spawned_enemies() -> void:
	for enemy: Enemy in _spawned_enemies:
		if is_instance_valid(enemy):
			remove_child(enemy)
			enemy.queue_free()

	_spawned_enemies.clear()
	_spawned_positions.clear()
