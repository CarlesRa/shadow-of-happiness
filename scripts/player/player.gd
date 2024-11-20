extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -300.0
const SIGNAL_ATTACK_PLAYER = "attack_player"
var is_attacking: bool = false
var sfx_sword: AudioStream = load("res://audio/sfx/sword_sfx.wav")
var sfx_run: AudioStream = load("res://audio/sfx/running_sfx.wav")
var footstep_frames: Array = [0, 2, 4, 6]

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var life_bar: ProgressBar = $LifeBar
@onready var attack_collision_right: CollisionShape2D = %AttackCollisionRight
@onready var attack_collision_left: CollisionShape2D = $AttackAreaLeft/AttackCollisionLeft

func _ready() -> void:
	GlobalSignals.connect(Consts.S_ATTACK_PLAYER, handle_damage)
	GlobalSignals.connect(Consts.S_RESTORE_PLAYER_HEALTH, handle_health)
	life_bar.value = PlayerConfig.life
	animated_sprite.play(Consts.ANIMATION_IDLE)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)		
	handle_inputs()
		
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
				animated_sprite.play(Consts.ANIMATION_IDLE)
			else:
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

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_inputs() -> void:
	# Handle attack
	if Input.is_action_just_pressed(Consts.ANIMATION_ATTACK) and not is_attacking:
		is_attacking = true
		if animated_sprite.flip_h == true:
			attack_collision_left.disabled = false
		else:
			attack_collision_right.disabled = false
		AudioUtil.load_sfx(audio_player, sfx_sword)
		audio_player.play()

	# Handle jump.
	if Input.is_action_just_pressed(Consts.ANIMATION_JUMP) and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == Consts.ANIMATION_ATTACK:
		animated_sprite.play(Consts.ANIMATION_IDLE)
		attack_collision_right.disabled = true
		attack_collision_left.disabled = true
		is_attacking = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if (animated_sprite.animation != Consts.ANIMATION_RUN): return
	AudioUtil.load_sfx(audio_player, sfx_run)
	if animated_sprite.frame in footstep_frames:
		audio_player.play()

func handle_damage(damage: float) -> void:
	if life_bar.value - damage <= 0:
		die()
		return	
	animated_sprite.play(Consts.ANIMATION_HURT)
	life_bar.value -= damage

func die():
	life_bar.value = 0
	Engine.time_scale = 0.2
	get_node("PlayerCollision").queue_free()
	AudioUtil.fade_out_audio(audio_player, reload_scene,-200, 1)

func handle_health(health: float) -> void:
	life_bar.value += health
	if life_bar.value > PlayerConfig.life:
		life_bar.value = PlayerConfig.life
		return

func reload_scene() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_attack_area_right_body_entered(body: Node2D) -> void:
	apply_attack_area(body)
		
func _on_attack_area_left_body_entered(body: Node2D) -> void:
	apply_attack_area(body)

func apply_attack_area(body: Node2D) -> void:
	if body.is_in_group(Consts.GROUP_ENEMIES) and is_attacking:
		body.take_damage(PlayerConfig.force, self)

func _on_camera_area_body_entered(body: Node2D) -> void:
	body.enable_audio()

func _on_camera_area_body_exited(body: Node2D) -> void:
	body.disable_audio()
