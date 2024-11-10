extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const START_POSITION = Vector2()

var is_attacking: bool = false
var sfx_sword: AudioStream = load("res://audio/sfx/sword_sfx.wav")
var sfx_run: AudioStream = load("res://audio/sfx/running_sfx.wav")
var audio_util = preload("res://scripts/utils/audio_util.gd").new()
var consts = preload("res://scripts/consts/consts.gd").new()
var footstep_frames: Array = [0, 2, 4, 6]

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var life_bar: ProgressBar = $LifeBar
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

func _ready() -> void:
	GlobalSignals.connect("attack_player", handle_damage)
	GlobalSignals.connect("restore_player_health", handle_health)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle attack
	if Input.is_action_just_pressed(consts.ANIMATION_ATTACK):
		is_attacking = true
		audio_util.load_sfx(audio_player, sfx_sword)
		audio_player.play()
		if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
			GlobalSignals.emit_signal("player_attack", 50)

	# Handle jump.
	if Input.is_action_just_pressed(consts.ANIMATION_JUMP) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
		# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play(consts.ANIMATION_IDLE)
			else:
				animated_sprite.play(consts.ANIMATION_RUN)
		else:
			animated_sprite.play(consts.ANIMATION_JUMP)
			
	if is_attacking:
			animated_sprite.play(consts.ANIMATION_ATTACK)

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == consts.ANIMATION_ATTACK:
		is_attacking = false
		animated_sprite.play(consts.ANIMATION_IDLE)

func _on_animated_sprite_2d_frame_changed() -> void:
	if (animated_sprite.animation == consts.ANIMATION_IDLE): return
	if (animated_sprite.animation == consts.ANIMATION_JUMP): return
	if (animated_sprite.animation == consts.ANIMATION_ATTACK): return
	audio_util.load_sfx(audio_player, sfx_run)
	if animated_sprite.frame in footstep_frames:
		audio_player.play()

func handle_damage(damage: float) -> void:
	if life_bar.value - damage <= 0:
		die()
		return
	animated_sprite.play(consts.ANIMATION_HURT)
	life_bar.value -= damage

func handle_health(health: float) -> void:
	if life_bar.value + health > 100:
		life_bar.value = 100
		return
	life_bar.value += health

func die():
	timer.start()
	Engine.time_scale = 0.2
	get_node("PlayerCollision").queue_free()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
