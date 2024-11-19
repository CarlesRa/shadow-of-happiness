extends Node2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	Vars.player_points = Vars.player_points_initial_value
	#player.position = Vars.player_position
	var interface = preload("res://scenes/ui/interface.tscn").instantiate()
	add_child(interface)
