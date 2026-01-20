extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var speed: float = 400.0
@export var acceleration: float = 1800.0
@export var friction: float = 2100.0
@export_group("Jump")
@export var jump_velocity: float = 600.0
@export var double_jump_velocity: float = 450.0
@export var double_jump_fall_velocity: float = 50.0
@export var extra_jumps: int = 1
@export var can_jump: bool = true
@export var can_double_jump: bool = true
@export_group("Gravity")
@export var max_fall_speed: float = 2300.0

var direction: int
var double_jumps_left: int = extra_jumps

func _physics_process(delta: float) -> void:
	movement_handler(delta)
	jump_handler()
	apply_gravity(delta)
	move_and_slide()

func movement_handler(delta: float):
	direction = int(Input.get_axis("Left", "Right")) # Returns one of those {-1, 0, 1}
	if direction: # Move state
		velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	else : # Idle State
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func jump_handler(): # Jump State
	# Reset Double jump on floor (Idle state)
	if is_on_floor():
		double_jumps_left = extra_jumps

	if Input.is_action_just_pressed("Jump"):
		# Simple Jump
		if is_on_floor() and can_jump:
			velocity.y = -jump_velocity
		# Double Jump
		elif can_double_jump and double_jumps_left and velocity.y > double_jump_fall_velocity:
			velocity.y = -double_jump_velocity
			double_jumps_left -= 1
	
	# Jump Release
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = 0

func apply_gravity(delta: float):
	if !is_on_floor() and velocity.y < max_fall_speed:
		velocity.y = min(velocity.y + get_gravity().y * delta, max_fall_speed)
