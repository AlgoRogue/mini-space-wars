extends Area2D
class_name PlayerProjectile

const CLEANUP_MARGIN: float = 16.0

@export var speed: float = 700.0


func _physics_process(delta: float) -> void:
	position += Vector2.UP * speed * delta

	if _is_outside_visible_area():
		queue_free()


func _is_outside_visible_area() -> bool:
	var viewport_rect: Rect2 = get_viewport_rect()
	var cleanup_rect: Rect2 = viewport_rect.grow(CLEANUP_MARGIN)

	return not cleanup_rect.has_point(global_position)
