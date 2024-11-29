extends StaticBody2D

const orbe_touched_sfx = preload("res://audio/music/orbe_touched_sfx.mp3")

@onready var player: AudioStreamPlayer2D = $Player
@onready var level_01_player: AudioStreamPlayer = %Level01MusicPlayer
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		AudioUtil.fade_out_audio(level_01_player, play_fx, -80, 3)

func play_fx() -> void:
	player.stop()
	player.stream = orbe_touched_sfx
	player.play()
	
func _on_player_finished() -> void:
	if player.stream == orbe_touched_sfx:
		change_scene()

func change_scene() -> void:
	Engine.time_scale = 1
	var scene: PackedScene = preload("res://scenes/levels/level01/level_01_outro.tscn")
	get_tree().change_scene_to_packed(scene)
	queue_free()
