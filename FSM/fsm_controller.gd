extends Node
class_name FSMController

@export var initial_state: State
@export var states: Dictionary[String, State]

var current_state: State
var fsm_owner

func _ready() -> void:
	fsm_owner = get_parent()
	change_state(initial_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(fsm_owner, delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(fsm_owner, delta)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit(fsm_owner)
		current_state.disconnect("request_transition", _on_transition_requested)
	
	current_state = new_state
	
	if current_state:
		current_state.connect("request_transition", _on_transition_requested)
		current_state.enter(fsm_owner)

func _on_transition_requested(state_name: String) -> void:
	if states.has(state_name):
		change_state(states[state_name])
