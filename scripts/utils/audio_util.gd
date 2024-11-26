extends Node

func fade_out_audio(audio: Variant, callback: Callable, variation: float, duration: int) -> void:
	var tween = audio.get_tree().create_tween()
	tween.tween_property(audio, "volume_db", variation, duration)	
	tween.tween_callback(callback)

func load_sfx(audio_player: Variant, audio_stream: AudioStream) -> void:
	if (audio_player.stream != audio_stream):
		audio_player.stop()
		audio_player.stream = audio_stream
		audio_player.play()
