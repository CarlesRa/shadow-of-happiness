extends Control


const LEVEL = "res://scenes/levels/level01/level_01_world.tscn"
@onready var textbox: CanvasLayer = $TextureRect/Textbox
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

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
	AudioUtil.fade_out_audio(audio_player, change_scene, -60, 3)

func change_scene() -> void:
	var level_01_world: PackedScene = preload(LEVEL)
	get_tree().change_scene_to_packed(level_01_world)
