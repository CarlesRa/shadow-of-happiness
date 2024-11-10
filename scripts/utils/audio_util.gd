extends Node

const FADE_DURATION = 3.0
const VOLUME_VARIATION = -60

func fade_out_audio(audio: AudioStreamPlayer2D, callback: Callable) -> void:
	var tween = audio.get_tree().create_tween()
	tween.tween_property(audio, "volume_db", VOLUME_VARIATION, FADE_DURATION)	
	tween.tween_callback(callback)

func load_sfx(audio_player: AudioStreamPlayer2D, audio_stream: AudioStream) -> void:
	if (audio_player.stream != audio_stream):
		audio_player.stop()
		audio_player.stream = audio_stream
