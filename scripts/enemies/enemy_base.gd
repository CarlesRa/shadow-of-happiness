extends CharacterBody2D

@export var flaying_enemy: bool = false
@export var direction = -1
@export var attack_amount: float
@export var points_amount: int
@export var speed: float
@export var sfx_walk: Resource
@export var sfx_attack: Resource
@export var sfx_attacked: Resource

var player_detected = false
var is_death = false
var direction_aux: int
var animation: AnimatedSprite2D
var ray_cast_left: RayCast2D
var ray_cast_right: RayCast2D
var audio_player: AudioStreamPlayer2D
var life_bar: ProgressBar

func _ready() -> void:
	add_to_group(Consts.GROUP_ENEMIES)
	walk()

func _physics_process(delta: float) -> void:	
	handle_gravity(delta)
	handle_direction()
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor() and not flaying_enemy:
		velocity += get_gravity() * delta

func handle_direction() -> void:
	if player_detected or is_death: return
	if ray_cast_left.is_colliding():
		direction = 1
	if ray_cast_right.is_colliding():
		direction = -1
	velocity.x = direction * speed
	animation.flip_h = direction > 0

func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = true
		attack()

func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = false
		walk()

func _on_animation_looped() -> void:
	if animation.animation == Consts.ANIMATION_DEATH:
		queue_free()

func _on_animation_finished() -> void:
	if animation.animation == Consts.ANIMATION_HURT:
		handle_animation_by_player_detected()
	if animation.animation == Consts.ANIMATION_ATTACK:
		handle_animation_by_player_detected()
		if player_detected: 
			GlobalSignals.attack_player.emit(attack_amount)

func handle_animation_by_player_detected() -> void:
	if player_detected: attack()
	else: walk()

func take_damage(amount: float) -> void:
	life_bar.value -= amount
	attacked()
	if life_bar.value <= 0 and not is_death:
		speed = 0
		is_death = true
		die()

func walk() -> void:
	if is_death: return
	if animation.flip_h: direction = 1
	else: direction = -1
	animation.play(Consts.ANIMATION_WALK)
	AudioUtil.load_sfx(audio_player, sfx_walk)
	audio_player.play()

func attack() -> void:
	if is_death: return
	direction = 0
	animation.play(Consts.ANIMATION_ATTACK)
	AudioUtil.load_sfx(audio_player, sfx_attack)
	audio_player.play()	

func attacked() -> void:
	if is_death: return	
	animation.play(Consts.ANIMATION_HURT)
	AudioUtil.load_sfx(audio_player, sfx_attacked)
	audio_player.play()

func die() -> void:
	animation.play(Consts.ANIMATION_DEATH)
	GlobalSignals.incrase_points.emit(points_amount)

func enable_audio() -> void:
	audio_player.volume_db = 0

func disable_audio() -> void:
	audio_player.volume_db = -80
