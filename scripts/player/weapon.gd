extends Node
class_name Weapon

@export var fire_cooldown: float = 0.25

var cooldown_remaining: float = 0.0


func _physics_process(delta: float) -> void:
	if cooldown_remaining <= 0.0:
		return

	cooldown_remaining = maxf(cooldown_remaining - delta, 0.0)


func can_fire() -> bool:
	return cooldown_remaining <= 0.0


func start_cooldown() -> void:
	cooldown_remaining = fire_cooldown

