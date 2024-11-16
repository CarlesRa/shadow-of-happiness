extends CharacterBody2D

@export var player_detected = false
@export var is_death = false
@export var direction = -1
@export var damage: int
@export var speed: int

@export var sfx_walk: Resource
@export var sfx_attack: Resource
@export var sfx_attacked: Resource

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
	if is_death: return
	handle_direction()
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_direction() -> void:
	if player_detected or is_death: return
	if ray_cast_left.is_colliding():
		direction = 1
	if ray_cast_right.is_colliding():
		direction = -1
	velocity.x = direction * speed
	animation.flip_h = direction > 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = true
		attack()

func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = false
		walk()

func _on_animation_looped() -> void:
	if animation.animation == Consts.ANIMATION_ATTACK:
		GlobalSignals.attack_player.emit(damage)
	if animation.animation == Consts.ANIMATION_HURT and player_detected:
		attack()
	if animation.animation == Consts.ANIMATION_HURT and not player_detected:
		walk()
	if animation.animation == Consts.ANIMATION_DEATH:
		queue_free()

func take_damage(damage: float) -> void:
	attacked()
	life_bar.value -= damage
	if life_bar.value <= 0 :
		is_death = true
		die()

func walk() -> void:
	animation.play(Consts.ANIMATION_WALK)
	AudioUtil.load_sfx(audio_player, sfx_walk)
	audio_player.play()

func attack() -> void:
	animation.play(Consts.ANIMATION_ATTACK)
	AudioUtil.load_sfx(audio_player, sfx_attack)
	audio_player.play()

func attacked() -> void:
	animation.play(Consts.ANIMATION_HURT)
	AudioUtil.load_sfx(audio_player, sfx_attacked)
	audio_player.play()

func die() -> void:
	animation.play(Consts.ANIMATION_DEATH)

func enable_audio() -> void:
	audio_player.volume_db = 0

func disable_audio() -> void:
	audio_player.volume_db = -80
