extends State
class_name PlayerMove

var name: String = "Move"

func physics_update(owner, delta: float):
	var player: Player = owner
	# Movement
	if player.direction:
		player.velocity.x = move_toward(
			player.velocity.x,
			player.speed * player.direction,
			player.acceleration * delta
			)
	else: # Stop
		request_transition.emit("Idle")
	
	# Jump State Check
	if Input.is_action_just_pressed("Jump"):
		request_transition.emit("Jump")
