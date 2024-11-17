extends "res://scripts/enemies/enemy_base.gd"

func _ready() -> void:
	animation = $WizardAnimation
	ray_cast_left = $RayCastLeft
	ray_cast_right = $RayCastRight
	audio_player = $AudioPlayer
	life_bar = $LifeBar
	attack_amount = 18
	speed = 60.0
	sfx_attack = preload("res://audio/sfx/injured_sfx.wav")
	sfx_attacked = preload("res://audio/sfx/wizard_attacked_sfx.wav")
	super()
