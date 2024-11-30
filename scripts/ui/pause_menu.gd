extends Control

const BUS_MASTER = "Master"

var is_paused: bool = false
var bus_index: int

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(BUS_MASTER)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toogle_pause()

func toogle_pause() -> void:
	is_paused = !is_paused
	if is_paused:
		canvas_layer.visible = true
		Engine.time_scale = 0
		AudioServer.set_bus_volume_db(bus_index, -80)
	else:
		canvas_layer.visible = false
		Engine.time_scale = 1
		AudioServer.set_bus_volume_db(bus_index, 0)
