extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const START_POSITION = Vector2()

var is_attacking: bool = false
var is_attacked: bool = false
var sfx_sword: AudioStream = load("res://audio/sfx/sword_sfx.wav")
var sfx_run: AudioStream = load("res://audio/sfx/running_sfx.wav")
var audio_util = preload("res://scripts/utils/audio_util.gd").new()
var footstep_frames: Array = [0, 2, 4, 6]

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var life_bar: ProgressBar = $LifeBar
@onready var attack_collision_right: CollisionShape2D = %AttackCollisionRight

func _ready() -> void:
	GlobalSignals.connect("attack_player", handle_damage)
	GlobalSignals.connect("restore_player_health", handle_health)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle attack
	if Input.is_action_just_pressed(Consts.ANIMATION_ATTACK):
		is_attacking = true
		attack_collision_right.disabled = false
		audio_util.load_sfx(audio_player, sfx_sword)
		audio_player.play()

	# Handle jump.
	if Input.is_action_just_pressed(Consts.ANIMATION_JUMP) and is_on_floor():
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
			if direction == 0 and not is_attacked:
				animated_sprite.play(Consts.ANIMATION_IDLE)
			elif not is_attacked:
				animated_sprite.play(Consts.ANIMATION_RUN)
		else:
			animated_sprite.play(Consts.ANIMATION_JUMP)
			
	if is_attacking:
			animated_sprite.play(Consts.ANIMATION_ATTACK)

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == Consts.ANIMATION_ATTACK:
		is_attacking = false
		attack_collision_right.disabled = true
		animated_sprite.play(Consts.ANIMATION_IDLE)		
	if animated_sprite.animation == Consts.ANIMATION_HURT:
		is_attacked = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if (animated_sprite.animation == Consts.ANIMATION_IDLE): return
	if (animated_sprite.animation == Consts.ANIMATION_JUMP): return
	if (animated_sprite.animation == Consts.ANIMATION_ATTACK): return
	audio_util.load_sfx(audio_player, sfx_run)
	if animated_sprite.frame in footstep_frames:
		audio_player.play()

func handle_damage(damage: float) -> void:
	if life_bar.value - damage <= 0:
		die()
		return
	animated_sprite.play(Consts.ANIMATION_HURT)
	is_attacked = true
	life_bar.value -= damage

func die():
	life_bar.value = 0
	Engine.time_scale = 0.2
	get_node("PlayerCollision").queue_free()
	audio_util.fade_out_audio(audio_player, reload_scene,-200, 1)

func handle_health(health: float) -> void:
	if life_bar.value + health > 100:
		life_bar.value = 100
		return
	life_bar.value += health

func reload_scene() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_attack_area_right_body_entered(body: Node2D) -> void:
	if body.is_in_group(Consts.GROUP_ENEMIES) and is_attacking:
		body.handle_damage(PlayerConfig.force)
