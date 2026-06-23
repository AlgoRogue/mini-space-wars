extends Area2D
class_name PlayerProjectile

const CLEANUP_MARGIN: float = 16.0

@export var speed: float = 700.0

var _has_hit_enemy: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	position += Vector2.UP * speed * delta

	if _is_outside_visible_area():
		queue_free()


func _is_outside_visible_area() -> bool:
	var viewport_rect: Rect2 = get_viewport_rect()
	var cleanup_rect: Rect2 = viewport_rect.grow(CLEANUP_MARGIN)

	return not cleanup_rect.has_point(global_position)


func _on_area_entered(area: Area2D) -> void:
	if _has_hit_enemy:
		return

	var enemy: Enemy = area as Enemy
	if enemy == null:
		return

	_has_hit_enemy = true
	set_deferred("monitoring", false)
	enemy.destroy()
	queue_free()
