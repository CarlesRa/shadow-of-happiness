extends CanvasLayer

const CHARACTERS_NUMBER = 1
const TIMER_WAIT_TIME = 0.1
const TEXT_NEXT = "Next"
const TEXT_CLOSE = "Close"
var total_characters: int
var is_typing = false
var texts: Array[String]
var current_text_index: int = 0
@onready var timer: Timer = %TextboxTimer
@onready var button: Button = %TextboxButton
@export var textbox_value: RichTextLabel
signal close_btn_pressed

func _ready() -> void:
	textbox_value = %TextboxValue
	textbox_value.visible_characters = 0

func _process(_delta: float) -> void:
	if current_text_index >= texts.size() -1:
		button.text = TEXT_CLOSE
	else:
		button.text = TEXT_NEXT
	
func set_text_values(values: Array[String]) -> void:
	texts = values
	show_panel(current_text_index)

func show_panel(index: int) -> void:
	start_typing(texts[index])

func start_typing(text: String) -> void:
	textbox_value.visible_characters = 0
	total_characters = text.length()
	textbox_value.text = text
	while textbox_value.visible_characters < total_characters:
		textbox_value.visible_characters += CHARACTERS_NUMBER
		timer.wait_time = TIMER_WAIT_TIME
		timer.one_shot = true
		timer.start()
		await timer.timeout


func _on_button_pressed() -> void:
	if button.text == TEXT_CLOSE:
		close_btn_pressed.emit()
		self.queue_free()
		return
	current_text_index += 1
	show_panel(current_text_index)
