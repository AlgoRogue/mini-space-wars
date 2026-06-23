extends Node2D
class_name EnemyDestructionEffect

const EFFECT_DURATION: float = 0.28
const FLASH_INTERVAL: float = 0.07
const BRIGHT_COLOR: Color = Color(1.0, 0.95, 0.45, 1.0)
const DIM_COLOR: Color = Color(1.0, 0.35, 0.16, 0.85)

var _elapsed_time: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	_elapsed_time += delta

	if _elapsed_time >= EFFECT_DURATION:
		queue_free()
		return

	var flash_step: int = int(_elapsed_time / FLASH_INTERVAL)
	if flash_step % 2 == 0:
		sprite.modulate = BRIGHT_COLOR
		return

	sprite.modulate = DIM_COLOR
