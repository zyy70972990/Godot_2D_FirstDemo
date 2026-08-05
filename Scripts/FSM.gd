extends Node
class_name FSM

signal on_state_transitioned(state_name: String)

@export var Initial_state: NodePath
var curr_state: State


func _ready() -> void:
	
	await owner.ready
	for state: State in get_children():
		state.fsm = self
		
	curr_state = get_node(Initial_state)
	curr_state.enter_state()


func _transition_to(state_name: String) ->void:
	if not has_node(state_name):
		return
	
	print("current state : ",curr_state.name)
	curr_state.exit_state()	
	curr_state = get_node(state_name)
	print("next state : ",curr_state.name)
	curr_state.enter_state()
	
	

	on_state_transitioned.emit(curr_state.name)
	
