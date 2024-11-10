extends ProgressBar

const COLOR_LOW = Color(1, 0, 0)
const COLOR_MEDIUM = Color(1, 0.65, 0)
const COLOR_HIGH = Color(0, 1, 0)

func _process(delta: float) -> void:
	update_color()

func update_color():
	if value < max_value * 0.33:
		self.modulate = COLOR_LOW
	elif value < max_value * 0.66:
		self.modulate = COLOR_MEDIUM
	else:
		self.modulate = COLOR_HIGH
