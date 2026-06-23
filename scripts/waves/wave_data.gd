extends Resource
class_name WaveData

@export_range(1, 3, 1) var wave_number: int = 1
@export_range(1, 20, 1) var enemy_count: int = 3
@export_range(0.1, 10.0, 0.1, "suffix:s") var enemy_fire_interval: float = 2.2
@export var spawn_area_limits: Rect2 = Rect2(48.0, 48.0, 1184.0, 144.0)
