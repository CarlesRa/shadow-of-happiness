extends CharacterBody2D

@export var direction = -1
@export var attack_amount = 20
@export var speed: float = 60.0

var start_position: Vector2
var target: Node2D = null
var is_attacking: bool = false
var is_player_in_attack_area = false
var is_death = false

@onready var knight: CharacterBody2D = $"."
@onready var animation: AnimatedSprite2D = $Animation
@onready var attack_player: Area2D = $AttackPlayer
@onready var timer: Timer = $Timer
@onready var life_bar: ProgressBar = $LifeBar

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
		if not animation.animation == Consts.ANIMATION_WALK:
			animation.play(Consts.ANIMATION_WALK)
	else:
		if not is_player_in_attack_area:
			direction = 1
			var direction_to_start = (start_position - global_position)
			if direction_to_start.length() > 1.0:
				if not animation.animation == Consts.ANIMATION_WALK:
					animation.play(Consts.ANIMATION_WALK)
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
		is_player_in_attack_area = true		
		attack()

func _on_attack_player_body_exited(body: Node2D) -> void:
	if is_death: return
	if body.name == Consts.PLAYER:
		is_player_in_attack_area = false

func idle() -> void:
	is_attacking = false
	velocity = Vector2.ZERO
	animation.play(Consts.ANIMATION_IDLE)

func walk(body: Node2D) -> void:
	is_attacking = false
	animation.play(Consts.ANIMATION_WALK)

func attack() -> void:
	is_attacking = true
	animation.play(Consts.ANIMATION_ATTACK)    
	if is_player_in_attack_area:
		GlobalSignals.attack_player.emit(attack_amount)

func _on_animation_animation_finished() -> void:
	is_attacking = false
	if animation.animation == Consts.ANIMATION_ATTACK:
		if is_player_in_attack_area:
			timer.start()
			idle()
			await timer.timeout
			if not is_death:
				attack()
		else:
			walk(target)

func take_damage(amount: float, body: Node2D) -> void:
	print("Enemy take damage")
	life_bar.value -= amount
	if life_bar.value <= 0:
		die()

func die() -> void:
	is_death = true
	animation.play(Consts.ANIMATION_DEATH)
	knight.collision_layer = 4
