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
	# Calculate Direction:
	direction = int(Input.get_axis("Left", "Right"))
	
	# Calculate Gravity:
	if !is_on_floor() and velocity.y < max_fall_speed:
		velocity.y = min(velocity.y + get_gravity().y * delta, max_fall_speed)
	
	# Movement Process:
	move_and_slide()
