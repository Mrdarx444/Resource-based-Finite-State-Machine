extends State
class_name PlayerIdle

# Debuggin:
var name: String = "Idle"

func physics_update(owner, delta: float):
	var player: Player = owner
	
	# Friction
	player.velocity.x = move_toward(
		player.velocity.x,
		0.0,
		player.friction * delta
	)
	
	# Double Jump
	player.double_jumps_left = player.extra_jumps
	
	# Move State Check
	if player.direction:
		request_transition.emit("Move")
	
	# Jump State Check
	if Input.is_action_just_pressed("Jump"):
		request_transition.emit("Jump")
