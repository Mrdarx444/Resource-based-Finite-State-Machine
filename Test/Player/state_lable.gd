extends Label

@export var fsm: FSMController

func _process(_delta: float) -> void:
	if fsm and fsm.current_state:
		text = "State: %s"%fsm.current_state.name
	else :
		text = "No FSM or current_state"
