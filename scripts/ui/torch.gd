extends Area2D

const TORCH_COLOR_INACTIVE = Color(0.2, 0.2, 0.2, 0.8)
const TORCH_COLOR_ACTIVE = Color(1, 1, 1, 1)
var is_sound_played = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:	
	animated_sprite_2d.modulate = Color(0.1, 0.1, 0.1)

func _on_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		animated_sprite_2d.modulate = TORCH_COLOR_ACTIVE
		animated_sprite_2d.play(Consts.ANIMATION_IDLE)
		Vars.player_points_initial_value = Vars.player_points
		Vars.player_position = body.position		
		if is_sound_played: return
		is_sound_played = true
		audio_stream_player_2d.play()
