extends Control


const LEVEL = "res://scenes/ui/final_screen.tscn"
@onready var textbox: CanvasLayer = $TextureRect/Textbox
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text()

func set_text() -> void:
	var values: Array[String]
	values = [
		"As Marc reached the heart of the forgotten temple, the Orbe of Wisdom shimmered before him, a mesmerizing beacon of light. Its glow seemed to pulse with the promise of untold happiness. Marc’s hands trembled as he reached out to claim the treasure he had sacrificed so much to find.",
		"But as his fingers grazed the orb, a voice resonated within his mind, deep and resonant, yet familiar. 'Marc,' it said, 'the happiness you seek has never been hidden in this orb or in distant lands. It has always been within you, waiting to be recognized.'",
		"In that moment, memories surged through Marc's heart: his family’s laughter echoing in their cozy home, the warmth of the sun filtering through the forest canopy, the bonds he had forged along his journey. Tears welled up in his eyes as the truth became clear.",
		"'True happiness is not a destination,' the voice continued. 'It is found in the love of your family, the embrace of nature, and the connections you hold dear.'",
		"With a newfound clarity, Marc stepped away from the orb, its glow fading into the soft light of dawn. He began his journey home, his heart lighter than ever. The forest seemed to hum with life around him, as if sharing in his revelation.",
		"And so, Marc returned, not with a mythical artifact, but with a treasure far greater: the understanding that happiness is woven into the fabric of his everyday life, waiting to be cherished."
	]
	textbox.set_text_values(values)

func _on_textbox_close_btn_pressed() -> void:	
	AudioUtil.fade_out_audio(audio_player, change_scene, -60, 3)

func change_scene() -> void:
	var final_screen: PackedScene = preload(LEVEL)
	get_tree().change_scene_to_packed(final_screen)
