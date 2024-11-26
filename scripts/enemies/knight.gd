extends CharacterBody2D

@export var direction = -1
@export var attack_amount = 20
@export var speed: float = 60.0
@export var wait_time_to_attack = 0.5
@export var attack_delai = 1.5

var is_attacking: bool = false
var is_player_in_attack_area = false
var is_death = false
var sfx_sword: AudioStream = load("res://audio/sfx/sword_sfx.wav")
var sfx_run: AudioStream = load("res://audio/sfx/running_sfx.wav")
var start_position: Vector2
var target: Node2D = null

@onready var knight: CharacterBody2D = $"."
@onready var animation: AnimatedSprite2D = $Animation
@onready var attack_player: Area2D = $AttackPlayer
@onready var timer: Timer = $Timer
@onready var life_bar: ProgressBar = $LifeBar
@onready var player: AudioStreamPlayer2D = $Player

func _ready() -> void:
	add_to_group(Consts.GROUP_ENEMIES)
	start_position = position
	idle()

func _physics_process(delta: float) -> void:
	if is_attacking or is_death:
		velocity = Vector2.ZERO
		return
	handle_movement(delta)
	handle_direction()
	
func handle_movement(delta: float) -> void:
	if target and not is_player_in_attack_area:
		var direction_to_target = (target.global_position - global_position).normalized()
		velocity = direction_to_target * speed
		play_animation(Consts.ANIMATION_WALK)
	else:
		if not is_player_in_attack_area:
			direction = 1
			var direction_to_start = (start_position - global_position)
			if direction_to_start.length() > 1.0:
				play_animation(Consts.ANIMATION_WALK)
				velocity = direction_to_start.normalized() * speed
			else:
				direction = -1
				idle()
	move_and_slide()

func handle_direction() -> void:
	if (direction < 0): animation.flip_h = true
	else: animation.flip_h = false

func _on_detect_player_body_entered(body: Node2D) -> void:
	if is_death: return
	if not body.name == Consts.PLAYER: return
	direction = -1
	target = body
	walk(body)


func _on_detect_player_body_exited(body: Node2D) -> void:
	if is_death: return
	if body == target:
		target = null
		idle()

func _on_attack_player_body_entered(body: Node2D) -> void:
	if is_death: return
	if body.name == Consts.PLAYER:
		timer.wait_time = wait_time_to_attack
		timer.start()
		await timer.timeout
		is_player_in_attack_area = true
		attack()

func _on_attack_player_body_exited(body: Node2D) -> void:
	if is_death: return
	if body.name == Consts.PLAYER:
		is_player_in_attack_area = false

func idle() -> void:
	is_attacking = false
	velocity = Vector2.ZERO
	play_animation(Consts.ANIMATION_IDLE)

func walk(body: Node2D) -> void:
	is_attacking = false
	play_animation(Consts.ANIMATION_WALK)
	play_audio(sfx_run)

func attack() -> void:
	is_attacking = true
	play_animation(Consts.ANIMATION_ATTACK)
	play_audio(sfx_sword) 
	if is_player_in_attack_area:
		GlobalSignals.attack_player.emit(attack_amount)

func play_animation(animation_name: String) -> void:
	if not animation.animation == animation_name:
		animation.play(animation_name)

func play_audio(audio: AudioStream) -> void:
	AudioUtil.load_sfx(player, audio)
	player.play()

func _on_animation_animation_finished() -> void:
	is_attacking = false
	if animation.animation == Consts.ANIMATION_ATTACK:
		if is_player_in_attack_area:
			timer.wait_time = attack_delai
			timer.start()
			idle()
			await timer.timeout
			if not is_death:
				attack()
		else:
			walk(target)

func take_damage(amount: float, body: Node2D) -> void:
	life_bar.value -= amount
	if life_bar.value <= 0:
		die()

func die() -> void:
	is_death = true
	velocity = Vector2.ZERO
	animation.play(Consts.ANIMATION_DEATH)
	player.stop()
	timer.stop()
	knight.collision_layer = 4
	GlobalSignals.play_level01_audio.emit()
