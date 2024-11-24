extends StaticBody2D

@onready var player: AudioStreamPlayer2D = $Player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		AudioUtil.fade_out_audio(player, change_scene, -60, 3)

func change_scene() -> void:
	var scene: PackedScene = preload("res://scenes/levels/level01/level_01_outro.tscn")
	get_tree().change_scene_to_packed(scene)
	queue_free()
