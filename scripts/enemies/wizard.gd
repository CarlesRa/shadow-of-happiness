extends "res://scripts/enemies/enemy_base.gd"

func _ready() -> void:
	animation = $WizardAnimation
	ray_cast_left = $RayCastLeft
	ray_cast_right = $RayCastRight
	audio_player = $AudioPlayer
	life_bar = $LifeBar
	attack_amount = 15
	speed = 60.0
	sfx_walk = preload("res://audio/sfx/slime_run_sfx.wav")
	sfx_attack = preload("res://audio/sfx/slime_bite.wav")
	sfx_attacked = preload("res://audio/sfx/enemie_attacked_01.wav")
	super()
