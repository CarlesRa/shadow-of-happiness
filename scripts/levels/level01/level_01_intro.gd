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
		"In a modest wooden house nestled deep within the forest, Marc lived a simple but content life with his family. The chirping of birds and the rustle of leaves were the soundtrack of their peaceful days. But one fateful evening, as the sun dipped below the horizon and the forest was bathed in golden hues, an enigmatic figure appeared at their door.",
		"Shrouded in a cloak that seemed to shimmer with the colors of the night, the stranger spoke in a voice that was both gentle and commanding.",
		"“Marc,” the figure began, “true happiness is a rare treasure, one that cannot be found in the comforts of the mundane. If you seek it, you must journey far and wide. One ancient artifacts, the Orbe of Wisdom hold the key. Only by finding them will you uncover the path to true joy.”",
		"Marc felt a mixture of fear and curiosity stirring within him. The words of the stranger lingered in the air, heavy with promise and mystery. His family watched in silence, their eyes filled with both worry and hope.",
		"Would Marc take the first step on this extraordinary quest?"
	]
	textbox.set_text_values(values)

func _on_textbox_close_btn_pressed() -> void:	
	AudioUtil.fade_out_audio(audio_player, change_scene, -60, 3)

func change_scene() -> void:
	var level_01_world: PackedScene = preload(LEVEL)
	get_tree().change_scene_to_packed(level_01_world)
