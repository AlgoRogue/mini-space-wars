extends Area2D
class_name EnemyProjectile

const CLEANUP_MARGIN: float = 16.0
const TRAIL_FLASH_INTERVAL: float = 0.08
const TRAIL_BRIGHT_COLOR: Color = Color(1.0, 0.46, 0.24, 1.0)
const TRAIL_DIM_COLOR: Color = Color(1.0, 0.18, 0.12, 1.0)

@export var speed: float = 360.0

var _has_hit_player: bool = false
var _visual_time: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	position += Vector2.DOWN * speed * delta
	_update_visual_feedback(delta)

	if _is_outside_visible_area():
		queue_free()


func _update_visual_feedback(delta: float) -> void:
	_visual_time += delta
	var flash_step: int = int(_visual_time / TRAIL_FLASH_INTERVAL)
	if flash_step % 2 == 0:
		sprite.modulate = TRAIL_BRIGHT_COLOR
		return

	sprite.modulate = TRAIL_DIM_COLOR


func _is_outside_visible_area() -> bool:
	var viewport_rect: Rect2 = get_viewport_rect()
	var cleanup_rect: Rect2 = viewport_rect.grow(CLEANUP_MARGIN)

	return not cleanup_rect.has_point(global_position)


func _on_area_entered(area: Area2D) -> void:
	if _has_hit_player:
		return

	var player: Player = area as Player
	if player == null:
		return

	_has_hit_player = true
	set_deferred("monitoring", false)
	player.apply_damage()
	queue_free()
