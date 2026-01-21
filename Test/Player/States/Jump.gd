extends State
class_name PlayerJump

var name: String = "Jump"
var player: Player

func enter(owner):
	player = owner
	# Simple Jump
	if player.is_on_floor():
		if player.can_jump:
			player.velocity.y = -player.jump_velocity
	# Double Jump
	else :
		player.velocity.y = -player.double_jump_velocity
		player.double_jumps_left -= 1
	

func physics_update(owner, delta: float):
	# Movement without acceleration or friction
	if player.direction:
		player.velocity.x = player.direction * player.speed
	else :
		player.velocity.x = 0
	
	# Jump Release
	if Input.is_action_just_released("Jump"):
		player.velocity.y = 0
	
	# Fall State Check:
	if player.velocity.y >= 0 and !player.is_on_floor():
		request_transition.emit("Fall")
	
	# Rare Idle State check (Bugg)
	if player.is_on_floor():
		request_transition.emit("Idle")
