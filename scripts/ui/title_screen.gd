extends Node2D

@onready var back_music: AudioStreamPlayer2D = $BackMusic
@onready var title_fx_01: AudioStreamPlayer2D = %TitleFx01
var audio_util = preload("res://scripts/utils/audio_util.gd").new()

const FADE_DURATION = 3.0
const VOLUME_VARIATION = -60

func play_fx() -> void:
	title_fx_01.play(0.0)

func _on_button_pressed() -> void:
	audio_util.fade_out_audio(back_music, change_level)

func change_level() -> void:
	var level_01: PackedScene = preload("res://scenes/levels/level01/level_01_intro.tscn")
	get_tree().change_scene_to_packed(level_01)
