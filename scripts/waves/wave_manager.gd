extends Node2D
class_name WaveManager

signal wave_started(wave_number: int)
signal all_waves_cleared

const MAX_SPAWN_ATTEMPTS := 12

@export var enemy_scene: PackedScene = preload("res://scenes/enemies/Enemy.tscn")
@export var wave_1_data: WaveData = preload("res://resources/waves/wave_1.tres")
@export var wave_2_data: WaveData = preload("res://resources/waves/wave_2.tres")
@export var wave_3_data: WaveData = preload("res://resources/waves/wave_3.tres")
@export var minimum_spawn_distance: float = 72.0
@export var auto_start: bool = true

var current_wave_data: WaveData
var current_wave_index: int = -1
var remaining_enemy_count: int = 0

var _random_number_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var _spawned_enemies: Array[Enemy] = []
var _spawned_positions: Array[Vector2] = []
var _removed_enemy_instance_ids: Array[int] = []
var _all_waves_cleared_emitted: bool = false


func _ready() -> void:
	_random_number_generator.randomize()
	if auto_start:
		start_wave(0)


func start_wave(wave_index: int) -> bool:
	var wave_data: WaveData = _get_wave_data(wave_index)
	if wave_data == null:
		return false

	current_wave_data = wave_data
	current_wave_index = wave_index
	remaining_enemy_count = wave_data.enemy_count
	_removed_enemy_instance_ids.clear()
	if wave_index == 0:
		_all_waves_cleared_emitted = false
	clear_active_enemies()

	for enemy_index: int in range(wave_data.enemy_count):
		_spawn_enemy(wave_data)

	print("Wave started: %d" % wave_data.wave_number)
	wave_started.emit(wave_data.wave_number)
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
	enemy.enemy_destroyed.connect(_on_enemy_destroyed.bind(enemy))
	enemy.enemy_escaped.connect(_on_enemy_escaped.bind(enemy))
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


func reset_progress() -> void:
	clear_active_enemies()
	current_wave_data = null
	current_wave_index = -1
	remaining_enemy_count = 0
	_removed_enemy_instance_ids.clear()
	_all_waves_cleared_emitted = false


func clear_active_enemies() -> void:
	var enemies_to_clear: Array[Enemy] = []
	for enemy: Enemy in _spawned_enemies:
		if is_instance_valid(enemy):
			enemies_to_clear.append(enemy)

	for child: Node in get_children():
		var child_enemy: Enemy = child as Enemy
		if child_enemy != null and not enemies_to_clear.has(child_enemy):
			enemies_to_clear.append(child_enemy)

	for enemy: Enemy in enemies_to_clear:
		if enemy.get_parent() == self:
			remove_child(enemy)
		enemy.queue_free()

	_spawned_enemies.clear()
	_spawned_positions.clear()


func _on_enemy_destroyed(enemy: Enemy) -> void:
	_remove_enemy_from_current_wave(enemy, "Enemy destroyed")


func _on_enemy_escaped(enemy: Enemy) -> void:
	_remove_enemy_from_current_wave(enemy, "Enemy escaped")


func _remove_enemy_from_current_wave(enemy: Enemy, log_message: String) -> void:
	if enemy == null:
		return

	var enemy_instance_id: int = enemy.get_instance_id()
	if _removed_enemy_instance_ids.has(enemy_instance_id):
		return

	_removed_enemy_instance_ids.append(enemy_instance_id)
	_spawned_enemies.erase(enemy)
	if enemy.get_parent() == self:
		remove_child(enemy)

	remaining_enemy_count = max(remaining_enemy_count - 1, 0)
	print("%s: %d remaining" % [log_message, remaining_enemy_count])

	if remaining_enemy_count == 0:
		_complete_current_wave()


func _complete_current_wave() -> void:
	if current_wave_index < _get_wave_count() - 1:
		call_deferred("_start_next_wave", current_wave_index + 1)
		return

	if _all_waves_cleared_emitted:
		return

	_all_waves_cleared_emitted = true
	print("All waves cleared")
	all_waves_cleared.emit()


func _start_next_wave(wave_index: int) -> void:
	start_wave(wave_index)


func _get_wave_count() -> int:
	return 3
