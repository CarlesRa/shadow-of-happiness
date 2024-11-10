extends Node2D

const SPEED = 60
var consts = preload("res://scripts/consts/consts.gd").new()
var audio_util = preload("res://scripts/utils/audio_util.gd").new()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity = Vector2.ZERO
var direction = -1
var player_in_sight = false
var is_death = false
var player_position = Vector2.ZERO
var sfx_run = preload("res://audio/sfx/slime_run_sfx.wav")
var sfx_bite = preload("res://audio/sfx/slime_bite.wav")

@onready var raycast_right: RayCast2D = $RaycastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_bottom: RayCast2D = $RayCastBottom
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var audio_player: AudioStreamPlayer2D = $StreamPlayer
@onready var life_bar: ProgressBar = $LifeBar

func _ready() -> void:
	GlobalSignals.connect("player_attack", handle_damage)
	audio_util.load_sfx(audio_player, sfx_run)
	audio_player.play()

func _physics_process(delta: float) -> void:
	if is_death: return
	apply_gravity(delta)
	handle_x_direction(delta)
	
func apply_gravity(delta: float) -> void:
	ray_cast_bottom.force_raycast_update()
	if not ray_cast_bottom.is_colliding():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	position.y += velocity.y * delta
	
func handle_x_direction(delta: float) -> void:
	if player_in_sight:
		direction = sign(player_position.x - position.x)
	else:
		handle_flip_h()
		position.x += direction * SPEED * delta

func handle_flip_h():
	if raycast_right.is_colliding():
		direction = -1	
	if ray_cast_left.is_colliding():
		direction = 1
	if direction > 0:
		animated_sprite.flip_h = true
	if direction < 0:
		animated_sprite.flip_h = false
		

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		handle_flip_h()
		player_in_sight = true
		animated_sprite.play(consts.ANIMATION_ATTACK)
		audio_util.load_sfx(audio_player, sfx_bite)
		audio_player.play()
		player_position = body.position


func _on_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_sight = false
		animated_sprite.play(consts.ANIMATION_RUN)
		audio_util.load_sfx(audio_player, sfx_run)
		audio_player.play()		
		handle_flip_h()

func _on_animated_sprite_animation_looped() -> void:
	if animated_sprite.animation == consts.ANIMATION_ATTACK:
		GlobalSignals.emit_signal("attack_player", 5)
	if animated_sprite.animation == consts.ANIMATION_DEATH:
		queue_free()

func handle_damage(damage: float) -> void:
	if not player_in_sight: return
	
	if life_bar.value - damage <= 0 or life_bar.value :
		is_death = true
		life_bar.value = 0
		animated_sprite.play(consts.ANIMATION_DEATH)
	life_bar.value -= damage
