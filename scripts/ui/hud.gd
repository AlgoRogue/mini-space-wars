extends Control
class_name HUD

@onready var lives_label: Label = $Panel/MarginContainer/Values/LivesLabel
@onready var wave_label: Label = $Panel/MarginContainer/Values/WaveLabel


func set_lives(lives: int) -> void:
	lives_label.text = "Lives: %d" % lives


func set_wave(wave_number: int) -> void:
	wave_label.text = "Wave: %d" % wave_number
