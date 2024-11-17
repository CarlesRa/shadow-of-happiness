extends Area2D

const POTION_SFX = preload("res://audio/sfx/potion_sfx.wav")
var touched = false
var life_amount
var audio_player: AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER and not touched:
		touched = true
		visible = false
		AudioUtil.load_sfx(audio_player, POTION_SFX)
		audio_player.play()
		GlobalSignals.restore_player_health.emit(life_amount)


func _on_audio_player_finished() -> void:
	queue_free()
