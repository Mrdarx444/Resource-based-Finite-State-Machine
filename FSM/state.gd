extends Resource
class_name State

signal request_transition(next_state_name: String)

func enter(owner):
	pass

func exit(owner):
	pass

func update(owner, delta: float):
	pass

func physics_update(owner, delta: float):
	pass
