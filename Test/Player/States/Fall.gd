extends State
class_name PlayerFall

var name: String = "Fall"

func physics_update(owner, delta: float):
	var player: Player = owner
	
	# Movement without acceleration or friction
	if player.direction:
		player.velocity.x = player.direction * player.speed
	else :
		player.velocity.x = 0
	
	# Double Jump check
	if (
		Input.is_action_just_pressed("Jump") and 
		player.can_double_jump and
		player.double_jumps_left and
		!player.is_on_floor() and
		player.velocity.y > player.double_jump_fall_velocity
		):
		request_transition.emit("Jump")
	
	# Ground Landing check (Idle State)
	if player.is_on_floor():
		request_transition.emit("Idle")
