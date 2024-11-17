extends "res://scripts/enemies/enemy_base.gd"

func _ready() -> void:
	animation = $SlimeAnimation
	ray_cast_left = $RayCastLeft
	ray_cast_right = $RayCastRight
	audio_player = $AudioPlayer
	life_bar = $LifeBar
	super()
