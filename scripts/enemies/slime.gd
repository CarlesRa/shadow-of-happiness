extends CharacterBody2D
@export var damage = 10
const SPEED = 60.0
var player_detected = false
var is_death = false
var direction = -1

var sfx_walk = preload("res://audio/sfx/slime_run_sfx.wav")
var sfx_bite = preload("res://audio/sfx/slime_bite.wav")
var sfx_attacked = preload("res://audio/sfx/enemie_attacked_01.wav")

@onready var slime_animation: AnimatedSprite2D = $SlimeAnimation
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var life_bar: ProgressBar = $LifeBar

func _ready() -> void:
	add_to_group(Consts.GROUP_ENEMIES)
	walk()

func _physics_process(delta: float) -> void:	
	handle_gravity(delta)
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
	velocity.x = direction * SPEED
	slime_animation.flip_h = direction > 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = true
		attack()

func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if body.name == Consts.PLAYER:
		player_detected = false
		walk()

func _on_slime_animation_animation_looped() -> void:
	if slime_animation.animation == Consts.ANIMATION_ATTACK:
		GlobalSignals.attack_player.emit(damage)
	if slime_animation.animation == Consts.ANIMATION_HURT and player_detected:
		attack()
	if slime_animation.animation == Consts.ANIMATION_HURT and not player_detected:
		walk()
	if slime_animation.animation == Consts.ANIMATION_DEATH:
		queue_free()

func take_damage(damage: float) -> void:
	attacked()
	life_bar.value -= damage
	if life_bar.value <= 0 :
		is_death = true
		die()

func walk() -> void:
	slime_animation.play(Consts.ANIMATION_WALK)
	AudioUtil.load_sfx(audio_player, sfx_walk)
	audio_player.play()

func attack() -> void:
	slime_animation.play(Consts.ANIMATION_ATTACK)
	AudioUtil.load_sfx(audio_player, sfx_bite)
	audio_player.play()

func attacked() -> void:
	slime_animation.play(Consts.ANIMATION_HURT)
	AudioUtil.load_sfx(audio_player, sfx_attacked)
	audio_player.play()

func die() -> void:
	slime_animation.play(Consts.ANIMATION_DEATH)

func enable_audio() -> void:
	audio_player.volume_db = 0

func disable_audio() -> void:
	audio_player.volume_db = -80
