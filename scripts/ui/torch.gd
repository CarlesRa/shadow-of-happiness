extends Area2D

@export var is_last_torch = false

const TORCH_COLOR_INACTIVE = Color(0.4, 0.4, 0.4, 0.8)
const TORCH_COLOR_ACTIVE = Color(1, 1, 1, 1)
var is_sound_played = false

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

func _ready() -> void:
	animated_sprite_2d.modulate = TORCH_COLOR_INACTIVE	

func _on_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		animated_sprite_2d.modulate = TORCH_COLOR_ACTIVE
		animated_sprite_2d.play(Consts.ANIMATION_IDLE)
		Vars.player_points_initial_value = Vars.player_points
		Vars.player_position = body.position
		if is_sound_played: return
		is_sound_played = true
		if (is_last_torch):
			GlobalSignals.play_final_level01_audio.emit()
			return
		audio_stream_player_2d.play()
