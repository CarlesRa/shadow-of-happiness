extends Node2D

const LEVEL = "res://scenes/levels/level01/level_01_world.tscn"
var audio_util = preload("res://scripts/utils/audio_util.gd").new()
var scenes_util = preload("res://scripts/utils/scenes_util.gd").new()
@onready var textbox: CanvasLayer = $Textbox
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text()

func set_text() -> void:
	var values: Array[String]
	values = [
		"En un lugar de la mancha de cuyo nombre no quiero acordarme",
		"Erase una vez el hombre en la tierra prometida"
	]
	textbox.set_text_values(values)

func _on_textbox_close_btn_pressed() -> void:	
	audio_util.fade_out_audio(audio_player, change_scene)

func change_scene() -> void:
	var level_01_world: PackedScene = preload(LEVEL)
	scenes_util.change_scene(self, level_01_world)
