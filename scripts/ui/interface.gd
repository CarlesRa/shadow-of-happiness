extends Control


@onready var pause_menu: Control = %PauseMenu
@onready var label: Label = $CanvasLayer/Sprite2D/Label

func _ready() -> void:
	GlobalSignals.connect(Consts.S_INCRASE_POINTS, incrase_points)
	set_label(Vars.player_points)



func incrase_points(amount: int) -> void:
	Vars.player_points += amount
	set_label(Vars.player_points)

func set_label(points: int) -> void:
	label.text = str(points)
