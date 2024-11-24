extends StaticBody2D

@export var points_to_end_level: int

var sound_played = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	label.text = str(points_to_end_level) + " Points"	


func _on_detect_player_body_entered(body: Node2D) -> void:
	if not body.name == Consts.PLAYER: return
	if Vars.player_points >= points_to_end_level and not sound_played:
		sound_played = true
		audio_stream_player.play()
		label.visible = false
		change_to_gold()

func change_to_gold() -> void:	
	sprite.modulate = Color(0.75, 0.75, 1, 1)

func _on_audio_stream_player_finished() -> void:
	animation_player.play(Consts.ANIMATION_FADE_OUT)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
