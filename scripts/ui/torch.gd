extends Area2D

const SFX_TORCH = preload("res://audio/sfx/torch_sfx.wav")
var is_sound_played = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		Vars.player_points_initial_value = Vars.player_points
		Vars.player_position = body.position
		if is_sound_played: return
		is_sound_played = true
		AudioUtil.load_sfx(audio_stream_player_2d, SFX_TORCH)
		audio_stream_player_2d.play()
