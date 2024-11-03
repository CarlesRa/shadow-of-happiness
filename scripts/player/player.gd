extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const ANIMATION_IDLE = "idle"
const ANIMATION_ATTACK = "attack"
const ANIMATION_RUN = "run"
const ANIMATION_JUMP = "jump"
var is_attacking: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play(ANIMATION_IDLE)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle attack
	if Input.is_action_just_pressed(ANIMATION_ATTACK):
		is_attacking = true		

	# Handle jump.
	if Input.is_action_just_pressed(ANIMATION_JUMP) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
		# Flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Play animations
	if not is_attacking:		
		if is_on_floor():
			if direction == 0:			
				animated_sprite_2d.play(ANIMATION_IDLE)
			else:			
				animated_sprite_2d.play(ANIMATION_RUN)
		else:
			animated_sprite_2d.play(ANIMATION_JUMP)
			
	if is_attacking:
			animated_sprite_2d.play(ANIMATION_ATTACK)

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == ANIMATION_ATTACK:
		is_attacking = false
		animated_sprite_2d.play(ANIMATION_IDLE)
